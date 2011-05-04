Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1EDUTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:19:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41433 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab1EDUTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:19:24 -0400
Subject: [PATCH] irq: add irq_alloc_desc_between() helper
To: tglx@linutronix.de, linux-kernel@vger.kernel.org, miltonm@bga.com
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 04 May 2011 14:19:22 -0600
Message-ID: <20110504201839.7701.18840.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Written in response to conversation on IRC about needing to specify an upper
limit on the virq value returned for some MSI interrupt controllers.  Compiled
only; untested

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 include/linux/irq.h  |    9 ++++++++-
 kernel/irq/irqdesc.c |    5 ++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 09a3080..bcb712b 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -544,10 +544,17 @@ static inline struct msi_desc *irq_data_get_msi(struct irq_data *d)
 	return d->msi_desc;
 }
 
-int irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node);
+int irq_alloc_descs_between(int irq, unsigned int from, unsigned int cnt,
+			    unsigned int max, int node);
 void irq_free_descs(unsigned int irq, unsigned int cnt);
 int irq_reserve_irqs(unsigned int from, unsigned int cnt);
 
+static inline int irq_alloc_descs(int irq, unsigned int from, unsigned int cnt,
+				  int node)
+{
+	return irq_alloc_descs_between(irq, from, cnt, 0, node);
+}
+
 static inline int irq_alloc_desc(int node)
 {
 	return irq_alloc_descs(-1, 0, 1, node);
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 2c039c9..c1ddabd 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -322,7 +322,7 @@ void irq_free_descs(unsigned int from, unsigned int cnt)
  * Returns the first irq number or error code
  */
 int __ref
-irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)
+irq_alloc_descs_between(int irq, unsigned int from, unsigned int cnt, unsigned int max, int node)
 {
 	int start, ret;
 
@@ -337,6 +337,9 @@ irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node)
 	if (irq >=0 && start != irq)
 		goto err;
 
+	if (max && start + cnt >= max)
+		goto err;
+
 	if (start + cnt > nr_irqs) {
 		ret = irq_expand_nr_irqs(start + cnt);
 		if (ret)

