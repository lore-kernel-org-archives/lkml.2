Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab0CVUsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:48:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:26914 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332Ab0CVUss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:48:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qCtCelSkLhViVPnfd++MLOJ6zsCYD0OaSr518VRgwCKWM2xjUKTN412JKXiawYg9PQ
         6aVKbtDHmzHxP9u+Q0LKuws8ZBblSW8ZtmEUK1ax9kPqkbfjUIkLFhuJYNN35drLxcuv
         p1opdmf5JZokyV/ZIgDR7eDJtDlgA+O4ybK0o=
Subject: Re: linux-next: Tree for March 22 (net-sysfs.c)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       therbert@google.com
In-Reply-To: <20100322.102206.148561893.davem@davemloft.net>
References: <20100322171937.d753bdba.sfr@canb.auug.org.au>
	 <4BA78D3D.9090007@oracle.com>
	 <20100322.102206.148561893.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Mar 2010 21:48:42 +0100
Message-ID: <1269290922.3043.9.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 22 mars 2010 à 10:22 -0700, David Miller a écrit :
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Mon, 22 Mar 2010 08:31:09 -0700
> 
> > When CONFIG_SYSFS is not enabled:
> > 
> > net/core/net-sysfs.c:742: error: implicit declaration of function 'rx_queue_remove_kobjects'
> > net/core/net-sysfs.c:783: error: implicit declaration of function 'rx_queue_register_kobjects'
> > 
> 

I cooked following patch and added a new CONFIG_RPS setting, I believe
its cleaner and could help.

Thanks

[PATCH net-next-2.6] net: RPS depends on CONFIG_SYSFS

Randy Dunlap found net/core/net-sysfs.c could not compile if
CONFIG_SYSFS=n

Defines CONFIG_RPS in net/Kconfig to let user disable RPS if wanted.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/linux/netdevice.h |    4 ++++
 net/Kconfig               |    5 +++++
 net/core/dev.c            |   29 +++++++++++++++++++----------
 net/core/net-sysfs.c      |    7 ++++++-
 4 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c96c41e..c94cdb4 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -531,6 +531,7 @@ struct netdev_queue {
 	unsigned long		tx_dropped;
 } ____cacheline_aligned_in_smp;
 
+#if defined(CONFIG_RPS)
 /*
  * This structure holds an RPS map which can be of variable length.  The
  * map is an array of CPUs.
@@ -549,6 +550,7 @@ struct netdev_rx_queue {
 	struct netdev_rx_queue *first;
 	atomic_t count;
 } ____cacheline_aligned_in_smp;
+#endif
 
 /*
  * This structure defines the management hooks for network devices.
@@ -897,12 +899,14 @@ struct net_device {
 
 	unsigned char		broadcast[MAX_ADDR_LEN];	/* hw bcast add	*/
 
+#ifdef CONFIG_RPS
 	struct kset		*queues_kset;
 
 	struct netdev_rx_queue	*_rx;
 
 	/* Number of RX queues allocated at alloc_netdev_mq() time  */
 	unsigned int		num_rx_queues;
+#endif
 
 	struct netdev_queue	rx_queue;
 
diff --git a/net/Kconfig b/net/Kconfig
index 041c35e..8189502 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -203,6 +203,11 @@ source "net/ieee802154/Kconfig"
 source "net/sched/Kconfig"
 source "net/dcb/Kconfig"
 
+config RPS
+	boolean "RPS: Remote Packet Steering"
+	depends on SMP && SYSFS
+	default y
+
 menu "Network testing"
 
 config NET_PKTGEN
diff --git a/net/core/dev.c b/net/core/dev.c
index a03aab4..0ea0f96 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2177,7 +2177,7 @@ int weight_p __read_mostly = 64;            /* old backlog weight */
 
 DEFINE_PER_CPU(struct netif_rx_stats, netdev_rx_stat) = { 0, };
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RPS
 /*
  * get_rps_cpu is called from netif_receive_skb and returns the target
  * CPU from the RPS map of the receiving queue for a given skb.
@@ -2325,7 +2325,7 @@ enqueue:
 
 		/* Schedule NAPI for backlog device */
 		if (napi_schedule_prep(&queue->backlog)) {
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RPS
 			if (cpu != smp_processor_id()) {
 				struct rps_remote_softirq_cpus *rcpus =
 				    &__get_cpu_var(rps_remote_softirq_cpus);
@@ -2376,7 +2376,7 @@ int netif_rx(struct sk_buff *skb)
 	if (!skb->tstamp.tv64)
 		net_timestamp(skb);
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RPS
 	cpu = get_rps_cpu(skb->dev, skb);
 	if (cpu < 0)
 		cpu = smp_processor_id();
@@ -2750,7 +2750,7 @@ out:
  */
 int netif_receive_skb(struct sk_buff *skb)
 {
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RPS
 	int cpu;
 
 	cpu = get_rps_cpu(skb->dev, skb);
@@ -3187,7 +3187,7 @@ void netif_napi_del(struct napi_struct *napi)
 }
 EXPORT_SYMBOL(netif_napi_del);
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RPS
 /*
  * net_rps_action sends any pending IPI's for rps.  This is only called from
  * softirq and interrupts must be enabled.
@@ -3212,7 +3212,7 @@ static void net_rx_action(struct softirq_action *h)
 	unsigned long time_limit = jiffies + 2;
 	int budget = netdev_budget;
 	void *have;
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RPS
 	int select;
 	struct rps_remote_softirq_cpus *rcpus;
 #endif
@@ -3278,7 +3278,7 @@ static void net_rx_action(struct softirq_action *h)
 		netpoll_poll_unlock(have);
 	}
 out:
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RPS
 	rcpus = &__get_cpu_var(rps_remote_softirq_cpus);
 	select = rcpus->select;
 	rcpus->select ^= 1;
@@ -5275,6 +5275,7 @@ int register_netdevice(struct net_device *dev)
 
 	dev->iflink = -1;
 
+#ifdef CONFIG_RPS
 	if (!dev->num_rx_queues) {
 		/*
 		 * Allocate a single RX queue if driver never called
@@ -5291,7 +5292,7 @@ int register_netdevice(struct net_device *dev)
 		atomic_set(&dev->_rx->count, 1);
 		dev->num_rx_queues = 1;
 	}
-
+#endif
 	/* Init, if this function is available */
 	if (dev->netdev_ops->ndo_init) {
 		ret = dev->netdev_ops->ndo_init(dev);
@@ -5649,11 +5650,13 @@ struct net_device *alloc_netdev_mq(int sizeof_priv, const char *name,
 		void (*setup)(struct net_device *), unsigned int queue_count)
 {
 	struct netdev_queue *tx;
-	struct netdev_rx_queue *rx;
 	struct net_device *dev;
 	size_t alloc_size;
 	struct net_device *p;
+#ifdef CONFIG_RPS
+	struct netdev_rx_queue *rx;
 	int i;
+#endif
 
 	BUG_ON(strlen(name) >= sizeof(dev->name));
 
@@ -5679,6 +5682,7 @@ struct net_device *alloc_netdev_mq(int sizeof_priv, const char *name,
 		goto free_p;
 	}
 
+#ifdef CONFIG_RPS
 	rx = kcalloc(queue_count, sizeof(struct netdev_rx_queue), GFP_KERNEL);
 	if (!rx) {
 		printk(KERN_ERR "alloc_netdev: Unable to allocate "
@@ -5694,6 +5698,7 @@ struct net_device *alloc_netdev_mq(int sizeof_priv, const char *name,
 	 */
 	for (i = 0; i < queue_count; i++)
 		rx[i].first = rx;
+#endif
 
 	dev = PTR_ALIGN(p, NETDEV_ALIGN);
 	dev->padded = (char *)dev - (char *)p;
@@ -5709,8 +5714,10 @@ struct net_device *alloc_netdev_mq(int sizeof_priv, const char *name,
 	dev->num_tx_queues = queue_count;
 	dev->real_num_tx_queues = queue_count;
 
+#ifdef CONFIG_RPS
 	dev->_rx = rx;
 	dev->num_rx_queues = queue_count;
+#endif
 
 	dev->gso_max_size = GSO_MAX_SIZE;
 
@@ -5727,8 +5734,10 @@ struct net_device *alloc_netdev_mq(int sizeof_priv, const char *name,
 	return dev;
 
 free_rx:
+#ifdef CONFIG_RPS
 	kfree(rx);
 free_tx:
+#endif
 	kfree(tx);
 free_p:
 	kfree(p);
@@ -6232,7 +6241,7 @@ static int __init net_dev_init(void)
 		queue->completion_queue = NULL;
 		INIT_LIST_HEAD(&queue->poll_list);
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RPS
 		queue->csd.func = trigger_softirq;
 		queue->csd.info = queue;
 		queue->csd.flags = 0;
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 7a46343..1e7fdd6 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -466,6 +466,7 @@ static struct attribute_group wireless_group = {
 };
 #endif
 
+#ifdef CONFIG_RPS
 /*
  * RX queue sysfs structures and functions.
  */
@@ -675,7 +676,7 @@ static void rx_queue_remove_kobjects(struct net_device *net)
 		kobject_put(&net->_rx[i].kobj);
 	kset_unregister(net->queues_kset);
 }
-
+#endif /* CONFIG_RPS */
 #endif /* CONFIG_SYSFS */
 
 #ifdef CONFIG_HOTPLUG
@@ -739,7 +740,9 @@ void netdev_unregister_kobject(struct net_device * net)
 	if (!net_eq(dev_net(net), &init_net))
 		return;
 
+#ifdef CONFIG_RPS
 	rx_queue_remove_kobjects(net);
+#endif
 
 	device_del(dev);
 }
@@ -780,11 +783,13 @@ int netdev_register_kobject(struct net_device *net)
 	if (error)
 		return error;
 
+#ifdef CONFIG_RPS
 	error = rx_queue_register_kobjects(net);
 	if (error) {
 		device_del(dev);
 		return error;
 	}
+#endif
 
 	return error;
 }


