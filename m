Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab0JWPb4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 11:31:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:40090 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757618Ab0JWPby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 11:31:54 -0400
Date: Sat, 23 Oct 2010 15:31:36 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: dirk.j.brandewie@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dirk.j.brandewie@intel.com, tglx@linutronix.de
In-Reply-To: <1287510389-8388-2-git-send-email-dirk.brandewie@gmail.com>
References: <1287510389-8388-2-git-send-email-dirk.brandewie@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: apic: Move probe_nr_irqs_gsi() into ioapic_init_mappings()
Message-ID: <tip-23f9b267159b4c7ff59d2e6c8ed31693eff841e3@git.kernel.org>
Git-Commit-ID: 23f9b267159b4c7ff59d2e6c8ed31693eff841e3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 23 Oct 2010 15:31:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23f9b267159b4c7ff59d2e6c8ed31693eff841e3
Gitweb:     http://git.kernel.org/tip/23f9b267159b4c7ff59d2e6c8ed31693eff841e3
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 15 Oct 2010 15:38:50 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 23 Oct 2010 17:27:50 +0200

x86: apic: Move probe_nr_irqs_gsi() into ioapic_init_mappings()

probe_br_irqs_gsi() is called right after ioapic_init_mappings() and
there are no other users. Move it into ioapic_init_mappings() so the
declaration can disappear and the function can become static.

Rename ioapic_init_mappings() to ioapic_and_gsi_init() to reflect that
change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1287510389-8388-2-git-send-email-dirk.brandewie@gmail.com>
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 arch/x86/include/asm/io_apic.h |    5 +----
 arch/x86/kernel/apic/io_apic.c |    6 ++++--
 arch/x86/kernel/setup.c        |    5 +----
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index c8be456..7e620ba 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -159,7 +159,7 @@ struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
 void setup_IO_APIC_irq_extra(u32 gsi);
-extern void ioapic_init_mappings(void);
+extern void ioapic_and_gsi_init(void);
 extern void ioapic_insert_resources(void);
 
 extern struct IO_APIC_route_entry **alloc_ioapic_entries(void);
@@ -168,8 +168,6 @@ extern int save_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 
-extern void probe_nr_irqs_gsi(void);
-
 extern void setup_ioapic_ids_from_mpc(void);
 
 struct mp_ioapic_gsi{
@@ -190,7 +188,6 @@ extern void __init pre_init_apic_IRQ0(void);
 static const int timer_through_8259 = 0;
 static inline void ioapic_init_mappings(void)	{ }
 static inline void ioapic_insert_resources(void) { }
-static inline void probe_nr_irqs_gsi(void)	{ }
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8ae808d..ce3c6fb 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3639,7 +3639,7 @@ int __init io_apic_get_redir_entries (int ioapic)
 	return reg_01.bits.entries + 1;
 }
 
-void __init probe_nr_irqs_gsi(void)
+static void __init probe_nr_irqs_gsi(void)
 {
 	int nr;
 
@@ -3951,7 +3951,7 @@ static struct resource * __init ioapic_setup_resources(int nr_ioapics)
 	return res;
 }
 
-void __init ioapic_init_mappings(void)
+void __init ioapic_and_gsi_init(void)
 {
 	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
 	struct resource *ioapic_res;
@@ -3989,6 +3989,8 @@ fake_ioapic_page:
 		ioapic_res->end = ioapic_phys + IO_APIC_SLOT_SIZE - 1;
 		ioapic_res++;
 	}
+
+	probe_nr_irqs_gsi();
 }
 
 void __init ioapic_insert_resources(void)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 420e641..b8982e0 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1017,10 +1017,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	init_apic_mappings();
-	ioapic_init_mappings();
-
-	/* need to wait for io_apic is mapped */
-	probe_nr_irqs_gsi();
+	ioapic_and_gsi_init();
 
 	kvm_guest_init();
 
