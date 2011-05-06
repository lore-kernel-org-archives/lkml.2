Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab1EFAg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:36:58 -0400
Received: from kroah.org ([198.145.64.141]:37417 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932530Ab1EFA0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:26:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:19 2011
Message-Id: <20110506002219.018445926@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:22:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [140/143] iwlwifi: fix skb usage after free
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit b25026981aecde3685dd0e45ad980fff9f528daa upstream.

Since

commit a120e912eb51e347f36c71b60a1d13af74d30e83
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Fri Feb 19 15:47:33 2010 -0800

    iwlwifi: sanity check before counting number of tfds can be free

we use skb->data after calling ieee80211_tx_status_irqsafe(), which
could free skb instantly.

On current kernels I do not observe practical problems related with
bug, but on 2.6.35.y it cause random system hangs when stressing
wireless link.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1088,11 +1088,15 @@ int iwl_tx_queue_reclaim(struct iwl_priv
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		tx_info = &txq->txb[txq->q.read_ptr];
-		ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb[0]);
+
+		if (WARN_ON_ONCE(tx_info->skb == NULL))
+			continue;
 
 		hdr = (struct ieee80211_hdr *)tx_info->skb[0]->data;
-		if (hdr && ieee80211_is_data_qos(hdr->frame_control))
+		if (ieee80211_is_data_qos(hdr->frame_control))
 			nfreed++;
+
+		ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb[0]);
 		tx_info->skb[0] = NULL;
 
 		if (priv->cfg->ops->lib->txq_inval_byte_cnt_tbl)


