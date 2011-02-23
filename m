Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab1BWMIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:08:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:56590 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622Ab1BWMIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:08:34 -0500
Date: Wed, 23 Feb 2011 12:08:07 GMT
From: tip-bot for Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, henne@nachtwindheim.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, henne@nachtwindheim.de, mingo@elte.hu
In-Reply-To: <1298385487-4708-3-git-send-email-henne@nachtwindheim.de>
References: <1298385487-4708-3-git-send-email-henne@nachtwindheim.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Rework arch_disable_smp_support() for x86
Message-ID: <tip-7167d08e780a722fa79ea414fc4e72bc00751392@git.kernel.org>
Git-Commit-ID: 7167d08e780a722fa79ea414fc4e72bc00751392
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 12:08:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7167d08e780a722fa79ea414fc4e72bc00751392
Gitweb:     http://git.kernel.org/tip/7167d08e780a722fa79ea414fc4e72bc00751392
Author:     Henrik Kretzschmar <henne@nachtwindheim.de>
AuthorDate: Tue, 22 Feb 2011 15:38:05 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Feb 2011 11:38:45 +0100

x86: Rework arch_disable_smp_support() for x86

Currently arch_disable_smp_support() on x86 disables only the
support for the IOAPIC and is also compiled in if SMP-support is
not.

Therefore this function is renamed to disable_ioapic_support(),
which meets its purpose and is only compiled in the kernel
when IOAPIC support is also.

A new arch_disable_smp_support() is created in smpboot.c,
which calls disable_ioapic_support() and gets only compiled
in the kernel when SMP support is also.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
LKML-Reference: <1298385487-4708-3-git-send-email-henne@nachtwindheim.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index 76b96d7..96e6809 100644
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
@@ -1209,7 +1210,7 @@ void __cpuinit setup_local_APIC(void)
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
index 08776a9..09d0172 100644
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
@@ -945,6 +946,14 @@ int __cpuinit native_cpu_up(unsigned int cpu)
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
@@ -1045,7 +1054,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 				"(tell your hw vendor)\n");
 		}
 		smpboot_clear_io_apic();
-		arch_disable_smp_support();
+		disable_ioapic_support();
 		return -1;
 	}
 
