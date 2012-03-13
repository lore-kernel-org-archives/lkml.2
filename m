Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965204Ab2CMAYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:24:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:48810 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965137Ab2CMAYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 167/196] iwlwifi: fix skb usage after free
Date: Mon, 12 Mar 2012 20:21:20 -0400
Message-Id: <1331598109-31424-122-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislaw Gruszka <sgruszka@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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

[PG: since 34, file renamed, + iwlagn_tx_status --> iwl_tx_status]

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index e950153..92a5f9e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1234,11 +1234,15 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		tx_info = &txq->txb[txq->q.read_ptr];
-		iwl_tx_status(priv, tx_info->skb[0]);
+
+		if (WARN_ON_ONCE(tx_info->skb == NULL))
+			continue;
 
 		hdr = (struct ieee80211_hdr *)tx_info->skb[0]->data;
-		if (hdr && ieee80211_is_data_qos(hdr->frame_control))
+		if (ieee80211_is_data_qos(hdr->frame_control))
 			nfreed++;
+
+		iwl_tx_status(priv, tx_info->skb[0]);
 		tx_info->skb[0] = NULL;
 
 		if (priv->cfg->ops->lib->txq_inval_byte_cnt_tbl)
-- 
1.7.9.3

