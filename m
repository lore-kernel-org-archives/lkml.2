Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946543Ab2CPXt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:49:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946227Ab2CPXj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:39:59 -0400
Message-Id: <20120316233811.305109391@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislaw Gruszka <sgruszka@redhat.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 08/41] rt2x00: fix random stalls
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 3780d038fdf4b5ef26ead10b0604ab1f46dd9510 upstream.

Is possible that we stop queue and then do not wake up it again,
especially when packets are transmitted fast. That can be easily
reproduced with modified tx queue entry_num to some small value e.g. 16.

If mac80211 already hold local->queue_stop_reason_lock, then we can wait
on that lock in both rt2x00queue_pause_queue() and
rt2x00queue_unpause_queue(). After drooping ->queue_stop_reason_lock
is possible that __ieee80211_wake_queue() will be performed before
__ieee80211_stop_queue(), hence we stop queue and newer wake up it
again.

Another race condition is possible when between rt2x00queue_threshold()
check and rt2x00queue_pause_queue() we will process all pending tx
buffers on different cpu. This might happen if for example interrupt
will be triggered on cpu performing rt2x00mac_tx().

To prevent race conditions serialize pause/unpause by queue->tx_lock.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    6 +++++-
 drivers/net/wireless/rt2x00/rt2x00mac.c   |    9 +++++++++
 drivers/net/wireless/rt2x00/rt2x00queue.c |    3 +++
 3 files changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -426,10 +426,14 @@ void rt2x00lib_txdone(struct queue_entry
 	/*
 	 * If the data queue was below the threshold before the txdone
 	 * handler we must make sure the packet queue in the mac80211 stack
-	 * is reenabled when the txdone handler has finished.
+	 * is reenabled when the txdone handler has finished. This has to be
+	 * serialized with rt2x00mac_tx(), otherwise we can wake up queue
+	 * before it was stopped.
 	 */
+	spin_lock_bh(&entry->queue->tx_lock);
 	if (!rt2x00queue_threshold(entry->queue))
 		rt2x00queue_unpause_queue(entry->queue);
+	spin_unlock_bh(&entry->queue->tx_lock);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
 
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -152,13 +152,22 @@ void rt2x00mac_tx(struct ieee80211_hw *h
 	if (unlikely(rt2x00queue_write_tx_frame(queue, skb, false)))
 		goto exit_fail;
 
+	/*
+	 * Pausing queue has to be serialized with rt2x00lib_txdone(). Note
+	 * we should not use spin_lock_bh variant as bottom halve was already
+	 * disabled before ieee80211_xmit() call.
+	 */
+	spin_lock(&queue->tx_lock);
 	if (rt2x00queue_threshold(queue))
 		rt2x00queue_pause_queue(queue);
+	spin_unlock(&queue->tx_lock);
 
 	return;
 
  exit_fail:
+	spin_lock(&queue->tx_lock);
 	rt2x00queue_pause_queue(queue);
+	spin_unlock(&queue->tx_lock);
  exit_free_skb:
 	dev_kfree_skb_any(skb);
 }
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -619,6 +619,9 @@ int rt2x00queue_write_tx_frame(struct da
 	else if (test_bit(REQUIRE_DMA, &queue->rt2x00dev->cap_flags))
 		rt2x00queue_align_frame(skb);
 
+	/*
+	 * That function must be called with bh disabled.
+	 */
 	spin_lock(&queue->tx_lock);
 
 	if (unlikely(rt2x00queue_full(queue))) {


