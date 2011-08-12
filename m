Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab1HNQGL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:06:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab1HNQGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:06:08 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:53 2011
Message-Id: <20110812210552.984561801@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:03:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [10/90] rt2x00: fix usage of NULL queue
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 00898a47269ae5e6dda04defad00234b96692d95 upstream.

We may call rt2x00queue_pause_queue(queue) with queue == NULL. Bug
was introduced by commit 62fe778412b36791b7897cfa139342906fbbf07b
"rt2x00: Fix stuck queue in tx failure case" .

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -113,7 +113,7 @@ void rt2x00mac_tx(struct ieee80211_hw *h
 	 * due to possible race conditions in mac80211.
 	 */
 	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
-		goto exit_fail;
+		goto exit_free_skb;
 
 	/*
 	 * Use the ATIM queue if appropriate and present.
@@ -127,7 +127,7 @@ void rt2x00mac_tx(struct ieee80211_hw *h
 		ERROR(rt2x00dev,
 		      "Attempt to send packet over invalid queue %d.\n"
 		      "Please file bug report to %s.\n", qid, DRV_PROJECT);
-		goto exit_fail;
+		goto exit_free_skb;
 	}
 
 	/*
@@ -159,6 +159,7 @@ void rt2x00mac_tx(struct ieee80211_hw *h
 
  exit_fail:
 	rt2x00queue_pause_queue(queue);
+ exit_free_skb:
 	dev_kfree_skb_any(skb);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_tx);


