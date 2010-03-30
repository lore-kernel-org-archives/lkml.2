Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab0C3IK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 04:10:58 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47330 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab0C3IHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 04:07:24 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, len.brown@intel.com,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-acpi@vger.kernel.org, Iranna D Ankad <iranna.ankad@in.ibm.com>,
       Gary Hade <garyhade@us.ibm.com>,
       Natalie Protasevich <protasnb@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 08/15] x86 ioapic: Fix the types of gsi values
Date: Tue, 30 Mar 2010 01:07:09 -0700
Message-Id: <1269936436-7039-8-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1oci6qlmr.fsf_-_@fess.ebiederm.org>
References: <m1oci6qlmr.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu, akpm@linux-foundation.org, jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org, trenn@suse.de, suresh.b.siddha@intel.com, len.brown@intel.com, tony.luck@intel.com, fenghua.yu@intel.com, linux-acpi@vger.kernel.org, iranna.ankad@in.ibm.com, garyhade@us.ibm.com, protasnb@gmail.com, ebiederm@xmission.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

This patches fixes the types of gsi_base and gsi_end values in
struct mp_ioapic_gsi, and the gsi parameter of mp_find_ioapic
and mp_find_ioapic_pin

A gsi is cannonically a u32, not an int.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/include/asm/io_apic.h |   10 +++++-----
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 35832a0..feeaf0d 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -180,12 +180,12 @@ extern void ioapic_write_entry(int apic, int pin,
 extern void setup_ioapic_ids_from_mpc(void);
 
 struct mp_ioapic_gsi{
-	int gsi_base;
-	int gsi_end;
+	u32 gsi_base;
+	u32 gsi_end;
 };
 extern struct mp_ioapic_gsi  mp_gsi_routing[];
-int mp_find_ioapic(int gsi);
-int mp_find_ioapic_pin(int ioapic, int gsi);
+int mp_find_ioapic(u32 gsi);
+int mp_find_ioapic_pin(int ioapic, u32 gsi);
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void __init pre_init_apic_IRQ0(void);
 
@@ -197,7 +197,7 @@ static const int timer_through_8259 = 0;
 static inline void ioapic_init_mappings(void)	{ }
 static inline void ioapic_insert_resources(void) { }
 static inline void probe_nr_irqs_gsi(void)	{ }
-static inline int mp_find_ioapic(int gsi) { return 0; }
+static inline int mp_find_ioapic(u32 gsi) { return 0; }
 
 struct io_apic_irq_attr;
 static inline int io_apic_set_pci_routing(struct device *dev, int irq,
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7e139bb..4611c43 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4238,7 +4238,7 @@ void __init ioapic_insert_resources(void)
 	}
 }
 
-int mp_find_ioapic(int gsi)
+int mp_find_ioapic(u32 gsi)
 {
 	int i = 0;
 
@@ -4253,7 +4253,7 @@ int mp_find_ioapic(int gsi)
 	return -1;
 }
 
-int mp_find_ioapic_pin(int ioapic, int gsi)
+int mp_find_ioapic_pin(int ioapic, u32 gsi)
 {
 	if (WARN_ON(ioapic == -1))
 		return -1;
-- 
1.6.5.2.143.g8cc62

