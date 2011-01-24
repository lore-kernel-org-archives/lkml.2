Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1AXLMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 06:12:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45143 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1AXLMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 06:12:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vyaOznivUuzlpywZ3JBn9/nvh2sp+IYO/3YPOeup6Q4JSax96ErEjl1Hmiaa9Pj/+k
         2ZUoFupLBAg5aI5ralFlp74BsnuzO8kS9yLpizkOywwMdql8+Q3KTtl6uVY07iZtnmHX
         XdKasOyEWVMlt9DWm/jeLNp75AwwOlIvpRspM=
Date: Mon, 24 Jan 2011 12:12:41 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: [PATCH RFC] RDMA: use alloc[_ordered]_workqueue()
Message-ID: <20110124111241.GB11404@htj.dyndns.org>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
 <1292086307-19211-2-git-send-email-tj@kernel.org>
 <adamxn0yujn.fsf@cisco.com>
 <20110124110654.GA11404@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124110654.GA11404@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace create[_singlethread]_workqueue() usages with the new
alloc[_ordered]_workqueue().  This removes rescuers from all
infiniband workqueues.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
---
Hello,

So, all the create* -> alloc* conversions were dropped (one
flush_scheduled_work() conversion was incorrectly dropped in the
process, fixed by the other patch).  Was this because of forward
progress under memory pressure guarantee?

It doesn't look like infiniband can be safely used in memory reclaim
path anyway (ie. it doesn't seem safe to host swap space) but I could
definitely be mistaken.  If forward progress is necessary, the right
thing to do is adding WQ_MEM_RECLAIM flag to workqueue allocation
calls.

Thank you.

 drivers/infiniband/core/addr.c            |    2 +-
 drivers/infiniband/core/cm.c              |    2 +-
 drivers/infiniband/core/cma.c             |    2 +-
 drivers/infiniband/core/iwcm.c            |    2 +-
 drivers/infiniband/core/mad.c             |    2 +-
 drivers/infiniband/core/multicast.c       |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c     |    2 +-
 drivers/infiniband/hw/cxgb4/cm.c          |    2 +-
 drivers/infiniband/hw/mlx4/main.c         |    2 +-
 drivers/infiniband/hw/mthca/mthca_catas.c |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c        |    4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    2 +-
 12 files changed, 13 insertions(+), 13 deletions(-)

Index: work/drivers/infiniband/core/addr.c
===================================================================
--- work.orig/drivers/infiniband/core/addr.c
+++ work/drivers/infiniband/core/addr.c
@@ -438,7 +438,7 @@ static struct notifier_block nb = {
 
 static int __init addr_init(void)
 {
-	addr_wq = create_singlethread_workqueue("ib_addr");
+	addr_wq = alloc_ordered_workqueue("ib_addr", 0);
 	if (!addr_wq)
 		return -ENOMEM;
 
Index: work/drivers/infiniband/core/cma.c
===================================================================
--- work.orig/drivers/infiniband/core/cma.c
+++ work/drivers/infiniband/core/cma.c
@@ -3257,7 +3257,7 @@ static int __init cma_init(void)
 {
 	int ret;
 
-	cma_wq = create_singlethread_workqueue("rdma_cm");
+	cma_wq = alloc_ordered_workqueue("rdma_cm", 0);
 	if (!cma_wq)
 		return -ENOMEM;
 
Index: work/drivers/infiniband/core/iwcm.c
===================================================================
--- work.orig/drivers/infiniband/core/iwcm.c
+++ work/drivers/infiniband/core/iwcm.c
@@ -1015,7 +1015,7 @@ EXPORT_SYMBOL(iw_cm_init_qp_attr);
 
 static int __init iw_cm_init(void)
 {
-	iwcm_wq = create_singlethread_workqueue("iw_cm_wq");
+	iwcm_wq = alloc_ordered_workqueue("iw_cm_wq", 0);
 	if (!iwcm_wq)
 		return -ENOMEM;
 
Index: work/drivers/infiniband/core/mad.c
===================================================================
--- work.orig/drivers/infiniband/core/mad.c
+++ work/drivers/infiniband/core/mad.c
@@ -2839,7 +2839,7 @@ static int ib_mad_port_open(struct ib_de
 		goto error7;
 
 	snprintf(name, sizeof name, "ib_mad%d", port_num);
-	port_priv->wq = create_singlethread_workqueue(name);
+	port_priv->wq = alloc_ordered_workqueue(name, 0);
 	if (!port_priv->wq) {
 		ret = -ENOMEM;
 		goto error8;
Index: work/drivers/infiniband/core/multicast.c
===================================================================
--- work.orig/drivers/infiniband/core/multicast.c
+++ work/drivers/infiniband/core/multicast.c
@@ -872,7 +872,7 @@ int mcast_init(void)
 {
 	int ret;
 
-	mcast_wq = create_singlethread_workqueue("ib_mcast");
+	mcast_wq = alloc_ordered_workqueue("ib_mcast", 0);
 	if (!mcast_wq)
 		return -ENOMEM;
 
Index: work/drivers/infiniband/hw/cxgb3/iwch_cm.c
===================================================================
--- work.orig/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ work/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -2236,7 +2236,7 @@ int __init iwch_cm_init(void)
 {
 	skb_queue_head_init(&rxq);
 
-	workq = create_singlethread_workqueue("iw_cxgb3");
+	workq = alloc_ordered_workqueue("iw_cxgb3", 0);
 	if (!workq)
 		return -ENOMEM;
 
Index: work/drivers/infiniband/hw/cxgb4/cm.c
===================================================================
--- work.orig/drivers/infiniband/hw/cxgb4/cm.c
+++ work/drivers/infiniband/hw/cxgb4/cm.c
@@ -2356,7 +2356,7 @@ int __init c4iw_cm_init(void)
 	spin_lock_init(&timeout_lock);
 	skb_queue_head_init(&rxq);
 
-	workq = create_singlethread_workqueue("iw_cxgb4");
+	workq = alloc_ordered_workqueue("iw_cxgb4", 0);
 	if (!workq)
 		return -ENOMEM;
 
Index: work/drivers/infiniband/hw/mlx4/main.c
===================================================================
--- work.orig/drivers/infiniband/hw/mlx4/main.c
+++ work/drivers/infiniband/hw/mlx4/main.c
@@ -1214,7 +1214,7 @@ static int __init mlx4_ib_init(void)
 {
 	int err;
 
-	wq = create_singlethread_workqueue("mlx4_ib");
+	wq = alloc_ordered_workqueue("mlx4_ib", 0);
 	if (!wq)
 		return -ENOMEM;
 
Index: work/drivers/infiniband/hw/mthca/mthca_catas.c
===================================================================
--- work.orig/drivers/infiniband/hw/mthca/mthca_catas.c
+++ work/drivers/infiniband/hw/mthca/mthca_catas.c
@@ -186,7 +186,7 @@ int __init mthca_catas_init(void)
 {
 	INIT_WORK(&catas_work, catas_reset);
 
-	catas_wq = create_singlethread_workqueue("mthca_catas");
+	catas_wq = alloc_ordered_workqueue("mthca_catas", 0);
 	if (!catas_wq)
 		return -ENOMEM;
 
Index: work/drivers/infiniband/hw/nes/nes_cm.c
===================================================================
--- work.orig/drivers/infiniband/hw/nes/nes_cm.c
+++ work/drivers/infiniband/hw/nes/nes_cm.c
@@ -2381,10 +2381,10 @@ static struct nes_cm_core *nes_cm_alloc_
 	nes_debug(NES_DBG_CM, "Init CM Core completed -- cm_core=%p\n", cm_core);
 
 	nes_debug(NES_DBG_CM, "Enable QUEUE EVENTS\n");
-	cm_core->event_wq = create_singlethread_workqueue("nesewq");
+	cm_core->event_wq = alloc_ordered_workqueue("nesewq", 0);
 	cm_core->post_event = nes_cm_post_event;
 	nes_debug(NES_DBG_CM, "Enable QUEUE DISCONNECTS\n");
-	cm_core->disconn_wq = create_singlethread_workqueue("nesdwq");
+	cm_core->disconn_wq = alloc_ordered_workqueue("nesdwq", 0);
 
 	print_core(cm_core);
 	return cm_core;
Index: work/drivers/infiniband/ulp/ipoib/ipoib_main.c
===================================================================
--- work.orig/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ work/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1374,7 +1374,7 @@ static int __init ipoib_init_module(void
 	 * so flush_scheduled_work() can deadlock during device
 	 * removal.
 	 */
-	ipoib_workqueue = create_singlethread_workqueue("ipoib");
+	ipoib_workqueue = alloc_ordered_workqueue("ipoib", 0);
 	if (!ipoib_workqueue) {
 		ret = -ENOMEM;
 		goto err_fs;
Index: work/drivers/infiniband/core/cm.c
===================================================================
--- work.orig/drivers/infiniband/core/cm.c
+++ work/drivers/infiniband/core/cm.c
@@ -3804,7 +3804,7 @@ static int __init ib_cm_init(void)
 	if (ret)
 		return -ENOMEM;
 
-	cm.wq = create_workqueue("ib_cm");
+	cm.wq = alloc_workqueue("ib_cm", 0, 0);
 	if (!cm.wq) {
 		ret = -ENOMEM;
 		goto error1;
