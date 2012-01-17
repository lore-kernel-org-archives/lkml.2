Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab2AQMWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:22:25 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:56487 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab2AQMWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:21 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 30/50] ACPI, APEI, Printk queued error record before panic
Date: Tue, 17 Jan 2012 07:21:22 -0500
Message-id: <46d12f0bcb17b2de89a059114349d472b7eb1783.1326802230.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

Because printk is not safe inside NMI handler, the recoverable error
records received in NMI handler will be queued to be printked in a
delayed IRQ context via irq_work.  If a fatal error occurs after the
recoverable error and before the irq_work processed, we lost a error
report.

To solve the issue, the queued error records are printked in NMI
handler if system will go panic.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/ghes.c |   53 ++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 9dcb2d8..aaf3609 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -740,26 +740,34 @@ static int ghes_notify_sci(struct notifier_block *this,
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
@@ -779,6 +787,32 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
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
@@ -804,6 +838,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 
 	if (sev_global >= GHES_SEV_PANIC) {
 		oops_begin();
+		ghes_print_queued_estatus();
 		__ghes_print_estatus(KERN_EMERG, ghes_global->generic,
 				     ghes_global->estatus);
 		/* reboot to log the error! */
-- 
1.7.9.rc1

