Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab2BBXWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:22:09 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37875 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab2BBXWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:22:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Don Zickus <dzickus@redhat.com>
Cc: <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kexec-list <kexec@lists.infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] x86, kdump: No need to disable ioapic in crash path
References: <1328206323-25580-1-git-send-email-dzickus@redhat.com>
Date: Thu, 02 Feb 2012 15:24:46 -0800
In-Reply-To: <1328206323-25580-1-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Thu, 2 Feb 2012 13:12:03 -0500")
Message-ID: <m1r4ycsts1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/szaSa7pBJuAO9X5w01SpxiyTqb5hXbB4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus <dzickus@redhat.com> writes:

> A customer of ours noticed when their machine crashed, kdump did not
> work but hung instead.  Using their firmware dumping solution they
> grabbed a vmcore and decoded the stacks on the cpus.  What they
> noticed seemed to be a rare deadlock with the ioapic_lock.
>
>  CPU4:
>  machine_crash_shutdown
>  -> machine_ops.crash_shutdown
>     -> native_machine_crash_shutdown
>        -> kdump_nmi_shootdown_cpus ------> Send NMI to other CPUs
>        -> disable_IO_APIC
>           -> clear_IO_APIC
>              -> clear_IO_APIC_pin
>                 -> ioapic_read_entry
>                    -> spin_lock_irqsave(&ioapic_lock, flags)
>                    ---Infinite loop here---
>
>  CPU0:
>  do_IRQ
>  -> handle_irq
>     -> handle_edge_irq
>         -> ack_apic_edge
>            -> move_native_irq
>                -> mask_IO_APIC_irq
>                   -> mask_IO_APIC_irq_desc
>                      -> spin_lock_irqsave(&ioapic_lock, flags)
>                      ---Receive NMI here after getting spinlock---
>                         -> nmi
>                            -> do_nmi
>                               -> crash_nmi_callback
>                               ---Infinite loop here---
>
> The problem is that although kdump tries to shutdown minimal hardware,
> it still needs to disable the IO APIC.  This requires spinlocks which
> may be held by another cpu.  This other cpu is being held infinitely in
> an NMI context by kdump in order to serialize the crashing path.  Instant
> deadlock.
>
> Eric, brought up a point that because the boot code was restructured we may
> not need to disable the io apic any more in the crash path.  The original
> concern that led to the development of disable_IO_APIC, was that the TSC
> calibration on boot up relied on the PIT timer for reference.  Access
> to the PIT required 8259 interrupts to be working.  This wouldn't work
> if the ioapic needed to be configured.  So on panic path, the ioapic was
> reconfigured to use virtual wire mode to allow the 8259 to passthrough.

A small clarification originally it was the jiffies calibration that
would fail if we could cause the PIT to generate interrupts through the
8259.  The boot would then hang at calibrating jiffies.

> Those concerns don't hold true now, thanks to the fast TSC calibration code
> not needing the PIT.  As a result, we can remove this call and simplify the
> locking needed in the panic path.
>
> I tested kdump on an Ivy Bridge platform, a Pentium4 and an old athlon that
> did not have an ioapic.  All three were successful.
>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
>
> ---
> I will probably need some help with my explaination as to why this line is not
> needed.  Any input is appreciated!

Can you test and verify that we also do not need the lapic_shutdown()
call and the disable_local_APIC call on the other processors.  The same
reasoning that supports us not needing to disable the IO_APIC also
supports us not needing to disable local apic.

Removing disable_IO_APIC in and of itself and then booting isn't quite
sufficient as a practical test to prove this code always works.
Sometimes the IOAPIC was not hooked up to interesting interrupt sources
like the 8259.

Eric

> ---
>  arch/x86/kernel/crash.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index 13ad899..b053cf9 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -96,9 +96,6 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
>  	cpu_emergency_svm_disable();
>  
>  	lapic_shutdown();
> -#if defined(CONFIG_X86_IO_APIC)
> -	disable_IO_APIC();
> -#endif
>  #ifdef CONFIG_HPET_TIMER
>  	hpet_disable();
>  #endif
