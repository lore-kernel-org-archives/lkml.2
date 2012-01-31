Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab2AaWUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 17:20:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab2AaWUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 17:20:38 -0500
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        ebiederm@xmission.com, kexec-list <kexec@lists.infradead.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH v2] x86, kdump, ioapic: Fix kdump race with migrating irq
Date: Tue, 31 Jan 2012 17:20:27 -0500
Message-Id: <1328048427-20838-1-git-send-email-dzickus@redhat.com>
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

I attempted to resolve this by busting the spinlock in the kdump case only.
My justification was that kdump has already stopped the other cpus and it
is only clearing the io apic which shouldn't cause harm when overwriting
what the other cpu was doing.

I tested this by loading a dummy module that grabs the ioapic_lock and then
on another cpu, run 'echo c > /proc/sysrq-trigger'.  The deadlock was detected
and fixed with the patch below.

v2:
In my haste, I somehow cut out hw_irq.h from the original patch
Compiling against latest tree with raw_spin_lock

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/hw_irq.h      |    2 +-
 arch/x86/kernel/apic/io_apic.c     |   18 +++++++++++++++++-
 arch/x86/kernel/crash.c            |    2 +-
 arch/x86/kernel/machine_kexec_32.c |    2 +-
 arch/x86/kernel/machine_kexec_64.c |    2 +-
 arch/x86/kernel/reboot.c           |    2 +-
 6 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index eb92a6e..1741f7a 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -82,7 +82,7 @@ extern unsigned long io_apic_irqs;
 
 extern void init_VISWS_APIC_irqs(void);
 extern void setup_IO_APIC(void);
-extern void disable_IO_APIC(void);
+extern void disable_IO_APIC(int);
 
 struct io_apic_irq_attr {
 	int ioapic;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index fb07275..96f1d46 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1991,9 +1991,25 @@ void __init enable_IO_APIC(void)
 /*
  * Not an __init, needed by the reboot code
  */
-void disable_IO_APIC(void)
+void disable_IO_APIC(int force)
 {
 	/*
+	 * Use force to bust the io_apic spinlock
+	 *
+	 * There is a case where kdump can race with irq
+	 * migration such that kdump will inject an NMI
+	 * while another cpu holds the ioapic_lock to
+	 * migrate the irq.  This would cause a deadlock.
+	 *
+	 * Because kdump stops all the cpus, we can safely
+	 * bust the spinlock as we are just clearing the
+	 * io apic anyway.
+	 */
+	if (force && raw_spin_is_locked(&ioapic_lock))
+		/* only one cpu should be running now */
+		raw_spin_lock_init(&ioapic_lock);
+
+	/*
 	 * Clear the IO-APIC before rebooting:
 	 */
 	clear_IO_APIC();
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 13ad899..c8383b0 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -97,7 +97,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 
 	lapic_shutdown();
 #if defined(CONFIG_X86_IO_APIC)
-	disable_IO_APIC();
+	disable_IO_APIC(1);
 #endif
 #ifdef CONFIG_HPET_TIMER
 	hpet_disable();
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index a3fa43b..3c60005 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -212,7 +212,7 @@ void machine_kexec(struct kimage *image)
 		 * one form or other. kexec jump path also need
 		 * one.
 		 */
-		disable_IO_APIC();
+		disable_IO_APIC(0);
 #endif
 	}
 
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index b3ea9db..ed94a6a 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -295,7 +295,7 @@ void machine_kexec(struct kimage *image)
 		 * one form or other. kexec jump path also need
 		 * one.
 		 */
-		disable_IO_APIC();
+		disable_IO_APIC(0);
 #endif
 	}
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 37a458b..766795c 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -652,7 +652,7 @@ void native_machine_shutdown(void)
 	lapic_shutdown();
 
 #ifdef CONFIG_X86_IO_APIC
-	disable_IO_APIC();
+	disable_IO_APIC(0);
 #endif
 
 #ifdef CONFIG_HPET_TIMER
-- 
1.7.7.5

