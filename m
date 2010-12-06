Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab0LFNeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 08:34:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:57539 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab0LFNeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:34:10 -0500
Date: Mon, 6 Dec 2010 13:33:51 GMT
From: tip-bot for Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, bigeasy@linutronix.de, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <20101126165020.GA26361@www.tglx.de>
References: <20101126165020.GA26361@www.tglx.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: io_apic: Split setup_ioapic_ids_from_mpc()
Message-ID: <tip-a38c5380ef9f088be9f49b6e4c5d80af8b1b5cd4@git.kernel.org>
Git-Commit-ID: a38c5380ef9f088be9f49b6e4c5d80af8b1b5cd4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 13:33:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a38c5380ef9f088be9f49b6e4c5d80af8b1b5cd4
Gitweb:     http://git.kernel.org/tip/a38c5380ef9f088be9f49b6e4c5d80af8b1b5cd4
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Fri, 26 Nov 2010 17:50:20 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 6 Dec 2010 14:30:28 +0100

x86: io_apic: Split setup_ioapic_ids_from_mpc()

Sodaville needs to setup the IO_APIC ids as the boot loader leaves
them uninitialized. Split out the setter function so it can be called
unconditionally from the sodaville board code.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20101126165020.GA26361@www.tglx.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/apic/io_apic.c |   28 ++++++++++++++++------------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 240a0a5..d7d46cb 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -169,6 +169,7 @@ extern void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 
 extern void setup_ioapic_ids_from_mpc(void);
+extern void setup_ioapic_ids_from_mpc_nocheck(void);
 
 struct mp_ioapic_gsi{
 	u32 gsi_base;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ce3c6fb..4f026a6 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1934,8 +1934,7 @@ void disable_IO_APIC(void)
  *
  * by Matt Domsch <Matt_Domsch@dell.com>  Tue Dec 21 12:25:05 CST 1999
  */
-
-void __init setup_ioapic_ids_from_mpc(void)
+void __init setup_ioapic_ids_from_mpc_nocheck(void)
 {
 	union IO_APIC_reg_00 reg_00;
 	physid_mask_t phys_id_present_map;
@@ -1944,15 +1943,6 @@ void __init setup_ioapic_ids_from_mpc(void)
 	unsigned char old_id;
 	unsigned long flags;
 
-	if (acpi_ioapic)
-		return;
-	/*
-	 * Don't check I/O APIC IDs for xAPIC systems.  They have
-	 * no meaning without the serial APIC bus.
-	 */
-	if (!(boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
-		|| APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
-		return;
 	/*
 	 * This is broken; anything with a real cpu count has to
 	 * circumvent this idiocy regardless.
@@ -2006,7 +1996,6 @@ void __init setup_ioapic_ids_from_mpc(void)
 			physids_or(phys_id_present_map, phys_id_present_map, tmp);
 		}
 
-
 		/*
 		 * We need to adjust the IRQ routing table
 		 * if the ID changed.
@@ -2042,6 +2031,21 @@ void __init setup_ioapic_ids_from_mpc(void)
 			apic_printk(APIC_VERBOSE, " ok.\n");
 	}
 }
+
+void __init setup_ioapic_ids_from_mpc(void)
+{
+
+	if (acpi_ioapic)
+		return;
+	/*
+	 * Don't check I/O APIC IDs for xAPIC systems.  They have
+	 * no meaning without the serial APIC bus.
+	 */
+	if (!(boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
+		|| APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
+		return;
+	setup_ioapic_ids_from_mpc_nocheck();
+}
 #endif
 
 int no_timer_check __initdata;
