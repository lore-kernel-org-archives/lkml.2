Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab0KYRoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:44:21 -0500
Received: from www.tglx.de ([62.245.132.106]:50957 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab0KYRoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:44:19 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 10/11] x86/io_apic: add simply id set
Date: Thu, 25 Nov 2010 18:40:00 +0100
Message-Id: <1290706801-7323-11-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one goes through the registered IO-APICs and sets the id which the
core code is using.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: x86@kernel.org
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/apic/io_apic.c |   44 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index dc1169f..c920657 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -170,6 +170,7 @@ extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 
 extern int get_nr_irqs_gsi(void);
 extern void setup_ioapic_ids_from_mpc(void);
+void setup_ioapic_ids_from_apicid(void);
 
 struct mp_ioapic_gsi{
 	u32 gsi_base;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 27a5709..74cfe9b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2047,6 +2047,50 @@ void __init setup_ioapic_ids_from_mpc(void)
 			apic_printk(APIC_VERBOSE, " ok.\n");
 	}
 }
+/*
+ * We assume here that the ids in mp_ioapics are correct but not yet
+ * written to the ioapic. While doing so we verify that those ids are
+ * unique.
+ */
+static __initdata DECLARE_BITMAP(apic_id_mask, MAX_APICS);
+void __init setup_ioapic_ids_from_apicid(void)
+{
+	union IO_APIC_reg_00 reg_00;
+	int apic_id;
+	unsigned long flags;
+
+	for (apic_id = 0; apic_id < nr_ioapics; apic_id++) {
+
+		if (mp_ioapics[apic_id].apicid > MAX_APICS) {
+			WARN_ON(1);
+			continue;
+		}
+
+		if (test_bit(mp_ioapics[apic_id].apicid, apic_id_mask)) {
+			WARN_ON(1);
+			continue;
+		}
+
+		set_bit(mp_ioapics[apic_id].apicid, apic_id_mask);
+
+		raw_spin_lock_irqsave(&ioapic_lock, flags);
+		reg_00.raw = io_apic_read(apic_id, 0);
+		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+
+		if (reg_00.bits.ID == mp_ioapics[apic_id].apicid)
+			continue;
+
+		reg_00.bits.ID = mp_ioapics[apic_id].apicid;
+		raw_spin_lock_irqsave(&ioapic_lock, flags);
+		io_apic_write(apic_id, 0, reg_00.raw);
+		reg_00.raw = io_apic_read(apic_id, 0);
+		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+
+		if (reg_00.bits.ID != mp_ioapics[apic_id].apicid)
+			printk(KERN_ERR "Could not update id of IOAPIC %d\n",
+					mp_ioapics[apic_id].apicid);
+	}
+}
 #endif
 
 int no_timer_check __initdata;
-- 
1.7.3.2

