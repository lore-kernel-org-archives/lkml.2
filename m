Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab2BLLNL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 06:13:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50011 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab2BLLNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 06:13:09 -0500
Date: Sun, 12 Feb 2012 12:12:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        torvalds@linux-foundation.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org,
        tglx@linutronix.de, dzickus@redhat.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in
 crash path
Message-ID: <20120212111250.GA21493@elte.hu>
References: <tip-d9bc9be89629445758670220787683e37c93f6c1@git.kernel.org>
 <CAE9FiQWRjvu_uNcx_bJXYHeg4D4k6YzHHmSudsq7EyubLi7+nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQWRjvu_uNcx_bJXYHeg4D4k6YzHHmSudsq7EyubLi7+nw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Sat, Feb 11, 2012 at 3:09 PM, tip-bot for Don Zickus
> <dzickus@redhat.com> wrote:
> > Commit-ID:  d9bc9be89629445758670220787683e37c93f6c1
> > Gitweb:     http://git.kernel.org/tip/d9bc9be89629445758670220787683e37c93f6c1
> > Author:     Don Zickus <dzickus@redhat.com>
> > AuthorDate: Thu, 9 Feb 2012 16:53:41 -0500
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sat, 11 Feb 2012 15:38:53 +0100
> >
> > x86/kdump: No need to disable ioapic/lapic in crash path
> >
> > A customer of ours noticed when their machine crashed, kdump did
> > not work but hung instead.  Using their firmware dumping
> > solution they grabbed a vmcore and decoded the stacks on the
> > cpus.  What they noticed seemed to be a rare deadlock with the
> > ioapic_lock.
> >
> >  CPU4:
> >  machine_crash_shutdown
> >  -> machine_ops.crash_shutdown
> >    -> native_machine_crash_shutdown
> >       -> kdump_nmi_shootdown_cpus ------> Send NMI to other CPUs
> >       -> disable_IO_APIC
> >          -> clear_IO_APIC
> >             -> clear_IO_APIC_pin
> >                -> ioapic_read_entry
> >                   -> spin_lock_irqsave(&ioapic_lock, flags)
> >                   ---Infinite loop here---
> >
> >  CPU0:
> >  do_IRQ
> >  -> handle_irq
> >    -> handle_edge_irq
> >        -> ack_apic_edge
> >           -> move_native_irq
> >               -> mask_IO_APIC_irq
> >                  -> mask_IO_APIC_irq_desc
> >                     -> spin_lock_irqsave(&ioapic_lock, flags)
> >                     ---Receive NMI here after getting spinlock---
> >                        -> nmi
> >                           -> do_nmi
> >                              -> crash_nmi_callback
> >                              ---Infinite loop here---
> >
> > The problem is that although kdump tries to shutdown minimal
> > hardware, it still needs to disable the IO APIC.  This requires
> > spinlocks which may be held by another cpu.  This other cpu is
> > being held infinitely in an NMI context by kdump in order to
> > serialize the crashing path.  Instant deadlock.
> >
> > Eric brought up a point that because the boot code was
> > restructured we may not need to disable the io apic any more in
> > the crash path.  The original concern that led to the
> > development of disable_IO_APIC, was that the jiffies calibration
> > on boot up relied on the PIT timer for reference.  Access to the
> > PIT required 8259 interrupts to be working.  This wouldn't work
> > if the ioapic needed to be configured.  So on panic path, the
> > ioapic was reconfigured to use virtual wire mode to allow the 8259 to passthrough.
> >
> > Those concerns don't hold true now, thanks to the jiffies
> > calibration code not needing the PIT.  As a result, we can
> > remove this call and simplify the locking needed in the panic
> > path.
> >
> > The same work allowed us to remove the need to disable the local
> > apic on shutdown too.  This should allow us to jump to the
> > second a little faster.
> >
> > I tested kdump on an Ivy Bridge platform, a Pentium4 and an old
> > athlon that did not have an ioapic.  All three were successful.
> >
> > I also tested using lkdtm that would use jprobes to panic the
> > system when entering do_IRQ.  The idea was to see how the system
> > reacted with an interrupt pending in the second kernel.  My
> > core2 quad successfully kdump'd 3 times in a row with no issues.
> >
> > v2: removed the disable lapic code too
> 
> with this commit, kdump is not working anymore on my setups with
> Nehalem, Westmere, sandbridge.
> these setup all have VT-d enabled.
> 
> After reverting this commit, kdump is working again.
> 
> So assume you need to drop this patch.

Dropped the patch, thanks for reporting this.

Don, Eric?

	Ingo
