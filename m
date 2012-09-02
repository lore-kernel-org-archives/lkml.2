Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2IBNl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 09:41:56 -0400
Received: from canardo.mork.no ([148.122.252.1]:60510 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab2IBNlz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 09:41:55 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        chunkeey@googlemail.com, linville@tuxdriver.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: input0: bad kobj_uevent_env content in show_uevent()
Organization: m
References: <20120902075946.GA21198@localhost>
Date: Sun, 02 Sep 2012 15:41:34 +0200
In-Reply-To: <20120902075946.GA21198@localhost> (Fengguang Wu's message of
	"Sun, 2 Sep 2012 15:59:46 +0800")
Message-ID: <87harg35kh.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:

> After the __devinit* removal series, I can still get kernel panic in
> show_uevent(). So there are more sources of bug..
>
> Debug patch:
>
> @@ -343,8 +343,11 @@ static ssize_t show_uevent(struct device
>                 goto out;
>
>         /* copy keys to file */
> -       for (i = 0; i < env->envp_idx; i++)
> +       dev_err(dev, "uevent %d env[%d]: %s/.../%s\n", env->buflen, env->envp_idx, top_kobj->name, dev->kobj.name);
> +       for (i = 0; i < env->envp_idx; i++) {
> +               printk(KERN_ERR "uevent %d env[%d]: %s\n", (int)count, i, env->envp[i]);
>                 count += sprintf(&buf[count], "%s\n", env->envp[i]);
> +       }
>
> Oops message, the env[] is again not properly initilized:
>
> [   44.068623] input input0: uevent 61 env[805306368]: input0/.../input0
> [   44.069552] uevent 0 env[0]: (null)

This is a completely different CONFIG_HOTPLUG problem, only
demonstrating another reason why CONFIG_HOTPLUG should go away.  I had a
hard time trying to disable it anyway ;-)

The problem this time is lots of code assuming that a call to
add_uevent_var() will guarantee that env->buflen > 0.  This is not true
if CONFIG_HOTPLUG is unset.  So things like this end up overwriting
env->envp_idx because the array index is -1:

	if (add_uevent_var(env, "MODALIAS="))
		return -ENOMEM;
        len = input_print_modalias(&env->buf[env->buflen - 1],
				   sizeof(env->buf) - env->buflen,
				   dev, 0);


Don't know what the best action is, given that there seem to be a *lot*
of this around the kernel.  This patch "fixes" the problem for me, but I
don't know if it can be considered an appropriate fix:


diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index fc615a9..1e57449 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -224,7 +224,7 @@ static inline int kobject_uevent_env(struct kobject *kobj,
 
 static inline __printf(2, 3)
 int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
-{ return 0; }
+{ return -ENOMEM; }
 
 static inline int kobject_action_type(const char *buf, size_t count,
                                      enum kobject_action *type)




Bjørn
