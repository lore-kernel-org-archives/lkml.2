Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1ESA7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 20:59:15 -0400
Received: from mail.vyatta.com ([76.74.103.46]:39724 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab1ESA7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 20:59:13 -0400
Date: Wed, 18 May 2011 17:59:10 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Decotigny <decot@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-net-upstream@google.com,
        Sameer Nanda <snanda@google.com>
Subject: Re: [PATCH 2/6] forcedeth: new ethtool stat "tx_timeout" to account
 for tx_timeouts
Message-ID: <20110518175910.355026a1@nehalam>
In-Reply-To: <1305764080-24853-2-git-send-email-decot@google.com>
References: <1305764080-24853-1-git-send-email-decot@google.com>
	<1305764080-24853-2-git-send-email-decot@google.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 May 2011 17:14:36 -0700
David Decotigny <decot@google.com> wrote:

> From: Sameer Nanda <snanda@google.com>
> 
> This change publishes a new ethtool stats: tx_timeout that counts the
> number of times the tx_timeout callback was triggered.
> 
> 
> Signed-off-by: David Decotigny <decot@google.com>

Since this is generic, maybe should be done that way not through ethtool
that way tools and administrators don't have to look for something special.

Something like:


--- a/include/linux/netdevice.h	2011-05-18 17:40:15.901691265 -0700
+++ b/include/linux/netdevice.h	2011-05-18 17:56:11.731742792 -0700
@@ -571,6 +571,8 @@ struct netdev_queue {
 	 * please use this field instead of dev->trans_start
 	 */
 	unsigned long		trans_start;
+
+	unsigned long		trans_timeout;
 } ____cacheline_aligned_in_smp;
 
 static inline int netdev_queue_numa_node_read(const struct netdev_queue *q)
--- a/net/core/net-sysfs.c	2011-05-18 17:50:54.540403456 -0700
+++ b/net/core/net-sysfs.c	2011-05-18 17:57:47.136747867 -0700
@@ -788,7 +788,6 @@ net_rx_queue_update_kobjects(struct net_
 #endif
 }
 
-#ifdef CONFIG_XPS
 /*
  * netdev_queue sysfs structures and functions.
  */
@@ -834,6 +833,17 @@ static const struct sysfs_ops netdev_que
 	.store = netdev_queue_attr_store,
 };
 
+static ssize_t show_trans_timeout(struct netdev_queue *queue,
+			       struct netdev_queue_attribute *attribute,
+			       char *buf)
+{
+	return sprintf(buf, "%lu", queue->trans_timeout);
+}
+
+static struct netdev_queue_attribute queue_trans_timeout =
+	__ATTR(tx_timeout, S_IRUGO, show_trans_timeout, NULL);
+
+#ifdef CONFIG_XPS
 static inline unsigned int get_netdev_queue_index(struct netdev_queue *queue)
 {
 	struct net_device *dev = queue->dev;
@@ -1043,9 +1053,13 @@ error:
 
 static struct netdev_queue_attribute xps_cpus_attribute =
     __ATTR(xps_cpus, S_IRUGO | S_IWUSR, show_xps_map, store_xps_map);
+#endif /* CONFIG_XPS */
 
 static struct attribute *netdev_queue_default_attrs[] = {
+	&queue_trans_timeout.attr,
+#ifdef CONFIG_XPS
 	&xps_cpus_attribute.attr,
+#endif
 	NULL
 };
 
@@ -1125,7 +1139,6 @@ static int netdev_queue_add_kobject(stru
 
 	return error;
 }
-#endif /* CONFIG_XPS */
 
 int
 netdev_queue_update_kobjects(struct net_device *net, int old_num, int new_num)
--- a/net/sched/sch_generic.c	2011-05-18 17:45:07.740756564 -0700
+++ b/net/sched/sch_generic.c	2011-05-18 17:48:18.474761735 -0700
@@ -245,6 +245,7 @@ static void dev_watchdog(unsigned long a
 				if (netif_tx_queue_stopped(txq) &&
 				    time_after(jiffies, (trans_start +
 							 dev->watchdog_timeo))) {
+					++txq->trans_timeout;
 					some_queue_timedout = 1;
 					break;
 				}

