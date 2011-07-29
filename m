Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1G2Wea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 18:34:30 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:52044 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab1G2We2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 18:34:28 -0400
Message-ID: <4E333559.1050001@kernel.org>
Date: Fri, 29 Jul 2011 15:34:01 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] x86, ioapic: Passing irq_attr struct pointer with setup_ioapic_irq()
References: <4E1F0BC9.1040102@kernel.org> <CAErSpo5CzU2j81moWLsHDoRxTs5107=AEAWYi3ezy3Xfw86qiQ@mail.gmail.com> <4E29BEEA.4020600@kernel.org> <20110725072831.GB22518@elte.hu> <4E33334D.1030007@kernel.org>
In-Reply-To: <4E33334D.1030007@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090206.4E333564.0017,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Do not expand that struct, and just pass pointer to reduce the parameters in related
functions.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -1324,8 +1324,8 @@ static int setup_ioapic_entry(int apic_i
 	return 0;
 }
 
-static void setup_ioapic_irq(int apic_id, int pin, unsigned int irq,
-			     struct irq_cfg *cfg, int trigger, int polarity)
+static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
+				struct io_apic_irq_attr *attr)
 {
 	struct IO_APIC_route_entry entry;
 	unsigned int dest;
@@ -1348,23 +1348,24 @@ static void setup_ioapic_irq(int apic_id
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
 		    "IRQ %d Mode:%i Active:%i Dest:%d)\n",
-		    apic_id, mpc_ioapic_id(apic_id), pin, cfg->vector,
-		    irq, trigger, polarity, dest);
+		    attr->ioapic, mpc_ioapic_id(attr->ioapic), attr->ioapic_pin,
+		    cfg->vector, irq, attr->trigger, attr->polarity, dest);
 
 
-	if (setup_ioapic_entry(mpc_ioapic_id(apic_id), irq, &entry,
-			       dest, trigger, polarity, cfg->vector, pin)) {
+	if (setup_ioapic_entry(mpc_ioapic_id(attr->ioapic), irq, &entry,
+			       dest, attr->trigger, attr->polarity, cfg->vector,
+			       attr->ioapic_pin)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
-		       mpc_ioapic_id(apic_id), pin);
+		       mpc_ioapic_id(attr->ioapic), attr->ioapic_pin);
 		__clear_irq_vector(irq, cfg);
 		return;
 	}
 
-	ioapic_register_intr(irq, cfg, trigger);
+	ioapic_register_intr(irq, cfg, attr->trigger);
 	if (irq < legacy_pic->nr_legacy_irqs)
 		legacy_pic->mask(irq);
 
-	ioapic_write_entry(apic_id, pin, entry);
+	ioapic_write_entry(attr->ioapic, attr->ioapic_pin, entry);
 }
 
 static bool __init io_apic_pin_not_connected(int idx, int apic_id, int pin)
@@ -3566,8 +3567,7 @@ io_apic_setup_irq_pin(unsigned int irq,
 		return -EINVAL;
 	ret = __add_pin_to_irq_node(cfg, node, attr->ioapic, attr->ioapic_pin);
 	if (!ret)
-		setup_ioapic_irq(attr->ioapic, attr->ioapic_pin, irq, cfg,
-				 attr->trigger, attr->polarity);
+		setup_ioapic_irq(irq, cfg, attr);
 	return ret;
 }
 
