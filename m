Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab1EFLgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 07:36:05 -0400
Received: from smtp.citrix.com ([66.165.176.89]:2780 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290Ab1EFLgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 07:36:04 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 May 2011 07:36:04 EDT
X-IronPort-AV: E=Sophos;i="4.64,325,1301889600"; 
   d="scan'208";a="13975709"
From: <stefano.stabellini@eu.citrix.com>
To: konrad.wilk@oracle.com
CC: Stefano.Stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 2/2] xen: do not implement irq_mask and irq_unmask in xen_percpu_chip
Date: Fri, 6 May 2011 12:27:51 +0100
Message-ID: <1304681271-3836-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1304681271-3836-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1304681271-3836-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

irq_mask and irq_unmask are not needed by handle_percpu_irq, but
they are called by fixup_irqs when changing affinity.
At the moment calling fixup_irqs can result in unmasking an interrupt
that was previously masked because of the call to irq_unmask.
However xen_percpu_chip doesn't even support irq_set_affinity, and we
don't need irq_mask and irq_unmask, so we can just change them to noops,
following the example of uv_irq_chip.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/events.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index bb59651..8eb5316 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -120,6 +120,7 @@ static struct irq_chip xen_percpu_chip;
 static struct irq_chip xen_pirq_chip;
 static void enable_dynirq(struct irq_data *data);
 static void disable_dynirq(struct irq_data *data);
+static void evtchn_noop(struct irq_data *data) { }
 
 /* Get info for IRQ */
 static struct irq_info *info_for_irq(unsigned irq)
@@ -1595,9 +1596,10 @@ static struct irq_chip xen_pirq_chip __read_mostly = {
 static struct irq_chip xen_percpu_chip __read_mostly = {
 	.name			= "xen-percpu",
 
+	.irq_enable		= enable_dynirq,
 	.irq_disable		= disable_dynirq,
-	.irq_mask		= disable_dynirq,
-	.irq_unmask		= enable_dynirq,
+	.irq_mask		= evtchn_noop,
+	.irq_unmask		= evtchn_noop,
 
 	.irq_ack		= ack_dynirq,
 };
-- 
1.7.2.3

