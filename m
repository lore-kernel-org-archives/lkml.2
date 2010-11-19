Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab0KSWB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:01:56 -0500
Received: from kroah.org ([198.145.64.141]:45377 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757633Ab0KSV7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:59:04 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:44 2010
Message-Id: <20101119215644.907101767@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [75/82] net: add a recursion limit in xmit path
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commits 745e20f1b626b1be4b100af5d4bf7b3439392f8f and
  11a766ce915fc9f8663714eac6d59239388534ea ]

As tunnel devices are going to be lockless, we need to make sure a
misconfigured machine wont enter an infinite loop.

Add a percpu variable, and limit to three the number of stacked xmits.

Reported-by: Jesse Gross <jesse@nicira.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/dev.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2110,6 +2110,9 @@ static inline int skb_needs_linearize(st
 					      illegal_highdma(dev, skb)));
 }
 
+static DEFINE_PER_CPU(int, xmit_recursion);
+#define RECURSION_LIMIT 10
+
 /**
  *	dev_queue_xmit - transmit a buffer
  *	@skb: buffer to transmit
@@ -2194,10 +2197,15 @@ gso:
 
 		if (txq->xmit_lock_owner != cpu) {
 
+			if (__this_cpu_read(xmit_recursion) > RECURSION_LIMIT)
+				goto recursion_alert;
+
 			HARD_TX_LOCK(dev, txq, cpu);
 
 			if (!netif_tx_queue_stopped(txq)) {
+				__this_cpu_inc(xmit_recursion);
 				rc = dev_hard_start_xmit(skb, dev, txq);
+				__this_cpu_dec(xmit_recursion);
 				if (dev_xmit_complete(rc)) {
 					HARD_TX_UNLOCK(dev, txq);
 					goto out;
@@ -2209,7 +2217,9 @@ gso:
 				       "queue packet!\n", dev->name);
 		} else {
 			/* Recursion is detected! It is possible,
-			 * unfortunately */
+			 * unfortunately
+			 */
+recursion_alert:
 			if (net_ratelimit())
 				printk(KERN_CRIT "Dead loop on virtual device "
 				       "%s, fix it urgently!\n", dev->name);


