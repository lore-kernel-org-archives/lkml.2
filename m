Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2IBQii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 12:38:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:65296 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab2IBQih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 12:38:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,356,1344236400"; 
   d="scan'208";a="217292855"
Date: Mon, 3 Sep 2012 00:38:31 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        chunkeey@googlemail.com, linville@tuxdriver.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: input0: bad kobj_uevent_env content in show_uevent()
Message-ID: <20120902163831.GA26191@localhost>
References: <20120902075946.GA21198@localhost>
 <87harg35kh.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87harg35kh.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2012 at 03:41:34PM +0200, Bjørn Mork wrote:
> Fengguang Wu <fengguang.wu@intel.com> writes:
> 
> > After the __devinit* removal series, I can still get kernel panic in
> > show_uevent(). So there are more sources of bug..
> >
> > Debug patch:
> >
> > @@ -343,8 +343,11 @@ static ssize_t show_uevent(struct device
> >                 goto out;
> >
> >         /* copy keys to file */
> > -       for (i = 0; i < env->envp_idx; i++)
> > +       dev_err(dev, "uevent %d env[%d]: %s/.../%s\n", env->buflen, env->envp_idx, top_kobj->name, dev->kobj.name);
> > +       for (i = 0; i < env->envp_idx; i++) {
> > +               printk(KERN_ERR "uevent %d env[%d]: %s\n", (int)count, i, env->envp[i]);
> >                 count += sprintf(&buf[count], "%s\n", env->envp[i]);
> > +       }
> >
> > Oops message, the env[] is again not properly initilized:
> >
> > [   44.068623] input input0: uevent 61 env[805306368]: input0/.../input0
> > [   44.069552] uevent 0 env[0]: (null)
> 
> This is a completely different CONFIG_HOTPLUG problem, only
> demonstrating another reason why CONFIG_HOTPLUG should go away.  I had a
> hard time trying to disable it anyway ;-)
> 
> The problem this time is lots of code assuming that a call to
> add_uevent_var() will guarantee that env->buflen > 0.  This is not true
> if CONFIG_HOTPLUG is unset.  So things like this end up overwriting
> env->envp_idx because the array index is -1:
> 
> 	if (add_uevent_var(env, "MODALIAS="))
> 		return -ENOMEM;
>         len = input_print_modalias(&env->buf[env->buflen - 1],
> 				   sizeof(env->buf) - env->buflen,
> 				   dev, 0);
> 
> 
> Don't know what the best action is, given that there seem to be a *lot*
> of this around the kernel.  This patch "fixes" the problem for me, but I

It also works reliably for me: 300 boots without a single failure.

Tested-by: Fengguang Wu <fengguang.wu@intel.com> 

Thanks!
Fengguang
