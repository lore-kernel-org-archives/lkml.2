Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab1CJI5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:57:39 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:45771 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1CJI5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:57:38 -0500
X-IronPort-AV: E=Sophos;i="4.62,295,1297036800"; 
   d="scan'208";a="4713833"
Subject: Re: [PATCH 12/14] xen: events: remove use of nr_irqs as upper
 bound on number of pirqs
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110310053305.GD10574@dumpdata.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
	 <1299692486-28634-12-git-send-email-ian.campbell@citrix.com>
	 <20110310053305.GD10574@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 10 Mar 2011 08:57:36 +0000
Message-ID: <1299747456.17339.734.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 05:33 +0000, Konrad Rzeszutek Wilk wrote:
> >  int xen_irq_from_pirq(unsigned pirq)
> >  {
> > -	return pirq_to_irq[pirq];
> > +	int irq;
> > +
> > +	struct irq_info *info;
> > +
> > +	spin_lock(&irq_mapping_update_lock);
> > +
> > +	list_for_each_entry(info, &xen_irq_list_head, list) {
> > +		if (info == NULL || info->type != IRQT_PIRQ)
> > +			continue;
> > +		irq = info->irq;
> > +		if (info->u.pirq.pirq == pirq)
> > +			goto out;
> > +	}
> > +	irq = -1;
> > +out:
> > +	spin_lock(&irq_mapping_update_lock);
> > +
> > +	return -1;
> 
> Shouldn't this be:
> 
>   return irq

Yes. The impact of not doing so is that xen_hvm_setup_msi_irqs would
allocate a fresh PIRQ each time an MSI was reused, instead of resuing
the old one -- i.e. it's a leak. I retested PVHVM PCI hotplug with the
following patch.

> How come you are using the spin_lock here, but not
> in other places when iterating over the xen_irq_list_head?

Those other places already hold the lock in their caller (or are known
to be single threaded -- e.g. resume). Callers of xen_irq_from_pirq do
not hold the lock.

Ian.

8<------------------------

>From 9b1686b874c4893a3b014e400185940dcba43676 Mon Sep 17 00:00:00 2001
From: Ian Campbell <ian.campbell@citrix.com>
Date: Thu, 10 Mar 2011 08:54:06 +0000
Subject: [PATCH] xen: events: fix return value from xen_irq_from_pirq

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 77c2b43..dc5b575 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -765,7 +765,7 @@ int xen_irq_from_pirq(unsigned pirq)
 out:
 	spin_lock(&irq_mapping_update_lock);
 
-	return -1;
+	return irq;
 }
 
 
-- 
1.5.6.5



