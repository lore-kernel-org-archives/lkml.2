Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab0C3Xx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:53:56 -0400
Received: from kroah.org ([198.145.64.141]:45717 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401Ab0C3XTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:25 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:30 2010
Message-Id: <20100330224729.833649732@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:40:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bob Copeland <me@bobcopeland.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [015/156] ath5k: fix setup for CAB queue
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bob Copeland <me@bobcopeland.com>

commit a951ae2176b982574ffa197455db6c89359fd5eb upstream.

The beacon sent gating doesn't seem to work with any combination
of flags.  Thus, buffered frames tend to stay buffered forever,
using up tx descriptors.

Instead, use the DBA gating and hold transmission of the buffered
frames until 80% of the beacon interval has elapsed using the ready
time.  This fixes the following error in AP mode:

   ath5k phy0: no further txbuf available, dropping packet

Add a comment to acknowledge that this isn't the best solution.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/ath5k.h |    2 +-
 drivers/net/wireless/ath/ath5k/base.c  |   22 +++++++++++++++++++---
 drivers/net/wireless/ath/ath5k/qcu.c   |    5 +++--
 3 files changed, 23 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -535,7 +535,7 @@ struct ath5k_txq_info {
 	u32	tqi_cbr_period; /* Constant bit rate period */
 	u32	tqi_cbr_overflow_limit;
 	u32	tqi_burst_time;
-	u32	tqi_ready_time; /* Not used */
+	u32	tqi_ready_time; /* Time queue waits after an event */
 };
 
 /*
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1537,7 +1537,8 @@ ath5k_beaconq_config(struct ath5k_softc
 
 	ret = ath5k_hw_get_tx_queueprops(ah, sc->bhalq, &qi);
 	if (ret)
-		return ret;
+		goto err;
+
 	if (sc->opmode == NL80211_IFTYPE_AP ||
 		sc->opmode == NL80211_IFTYPE_MESH_POINT) {
 		/*
@@ -1564,10 +1565,25 @@ ath5k_beaconq_config(struct ath5k_softc
 	if (ret) {
 		ATH5K_ERR(sc, "%s: unable to update parameters for beacon "
 			"hardware queue!\n", __func__);
-		return ret;
+		goto err;
 	}
+	ret = ath5k_hw_reset_tx_queue(ah, sc->bhalq); /* push to h/w */
+	if (ret)
+		goto err;
+
+	/* reconfigure cabq with ready time to 80% of beacon_interval */
+	ret = ath5k_hw_get_tx_queueprops(ah, AR5K_TX_QUEUE_ID_CAB, &qi);
+	if (ret)
+		goto err;
+
+	qi.tqi_ready_time = (sc->bintval * 80) / 100;
+	ret = ath5k_hw_set_tx_queueprops(ah, AR5K_TX_QUEUE_ID_CAB, &qi);
+	if (ret)
+		goto err;
 
-	return ath5k_hw_reset_tx_queue(ah, sc->bhalq); /* push to h/w */;
+	ret = ath5k_hw_reset_tx_queue(ah, AR5K_TX_QUEUE_ID_CAB);
+err:
+	return ret;
 }
 
 static void
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -408,12 +408,13 @@ int ath5k_hw_reset_tx_queue(struct ath5k
 			break;
 
 		case AR5K_TX_QUEUE_CAB:
+			/* XXX: use BCN_SENT_GT, if we can figure out how */
 			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
-				AR5K_QCU_MISC_FRSHED_BCN_SENT_GT |
+				AR5K_QCU_MISC_FRSHED_DBA_GT |
 				AR5K_QCU_MISC_CBREXP_DIS |
 				AR5K_QCU_MISC_CBREXP_BCN_DIS);
 
-			ath5k_hw_reg_write(ah, ((AR5K_TUNE_BEACON_INTERVAL -
+			ath5k_hw_reg_write(ah, ((tq->tqi_ready_time -
 				(AR5K_TUNE_SW_BEACON_RESP -
 				AR5K_TUNE_DMA_BEACON_RESP) -
 				AR5K_TUNE_ADDITIONAL_SWBA_BACKOFF) * 1024) |


