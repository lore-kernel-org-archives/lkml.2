Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab2IXJiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:38:06 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:41943 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2IXJiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:38:04 -0400
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, benh@kernel.crashing.org, grant.likely@secretlab.ca,
        Mike Qiu <qiudayu@linux.vnet.ibm.com>
Subject: [PATCH] No need to call irq_domain_legacy_revmap() for twice
Date: Mon, 24 Sep 2012 17:37:55 +0800
Message-Id: <1348479475-13074-1-git-send-email-qiudayu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
x-cbid: 12092409-2674-0000-0000-00000616D977
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function irq_create_mapping() calls irq_find_mapping(). The later
function has checked if the indicated IRQ domain has hw IRQ mapped to
virtual IRQ through legacy mode or not and return the value of the
legacy irq number by call irq_domain_legacy_revmap(). We needn't
to call irq_domain_legacy_revmap() to do same check in
irq_create_mapping() again.

The patch removes the duplicate call.

Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
---
 kernel/irq/irqdomain.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 49a7772..286d672 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -547,9 +547,12 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 		return virq;
 	}
 
-	/* Get a virtual interrupt number */
+	/*
+	 * For IRQ domain with type of IRQ_DOMAIN_MAP_LEGACY, we needn't
+	 * create the IRQ mapping for non-existing one, so just return 0.
+	 */
 	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
-		return irq_domain_legacy_revmap(domain, hwirq);
+		return 0;
 
 	/* Allocate a virtual interrupt number */
 	hint = hwirq % nr_irqs;
-- 
1.7.7.6

