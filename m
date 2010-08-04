Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab0HDWHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 18:07:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20756 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab0HDWHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 18:07:01 -0400
Message-ID: <4C59E44E.5040800@kernel.org>
Date: Wed, 04 Aug 2010 15:06:06 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Dave Airlie <airlied@gmail.com>, Iranna D Ankad <iranna.ankad@in.ibm.com>,
        Gary Hade <garyhade@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: oops in ioapic_write_entry
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>	<AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>	<4C577197.9020003@kernel.org> <4C57723C.1060400@kernel.org>	<m1bp9k2xsg.fsf@fess.ebiederm.org> <4C57C319.8070800@kernel.org>	<m11vagw2fl.fsf@fess.ebiederm.org> <4C57CD9C.70602@kernel.org>	<m1fwywoz0f.fsf@fess.ebiederm.org> <4C57DACF.1090503@kernel.org>	<m17hk8oy5g.fsf@fess.ebiederm.org> <4C57E32A.9070401@kernel.org>	<m18w4onebi.fsf@fess.ebiederm.org> <4C5871BC.4070007@kernel.org>	<m1bp9jgyww.fsf@fess.ebiederm.org> <4C592BF5.3070008@kernel.org>	<m1mxt28tku.fsf@fess.ebiederm.org> <4C59BE0D.7020604@kernel.org> <m162zq86ck.fsf@fess.ebiederm.org>
In-Reply-To: <m162zq86ck.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C59E457.00F3,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please check if this one address your concerns.

Thanks

Yinghai

---
 arch/x86/kernel/mpparse.c |   88 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 77 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -173,17 +173,17 @@ static int __init mp_irq_mpc_intsrc_cmp(
 {
 	if (mp_irq->dstapic != m->dstapic)
 		return 1;
-	if (mp_irq->type != m->type)
+	if (mp_irq->dstirq != m->dstirq)
 		return 2;
-	if (mp_irq->irqtype != m->irqtype)
+	if (mp_irq->srcbus != m->srcbus)
 		return 3;
-	if (mp_irq->irqflag != m->irqflag)
+	if (mp_irq->type != m->type)
 		return 4;
-	if (mp_irq->srcbus != m->srcbus)
+	if (mp_irq->irqtype != m->irqtype)
 		return 5;
-	if (mp_irq->srcbusirq != m->srcbusirq)
+	if (mp_irq->irqflag != m->irqflag)
 		return 6;
-	if (mp_irq->dstirq != m->dstirq)
+	if (mp_irq->srcbusirq != m->srcbusirq)
 		return 7;
 
 	return 0;
@@ -195,9 +195,45 @@ static void __init MP_intsrc_info(struct
 
 	print_MP_intsrc_info(m);
 
+	/*
+	 *  All BUS, and IOAPIC entries are processed already
+	 */
+
+	/* check if dstapic is right */
+	for (i = 0; i < nr_ioapics; i++) {
+		if (mp_ioapics[i].apicid == m->dstapic)
+			break;
+	}
+	if (i == nr_ioapics) {
+		apic_printk(APIC_VERBOSE, "intsrc with wrong apic id is skipped\n");
+		return;
+	}
+
 	for (i = 0; i < mp_irq_entries; i++) {
-		if (!mp_irq_mpc_intsrc_cmp(&mp_irqs[i], m))
+		int ret = mp_irq_mpc_intsrc_cmp(&mp_irqs[i], m);
+
+		/* duplicated entries ? */
+		if (!ret) {
+			apic_printk(APIC_VERBOSE, "Duplicated intsrc is skipped\n");
 			return;
+		}
+
+		/* same apic/pin, but different bus */
+		if (ret == 3) {
+			/* overwrite wrong legacy one */
+			if (test_bit(mp_irqs[i].srcbus, mp_bus_not_pci) &&
+			    !test_bit(m->srcbus, mp_bus_not_pci)) {
+				apic_printk(APIC_VERBOSE, "Wrong legacy entry with same apic/pin is removed\n");
+				assign_to_mp_irq(m, &mp_irqs[i]);
+				return;
+			}
+			/* dump this legacy one */
+			if (!test_bit(mp_irqs[i].srcbus, mp_bus_not_pci) &&
+			    test_bit(m->srcbus, mp_bus_not_pci)) {
+				apic_printk(APIC_VERBOSE, "Wrong legacy entry is skipped\n");
+				return;
+			}
+		}
 	}
 
 	assign_to_mp_irq(m, &mp_irqs[mp_irq_entries]);
@@ -280,8 +316,8 @@ static int __init smp_read_mpc(struct mp
 	char str[16];
 	char oem[10];
 
-	int count = sizeof(*mpc);
-	unsigned char *mpt = ((unsigned char *)mpc) + count;
+	int count;
+	unsigned char *mpt;
 
 	if (!smp_check_mpc(mpc, oem, str))
 		return 0;
@@ -305,8 +341,9 @@ static int __init smp_read_mpc(struct mp
 	/*
 	 *      Now process the configuration blocks.
 	 */
+	count = sizeof(*mpc);
+	mpt = ((unsigned char *)mpc) + count;
 	x86_init.mpparse.mpc_record(0);
-
 	while (count < mpc->length) {
 		switch (*mpt) {
 		case MP_PROCESSOR:
@@ -324,7 +361,7 @@ static int __init smp_read_mpc(struct mp
 			skip_entry(&mpt, &count, sizeof(struct mpc_ioapic));
 			break;
 		case MP_INTSRC:
-			MP_intsrc_info((struct mpc_intsrc *)mpt);
+			/* check that next pass */
 			skip_entry(&mpt, &count, sizeof(struct mpc_intsrc));
 			break;
 		case MP_LINTSRC:
@@ -337,6 +374,35 @@ static int __init smp_read_mpc(struct mp
 			count = mpc->length;
 			break;
 		}
+		x86_init.mpparse.mpc_record(1);
+	}
+
+	/* second pass for INTSRC */
+	count = sizeof(*mpc);
+	mpt = ((unsigned char *)mpc) + count;
+	x86_init.mpparse.mpc_record(0);
+	while (count < mpc->length) {
+		switch (*mpt) {
+		case MP_PROCESSOR:
+			skip_entry(&mpt, &count, sizeof(struct mpc_cpu));
+			break;
+		case MP_BUS:
+			skip_entry(&mpt, &count, sizeof(struct mpc_bus));
+			break;
+		case MP_IOAPIC:
+			skip_entry(&mpt, &count, sizeof(struct mpc_ioapic));
+			break;
+		case MP_INTSRC:
+			MP_intsrc_info((struct mpc_intsrc *)mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_intsrc));
+			break;
+		case MP_LINTSRC:
+			skip_entry(&mpt, &count, sizeof(struct mpc_lintsrc));
+			break;
+		default:
+			count = mpc->length;
+			break;
+		}
 		x86_init.mpparse.mpc_record(1);
 	}
 
