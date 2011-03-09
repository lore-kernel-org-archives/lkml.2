Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab1CIAyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:54:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41583 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879Ab1CIAyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:54:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KvIwCVJoLvILOqjcBWqMSZP4av8exRxm1/avcx+6AmqaZzu7tsse/BrBJrRM35+bwr
         0c5DQk369WV0tk6X9JPEgwOb4W2kUcOSOkYNNFI6OxSz/dmhkkxjmGfvz7ahI9DMSqWu
         A5F7u/lIG+d2w1M8KwWGI4WKgxHr6PTDYXSe4=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH next 2/5] staging: brcm80211: optimize kmalloc to kzalloc
Date: Wed,  9 Mar 2011 03:53:35 +0300
Message-Id: <1299632018-6774-2-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299632018-6774-1-git-send-email-a.beregalov@gmail.com>
References: <1299632018-6774-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzalloc rather than kmalloc followed by memset with 0.
Found by coccinelle.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |    4 +---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c    |    6 ++----
 drivers/staging/brcm80211/brcmfmac/wl_iw.c       |    9 +++------
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |    4 +---
 4 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index ab8e688..d473f64 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1931,14 +1931,12 @@ dhd_pub_t *dhd_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	}
 
 	/* Allocate primary dhd_info */
-	dhd = kmalloc(sizeof(dhd_info_t), GFP_ATOMIC);
+	dhd = kzalloc(sizeof(dhd_info_t), GFP_ATOMIC);
 	if (!dhd) {
 		DHD_ERROR(("%s: OOM - alloc dhd_info\n", __func__));
 		goto fail;
 	}
 
-	memset(dhd, 0, sizeof(dhd_info_t));
-
 	/*
 	 * Save the dhd_info into the priv
 	 */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 971d406..b74b3c6 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -2528,11 +2528,10 @@ static int dhdsdio_write_vars(dhd_bus_t *bus)
 	varaddr = (bus->ramsize - 4) - varsize;
 
 	if (bus->vars) {
-		vbuffer = kmalloc(varsize, GFP_ATOMIC);
+		vbuffer = kzalloc(varsize, GFP_ATOMIC);
 		if (!vbuffer)
 			return BCME_NOMEM;
 
-		memset(vbuffer, 0, varsize);
 		memcpy(vbuffer, bus->vars, bus->varsz);
 
 		/* Write the vars list */
@@ -5258,13 +5257,12 @@ dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
 		udelay(65);
 
 		for (fn = 0; fn <= numfn; fn++) {
-			cis[fn] = kmalloc(SBSDIO_CIS_SIZE_LIMIT, GFP_ATOMIC);
+			cis[fn] = kzalloc(SBSDIO_CIS_SIZE_LIMIT, GFP_ATOMIC);
 			if (!cis[fn]) {
 				DHD_INFO(("dhdsdio_probe: fn %d cis malloc "
 					"failed\n", fn));
 				break;
 			}
-			memset(cis[fn], 0, SBSDIO_CIS_SIZE_LIMIT);
 
 			err = bcmsdh_cis_read(sdh, fn, cis[fn],
 						SBSDIO_CIS_SIZE_LIMIT);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index 4d16644..b49957f 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -862,10 +862,9 @@ wl_iw_get_aplist(struct net_device *dev,
 	if (!extra)
 		return -EINVAL;
 
-	list = kmalloc(buflen, GFP_KERNEL);
+	list = kzalloc(buflen, GFP_KERNEL);
 	if (!list)
 		return -ENOMEM;
-	memset(list, 0, buflen);
 	list->buflen = cpu_to_le32(buflen);
 	error = dev_wlc_ioctl(dev, WLC_SCAN_RESULTS, list, buflen);
 	if (error) {
@@ -3667,11 +3666,10 @@ int wl_iw_attach(struct net_device *dev, void *dhdp)
 	params_size =
 	    (WL_SCAN_PARAMS_FIXED_SIZE + offsetof(wl_iscan_params_t, params));
 #endif
-	iscan = kmalloc(sizeof(iscan_info_t), GFP_KERNEL);
+	iscan = kzalloc(sizeof(iscan_info_t), GFP_KERNEL);
 
 	if (!iscan)
 		return -ENOMEM;
-	memset(iscan, 0, sizeof(iscan_info_t));
 
 	iscan->iscan_ex_params_p = kmalloc(params_size, GFP_KERNEL);
 	if (!iscan->iscan_ex_params_p)
@@ -3705,11 +3703,10 @@ int wl_iw_attach(struct net_device *dev, void *dhdp)
 	priv_dev = dev;
 	MUTEX_LOCK_SOFTAP_SET_INIT(iw->pub);
 #endif
-	g_scan = kmalloc(G_SCAN_RESULTS, GFP_KERNEL);
+	g_scan = kzalloc(G_SCAN_RESULTS, GFP_KERNEL);
 	if (!g_scan)
 		return -ENOMEM;
 
-	memset(g_scan, 0, G_SCAN_RESULTS);
 	g_scan_specified_ssid = 0;
 
 	return 0;
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 9fec1b7..5a1560f 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -1609,14 +1609,12 @@ struct wl_timer *wl_init_timer(struct wl_info *wl, void (*fn) (void *arg),
 {
 	struct wl_timer *t;
 
-	t = kmalloc(sizeof(struct wl_timer), GFP_ATOMIC);
+	t = kzalloc(sizeof(struct wl_timer), GFP_ATOMIC);
 	if (!t) {
 		WL_ERROR("wl%d: wl_init_timer: out of memory\n", wl->pub->unit);
 		return 0;
 	}
 
-	memset(t, 0, sizeof(struct wl_timer));
-
 	init_timer(&t->timer);
 	t->timer.data = (unsigned long) t;
 	t->timer.function = wl_timer;
-- 
1.7.4.1

