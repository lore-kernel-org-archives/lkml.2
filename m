Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629Ab2EJRfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:35:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52779 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760631Ab2EJRfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:35:04 -0400
Message-Id: <20120510173135.689856095@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Stephen Ko <stephen.s.ko@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 32/52] net: Add memory barriers to prevent possible race in byte queue limits
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alexander Duyck <alexander.h.duyck@intel.com>

[ Upstream commit b37c0fbe3f6dfba1f8ad2aed47fb40578a254635 ]

This change adds a memory barrier to the byte queue limit code to address a
possible race as has been seen in the past with the
netif_stop_queue/netif_wake_queue logic.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Tested-by: Stephen Ko <stephen.s.ko@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |   49 ++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1898,12 +1898,22 @@ static inline void netdev_tx_sent_queue(
 {
 #ifdef CONFIG_BQL
 	dql_queued(&dev_queue->dql, bytes);
-	if (unlikely(dql_avail(&dev_queue->dql) < 0)) {
-		set_bit(__QUEUE_STATE_STACK_XOFF, &dev_queue->state);
-		if (unlikely(dql_avail(&dev_queue->dql) >= 0))
-			clear_bit(__QUEUE_STATE_STACK_XOFF,
-			    &dev_queue->state);
-	}
+
+	if (likely(dql_avail(&dev_queue->dql) >= 0))
+		return;
+
+	set_bit(__QUEUE_STATE_STACK_XOFF, &dev_queue->state);
+
+	/*
+	 * The XOFF flag must be set before checking the dql_avail below,
+	 * because in netdev_tx_completed_queue we update the dql_completed
+	 * before checking the XOFF flag.
+	 */
+	smp_mb();
+
+	/* check again in case another CPU has just made room avail */
+	if (unlikely(dql_avail(&dev_queue->dql) >= 0))
+		clear_bit(__QUEUE_STATE_STACK_XOFF, &dev_queue->state);
 #endif
 }
 
@@ -1916,16 +1926,23 @@ static inline void netdev_tx_completed_q
 					     unsigned pkts, unsigned bytes)
 {
 #ifdef CONFIG_BQL
-	if (likely(bytes)) {
-		dql_completed(&dev_queue->dql, bytes);
-		if (unlikely(test_bit(__QUEUE_STATE_STACK_XOFF,
-		    &dev_queue->state) &&
-		    dql_avail(&dev_queue->dql) >= 0)) {
-			if (test_and_clear_bit(__QUEUE_STATE_STACK_XOFF,
-			     &dev_queue->state))
-				netif_schedule_queue(dev_queue);
-		}
-	}
+	if (unlikely(!bytes))
+		return;
+
+	dql_completed(&dev_queue->dql, bytes);
+
+	/*
+	 * Without the memory barrier there is a small possiblity that
+	 * netdev_tx_sent_queue will miss the update and cause the queue to
+	 * be stopped forever
+	 */
+	smp_mb();
+
+	if (dql_avail(&dev_queue->dql) < 0)
+		return;
+
+	if (test_and_clear_bit(__QUEUE_STATE_STACK_XOFF, &dev_queue->state))
+		netif_schedule_queue(dev_queue);
 #endif
 }
 


