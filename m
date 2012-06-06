Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab2FFRw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:52:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:63532 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab2FFRwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:52:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="152460033"
From: "Iyer, Sundar" <sundar.iyer@intel.com>
To: "tglx@linutronix.de" <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Monroy, German" <german.monroy@intel.com>
Subject: RE: [PATCH v2] x86/irq: handle chained interrupts during IRQ
 migration
Thread-Topic: [PATCH v2] x86/irq: handle chained interrupts during IRQ
 migration
Thread-Index: AQHNPkQDApkIwRsebESeNTDprZRGRpbtnVkQ
Date: Wed, 6 Jun 2012 17:52:21 +0000
Message-ID: <2FABAEF0D3DCAF4F9C9628D6E2F968451D8329@BGSMSX102.gar.corp.intel.com>
References: <1338370137-18929-1-git-send-email-sundar.iyer@intel.com>
In-Reply-To: <1338370137-18929-1-git-send-email-sundar.iyer@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Any comments on this version? Or do you suggest to add a new flag in the accessors and set it?

Thanks

>-----Original Message-----
>From: Iyer, Sundar
>Sent: Wednesday, May 30, 2012 2:59 PM
>To: tglx@linutronix.de
>Cc: linux-kernel@vger.kernel.org; lethal@linux-sh.org; arjan@linux.intel.com; Iyer,
>Sundar; Monroy, German
>Subject: [PATCH v2] x86/irq: handle chained interrupts during IRQ migration
>
>Chained interrupt handlers dont have an irqaction and hence are not handled during
>migrating interrupts when some cores go offline.
>
>Handle this by introducing a irq_is_chained() check which is based on the the very least
>NOREQUEST, NOPROBE, and NOTHREAD flags being set for such interrupts.
>fixup_irq() can then handle such interrupts and not skip them over.
>
>Change-Id: I011de8bee98c1702a362deb06106845ca7bcad61
>Signed-off-by: Sundar Iyer <sundar.iyer@intel.com>
>---
>v1: use accessors instead of new variables to identify chained irqs
>v2: use a mask of NOREQUEST, NOPROBE, and NOTHREAD accessor flags as per
>Paul M
>
> arch/x86/kernel/irq.c   |    6 ++++--
> include/linux/irqdesc.h |   11 +++++++++++
> 2 files changed, 15 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c index 6c0802e..acd7949 100644
>--- a/arch/x86/kernel/irq.c
>+++ b/arch/x86/kernel/irq.c
>@@ -249,8 +249,10 @@ void fixup_irqs(void)
>
> 		data = irq_desc_get_irq_data(desc);
> 		affinity = data->affinity;
>-		if (!irq_has_action(irq) || irqd_is_per_cpu(data) ||
>-		    cpumask_subset(affinity, cpu_online_mask)) {
>+		/* include IRQs who have no action, but are chained */
>+		if ((!irq_has_action(irq) && irq_is_chained(irq)) ||
>+			irqd_is_per_cpu(data) ||
>+			cpumask_subset(affinity, cpu_online_mask)) {
> 			raw_spin_unlock(&desc->lock);
> 			continue;
> 		}
>diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h index 2d921b3..8d5eb42
>100644
>--- a/include/linux/irqdesc.h
>+++ b/include/linux/irqdesc.h
>@@ -120,6 +120,17 @@ static inline int irq_has_action(unsigned int irq)
> 	return desc->action != NULL;
> }
>
>+/*
>+ * Test to see if the IRQ is chained; it would not be requested and
>+hence
>+ * very miinimum _IRQ_NOREQUEST, _IRQ_NOPROBE, _IRQ_NOTHREAD  would be
>+set  */ static inline int irq_is_chained(unsigned int irq) {
>+	struct irq_desc *desc = irq_to_desc(irq);
>+	return !(desc->status_use_accessors &
>+			(IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOTHREAD)); }
>+
> /* caller has locked the irq_desc and both params are valid */  static inline void
>__irq_set_handler_locked(unsigned int irq,
> 					    irq_flow_handler_t handler)
>--
>1.7.1

