Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1ATGRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 01:17:15 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52563 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab1ATGRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 01:17:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F34WMhe8NUBq7EfotbC7aiJm+tiR7U78VxBdFhal7a2C9PlL3wwD+y9cv5ytwv4ES3
         HkQ3HMLT9eR1UtNREURBxJuWhf18IEnbeFLmEllFAJ9p1jOEx3mgUutKgijaa7cXKPIx
         jnLKFetClp2/UD8HZpPNrJthZ5pM1tPmxHebY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 3/3]staging: brcm80211 Remove WAKE_LOCK
Date: Wed, 19 Jan 2011 22:16:06 -0800
Message-Id: <1295504166-1042-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
In-Reply-To: <1295504166-1042-2-git-send-email-justinmattock@gmail.com>
References: <1295504166-1042-1-git-send-email-justinmattock@gmail.com>
 <1295504166-1042-2-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes WAKE_LOCK since it is no longer in the kernel.
Please let me know, if this is the proper way of doing this and/or more needs
to be done..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |    2 -
 drivers/staging/brcm80211/brcmfmac/dhd.h          |   15 ---------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |   33 ---------------------
 drivers/staging/brcm80211/brcmfmac/wl_iw.c        |    4 --
 4 files changed, 0 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index d24b5e7..143e860 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -328,8 +328,6 @@ static irqreturn_t wlan_oob_irq(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
-	WAKE_LOCK_TIMEOUT(dhdp, WAKE_LOCK_TMOUT, 25);
-
 	dhdsdio_isr((void *)dhdp->bus);
 
 	return IRQ_HANDLED;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 6a382c8..4383210 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -49,21 +49,6 @@ enum dhd_bus_state {
 	DHD_BUS_DATA		/* Ready for frame transfers */
 };
 
-enum dhd_bus_wake_state {
-	WAKE_LOCK_OFF,
-	WAKE_LOCK_PRIV,
-	WAKE_LOCK_DPC,
-	WAKE_LOCK_IOCTL,
-	WAKE_LOCK_DOWNLOAD,
-	WAKE_LOCK_TMOUT,
-	WAKE_LOCK_WATCHDOG,
-	WAKE_LOCK_LINK_DOWN_TMOUT,
-	WAKE_LOCK_PNO_FIND_TMOUT,
-	WAKE_LOCK_SOFTAP_SET,
-	WAKE_LOCK_SOFTAP_STOP,
-	WAKE_LOCK_SOFTAP_START,
-	WAKE_LOCK_MAX
-};
 enum dhd_prealloc_index {
 	DHD_PREALLOC_PROT = 0,
 	DHD_PREALLOC_RXBUF,
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index db45083..bf9e01a 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1045,7 +1045,6 @@ int dhd_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf)
 #ifdef BCMDBUS
 	ret = dbus_send_pkt(dhdp->dbus, pktbuf, NULL /* pktinfo */);
 #else
-	WAKE_LOCK_TIMEOUT(dhdp, WAKE_LOCK_TMOUT, 25);
 	ret = dhd_bus_txdata(dhdp->bus, pktbuf);
 #endif				/* BCMDBUS */
 
@@ -1304,7 +1303,6 @@ static struct net_device_stats *dhd_get_stats(struct net_device *net)
 static int dhd_watchdog_thread(void *data)
 {
 	dhd_info_t *dhd = (dhd_info_t *) data;
-	WAKE_LOCK_INIT(&dhd->pub, WAKE_LOCK_WATCHDOG, "dhd_watchdog_thread");
 
 	/* This thread doesn't need any user-level access,
 	 * so get rid of all our resources
@@ -1325,18 +1323,14 @@ static int dhd_watchdog_thread(void *data)
 			break;
 		if (down_interruptible(&dhd->watchdog_sem) == 0) {
 			if (dhd->pub.dongle_reset == false) {
-				WAKE_LOCK(&dhd->pub, WAKE_LOCK_WATCHDOG);
 				/* Call the bus module watchdog */
 				dhd_bus_watchdog(&dhd->pub);
-				WAKE_UNLOCK(&dhd->pub, WAKE_LOCK_WATCHDOG);
 			}
 			/* Count the tick for reference */
 			dhd->pub.tickcnt++;
 		} else
 			break;
 	}
-
-	WAKE_LOCK_DESTROY(&dhd->pub, WAKE_LOCK_WATCHDOG);
 	return 0;
 }
 
@@ -1370,7 +1364,6 @@ static int dhd_dpc_thread(void *data)
 {
 	dhd_info_t *dhd = (dhd_info_t *) data;
 
-	WAKE_LOCK_INIT(&dhd->pub, WAKE_LOCK_DPC, "dhd_dpc_thread");
 	/* This thread doesn't need any user-level access,
 	 * so get rid of all our resources
 	 */
@@ -1393,21 +1386,15 @@ static int dhd_dpc_thread(void *data)
 			/* Call bus dpc unless it indicated down
 				 (then clean stop) */
 			if (dhd->pub.busstate != DHD_BUS_DOWN) {
-				WAKE_LOCK(&dhd->pub, WAKE_LOCK_DPC);
 				if (dhd_bus_dpc(dhd->pub.bus)) {
 					up(&dhd->dpc_sem);
-					WAKE_LOCK_TIMEOUT(&dhd->pub,
-							  WAKE_LOCK_TMOUT, 25);
 				}
-				WAKE_UNLOCK(&dhd->pub, WAKE_LOCK_DPC);
 			} else {
 				dhd_bus_stop(dhd->pub.bus, true);
 			}
 		} else
 			break;
 	}
-
-	WAKE_LOCK_DESTROY(&dhd->pub, WAKE_LOCK_DPC);
 	return 0;
 }
 
@@ -1797,14 +1784,9 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 	if (is_set_key_cmd)
 		dhd_wait_pend8021x(net);
 
-	WAKE_LOCK_INIT(&dhd->pub, WAKE_LOCK_IOCTL, "dhd_ioctl_entry");
-	WAKE_LOCK(&dhd->pub, WAKE_LOCK_IOCTL);
-
 	bcmerror =
 	    dhd_prot_ioctl(&dhd->pub, ifidx, (wl_ioctl_t *)&ioc, buf, buflen);
 
-	WAKE_UNLOCK(&dhd->pub, WAKE_LOCK_IOCTL);
-	WAKE_LOCK_DESTROY(&dhd->pub, WAKE_LOCK_IOCTL);
 done:
 	if (!bcmerror && buf && ioc.buf) {
 		if (copy_to_user(ioc.buf, buf, buflen))
@@ -2115,11 +2097,6 @@ dhd_pub_t *dhd_attach(struct osl_info *osh, struct dhd_bus *bus,
 #endif	/* defined(CONFIG_PM_SLEEP) */
 	/* && defined(DHD_GPL) */
 	/* Init lock suspend to prevent kernel going to suspend */
-	WAKE_LOCK_INIT(&dhd->pub, WAKE_LOCK_TMOUT, "dhd_wake_lock");
-	WAKE_LOCK_INIT(&dhd->pub, WAKE_LOCK_LINK_DOWN_TMOUT,
-		       "dhd_wake_lock_link_dw_event");
-	WAKE_LOCK_INIT(&dhd->pub, WAKE_LOCK_PNO_FIND_TMOUT,
-		       "dhd_wake_lock_link_pno_find_event");
 #ifdef CONFIG_HAS_EARLYSUSPEND
 	dhd->early_suspend.level = EARLY_SUSPEND_LEVEL_BLANK_SCREEN + 20;
 	dhd->early_suspend.suspend = dhd_early_suspend;
@@ -2153,20 +2130,13 @@ int dhd_bus_start(dhd_pub_t *dhdp)
 
 	/* try to download image and nvram to the dongle */
 	if (dhd->pub.busstate == DHD_BUS_DOWN) {
-		WAKE_LOCK_INIT(dhdp, WAKE_LOCK_DOWNLOAD, "dhd_bus_start");
-		WAKE_LOCK(dhdp, WAKE_LOCK_DOWNLOAD);
 		if (!(dhd_bus_download_firmware(dhd->pub.bus, dhd->pub.osh,
 						fw_path, nv_path))) {
 			DHD_ERROR(("%s: dhdsdio_probe_download failed. "
 				"firmware = %s nvram = %s\n",
 				__func__, fw_path, nv_path));
-			WAKE_UNLOCK(dhdp, WAKE_LOCK_DOWNLOAD);
-			WAKE_LOCK_DESTROY(dhdp, WAKE_LOCK_DOWNLOAD);
 			return -1;
 		}
-
-		WAKE_UNLOCK(dhdp, WAKE_LOCK_DOWNLOAD);
-		WAKE_LOCK_DESTROY(dhdp, WAKE_LOCK_DOWNLOAD);
 	}
 
 	/* Start the watchdog timer */
@@ -2432,9 +2402,6 @@ void dhd_detach(dhd_pub_t *dhdp)
 			unregister_pm_notifier(&dhd_sleep_pm_notifier);
 #endif	/* defined(CONFIG_PM_SLEEP) */
 			/* && defined(DHD_GPL) */
-			WAKE_LOCK_DESTROY(dhdp, WAKE_LOCK_TMOUT);
-			WAKE_LOCK_DESTROY(dhdp, WAKE_LOCK_LINK_DOWN_TMOUT);
-			WAKE_LOCK_DESTROY(dhdp, WAKE_LOCK_PNO_FIND_TMOUT);
 			free_netdev(ifp->net);
 			kfree(ifp);
 			kfree(dhd);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index db6e68e..bbce44c 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -3409,8 +3409,6 @@ void wl_iw_event(struct net_device *dev, wl_event_msg_t *e, void *data)
 		if (!(flags & WLC_EVENT_MSG_LINK)) {
 			memset(wrqu.addr.sa_data, 0, ETH_ALEN);
 			memset(&extra, 0, ETH_ALEN);
-			WAKE_LOCK_TIMEOUT(iw->pub, WAKE_LOCK_LINK_DOWN_TMOUT,
-					  20 * HZ);
 		} else {
 			memcpy(wrqu.addr.sa_data, &e->addr, ETH_ALEN);
 			WL_TRACE("Link UP\n");
@@ -3523,8 +3521,6 @@ void wl_iw_event(struct net_device *dev, wl_event_msg_t *e, void *data)
 			WL_ERROR("%s Event WLC_E_PFN_NET_FOUND, send %s up : find %s len=%d\n",
 				 __func__, PNO_EVENT_UP,
 				 ssid->SSID, ssid->SSID_len);
-			WAKE_LOCK_TIMEOUT(iw->pub, WAKE_LOCK_PNO_FIND_TMOUT,
-					  20 * HZ);
 			cmd = IWEVCUSTOM;
 			memset(&wrqu, 0, sizeof(wrqu));
 			strcpy(extra, PNO_EVENT_UP);
-- 
1.6.5.GIT

