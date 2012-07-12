Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162835Ab2GLXXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:23:49 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43335 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162503Ab2GLXDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:03:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>, Tom Herbert <therbert@google.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        Roland Dreier <roland@kernel.org>, Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 11/68] bonding: Fix corrupted queue_mapping
Date: Thu, 12 Jul 2012 16:01:45 -0700
Message-Id: <20120712175036.405029842@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5ee31c6898ea5537fcea160999d60dc63bc0c305 ]

In the transmit path of the bonding driver, skb->cb is used to
stash the skb->queue_mapping so that the bonding device can set its
own queue mapping.  This value becomes corrupted since the skb->cb is
also used in __dev_xmit_skb.

When transmitting through bonding driver, bond_select_queue is
called from dev_queue_xmit.  In bond_select_queue the original
skb->queue_mapping is copied into skb->cb (via bond_queue_mapping)
and skb->queue_mapping is overwritten with the bond driver queue.

Subsequently in dev_queue_xmit, __dev_xmit_skb is called which writes
the packet length into skb->cb, thereby overwriting the stashed
queue mappping.  In bond_dev_queue_xmit (called from hard_start_xmit),
the queue mapping for the skb is set to the stashed value which is now
the skb length and hence is an invalid queue for the slave device.

If we want to save skb->queue_mapping into skb->cb[], best place is to
add a field in struct qdisc_skb_cb, to make sure it wont conflict with
other layers (eg : Qdiscc, Infiniband...)

This patchs also makes sure (struct qdisc_skb_cb)->data is aligned on 8
bytes :

netem qdisc for example assumes it can store an u64 in it, without
misalignment penalty.

Note : we only have 20 bytes left in (struct qdisc_skb_cb)->data[].
The largest user is CHOKe and it fills it.

Based on a previous patch from Tom Herbert.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Tom Herbert <therbert@google.com>
Cc: John Fastabend <john.r.fastabend@intel.com>
Cc: Roland Dreier <roland@kernel.org>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    9 +++++----
 include/net/sch_generic.h       |    7 +++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -77,6 +77,7 @@
 #include <net/route.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
+#include <net/pkt_sched.h>
 #include "bonding.h"
 #include "bond_3ad.h"
 #include "bond_alb.h"
@@ -388,8 +389,6 @@ struct vlan_entry *bond_next_vlan(struct
 	return next;
 }
 
-#define bond_queue_mapping(skb) (*(u16 *)((skb)->cb))
-
 /**
  * bond_dev_queue_xmit - Prepare skb for xmit.
  *
@@ -403,7 +402,9 @@ int bond_dev_queue_xmit(struct bonding *
 	skb->dev = slave_dev;
 	skb->priority = 1;
 
-	skb->queue_mapping = bond_queue_mapping(skb);
+	BUILD_BUG_ON(sizeof(skb->queue_mapping) !=
+		     sizeof(qdisc_skb_cb(skb)->bond_queue_mapping));
+	skb->queue_mapping = qdisc_skb_cb(skb)->bond_queue_mapping;
 
 	if (unlikely(netpoll_tx_running(slave_dev)))
 		bond_netpoll_send_skb(bond_get_slave_by_dev(bond, slave_dev), skb);
@@ -4240,7 +4241,7 @@ static u16 bond_select_queue(struct net_
 	/*
 	 * Save the original txq to restore before passing to the driver
 	 */
-	bond_queue_mapping(skb) = skb->queue_mapping;
+	qdisc_skb_cb(skb)->bond_queue_mapping = skb->queue_mapping;
 
 	if (unlikely(txq >= dev->real_num_tx_queues)) {
 		do {
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -219,13 +219,16 @@ struct tcf_proto {
 
 struct qdisc_skb_cb {
 	unsigned int		pkt_len;
-	unsigned char		data[24];
+	u16			bond_queue_mapping;
+	u16			_pad;
+	unsigned char		data[20];
 };
 
 static inline void qdisc_cb_private_validate(const struct sk_buff *skb, int sz)
 {
 	struct qdisc_skb_cb *qcb;
-	BUILD_BUG_ON(sizeof(skb->cb) < sizeof(unsigned int) + sz);
+
+	BUILD_BUG_ON(sizeof(skb->cb) < offsetof(struct qdisc_skb_cb, data) + sz);
 	BUILD_BUG_ON(sizeof(qcb->data) < sz);
 }
 


