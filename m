Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab2IAJUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:20:23 -0400
Received: from gn237.zone.eu ([217.146.67.237]:54697 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab2IAJRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:17:08 -0400
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Priit Laes <plaes@plaes.org>
Subject: [PATCH 02/14] staging: csr: netdev.c: Clean up KERNEL_VERSION checks: 2.6.27
Date: Sat,  1 Sep 2012 12:05:58 +0300
Message-Id: <1346490370-32438-3-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346490370-32438-1-git-send-email-plaes@plaes.org>
References: <1346490370-32438-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/staging/csr/netdev.c | 42 ------------------------------------------
 1 file changed, 42 deletions(-)

diff --git a/drivers/staging/csr/netdev.c b/drivers/staging/csr/netdev.c
index 7b7d3fd..c44526e 100644
--- a/drivers/staging/csr/netdev.c
+++ b/drivers/staging/csr/netdev.c
@@ -216,9 +216,6 @@ static struct Qdisc_ops uf_qdisc_ops =
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
 #define UF_QDISC_CREATE_DFLT(_dev, _ops, _root)
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
-#define UF_QDISC_CREATE_DFLT(_dev, _ops, _root)         \
-    qdisc_create_dflt(dev, netdev_get_tx_queue(_dev, 0), _ops, _root)
 #else
 #define UF_QDISC_CREATE_DFLT(_dev, _ops, _root)         \
     qdisc_create_dflt(dev, _ops)
@@ -2338,8 +2335,6 @@ uf_resume_data_plane(unifi_priv_t *priv, int queue,
         if (netif_running(priv->netdev[interfaceTag])) {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
             netif_tx_schedule_all(priv->netdev[interfaceTag]);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
-            netif_schedule_queue(netdev_get_tx_queue(priv->netdev[interfaceTag], 0));
 #else
             netif_schedule(priv->netdev[interfaceTag]);
 #endif /* LINUX_VERSION_CODE */
@@ -3199,25 +3194,11 @@ void uf_net_get_name(struct net_device *dev, char *name, int len)
 int uf_install_qdisc(struct net_device *dev)
 {
     struct Qdisc *qdisc;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
     struct netdev_queue *queue0;
-#endif /* LINUX_VERSION_CODE */
 
 
     func_enter();
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)
-    /*
-     * check that there is no qdisc currently attached to device
-     * this ensures that we will be the root qdisc. (I can't find a better
-     * way to test this explicitly)
-     */
-    if (dev->qdisc_sleeping != &noop_qdisc) {
-        func_exit_r(-EFAULT);
-        return -EINVAL;
-    }
-#endif /* LINUX_VERSION_CODE */
-
     qdisc = UF_QDISC_CREATE_DFLT(dev, &uf_qdisc_ops, TC_H_ROOT);
     if (!qdisc) {
         unifi_error(NULL, "%s: qdisc installation failed\n", dev->name);
@@ -3230,7 +3211,6 @@ int uf_install_qdisc(struct net_device *dev)
     qdisc->handle = 0x80020000;
     qdisc->flags = 0x0;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
     queue0 = netdev_get_tx_queue(dev, 0);
     if (queue0 == NULL) {
         unifi_error(NULL, "%s: netdev_get_tx_queue returned no queue\n",
@@ -3240,12 +3220,6 @@ int uf_install_qdisc(struct net_device *dev)
     }
     queue0->qdisc = qdisc;
     queue0->qdisc_sleeping = qdisc;
-#else
-    qdisc_lock_tree(dev);
-    list_add_tail(&qdisc->list, &dev->qdisc_list);
-    dev->qdisc_sleeping = qdisc;
-    qdisc_unlock_tree(dev);
-#endif /* LINUX_VERSION_CODE */
 
     func_exit_r(0);
     return 0;
@@ -3254,11 +3228,7 @@ int uf_install_qdisc(struct net_device *dev)
 
 static int uf_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
     netInterface_priv_t *interfacePriv = (netInterface_priv_t *)netdev_priv(qd->dev_queue->dev);
-#else
-    netInterface_priv_t *interfacePriv = (netInterface_priv_t *)netdev_priv(qd->dev);
-#endif /* LINUX_VERSION_CODE */
     unifi_priv_t *priv = interfacePriv->privPtr;
     struct uf_sched_data *q = qdisc_priv(qd);
     struct uf_tx_packet_data *pkt_data = (struct uf_tx_packet_data *) skb->cb;
@@ -3305,11 +3275,7 @@ static int uf_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 
 static int uf_qdiscop_requeue(struct sk_buff *skb, struct Qdisc* qd)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
     netInterface_priv_t *interfacePriv = (netInterface_priv_t*)netdev_priv(qd->dev_queue->dev);
-#else
-    netInterface_priv_t *interfacePriv = (netInterface_priv_t*)netdev_priv(qd->dev);
-#endif /* LINUX_VERSION_CODE */
     unifi_priv_t *priv = interfacePriv->privPtr;
     struct uf_sched_data *q = qdisc_priv(qd);
     struct uf_tx_packet_data *pkt_data = (struct uf_tx_packet_data *) skb->cb;
@@ -3339,11 +3305,7 @@ static int uf_qdiscop_requeue(struct sk_buff *skb, struct Qdisc* qd)
 
 static struct sk_buff *uf_qdiscop_dequeue(struct Qdisc* qd)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
     netInterface_priv_t *interfacePriv = (netInterface_priv_t *)netdev_priv(qd->dev_queue->dev);
-#else
-    netInterface_priv_t *interfacePriv = (netInterface_priv_t *)netdev_priv(qd->dev);
-#endif /* LINUX_VERSION_CODE */
     unifi_priv_t *priv = interfacePriv->privPtr;
     struct uf_sched_data *q = qdisc_priv(qd);
     struct sk_buff *skb;
@@ -3478,11 +3440,7 @@ static int uf_qdiscop_tune(struct Qdisc *qd, struct nlattr *opt)
 /* called during initial creation of qdisc on device */
 static int uf_qdiscop_init(struct Qdisc *qd, struct nlattr *opt)
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
     struct net_device *dev = qd->dev_queue->dev;
-#else
-    struct net_device *dev = qd->dev;
-#endif /* LINUX_VERSION_CODE */
     netInterface_priv_t *interfacePriv = (netInterface_priv_t *)netdev_priv(dev);
     unifi_priv_t *priv = interfacePriv->privPtr;
     struct uf_sched_data *q = qdisc_priv(qd);
-- 
1.7.12

