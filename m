Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0HPNfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 09:35:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab0HPNfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 09:35:18 -0400
Date: Mon, 16 Aug 2010 09:34:52 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: fix BUG: using smp_processor_id() in touch_nmi_watchdog and
 touch_softlockup_watchdog
Message-ID: <20100816133452.GS4879@redhat.com>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
 <1281946970.1926.998.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281946970.1926.998.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 10:22:50AM +0200, Peter Zijlstra wrote:
> On Fri, 2010-08-13 at 13:21 +0300, Sergey Senozhatsky wrote:
> 
> > [   67.703556] BUG: using smp_processor_id() in preemptible [00000000] code: s2disk/5139
> > [   67.703563] caller is touch_nmi_watchdog+0x15/0x2c
> > [   67.703566] Pid: 5139, comm: s2disk Not tainted 2.6.36-rc0-git12-07921-g60bf26a-dirty #116
> > [   67.703568] Call Trace:
> > [   67.703575]  [<ffffffff811f6bf1>] debug_smp_processor_id+0xc9/0xe4
> > [   67.703578]  [<ffffffff81092766>] touch_nmi_watchdog+0x15/0x2c
> > [   67.703584]  [<ffffffff81222950>] acpi_os_stall+0x34/0x40
> > [   67.703589]  [<ffffffff812398d2>] acpi_ex_system_do_stall+0x34/0x38
> 
> Which could mean two things, either ACPI got funny on us, or Don's new
> watchdog stuff has a hole in it.

it could. :-)

> 
> 
> > ---
> > 
> > diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> > index 613bc1f..8822f1e 100644
> > --- a/kernel/watchdog.c
> > +++ b/kernel/watchdog.c
> > @@ -116,13 +116,14 @@ static unsigned long get_sample_period(void)
> >  static void __touch_watchdog(void)
> >  {
> >  	int this_cpu = smp_processor_id();
> > -
> > -	__get_cpu_var(watchdog_touch_ts) = get_timestamp(this_cpu);
> > +	per_cpu(watchdog_touch_ts, this_cpu) = get_timestamp(this_cpu);
> >  }
> 
> That change seems sensible enough..

ok.

> 
> >  void touch_softlockup_watchdog(void)
> >  {
> > -	__get_cpu_var(watchdog_touch_ts) = 0;
> > +	int this_cpu = get_cpu();
> > +	per_cpu(watchdog_touch_ts, this_cpu) = 0;
> > +	put_cpu();
> >  }
> >  EXPORT_SYMBOL(touch_softlockup_watchdog);
> >  
> > @@ -142,7 +143,9 @@ void touch_all_softlockup_watchdogs(void)
> >  #ifdef CONFIG_HARDLOCKUP_DETECTOR
> >  void touch_nmi_watchdog(void)
> >  {
> > -	__get_cpu_var(watchdog_nmi_touch) = true;
> > +	int this_cpu = get_cpu();
> > +	per_cpu(watchdog_nmi_touch, this_cpu) = true;
> > +	put_cpu();
> >  	touch_softlockup_watchdog();
> >  }
> >  EXPORT_SYMBOL(touch_nmi_watchdog);
> 
> These other two really are about assumptions we make on the call sites,
> which at the very least are violated by ACPI.
> 
> Don/Ingo, remember if we require touch_*_watchdog callers to have
> preemption disabled? Or is the proposed patch sensible?

I don't recall any requirement to have preemption disabled when using
those functions.  It seems sensible to put it in the
touch_{softlockup|nmi}_watchdog code.

I assume the reason for having preemption disabled when using
smp_processor_id() is that the code could migrate to another cpu when
rescheduled?

I don't see a problem with the patch, but my low level understanding of
the __get_cpu_var vs. per_cpu isn't very strong.

Cheers,
Don

> 
