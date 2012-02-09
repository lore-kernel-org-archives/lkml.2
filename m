Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab2BICvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 21:51:23 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:47501 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab2BICvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 21:51:22 -0500
Date: Thu, 9 Feb 2012 10:51:03 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
        Venki Pallipadi <venki@google.com>, linaro-dev@lists.linaro.org,
        patches@linaro.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] sched: generalize CONFIG_IRQ_TIME_ACCOUNTING for X86 and
 ARM
Message-ID: <20120209025103.GC26152@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1328705314-20978-1-git-send-email-dmitry.antipov@linaro.org>
 <20120208131833.GK889@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120208131833.GK889@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 01:18:33PM +0000, Russell King - ARM Linux wrote:
> On Wed, Feb 08, 2012 at 04:48:34AM -0800, Dmitry Antipov wrote:
> > Generalize CONFIG_IRQ_TIME_ACCOUNTING  between X86 and
> > ARM, move "noirqtime=" option to common debugging code.
> > For a bit of backward compatibility, "tsc=noirqtime"
> > is preserved, but issues a warning.
> > 
> > Suggested-by: Venki Pallipadi <venki@google.com>
> > Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
> > ---
> >  arch/arm/kernel/sched_clock.c |    3 +++
> >  arch/x86/Kconfig              |   11 -----------
> >  arch/x86/kernel/tsc.c         |    7 ++++---
> >  include/linux/sched.h         |    2 ++
> >  lib/Kconfig.debug             |   12 ++++++++++++
> >  lib/Makefile                  |    2 ++
> >  lib/irqtime.c                 |   12 ++++++++++++
> >  7 files changed, 35 insertions(+), 14 deletions(-)
> >  create mode 100644 lib/irqtime.c
> > 
> > diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
> > index 5416c7c..56d2a9d 100644
> > --- a/arch/arm/kernel/sched_clock.c
> > +++ b/arch/arm/kernel/sched_clock.c
> > @@ -162,5 +162,8 @@ void __init sched_clock_postinit(void)
> >  	if (read_sched_clock == jiffy_sched_clock_read)
> >  		setup_sched_clock(jiffy_sched_clock_read, 32, HZ);
> >  
> > +	if (!no_sched_irq_time)
> > +		enable_sched_clock_irqtime();
> 
> Why are you placing this here?  sched_clock is available from the point
> that it's registered, which should be before the first sched_clock()
> call.
> 
> > +config IRQ_TIME_ACCOUNTING
> > +	bool "Fine granularity task level IRQ time accounting"
> > +	depends on (X86 || (ARM && HAVE_SCHED_CLOCK))
> 
> Even though it's not bad here, please get out of the habbit of throwing
> unnecessary parens into the mix.  It can make stuff more difficult to
> read and therefore confirm correctness.  (I've spent many a time
> rewriting if() statements because of paren overuse.)
> 
> This could have been written:
> 
> 	depends on X86 || (ARM && HAVE_SCHED_CLOCK)
> 
> However, ARM will always have HAVE_SCHED_CLOCK after the next merge window,
> so this can become a much simpler:
> 
> 	depends on X86 || ARM

Maybe we can hand the depend-things to every ARCH, say let ARCH provides
HAVE_IRQ_TIME_ACCOUNTING. Thus we can make IRQ_TIME_ACCOUNTING
denpend on HAVE_IRQ_TIME_ACCOUNTING.

Thanks,
Yong

> 
> Apart from these two points, the rest of the patch looks fine to me but
> the ultimate decision about its acceptability is up to other people.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
