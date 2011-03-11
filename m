Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1CKUi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:38:56 -0500
Received: from www.tglx.de ([62.245.132.106]:37100 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab1CKUiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:38:54 -0500
Date: Fri, 11 Mar 2011 21:37:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
cc: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Qualcomm PM8921 MFD v2 2/6] mfd: pm8xxx: Add irq support
In-Reply-To: <4D7A80DD.7000909@codeaurora.org>
Message-ID: <alpine.LFD.2.00.1103112112310.2787@localhost6.localdomain6>
References: <1299564590-30116-1-git-send-email-adharmap@codeaurora.org> <1299564590-30116-3-git-send-email-adharmap@codeaurora.org> <alpine.LFD.2.00.1103081201520.2787@localhost6.localdomain6> <4D770E47.6050402@codeaurora.org>
 <alpine.LFD.2.00.1103101126100.2787@localhost6.localdomain6> <4D79A85D.8000301@codeaurora.org> <alpine.LFD.2.00.1103111853480.2787@localhost6.localdomain6> <4D7A71B9.9000306@codeaurora.org> <alpine.LFD.2.00.1103112020370.2787@localhost6.localdomain6>
 <4D7A80DD.7000909@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011, Abhijeet Dharmapurikar wrote:
> Thomas Gleixner wrote:
> > Simply because this kind of misdesigned hardware will creep up over
> > and over and we want to handle these cases in the core. Even for a
> > sinlge instance like yours solving it in the core is the right thing
> > to do, because it's a ~3 lines patch to the core code to get this
> > done.
> 
> ~3 lines patch to the code sounds promising. Please tell me how?

So I deduce, that your HW has no way to mark the wakeup
interrupts. Whack your HW designer on my behalf, please! :)

Patch below against:

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq/core

It's 8 lines, but that's still at least an order of magnitude less
than solving this with an workaround. :)

Thanks,

	tglx

---------->
Subject: genirq-force-mask-on-suspend.patch
From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 11 Mar 2011 21:22:14 +0100

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |    2 ++
 kernel/irq/pm.c     |   14 ++++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -330,10 +330,12 @@ struct irq_chip {
  *
  * IRQCHIP_SET_TYPE_MASKED:	Mask before calling chip.irq_set_type()
  * IRQCHIP_EOI_IF_HANDLED:	Only issue irq_eoi() when irq was handled
+ * IRQCHIP_MASK_ON_SUSPEND:	Mask non wake irqs in the suspend path
  */
 enum {
 	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
 	IRQCHIP_EOI_IF_HANDLED		= (1 <<  1),
+	IRQCHIP_MASK_ON_SUSPEND		= (2 <<  1),
 };
 
 /* This include will go away once we isolated irq_desc usage to core code */
Index: linux-2.6-tip/kernel/irq/pm.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/pm.c
+++ linux-2.6-tip/kernel/irq/pm.c
@@ -68,10 +68,16 @@ int check_wakeup_irqs(void)
 	struct irq_desc *desc;
 	int irq;
 
-	for_each_irq_desc(irq, desc)
-		if (irqd_is_wakeup_set(&desc->irq_data) &&
-		    (desc->istate & IRQS_PENDING))
-			return -EBUSY;
+	for_each_irq_desc(irq, desc) {
+		if (irqd_is_wakeup_set(&desc->irq_data)) {
+			if (desc->istate & IRQS_PENDING)
+				return -EBUSY;
+			continue;
+		}
+		if (desc->istate & IRQS_SUSPENDED &&
+		    irq_desc_get_chip(desc)->flags & IRQCHIP_MASK_ON_SUSPEND)
+			mask_irq(desc);
+	}
 
 	return 0;
 }
