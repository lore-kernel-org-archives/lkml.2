Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2B2UJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:09:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab2B2UJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:09:13 -0500
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kexec-list <kexec@lists.infradead.org>,
        Don Zickus <dzickus@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] x86, kdump: No need to disable ioapic in crash path
Date: Wed, 29 Feb 2012 15:08:49 -0500
Message-Id: <1330546129-4812-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A customer of ours noticed when their machine crashed, kdump did not
work but hung instead.  Using their firmware dumping solution they
grabbed a vmcore and decoded the stacks on the cpus.  What they
noticed seemed to be a rare deadlock with the ioapic_lock.

 CPU4:
 machine_crash_shutdown
 -> machine_ops.crash_shutdown
    -> native_machine_crash_shutdown
       -> kdump_nmi_shootdown_cpus ------> Send NMI to other CPUs
       -> disable_IO_APIC
          -> clear_IO_APIC
             -> clear_IO_APIC_pin
                -> ioapic_read_entry
                   -> spin_lock_irqsave(&ioapic_lock, flags)
                   ---Infinite loop here---

 CPU0:
 do_IRQ
 -> handle_irq
    -> handle_edge_irq
        -> ack_apic_edge
           -> move_native_irq
               -> mask_IO_APIC_irq
                  -> mask_IO_APIC_irq_desc
                     -> spin_lock_irqsave(&ioapic_lock, flags)
                     ---Receive NMI here after getting spinlock---
                        -> nmi
                           -> do_nmi
                              -> crash_nmi_callback
                              ---Infinite loop here---

The problem is that although kdump tries to shutdown minimal hardware,
it still needs to disable the IO APIC.  This requires spinlocks which
may be held by another cpu.  This other cpu is being held infinitely in
an NMI context by kdump in order to serialize the crashing path.  Instant
deadlock.

Eric, brought up a point that because the boot code was restructured we may
not need to disable the io apic any more in the crash path.  The original
concern that led to the development of disable_IO_APIC, was that the jiffies
calibration on boot up relied on the PIT timer for reference.  Access
to the PIT required 8259 interrupts to be working.  This wouldn't work
if the ioapic needed to be configured.  So on panic path, the ioapic was
reconfigured to use virtual wire mode to allow the 8259 to passthrough.

Those concerns don't hold true now, thanks to the jiffies calibration code
not needing the PIT.  As a result, we can remove this call and simplify the
locking needed in the panic path.

I tested kdump on an Ivy Bridge platform, a Pentium4 and an old athlon that
did not have an ioapic.  All three were successful.

I also tested using lkdtm that would use jprobes to panic the system when
entering do_IRQ.  The idea was to see how the system reacted with an
interrupt pending in the second kernel.  My core2 quad successfully kdump'd
3 times in a row with no issues.

v2: removed the disable lapic code too
v3: re-add disabling of lapic code

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---

There are really two problems here.  One is the deadlock of the ioapic_lock
that I describe above.  Removing the code to disable the ioapic seems to
resolve that.

The second issue is handling non-IRQ exceptions like NMIs.  Eric asked me
to include removing the disable lapic code too.  However, because the nmi
watchdog is stil active and kexec zeros out the idt before it jumps to
purgatory, an NMI that comes in during the transition between the first
kernel and second kernel will see an empty idt and reset the cpu.

Leaving the code to disable the lapic in, turns off perf and blocks those NMIs
from happening (though an external NMI would still be an issue but that is no
different than right now).

I tried playing with a stub idt and leaving it in place through the transition
to the second kernel, but I can't quite get it to work correctly.  Spinning in the
first kernel before the purgatory jump catches the idt properly.  Spinning in
purgatory before the second kernel jump doesn't.  I even disabled the zero'ing
out of the idt in the purgatory code.

I would like to get resolution on the ioapic deadlock to fix a customer issue
while working the idt and NMI thing on the side, hence the split of this
patchset.

Hopefully, people recognize there are two issues here and that this patch
resolves the first one and the second one needs more debugging and time.
---
 arch/x86/kernel/crash.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 13ad899..b053cf9 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -96,9 +96,6 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 	cpu_emergency_svm_disable();
 
 	lapic_shutdown();
-#if defined(CONFIG_X86_IO_APIC)
-	disable_IO_APIC();
-#endif
 #ifdef CONFIG_HPET_TIMER
 	hpet_disable();
 #endif
-- 
1.7.7.6

