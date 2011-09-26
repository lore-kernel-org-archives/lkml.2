Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1IZWFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 18:05:20 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:1634 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1IZWFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 18:05:19 -0400
Subject: Re: [PATCH v5 3.1.0-rc4-tip 13/26] x86: define a x86 specific
 exception notifier.
From: Shuah Khan <shuah.khan@hp.com>
To: srikar@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: ISS-VC
Date: Mon, 26 Sep 2011 16:05:17 -0600
Message-ID: <1317074717.2986.79.camel@lorien.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2011-09-20 at 17:32 +0530, Srikar Dronamraju wrote:
> > @@ -820,6 +821,19 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
> >                 mce_notify_process();
> >  #endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
> > 
> > +       if (thread_info_flags & _TIF_UPROBE) {
> > +               clear_thread_flag(TIF_UPROBE);
> > +#ifdef CONFIG_X86_32
> > +               /*
> > +                * On x86_32, do_notify_resume() gets called with
> > +                * interrupts disabled. Hence enable interrupts if they
> > +                * are still disabled.
> > +                */
> > +               local_irq_enable();
> > +#endif
> > +               uprobe_notify_resume(regs);
> > +       }
> > +
> >         /* deal with pending signal delivery */
> >         if (thread_info_flags & _TIF_SIGPENDING)
> >                 do_signal(regs); 
> 
> It would be good to remove this difference between i386 and x86_64.


> I think, we have already discussed this. I tried getting to know why we
> have this difference in behaviour. However I havent been able to find
> the answer.

The reason for the difference between X86_64 and i386 is because of a bug
that went to address delayed signals on x86_64. More details can be found
at:

http://kerneltrap.org/mailarchive/git-commits-head/2008/7/15/2490384

It appears for some reason i386 code path left unchanged, maybe desire to
not fix it when it ain't broken.

-- Shuah



