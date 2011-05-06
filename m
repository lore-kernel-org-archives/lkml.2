Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab1EFAr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:47:27 -0400
Received: from kroah.org ([198.145.64.141]:37028 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325Ab1EFAZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:14 2011
Message-Id: <20110506002214.036157708@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Ivo van Doorn <ivdoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [090/143] rt2x00: Properly request tx headroom for alignment operations.
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Gertjan van Wingerde <gwingerde@gmail.com>

commit 7a4a77b7771164d61ce702a588067d1e1d66db7c upstream.

Current rt2x00 drivers may result in a "ieee80211_tx_status: headroom too
small" error message when a frame needs to be properly aligned before
transmitting it.
This is because the space needed to ensure proper alignment isn't
requested from mac80211.
Fix this by adding sufficient amount of alignment space to the amount
of headroom requested for TX frames.

Reported-by: David Ellingsworth <david@identd.dyndns.org>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <ivdoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    6 ++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c |   12 +++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -112,6 +112,12 @@
 	(  ((unsigned long)((__skb)->data + (__header))) & 3 )
 
 /*
+ * Constants for extra TX headroom for alignment purposes.
+ */
+#define RT2X00_ALIGN_SIZE	4 /* Only whole frame needs alignment */
+#define RT2X00_L2PAD_SIZE	8 /* Both header & payload need alignment */
+
+/*
  * Standard timing and size defines.
  * These values should follow the ieee80211 specifications.
  */
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -686,7 +686,17 @@ static int rt2x00lib_probe_hw(struct rt2
 	/*
 	 * Initialize extra TX headroom required.
 	 */
-	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom;
+	rt2x00dev->hw->extra_tx_headroom =
+		max_t(unsigned int, IEEE80211_TX_STATUS_HEADROOM,
+		      rt2x00dev->ops->extra_tx_headroom);
+
+	/*
+	 * Take TX headroom required for alignment into account.
+	 */
+	if (test_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags))
+		rt2x00dev->hw->extra_tx_headroom += RT2X00_L2PAD_SIZE;
+	else if (test_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags))
+		rt2x00dev->hw->extra_tx_headroom += RT2X00_ALIGN_SIZE;
 
 	/*
 	 * Register HW.


