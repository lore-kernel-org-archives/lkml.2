Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0KZQwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:52:53 -0500
Received: from www.tglx.de ([62.245.132.106]:40295 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab0KZQww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:52:52 -0500
Date: Fri, 26 Nov 2010 17:50:20 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: sodaville@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/io_apic: split setup_ioapic_ids_from_mpc() into a non-checkign version
Message-ID: <20101126165020.GA26361@www.tglx.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de> <1290706801-7323-11-git-send-email-bigeasy@linutronix.de> <AANLkTikBHcRkgvzCi3jRLiRHLSPT93Gm1Kkwx35fXBeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <AANLkTikBHcRkgvzCi3jRLiRHLSPT93Gm1Kkwx35fXBeA@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that I need this function to write the APIC id back to the chip
as it is not initialized at all. apic_version[boot_cpu_physical_apicid]
return 0x14 and therefore it is skipped. The manual on the other hand
says that these ids should be uniqe.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: x86@kernel.org
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/apic/io_apic.c |   28 ++++++++++++++++------------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index dc1169f..185d484 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -170,6 +170,7 @@ extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 
 extern int get_nr_irqs_gsi(void);
 extern void setup_ioapic_ids_from_mpc(void);
+void setup_ioapic_ids_from_mpc_nocheck(void);
 
 struct mp_ioapic_gsi{
 	u32 gsi_base;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 27a5709..56c45ab 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1939,8 +1939,7 @@ void disable_IO_APIC(void)
  *
  * by Matt Domsch <Matt_Domsch@dell.com>  Tue Dec 21 12:25:05 CST 1999
  */
-
-void __init setup_ioapic_ids_from_mpc(void)
+void __init setup_ioapic_ids_from_mpc_nocheck(void)
 {
 	union IO_APIC_reg_00 reg_00;
 	physid_mask_t phys_id_present_map;
@@ -1949,15 +1948,6 @@ void __init setup_ioapic_ids_from_mpc(void)
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
@@ -2011,7 +2001,6 @@ void __init setup_ioapic_ids_from_mpc(void)
 			physids_or(phys_id_present_map, phys_id_present_map, tmp);
 		}
 
-
 		/*
 		 * We need to adjust the IRQ routing table
 		 * if the ID changed.
@@ -2047,6 +2036,21 @@ void __init setup_ioapic_ids_from_mpc(void)
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
-- 
1.7.3.2

