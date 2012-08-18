Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030672Ab2HWSpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:45:25 -0400
Received: from noserose.net ([66.220.18.76]:52820 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934183Ab2HWSoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:44:44 -0400
Message-Id: <cde500d146f92a994de5c6b641183323f3f71874.1345743801.git.ecashin@coraid.com>
In-Reply-To: <cover.1345743800.git.ecashin@coraid.com>
References: <cover.1345743800.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Date: Fri, 17 Aug 2012 21:26:46 -0400
Subject: [PATCH 04/14] aoe: use a kernel thread for transmissions
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_queue_xmit function needs to have interrupts enabled, so the
most simple way to get the locking right but still fulfill that
requirement is to use a process that can call dev_queue_xmit serially
over queued transmissions.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |    2 ++
 drivers/block/aoe/aoecmd.c |    4 ++--
 drivers/block/aoe/aoenet.c |   37 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 8c4f6d9..d0087de1 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -210,6 +210,8 @@ struct sk_buff *aoecmd_ata_id(struct aoedev *);
 void aoe_freetframe(struct frame *);
 void aoe_flush_iocq(void);
 void aoe_end_request(struct aoedev *, struct request *, int);
+int aoe_ktstart(struct ktstate *k);
+void aoe_ktstop(struct ktstate *k);
 
 int aoedev_init(void);
 void aoedev_exit(void);
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index e7df343..92eb28a 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1117,14 +1117,14 @@ kthread(void *vp)
 	return 0;
 }
 
-static void
+void
 aoe_ktstop(struct ktstate *k)
 {
 	kthread_stop(k->task);
 	wait_for_completion(&k->rendez);
 }
 
-static int
+int
 aoe_ktstart(struct ktstate *k)
 {
 	struct task_struct *task;
diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index 000eff2..5f43710 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -33,6 +33,9 @@ static char aoe_iflist[IFLISTSZ];
 module_param_string(aoe_iflist, aoe_iflist, IFLISTSZ, 0600);
 MODULE_PARM_DESC(aoe_iflist, "aoe_iflist=\"dev1 [dev2 ...]\"");
 
+static wait_queue_head_t txwq;
+static struct ktstate kts;
+
 #ifndef MODULE
 static int __init aoe_iflist_setup(char *str)
 {
@@ -44,6 +47,23 @@ static int __init aoe_iflist_setup(char *str)
 __setup("aoe_iflist=", aoe_iflist_setup);
 #endif
 
+static spinlock_t txlock;
+static struct sk_buff_head skbtxq;
+
+/* enters with txlock held */
+static int
+tx(void)
+{
+	struct sk_buff *skb;
+
+	while ((skb = skb_dequeue(&skbtxq))) {
+		spin_unlock_irq(&txlock);
+		dev_queue_xmit(skb);
+		spin_lock_irq(&txlock);
+	}
+	return 0;
+}
+
 int
 is_aoe_netif(struct net_device *ifp)
 {
@@ -88,10 +108,14 @@ void
 aoenet_xmit(struct sk_buff_head *queue)
 {
 	struct sk_buff *skb, *tmp;
+	ulong flags;
 
 	skb_queue_walk_safe(queue, skb, tmp) {
 		__skb_unlink(skb, queue);
-		dev_queue_xmit(skb);
+		spin_lock_irqsave(&txlock, flags);
+		skb_queue_tail(&skbtxq, skb);
+		spin_unlock_irqrestore(&txlock, flags);
+		wake_up(&txwq);
 	}
 }
 
@@ -169,6 +193,15 @@ static struct packet_type aoe_pt __read_mostly = {
 int __init
 aoenet_init(void)
 {
+	skb_queue_head_init(&skbtxq);
+	init_waitqueue_head(&txwq);
+	spin_lock_init(&txlock);
+	kts.lock = &txlock;
+	kts.fn = tx;
+	kts.waitq = &txwq;
+	kts.name = "aoe_tx";
+	if (aoe_ktstart(&kts))
+		return -EAGAIN;
 	dev_add_pack(&aoe_pt);
 	return 0;
 }
@@ -176,6 +209,8 @@ aoenet_init(void)
 void
 aoenet_exit(void)
 {
+	aoe_ktstop(&kts);
+	skb_queue_purge(&skbtxq);
 	dev_remove_pack(&aoe_pt);
 }
 
-- 
1.7.2.5

