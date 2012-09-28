Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031231Ab2I1Tut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:50:49 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63190 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965034Ab2I1S6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:58:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Fengguang Wu <fengguang.wu@intel.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: =?UTF-8?q?=5B=20085/262=5D=20kobject=3A=20fix=20oops=20with=20=22input0=3A=20bad=20kobj=5Fuevent=5Fenv=20content=20in=20show=5Fuevent=28=29=22?=
Date: Fri, 28 Sep 2012 11:50:14 -0700
Message-Id: <20120928183008.199904216@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 60e233a56609fd963c59e99bd75c663d63fa91b6 upstream.

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
don't know if it can be considered an appropriate fix.

[ It is the correct fix for now, for 3.7 forcing CONFIG_HOTPLUG to
always be on is the longterm fix, but it's too late for 3.6 and older
kernels to resolve this that way - gregkh ]

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/kobject.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -224,7 +224,7 @@ static inline int kobject_uevent_env(str
 
 static inline __printf(2, 3)
 int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
-{ return 0; }
+{ return -ENOMEM; }
 
 static inline int kobject_action_type(const char *buf, size_t count,
 				      enum kobject_action *type)


