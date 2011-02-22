Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab1BVOiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:38:17 -0500
Received: from server103.greatnet.de ([83.133.97.6]:58838 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab1BVOiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:38:15 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@elte.hu
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 3/5] x86: rework arch_disable_smp_support() for x86
Date: Tue, 22 Feb 2011 15:38:05 +0100
Message-Id: <1298385487-4708-3-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298385487-4708-1-git-send-email-henne@nachtwindheim.de>
References: <1298385487-4708-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently arch_disable_smp_support() on x86 disables only the support
for the IOAPIC and is also compiled in if SMP-support is not.

Therefore this function is renamed to disable_ioapic_support(),
which meets its purpose and is only compiled in the kernel
when IOAPIC support is also.

A new arch_disable_smp_support() is created in smpboot.c,
which calls disable_ioapic_support() and gets only compiled
in the kernel when SMP support is also.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 arch/x86/include/asm/io_apic.h |    3 +++
 arch/x86/kernel/apic/apic.c    |    3 ++-
 arch/x86/kernel/apic/io_apic.c |    7 +++++--
 arch/x86/kernel/smpboot.c      |   11 ++++++++++-
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index b24915f..0be2f27 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -175,6 +175,8 @@ extern void __init pre_init_apic_IRQ0(void);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
 
+extern void disable_ioapic_support(void);
+
 #else  /* !CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
@@ -189,6 +191,7 @@ struct io_apic_irq_attr;
 static inline int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr) { return 0; }
 static inline void mp_save_irq(struct mpc_intsrc *m) { };
+static inline void disable_ioapic_support(void) { }
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 1e17929..6fd5c33 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -43,6 +43,7 @@
 #include <asm/i8259.h>
 #include <asm/proto.h>
 #include <asm/apic.h>
+#include <asm/io_apic.h>
 #include <asm/desc.h>
 #include <asm/hpet.h>
 #include <asm/idle.h>
@@ -1218,7 +1219,7 @@ void __cpuinit setup_local_APIC(void)
 		rdtscll(tsc);
 
 	if (disable_apic) {
-		arch_disable_smp_support();
+		disable_ioapic_support();
 		return;
 	}
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ca9e2a3..a2f2bf8 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -108,7 +108,10 @@ DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 
 int skip_ioapic_setup;
 
-void arch_disable_smp_support(void)
+/**
+ * disable_ioapic_support() - disables ioapic support at runtime
+ */
+void disable_ioapic_support(void)
 {
 #ifdef CONFIG_PCI
 	noioapicquirk = 1;
@@ -120,7 +123,7 @@ void arch_disable_smp_support(void)
 static int __init parse_noapic(char *str)
 {
 	/* disable IO-APIC */
-	arch_disable_smp_support();
+	disable_ioapic_support();
 	return 0;
 }
 early_param("noapic", parse_noapic);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 91de347..e9efdfd 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -64,6 +64,7 @@
 #include <asm/mtrr.h>
 #include <asm/mwait.h>
 #include <asm/apic.h>
+#include <asm/io_apic.h>
 #include <asm/setup.h>
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
@@ -867,6 +868,14 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	return 0;
 }
 
+/**
+ * arch_disable_smp_support() - disables SMP support for x86 at runtime
+ */
+void arch_disable_smp_support(void)
+{
+	disable_ioapic_support();
+}
+
 /*
  * Fall back to non SMP mode after errors.
  *
@@ -966,7 +975,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 				"(tell your hw vendor)\n");
 		}
 		smpboot_clear_io_apic();
-		arch_disable_smp_support();
+		disable_ioapic_support();
 		return -1;
 	}
 
-- 
1.7.2.3

