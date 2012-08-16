Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2HPD6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 23:58:23 -0400
Received: from relay1.sgi.com ([192.48.179.29]:38306 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab2HPD6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 23:58:22 -0400
Date: Wed, 15 Aug 2012 22:58:20 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] SGI XPC fails to load when cpu 0 is out of IRQ resources.
  -v2
Message-ID: <20120816035820.GE2951@sgi.com>
References: <20120803194628.GN3093@sgi.com>
 <20120815155605.cf02ef7b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815155605.cf02ef7b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On many of our larger systems, CPU 0 has had all of its IRQ resources
consumed before XPC loads.  Worst cases on machines with multiple
10 GigE cards and multiple IB cards have depleted the entire first
socket of IRQs.  This patch makes selecting the node upon which
IRQs are allocated (as well as all the other GRU Message Queue
structures) specifiable as a module load param and has a default
behavior of searching all nodes/cpus for an available resources.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: stable@vger.kernel.org

---

-v2 - incorporate review comments from Andrew Morton.

 drivers/misc/sgi-xp/xpc_uv.c |   82 ++++++++++++++++++++++++++++++++----------
 1 files changed, 63 insertions(+), 19 deletions(-)

diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
index 87b251a..57a53c1 100644
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -59,6 +59,8 @@ static struct xpc_heartbeat_uv *xpc_heartbeat_uv;
 					 XPC_NOTIFY_MSG_SIZE_UV)
 #define XPC_NOTIFY_IRQ_NAME		"xpc_notify"
 
+static int xpc_mq_node = -1;
+
 static struct xpc_gru_mq_uv *xpc_activate_mq_uv;
 static struct xpc_gru_mq_uv *xpc_notify_mq_uv;
 
@@ -109,11 +111,8 @@ xpc_get_gru_mq_irq_uv(struct xpc_gru_mq_uv *mq, int cpu, char *irq_name)
 #if defined CONFIG_X86_64
 	mq->irq = uv_setup_irq(irq_name, cpu, mq->mmr_blade, mq->mmr_offset,
 			UV_AFFINITY_CPU);
-	if (mq->irq < 0) {
-		dev_err(xpc_part, "uv_setup_irq() returned error=%d\n",
-			-mq->irq);
+	if (mq->irq < 0)
 		return mq->irq;
-	}
 
 	mq->mmr_value = uv_read_global_mmr64(mmr_pnode, mq->mmr_offset);
 
@@ -238,8 +237,9 @@ xpc_create_gru_mq_uv(unsigned int mq_size, int cpu, char *irq_name,
 	mq->mmr_blade = uv_cpu_to_blade_id(cpu);
 
 	nid = cpu_to_node(cpu);
-	page = alloc_pages_exact_node(nid, GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
-				pg_order);
+	page = alloc_pages_exact_node(nid,
+				      GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
+				      pg_order);
 	if (page == NULL) {
 		dev_err(xpc_part, "xpc_create_gru_mq_uv() failed to alloc %d "
 			"bytes of memory on nid=%d for GRU mq\n", mq_size, nid);
@@ -1731,9 +1731,50 @@ static struct xpc_arch_operations xpc_arch_ops_uv = {
 	.notify_senders_of_disconnect = xpc_notify_senders_of_disconnect_uv,
 };
 
+static int
+xpc_init_mq_node(int nid)
+{
+	int cpu;
+
+	get_online_cpus();
+
+	for_each_cpu(cpu, cpumask_of_node(nid)) {
+		xpc_activate_mq_uv =
+			xpc_create_gru_mq_uv(XPC_ACTIVATE_MQ_SIZE_UV, nid,
+					     XPC_ACTIVATE_IRQ_NAME,
+					     xpc_handle_activate_IRQ_uv);
+		if (!IS_ERR(xpc_activate_mq_uv))
+			break;
+	}
+	if (IS_ERR(xpc_activate_mq_uv)) {
+		put_online_cpus();
+		return PTR_ERR(xpc_activate_mq_uv);
+	}
+
+	for_each_cpu(cpu, cpumask_of_node(nid)) {
+		xpc_notify_mq_uv =
+			xpc_create_gru_mq_uv(XPC_NOTIFY_MQ_SIZE_UV, nid,
+					     XPC_NOTIFY_IRQ_NAME,
+					     xpc_handle_notify_IRQ_uv);
+		if (!IS_ERR(xpc_notify_mq_uv))
+			break;
+	}
+	if (IS_ERR(xpc_notify_mq_uv)) {
+		xpc_destroy_gru_mq_uv(xpc_activate_mq_uv);
+		put_online_cpus();
+		return PTR_ERR(xpc_notify_mq_uv);
+	}
+
+	put_online_cpus();
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
@@ -1742,21 +1783,21 @@ xpc_init_uv(void)
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
@@ -1765,3 +1806,6 @@ xpc_exit_uv(void)
 	xpc_destroy_gru_mq_uv(xpc_notify_mq_uv);
 	xpc_destroy_gru_mq_uv(xpc_activate_mq_uv);
 }
+
+module_param(xpc_mq_node, int, 0);
+MODULE_PARM_DESC(xpc_mq_node, "Node number on which to allocate message queues.");
-- 
1.7.6.1

