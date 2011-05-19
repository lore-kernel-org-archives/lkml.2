Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab1ESAPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 20:15:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36094 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab1ESAPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 20:15:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:organization;
	b=RpwfjJ4RT3jBBJfeq1RC5tlNIWZ7HPxN+B9d554w5Ukqmez9Wl1ot7/TdhUex4tFF
	UBu8FDayYwwsB0iVXYyzw==
From: David Decotigny <decot@google.com>
To: "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kernel-net-upstream@google.com, Salman Qazi <sqazi@google.com>,
        David Decotigny <decot@google.com>
Subject: [PATCH 6/6] forcedeth: Fix a race during rmmod of forcedeth
Date: Wed, 18 May 2011 17:14:40 -0700
Message-Id: <1305764080-24853-6-git-send-email-decot@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1305764080-24853-1-git-send-email-decot@google.com>
References: <1305764080-24853-1-git-send-email-decot@google.com>
Organization: Google, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Salman Qazi <sqazi@google.com>

The race was between del_timer_sync and nv_do_stats_poll called through
nv_get_ethtool_stats.  To prevent this, we have to introduce mutual
exclusion between nv_get_ethtool_stats and del_timer_sync.  Notice
that we don't put the mutual exclusion in nv_do_stats_poll.  That's
because doing so would result in a deadlock, since it is a timer
callback and hence already waited for by timer deletion.


Signed-off-by: David Decotigny <decot@google.com>
---
 drivers/net/forcedeth.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 2712ddc..2121cea 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -3921,6 +3921,10 @@ static void nv_poll_controller(struct net_device *dev)
 }
 #endif
 
+/* No locking is needed as long as this is in the timer
+ * callback.  However, any other callers must call this
+ * function with np->lock held.
+ */
 static void nv_do_stats_poll(unsigned long data)
 {
 	struct net_device *dev = (struct net_device *) data;
@@ -4553,12 +4557,17 @@ static int nv_get_sset_count(struct net_device *dev, int sset)
 
 static void nv_get_ethtool_stats(struct net_device *dev, struct ethtool_stats *estats, u64 *buffer)
 {
+	unsigned long flags;
 	struct fe_priv *np = netdev_priv(dev);
 
+	spin_lock_irqsave(&np->lock, flags);
+
 	/* update stats */
 	nv_do_stats_poll((unsigned long)dev);
 
 	memcpy(buffer, &np->estats, nv_get_sset_count(dev, ETH_SS_STATS)*sizeof(u64));
+
+	spin_unlock_irqrestore(&np->lock, flags);
 }
 
 static int nv_link_test(struct net_device *dev)
@@ -5176,13 +5185,13 @@ static int nv_close(struct net_device *dev)
 
 	spin_lock_irq(&np->lock);
 	np->in_shutdown = 1;
+	del_timer_sync(&np->stats_poll);
 	spin_unlock_irq(&np->lock);
 	nv_napi_disable(dev);
 	synchronize_irq(np->pci_dev->irq);
 
 	del_timer_sync(&np->oom_kick);
 	del_timer_sync(&np->nic_poll);
-	del_timer_sync(&np->stats_poll);
 
 	netif_stop_queue(dev);
 	spin_lock_irq(&np->lock);
-- 
1.7.3.1

