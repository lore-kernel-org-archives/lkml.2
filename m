Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1GVSSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 14:18:51 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:52473 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab1GVSSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 14:18:50 -0400
Message-ID: <4E29BEEA.4020600@kernel.org>
Date: Fri, 22 Jul 2011 11:18:18 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] x86, ioapic: Print out irte  with right ioapic index
References: <4E1F0BC9.1040102@kernel.org> <CAErSpo5CzU2j81moWLsHDoRxTs5107=AEAWYi3ezy3Xfw86qiQ@mail.gmail.com>
In-Reply-To: <CAErSpo5CzU2j81moWLsHDoRxTs5107=AEAWYi3ezy3Xfw86qiQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E29BEF5.0173,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While checking irte dump in dmesg, the print out is confused ioapic index
and real io apic id.

IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000001 SID:00FF SQ:0 SVT:1)
IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000001 SID:00FF SQ:0 SVT:1)

The system first ioapic id is 1.

Try to fix it with passing ioapic idx instead of phys apic id.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1255,7 +1255,7 @@ static void ioapic_register_intr(unsigne
 				      fasteoi ? "fasteoi" : "edge");
 }
 
-static int setup_ioapic_entry(int apic_id, int irq,
+static int setup_ioapic_entry(int ioapic, int irq,
 			      struct IO_APIC_route_entry *entry,
 			      unsigned int destination, int trigger,
 			      int polarity, int vector, int pin)
@@ -1266,6 +1266,7 @@ static int setup_ioapic_entry(int apic_i
 	memset(entry,0,sizeof(*entry));
 
 	if (intr_remapping_enabled) {
+		int apic_id = mpc_ioapic_id(ioapic);
 		struct intel_iommu *iommu = map_ioapic_to_ir(apic_id);
 		struct irte irte;
 		struct IR_IO_APIC_route_entry *ir_entry =
@@ -1301,7 +1302,7 @@ static int setup_ioapic_entry(int apic_i
 			"Redir_hint:%d Trig_Mode:%d Dlvry_Mode:%X "
 			"Avail:%X Vector:%02X Dest:%08X "
 			"SID:%04X SQ:%X SVT:%X)\n",
-			apic_id, irte.present, irte.fpd, irte.dst_mode,
+			ioapic, irte.present, irte.fpd, irte.dst_mode,
 			irte.redir_hint, irte.trigger_mode, irte.dlvry_mode,
 			irte.avail, irte.vector, irte.dest_id,
 			irte.sid, irte.sq, irte.svt);
@@ -1352,7 +1353,7 @@ static void setup_ioapic_irq(int apic_id
 		    irq, trigger, polarity, dest);
 
 
-	if (setup_ioapic_entry(mpc_ioapic_id(apic_id), irq, &entry,
+	if (setup_ioapic_entry(apic_id, irq, &entry,
 			       dest, trigger, polarity, cfg->vector, pin)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mpc_ioapic_id(apic_id), pin);
