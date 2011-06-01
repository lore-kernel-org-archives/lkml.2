Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162662Ab1FAIWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:22:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:44719 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162615Ab1FAIWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:22:44 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:41 2011
Message-Id: <20110601081141.200243393@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:56 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Vossen <rvossen@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [086/165] staging: brcm80211: bugfix for div by zero in
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 minstrel_ht_tx_status
Content-Length: 1944
Lines: 53

From: Roland Vossen <rvossen@broadcom.com>

commit e9c661e08c2a6015c1b7cba1cecefa27a089df71 upstream.

Caused by brcmsmac.ko suppling a 0 value to Mac80211. Mac80211 subsequently
divides by this number. Bug only occurred on AMPDU traffic. This is a fix
for https://bugzilla.kernel.org/show_bug.cgi?id=32032, titled
'Divide error in minstrel_ht_tx_status followed by hang', reported by
Wouter Cloetens.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -1123,21 +1123,12 @@ wlc_ampdu_dotxstatus_complete(struct amp
 				ini->txretry[index] = 0;
 
 				/* ampdu_ack_len: number of acked aggregated frames */
-				/* ampdu_ack_map: block ack bit map for the aggregation */
 				/* ampdu_len: number of aggregated frames */
 				rate_status(wlc, tx_info, txs, mcs);
 				tx_info->flags |= IEEE80211_TX_STAT_ACK;
 				tx_info->flags |= IEEE80211_TX_STAT_AMPDU;
-
-				/* XXX TODO: Make these accurate. */
 				tx_info->status.ampdu_ack_len =
-				    (txs->
-				     status & TX_STATUS_FRM_RTX_MASK) >>
-				    TX_STATUS_FRM_RTX_SHIFT;
-				tx_info->status.ampdu_len =
-				    (txs->
-				     status & TX_STATUS_FRM_RTX_MASK) >>
-				    TX_STATUS_FRM_RTX_SHIFT;
+					tx_info->status.ampdu_len = 1;
 
 				skb_pull(p, D11_PHY_HDR_LEN);
 				skb_pull(p, D11_TXH_LEN);
@@ -1163,6 +1154,8 @@ wlc_ampdu_dotxstatus_complete(struct amp
 				/* Retry timeout */
 				ini->tx_in_transit--;
 				ieee80211_tx_info_clear_status(tx_info);
+				tx_info->status.ampdu_ack_len = 0;
+				tx_info->status.ampdu_len = 1;
 				tx_info->flags |=
 				    IEEE80211_TX_STAT_AMPDU_NO_BACK;
 				skb_pull(p, D11_PHY_HDR_LEN);


