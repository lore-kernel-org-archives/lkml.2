Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab1CJQIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:08:42 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:34480 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab1CJQIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:08:41 -0500
X-IronPort-AV: E=Sophos;i="4.62,296,1297054800"; 
   d="scan'208";a="139621173"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 13/14] xen: events: do not workaround too-small nr_irqs
Date: Thu, 10 Mar 2011 16:08:14 +0000
Message-Id: <1299773295-348-13-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
References: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 10 Mar 2011 16:08:39.0697 (UTC) FILETIME=[6B55B810:01CBDF3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of e7bcecb7b1d2 "genirq: Make nr_irqs runtime expandable"
nr_irqs can grow as necessary to accommodate our allocation requests.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 drivers/xen/events.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 6782251..7c36689 100644
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

