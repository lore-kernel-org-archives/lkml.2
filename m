Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab1DZVSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:18:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:1363 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345Ab1DZVPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:15:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="914749054"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: stable@kernel.org, #@linux.intel.com, 2.6.32+@linux.intel.com,
        sgruszka@redhat.com, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [101/106] From: iwlwifi: fix skb usage after free
Message-Id: <20110426211423.E6C583E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Date: Wed, 20 Apr 2011 15:57:14 +0200
Subject: iwlwifi: fix skb usage after free

[AK: Did some changes for the backport to .35. Stanislaw, please verify 
them]

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

Cc: stable@kernel.org # 2.6.32+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ linux-2.6.35.y/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1141,11 +1141,14 @@ int iwlagn_tx_queue_reclaim(struct iwl_p
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		tx_info = &txq->txb[txq->q.read_ptr];
-		iwlagn_tx_status(priv, tx_info->skb[0]);
+
+		if (WARN_ON_ONCE(tx_info->skb[0] == NULL))
+			continue;
 
 		hdr = (struct ieee80211_hdr *)tx_info->skb[0]->data;
-		if (hdr && ieee80211_is_data_qos(hdr->frame_control))
+		if (ieee80211_is_data_qos(hdr->frame_control))
 			nfreed++;
+		iwlagn_tx_status(priv, tx_info->skb[0]);
 		tx_info->skb[0] = NULL;
 
 		if (priv->cfg->ops->lib->txq_inval_byte_cnt_tbl)
