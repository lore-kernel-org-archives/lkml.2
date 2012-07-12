Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161246Ab2GLPkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 11:40:39 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:34955
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161233Ab2GLPkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 11:40:33 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -12
X-BigFish: VPS-12(zz98dI1432Izz1202hzz15d4R8275bh8275dhz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M720VB-02-314-02
X-M-MSG: 
Date: Thu, 12 Jul 2012 17:40:31 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 01/27] x86/irq: Add data structure to keep AMD specific
 irq remapping information
Message-ID: <20120712154031.GA4213@amd.com>
References: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
 <1342013952-10174-2-git-send-email-joerg.roedel@amd.com>
 <CAE9FiQUEYVMi46WYfLDDUO=PuTHYbmqXreZnCWLRdUjBH2iH4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAE9FiQUEYVMi46WYfLDDUO=PuTHYbmqXreZnCWLRdUjBH2iH4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 02:42:03PM -0700, Yinghai Lu wrote:
> >  #ifdef CONFIG_IRQ_REMAP
> > -       struct irq_2_iommu      irq_2_iommu;
> > +       union irq_remap_info    irq_remap_info;
> 
> how about
> +union {
> +       struct irq_2_iommu irq_2_iommu;
> +       struct irq_2_irte  irq_2_irte;
> +};
> 
> instead?

Yes, that is better. I updated the patch (and 4-5 more patches in the
series to adapt them to this data structure change). I will update the
branch on my tree today and push the version with this change included.
Here is the new patch:

>From a0fd5f10f015629592adc28cb9b79d61d0ba1bfb Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Tue, 19 Jun 2012 16:07:45 +0200
Subject: [PATCH 01/27] x86/irq: Add data structure to keep AMD specific irq
 remapping information

Add a data structure to store information the IOMMU driver
can use to get from a 'struct irq_cfg' to the remapping
entry.

Cc: x86@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/hw_irq.h |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index eb92a6e..fc89a2a 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -101,6 +101,7 @@ static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
 	irq_attr->polarity	= polarity;
 }
 
+/* Intel specific interrupt remapping information */
 struct irq_2_iommu {
 	struct intel_iommu *iommu;
 	u16 irte_index;
@@ -108,6 +109,12 @@ struct irq_2_iommu {
 	u8  irte_mask;
 };
 
+/* AMD specific interrupt remapping information */
+struct irq_2_irte {
+	u16 devid; /* Device ID for IRTE table */
+	u16 index; /* Index into IRTE table*/
+};
+
 /*
  * This is performance-critical, we want to do it O(1)
  *
@@ -120,7 +127,10 @@ struct irq_cfg {
 	u8			vector;
 	u8			move_in_progress : 1;
 #ifdef CONFIG_IRQ_REMAP
-	struct irq_2_iommu	irq_2_iommu;
+	union {
+		struct irq_2_iommu irq_2_iommu;
+		struct irq_2_irte  irq_2_irte;
+	};
 #endif
 };
 
-- 
1.7.9.5


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

