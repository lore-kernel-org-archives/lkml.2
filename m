Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2BLDKb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 22:10:31 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:33145 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab2BLDKa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 22:10:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        torvalds@linux-foundation.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in crash path
References: <tip-d9bc9be89629445758670220787683e37c93f6c1@git.kernel.org>
	<CAE9FiQWRjvu_uNcx_bJXYHeg4D4k6YzHHmSudsq7EyubLi7+nw@mail.gmail.com>
Date: Sat, 11 Feb 2012 19:13:15 -0800
In-Reply-To: <CAE9FiQWRjvu_uNcx_bJXYHeg4D4k6YzHHmSudsq7EyubLi7+nw@mail.gmail.com>
	(Yinghai Lu's message of "Sat, 11 Feb 2012 17:04:15 -0800")
Message-ID: <m1ipjc3fsk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/BvHQzfRv8qFHFrfx/KI0k9t9uZy5yrEQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On Sat, Feb 11, 2012 at 3:09 PM, tip-bot for Don Zickus
> <dzickus@redhat.com> wrote:
>> Commit-ID:  d9bc9be89629445758670220787683e37c93f6c1
>> Gitweb:     http://git.kernel.org/tip/d9bc9be89629445758670220787683e37c93f6c1
>> Author:     Don Zickus <dzickus@redhat.com>
>> AuthorDate: Thu, 9 Feb 2012 16:53:41 -0500
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Sat, 11 Feb 2012 15:38:53 +0100
>>
>> x86/kdump: No need to disable ioapic/lapic in crash path
>>
>> A customer of ours noticed when their machine crashed, kdump did
>> not work but hung instead.  Using their firmware dumping
>> solution they grabbed a vmcore and decoded the stacks on the
>> cpus.  What they noticed seemed to be a rare deadlock with the
>> ioapic_lock.
>>
>>  CPU4:
>>  machine_crash_shutdown
>>  -> machine_ops.crash_shutdown
>>    -> native_machine_crash_shutdown
>>       -> kdump_nmi_shootdown_cpus ------> Send NMI to other CPUs
>>       -> disable_IO_APIC
>>          -> clear_IO_APIC
>>             -> clear_IO_APIC_pin
>>                -> ioapic_read_entry
>>                   -> spin_lock_irqsave(&ioapic_lock, flags)
>>                   ---Infinite loop here---
>>
>>  CPU0:
>>  do_IRQ
>>  -> handle_irq
>>    -> handle_edge_irq
>>        -> ack_apic_edge
>>           -> move_native_irq
>>               -> mask_IO_APIC_irq
>>                  -> mask_IO_APIC_irq_desc
>>                     -> spin_lock_irqsave(&ioapic_lock, flags)
>>                     ---Receive NMI here after getting spinlock---
>>                        -> nmi
>>                           -> do_nmi
>>                              -> crash_nmi_callback
>>                              ---Infinite loop here---
>>
>> The problem is that although kdump tries to shutdown minimal
>> hardware, it still needs to disable the IO APIC.  This requires
>> spinlocks which may be held by another cpu.  This other cpu is
>> being held infinitely in an NMI context by kdump in order to
>> serialize the crashing path.  Instant deadlock.
>>
>> Eric brought up a point that because the boot code was
>> restructured we may not need to disable the io apic any more in
>> the crash path.  The original concern that led to the
>> development of disable_IO_APIC, was that the jiffies calibration
>> on boot up relied on the PIT timer for reference.  Access to the
>> PIT required 8259 interrupts to be working.  This wouldn't work
>> if the ioapic needed to be configured.  So on panic path, the
>> ioapic was reconfigured to use virtual wire mode to allow the 8259 to passthrough.
>>
>> Those concerns don't hold true now, thanks to the jiffies
>> calibration code not needing the PIT.  As a result, we can
>> remove this call and simplify the locking needed in the panic
>> path.
>>
>> The same work allowed us to remove the need to disable the local
>> apic on shutdown too.  This should allow us to jump to the
>> second a little faster.
>>
>> I tested kdump on an Ivy Bridge platform, a Pentium4 and an old
>> athlon that did not have an ioapic.  All three were successful.
>>
>> I also tested using lkdtm that would use jprobes to panic the
>> system when entering do_IRQ.  The idea was to see how the system
>> reacted with an interrupt pending in the second kernel.  My
>> core2 quad successfully kdump'd 3 times in a row with no issues.
>>
>> v2: removed the disable lapic code too
>
> with this commit, kdump is not working anymore on my setups with
> Nehalem, Westmere, sandbridge.
> these setup all have VT-d enabled.
>
>
> After reverting this commit, kdump is working again.
>
> So assume you need to drop this patch.

It sounds like there is a bug in ioapic initialization in the context of
VT-d.  Where do you fail?

It would be much better to debug this than to blindly revert this patch,
as this change has the potential to significantly increase the
reliability of the kdump path.

Eric
