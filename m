Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2HCTrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 15:47:40 -0400
Received: from relay1.sgi.com ([192.48.179.29]:51319 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab2HCTqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 15:46:42 -0400
Date: Fri, 3 Aug 2012 14:46:29 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Robin Holt <holt@sgi.com>
Subject: [PATCH] SGI XPC fails to load when cpu 0 is out of IRQ resources.
Message-ID: <20120803194628.GN3093@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On many of our larger systems, CPU 0 has had all of its IRQ resources
consumed before XPC loads.  Worse cases on machines with multiple
10 GigE cards and multiple IB cards have depleted the entire first
socket of IRQs.  That patch makes selecting the node upon which
IRQs are allocated (as well as all the other GRU Message Queue
structures) specifiable as a module load param and has a default
behavior of searching all nodes/cpus for an available resource.

Signed-off-by: Robin Holt <holt@sgi.com>
---
 drivers/misc/sgi-xp/xpc_uv.c |   66 ++++++++++++++++++++++++++++++++---------
 1 files changed, 51 insertions(+), 15 deletions(-)

diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
index 87b251a..f4398bb 100644
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -59,6 +59,8 @@ static struct xpc_heartbeat_uv *xpc_heartbeat_uv;
 					 XPC_NOTIFY_MSG_SIZE_UV)
 #define XPC_NOTIFY_IRQ_NAME		"xpc_notify"
 
+static int xpc_mq_node = -1;
+
 static struct xpc_gru_mq_uv *xpc_activate_mq_uv;
 static struct xpc_gru_mq_uv *xpc_notify_mq_uv;
 
@@ -110,8 +112,6 @@ xpc_get_gru_mq_irq_uv(struct xpc_gru_mq_uv *mq, int cpu, char *irq_name)
 	mq->irq = uv_setup_irq(irq_name, cpu, mq->mmr_blade, mq->mmr_offset,
 			UV_AFFINITY_CPU);
 	if (mq->irq < 0) {
-		dev_err(xpc_part, "uv_setup_irq() returned error=%d\n",
-			-mq->irq);
 		return mq->irq;
 	}
 
@@ -1731,9 +1731,42 @@ static struct xpc_arch_operations xpc_arch_ops_uv = {
 	.notify_senders_of_disconnect = xpc_notify_senders_of_disconnect_uv,
 };
 
+static int
+xpc_init_mq_node(int nid)
+{
+	int cpu;
+
+	for_each_cpu(cpu, cpumask_of_node(nid)) {
+		xpc_activate_mq_uv = xpc_create_gru_mq_uv(XPC_ACTIVATE_MQ_SIZE_UV, nid,
+							  XPC_ACTIVATE_IRQ_NAME,
+							  xpc_handle_activate_IRQ_uv);
+		if (!IS_ERR(xpc_activate_mq_uv))
+			break;
+	}
+	if (IS_ERR(xpc_activate_mq_uv))
+		return PTR_ERR(xpc_activate_mq_uv);
+
+	for_each_cpu(cpu, cpumask_of_node(nid)) {
+		xpc_notify_mq_uv = xpc_create_gru_mq_uv(XPC_NOTIFY_MQ_SIZE_UV, nid,
+							XPC_NOTIFY_IRQ_NAME,
+							xpc_handle_notify_IRQ_uv);
+		if (!IS_ERR(xpc_notify_mq_uv))
+			break;
+	}
+	if (IS_ERR(xpc_notify_mq_uv)) {
+		xpc_destroy_gru_mq_uv(xpc_activate_mq_uv);
+		return PTR_ERR(xpc_notify_mq_uv);
+	}
+
+	return 0;
+}
+
 int
 xpc_init_uv(void)
 {
+	int nid;
+	int ret = 0;
+
 	xpc_arch_ops = xpc_arch_ops_uv;
 
 	if (sizeof(struct xpc_notify_mq_msghdr_uv) > XPC_MSG_HDR_MAX_SIZE) {
@@ -1742,21 +1775,21 @@ xpc_init_uv(void)
 		return -E2BIG;
 	}
 
-	xpc_activate_mq_uv = xpc_create_gru_mq_uv(XPC_ACTIVATE_MQ_SIZE_UV, 0,
-						  XPC_ACTIVATE_IRQ_NAME,
-						  xpc_handle_activate_IRQ_uv);
-	if (IS_ERR(xpc_activate_mq_uv))
-		return PTR_ERR(xpc_activate_mq_uv);
+	if (xpc_mq_node < 0)
+		for_each_online_node(nid) {
+			ret = xpc_init_mq_node(nid);
 
-	xpc_notify_mq_uv = xpc_create_gru_mq_uv(XPC_NOTIFY_MQ_SIZE_UV, 0,
-						XPC_NOTIFY_IRQ_NAME,
-						xpc_handle_notify_IRQ_uv);
-	if (IS_ERR(xpc_notify_mq_uv)) {
-		xpc_destroy_gru_mq_uv(xpc_activate_mq_uv);
-		return PTR_ERR(xpc_notify_mq_uv);
-	}
+			if (!ret)
+				break;
+		}
+	else
+		ret = xpc_init_mq_node(xpc_mq_node);
 
-	return 0;
+	if (ret < 0)
+		dev_err(xpc_part, "xpc_init_mq_node() returned error=%d\n",
+			-ret);
+
+	return ret;
 }
 
 void
@@ -1765,3 +1798,6 @@ xpc_exit_uv(void)
 	xpc_destroy_gru_mq_uv(xpc_notify_mq_uv);
 	xpc_destroy_gru_mq_uv(xpc_activate_mq_uv);
 }
+
+module_param(xpc_mq_node, int, 0);
+MODULE_PARM_DESC(xpc_mq_node, "Node number on which to allocate message queues.");
-- 
1.7.6.1

