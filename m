Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab2ICAWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 20:22:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab2ICAWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 20:22:45 -0400
Date: Sun, 2 Sep 2012 17:22:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>, linux-input@vger.kernel.org,
        chunkeey@googlemail.com, linville@tuxdriver.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: input0: bad kobj_uevent_env content in show_uevent()
Message-ID: <20120903002241.GA20054@kroah.com>
References: <20120902075946.GA21198@localhost>
 <87harg35kh.fsf@nemi.mork.no>
 <20120902163831.GA26191@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120902163831.GA26191@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 12:38:31AM +0800, Fengguang Wu wrote:
> On Sun, Sep 02, 2012 at 03:41:34PM +0200, Bjørn Mork wrote:
> > Fengguang Wu <fengguang.wu@intel.com> writes:
> > 
> > > After the __devinit* removal series, I can still get kernel panic in
> > > show_uevent(). So there are more sources of bug..
> > >
> > > Debug patch:
> > >
> > > @@ -343,8 +343,11 @@ static ssize_t show_uevent(struct device
> > >                 goto out;
> > >
> > >         /* copy keys to file */
> > > -       for (i = 0; i < env->envp_idx; i++)
> > > +       dev_err(dev, "uevent %d env[%d]: %s/.../%s\n", env->buflen, env->envp_idx, top_kobj->name, dev->kobj.name);
> > > +       for (i = 0; i < env->envp_idx; i++) {
> > > +               printk(KERN_ERR "uevent %d env[%d]: %s\n", (int)count, i, env->envp[i]);
> > >                 count += sprintf(&buf[count], "%s\n", env->envp[i]);
> > > +       }
> > >
> > > Oops message, the env[] is again not properly initilized:
> > >
> > > [   44.068623] input input0: uevent 61 env[805306368]: input0/.../input0
> > > [   44.069552] uevent 0 env[0]: (null)
> > 
> > This is a completely different CONFIG_HOTPLUG problem, only
> > demonstrating another reason why CONFIG_HOTPLUG should go away.  I had a
> > hard time trying to disable it anyway ;-)
> > 
> > The problem this time is lots of code assuming that a call to
> > add_uevent_var() will guarantee that env->buflen > 0.  This is not true
> > if CONFIG_HOTPLUG is unset.  So things like this end up overwriting
> > env->envp_idx because the array index is -1:
> > 
> > 	if (add_uevent_var(env, "MODALIAS="))
> > 		return -ENOMEM;
> >         len = input_print_modalias(&env->buf[env->buflen - 1],
> > 				   sizeof(env->buf) - env->buflen,
> > 				   dev, 0);
> > 
> > 
> > Don't know what the best action is, given that there seem to be a *lot*
> > of this around the kernel.  This patch "fixes" the problem for me, but I
> 
> It also works reliably for me: 300 boots without a single failure.
> 
> Tested-by: Fengguang Wu <fengguang.wu@intel.com> 

Thanks for figuring this out.  I'll apply it for 3.6, but work to get
rid of CONFIG_HOTPLUG completly for 3.7 as it just causes problems.

greg k-h
