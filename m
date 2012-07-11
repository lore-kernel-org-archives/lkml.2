Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369Ab2GKS1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 14:27:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:28630 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758321Ab2GKS1j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 14:27:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="164414236"
From: "Iyer, Sundar" <sundar.iyer@intel.com>
To: "tglx@linutronix.de" <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "Monroy, German" <german.monroy@intel.com>
Subject: RE: [PATCH v4] x86/irq: handle chained interrupts during IRQ
 migration
Thread-Topic: [PATCH v4] x86/irq: handle chained interrupts during IRQ
 migration
Thread-Index: AQHNWo8pRI3b4Oohx0CIWSyJSCrqQJckcHGA
Date: Wed, 11 Jul 2012 18:27:34 +0000
Message-ID: <2FABAEF0D3DCAF4F9C9628D6E2F96845223BB5@BGSMSX102.gar.corp.intel.com>
References: <1341479776-12328-1-git-send-email-sundar.iyer@intel.com>
In-Reply-To: <1341479776-12328-1-git-send-email-sundar.iyer@intel.com>
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

Any status on this one?

Cheers!

>-----Original Message-----
>From: Iyer, Sundar
>Sent: Thursday, July 05, 2012 2:46 PM
>To: tglx@linutronix.de
>Cc: linux-kernel@vger.kernel.org; arjan@linux.intel.com; lethal@linux-sh.org; Iyer,
>Sundar; Monroy, German
>Subject: [PATCH v4] x86/irq: handle chained interrupts during IRQ migration
>
>Chained interrupt handlers dont have an irqaction and hence are not handled during
>migrating interrupts when some cores go offline.
>
>Handle this by introducing a irq_is_chained() check which is based on the the CHAINED
>flag being set for such interrupts. fixup_irq() can then handle such interrupts and not
>skip them over.
>
>---
>v1: use accessors instead of new variables to identify chained irqs
>v2: use a mask of NOREQUEST, NOPROBE, and NOTHREAD accessor flags as per
>Paul M
>v3: use a new accessor called IRQ_CHAINED instead of the mask in v2
>v4: rebase against tip/irq/core branch
>
>Signed-off-by: Sundar Iyer <sundar.iyer@intel.com>
>Reviewed-by: Yang, Fei <fei.yang@intel.com>
>Tested-by: Ng, Cheon-woei <cheon-woei.ng@intel.com>
>---
> arch/x86/kernel/irq.c   |   10 ++++++----
> include/linux/irq.h     |    1 +
> include/linux/irqdesc.h |    7 +++++++
> kernel/irq/chip.c       |    1 +
> kernel/irq/settings.h   |    8 ++++++++
> 5 files changed, 23 insertions(+), 4 deletions(-)
>
>diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c index 3dafc60..352de40 100644
>--- a/arch/x86/kernel/irq.c
>+++ b/arch/x86/kernel/irq.c
>@@ -255,10 +255,12 @@ void fixup_irqs(void)
>
> 		data = irq_desc_get_irq_data(desc);
> 		affinity = data->affinity;
>-		if (!irq_has_action(irq) || irqd_is_per_cpu(data) ||
>-		    cpumask_subset(affinity, cpu_online_mask)) {
>-			raw_spin_unlock(&desc->lock);
>-			continue;
>+		/* include IRQs who have no action, but are chained */
>+		if ((!irq_has_action(irq) && !irq_is_chained(irq)) ||
>+			irqd_is_per_cpu(data) ||
>+			cpumask_subset(affinity, cpu_online_mask)) {
>+				raw_spin_unlock(&desc->lock);
>+				continue;
> 		}
>
> 		/*
>diff --git a/include/linux/irq.h b/include/linux/irq.h index 61f5cec..531fa31 100644
>--- a/include/linux/irq.h
>+++ b/include/linux/irq.h
>@@ -97,6 +97,7 @@ enum {
> 	IRQ_NESTED_THREAD	= (1 << 15),
> 	IRQ_NOTHREAD		= (1 << 16),
> 	IRQ_PER_CPU_DEVID	= (1 << 17),
>+	IRQ_CHAINED		= (1 << 18),
> };
>
> #define IRQF_MODIFY_MASK	\
>diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h index f1e2527..785d608
>100644
>--- a/include/linux/irqdesc.h
>+++ b/include/linux/irqdesc.h
>@@ -123,6 +123,13 @@ static inline int irq_has_action(unsigned int irq)
> 	return desc->action != NULL;
> }
>
>+/* Test to see if the IRQ is chained */ static inline int
>+irq_is_chained(unsigned int irq) {
>+	struct irq_desc *desc = irq_to_desc(irq);
>+	return desc->status_use_accessors & IRQ_CHAINED; }
>+
> /* caller has locked the irq_desc and both params are valid */  static inline void
>__irq_set_handler_locked(unsigned int irq,
> 					    irq_flow_handler_t handler)
>diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c index eebd6d5..41e0208 100644
>--- a/kernel/irq/chip.c
>+++ b/kernel/irq/chip.c
>@@ -657,6 +657,7 @@ __irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int
>is_chained,
> 		irq_settings_set_noprobe(desc);
> 		irq_settings_set_norequest(desc);
> 		irq_settings_set_nothread(desc);
>+		irq_settings_set_chained(desc);
> 		irq_startup(desc, true);
> 	}
> out:
>diff --git a/kernel/irq/settings.h b/kernel/irq/settings.h index 1162f10..bb8e167 100644
>--- a/kernel/irq/settings.h
>+++ b/kernel/irq/settings.h
>@@ -15,6 +15,7 @@ enum {
> 	_IRQ_NESTED_THREAD	= IRQ_NESTED_THREAD,
> 	_IRQ_PER_CPU_DEVID	= IRQ_PER_CPU_DEVID,
> 	_IRQF_MODIFY_MASK	= IRQF_MODIFY_MASK,
>+	_IRQ_CHAINED		= IRQ_CHAINED,
> };
>
> #define IRQ_PER_CPU		GOT_YOU_MORON
>@@ -28,6 +29,7 @@ enum {
> #define IRQ_PER_CPU_DEVID	GOT_YOU_MORON
> #undef IRQF_MODIFY_MASK
> #define IRQF_MODIFY_MASK	GOT_YOU_MORON
>+#define IRQ_CHAINED		GOT_YOU_MORON
>
> static inline void
> irq_settings_clr_and_set(struct irq_desc *desc, u32 clr, u32 set) @@ -147,3 +149,9 @@
>static inline bool irq_settings_is_nested_thread(struct irq_desc *desc)  {
> 	return desc->status_use_accessors & _IRQ_NESTED_THREAD;  }
>+
>+static inline bool irq_settings_set_chained(struct irq_desc *desc) {
>+	return desc->status_use_accessors |= _IRQ_CHAINED; }
>+
>--
>1.7.0.4

