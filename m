Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab1CIRl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:41:56 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:36468 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932922Ab1CIRly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:41:54 -0500
X-IronPort-AV: E=Sophos;i="4.62,291,1297054800"; 
   d="scan'208";a="139432645"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 13/14] xen: events: do not workaround too-small nr_irqs
Date: Wed,  9 Mar 2011 17:41:25 +0000
Message-Id: <1299692486-28634-13-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 09 Mar 2011 17:41:53.0930 (UTC) FILETIME=[47582EA0:01CBDE81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This workaround was somewhat useful prior to the introduction of the
core irq allocator and 026c9d2d0d75 "xen: events: allocate GSIs and
dynamic IRQs from separate IRQ ranges." but should be unnecessary now.

If nr_irqs turns out to be too small under Xen then we should increase
nr_irqs rather than working around the core allocator in this way.

In my configuration NR_IRQS ends up being 2304 with nr_irq_gsi 272
which is sufficient.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 drivers/xen/events.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index b07f5bb..51c6a5b 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -423,15 +423,8 @@ static int xen_allocate_irq_dynamic(void)
 		first = get_nr_irqs_gsi();
 #endif
 
-retry:
 	irq = irq_alloc_desc_from(first, -1);
 
-	if (irq == -ENOMEM && first > NR_IRQS_LEGACY) {
-		printk(KERN_ERR "Out of dynamic IRQ space and eating into GSI space. You should increase nr_irqs\n");
-		first = max(NR_IRQS_LEGACY, first - NR_IRQS_LEGACY);
-		goto retry;
-	}
-
 	if (irq < 0)
 		panic("No available IRQ to bind to: increase nr_irqs!\n");
 
-- 
1.5.6.5

