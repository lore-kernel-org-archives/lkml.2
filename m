Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab0LNA5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:57:20 -0500
Received: from mail.perches.com ([173.55.12.10]:2604 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518Ab0LNA5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:57:15 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Dowan Kim <dowan@broadcom.com>, Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 2/8] staging: brcm80211: Convert ETHER_IS_MULTI to is_multicast_ether_addr
Date: Mon, 13 Dec 2010 16:56:58 -0800
Message-Id: <98db550d8c4b7648561e561d9c00ddccaa6d194c.1292287722.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1292287720.git.joe@perches.com>
References: <cover.1292287720.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the standard kernel function.
Change callers to add .octet to addressing to avoid warnings.
Add #include <linux/etherdevice.h> where necessary.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    2 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |    2 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    2 +-
 drivers/staging/brcm80211/include/proto/ethernet.h |    2 --
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |   16 ++++++++++------
 drivers/staging/brcm80211/util/bcmsrom.c           |   11 ++++++-----
 6 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index a114dee..b37539c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1032,7 +1032,7 @@ int dhd_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf)
 		u8 *pktdata = (u8 *) (pktbuf->data);
 		struct ether_header *eh = (struct ether_header *)pktdata;
 
-		if (ETHER_ISMULTI(eh->ether_dhost))
+		if (is_multicast_ether_addr(eh->ether_dhost))
 			dhdp->tx_multicast++;
 		if (ntoh16(eh->ether_type) == ETHER_TYPE_802_1X)
 			atomic_inc(&dhd->pend_8021x_cnt);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index edf300d..59f7ca5 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1532,7 +1532,7 @@ wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 	key.index = (u32) key_idx;
 	/* Instead of bcast for ea address for default wep keys,
 		 driver needs it to be Null */
-	if (!ETHER_ISMULTI(mac_addr))
+	if (!is_multicast_ether_addr(mac_addr))
 		memcpy((char *)&key.ea, (void *)mac_addr, ETHER_ADDR_LEN);
 	key.len = (u32) params->key_len;
 	/* check for key index change */
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index d8600bf..2e0eab1 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -2548,7 +2548,7 @@ wl_iw_set_encodeext(struct net_device *dev,
 
 	key.len = iwe->key_len;
 
-	if (!ETHER_ISMULTI(iwe->addr.sa_data))
+	if (!is_multicast_ether_addr(iwe->addr.sa_data))
 		bcopy((void *)&iwe->addr.sa_data, (char *)&key.ea,
 		      ETHER_ADDR_LEN);
 
diff --git a/drivers/staging/brcm80211/include/proto/ethernet.h b/drivers/staging/brcm80211/include/proto/ethernet.h
index a8981f6..a2353a5 100644
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ b/drivers/staging/brcm80211/include/proto/ethernet.h
@@ -64,8 +64,6 @@ BWL_PRE_PACKED_STRUCT struct ether_addr {
 
 #define ETHER_SET_UNICAST(ea)	(((u8 *)(ea))[0] = (((u8 *)(ea))[0] & ~1))
 
-#define ETHER_ISMULTI(ea) (((const u8 *)(ea))[0] & 1)
-
 #define	ether_cmp(a, b)	(!(((short *)a)[0] == ((short *)b)[0]) | \
 			 !(((short *)a)[1] == ((short *)b)[1]) | \
 			 !(((short *)a)[2] == ((short *)b)[2]))
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index e4a4365..24bf64d 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -15,6 +15,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/ctype.h>
+#include <linux/etherdevice.h>
 #include <bcmdefs.h>
 #include <bcmdevs.h>
 #include <wlc_cfg.h>
@@ -5802,7 +5803,8 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 			ASSERT(RSPEC_ACTIVE(rspec[k]));
 			rspec[k] = WLC_RATE_1M;
 		} else {
-			if (WLANTSEL_ENAB(wlc) && !ETHER_ISMULTI(&h->a1)) {
+			if (WLANTSEL_ENAB(wlc) &&
+			    !is_multicast_ether_addr(h->a1.octet)) {
 				/* set tx antenna config */
 				wlc_antsel_antcfg_get(wlc->asi, false, false, 0,
 						      0, &antcfg, &fbantcfg);
@@ -5963,7 +5965,8 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	    plcp[0];
 
 	/* DUR field for main rate */
-	if ((fc != FC_PS_POLL) && !ETHER_ISMULTI(&h->a1) && !use_rifs) {
+	if ((fc != FC_PS_POLL) &&
+	    !is_multicast_ether_addr(h->a1.octet) && !use_rifs) {
 		durid =
 		    wlc_compute_frame_dur(wlc, rspec[0], preamble_type[0],
 					  next_frag_len);
@@ -5981,7 +5984,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	/* DUR field for fallback rate */
 	if (fc == FC_PS_POLL)
 		txh->FragDurFallback = h->durid;
-	else if (ETHER_ISMULTI(&h->a1) || use_rifs)
+	else if (is_multicast_ether_addr(h->a1.octet) || use_rifs)
 		txh->FragDurFallback = 0;
 	else {
 		durid = wlc_compute_frame_dur(wlc, rspec[1],
@@ -5993,7 +5996,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	if (frag == 0)
 		mcl |= TXC_STARTMSDU;
 
-	if (!ETHER_ISMULTI(&h->a1))
+	if (!is_multicast_ether_addr(h->a1.octet))
 		mcl |= TXC_IMMEDACK;
 
 	if (BAND_5G(wlc->band->bandtype))
@@ -6222,7 +6225,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	if (SCB_WME(scb) && qos && wlc->edcf_txop[ac]) {
 		uint frag_dur, dur, dur_fallback;
 
-		ASSERT(!ETHER_ISMULTI(&h->a1));
+		ASSERT(!is_multicast_ether_addr(h->a1.octet));
 
 		/* WME: Update TXOP threshold */
 		if ((!(tx_info->flags & IEEE80211_TX_CTL_AMPDU)) && (frag == 0)) {
@@ -7023,7 +7026,8 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 	if (!is_amsdu) {
 		/* CTS and ACK CTL frames are w/o a2 */
 		if (FC_TYPE(fc) == FC_TYPE_DATA || FC_TYPE(fc) == FC_TYPE_MNG) {
-			if ((ETHER_ISNULLADDR(&h->a2) || ETHER_ISMULTI(&h->a2))) {
+			if ((ETHER_ISNULLADDR(&h->a2) ||
+			     is_multicast_ether_addr(h->a2.octet))) {
 				WL_ERROR(("wl%d: %s: dropping a frame with "
 					"invalid src mac address, a2: %pM\n",
 					wlc->pub->unit, __func__, &h->a2));
diff --git a/drivers/staging/brcm80211/util/bcmsrom.c b/drivers/staging/brcm80211/util/bcmsrom.c
index 3a0beb9..8393d58 100644
--- a/drivers/staging/brcm80211/util/bcmsrom.c
+++ b/drivers/staging/brcm80211/util/bcmsrom.c
@@ -15,6 +15,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <linux/etherdevice.h>
 #include <bcmdefs.h>
 #include <osl.h>
 #include <linux/module.h>
@@ -499,10 +500,10 @@ int srom_parsecis(struct osl_info *osh, u8 *pcis[], uint ciscnt, char **vars,
 					break;
 				default:
 					/* set macaddr if HNBU_MACADDR not seen yet */
-					if (eabuf[0] == '\0'
-					    && cis[i] == LAN_NID
-					    && !(ETHER_ISNULLADDR(&cis[i + 2]))
-					    && !(ETHER_ISMULTI(&cis[i + 2]))) {
+					if (eabuf[0] == '\0' &&
+					    cis[i] == LAN_NID &&
+					    !(ETHER_ISNULLADDR(&cis[i + 2])) &&
+					    !is_multicast_ether_addr(&cis[i + 2])) {
 						ASSERT(cis[i + 1] ==
 						       ETHER_ADDR_LEN);
 						snprintf(eabuf, sizeof(eabuf),
@@ -974,7 +975,7 @@ int srom_parsecis(struct osl_info *osh, u8 *pcis[], uint ciscnt, char **vars,
 
 				case HNBU_MACADDR:
 					if (!(ETHER_ISNULLADDR(&cis[i + 1])) &&
-					    !(ETHER_ISMULTI(&cis[i + 1]))) {
+					    !is_multicast_ether_addr(&cis[i + 1])) {
 						snprintf(eabuf, sizeof(eabuf),
 							"%pM", &cis[i + 1]);
 
-- 
1.7.3.3.398.g0b0cd.dirty

