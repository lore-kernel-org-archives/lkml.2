Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab0LNA6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:58:17 -0500
Received: from mail.perches.com ([173.55.12.10]:2614 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758795Ab0LNA5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:57:19 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Dowan Kim <dowan@broadcom.com>, Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 4/8] staging: brcm80211: Convert ETHER_IS<FOO> to is_<foo>_ether_addr
Date: Mon, 13 Dec 2010 16:57:00 -0800
Message-Id: <d812ddafafdf487a2ac617c241f3cc334e1190cb.1292287723.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1292287720.git.joe@perches.com>
References: <cover.1292287720.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the normal kernel calls and remove the #defines
for ETHER_IS_BCAST and ETHER_IS_NULLADDR.

Add #include for etherdevice.h where necessary.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    3 ++-
 drivers/staging/brcm80211/include/proto/ethernet.h |   13 -------------
 drivers/staging/brcm80211/sys/wlc_bmac.c           |    5 +++--
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |    6 +++---
 drivers/staging/brcm80211/util/bcmsrom.c           |    4 ++--
 5 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index 2e0eab1..abf5d743 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -772,7 +772,8 @@ wl_iw_set_wap(struct net_device *dev,
 		return -EINVAL;
 	}
 
-	if (ETHER_ISBCAST(awrq->sa_data) || ETHER_ISNULLADDR(awrq->sa_data)) {
+	if (is_broadcast_ether_addr(awrq->sa_data) ||
+	    is_zero_ether_addr(awrq->sa_data)) {
 		scb_val_t scbval;
 		memset(&scbval, 0, sizeof(scb_val_t));
 		(void)dev_wlc_ioctl(dev, WLC_DISASSOC, &scbval,
diff --git a/drivers/staging/brcm80211/include/proto/ethernet.h b/drivers/staging/brcm80211/include/proto/ethernet.h
index 1b352c5..086b9b9 100644
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ b/drivers/staging/brcm80211/include/proto/ethernet.h
@@ -66,19 +66,6 @@ BWL_PRE_PACKED_STRUCT struct ether_addr {
 
 static const struct ether_addr ether_bcast = { {255, 255, 255, 255, 255, 255} };
 
-#define ETHER_ISBCAST(ea)	((((u8 *)(ea))[0] &		\
-	((u8 *)(ea))[1] &		\
-	((u8 *)(ea))[2] &		\
-	((u8 *)(ea))[3] &		\
-	((u8 *)(ea))[4] &		\
-	((u8 *)(ea))[5]) == 0xff)
-#define ETHER_ISNULLADDR(ea)	((((u8 *)(ea))[0] |		\
-	((u8 *)(ea))[1] |		\
-	((u8 *)(ea))[2] |		\
-	((u8 *)(ea))[3] |		\
-	((u8 *)(ea))[4] |		\
-	((u8 *)(ea))[5]) == 0)
-
 #define ETHER_MOVE_HDR(d, s) \
 do { \
 	struct ether_header t; \
diff --git a/drivers/staging/brcm80211/sys/wlc_bmac.c b/drivers/staging/brcm80211/sys/wlc_bmac.c
index dff4f6b..2baacfd 100644
--- a/drivers/staging/brcm80211/sys/wlc_bmac.c
+++ b/drivers/staging/brcm80211/sys/wlc_bmac.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 #include <bcmdefs.h>
 #include <osl.h>
 #include <proto/802.11.h>
@@ -1022,8 +1023,8 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		goto fail;
 	}
 	bcm_ether_atoe(macaddr, &wlc_hw->etheraddr);
-	if (ETHER_ISBCAST((char *)&wlc_hw->etheraddr) ||
-	    ETHER_ISNULLADDR((char *)&wlc_hw->etheraddr)) {
+	if (is_broadcast_ether_addr(wlc_hw->etheraddr.octet) ||
+	    is_zero_ether_addr(wlc_hw->etheraddr.octet)) {
 		WL_ERROR(("wl%d: wlc_bmac_attach: bad macaddr %s\n", unit,
 			  macaddr));
 		err = 22;
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index 24bf64d..daa67c9 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -3633,8 +3633,8 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 				u16 lo;
 				u32 hi;
 				/* group keys in WPA-NONE (IBSS only, AES and TKIP) use a global TXIV */
-				if ((bsscfg->WPA_auth & WPA_AUTH_NONE)
-				    && ETHER_ISNULLADDR(&key->ea)) {
+				if ((bsscfg->WPA_auth & WPA_AUTH_NONE) &&
+				    is_zero_ether_addr(key->ea.octet)) {
 					lo = bsscfg->wpa_none_txiv.lo;
 					hi = bsscfg->wpa_none_txiv.hi;
 				} else {
@@ -7026,7 +7026,7 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 	if (!is_amsdu) {
 		/* CTS and ACK CTL frames are w/o a2 */
 		if (FC_TYPE(fc) == FC_TYPE_DATA || FC_TYPE(fc) == FC_TYPE_MNG) {
-			if ((ETHER_ISNULLADDR(&h->a2) ||
+			if ((is_zero_ether_addr(h->a2.octet) ||
 			     is_multicast_ether_addr(h->a2.octet))) {
 				WL_ERROR(("wl%d: %s: dropping a frame with "
 					"invalid src mac address, a2: %pM\n",
diff --git a/drivers/staging/brcm80211/util/bcmsrom.c b/drivers/staging/brcm80211/util/bcmsrom.c
index 8393d58..668dac6 100644
--- a/drivers/staging/brcm80211/util/bcmsrom.c
+++ b/drivers/staging/brcm80211/util/bcmsrom.c
@@ -502,7 +502,7 @@ int srom_parsecis(struct osl_info *osh, u8 *pcis[], uint ciscnt, char **vars,
 					/* set macaddr if HNBU_MACADDR not seen yet */
 					if (eabuf[0] == '\0' &&
 					    cis[i] == LAN_NID &&
-					    !(ETHER_ISNULLADDR(&cis[i + 2])) &&
+					    !is_zero_ether_addr(&cis[i + 2]) &&
 					    !is_multicast_ether_addr(&cis[i + 2])) {
 						ASSERT(cis[i + 1] ==
 						       ETHER_ADDR_LEN);
@@ -974,7 +974,7 @@ int srom_parsecis(struct osl_info *osh, u8 *pcis[], uint ciscnt, char **vars,
 					break;
 
 				case HNBU_MACADDR:
-					if (!(ETHER_ISNULLADDR(&cis[i + 1])) &&
+					if (!is_zero_ether_addr(&cis[i + 1]) &&
 					    !is_multicast_ether_addr(&cis[i + 1])) {
 						snprintf(eabuf, sizeof(eabuf),
 							"%pM", &cis[i + 1]);
-- 
1.7.3.3.398.g0b0cd.dirty

