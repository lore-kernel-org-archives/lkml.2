Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab0C2XVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 19:21:48 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44113 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab0C2XU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 19:20:57 -0400
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
Subject: [PATCH 14/14] x86 irq: Kill io_apic_renumber_irq
Date: Mon, 29 Mar 2010 16:20:25 -0700
Message-Id: <1269904825-27462-14-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1r5n2wwah.fsf_-_@fess.ebiederm.org>
References: <m1r5n2wwah.fsf_-_@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu, akpm@linux-foundation.org, jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org, trenn@suse.de, suresh.b.siddha@intel.com, len.brown@intel.com, tony.luck@intel.com, fenghua.yu@intel.com, linux-acpi@vger.kernel.org, iranna.ankad@in.ibm.com, garyhade@us.ibm.com, protasnb@gmail.com, ebiederm@xmission.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that the generic irq layer is performing the exact same remapping as
io_apic_renumber_irq we can kill this weird  es7000 specific function.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/include/asm/io_apic.h   |    1 -
 arch/x86/kernel/acpi/boot.c      |    5 -----
 arch/x86/kernel/apic/es7000_32.c |   19 -------------------
 arch/x86/kernel/apic/io_apic.c   |    6 ------
 4 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 37b0f2b..9da192a 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -159,7 +159,6 @@ struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
 void setup_IO_APIC_irq_extra(u32 gsi);
-extern int (*ioapic_renumber_irq)(int ioapic, int irq);
 extern void ioapic_init_mappings(void);
 extern void ioapic_insert_resources(void);
 
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index b372aba..a48dfa9 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1116,11 +1116,6 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 
 	ioapic_pin = mp_find_ioapic_pin(ioapic, gsi);
 
-#ifdef CONFIG_X86_32
-	if (ioapic_renumber_irq)
-		gsi = ioapic_renumber_irq(ioapic, gsi);
-#endif
-
 	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
 		printk(KERN_ERR "Invalid reference to IOAPIC pin "
 		       "%d-%d\n", mp_ioapics[ioapic].apicid,
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index dd2b5f2..7a63d47 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -130,24 +130,6 @@ int					es7000_plat;
 
 static unsigned int			base;
 
-static int
-es7000_rename_gsi(int ioapic, int gsi)
-{
-	if (es7000_plat == ES7000_ZORRO)
-		return gsi;
-
-	if (!base) {
-		int i;
-		for (i = 0; i < nr_ioapics; i++)
-			base += nr_ioapic_registers[i];
-	}
-
-	if (!ioapic && (gsi < 16))
-		gsi += base;
-
-	return gsi;
-}
-
 static int __cpuinit wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
 {
 	unsigned long vect = 0, psaival = 0;
@@ -189,7 +171,6 @@ static void setup_unisys(void)
 		es7000_plat = ES7000_ZORRO;
 	else
 		es7000_plat = ES7000_CLASSIC;
-	ioapic_renumber_irq = es7000_rename_gsi;
 }
 
 /*
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f2c26d2..df7dcb3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1015,7 +1015,6 @@ static inline int irq_trigger(int idx)
 	return MPBIOS_trigger(idx);
 }
 
-int (*ioapic_renumber_irq)(int ioapic, int irq);
 static int pin_2_irq(int idx, int apic, int pin)
 {
 	int irq;
@@ -1031,11 +1030,6 @@ static int pin_2_irq(int idx, int apic, int pin)
 		irq = mp_irqs[idx].srcbusirq;
 	} else {
 		u32 gsi = mp_gsi_routing[apic].gsi_base + pin;
-		/*
-                 * For MPS mode, so far only needed by ES7000 platform
-                 */
-		if (ioapic_renumber_irq)
-			gsi = ioapic_renumber_irq(apic, gsi);
 
 		if (gsi >= NR_IRQS_LEGACY)
 			irq = gsi;
-- 
1.6.5.2.143.g8cc62

