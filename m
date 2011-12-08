Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab1LHD0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 22:26:05 -0500
Received: from mga03.intel.com ([143.182.124.21]:14032 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757975Ab1LHD0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 22:26:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="45071367"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 06/11] ACPI, APEI, Printk queued error record before panic
Date: Thu,  8 Dec 2011 11:25:45 +0800
Message-Id: <1323314750-8185-7-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323314750-8185-1-git-send-email-ying.huang@intel.com>
References: <1323314750-8185-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because printk is not safe inside NMI handler, the recoverable error
records received in NMI handler will be queued to be printked in a
delayed IRQ context via irq_work.  If a fatal error occurs after the
recoverable error and before the irq_work processed, we lost a error
report.

To solve the issue, the queued error records are printked in NMI
handler if system will go panic.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/ghes.c |   53 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 9 deletions(-)

--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -740,26 +740,34 @@ static int ghes_notify_sci(struct notifi
 	return ret;
 }
 
+static struct llist_node *llist_nodes_reverse(struct llist_node *llnode)
+{
+	struct llist_node *next, *tail = NULL;
+
+	while (llnode) {
+		next = llnode->next;
+		llnode->next = tail;
+		tail = llnode;
+		llnode = next;
+	}
+
+	return tail;
+}
+
 static void ghes_proc_in_irq(struct irq_work *irq_work)
 {
-	struct llist_node *llnode, *next, *tail = NULL;
+	struct llist_node *llnode, *next;
 	struct ghes_estatus_node *estatus_node;
 	struct acpi_hest_generic *generic;
 	struct acpi_hest_generic_status *estatus;
 	u32 len, node_len;
 
+	llnode = llist_del_all(&ghes_estatus_llist);
 	/*
 	 * Because the time order of estatus in list is reversed,
 	 * revert it back to proper order.
 	 */
-	llnode = llist_del_all(&ghes_estatus_llist);
-	while (llnode) {
-		next = llnode->next;
-		llnode->next = tail;
-		tail = llnode;
-		llnode = next;
-	}
-	llnode = tail;
+	llnode = llist_nodes_reverse(llnode);
 	while (llnode) {
 		next = llnode->next;
 		estatus_node = llist_entry(llnode, struct ghes_estatus_node,
@@ -779,6 +787,32 @@ static void ghes_proc_in_irq(struct irq_
 	}
 }
 
+static void ghes_print_queued_estatus(void)
+{
+	struct llist_node *llnode;
+	struct ghes_estatus_node *estatus_node;
+	struct acpi_hest_generic *generic;
+	struct acpi_hest_generic_status *estatus;
+	u32 len, node_len;
+
+	llnode = llist_del_all(&ghes_estatus_llist);
+	/*
+	 * Because the time order of estatus in list is reversed,
+	 * revert it back to proper order.
+	 */
+	llnode = llist_nodes_reverse(llnode);
+	while (llnode) {
+		estatus_node = llist_entry(llnode, struct ghes_estatus_node,
+					   llnode);
+		estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
+		len = apei_estatus_len(estatus);
+		node_len = GHES_ESTATUS_NODE_LEN(len);
+		generic = estatus_node->generic;
+		ghes_print_estatus(NULL, generic, estatus);
+		llnode = llnode->next;
+	}
+}
+
 static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 {
 	struct ghes *ghes, *ghes_global = NULL;
@@ -804,6 +838,7 @@ static int ghes_notify_nmi(unsigned int
 
 	if (sev_global >= GHES_SEV_PANIC) {
 		oops_begin();
+		ghes_print_queued_estatus();
 		__ghes_print_estatus(KERN_EMERG, ghes_global->generic,
 				     ghes_global->estatus);
 		/* reboot to log the error! */
