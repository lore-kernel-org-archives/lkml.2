Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab2IAJUV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:20:21 -0400
Received: from gn237.zone.eu ([217.146.67.237]:54695 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab2IAJRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:17:08 -0400
X-Greylist: delayed 606 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Sep 2012 05:17:08 EDT
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Priit Laes <plaes@plaes.org>
Subject: [PATCH 03/14] staging: csr: netdev.c: Clean up KERNEL_VERSION checks: 2.6.28
Date: Sat,  1 Sep 2012 12:05:59 +0300
Message-Id: <1346490370-32438-4-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346490370-32438-1-git-send-email-plaes@plaes.org>
References: <1346490370-32438-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/staging/csr/netdev.c | 454 -------------------------------------------
 1 file changed, 454 deletions(-)

diff --git a/drivers/staging/csr/netdev.c b/drivers/staging/csr/netdev.c
index c44526e..6a5a483 100644
--- a/drivers/staging/csr/netdev.c
+++ b/drivers/staging/csr/netdev.c
@@ -67,7 +67,6 @@
  */
 #define ALLOW_Q_PAUSE
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
 #ifdef UNIFI_NET_NAME
 #define UF_ALLOC_NETDEV(_dev, _size, _name, _setup, _num_of_queues)     \
     do {                                                                \
@@ -81,21 +80,6 @@
         _dev = alloc_etherdev_mq(_size, _num_of_queues);                \
     } while (0);
 #endif /* UNIFI_NET_NAME */
-#else
-#ifdef UNIFI_NET_NAME
-#define UF_ALLOC_NETDEV(_dev, _size, _name, _setup, _num_of_queues)     \
-    do {                                                                \
-        static char name[8];                                           \
-        sprintf(name, "%s%s", UNIFI_NET_NAME, _name);                   \
-        _dev = alloc_netdev(_size, name, _setup);                       \
-    } while (0);
-#else
-#define UF_ALLOC_NETDEV(_dev, _size, _name, _setup, _num_of_queues)     \
-    do {                                                                \
-        _dev = alloc_etherdev(_size);                                   \
-    } while (0);
-#endif /* UNIFI_NET_NAME */
-#endif /* LINUX_VERSION_CODE */
 
 
 /* Wext handler is suported only if CSR_SUPPORT_WEXT is defined */
@@ -116,9 +100,7 @@ static int uf_net_open(struct net_device *dev);
 static int uf_net_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static int uf_net_stop(struct net_device *dev);
 static struct net_device_stats *uf_net_get_stats(struct net_device *dev);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
 static u16 uf_net_select_queue(struct net_device *dev, struct sk_buff *skb);
-#endif
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32)
 static netdev_tx_t uf_net_xmit(struct sk_buff *skb, struct net_device *dev);
 #else
@@ -179,48 +161,6 @@ struct uf_tx_packet_data {
     unsigned long host_tag;
 };
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)
-static int uf_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd);
-static int uf_qdiscop_requeue(struct sk_buff *skb, struct Qdisc* qd);
-static struct sk_buff *uf_qdiscop_dequeue(struct Qdisc* qd);
-static void uf_qdiscop_reset(struct Qdisc* qd);
-static void uf_qdiscop_destroy(struct Qdisc* qd);
-static int uf_qdiscop_dump(struct Qdisc *qd, struct sk_buff *skb);
-static int uf_qdiscop_tune(struct Qdisc *qd, struct nlattr *opt);
-static int uf_qdiscop_init(struct Qdisc *qd, struct nlattr *opt);
-#endif
-
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)
-/* queueing discipline operations */
-static struct Qdisc_ops uf_qdisc_ops =
-{
-    .next = NULL,
-    .cl_ops = NULL,
-    .id = "UniFi Qdisc",
-    .priv_size = sizeof(struct uf_sched_data),
-
-    .enqueue = uf_qdiscop_enqueue,
-    .dequeue = uf_qdiscop_dequeue,
-    .requeue = uf_qdiscop_requeue,
-    .drop = NULL, /* drop not needed since we are always the root qdisc */
-
-    .init = uf_qdiscop_init,
-    .reset = uf_qdiscop_reset,
-    .destroy = uf_qdiscop_destroy,
-    .change = uf_qdiscop_tune,
-
-    .dump = uf_qdiscop_dump,
-};
-#endif /* LINUX_VERSION_CODE */
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
-#define UF_QDISC_CREATE_DFLT(_dev, _ops, _root)
-#else
-#define UF_QDISC_CREATE_DFLT(_dev, _ops, _root)         \
-    qdisc_create_dflt(dev, _ops)
-#endif /* LINUX_VERSION_CODE */
-
 #endif /* CONFIG_NET_SCHED */
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29)
@@ -330,10 +270,8 @@ uf_alloc_netdevice(CsrSdioFunction *sdio_dev, int bus_id)
     dev->get_stats = uf_net_get_stats;
 
     dev->set_multicast_list = uf_set_multicast_list;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
     dev->select_queue       = uf_net_select_queue;
 #endif
-#endif
 
 #ifdef CSR_SUPPORT_WEXT
     dev->wireless_handlers = &unifi_iw_handler_def;
@@ -473,16 +411,8 @@ uf_alloc_netdevice(CsrSdioFunction *sdio_dev, int bus_id)
 #endif
 #endif
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)
-#ifdef CONFIG_NET_SCHED
-    /* Register the qdisc operations */
-    register_qdisc(&uf_qdisc_ops);
-#endif /* CONFIG_NET_SCHED */
-#endif /* LINUX_VERSION_CODE */
-
     priv->ref_count = 1;
 
-
     priv->amp_client = NULL;
     priv->coredump_mode = 0;
     priv->ptest_mode = 0;
@@ -672,13 +602,6 @@ uf_free_netdevice(unifi_priv_t *priv)
     spin_unlock_irqrestore(&priv->wapi_lock, flags);
 #endif
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)
-#ifdef CONFIG_NET_SCHED
-    /* Unregister the qdisc operations */
-    unregister_qdisc(&uf_qdisc_ops);
-#endif /* CONFIG_NET_SCHED */
-#endif /* LINUX_VERSION_CODE */
-
 #ifdef CSR_SUPPORT_WEXT
     /* Unregister callback for netdevice state changes */
     unregister_netdevice_notifier(&uf_netdev_notifier);
@@ -941,7 +864,6 @@ get_packet_priority(unifi_priv_t *priv, struct sk_buff *skb, const struct ethhdr
     return priority;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
 /*
  * ---------------------------------------------------------------------------
  *  uf_net_select_queue
@@ -989,7 +911,6 @@ uf_net_select_queue(struct net_device *dev, struct sk_buff *skb)
     func_exit();
     return (u16)queue;
 } /* uf_net_select_queue() */
-#endif
 
 int
 skb_add_llc_snap(struct net_device *dev, struct sk_buff *skb, int proto)
@@ -1913,9 +1834,7 @@ uf_net_xmit(struct sk_buff *skb, struct net_device *dev)
     int result;
     static tx_signal_handler tx_handler;
     CSR_PRIORITY priority;
-#if !defined (CONFIG_NET_SCHED) || (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28))
     CsrWifiRouterCtrlPortAction port_action;
-#endif /* CONFIG_NET_SCHED */
 
     func_enter();
 
@@ -1940,11 +1859,6 @@ uf_net_xmit(struct sk_buff *skb, struct net_device *dev)
         port = UF_UNCONTROLLED_PORT_Q;
     }
 
-#if defined (CONFIG_NET_SCHED) && (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28))
-    /* Remove the ethernet header */
-    skb_pull(skb, ETH_HLEN);
-    result = tx_handler(priv, skb, &ehdr, priority);
-#else
     /* Uncontrolled port rules apply */
     port_action = verify_port(priv
         , (((CSR_WIFI_ROUTER_CTRL_MODE_STA == interfacePriv->interfaceMode)||(CSR_WIFI_ROUTER_CTRL_MODE_P2PCLI== interfacePriv->interfaceMode))? interfacePriv->bssid.a: ehdr.h_dest)
@@ -1970,7 +1884,6 @@ uf_net_xmit(struct sk_buff *skb, struct net_device *dev)
         func_exit();
         return NETDEV_TX_OK;
     }
-#endif /* CONFIG_NET_SCHED */
 
     if (result == NETDEV_TX_OK) {
 #if (defined(CSR_WIFI_SECURITY_WAPI_ENABLE) && defined(CSR_WIFI_SECURITY_WAPI_SW_ENCRYPTION))
@@ -2043,7 +1956,6 @@ unifi_pause_xmit(void *ospriv, unifi_TrafficQueue queue)
     func_enter();
     unifi_trace(priv, UDBG2, "Stopping queue %d\n", queue);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
     for(i=0;i<CSR_WIFI_NUM_INTERFACES;i++)
     {
         if (netif_running(priv->netdev[i]))
@@ -2051,24 +1963,6 @@ unifi_pause_xmit(void *ospriv, unifi_TrafficQueue queue)
             netif_stop_subqueue(priv->netdev[i], (u16)queue);
         }
     }
-#else
-#ifdef ALLOW_Q_PAUSE
-    unifi_trace(priv, UDBG2, "Stopping netif\n");
-    /* stop the traffic from all the interfaces. */
-    for(i=0;i<CSR_WIFI_NUM_INTERFACES;i++)
-    {
-        if (netif_running(priv->netdev[i])) {
-            UF_NETIF_TX_STOP_ALL_QUEUES(priv->netdev[i]);
-        }
-    }
-#else
-    if (net_is_tx_q_paused(priv, queue)) {
-        unifi_trace(priv, UDBG2, "Queue already stopped\n");
-        return;
-    }
-    net_tx_q_pause(priv, queue);
-#endif
-#endif
 
 #ifdef CSR_SUPPORT_SME
     if(queue<=3) {
@@ -2092,7 +1986,6 @@ unifi_restart_xmit(void *ospriv, unifi_TrafficQueue queue)
     func_enter();
     unifi_trace(priv, UDBG2, "Waking queue %d\n", queue);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
     for(i=0;i<CSR_WIFI_NUM_INTERFACES;i++)
     {
         if (netif_running(priv->netdev[i]))
@@ -2100,25 +1993,6 @@ unifi_restart_xmit(void *ospriv, unifi_TrafficQueue queue)
             netif_wake_subqueue(priv->netdev[i], (u16)queue);
         }
     }
-#else
-#ifdef ALLOW_Q_PAUSE
-    /* Need to supply queue number depending on Kernel support */
-    /* Resume the traffic from all the interfaces */
-    for(i=0;i<CSR_WIFI_NUM_INTERFACES;i++)
-    {
-        if (netif_running(priv->netdev[i])) {
-            UF_NETIF_TX_WAKE_ALL_QUEUES(priv->netdev[i]);
-        }
-    }
-#else
-    if (!(net_is_tx_q_paused(priv, queue))) {
-        unifi_trace(priv, UDBG2, "Queue already running\n");
-        func_exit();
-        return;
-    }
-    net_tx_q_unpause(priv, queue);
-#endif
-#endif
 
 #ifdef CSR_SUPPORT_SME
     if(queue <=3) {
@@ -2333,11 +2207,7 @@ uf_resume_data_plane(unifi_priv_t *priv, int queue,
     {
 #ifdef CONFIG_NET_SCHED
         if (netif_running(priv->netdev[interfaceTag])) {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
             netif_tx_schedule_all(priv->netdev[interfaceTag]);
-#else
-            netif_schedule(priv->netdev[interfaceTag]);
-#endif /* LINUX_VERSION_CODE */
         }
 #endif
         uf_process_rx_pending_queue(priv, queue, peer_address, 1,interfaceTag);
@@ -3163,330 +3033,6 @@ void uf_net_get_name(struct net_device *dev, char *name, int len)
 
 } /* uf_net_get_name */
 
-
-
-
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)
-#ifdef CONFIG_NET_SCHED
-
-/*
- * ---------------------------------------------------------------------------
- *  uf_install_qdisc
- *
- *      Creates a root qdisc, registers our qdisc handlers and
- *      overrides the device's qdisc_sleeping to prevent the system
- *      from creating a new one for our network device.
- *
- *  Arguments:
- *      dev             Pointer to the network device.
- *
- *  Returns:
- *      0 on success, Linux error code otherwise.
- *
- *  Notes:
- *      This function holds the qdisk lock so it needs to be called
- *      after registering the network device in uf_register_netdev().
- *      Also, the qdisc_create_dflt() API has changed in 2.6.20 to
- *      include the parentid.
- * ---------------------------------------------------------------------------
- */
-int uf_install_qdisc(struct net_device *dev)
-{
-    struct Qdisc *qdisc;
-    struct netdev_queue *queue0;
-
-
-    func_enter();
-
-    qdisc = UF_QDISC_CREATE_DFLT(dev, &uf_qdisc_ops, TC_H_ROOT);
-    if (!qdisc) {
-        unifi_error(NULL, "%s: qdisc installation failed\n", dev->name);
-        func_exit_r(-EFAULT);
-        return -EFAULT;
-    }
-    unifi_trace(NULL, UDBG5, "%s: parent qdisc=0x%p\n",
-            dev->name, qdisc);
-
-    qdisc->handle = 0x80020000;
-    qdisc->flags = 0x0;
-
-    queue0 = netdev_get_tx_queue(dev, 0);
-    if (queue0 == NULL) {
-        unifi_error(NULL, "%s: netdev_get_tx_queue returned no queue\n",
-                dev->name);
-        func_exit_r(-EFAULT);
-        return -EFAULT;
-    }
-    queue0->qdisc = qdisc;
-    queue0->qdisc_sleeping = qdisc;
-
-    func_exit_r(0);
-    return 0;
-
-} /* uf_install_qdisc() */
-
-static int uf_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
-{
-    netInterface_priv_t *interfacePriv = (netInterface_priv_t *)netdev_priv(qd->dev_queue->dev);
-    unifi_priv_t *priv = interfacePriv->privPtr;
-    struct uf_sched_data *q = qdisc_priv(qd);
-    struct uf_tx_packet_data *pkt_data = (struct uf_tx_packet_data *) skb->cb;
-    struct ethhdr ehdr;
-    struct Qdisc *qdisc;
-    int r, proto;
-
-    func_enter();
-
-    memcpy(&ehdr, skb->data, ETH_HLEN);
-    proto = ntohs(ehdr.h_proto);
-
-    /* 802.1x - apply controlled/uncontrolled port rules */
-    if ((proto != ETH_P_PAE)
-#ifdef CSR_WIFI_SECURITY_WAPI_ENABLE
-            && (proto != ETH_P_WAI)
-#endif
-       ) {
-        /* queues 0 - 3 */
-        pkt_data->priority = get_packet_priority(priv, skb, &ehdr, interfacePriv);
-        pkt_data->queue = unifi_frame_priority_to_queue(pkt_data->priority);
-    } else {
-        pkt_data->queue = UNIFI_TRAFFIC_Q_EAPOL;
-    }
-
-    qdisc = q->queues[pkt_data->queue];
-    r = qdisc->enqueue(skb, qdisc);
-    if (r == NET_XMIT_SUCCESS) {
-        qd->q.qlen++;
-        qd->bstats.bytes += skb->len;
-        qd->bstats.packets++;
-        func_exit_r(NET_XMIT_SUCCESS);
-        return NET_XMIT_SUCCESS;
-    }
-
-    unifi_error(priv, "uf_qdiscop_enqueue: dropped\n");
-    qd->qstats.drops++;
-
-    func_exit_r(r);
-    return r;
-
-} /* uf_qdiscop_enqueue() */
-
-
-static int uf_qdiscop_requeue(struct sk_buff *skb, struct Qdisc* qd)
-{
-    netInterface_priv_t *interfacePriv = (netInterface_priv_t*)netdev_priv(qd->dev_queue->dev);
-    unifi_priv_t *priv = interfacePriv->privPtr;
-    struct uf_sched_data *q = qdisc_priv(qd);
-    struct uf_tx_packet_data *pkt_data = (struct uf_tx_packet_data *) skb->cb;
-    struct Qdisc *qdisc;
-    int r;
-
-    func_enter();
-
-    unifi_trace(priv, UDBG5, "uf_qdiscop_requeue: (q=%d), tag=%u\n",
-            pkt_data->queue, pkt_data->host_tag);
-
-    /* we recorded which queue to use earlier! */
-    qdisc = q->queues[pkt_data->queue];
-
-    if ((r = qdisc->ops->requeue(skb, qdisc)) == 0) {
-        qd->q.qlen++;
-        func_exit_r(0);
-        return 0;
-    }
-
-    unifi_error(priv, "uf_qdiscop_requeue: dropped\n");
-    qd->qstats.drops++;
-
-    func_exit_r(r);
-    return r;
-} /* uf_qdiscop_requeue() */
-
-static struct sk_buff *uf_qdiscop_dequeue(struct Qdisc* qd)
-{
-    netInterface_priv_t *interfacePriv = (netInterface_priv_t *)netdev_priv(qd->dev_queue->dev);
-    unifi_priv_t *priv = interfacePriv->privPtr;
-    struct uf_sched_data *q = qdisc_priv(qd);
-    struct sk_buff *skb;
-    struct Qdisc *qdisc;
-    int queue, i;
-    struct ethhdr ehdr;
-    struct uf_tx_packet_data *pkt_data;
-    CsrWifiRouterCtrlPortAction port_action;
-
-    func_enter();
-
-    /* check all the queues */
-    for (i = UNIFI_TRAFFIC_Q_MAX - 1; i >= 0; i--) {
-
-        if (i != UNIFI_TRAFFIC_Q_EAPOL) {
-            queue = priv->prev_queue;
-            if (++priv->prev_queue >= UNIFI_TRAFFIC_Q_EAPOL) {
-                priv->prev_queue = 0;
-            }
-        } else {
-            queue = i;
-        }
-
-#ifndef ALLOW_Q_PAUSE
-        /* If queue is paused, do not dequeue */
-        if (net_is_tx_q_paused(priv, queue)) {
-            unifi_trace(priv, UDBG5,
-                    "uf_qdiscop_dequeue: tx queue paused (q=%d)\n", queue);
-            continue;
-        }
-#endif
-
-        qdisc = q->queues[queue];
-        skb = qdisc->dequeue(qdisc);
-        if (skb) {
-            /* A packet has been dequeued, decrease the queued packets count */
-            qd->q.qlen--;
-
-            pkt_data = (struct uf_tx_packet_data *) skb->cb;
-
-            /* Check the (un)controlled port status */
-            memcpy(&ehdr, skb->data, ETH_HLEN);
-
-            port_action = verify_port(priv
-                            , (((CSR_WIFI_ROUTER_CTRL_MODE_STA == interfacePriv->interfaceMode) ||(CSR_WIFI_ROUTER_CTRL_MODE_P2PCLI == interfacePriv->interfaceMode))? interfacePriv->bssid.a: ehdr.h_dest)
-                            , (UNIFI_TRAFFIC_Q_EAPOL == queue? UF_UNCONTROLLED_PORT_Q: UF_CONTROLLED_PORT_Q)
-                            , interfacePriv->InterfaceTag);
-
-            /* Dequeue packet if port is open */
-            if (port_action == CSR_WIFI_ROUTER_CTRL_PORT_ACTION_8021X_PORT_OPEN) {
-                unifi_trace(priv, UDBG5,
-                        "uf_qdiscop_dequeue: new (q=%d), tag=%u\n",
-                        queue, pkt_data->host_tag);
-
-                func_exit();
-                return skb;
-            }
-
-            /* Discard or block the packet if necessary */
-            if (port_action == CSR_WIFI_ROUTER_CTRL_PORT_ACTION_8021X_PORT_CLOSED_DISCARD) {
-                unifi_trace(priv, UDBG5,
-                        "uf_qdiscop_dequeue: drop (q=%d), tag=%u\n",
-                        queue, pkt_data->host_tag);
-                kfree_skb(skb);
-                break;
-            }
-
-            /* We can not send the packet now, put it back to the queue */
-            if (qdisc->ops->requeue(skb, qdisc) != 0) {
-                unifi_error(priv,
-                        "uf_qdiscop_dequeue: requeue (q=%d) failed, tag=%u, drop it\n",
-                        queue, pkt_data->host_tag);
-
-                /* Requeue failed, drop the packet */
-                kfree_skb(skb);
-                break;
-            }
-            /* We requeued the packet, increase the queued packets count */
-            qd->q.qlen++;
-
-            unifi_trace(priv, UDBG5,
-                    "uf_qdiscop_dequeue: skip (q=%d), tag=%u\n",
-                    queue, pkt_data->host_tag);
-        }
-    }
-
-    func_exit();
-    return NULL;
-} /* uf_qdiscop_dequeue() */
-
-
-static void uf_qdiscop_reset(struct Qdisc* qd)
-{
-    struct uf_sched_data *q = qdisc_priv(qd);
-    int queue;
-    func_enter();
-
-    for (queue = 0; queue < UNIFI_TRAFFIC_Q_MAX; queue++) {
-        qdisc_reset(q->queues[queue]);
-    }
-    qd->q.qlen = 0;
-
-    func_exit();
-} /* uf_qdiscop_reset() */
-
-
-static void uf_qdiscop_destroy(struct Qdisc* qd)
-{
-    struct uf_sched_data *q = qdisc_priv(qd);
-    int queue;
-
-    func_enter();
-
-    for (queue=0; queue < UNIFI_TRAFFIC_Q_MAX; queue++) {
-        qdisc_destroy(q->queues[queue]);
-        q->queues[queue] = &noop_qdisc;
-    }
-
-    func_exit();
-} /* uf_qdiscop_destroy() */
-
-
-/* called whenever parameters are updated on existing qdisc */
-static int uf_qdiscop_tune(struct Qdisc *qd, struct nlattr *opt)
-{
-    func_enter();
-    func_exit();
-    return 0;
-} /* uf_qdiscop_tune() */
-
-
-/* called during initial creation of qdisc on device */
-static int uf_qdiscop_init(struct Qdisc *qd, struct nlattr *opt)
-{
-    struct net_device *dev = qd->dev_queue->dev;
-    netInterface_priv_t *interfacePriv = (netInterface_priv_t *)netdev_priv(dev);
-    unifi_priv_t *priv = interfacePriv->privPtr;
-    struct uf_sched_data *q = qdisc_priv(qd);
-    int err = 0, i;
-
-    func_enter();
-
-    /* make sure we do not mess with the ingress qdisc */
-    if (qd->flags & TCQ_F_INGRESS) {
-        func_exit();
-        return -EINVAL;
-    }
-
-    /* if options were passed in, set them */
-    if (opt) {
-        err = uf_qdiscop_tune(qd, opt);
-    }
-
-    /* create child queues */
-    for (i = 0; i < UNIFI_TRAFFIC_Q_MAX; i++) {
-        q->queues[i] = UF_QDISC_CREATE_DFLT(dev, &pfifo_qdisc_ops,
-                qd->handle);
-        if (!q->queues[i]) {
-            q->queues[i] = &noop_qdisc;
-            unifi_error(priv, "%s child qdisc %i creation failed\n");
-        }
-
-        unifi_trace(priv, UDBG5, "%s: child qdisc=0x%p\n",
-                dev->name, q->queues[i]);
-    }
-
-    func_exit_r(err);
-    return err;
-} /* uf_qdiscop_init() */
-
-
-static int uf_qdiscop_dump(struct Qdisc *qd, struct sk_buff *skb)
-{
-    func_enter();
-    func_exit_r(skb->len);
-    return skb->len;
-} /* uf_qdiscop_dump() */
-
-#endif /* CONFIG_NET_SCHED */
-#endif /* LINUX_VERSION_CODE */
-
 #ifdef CSR_SUPPORT_WEXT
 
 /*
-- 
1.7.12

