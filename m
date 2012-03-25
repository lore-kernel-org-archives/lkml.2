Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2CYMd5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 08:33:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27696 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab2CYMd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 08:33:56 -0400
X-AuditID: cbfee61b-b7baeae000004fa7-6b-4f6f10b2cbc0
From: Thomas Abraham <thomas.abraham@linaro.org>
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org
Subject: [PATCH] of/irq: of_irq_init: Call initialization function for all
 controllers
Date: Sun, 25 Mar 2012 18:08:49 +0530
Message-id: <1332679129-23864-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <CAJuYYwS5Srw2-D6hdk=-=YN3iB37+KTWVqQPPPVbb-e7it+uVQ@mail.gmail.com>
References: <CAJuYYwS5Srw2-D6hdk=-=YN3iB37+KTWVqQPPPVbb-e7it+uVQ@mail.gmail.com>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_irq_init function stops processing the interrupt controller hierarchy
when there are no more interrupt controller parents identified. Though this
condition suffices most cases, there are cases where a interrupt controller's
parent controller does not participate in the initialization of the interrupt
hierarchy. An example of such a case is the use of a interrupt nexus node
by a interrupt controller node which delivers interrupts to separate interrupt
parent controllers.

Instead of stopping the processing of interrupt controller hierarchy in such
a case, the orphan interrupt controller node's descriptor can be identified
and its 'logical' parent in the descriptor is set as NULL. The processing of
interrupt hierarchy is then restarted by looking for descriptors which have
a NULL interrupt parent.

Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/of/irq.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 9cf0060..70c6ece 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -400,6 +400,38 @@ struct intc_desc {
 };
 
 /**
+ * of_irq_mark_orphan_desc - Set parent as NULL for a orphan intc_desc
+ * @intc_desc_list: the list of intc_desc to search for orphan intc_desc
+ *
+ * This is a helper function for the of_irq_init function and is invoked
+ * when there are child nodes available in intc_desc_list but there are
+ * no parent nodes in intc_parent_list. When invoked, this function
+ * searches for a intc_desc instance that does not have a parent intc_desc
+ * instance in intc_desc_list. The very reason of the invocation of this
+ * function ensures that a orphan intc_desc will be found. When found, the
+ * interrupt_parent of the orphan intc_desc is set to NULL.
+ */
+static void of_irq_mark_orphan_desc(struct list_head *intc_desc_list)
+{
+	struct intc_desc *desc, *temp_desc;
+
+	list_for_each_entry_safe(desc, temp_desc, intc_desc_list, list) {
+		struct intc_desc *td1, *td2;
+		list_for_each_entry_safe(td1, td2, intc_desc_list, list) {
+			if (desc->interrupt_parent == td1->dev)
+				break;
+		}
+		if (desc->interrupt_parent == td1->dev)
+			continue;
+
+		pr_debug("%s: set interrupt_parent of 'intc_desc' with dev name"
+			" %s as NULL\n", __func__, desc->dev->full_name);
+		desc->interrupt_parent = NULL;
+		return;
+	}
+}
+
+/**
  * of_irq_init - Scan and init matching interrupt controllers in DT
  * @matches: 0 terminated array of nodes to match and init function to call
  *
@@ -481,8 +513,19 @@ void __init of_irq_init(const struct of_device_id *matches)
 		/* Get the next pending parent that might have children */
 		desc = list_first_entry(&intc_parent_list, typeof(*desc), list);
 		if (list_empty(&intc_parent_list) || !desc) {
+			/*
+			 * This has reached a point where there are children in
+			 * the intc_desc_list but no parent in intc_parent_list.
+			 * This means there is a child desc in intc_desc_list
+			 * whose parent is not one of the remaining elements of
+			 * the intc_desc_list. Such a child node is marked as
+			 * orphan (interrupt_parent is set to NULL) and the
+			 * process continues with parent set to NULL.
+			 */
 			pr_err("of_irq_init: children remain, but no parents\n");
-			break;
+			of_irq_mark_orphan_desc(&intc_desc_list);
+			parent = NULL;
+			continue;
 		}
 		list_del(&desc->list);
 		parent = desc->dev;
-- 
1.6.6.rc2

