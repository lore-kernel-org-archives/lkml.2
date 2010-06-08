Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab0FHSon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 14:44:43 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43791 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab0FHSom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 14:44:42 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
References: <1275952044-27996-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<m1631ue5ho.fsf@fess.ebiederm.org> <4C0D8F43.4070900@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 08 Jun 2010 11:44:32 -0700
In-Reply-To: <4C0D8F43.4070900@zytor.com> (H. Peter Anvin's message of "Mon\, 07 Jun 2010 17\:30\:59 -0700")
Message-ID: <m17hm9jre7.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: hpa@zytor.com, len.brown@intel.com, feng.tang@intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org, arjan@linux.intel.com, alan@linux.intel.com, jacob.jun.pan@linux.intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 XMBrknScrpt_02 Possible Broken Spam Script
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH] x86/irq: Rename gsi_end gsi_top, and fix off by one errors
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When I introduced the global variable gsi_end I thought gsi_end on
io_apics was one past the end of the gsi range for the io_apic.  After
it was pointed out the the range on io_apics was inclusive I changed
my global variable to match.  That was a big mistake.  Inclusive
semantics without a range start cannot describe the case when no gsi's
are allocated.  Describing the case where no gsi's are allocated is
important in sfi.c and mpparse.c so that we can assign gsi numbers
instead of blindly copying the gsi assignments the BIOS has done as we
do in the acpi case.

To keep from getting the global variable confused with the gsi range
end rename it gsi_top.

To allow describing the case where no gsi's are allocated have gsi_top
be one place the highest gsi number seen in the system.

This fixes an off by one bug in sfi.c:
Reported-by: jacob pan <jacob.jun.pan@linux.intel.com>

This fixes the same off by one bug in mpparse.c:

This fixes an off unreachable by one bug in acpi/boot.c:irq_to_gsi
Reported-by: Yinghai <yinghai.lu@oracle.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/include/asm/io_apic.h |    4 ++--
 arch/x86/kernel/acpi/boot.c    |    8 ++++----
 arch/x86/kernel/apic/io_apic.c |   12 ++++++------
 arch/x86/kernel/mpparse.c      |    2 +-
 arch/x86/kernel/sfi.c          |    2 +-
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 63cb409..9cb2edb 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -183,7 +183,7 @@ struct mp_ioapic_gsi{
 	u32 gsi_end;
 };
 extern struct mp_ioapic_gsi  mp_gsi_routing[];
-extern u32 gsi_end;
+extern u32 gsi_top;
 int mp_find_ioapic(u32 gsi);
 int mp_find_ioapic_pin(int ioapic, u32 gsi);
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
@@ -197,7 +197,7 @@ static const int timer_through_8259 = 0;
 static inline void ioapic_init_mappings(void)	{ }
 static inline void ioapic_insert_resources(void) { }
 static inline void probe_nr_irqs_gsi(void)	{ }
-#define gsi_end (NR_IRQS_LEGACY - 1)
+#define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
 
 struct io_apic_irq_attr;
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 60cc405..c05872a 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -118,7 +118,7 @@ static unsigned int gsi_to_irq(unsigned int gsi)
 	if (gsi >= NR_IRQS_LEGACY)
 		irq = gsi;
 	else
-		irq = gsi_end + 1 + gsi;
+		irq = gsi_top + gsi;
 
 	return irq;
 }
@@ -129,10 +129,10 @@ static u32 irq_to_gsi(int irq)
 
 	if (irq < NR_IRQS_LEGACY)
 		gsi = isa_irq_to_gsi[irq];
-	else if (irq <= gsi_end)
+	else if (irq < gsi_top)
 		gsi = irq;
-	else if (irq <= (gsi_end + NR_IRQS_LEGACY))
-		gsi = irq - gsi_end;
+	else if (irq < (gsi_top + NR_IRQS_LEGACY))
+		gsi = irq - gsi_top;
 	else
 		gsi = 0xffffffff;
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 33f3563..e41ed24 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -89,8 +89,8 @@ int nr_ioapics;
 /* IO APIC gsi routing info */
 struct mp_ioapic_gsi  mp_gsi_routing[MAX_IO_APICS];
 
-/* The last gsi number used */
-u32 gsi_end;
+/* The one past the highest gsi number used */
+u32 gsi_top;
 
 /* MP IRQ source entries */
 struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
@@ -1035,7 +1035,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 		if (gsi >= NR_IRQS_LEGACY)
 			irq = gsi;
 		else
-			irq = gsi_end + 1 + gsi;
+			irq = gsi_top + gsi;
 	}
 
 #ifdef CONFIG_X86_32
@@ -3853,7 +3853,7 @@ void __init probe_nr_irqs_gsi(void)
 {
 	int nr;
 
-	nr = gsi_end + 1 + NR_IRQS_LEGACY;
+	nr = gsi_top + NR_IRQS_LEGACY;
 	if (nr > nr_irqs_gsi)
 		nr_irqs_gsi = nr;
 
@@ -4294,8 +4294,8 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	 */
 	nr_ioapic_registers[idx] = entries;
 
-	if (mp_gsi_routing[idx].gsi_end > gsi_end)
-		gsi_end = mp_gsi_routing[idx].gsi_end;
+	if (mp_gsi_routing[idx].gsi_end >= gsi_top)
+		gsi_top = mp_gsi_routing[idx].gsi_end + 1;
 
 	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
 	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 5ae5d24..d86dbf7 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -123,7 +123,7 @@ static void __init MP_ioapic_info(struct mpc_ioapic *m)
 	printk(KERN_INFO "I/O APIC #%d Version %d at 0x%X.\n",
 	       m->apicid, m->apicver, m->apicaddr);
 
-	mp_register_ioapic(m->apicid, m->apicaddr, gsi_end + 1);
+	mp_register_ioapic(m->apicid, m->apicaddr, gsi_top);
 }
 
 static void print_MP_intsrc_info(struct mpc_intsrc *m)
diff --git a/arch/x86/kernel/sfi.c b/arch/x86/kernel/sfi.c
index 7ded578..cb22acf 100644
--- a/arch/x86/kernel/sfi.c
+++ b/arch/x86/kernel/sfi.c
@@ -93,7 +93,7 @@ static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 	pentry = (struct sfi_apic_table_entry *)sb->pentry;
 
 	for (i = 0; i < num; i++) {
-		mp_register_ioapic(i, pentry->phys_addr, gsi_end + 1);
+		mp_register_ioapic(i, pentry->phys_addr, gsi_top);
 		pentry++;
 	}
 
-- 
1.6.5.2.143.g8cc62

