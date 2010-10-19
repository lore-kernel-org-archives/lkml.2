Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0JSRd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:33:56 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61102 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab0JSRdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:33:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PbYvmtA4zZvj4rYIwWuzT0xhGg9cmr5X8JMsGHt+2GnRm9qvL9wcCll0KhX9MKuP70
         2h9T4L/nBnZeXKMVu8IqhKHiVTMfG2lwlzinDZP88rN0UGGemdh15ks/P8fqI15OGBK9
         cds3q3aJBfURNCsXQ4/GdWAKX91bVc6TQQs00=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
Subject: [PATCH] x86/apic: move probe_nr_irqs_gsi() into ioapic_init_mappings()
Date: Tue, 19 Oct 2010 10:46:29 -0700
Message-Id: <1287510389-8388-2-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1287510389-8388-1-git-send-email-dirk.brandewie@gmail.com>
References: <1287510389-8388-1-git-send-email-dirk.brandewie@gmail.com>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

It is called right after ioapic_init_mappings() and there are no other
users. Move into ioapic_init_mappings() so the declaration can disappear
and the function can become static.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |    3 ---
 arch/x86/kernel/apic/io_apic.c |    4 +++-
 arch/x86/kernel/setup.c        |    3 ---
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 9cb2edb..0b7a8a7 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -168,8 +168,6 @@ extern int save_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 
-extern void probe_nr_irqs_gsi(void);
-
 extern int setup_ioapic_entry(int apic, int irq,
 			      struct IO_APIC_route_entry *entry,
 			      unsigned int destination, int trigger,
@@ -196,7 +194,6 @@ extern void __init pre_init_apic_IRQ0(void);
 static const int timer_through_8259 = 0;
 static inline void ioapic_init_mappings(void)	{ }
 static inline void ioapic_insert_resources(void) { }
-static inline void probe_nr_irqs_gsi(void)	{ }
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 5c5b8f3..ba5b0cc 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3856,7 +3856,7 @@ int __init io_apic_get_redir_entries (int ioapic)
 	return reg_01.bits.entries + 1;
 }
 
-void __init probe_nr_irqs_gsi(void)
+static void __init probe_nr_irqs_gsi(void)
 {
 	int nr;
 
@@ -4210,6 +4210,8 @@ fake_ioapic_page:
 		ioapic_res->end = ioapic_phys + IO_APIC_SLOT_SIZE - 1;
 		ioapic_res++;
 	}
+
+	probe_nr_irqs_gsi();
 }
 
 void __init ioapic_insert_resources(void)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 92edc86..c77b4e5 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1055,9 +1055,6 @@ void __init setup_arch(char **cmdline_p)
 	init_apic_mappings();
 	ioapic_init_mappings();
 
-	/* need to wait for io_apic is mapped */
-	probe_nr_irqs_gsi();
-
 	kvm_guest_init();
 
 	e820_reserve_resources();
-- 
1.7.2.3

