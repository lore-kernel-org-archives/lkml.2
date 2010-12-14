Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971Ab0LNUwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:52:09 -0500
Received: from mail.perches.com ([173.55.12.10]:2654 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758360Ab0LNUwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:52:04 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Dowan Kim <dowan@broadcom.com>, Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH] staging: brcm80211: Fix WL_<type> logging macros
Date: Tue, 14 Dec 2010 12:51:52 -0800
Message-Id: <47873eb4542dce50447631225c3d0d69990da477.1292359867.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros use the equivalent of "#define WL_<type>(x) printk x"
which requires an extra level of parentheses.

Convert the macros to use the normal WL_<type>(fmt, args...) style
and remove the extra parentheses from the uses.

Add format argument verification using no_printk as appropriate.
Couple of spelling typo fixes in the formats and argument alignment
at the same time. Also coalesced long formats.

Signed-off-by: Joe Perches <joe@perches.com>
---
 .../staging/brcm80211/brcmfmac/dhd_custom_gpio.c   |   34 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |  518 ++++++++++----------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |   46 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |  480 +++++++++----------
 drivers/staging/brcm80211/brcmfmac/wl_iw.h         |    2 +-
 drivers/staging/brcm80211/sys/wl_dbg.h             |   72 ++-
 drivers/staging/brcm80211/sys/wl_mac80211.c        |  247 +++++-----
 drivers/staging/brcm80211/sys/wlc_alloc.c          |    2 +-
 drivers/staging/brcm80211/sys/wlc_ampdu.c          |   99 ++--
 drivers/staging/brcm80211/sys/wlc_antsel.c         |    4 +-
 drivers/staging/brcm80211/sys/wlc_bmac.c           |  285 ++++++-----
 drivers/staging/brcm80211/sys/wlc_channel.c        |   45 +-
 drivers/staging/brcm80211/sys/wlc_event.c          |    4 +-
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |  340 +++++++------
 drivers/staging/brcm80211/sys/wlc_phy_shim.c       |    3 +-
 drivers/staging/brcm80211/sys/wlc_stf.c            |   12 +-
 16 files changed, 1136 insertions(+), 1057 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
index bb3c7b8..c3f18bb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
@@ -24,8 +24,8 @@
 #include <wlioctl.h>
 #include <wl_iw.h>
 
-#define WL_ERROR(x) printf x
-#define WL_TRACE(x)
+#define WL_ERROR(fmt, args...) printk(fmt, ##args)
+#define WL_TRACE(fmt, args...) no_printk(fmt, ##args)
 
 #ifdef CUSTOMER_HW
 extern void bcm_wlan_power_off(int);
@@ -67,13 +67,13 @@ int dhd_customer_oob_irq_map(unsigned long *irq_flags_ptr)
 #endif
 
 	if (dhd_oob_gpio_num < 0) {
-		WL_ERROR(("%s: ERROR customer specific Host GPIO is NOT defined\n",
-			__func__));
+		WL_ERROR("%s: ERROR customer specific Host GPIO is NOT defined\n",
+			 __func__);
 		return dhd_oob_gpio_num;
 	}
 
-	WL_ERROR(("%s: customer specific Host GPIO number is (%d)\n",
-		  __func__, dhd_oob_gpio_num));
+	WL_ERROR("%s: customer specific Host GPIO number is (%d)\n",
+		 __func__, dhd_oob_gpio_num);
 
 #if defined CUSTOMER_HW
 	host_oob_irq = MSM_GPIO_TO_INT(dhd_oob_gpio_num);
@@ -93,40 +93,40 @@ void dhd_customer_gpio_wlan_ctrl(int onoff)
 {
 	switch (onoff) {
 	case WLAN_RESET_OFF:
-		WL_TRACE(("%s: call customer specific GPIO to insert WLAN RESET\n",
-			__func__));
+		WL_TRACE("%s: call customer specific GPIO to insert WLAN RESET\n",
+			 __func__);
 #ifdef CUSTOMER_HW
 		bcm_wlan_power_off(2);
 #endif				/* CUSTOMER_HW */
 #ifdef CUSTOMER_HW2
 		wifi_set_power(0, 0);
 #endif
-		WL_ERROR(("=========== WLAN placed in RESET ========\n"));
+		WL_ERROR("=========== WLAN placed in RESET ========\n");
 		break;
 
 	case WLAN_RESET_ON:
-		WL_TRACE(("%s: callc customer specific GPIO to remove WLAN RESET\n",
-			__func__));
+		WL_TRACE("%s: callc customer specific GPIO to remove WLAN RESET\n",
+			 __func__);
 #ifdef CUSTOMER_HW
 		bcm_wlan_power_on(2);
 #endif				/* CUSTOMER_HW */
 #ifdef CUSTOMER_HW2
 		wifi_set_power(1, 0);
 #endif
-		WL_ERROR(("=========== WLAN going back to live  ========\n"));
+		WL_ERROR("=========== WLAN going back to live  ========\n");
 		break;
 
 	case WLAN_POWER_OFF:
-		WL_TRACE(("%s: call customer specific GPIO to turn off WL_REG_ON\n",
-			__func__));
+		WL_TRACE("%s: call customer specific GPIO to turn off WL_REG_ON\n",
+			 __func__);
 #ifdef CUSTOMER_HW
 		bcm_wlan_power_off(1);
 #endif				/* CUSTOMER_HW */
 		break;
 
 	case WLAN_POWER_ON:
-		WL_TRACE(("%s: call customer specific GPIO to turn on WL_REG_ON\n",
-			__func__));
+		WL_TRACE("%s: call customer specific GPIO to turn on WL_REG_ON\n",
+			 __func__);
 #ifdef CUSTOMER_HW
 		bcm_wlan_power_on(1);
 #endif				/* CUSTOMER_HW */
@@ -140,7 +140,7 @@ void dhd_customer_gpio_wlan_ctrl(int onoff)
 /* Function to get custom MAC address */
 int dhd_custom_get_mac_address(unsigned char *buf)
 {
-	WL_TRACE(("%s Enter\n", __func__));
+	WL_TRACE("%s Enter\n", __func__);
 	if (!buf)
 		return -EINVAL;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 1e92f2e..991463f 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -337,7 +337,7 @@ static void wl_debugfs_remove_netdev(struct wl_priv *wl);
 	struct wl_iface *ci;						\
 	if (unlikely(!(wl_cfg80211_dev && 				\
 		(ci = wl_get_drvdata(wl_cfg80211_dev))))) {		\
-		WL_ERR(("wl_cfg80211_dev is unavailable\n"));		\
+		WL_ERR("wl_cfg80211_dev is unavailable\n");		\
 		BUG();							\
 	} 								\
 	ci_to_wl(ci);							\
@@ -347,8 +347,8 @@ static void wl_debugfs_remove_netdev(struct wl_priv *wl);
 do {									\
 	struct wl_priv *wl = wiphy_to_wl(wiphy);			\
 	if (unlikely(!test_bit(WL_STATUS_READY, &wl->status))) {	\
-		WL_INFO(("device is not ready : status (%d)\n",		\
-			(int)wl->status));				\
+		WL_INFO("device is not ready : status (%d)\n",		\
+			(int)wl->status);				\
 		return -EIO;						\
 	}								\
 } while (0)
@@ -613,8 +613,8 @@ wl_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	switch (type) {
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_WDS:
-		WL_ERR(("type (%d) : currently we do not support this type\n",
-			type));
+		WL_ERR("type (%d) : currently we do not support this type\n",
+		       type);
 		return -EOPNOTSUPP;
 	case NL80211_IFTYPE_ADHOC:
 		wl->conf->mode = WL_MODE_IBSS;
@@ -630,15 +630,15 @@ wl_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	ap = htod32(ap);
 	wdev = ndev->ieee80211_ptr;
 	wdev->iftype = type;
-	WL_DBG(("%s : ap (%d), infra (%d)\n", ndev->name, ap, infra));
+	WL_DBG("%s : ap (%d), infra (%d)\n", ndev->name, ap, infra);
 	err = wl_dev_ioctl(ndev, WLC_SET_INFRA, &infra, sizeof(infra));
 	if (unlikely(err)) {
-		WL_ERR(("WLC_SET_INFRA error (%d)\n", err));
+		WL_ERR("WLC_SET_INFRA error (%d)\n", err);
 		return err;
 	}
 	err = wl_dev_ioctl(ndev, WLC_SET_AP, &ap, sizeof(ap));
 	if (unlikely(err)) {
-		WL_ERR(("WLC_SET_AP error (%d)\n", err));
+		WL_ERR("WLC_SET_AP error (%d)\n", err);
 		return err;
 	}
 
@@ -717,9 +717,9 @@ wl_run_iscan(struct wl_iscan_ctrl *iscan, struct wlc_ssid *ssid, u16 action)
 				iscan->ioctl_buf, WLC_IOCTL_SMLEN);
 	if (unlikely(err)) {
 		if (err == -EBUSY) {
-			WL_INFO(("system busy : iscan canceled\n"));
+			WL_INFO("system busy : iscan canceled\n");
 		} else {
-			WL_ERR(("error (%d)\n", err));
+			WL_ERR("error (%d)\n", err);
 		}
 	}
 	kfree(params);
@@ -743,7 +743,7 @@ static s32 wl_do_iscan(struct wl_priv *wl)
 	err = wl_dev_ioctl(wl_to_ndev(wl), WLC_SET_PASSIVE_SCAN,
 			&passive_scan, sizeof(passive_scan));
 	if (unlikely(err)) {
-		WL_DBG(("error (%d)\n", err));
+		WL_DBG("error (%d)\n", err);
 		return err;
 	}
 	wl_set_mpc(ndev, 0);
@@ -769,12 +769,12 @@ __wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 
 	if (unlikely(test_bit(WL_STATUS_SCANNING, &wl->status))) {
-		WL_ERR(("Scanning already : status (%d)\n", (int)wl->status));
+		WL_ERR("Scanning already : status (%d)\n", (int)wl->status);
 		return -EAGAIN;
 	}
 	if (unlikely(test_bit(WL_STATUS_SCAN_ABORTING, &wl->status))) {
-		WL_ERR(("Scanning being aborted : status (%d)\n",
-			(int)wl->status));
+		WL_ERR("Scanning being aborted : status (%d)\n",
+		       (int)wl->status);
 		return -EAGAIN;
 	}
 
@@ -806,26 +806,26 @@ __wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		else
 			goto scan_out;
 	} else {
-		WL_DBG(("ssid \"%s\", ssid_len (%d)\n",
-			ssids->ssid, ssids->ssid_len));
+		WL_DBG("ssid \"%s\", ssid_len (%d)\n",
+		       ssids->ssid, ssids->ssid_len);
 		memset(&sr->ssid, 0, sizeof(sr->ssid));
 		sr->ssid.SSID_len =
 			    min_t(u8, sizeof(sr->ssid.SSID), ssids->ssid_len);
 		if (sr->ssid.SSID_len) {
 			memcpy(sr->ssid.SSID, ssids->ssid, sr->ssid.SSID_len);
 			sr->ssid.SSID_len = htod32(sr->ssid.SSID_len);
-			WL_DBG(("Specific scan ssid=\"%s\" len=%d\n",
-					sr->ssid.SSID, sr->ssid.SSID_len));
+			WL_DBG("Specific scan ssid=\"%s\" len=%d\n",
+			       sr->ssid.SSID, sr->ssid.SSID_len);
 			spec_scan = true;
 		} else {
-			WL_DBG(("Broadcast scan\n"));
+			WL_DBG("Broadcast scan\n");
 		}
-		WL_DBG(("sr->ssid.SSID_len (%d)\n", sr->ssid.SSID_len));
+		WL_DBG("sr->ssid.SSID_len (%d)\n", sr->ssid.SSID_len);
 		passive_scan = wl->active_scan ? 0 : 1;
 		err = wl_dev_ioctl(ndev, WLC_SET_PASSIVE_SCAN,
 				&passive_scan, sizeof(passive_scan));
 		if (unlikely(err)) {
-			WL_ERR(("WLC_SET_PASSIVE_SCAN error (%d)\n", err));
+			WL_ERR("WLC_SET_PASSIVE_SCAN error (%d)\n", err);
 			goto scan_out;
 		}
 		wl_set_mpc(ndev, 0);
@@ -833,10 +833,10 @@ __wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 				sizeof(sr->ssid));
 		if (err) {
 			if (err == -EBUSY) {
-				WL_INFO(("system busy : scan for \"%s\" "
-					"canceled\n", sr->ssid.SSID));
+				WL_INFO("system busy : scan for \"%s\" canceled\n",
+					sr->ssid.SSID);
 			} else {
-				WL_ERR(("WLC_SCAN error (%d)\n", err));
+				WL_ERR("WLC_SCAN error (%d)\n", err);
 			}
 			wl_set_mpc(ndev, 1);
 			goto scan_out;
@@ -860,7 +860,7 @@ wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 	CHECK_SYS_UP();
 	err = __wl_cfg80211_scan(wiphy, ndev, request, NULL);
 	if (unlikely(err)) {
-		WL_DBG(("scan error (%d)\n", err));
+		WL_DBG("scan error (%d)\n", err);
 		return err;
 	}
 
@@ -879,7 +879,7 @@ static s32 wl_dev_intvar_set(struct net_device *dev, s8 *name, s32 val)
 
 	err = wl_dev_ioctl(dev, WLC_SET_VAR, buf, len);
 	if (unlikely(err)) {
-		WL_ERR(("error (%d)\n", err));
+		WL_ERR("error (%d)\n", err);
 	}
 
 	return err;
@@ -902,7 +902,7 @@ wl_dev_intvar_get(struct net_device *dev, s8 *name, s32 *retval)
 	BUG_ON(unlikely(!len));
 	err = wl_dev_ioctl(dev, WLC_GET_VAR, &var, len);
 	if (unlikely(err)) {
-		WL_ERR(("error (%d)\n", err));
+		WL_ERR("error (%d)\n", err);
 	}
 	*retval = dtoh32(var.val);
 
@@ -915,7 +915,7 @@ static s32 wl_set_rts(struct net_device *dev, u32 rts_threshold)
 
 	err = wl_dev_intvar_set(dev, "rtsthresh", rts_threshold);
 	if (unlikely(err)) {
-		WL_ERR(("Error (%d)\n", err));
+		WL_ERR("Error (%d)\n", err);
 		return err;
 	}
 	return err;
@@ -927,7 +927,7 @@ static s32 wl_set_frag(struct net_device *dev, u32 frag_threshold)
 
 	err = wl_dev_intvar_set(dev, "fragthresh", frag_threshold);
 	if (unlikely(err)) {
-		WL_ERR(("Error (%d)\n", err));
+		WL_ERR("Error (%d)\n", err);
 		return err;
 	}
 	return err;
@@ -941,7 +941,7 @@ static s32 wl_set_retry(struct net_device *dev, u32 retry, bool l)
 	retry = htod32(retry);
 	err = wl_dev_ioctl(dev, cmd, &retry, sizeof(retry));
 	if (unlikely(err)) {
-		WL_ERR(("cmd (%d) , error (%d)\n", cmd, err));
+		WL_ERR("cmd (%d) , error (%d)\n", cmd, err);
 		return err;
 	}
 	return err;
@@ -1001,7 +1001,7 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 
 	CHECK_SYS_UP();
 	if (params->bssid) {
-		WL_ERR(("Invalid bssid\n"));
+		WL_ERR("Invalid bssid\n");
 		return -EOPNOTSUPP;
 	}
 	bss = cfg80211_get_ibss(wiphy, NULL, params->ssid, params->ssid_len);
@@ -1027,7 +1027,7 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	}
 	if (bss) {
 		wl->ibss_starter = false;
-		WL_DBG(("Found IBSS\n"));
+		WL_DBG("Found IBSS\n");
 	} else {
 		wl->ibss_starter = true;
 	}
@@ -1051,7 +1051,7 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	err = wl_dev_ioctl(dev, WLC_SET_SSID, &join_params,
 			sizeof(join_params));
 	if (unlikely(err)) {
-		WL_ERR(("Error (%d)\n", err));
+		WL_ERR("Error (%d)\n", err);
 		return err;
 	}
 	return err;
@@ -1082,10 +1082,10 @@ wl_set_wpa_version(struct net_device *dev, struct cfg80211_connect_params *sme)
 		val = WPA2_AUTH_PSK | WPA2_AUTH_UNSPECIFIED;
 	else
 		val = WPA_AUTH_DISABLED;
-	WL_DBG(("setting wpa_auth to 0x%0x\n", val));
+	WL_DBG("setting wpa_auth to 0x%0x\n", val);
 	err = wl_dev_intvar_set(dev, "wpa_auth", val);
 	if (unlikely(err)) {
-		WL_ERR(("set wpa_auth failed (%d)\n", err));
+		WL_ERR("set wpa_auth failed (%d)\n", err);
 		return err;
 	}
 	sec = wl_read_prof(wl, WL_PROF_SEC);
@@ -1104,27 +1104,27 @@ wl_set_auth_type(struct net_device *dev, struct cfg80211_connect_params *sme)
 	switch (sme->auth_type) {
 	case NL80211_AUTHTYPE_OPEN_SYSTEM:
 		val = 0;
-		WL_DBG(("open system\n"));
+		WL_DBG("open system\n");
 		break;
 	case NL80211_AUTHTYPE_SHARED_KEY:
 		val = 1;
-		WL_DBG(("shared key\n"));
+		WL_DBG("shared key\n");
 		break;
 	case NL80211_AUTHTYPE_AUTOMATIC:
 		val = 2;
-		WL_DBG(("automatic\n"));
+		WL_DBG("automatic\n");
 		break;
 	case NL80211_AUTHTYPE_NETWORK_EAP:
-		WL_DBG(("network eap\n"));
+		WL_DBG("network eap\n");
 	default:
 		val = 2;
-		WL_ERR(("invalid auth type (%d)\n", sme->auth_type));
+		WL_ERR("invalid auth type (%d)\n", sme->auth_type);
 		break;
 	}
 
 	err = wl_dev_intvar_set(dev, "auth", val);
 	if (unlikely(err)) {
-		WL_ERR(("set auth failed (%d)\n", err));
+		WL_ERR("set auth failed (%d)\n", err);
 		return err;
 	}
 	sec = wl_read_prof(wl, WL_PROF_SEC);
@@ -1157,8 +1157,8 @@ wl_set_set_cipher(struct net_device *dev, struct cfg80211_connect_params *sme)
 			pval = AES_ENABLED;
 			break;
 		default:
-			WL_ERR(("invalid cipher pairwise (%d)\n",
-				sme->crypto.ciphers_pairwise[0]));
+			WL_ERR("invalid cipher pairwise (%d)\n",
+			       sme->crypto.ciphers_pairwise[0]);
 			return -EINVAL;
 		}
 	}
@@ -1178,16 +1178,16 @@ wl_set_set_cipher(struct net_device *dev, struct cfg80211_connect_params *sme)
 			gval = AES_ENABLED;
 			break;
 		default:
-			WL_ERR(("invalid cipher group (%d)\n",
-				sme->crypto.cipher_group));
+			WL_ERR("invalid cipher group (%d)\n",
+			       sme->crypto.cipher_group);
 			return -EINVAL;
 		}
 	}
 
-	WL_DBG(("pval (%d) gval (%d)\n", pval, gval));
+	WL_DBG("pval (%d) gval (%d)\n", pval, gval);
 	err = wl_dev_intvar_set(dev, "wsec", pval | gval);
 	if (unlikely(err)) {
-		WL_ERR(("error (%d)\n", err));
+		WL_ERR("error (%d)\n", err);
 		return err;
 	}
 
@@ -1209,7 +1209,7 @@ wl_set_key_mgmt(struct net_device *dev, struct cfg80211_connect_params *sme)
 	if (sme->crypto.n_akm_suites) {
 		err = wl_dev_intvar_get(dev, "wpa_auth", &val);
 		if (unlikely(err)) {
-			WL_ERR(("could not get wpa_auth (%d)\n", err));
+			WL_ERR("could not get wpa_auth (%d)\n", err);
 			return err;
 		}
 		if (val & (WPA_AUTH_PSK | WPA_AUTH_UNSPECIFIED)) {
@@ -1221,8 +1221,8 @@ wl_set_key_mgmt(struct net_device *dev, struct cfg80211_connect_params *sme)
 				val = WPA_AUTH_PSK;
 				break;
 			default:
-				WL_ERR(("invalid cipher group (%d)\n",
-					sme->crypto.cipher_group));
+				WL_ERR("invalid cipher group (%d)\n",
+				       sme->crypto.cipher_group);
 				return -EINVAL;
 			}
 		} else if (val & (WPA2_AUTH_PSK | WPA2_AUTH_UNSPECIFIED)) {
@@ -1234,16 +1234,16 @@ wl_set_key_mgmt(struct net_device *dev, struct cfg80211_connect_params *sme)
 				val = WPA2_AUTH_PSK;
 				break;
 			default:
-				WL_ERR(("invalid cipher group (%d)\n",
-					sme->crypto.cipher_group));
+				WL_ERR("invalid cipher group (%d)\n",
+				       sme->crypto.cipher_group);
 				return -EINVAL;
 			}
 		}
 
-		WL_DBG(("setting wpa_auth to %d\n", val));
+		WL_DBG("setting wpa_auth to %d\n", val);
 		err = wl_dev_intvar_set(dev, "wpa_auth", val);
 		if (unlikely(err)) {
-			WL_ERR(("could not set wpa_auth (%d)\n", err));
+			WL_ERR("could not set wpa_auth (%d)\n", err);
 			return err;
 		}
 	}
@@ -1263,11 +1263,11 @@ wl_set_set_sharedkey(struct net_device *dev,
 	s32 val;
 	s32 err = 0;
 
-	WL_DBG(("key len (%d)\n", sme->key_len));
+	WL_DBG("key len (%d)\n", sme->key_len);
 	if (sme->key_len) {
 		sec = wl_read_prof(wl, WL_PROF_SEC);
-		WL_DBG(("wpa_versions 0x%x cipher_pairwise 0x%x\n",
-			sec->wpa_versions, sec->cipher_pairwise));
+		WL_DBG("wpa_versions 0x%x cipher_pairwise 0x%x\n",
+		       sec->wpa_versions, sec->cipher_pairwise);
 		if (!
 		    (sec->wpa_versions & (NL80211_WPA_VERSION_1 |
 					  NL80211_WPA_VERSION_2))
@@ -1277,7 +1277,7 @@ wl_set_set_sharedkey(struct net_device *dev,
 			key.len = (u32) sme->key_len;
 			key.index = (u32) sme->key_idx;
 			if (unlikely(key.len > sizeof(key.data))) {
-				WL_ERR(("Too long key length (%u)\n", key.len));
+				WL_ERR("Too long key length (%u)\n", key.len);
 				return -EINVAL;
 			}
 			memcpy(key.data, sme->key, key.len);
@@ -1290,27 +1290,27 @@ wl_set_set_sharedkey(struct net_device *dev,
 				key.algo = CRYPTO_ALGO_WEP128;
 				break;
 			default:
-				WL_ERR(("Invalid algorithm (%d)\n",
-					sme->crypto.ciphers_pairwise[0]));
+				WL_ERR("Invalid algorithm (%d)\n",
+				       sme->crypto.ciphers_pairwise[0]);
 				return -EINVAL;
 			}
 			/* Set the new key/index */
-			WL_DBG(("key length (%d) key index (%d) algo (%d)\n",
-				key.len, key.index, key.algo));
-			WL_DBG(("key \"%s\"\n", key.data));
+			WL_DBG("key length (%d) key index (%d) algo (%d)\n",
+			       key.len, key.index, key.algo);
+			WL_DBG("key \"%s\"\n", key.data);
 			swap_key_from_BE(&key);
 			err = wl_dev_ioctl(dev, WLC_SET_KEY, &key,
 					sizeof(key));
 			if (unlikely(err)) {
-				WL_ERR(("WLC_SET_KEY error (%d)\n", err));
+				WL_ERR("WLC_SET_KEY error (%d)\n", err);
 				return err;
 			}
 			if (sec->auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM) {
-				WL_DBG(("set auth_type to shared key\n"));
+				WL_DBG("set auth_type to shared key\n");
 				val = 1;	/* shared key */
 				err = wl_dev_intvar_set(dev, "auth", val);
 				if (unlikely(err)) {
-					WL_ERR(("set auth failed (%d)\n", err));
+					WL_ERR("set auth failed (%d)\n", err);
 					return err;
 				}
 			}
@@ -1332,15 +1332,15 @@ wl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 
 	CHECK_SYS_UP();
 	if (unlikely(!sme->ssid)) {
-		WL_ERR(("Invalid ssid\n"));
+		WL_ERR("Invalid ssid\n");
 		return -EOPNOTSUPP;
 	}
 	if (chan) {
 		wl->channel = ieee80211_frequency_to_channel(chan->center_freq);
-		WL_DBG(("channel (%d), center_req (%d)\n", wl->channel,
-			chan->center_freq));
+		WL_DBG("channel (%d), center_req (%d)\n",
+		       wl->channel, chan->center_freq);
 	}
-	WL_DBG(("ie (%p), ie_len (%zd)\n", sme->ie, sme->ie_len));
+	WL_DBG("ie (%p), ie_len (%zd)\n", sme->ie, sme->ie_len);
 	err = wl_set_wpa_version(dev, sme);
 	if (unlikely(err))
 		return err;
@@ -1376,15 +1376,15 @@ wl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(&join_params.params.bssid, &ether_bcast, ETH_ALEN);
 
 	wl_ch_to_chanspec(wl->channel, &join_params, &join_params_size);
-	WL_DBG(("join_param_size %d\n", join_params_size));
+	WL_DBG("join_param_size %d\n", join_params_size);
 
 	if (join_params.ssid.SSID_len < IEEE80211_MAX_SSID_LEN) {
-		WL_DBG(("ssid \"%s\", len (%d)\n", join_params.ssid.SSID,
-			join_params.ssid.SSID_len));
+		WL_DBG("ssid \"%s\", len (%d)\n",
+		       join_params.ssid.SSID, join_params.ssid.SSID_len);
 	}
 	err = wl_dev_ioctl(dev, WLC_SET_SSID, &join_params, join_params_size);
 	if (unlikely(err)) {
-		WL_ERR(("error (%d)\n", err));
+		WL_ERR("error (%d)\n", err);
 		return err;
 	}
 	set_bit(WL_STATUS_CONNECTING, &wl->status);
@@ -1401,7 +1401,7 @@ wl_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	bool act = false;
 	s32 err = 0;
 
-	WL_DBG(("Reason %d\n", reason_code));
+	WL_DBG("Reason %d\n", reason_code);
 	CHECK_SYS_UP();
 	act = *(bool *) wl_read_prof(wl, WL_PROF_ACT);
 	if (likely(act)) {
@@ -1411,7 +1411,7 @@ wl_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 		err = wl_dev_ioctl(dev, WLC_DISASSOC, &scbval,
 				sizeof(scb_val_t));
 		if (unlikely(err)) {
-			WL_ERR(("error (%d)\n", err));
+			WL_ERR("error (%d)\n", err);
 			return err;
 		}
 	}
@@ -1436,13 +1436,13 @@ wl_cfg80211_set_tx_power(struct wiphy *wiphy,
 		break;
 	case NL80211_TX_POWER_LIMITED:
 		if (dbm < 0) {
-			WL_ERR(("TX_POWER_LIMITTED - dbm is negative\n"));
+			WL_ERR("TX_POWER_LIMITED - dbm is negative\n");
 			return -EINVAL;
 		}
 		break;
 	case NL80211_TX_POWER_FIXED:
 		if (dbm < 0) {
-			WL_ERR(("TX_POWER_FIXED - dbm is negative..\n"));
+			WL_ERR("TX_POWER_FIXED - dbm is negative\n");
 			return -EINVAL;
 		}
 		break;
@@ -1452,7 +1452,7 @@ wl_cfg80211_set_tx_power(struct wiphy *wiphy,
 	disable = htod32(disable);
 	err = wl_dev_ioctl(ndev, WLC_SET_RADIO, &disable, sizeof(disable));
 	if (unlikely(err)) {
-		WL_ERR(("WLC_SET_RADIO error (%d)\n", err));
+		WL_ERR("WLC_SET_RADIO error (%d)\n", err);
 		return err;
 	}
 
@@ -1463,7 +1463,7 @@ wl_cfg80211_set_tx_power(struct wiphy *wiphy,
 	err = wl_dev_intvar_set(ndev, "qtxpower",
 			(s32) (bcm_mw_to_qdbm(txpwrmw)));
 	if (unlikely(err)) {
-		WL_ERR(("qtxpower error (%d)\n", err));
+		WL_ERR("qtxpower error (%d)\n", err);
 		return err;
 	}
 	wl->conf->tx_power = dbm;
@@ -1482,7 +1482,7 @@ static s32 wl_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm)
 	CHECK_SYS_UP();
 	err = wl_dev_intvar_get(ndev, "qtxpower", &txpwrdbm);
 	if (unlikely(err)) {
-		WL_ERR(("error (%d)\n", err));
+		WL_ERR("error (%d)\n", err);
 		return err;
 	}
 	result = (u8) (txpwrdbm & ~WL_TXPWR_OVERRIDE);
@@ -1499,12 +1499,12 @@ wl_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *dev,
 	s32 wsec;
 	s32 err = 0;
 
-	WL_DBG(("key index (%d)\n", key_idx));
+	WL_DBG("key index (%d)\n", key_idx);
 	CHECK_SYS_UP();
 
 	err = wl_dev_ioctl(dev, WLC_GET_WSEC, &wsec, sizeof(wsec));
 	if (unlikely(err)) {
-		WL_ERR(("WLC_GET_WSEC error (%d)\n", err));
+		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		return err;
 	}
 	wsec = dtoh32(wsec);
@@ -1515,7 +1515,7 @@ wl_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *dev,
 		err = wl_dev_ioctl(dev, WLC_SET_KEY_PRIMARY, &index,
 				sizeof(index));
 		if (unlikely(err)) {
-			WL_ERR(("error (%d)\n", err));
+			WL_ERR("error (%d)\n", err);
 		}
 	}
 	return err;
@@ -1541,16 +1541,16 @@ wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 		swap_key_from_BE(&key);
 		err = wl_dev_ioctl(dev, WLC_SET_KEY, &key, sizeof(key));
 		if (unlikely(err)) {
-			WL_ERR(("key delete error (%d)\n", err));
+			WL_ERR("key delete error (%d)\n", err);
 			return err;
 		}
 	} else {
 		if (key.len > sizeof(key.data)) {
-			WL_ERR(("Invalid key length (%d)\n", key.len));
+			WL_ERR("Invalid key length (%d)\n", key.len);
 			return -EINVAL;
 		}
 
-		WL_DBG(("Setting the key index %d\n", key.index));
+		WL_DBG("Setting the key index %d\n", key.index);
 		memcpy(key.data, params->key, key.len);
 
 		if (params->cipher == WLAN_CIPHER_SUITE_TKIP) {
@@ -1574,26 +1574,26 @@ wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 		switch (params->cipher) {
 		case WLAN_CIPHER_SUITE_WEP40:
 			key.algo = CRYPTO_ALGO_WEP1;
-			WL_DBG(("WLAN_CIPHER_SUITE_WEP40\n"));
+			WL_DBG("WLAN_CIPHER_SUITE_WEP40\n");
 			break;
 		case WLAN_CIPHER_SUITE_WEP104:
 			key.algo = CRYPTO_ALGO_WEP128;
-			WL_DBG(("WLAN_CIPHER_SUITE_WEP104\n"));
+			WL_DBG("WLAN_CIPHER_SUITE_WEP104\n");
 			break;
 		case WLAN_CIPHER_SUITE_TKIP:
 			key.algo = CRYPTO_ALGO_TKIP;
-			WL_DBG(("WLAN_CIPHER_SUITE_TKIP\n"));
+			WL_DBG("WLAN_CIPHER_SUITE_TKIP\n");
 			break;
 		case WLAN_CIPHER_SUITE_AES_CMAC:
 			key.algo = CRYPTO_ALGO_AES_CCM;
-			WL_DBG(("WLAN_CIPHER_SUITE_AES_CMAC\n"));
+			WL_DBG("WLAN_CIPHER_SUITE_AES_CMAC\n");
 			break;
 		case WLAN_CIPHER_SUITE_CCMP:
 			key.algo = CRYPTO_ALGO_AES_CCM;
-			WL_DBG(("WLAN_CIPHER_SUITE_CCMP\n"));
+			WL_DBG("WLAN_CIPHER_SUITE_CCMP\n");
 			break;
 		default:
-			WL_ERR(("Invalid cipher (0x%x)\n", params->cipher));
+			WL_ERR("Invalid cipher (0x%x)\n", params->cipher);
 			return -EINVAL;
 		}
 		swap_key_from_BE(&key);
@@ -1601,7 +1601,7 @@ wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 		dhd_wait_pend8021x(dev);
 		err = wl_dev_ioctl(dev, WLC_SET_KEY, &key, sizeof(key));
 		if (unlikely(err)) {
-			WL_ERR(("WLC_SET_KEY error (%d)\n", err));
+			WL_ERR("WLC_SET_KEY error (%d)\n", err);
 			return err;
 		}
 	}
@@ -1618,7 +1618,7 @@ wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	s32 wsec;
 	s32 err = 0;
 
-	WL_DBG(("key index (%d)\n", key_idx));
+	WL_DBG("key index (%d)\n", key_idx);
 	CHECK_SYS_UP();
 
 	if (mac_addr)
@@ -1629,7 +1629,7 @@ wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	key.index = (u32) key_idx;
 
 	if (unlikely(key.len > sizeof(key.data))) {
-		WL_ERR(("Too long key length (%u)\n", key.len));
+		WL_ERR("Too long key length (%u)\n", key.len);
 		return -EINVAL;
 	}
 	memcpy(key.data, params->key, key.len);
@@ -1638,26 +1638,26 @@ wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	switch (params->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
 		key.algo = CRYPTO_ALGO_WEP1;
-		WL_DBG(("WLAN_CIPHER_SUITE_WEP40\n"));
+		WL_DBG("WLAN_CIPHER_SUITE_WEP40\n");
 		break;
 	case WLAN_CIPHER_SUITE_WEP104:
 		key.algo = CRYPTO_ALGO_WEP128;
-		WL_DBG(("WLAN_CIPHER_SUITE_WEP104\n"));
+		WL_DBG("WLAN_CIPHER_SUITE_WEP104\n");
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 		key.algo = CRYPTO_ALGO_TKIP;
-		WL_DBG(("WLAN_CIPHER_SUITE_TKIP\n"));
+		WL_DBG("WLAN_CIPHER_SUITE_TKIP\n");
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		key.algo = CRYPTO_ALGO_AES_CCM;
-		WL_DBG(("WLAN_CIPHER_SUITE_AES_CMAC\n"));
+		WL_DBG("WLAN_CIPHER_SUITE_AES_CMAC\n");
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		key.algo = CRYPTO_ALGO_AES_CCM;
-		WL_DBG(("WLAN_CIPHER_SUITE_CCMP\n"));
+		WL_DBG("WLAN_CIPHER_SUITE_CCMP\n");
 		break;
 	default:
-		WL_ERR(("Invalid cipher (0x%x)\n", params->cipher));
+		WL_ERR("Invalid cipher (0x%x)\n", params->cipher);
 		return -EINVAL;
 	}
 
@@ -1665,21 +1665,21 @@ wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	swap_key_from_BE(&key);
 	err = wl_dev_ioctl(dev, WLC_SET_KEY, &key, sizeof(key));
 	if (unlikely(err)) {
-		WL_ERR(("WLC_SET_KEY error (%d)\n", err));
+		WL_ERR("WLC_SET_KEY error (%d)\n", err);
 		return err;
 	}
 
 	val = WEP_ENABLED;
 	err = wl_dev_intvar_get(dev, "wsec", &wsec);
 	if (unlikely(err)) {
-		WL_ERR(("get wsec error (%d)\n", err));
+		WL_ERR("get wsec error (%d)\n", err);
 		return err;
 	}
 	wsec &= ~(WEP_ENABLED);
 	wsec |= val;
 	err = wl_dev_intvar_set(dev, "wsec", wsec);
 	if (unlikely(err)) {
-		WL_ERR(("set wsec error (%d)\n", err));
+		WL_ERR("set wsec error (%d)\n", err);
 		return err;
 	}
 
@@ -1687,7 +1687,7 @@ wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	val = htod32(val);
 	err = wl_dev_ioctl(dev, WLC_SET_AUTH, &val, sizeof(val));
 	if (unlikely(err)) {
-		WL_ERR(("WLC_SET_AUTH error (%d)\n", err));
+		WL_ERR("WLC_SET_AUTH error (%d)\n", err);
 		return err;
 	}
 	return err;
@@ -1709,7 +1709,7 @@ wl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 	key.flags = WL_PRIMARY_KEY;
 	key.algo = CRYPTO_ALGO_OFF;
 
-	WL_DBG(("key index (%d)\n", key_idx));
+	WL_DBG("key index (%d)\n", key_idx);
 	/* Set the new key/index */
 	swap_key_from_BE(&key);
 	err = wl_dev_ioctl(dev, WLC_SET_KEY, &key, sizeof(key));
@@ -1717,10 +1717,10 @@ wl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 		if (err == -EINVAL) {
 			if (key.index >= DOT11_MAX_DEFAULT_KEYS) {
 				/* we ignore this key index in this case */
-				WL_DBG(("invalid key index (%d)\n", key_idx));
+				WL_DBG("invalid key index (%d)\n", key_idx);
 			}
 		} else {
-			WL_ERR(("WLC_SET_KEY error (%d)\n", err));
+			WL_ERR("WLC_SET_KEY error (%d)\n", err);
 		}
 		return err;
 	}
@@ -1728,14 +1728,14 @@ wl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 	val = 0;
 	err = wl_dev_intvar_get(dev, "wsec", &wsec);
 	if (unlikely(err)) {
-		WL_ERR(("get wsec error (%d)\n", err));
+		WL_ERR("get wsec error (%d)\n", err);
 		return err;
 	}
 	wsec &= ~(WEP_ENABLED);
 	wsec |= val;
 	err = wl_dev_intvar_set(dev, "wsec", wsec);
 	if (unlikely(err)) {
-		WL_ERR(("set wsec error (%d)\n", err));
+		WL_ERR("set wsec error (%d)\n", err);
 		return err;
 	}
 
@@ -1743,7 +1743,7 @@ wl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 	val = htod32(val);
 	err = wl_dev_ioctl(dev, WLC_SET_AUTH, &val, sizeof(val));
 	if (unlikely(err)) {
-		WL_ERR(("WLC_SET_AUTH error (%d)\n", err));
+		WL_ERR("WLC_SET_AUTH error (%d)\n", err);
 		return err;
 	}
 	return err;
@@ -1761,7 +1761,7 @@ wl_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 	s32 wsec;
 	s32 err = 0;
 
-	WL_DBG(("key index (%d)\n", key_idx));
+	WL_DBG("key index (%d)\n", key_idx);
 	CHECK_SYS_UP();
 
 	memset(&key, 0, sizeof(key));
@@ -1773,7 +1773,7 @@ wl_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 
 	err = wl_dev_ioctl(dev, WLC_GET_WSEC, &wsec, sizeof(wsec));
 	if (unlikely(err)) {
-		WL_ERR(("WLC_GET_WSEC error (%d)\n", err));
+		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		return err;
 	}
 	wsec = dtoh32(wsec);
@@ -1782,22 +1782,22 @@ wl_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 		sec = wl_read_prof(wl, WL_PROF_SEC);
 		if (sec->cipher_pairwise & WLAN_CIPHER_SUITE_WEP40) {
 			params.cipher = WLAN_CIPHER_SUITE_WEP40;
-			WL_DBG(("WLAN_CIPHER_SUITE_WEP40\n"));
+			WL_DBG("WLAN_CIPHER_SUITE_WEP40\n");
 		} else if (sec->cipher_pairwise & WLAN_CIPHER_SUITE_WEP104) {
 			params.cipher = WLAN_CIPHER_SUITE_WEP104;
-			WL_DBG(("WLAN_CIPHER_SUITE_WEP104\n"));
+			WL_DBG("WLAN_CIPHER_SUITE_WEP104\n");
 		}
 		break;
 	case TKIP_ENABLED:
 		params.cipher = WLAN_CIPHER_SUITE_TKIP;
-		WL_DBG(("WLAN_CIPHER_SUITE_TKIP\n"));
+		WL_DBG("WLAN_CIPHER_SUITE_TKIP\n");
 		break;
 	case AES_ENABLED:
 		params.cipher = WLAN_CIPHER_SUITE_AES_CMAC;
-		WL_DBG(("WLAN_CIPHER_SUITE_AES_CMAC\n"));
+		WL_DBG("WLAN_CIPHER_SUITE_AES_CMAC\n");
 		break;
 	default:
-		WL_ERR(("Invalid algo (0x%x)\n", wsec));
+		WL_ERR("Invalid algo (0x%x)\n", wsec);
 		return -EINVAL;
 	}
 
@@ -1809,7 +1809,7 @@ static s32
 wl_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
 				    struct net_device *dev, u8 key_idx)
 {
-	WL_INFO(("Not supported\n"));
+	WL_INFO("Not supported\n");
 	CHECK_SYS_UP();
 	return -EOPNOTSUPP;
 }
@@ -1827,19 +1827,19 @@ wl_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	CHECK_SYS_UP();
 	if (unlikely
 	    (memcmp(mac, wl_read_prof(wl, WL_PROF_BSSID), ETH_ALEN))) {
-		WL_ERR(("Wrong Mac address\n"));
+		WL_ERR("Wrong Mac address\n");
 		return -ENOENT;
 	}
 
 	/* Report the current tx rate */
 	err = wl_dev_ioctl(dev, WLC_GET_RATE, &rate, sizeof(rate));
 	if (err) {
-		WL_ERR(("Could not get rate (%d)\n", err));
+		WL_ERR("Could not get rate (%d)\n", err);
 	} else {
 		rate = dtoh32(rate);
 		sinfo->filled |= STATION_INFO_TX_BITRATE;
 		sinfo->txrate.legacy = rate * 5;
-		WL_DBG(("Rate %d Mbps\n", (rate / 2)));
+		WL_DBG("Rate %d Mbps\n", rate / 2);
 	}
 
 	if (test_bit(WL_STATUS_CONNECTED, &wl->status)) {
@@ -1847,13 +1847,13 @@ wl_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 		err = wl_dev_ioctl(dev, WLC_GET_RSSI, &scb_val,
 				sizeof(scb_val_t));
 		if (unlikely(err)) {
-			WL_ERR(("Could not get rssi (%d)\n", err));
+			WL_ERR("Could not get rssi (%d)\n", err);
 			return err;
 		}
 		rssi = dtoh32(scb_val.val);
 		sinfo->filled |= STATION_INFO_SIGNAL;
 		sinfo->signal = rssi;
-		WL_DBG(("RSSI %d dBm\n", rssi));
+		WL_DBG("RSSI %d dBm\n", rssi);
 	}
 
 	return err;
@@ -1869,13 +1869,13 @@ wl_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	CHECK_SYS_UP();
 	pm = enabled ? PM_FAST : PM_OFF;
 	pm = htod32(pm);
-	WL_DBG(("power save %s\n", (pm ? "enabled" : "disabled")));
+	WL_DBG("power save %s\n", (pm ? "enabled" : "disabled"));
 	err = wl_dev_ioctl(dev, WLC_SET_PM, &pm, sizeof(pm));
 	if (unlikely(err)) {
 		if (err == -ENODEV)
-			WL_DBG(("net_device is not ready yet\n"));
+			WL_DBG("net_device is not ready yet\n");
 		else
-			WL_ERR(("error (%d)\n", err));
+			WL_ERR("error (%d)\n", err);
 		return err;
 	}
 	return err;
@@ -1927,7 +1927,7 @@ wl_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 	err = wl_dev_ioctl(dev, WLC_GET_CURR_RATESET, &rateset,
 			sizeof(rateset));
 	if (unlikely(err)) {
-		WL_ERR(("could not get current rateset (%d)\n", err));
+		WL_ERR("could not get current rateset (%d)\n", err);
 		return err;
 	}
 
@@ -1947,7 +1947,7 @@ wl_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 		rate = val / 500000;
 	}
 
-	WL_DBG(("rate %d mbps\n", (rate / 2)));
+	WL_DBG("rate %d mbps\n", rate / 2);
 
 	/*
 	 *
@@ -1957,7 +1957,7 @@ wl_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 	err_bg = wl_dev_intvar_set(dev, "bg_rate", rate);
 	err_a = wl_dev_intvar_set(dev, "a_rate", rate);
 	if (unlikely(err_bg && err_a)) {
-		WL_ERR(("could not set fixed rate (%d) (%d)\n", err_bg, err_a));
+		WL_ERR("could not set fixed rate (%d) (%d)\n", err_bg, err_a);
 		return err_bg | err_a;
 	}
 
@@ -2002,12 +2002,12 @@ wl_update_pmklist(struct net_device *dev, struct wl_pmk_list *pmk_list,
 {
 	int i, j;
 
-	WL_DBG(("No of elements %d\n", pmk_list->pmkids.npmkid));
+	WL_DBG("No of elements %d\n", pmk_list->pmkids.npmkid);
 	for (i = 0; i < pmk_list->pmkids.npmkid; i++) {
-		WL_DBG(("PMKID[%d]: %pM =\n", i,
-			&pmk_list->pmkids.pmkid[i].BSSID));
+		WL_DBG("PMKID[%d]: %pM =\n", i,
+		       &pmk_list->pmkids.pmkid[i].BSSID);
 		for (j = 0; j < WPA2_PMKID_LEN; j++) {
-			WL_DBG(("%02x\n", pmk_list->pmkids.pmkid[i].PMKID[j]));
+			WL_DBG("%02x\n", pmk_list->pmkids.pmkid[i].PMKID[j]);
 		}
 	}
 	if (likely(!err)) {
@@ -2041,12 +2041,12 @@ wl_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
 	} else {
 		err = -EINVAL;
 	}
-	WL_DBG(("set_pmksa,IW_PMKSA_ADD - PMKID: %pM =\n",
-		&wl->pmk_list->pmkids.pmkid[wl->pmk_list->pmkids.npmkid].BSSID));
+	WL_DBG("set_pmksa,IW_PMKSA_ADD - PMKID: %pM =\n",
+	       &wl->pmk_list->pmkids.pmkid[wl->pmk_list->pmkids.npmkid].BSSID);
 	for (i = 0; i < WPA2_PMKID_LEN; i++) {
-		WL_DBG(("%02x\n",
-			wl->pmk_list->pmkids.pmkid[wl->pmk_list->pmkids.npmkid].
-			PMKID[i]));
+		WL_DBG("%02x\n",
+		       wl->pmk_list->pmkids.pmkid[wl->pmk_list->pmkids.npmkid].
+		       PMKID[i]);
 	}
 
 	err = wl_update_pmklist(dev, wl->pmk_list, err);
@@ -2067,10 +2067,10 @@ wl_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(&pmkid.pmkid[0].BSSID, pmksa->bssid, ETH_ALEN);
 	memcpy(&pmkid.pmkid[0].PMKID, pmksa->pmkid, WPA2_PMKID_LEN);
 
-	WL_DBG(("del_pmksa,IW_PMKSA_REMOVE - PMKID: %pM =\n",
-		&pmkid.pmkid[0].BSSID));
+	WL_DBG("del_pmksa,IW_PMKSA_REMOVE - PMKID: %pM =\n",
+	       &pmkid.pmkid[0].BSSID);
 	for (i = 0; i < WPA2_PMKID_LEN; i++) {
-		WL_DBG(("%02x\n", pmkid.pmkid[0].PMKID[i]));
+		WL_DBG("%02x\n", pmkid.pmkid[0].PMKID[i]);
 	}
 
 	for (i = 0; i < wl->pmk_list->pmkids.npmkid; i++)
@@ -2163,13 +2163,13 @@ static struct wireless_dev *wl_alloc_wdev(s32 sizeof_iface,
 
 	wdev = kzalloc(sizeof(*wdev), GFP_KERNEL);
 	if (unlikely(!wdev)) {
-		WL_ERR(("Could not allocate wireless device\n"));
+		WL_ERR("Could not allocate wireless device\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	wdev->wiphy =
 	    wiphy_new(&wl_cfg80211_ops, sizeof(struct wl_priv) + sizeof_iface);
 	if (unlikely(!wdev->wiphy)) {
-		WL_ERR(("Couldn not allocate wiphy device\n"));
+		WL_ERR("Couldn not allocate wiphy device\n");
 		err = -ENOMEM;
 		goto wiphy_new_out;
 	}
@@ -2199,7 +2199,7 @@ static struct wireless_dev *wl_alloc_wdev(s32 sizeof_iface,
 #endif				/* !WL_POWERSAVE_DISABLED */
 	err = wiphy_register(wdev->wiphy);
 	if (unlikely(err < 0)) {
-		WL_ERR(("Couldn not register wiphy device (%d)\n", err));
+		WL_ERR("Couldn not register wiphy device (%d)\n", err);
 		goto wiphy_register_out;
 	}
 	return wdev;
@@ -2218,7 +2218,7 @@ static void wl_free_wdev(struct wl_priv *wl)
 	struct wireless_dev *wdev = wl_to_wdev(wl);
 
 	if (unlikely(!wdev)) {
-		WL_ERR(("wdev is invalid\n"));
+		WL_ERR("wdev is invalid\n");
 		return;
 	}
 	wiphy_unregister(wdev->wiphy);
@@ -2236,11 +2236,11 @@ static s32 wl_inform_bss(struct wl_priv *wl)
 
 	bss_list = wl->bss_list;
 	if (unlikely(bss_list->version != WL_BSS_INFO_VERSION)) {
-		WL_ERR(("Version %d != WL_BSS_INFO_VERSION\n",
-			bss_list->version));
+		WL_ERR("Version %d != WL_BSS_INFO_VERSION\n",
+		       bss_list->version);
 		return -EOPNOTSUPP;
 	}
-	WL_DBG(("scanned AP count (%d)\n", bss_list->count));
+	WL_DBG("scanned AP count (%d)\n", bss_list->count);
 	bi = next_bss(bss_list, bi);
 	for_each_bss(bss_list, bi, i) {
 		err = wl_inform_single_bss(wl, bi);
@@ -2265,14 +2265,14 @@ static s32 wl_inform_single_bss(struct wl_priv *wl, struct wl_bss_info *bi)
 	s32 err = 0;
 
 	if (unlikely(dtoh32(bi->length) > WL_BSS_INFO_MAX)) {
-		WL_DBG(("Beacon is larger than buffer. Discarding\n"));
+		WL_DBG("Beacon is larger than buffer. Discarding\n");
 		return err;
 	}
 	notif_bss_info =
 	    kzalloc(sizeof(*notif_bss_info) + sizeof(*mgmt) - sizeof(u8) +
 		    WL_BSS_INFO_MAX, GFP_KERNEL);
 	if (unlikely(!notif_bss_info)) {
-		WL_ERR(("notif_bss_info alloc failed\n"));
+		WL_ERR("notif_bss_info alloc failed\n");
 		return -ENOMEM;
 	}
 	mgmt = (struct ieee80211_mgmt *)notif_bss_info->frame_buf;
@@ -2316,17 +2316,17 @@ static s32 wl_inform_single_bss(struct wl_priv *wl, struct wl_bss_info *bi)
 	freq = ieee80211_channel_to_frequency(notif_bss_info->channel);
 	channel = ieee80211_get_channel(wiphy, freq);
 
-	WL_DBG(("SSID : \"%s\", rssi %d, channel %d, capability : 0x04%x, bssid %pM\n",
-		bi->SSID,
-		notif_bss_info->rssi, notif_bss_info->channel,
-		mgmt->u.beacon.capab_info, &bi->BSSID));
+	WL_DBG("SSID : \"%s\", rssi %d, channel %d, capability : 0x04%x, bssid %pM\n",
+	       bi->SSID,
+	       notif_bss_info->rssi, notif_bss_info->channel,
+	       mgmt->u.beacon.capab_info, &bi->BSSID);
 
 	signal = notif_bss_info->rssi * 100;
 	if (unlikely(!cfg80211_inform_bss_frame(wiphy, channel, mgmt,
 						le16_to_cpu
 						(notif_bss_info->frame_len),
 						signal, GFP_KERNEL))) {
-		WL_ERR(("cfg80211_inform_bss_frame error\n"));
+		WL_ERR("cfg80211_inform_bss_frame error\n");
 		kfree(notif_bss_info);
 		return -EINVAL;
 	}
@@ -2394,12 +2394,12 @@ wl_notify_connect_status(struct wl_priv *wl, struct net_device *ndev,
 		if (wl_is_ibssmode(wl)) {
 			cfg80211_ibss_joined(ndev, (s8 *)&e->addr,
 					     GFP_KERNEL);
-			WL_DBG(("joined in IBSS network\n"));
+			WL_DBG("joined in IBSS network\n");
 		} else {
 			wl_bss_connect_done(wl, ndev, e, data, true);
-			WL_DBG(("joined in BSS network \"%s\"\n",
-				((struct wlc_ssid *)
-				 wl_read_prof(wl, WL_PROF_SSID))->SSID));
+			WL_DBG("joined in BSS network \"%s\"\n",
+			       ((struct wlc_ssid *)
+				wl_read_prof(wl, WL_PROF_SSID))->SSID);
 		}
 		act = true;
 		wl_update_prof(wl, e, &act, WL_PROF_ACT);
@@ -2454,7 +2454,7 @@ wl_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
 	err = wl_dev_ioctl(dev, WLC_GET_VAR, (void *)wl->ioctl_buf,
 			WL_IOCTL_LEN_MAX);
 	if (unlikely(err)) {
-		WL_ERR(("error (%d)\n", err));
+		WL_ERR("error (%d)\n", err);
 		return err;
 	}
 	memcpy(buf, wl->ioctl_buf, buf_len);
@@ -2474,7 +2474,7 @@ static s32 wl_get_assoc_ies(struct wl_priv *wl)
 	err = wl_dev_bufvar_get(ndev, "assoc_info", wl->extra_buf,
 				WL_ASSOC_INFO_MAX);
 	if (unlikely(err)) {
-		WL_ERR(("could not get assoc info (%d)\n", err));
+		WL_ERR("could not get assoc info (%d)\n", err);
 		return err;
 	}
 	assoc_info = (struct wl_assoc_ielen *)wl->extra_buf;
@@ -2484,7 +2484,7 @@ static s32 wl_get_assoc_ies(struct wl_priv *wl)
 		err = wl_dev_bufvar_get(ndev, "assoc_req_ies", wl->extra_buf,
 					WL_ASSOC_INFO_MAX);
 		if (unlikely(err)) {
-			WL_ERR(("could not get assoc req (%d)\n", err));
+			WL_ERR("could not get assoc req (%d)\n", err);
 			return err;
 		}
 		conn_info->req_ie_len = req_len;
@@ -2498,7 +2498,7 @@ static s32 wl_get_assoc_ies(struct wl_priv *wl)
 		err = wl_dev_bufvar_get(ndev, "assoc_resp_ies", wl->extra_buf,
 					WL_ASSOC_INFO_MAX);
 		if (unlikely(err)) {
-			WL_ERR(("could not get assoc resp (%d)\n", err));
+			WL_ERR("could not get assoc resp (%d)\n", err);
 			return err;
 		}
 		conn_info->resp_ie_len = resp_len;
@@ -2508,8 +2508,8 @@ static s32 wl_get_assoc_ies(struct wl_priv *wl)
 		conn_info->resp_ie_len = 0;
 		conn_info->resp_ie = NULL;
 	}
-	WL_DBG(("req len (%d) resp len (%d)\n", conn_info->req_ie_len,
-		conn_info->resp_ie_len));
+	WL_DBG("req len (%d) resp len (%d)\n",
+	       conn_info->req_ie_len, conn_info->resp_ie_len);
 
 	return err;
 }
@@ -2542,8 +2542,8 @@ static void wl_ch_to_chanspec(int ch, struct wl_join_params *join_params,
 		join_params->params.chanspec_num =
 			htod32(join_params->params.chanspec_num);
 
-		WL_DBG(("join_params->params.chanspec_list[0]= %#X, channel %d, chanspec %#X\n",
-			join_params->params.chanspec_list[0], ch, chanspec));
+		WL_DBG("join_params->params.chanspec_list[0]= %#X, channel %d, chanspec %#X\n",
+		       join_params->params.chanspec_list[0], ch, chanspec);
 	}
 }
 
@@ -2570,12 +2570,12 @@ static s32 wl_update_bss_info(struct wl_priv *wl)
 
 	rtnl_lock();
 	if (unlikely(!bss)) {
-		WL_DBG(("Could not find the AP\n"));
+		WL_DBG("Could not find the AP\n");
 		*(u32 *) wl->extra_buf = htod32(WL_EXTRA_BUF_MAX);
 		err = wl_dev_ioctl(wl_to_ndev(wl), WLC_GET_BSS_INFO,
 				wl->extra_buf, WL_EXTRA_BUF_MAX);
 		if (unlikely(err)) {
-			WL_ERR(("Could not get bss info %d\n", err));
+			WL_ERR("Could not get bss info %d\n", err);
 			goto update_bss_info_out;
 		}
 		bi = (struct wl_bss_info *)(wl->extra_buf + 4);
@@ -2591,7 +2591,7 @@ static s32 wl_update_bss_info(struct wl_priv *wl)
 		ie_len = bi->ie_length;
 		beacon_interval = cpu_to_le16(bi->beacon_period);
 	} else {
-		WL_DBG(("Found the AP in the list - BSSID %pM\n", bss->bssid));
+		WL_DBG("Found the AP in the list - BSSID %pM\n", bss->bssid);
 		ie = bss->information_elements;
 		ie_len = bss->len_information_elements;
 		beacon_interval = bss->beacon_interval;
@@ -2610,7 +2610,7 @@ static s32 wl_update_bss_info(struct wl_priv *wl)
 		err = wl_dev_ioctl(wl_to_ndev(wl), WLC_GET_DTIMPRD,
 			&dtim_period, sizeof(dtim_period));
 		if (unlikely(err)) {
-			WL_ERR(("WLC_GET_DTIMPRD error (%d)\n", err));
+			WL_ERR("WLC_GET_DTIMPRD error (%d)\n", err);
 			goto update_bss_info_out;
 		}
 	}
@@ -2637,7 +2637,7 @@ wl_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
 			(u8 *)&wl->bssid,
 			conn_info->req_ie, conn_info->req_ie_len,
 			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL);
-	WL_DBG(("Report roaming result\n"));
+	WL_DBG("Report roaming result\n");
 
 	set_bit(WL_STATUS_CONNECTED, &wl->status);
 
@@ -2663,15 +2663,15 @@ wl_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
 					conn_info->resp_ie_len,
 					completed ? WLAN_STATUS_SUCCESS : WLAN_STATUS_AUTH_TIMEOUT,
 					GFP_KERNEL);
-		WL_DBG(("Report connect result - connection %s\n",
-			completed ? "succeeded" : "failed"));
+		WL_DBG("Report connect result - connection %s\n",
+		       completed ? "succeeded" : "failed");
 	} else {
 		cfg80211_roamed(ndev,
 				(u8 *)&wl->bssid,
 				conn_info->req_ie, conn_info->req_ie_len,
 				conn_info->resp_ie, conn_info->resp_ie_len,
 				GFP_KERNEL);
-		WL_DBG(("Report roaming result\n"));
+		WL_DBG("Report roaming result\n");
 	}
 	set_bit(WL_STATUS_CONNECTED, &wl->status);
 
@@ -2711,7 +2711,7 @@ wl_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 		return wl_wakeup_iscan(wl_to_iscan(wl));
 
 	if (unlikely(!test_and_clear_bit(WL_STATUS_SCANNING, &wl->status))) {
-		WL_ERR(("Scan complete while device not scanning\n"));
+		WL_ERR("Scan complete while device not scanning\n");
 		return -EINVAL;
 	}
 	if (unlikely(!wl->scan_request)) {
@@ -2720,14 +2720,14 @@ wl_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 	err = wl_dev_ioctl(ndev, WLC_GET_CHANNEL, &channel_inform,
 			sizeof(channel_inform));
 	if (unlikely(err)) {
-		WL_ERR(("scan busy (%d)\n", err));
+		WL_ERR("scan busy (%d)\n", err);
 		goto scan_done_out;
 	}
 	channel_inform.scan_channel = dtoh32(channel_inform.scan_channel);
 	if (unlikely(channel_inform.scan_channel)) {
 
-		WL_DBG(("channel_inform.scan_channel (%d)\n",
-			channel_inform.scan_channel));
+		WL_DBG("channel_inform.scan_channel (%d)\n",
+		       channel_inform.scan_channel);
 	}
 	wl->bss_list = wl->scan_results;
 	bss_list = wl->bss_list;
@@ -2735,7 +2735,7 @@ wl_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 	bss_list->buflen = htod32(len);
 	err = wl_dev_ioctl(ndev, WLC_SCAN_RESULTS, bss_list, len);
 	if (unlikely(err)) {
-		WL_ERR(("%s Scan_results error (%d)\n", ndev->name, err));
+		WL_ERR("%s Scan_results error (%d)\n", ndev->name, err);
 		err = -EINVAL;
 		goto scan_done_out;
 	}
@@ -2791,52 +2791,52 @@ static s32 wl_init_priv_mem(struct wl_priv *wl)
 {
 	wl->scan_results = kzalloc(WL_SCAN_BUF_MAX, GFP_KERNEL);
 	if (unlikely(!wl->scan_results)) {
-		WL_ERR(("Scan results alloc failed\n"));
+		WL_ERR("Scan results alloc failed\n");
 		goto init_priv_mem_out;
 	}
 	wl->conf = kzalloc(sizeof(*wl->conf), GFP_KERNEL);
 	if (unlikely(!wl->conf)) {
-		WL_ERR(("wl_conf alloc failed\n"));
+		WL_ERR("wl_conf alloc failed\n");
 		goto init_priv_mem_out;
 	}
 	wl->profile = kzalloc(sizeof(*wl->profile), GFP_KERNEL);
 	if (unlikely(!wl->profile)) {
-		WL_ERR(("wl_profile alloc failed\n"));
+		WL_ERR("wl_profile alloc failed\n");
 		goto init_priv_mem_out;
 	}
 	wl->bss_info = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
 	if (unlikely(!wl->bss_info)) {
-		WL_ERR(("Bss information alloc failed\n"));
+		WL_ERR("Bss information alloc failed\n");
 		goto init_priv_mem_out;
 	}
 	wl->scan_req_int = kzalloc(sizeof(*wl->scan_req_int), GFP_KERNEL);
 	if (unlikely(!wl->scan_req_int)) {
-		WL_ERR(("Scan req alloc failed\n"));
+		WL_ERR("Scan req alloc failed\n");
 		goto init_priv_mem_out;
 	}
 	wl->ioctl_buf = kzalloc(WL_IOCTL_LEN_MAX, GFP_KERNEL);
 	if (unlikely(!wl->ioctl_buf)) {
-		WL_ERR(("Ioctl buf alloc failed\n"));
+		WL_ERR("Ioctl buf alloc failed\n");
 		goto init_priv_mem_out;
 	}
 	wl->extra_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
 	if (unlikely(!wl->extra_buf)) {
-		WL_ERR(("Extra buf alloc failed\n"));
+		WL_ERR("Extra buf alloc failed\n");
 		goto init_priv_mem_out;
 	}
 	wl->iscan = kzalloc(sizeof(*wl->iscan), GFP_KERNEL);
 	if (unlikely(!wl->iscan)) {
-		WL_ERR(("Iscan buf alloc failed\n"));
+		WL_ERR("Iscan buf alloc failed\n");
 		goto init_priv_mem_out;
 	}
 	wl->fw = kzalloc(sizeof(*wl->fw), GFP_KERNEL);
 	if (unlikely(!wl->fw)) {
-		WL_ERR(("fw object alloc failed\n"));
+		WL_ERR("fw object alloc failed\n");
 		goto init_priv_mem_out;
 	}
 	wl->pmk_list = kzalloc(sizeof(*wl->pmk_list), GFP_KERNEL);
 	if (unlikely(!wl->pmk_list)) {
-		WL_ERR(("pmk list alloc failed\n"));
+		WL_ERR("pmk list alloc failed\n");
 		goto init_priv_mem_out;
 	}
 
@@ -2878,7 +2878,7 @@ static s32 wl_create_event_handler(struct wl_priv *wl)
 	wl->event_tsk = kthread_run(wl_event_handler, wl, "wl_event_handler");
 	if (IS_ERR(wl->event_tsk)) {
 		wl->event_tsk = NULL;
-		WL_ERR(("failed to create event thread\n"));
+		WL_ERR("failed to create event thread\n");
 		return -ENOMEM;
 	}
 	return 0;
@@ -2911,7 +2911,7 @@ static void wl_notify_iscan_complete(struct wl_iscan_ctrl *iscan, bool aborted)
 	struct net_device *ndev = wl_to_ndev(wl);
 
 	if (unlikely(!test_and_clear_bit(WL_STATUS_SCANNING, &wl->status))) {
-		WL_ERR(("Scan complete while device not scanning\n"));
+		WL_ERR("Scan complete while device not scanning\n");
 		return;
 	}
 	if (likely(wl->scan_request)) {
@@ -2925,7 +2925,7 @@ static void wl_notify_iscan_complete(struct wl_iscan_ctrl *iscan, bool aborted)
 static s32 wl_wakeup_iscan(struct wl_iscan_ctrl *iscan)
 {
 	if (likely(iscan->state != WL_ISCAN_STATE_IDLE)) {
-		WL_DBG(("wake up iscan\n"));
+		WL_DBG("wake up iscan\n");
 		up(&iscan->sync);
 		return 0;
 	}
@@ -2955,14 +2955,14 @@ wl_get_iscan_results(struct wl_iscan_ctrl *iscan, u32 *status,
 				WL_ISCAN_RESULTS_FIXED_SIZE, iscan->scan_buf,
 				WL_ISCAN_BUF_MAX);
 	if (unlikely(err)) {
-		WL_ERR(("error (%d)\n", err));
+		WL_ERR("error (%d)\n", err);
 		return err;
 	}
 	results->buflen = dtoh32(results->buflen);
 	results->version = dtoh32(results->version);
 	results->count = dtoh32(results->count);
-	WL_DBG(("results->count = %d\n", results->count));
-	WL_DBG(("results->buflen = %d\n", results->buflen));
+	WL_DBG("results->count = %d\n", results->count);
+	WL_DBG("results->buflen = %d\n", results->buflen);
 	*status = dtoh32(list_buf->status);
 	*bss_list = results;
 
@@ -3047,7 +3047,7 @@ static s32 wl_iscan_thread(void *data)
 		err = wl_get_iscan_results(iscan, &status, &wl->bss_list);
 		if (unlikely(err)) {
 			status = WL_SCAN_RESULTS_ABORTED;
-			WL_ERR(("Abort iscan\n"));
+			WL_ERR("Abort iscan\n");
 		}
 		rtnl_unlock();
 		el->handler[status] (wl);
@@ -3056,7 +3056,7 @@ static s32 wl_iscan_thread(void *data)
 		del_timer_sync(&iscan->timer);
 		iscan->timer_on = 0;
 	}
-	WL_DBG(("%s was terminated\n", __func__));
+	WL_DBG("%s was terminated\n", __func__);
 
 	return 0;
 }
@@ -3067,7 +3067,7 @@ static void wl_iscan_timer(unsigned long data)
 
 	if (iscan) {
 		iscan->timer_on = 0;
-		WL_DBG(("timer expired\n"));
+		WL_DBG("timer expired\n");
 		wl_wakeup_iscan(iscan);
 	}
 }
@@ -3082,7 +3082,7 @@ static s32 wl_invoke_iscan(struct wl_priv *wl)
 		sema_init(&iscan->sync, 0);
 		iscan->tsk = kthread_run(wl_iscan_thread, iscan, "wl_iscan");
 		if (IS_ERR(iscan->tsk)) {
-			WL_ERR(("Could not create iscan thread\n"));
+			WL_ERR("Could not create iscan thread\n");
 			iscan->tsk = NULL;
 			return -ENOMEM;
 		}
@@ -3117,7 +3117,7 @@ static s32 wl_init_iscan(struct wl_priv *wl)
 		sema_init(&iscan->sync, 0);
 		iscan->tsk = kthread_run(wl_iscan_thread, iscan, "wl_iscan");
 		if (IS_ERR(iscan->tsk)) {
-			WL_ERR(("Could not create iscan thread\n"));
+			WL_ERR("Could not create iscan thread\n");
 			iscan->tsk = NULL;
 			return -ENOMEM;
 		}
@@ -3186,15 +3186,15 @@ s32 wl_cfg80211_attach(struct net_device *ndev, void *data)
 	s32 err = 0;
 
 	if (unlikely(!ndev)) {
-		WL_ERR(("ndev is invaild\n"));
+		WL_ERR("ndev is invalid\n");
 		return -ENODEV;
 	}
 	wl_cfg80211_dev = kzalloc(sizeof(struct wl_dev), GFP_KERNEL);
 	if (unlikely(!wl_cfg80211_dev)) {
-		WL_ERR(("wl_cfg80211_dev is invalid\n"));
+		WL_ERR("wl_cfg80211_dev is invalid\n");
 		return -ENOMEM;
 	}
-	WL_DBG(("func %p\n", wl_cfg80211_get_sdio_func()));
+	WL_DBG("func %p\n", wl_cfg80211_get_sdio_func());
 	wdev = wl_alloc_wdev(sizeof(struct wl_iface), &wl_cfg80211_get_sdio_func()->dev);
 	if (IS_ERR(wdev))
 		return -ENOMEM;
@@ -3210,7 +3210,7 @@ s32 wl_cfg80211_attach(struct net_device *ndev, void *data)
 	wdev->netdev = ndev;
 	err = wl_init_priv(wl);
 	if (unlikely(err)) {
-		WL_ERR(("Failed to init iwm_priv (%d)\n", err));
+		WL_ERR("Failed to init iwm_priv (%d)\n", err);
 		goto cfg80211_attach_out;
 	}
 	wl_set_drvdata(wl_cfg80211_dev, ci);
@@ -3255,19 +3255,19 @@ static s32 wl_event_handler(void *data)
 			break;
 		e = wl_deq_event(wl);
 		if (unlikely(!e)) {
-			WL_ERR(("eqeue empty..\n"));
+			WL_ERR("event queue empty...\n");
 			BUG();
 		}
-		WL_DBG(("event type (%d)\n", e->etype));
+		WL_DBG("event type (%d)\n", e->etype);
 		if (wl->el.handler[e->etype]) {
 			wl->el.handler[e->etype] (wl, wl_to_ndev(wl), &e->emsg,
 						  e->edata);
 		} else {
-			WL_DBG(("Unknown Event (%d): ignoring\n", e->etype));
+			WL_DBG("Unknown Event (%d): ignoring\n", e->etype);
 		}
 		wl_put_event(e);
 	}
-	WL_DBG(("%s was terminated\n", __func__));
+	WL_DBG("%s was terminated\n", __func__);
 	return 0;
 }
 
@@ -3280,7 +3280,7 @@ wl_cfg80211_event(struct net_device *ndev, const wl_event_msg_t * e, void *data)
 	s8 *estr = (event_type <= sizeof(wl_dbg_estr) / WL_DBG_ESTR_MAX - 1) ?
 	    wl_dbg_estr[event_type] : (s8 *) "Unknown";
 #endif				/* (WL_DBG_LEVEL > 0) */
-	WL_DBG(("event_type (%d):" "WLC_E_" "%s\n", event_type, estr));
+	WL_DBG("event_type (%d):" "WLC_E_" "%s\n", event_type, estr);
 	if (likely(!wl_enq_event(wl, event_type, e, data)))
 		wl_wakeup_event(wl);
 }
@@ -3335,7 +3335,7 @@ wl_enq_event(struct wl_priv *wl, u32 event, const wl_event_msg_t *msg,
 
 	e = kzalloc(sizeof(struct wl_event_q), GFP_KERNEL);
 	if (unlikely(!e)) {
-		WL_ERR(("event alloc failed\n"));
+		WL_ERR("event alloc failed\n");
 		return -ENOMEM;
 	}
 
@@ -3379,8 +3379,8 @@ static s32 wl_dongle_mode(struct net_device *ndev, s32 iftype)
 	switch (iftype) {
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_WDS:
-		WL_ERR(("type (%d) : currently we do not support this mode\n",
-			iftype));
+		WL_ERR("type (%d) : currently we do not support this mode\n",
+		       iftype);
 		err = -EINVAL;
 		return err;
 	case NL80211_IFTYPE_ADHOC:
@@ -3390,20 +3390,20 @@ static s32 wl_dongle_mode(struct net_device *ndev, s32 iftype)
 		break;
 	default:
 		err = -EINVAL;
-		WL_ERR(("invalid type (%d)\n", iftype));
+		WL_ERR("invalid type (%d)\n", iftype);
 		return err;
 	}
 	infra = htod32(infra);
 	ap = htod32(ap);
-	WL_DBG(("%s ap (%d), infra (%d)\n", ndev->name, ap, infra));
+	WL_DBG("%s ap (%d), infra (%d)\n", ndev->name, ap, infra);
 	err = wl_dev_ioctl(ndev, WLC_SET_INFRA, &infra, sizeof(infra));
 	if (unlikely(err)) {
-		WL_ERR(("WLC_SET_INFRA error (%d)\n", err));
+		WL_ERR("WLC_SET_INFRA error (%d)\n", err);
 		return err;
 	}
 	err = wl_dev_ioctl(ndev, WLC_SET_AP, &ap, sizeof(ap));
 	if (unlikely(err)) {
-		WL_ERR(("WLC_SET_AP error (%d)\n", err));
+		WL_ERR("WLC_SET_AP error (%d)\n", err);
 		return err;
 	}
 
@@ -3425,7 +3425,7 @@ static s32 wl_dongle_up(struct net_device *ndev, u32 up)
 
 	err = wl_dev_ioctl(ndev, WLC_UP, &up, sizeof(up));
 	if (unlikely(err)) {
-		WL_ERR(("WLC_UP error (%d)\n", err));
+		WL_ERR("WLC_UP error (%d)\n", err);
 	}
 	return err;
 }
@@ -3436,7 +3436,7 @@ static s32 wl_dongle_power(struct net_device *ndev, u32 power_mode)
 
 	err = wl_dev_ioctl(ndev, WLC_SET_PM, &power_mode, sizeof(power_mode));
 	if (unlikely(err)) {
-		WL_ERR(("WLC_SET_PM error (%d)\n", err));
+		WL_ERR("WLC_SET_PM error (%d)\n", err);
 	}
 	return err;
 }
@@ -3453,14 +3453,14 @@ wl_dongle_glom(struct net_device *ndev, u32 glom, u32 dongle_align)
 		    sizeof(iovbuf));
 	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
-		WL_ERR(("txglomalign error (%d)\n", err));
+		WL_ERR("txglomalign error (%d)\n", err);
 		goto dongle_glom_out;
 	}
 	/* disable glom option per default */
 	bcm_mkiovar("bus:txglom", (char *)&glom, 4, iovbuf, sizeof(iovbuf));
 	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
-		WL_ERR(("txglom error (%d)\n", err));
+		WL_ERR("txglom error (%d)\n", err);
 		goto dongle_glom_out;
 	}
 dongle_glom_out:
@@ -3481,7 +3481,7 @@ wl_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 			    sizeof(iovbuf));
 		err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 		if (unlikely(err)) {
-			WL_ERR(("bcn_timeout error (%d)\n", err));
+			WL_ERR("bcn_timeout error (%d)\n", err);
 			goto dongle_rom_out;
 		}
 	}
@@ -3490,7 +3490,7 @@ wl_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	bcm_mkiovar("roam_off", (char *)&roamvar, 4, iovbuf, sizeof(iovbuf));
 	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
-		WL_ERR(("roam_off error (%d)\n", err));
+		WL_ERR("roam_off error (%d)\n", err);
 		goto dongle_rom_out;
 	}
 dongle_rom_out:
@@ -3510,7 +3510,7 @@ static s32 wl_dongle_eventmsg(struct net_device *ndev)
 		    sizeof(iovbuf));
 	err = wl_dev_ioctl(ndev, WLC_GET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
-		WL_ERR(("Get event_msgs error (%d)\n", err));
+		WL_ERR("Get event_msgs error (%d)\n", err);
 		goto dongle_eventmsg_out;
 	}
 	memcpy(eventmask, iovbuf, WL_EVENTING_MASK_LEN);
@@ -3538,7 +3538,7 @@ static s32 wl_dongle_eventmsg(struct net_device *ndev)
 		    sizeof(iovbuf));
 	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
-		WL_ERR(("Set event_msgs error (%d)\n", err));
+		WL_ERR("Set event_msgs error (%d)\n", err);
 		goto dongle_eventmsg_out;
 	}
 
@@ -3556,9 +3556,9 @@ wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 			sizeof(scan_assoc_time));
 	if (err) {
 		if (err == -EOPNOTSUPP) {
-			WL_INFO(("Scan assoc time is not supported\n"));
+			WL_INFO("Scan assoc time is not supported\n");
 		} else {
-			WL_ERR(("Scan assoc time error (%d)\n", err));
+			WL_ERR("Scan assoc time error (%d)\n", err);
 		}
 		goto dongle_scantime_out;
 	}
@@ -3566,9 +3566,9 @@ wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 			sizeof(scan_unassoc_time));
 	if (err) {
 		if (err == -EOPNOTSUPP) {
-			WL_INFO(("Scan unassoc time is not supported\n"));
+			WL_INFO("Scan unassoc time is not supported\n");
 		} else {
-			WL_ERR(("Scan unassoc time error (%d)\n", err));
+			WL_ERR("Scan unassoc time error (%d)\n", err);
 		}
 		goto dongle_scantime_out;
 	}
@@ -3589,9 +3589,9 @@ wl_dongle_offload(struct net_device *ndev, s32 arpoe, s32 arp_ol)
 	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (err) {
 		if (err == -EOPNOTSUPP)
-			WL_INFO(("arpoe is not supported\n"));
+			WL_INFO("arpoe is not supported\n");
 		else
-			WL_ERR(("arpoe error (%d)\n", err));
+			WL_ERR("arpoe error (%d)\n", err);
 
 		goto dongle_offload_out;
 	}
@@ -3599,9 +3599,9 @@ wl_dongle_offload(struct net_device *ndev, s32 arpoe, s32 arp_ol)
 	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (err) {
 		if (err == -EOPNOTSUPP)
-			WL_INFO(("arp_ol is not supported\n"));
+			WL_INFO("arp_ol is not supported\n");
 		else
-			WL_ERR(("arp_ol error (%d)\n", err));
+			WL_ERR("arp_ol error (%d)\n", err);
 
 		goto dongle_offload_out;
 	}
@@ -3614,12 +3614,12 @@ static s32 wl_pattern_atoh(s8 *src, s8 *dst)
 {
 	int i;
 	if (strncmp(src, "0x", 2) != 0 && strncmp(src, "0X", 2) != 0) {
-		WL_ERR(("Mask invalid format. Needs to start with 0x\n"));
+		WL_ERR("Mask invalid format. Needs to start with 0x\n");
 		return -1;
 	}
 	src = src + 2;		/* Skip past 0x */
 	if (strlen(src) % 2 != 0) {
-		WL_ERR(("Mask invalid format. Needs to be of even length\n"));
+		WL_ERR("Mask invalid format. Needs to be of even length\n");
 		return -1;
 	}
 	for (i = 0; *src != '\0'; i++) {
@@ -3678,7 +3678,7 @@ static s32 wl_dongle_filter(struct net_device *ndev, u32 filter_mode)
 					      mask_and_pattern[mask_size]));
 
 	if (mask_size != pattern_size) {
-		WL_ERR(("Mask and pattern not the same size\n"));
+		WL_ERR("Mask and pattern not the same size\n");
 		err = -EINVAL;
 		goto dongle_filter_out;
 	}
@@ -3698,9 +3698,9 @@ static s32 wl_dongle_filter(struct net_device *ndev, u32 filter_mode)
 	err = wl_dev_ioctl(ndev, WLC_SET_VAR, buf, buf_len);
 	if (err) {
 		if (err == -EOPNOTSUPP) {
-			WL_INFO(("filter not supported\n"));
+			WL_INFO("filter not supported\n");
 		} else {
-			WL_ERR(("filter (%d)\n", err));
+			WL_ERR("filter (%d)\n", err);
 		}
 		goto dongle_filter_out;
 	}
@@ -3711,9 +3711,9 @@ static s32 wl_dongle_filter(struct net_device *ndev, u32 filter_mode)
 	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (err) {
 		if (err == -EOPNOTSUPP) {
-			WL_INFO(("filter_mode not supported\n"));
+			WL_INFO("filter_mode not supported\n");
 		} else {
-			WL_ERR(("filter_mode (%d)\n", err));
+			WL_ERR("filter_mode (%d)\n", err);
 		}
 		goto dongle_filter_out;
 	}
@@ -3794,12 +3794,12 @@ static s32 wl_update_wiphybands(struct wl_priv *wl)
 	err = wl_dev_ioctl(wl_to_ndev(wl), WLC_GET_PHYLIST, &phy_list,
 			sizeof(phy_list));
 	if (unlikely(err)) {
-		WL_ERR(("error (%d)\n", err));
+		WL_ERR("error (%d)\n", err);
 		return err;
 	}
 
 	phy = ((char *)&phy_list)[1];
-	WL_DBG(("%c phy\n", phy));
+	WL_DBG("%c phy\n", phy);
 	if (phy == 'n' || phy == 'a') {
 		wiphy = wl_to_wiphy(wl);
 		wiphy->bands[IEEE80211_BAND_5GHZ] = &__wl_band_5ghz_n;
@@ -3905,7 +3905,7 @@ static void *wl_read_prof(struct wl_priv *wl, s32 item)
 	case WL_PROF_SSID:
 		return &wl->profile->ssid;
 	}
-	WL_ERR(("invalid item (%d)\n", item));
+	WL_ERR("invalid item (%d)\n", item);
 	return NULL;
 }
 
@@ -3943,7 +3943,7 @@ wl_update_prof(struct wl_priv *wl, const wl_event_msg_t *e, void *data,
 		wl->profile->dtim_period = *(u8 *)data;
 		break;
 	default:
-		WL_ERR(("unsupported item (%d)\n", item));
+		WL_ERR("unsupported item (%d)\n", item);
 		err = -EOPNOTSUPP;
 		break;
 	}
@@ -3985,7 +3985,7 @@ static __used s32 wl_add_ie(struct wl_priv *wl, u8 t, u8 l, u8 *v)
 	s32 err = 0;
 
 	if (unlikely(ie->offset + l + 2 > WL_TLV_INFO_MAX)) {
-		WL_ERR(("ei crosses buffer boundary\n"));
+		WL_ERR("ei crosses buffer boundary\n");
 		return -ENOSPC;
 	}
 	ie->buf[ie->offset] = t;
@@ -4002,7 +4002,7 @@ static s32 wl_mrg_ie(struct wl_priv *wl, u8 *ie_stream, u16 ie_size)
 	s32 err = 0;
 
 	if (unlikely(ie->offset + ie_size > WL_TLV_INFO_MAX)) {
-		WL_ERR(("ei_stream crosses buffer boundary\n"));
+		WL_ERR("ei_stream crosses buffer boundary\n");
 		return -ENOSPC;
 	}
 	memcpy(&ie->buf[ie->offset], ie_stream, ie_size);
@@ -4017,7 +4017,7 @@ static s32 wl_cp_ie(struct wl_priv *wl, u8 *dst, u16 dst_size)
 	s32 err = 0;
 
 	if (unlikely(ie->offset > dst_size)) {
-		WL_ERR(("dst_size is not enough\n"));
+		WL_ERR("dst_size is not enough\n");
 		return -ENOSPC;
 	}
 	memcpy(dst, &ie->buf[0], ie->offset);
@@ -4117,37 +4117,37 @@ void *wl_cfg80211_request_fw(s8 *file_name)
 	const struct firmware *fw_entry = NULL;
 	s32 err = 0;
 
-	WL_DBG(("file name : \"%s\"\n", file_name));
+	WL_DBG("file name : \"%s\"\n", file_name);
 	wl = WL_PRIV_GET();
 
 	if (!test_bit(WL_FW_LOADING_DONE, &wl->fw->status)) {
 		err = request_firmware(&wl->fw->fw_entry, file_name,
 				&wl_cfg80211_get_sdio_func()->dev);
 		if (unlikely(err)) {
-			WL_ERR(("Could not download fw (%d)\n", err));
+			WL_ERR("Could not download fw (%d)\n", err);
 			goto req_fw_out;
 		}
 		set_bit(WL_FW_LOADING_DONE, &wl->fw->status);
 		fw_entry = wl->fw->fw_entry;
 		if (fw_entry) {
-			WL_DBG(("fw size (%zd), data (%p)\n", fw_entry->size,
-				fw_entry->data));
+			WL_DBG("fw size (%zd), data (%p)\n",
+			       fw_entry->size, fw_entry->data);
 		}
 	} else if (!test_bit(WL_NVRAM_LOADING_DONE, &wl->fw->status)) {
 		err = request_firmware(&wl->fw->fw_entry, file_name,
 				&wl_cfg80211_get_sdio_func()->dev);
 		if (unlikely(err)) {
-			WL_ERR(("Could not download nvram (%d)\n", err));
+			WL_ERR("Could not download nvram (%d)\n", err);
 			goto req_fw_out;
 		}
 		set_bit(WL_NVRAM_LOADING_DONE, &wl->fw->status);
 		fw_entry = wl->fw->fw_entry;
 		if (fw_entry) {
-			WL_DBG(("nvram size (%zd), data (%p)\n", fw_entry->size,
-				fw_entry->data));
+			WL_DBG("nvram size (%zd), data (%p)\n",
+			       fw_entry->size, fw_entry->data);
 		}
 	} else {
-		WL_DBG(("Downloading already done. Nothing to do more\n"));
+		WL_DBG("Downloading already done. Nothing to do more\n");
 		err = -EPERM;
 	}
 
@@ -4183,10 +4183,10 @@ static void wl_set_mpc(struct net_device *ndev, int mpc)
 
 	err = wl_dev_intvar_set(ndev, "mpc", mpc);
 	if (unlikely(err)) {
-		WL_ERR(("fail to set mpc\n"));
+		WL_ERR("fail to set mpc\n");
 		return;
 	}
-	WL_DBG(("MPC : %d\n", mpc));
+	WL_DBG("MPC : %d\n", mpc);
 }
 
 static int wl_debugfs_add_netdev_params(struct wl_priv *wl)
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 1069e65..482691b 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -54,34 +54,36 @@ struct wl_ibss;
 
 #define WL_DBG_LEVEL 1		/* 0 invalidates all debug messages.
 				 default is 1 */
-#define	WL_ERR(args)									\
-do {										\
-	if (wl_dbg_level & WL_DBG_ERR) {				\
-		if (net_ratelimit()) {						\
-			printk(KERN_ERR "ERROR @%s : ", __func__);	\
-			printk args;						\
-		} 								\
-	}									\
+#define	WL_ERR(fmt, args...)					\
+do {								\
+	if (wl_dbg_level & WL_DBG_ERR) {			\
+		if (net_ratelimit()) {				\
+			printk(KERN_ERR "ERROR @%s : " fmt,	\
+			       __func__, ##args);		\
+		}						\
+	}							\
 } while (0)
-#define	WL_INFO(args)									\
-do {										\
-	if (wl_dbg_level & WL_DBG_INFO) {				\
-		if (net_ratelimit()) {						\
-			printk(KERN_ERR "INFO @%s : ", __func__);	\
-			printk args;						\
-		}								\
-	}									\
+
+#define	WL_INFO(fmt, args...)					\
+do {								\
+	if (wl_dbg_level & WL_DBG_INFO) {			\
+		if (net_ratelimit()) {				\
+			printk(KERN_ERR "INFO @%s : " fmt,	\
+			       __func__, ##args);		\
+		}						\
+	}							\
 } while (0)
+
 #if (WL_DBG_LEVEL > 0)
-#define	WL_DBG(args)								\
-do {									\
+#define	WL_DBG(fmt, args...)					\
+do {								\
 	if (wl_dbg_level & WL_DBG_DBG) {			\
-		printk(KERN_ERR "DEBUG @%s :", __func__);	\
-		printk args;							\
-	}									\
+		printk(KERN_ERR "DEBUG @%s :" fmt,		\
+		       __func__, ##args);			\
+	}							\
 } while (0)
 #else				/* !(WL_DBG_LEVEL > 0) */
-#define	WL_DBG(args)
+#define	WL_DBG(fmt, args...) noprintk(fmt, ##args)
 #endif				/* (WL_DBG_LEVEL > 0) */
 
 #define WL_SCAN_RETRY_MAX	3	/* used for ibss scan */
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index 14580b2..db6e68e 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -39,12 +39,11 @@ typedef const struct si_pub si_t;
 #include <dngl_stats.h>
 #include <dhd.h>
 
-#define WL_ERROR(x) printf x
-#define WL_TRACE(x)
-#define WL_ASSOC(x)
-#define WL_INFORM(x)
-#define WL_WSEC(x)
-#define WL_SCAN(x)
+#define WL_ERROR(fmt, args...)	printk(fmt, ##args)
+#define WL_TRACE(fmt, args...)	no_printk(fmt, ##args)
+#define WL_INFORM(fmt, args...)	no_printk(fmt, ##args)
+#define WL_WSEC(fmt, args...)	no_printk(fmt, ##args)
+#define WL_SCAN(fmt, args...)	no_printk(fmt, ##args)
 
 #include <wl_iw.h>
 
@@ -187,12 +186,12 @@ static int dev_wlc_ioctl(struct net_device *dev, int cmd, void *arg, int len)
 	int ret = -EINVAL;
 
 	if (!dev) {
-		WL_ERROR(("%s: dev is null\n", __func__));
+		WL_ERROR("%s: dev is null\n", __func__);
 		return ret;
 	}
 
-	WL_INFORM(("\n%s, PID:%x: send Local IOCTL -> dhd: cmd:0x%x, buf:%p, "
-		"len:%d ,\n", __func__, current->pid, cmd, arg, len));
+	WL_INFORM("\n%s, PID:%x: send Local IOCTL -> dhd: cmd:0x%x, buf:%p, len:%d\n",
+		  __func__, current->pid, cmd, arg, len);
 
 	if (g_onoff == G_WLAN_SET_ON) {
 		memset(&ioc, 0, sizeof(ioc));
@@ -205,7 +204,7 @@ static int dev_wlc_ioctl(struct net_device *dev, int cmd, void *arg, int len)
 
 		ret = dev_open(dev);
 		if (ret) {
-			WL_ERROR(("%s: Error dev_open: %d\n", __func__, ret));
+			WL_ERROR("%s: Error dev_open: %d\n", __func__, ret);
 			return ret;
 		}
 
@@ -214,7 +213,7 @@ static int dev_wlc_ioctl(struct net_device *dev, int cmd, void *arg, int len)
 		ret = dev->netdev_ops->ndo_do_ioctl(dev, &ifr, SIOCDEVPRIVATE);
 		set_fs(fs);
 	} else {
-		WL_TRACE(("%s: call after driver stop : ignored\n", __func__));
+		WL_TRACE("%s: call after driver stop : ignored\n", __func__);
 	}
 	return ret;
 }
@@ -335,7 +334,7 @@ wl_iw_config_commit(struct net_device *dev,
 	int error;
 	struct sockaddr bssid;
 
-	WL_TRACE(("%s: SIOCSIWCOMMIT\n", dev->name));
+	WL_TRACE("%s: SIOCSIWCOMMIT\n", dev->name);
 
 	error = dev_wlc_ioctl(dev, WLC_GET_SSID, &ssid, sizeof(ssid));
 	if (error)
@@ -349,8 +348,8 @@ wl_iw_config_commit(struct net_device *dev,
 	memset(&bssid, 0, sizeof(struct sockaddr));
 	error = dev_wlc_ioctl(dev, WLC_REASSOC, &bssid, ETH_ALEN);
 	if (error) {
-		WL_ERROR(("%s: WLC_REASSOC to %s failed\n", __func__,
-			  ssid.SSID));
+		WL_ERROR("%s: WLC_REASSOC to %s failed\n",
+			 __func__, ssid.SSID);
 		return error;
 	}
 
@@ -361,7 +360,7 @@ static int
 wl_iw_get_name(struct net_device *dev,
 	       struct iw_request_info *info, char *cwrq, char *extra)
 {
-	WL_TRACE(("%s: SIOCGIWNAME\n", dev->name));
+	WL_TRACE("%s: SIOCGIWNAME\n", dev->name);
 
 	strcpy(cwrq, "IEEE 802.11-DS");
 
@@ -375,7 +374,7 @@ wl_iw_set_freq(struct net_device *dev,
 	int error, chan;
 	uint sf = 0;
 
-	WL_TRACE(("\n %s %s: SIOCSIWFREQ\n", __func__, dev->name));
+	WL_TRACE("\n %s %s: SIOCSIWFREQ\n", __func__, dev->name);
 
 	if (fwrq->e == 0 && fwrq->m < MAXCHANNEL) {
 		chan = fwrq->m;
@@ -410,7 +409,7 @@ wl_iw_get_freq(struct net_device *dev,
 	channel_info_t ci;
 	int error;
 
-	WL_TRACE(("%s: SIOCGIWFREQ\n", dev->name));
+	WL_TRACE("%s: SIOCGIWFREQ\n", dev->name);
 
 	error = dev_wlc_ioctl(dev, WLC_GET_CHANNEL, &ci, sizeof(ci));
 	if (error)
@@ -427,7 +426,7 @@ wl_iw_set_mode(struct net_device *dev,
 {
 	int infra = 0, ap = 0, error = 0;
 
-	WL_TRACE(("%s: SIOCSIWMODE\n", dev->name));
+	WL_TRACE("%s: SIOCSIWMODE\n", dev->name);
 
 	switch (*uwrq) {
 	case IW_MODE_MASTER:
@@ -462,7 +461,7 @@ wl_iw_get_mode(struct net_device *dev,
 {
 	int error, infra = 0, ap = 0;
 
-	WL_TRACE(("%s: SIOCGIWMODE\n", dev->name));
+	WL_TRACE("%s: SIOCGIWMODE\n", dev->name);
 
 	error = dev_wlc_ioctl(dev, WLC_GET_INFRA, &infra, sizeof(infra));
 	if (error)
@@ -501,14 +500,14 @@ wl_iw_get_range(struct net_device *dev,
 	{30, 60, 90, 120, 180, 240, 270, 300}
 	};
 
-	WL_TRACE(("%s: SIOCGIWRANGE\n", dev->name));
+	WL_TRACE("%s: SIOCGIWRANGE\n", dev->name);
 
 	if (!extra)
 		return -EINVAL;
 
 	channels = kmalloc((MAXCHANNEL + 1) * 4, GFP_KERNEL);
 	if (!channels) {
-		WL_ERROR(("Could not alloc channels\n"));
+		WL_ERROR("Could not alloc channels\n");
 		return -ENOMEM;
 	}
 	list = (wl_u32_list_t *) channels;
@@ -684,7 +683,7 @@ wl_iw_set_spy(struct net_device *dev,
 	struct sockaddr *addr = (struct sockaddr *)extra;
 	int i;
 
-	WL_TRACE(("%s: SIOCSIWSPY\n", dev->name));
+	WL_TRACE("%s: SIOCSIWSPY\n", dev->name);
 
 	if (!extra)
 		return -EINVAL;
@@ -706,7 +705,7 @@ wl_iw_get_spy(struct net_device *dev,
 	struct iw_quality *qual = (struct iw_quality *)&addr[iw->spy_num];
 	int i;
 
-	WL_TRACE(("%s: SIOCGIWSPY\n", dev->name));
+	WL_TRACE("%s: SIOCGIWSPY\n", dev->name);
 
 	if (!extra)
 		return -EINVAL;
@@ -751,8 +750,8 @@ wl_iw_ch_to_chanspec(int ch, wl_join_params_t *join_params,
 		join_params->params.chanspec_num =
 		    htod32(join_params->params.chanspec_num);
 
-		WL_TRACE(("%s  join_params->params.chanspec_list[0]= %X\n",
-			  __func__, join_params->params.chanspec_list[0]));
+		WL_TRACE("%s  join_params->params.chanspec_list[0]= %X\n",
+			 __func__, join_params->params.chanspec_list[0]);
 	}
 	return 1;
 }
@@ -765,10 +764,10 @@ wl_iw_set_wap(struct net_device *dev,
 	wl_join_params_t join_params;
 	int join_params_size;
 
-	WL_TRACE(("%s: SIOCSIWAP\n", dev->name));
+	WL_TRACE("%s: SIOCSIWAP\n", dev->name);
 
 	if (awrq->sa_family != ARPHRD_ETHER) {
-		WL_ERROR(("Invalid Header...sa_family\n"));
+		WL_ERROR("Invalid Header...sa_family\n");
 		return -EINVAL;
 	}
 
@@ -788,21 +787,21 @@ wl_iw_set_wap(struct net_device *dev,
 	join_params.ssid.SSID_len = htod32(g_ssid.SSID_len);
 	memcpy(&join_params.params.bssid, awrq->sa_data, ETH_ALEN);
 
-	WL_TRACE(("%s  target_channel=%d\n", __func__,
-		  g_wl_iw_params.target_channel));
+	WL_TRACE("%s  target_channel=%d\n",
+		 __func__, g_wl_iw_params.target_channel);
 	wl_iw_ch_to_chanspec(g_wl_iw_params.target_channel, &join_params,
 			     &join_params_size);
 
 	error = dev_wlc_ioctl(dev, WLC_SET_SSID, &join_params,
 				join_params_size);
 	if (error) {
-		WL_ERROR(("%s Invalid ioctl data=%d\n", __func__, error));
+		WL_ERROR("%s Invalid ioctl data=%d\n", __func__, error);
 	}
 
 	if (g_ssid.SSID_len) {
-		WL_TRACE(("%s: join SSID=%s BSSID=%pM ch=%d\n",
-			  __func__, g_ssid.SSID, awrq->sa_data,
-			  g_wl_iw_params.target_channel));
+		WL_TRACE("%s: join SSID=%s BSSID=%pM ch=%d\n",
+			 __func__, g_ssid.SSID, awrq->sa_data,
+			 g_wl_iw_params.target_channel);
 	}
 
 	memset(&g_ssid, 0, sizeof(g_ssid));
@@ -813,7 +812,7 @@ static int
 wl_iw_get_wap(struct net_device *dev,
 	      struct iw_request_info *info, struct sockaddr *awrq, char *extra)
 {
-	WL_TRACE(("%s: SIOCGIWAP\n", dev->name));
+	WL_TRACE("%s: SIOCGIWAP\n", dev->name);
 
 	awrq->sa_family = ARPHRD_ETHER;
 	memset(awrq->sa_data, 0, ETH_ALEN);
@@ -832,11 +831,11 @@ wl_iw_mlme(struct net_device *dev,
 	scb_val_t scbval;
 	int error = -EINVAL;
 
-	WL_TRACE(("%s: SIOCSIWMLME DISASSOC/DEAUTH\n", dev->name));
+	WL_TRACE("%s: SIOCSIWMLME DISASSOC/DEAUTH\n", dev->name);
 
 	mlme = (struct iw_mlme *)extra;
 	if (mlme == NULL) {
-		WL_ERROR(("Invalid ioctl data.\n"));
+		WL_ERROR("Invalid ioctl data\n");
 		return error;
 	}
 
@@ -854,7 +853,7 @@ wl_iw_mlme(struct net_device *dev,
 		    dev_wlc_ioctl(dev, WLC_SCB_DEAUTHENTICATE_FOR_REASON,
 				  &scbval, sizeof(scb_val_t));
 	} else {
-		WL_ERROR(("Invalid ioctl data.\n"));
+		WL_ERROR("Invalid ioctl data\n");
 		return error;
 	}
 
@@ -875,7 +874,7 @@ wl_iw_get_aplist(struct net_device *dev,
 	int error, i;
 	uint buflen = dwrq->length;
 
-	WL_TRACE(("%s: SIOCGIWAPLIST\n", dev->name));
+	WL_TRACE("%s: SIOCGIWAPLIST\n", dev->name);
 
 	if (!extra)
 		return -EINVAL;
@@ -887,7 +886,7 @@ wl_iw_get_aplist(struct net_device *dev,
 	list->buflen = htod32(buflen);
 	error = dev_wlc_ioctl(dev, WLC_SCAN_RESULTS, list, buflen);
 	if (error) {
-		WL_ERROR(("%d: Scan results error %d\n", __LINE__, error));
+		WL_ERROR("%d: Scan results error %d\n", __LINE__, error);
 		kfree(list);
 		return error;
 	}
@@ -895,8 +894,8 @@ wl_iw_get_aplist(struct net_device *dev,
 	list->version = dtoh32(list->version);
 	list->count = dtoh32(list->count);
 	if (list->version != WL_BSS_INFO_VERSION) {
-		WL_ERROR(("%s : list->version %d != WL_BSS_INFO_VERSION\n",
-			  __func__, list->version));
+		WL_ERROR("%s : list->version %d != WL_BSS_INFO_VERSION\n",
+			 __func__, list->version);
 		kfree(list);
 		return -EINVAL;
 	}
@@ -953,13 +952,13 @@ wl_iw_iscan_get_aplist(struct net_device *dev,
 	wl_bss_info_t *bi = NULL;
 	int i;
 
-	WL_TRACE(("%s: SIOCGIWAPLIST\n", dev->name));
+	WL_TRACE("%s: SIOCGIWAPLIST\n", dev->name);
 
 	if (!extra)
 		return -EINVAL;
 
 	if ((!iscan) || (!iscan->sysioc_tsk)) {
-		WL_ERROR(("%s error\n", __func__));
+		WL_ERROR("%s error\n", __func__);
 		return 0;
 	}
 
@@ -967,9 +966,8 @@ wl_iw_iscan_get_aplist(struct net_device *dev,
 	while (buf) {
 		list = &((wl_iscan_results_t *) buf->iscan_buf)->results;
 		if (list->version != WL_BSS_INFO_VERSION) {
-			WL_ERROR(("%s : list->version %d != "
-				"WL_BSS_INFO_VERSION\n",
-				__func__, list->version));
+			WL_ERROR("%s : list->version %d != WL_BSS_INFO_VERSION\n",
+				 __func__, list->version);
 			return -EINVAL;
 		}
 
@@ -1044,15 +1042,15 @@ static int wl_iw_iscan(iscan_info_t *iscan, wlc_ssid_t *ssid, u16 action)
 	iscan->iscan_ex_params_p->action = htod16(action);
 	iscan->iscan_ex_params_p->scan_duration = htod16(0);
 
-	WL_SCAN(("%s : nprobes=%d\n", __func__,
-		 iscan->iscan_ex_params_p->params.nprobes));
-	WL_SCAN(("active_time=%d\n",
-		 iscan->iscan_ex_params_p->params.active_time));
-	WL_SCAN(("passive_time=%d\n",
-		 iscan->iscan_ex_params_p->params.passive_time));
-	WL_SCAN(("home_time=%d\n", iscan->iscan_ex_params_p->params.home_time));
-	WL_SCAN(("scan_type=%d\n", iscan->iscan_ex_params_p->params.scan_type));
-	WL_SCAN(("bss_type=%d\n", iscan->iscan_ex_params_p->params.bss_type));
+	WL_SCAN("%s : nprobes=%d\n",
+		__func__, iscan->iscan_ex_params_p->params.nprobes);
+	WL_SCAN("active_time=%d\n",
+		 iscan->iscan_ex_params_p->params.active_time);
+	WL_SCAN("passive_time=%d\n",
+		 iscan->iscan_ex_params_p->params.passive_time);
+	WL_SCAN("home_time=%d\n", iscan->iscan_ex_params_p->params.home_time);
+	WL_SCAN("scan_type=%d\n", iscan->iscan_ex_params_p->params.scan_type);
+	WL_SCAN("bss_type=%d\n", iscan->iscan_ex_params_p->params.bss_type);
 
 	(void)dev_iw_iovar_setbuf(iscan->dev, "iscan", iscan->iscan_ex_params_p,
 				  iscan->iscan_ex_param_size, iscan->ioctlbuf,
@@ -1067,7 +1065,7 @@ static void wl_iw_timerfunc(unsigned long data)
 	if (iscan) {
 		iscan->timer_on = 0;
 		if (iscan->iscan_state != ISCAN_STATE_IDLE) {
-			WL_TRACE(("timer trigger\n"));
+			WL_TRACE("timer trigger\n");
 			up(&iscan->sysioc_sem);
 		}
 	}
@@ -1102,8 +1100,8 @@ static u32 wl_iw_iscan_get(iscan_info_t *iscan)
 	} else {
 		buf = kmalloc(sizeof(iscan_buf_t), GFP_KERNEL);
 		if (!buf) {
-			WL_ERROR(("%s can't alloc iscan_buf_t : going to abort "
-				"currect iscan\n", __func__));
+			WL_ERROR("%s can't alloc iscan_buf_t : going to abort current iscan\n",
+				 __func__);
 			MUTEX_UNLOCK_WL_SCAN_SET();
 			return WL_SCAN_RESULTS_NO_MEM;
 		}
@@ -1136,11 +1134,11 @@ static u32 wl_iw_iscan_get(iscan_info_t *iscan)
 		results->buflen = dtoh32(results->buflen);
 		results->version = dtoh32(results->version);
 		results->count = dtoh32(results->count);
-		WL_TRACE(("results->count = %d\n", results->count));
-		WL_TRACE(("results->buflen = %d\n", results->buflen));
+		WL_TRACE("results->count = %d\n", results->count);
+		WL_TRACE("results->buflen = %d\n", results->buflen);
 		status = dtoh32(list_buf->status);
 	} else {
-		WL_ERROR(("%s returns error %d\n", __func__, res));
+		WL_ERROR("%s returns error %d\n", __func__, res);
 		status = WL_SCAN_RESULTS_NO_MEM;
 	}
 	MUTEX_UNLOCK_WL_SCAN_SET();
@@ -1149,8 +1147,8 @@ static u32 wl_iw_iscan_get(iscan_info_t *iscan)
 
 static void wl_iw_force_specific_scan(iscan_info_t *iscan)
 {
-	WL_TRACE(("%s force Specific SCAN for %s\n", __func__,
-		  g_specific_ssid.SSID));
+	WL_TRACE("%s force Specific SCAN for %s\n",
+		 __func__, g_specific_ssid.SSID);
 	rtnl_lock();
 
 	(void)dev_wlc_ioctl(iscan->dev, WLC_SCAN, &g_specific_ssid,
@@ -1167,7 +1165,7 @@ static void wl_iw_send_scan_complete(iscan_info_t *iscan)
 	memset(&wrqu, 0, sizeof(wrqu));
 
 	wireless_send_event(iscan->dev, SIOCGIWSCAN, &wrqu, NULL);
-	WL_TRACE(("Send Event ISCAN complete\n"));
+	WL_TRACE("Send Event ISCAN complete\n");
 #endif
 }
 
@@ -1191,8 +1189,8 @@ static int _iscan_sysioc_thread(void *data)
 		status = wl_iw_iscan_get(iscan);
 		rtnl_unlock();
 		if (g_scan_specified_ssid && (iscan_pass_abort == true)) {
-			WL_TRACE(("%s Get results from specific scan "
-				"status = %d\n", __func__, status));
+			WL_TRACE("%s Get results from specific scan status = %d\n",
+				 __func__, status);
 			wl_iw_send_scan_complete(iscan);
 			iscan_pass_abort = false;
 			status = -1;
@@ -1200,7 +1198,7 @@ static int _iscan_sysioc_thread(void *data)
 
 		switch (status) {
 		case WL_SCAN_RESULTS_PARTIAL:
-			WL_TRACE(("iscanresults incomplete\n"));
+			WL_TRACE("iscanresults incomplete\n");
 			rtnl_lock();
 			wl_iw_iscan(iscan, NULL, WL_SCAN_ACTION_CONTINUE);
 			rtnl_unlock();
@@ -1209,18 +1207,18 @@ static int _iscan_sysioc_thread(void *data)
 			iscan->timer_on = 1;
 			break;
 		case WL_SCAN_RESULTS_SUCCESS:
-			WL_TRACE(("iscanresults complete\n"));
+			WL_TRACE("iscanresults complete\n");
 			iscan->iscan_state = ISCAN_STATE_IDLE;
 			wl_iw_send_scan_complete(iscan);
 			break;
 		case WL_SCAN_RESULTS_PENDING:
-			WL_TRACE(("iscanresults pending\n"));
+			WL_TRACE("iscanresults pending\n");
 			mod_timer(&iscan->timer,
 				  jiffies + iscan->timer_ms * HZ / 1000);
 			iscan->timer_on = 1;
 			break;
 		case WL_SCAN_RESULTS_ABORTED:
-			WL_TRACE(("iscanresults aborted\n"));
+			WL_TRACE("iscanresults aborted\n");
 			iscan->iscan_state = ISCAN_STATE_IDLE;
 			if (g_scan_specified_ssid == 0)
 				wl_iw_send_scan_complete(iscan);
@@ -1230,12 +1228,12 @@ static int _iscan_sysioc_thread(void *data)
 			}
 			break;
 		case WL_SCAN_RESULTS_NO_MEM:
-			WL_TRACE(("iscanresults can't alloc memory: skip\n"));
+			WL_TRACE("iscanresults can't alloc memory: skip\n");
 			iscan->iscan_state = ISCAN_STATE_IDLE;
 			break;
 		default:
-			WL_TRACE(("iscanresults returned unknown status %d\n",
-				  status));
+			WL_TRACE("iscanresults returned unknown status %d\n",
+				 status);
 			break;
 		}
 	}
@@ -1254,11 +1252,11 @@ wl_iw_set_scan(struct net_device *dev,
 	       union iwreq_data *wrqu, char *extra)
 {
 	int error;
-	WL_TRACE(("\n:%s dev:%s: SIOCSIWSCAN : SCAN\n", __func__, dev->name));
+	WL_TRACE("\n:%s dev:%s: SIOCSIWSCAN : SCAN\n", __func__, dev->name);
 
 	g_set_essid_before_scan = false;
 #if defined(CSCAN)
-	WL_ERROR(("%s: Scan from SIOCGIWSCAN not supported\n", __func__));
+	WL_ERROR("%s: Scan from SIOCGIWSCAN not supported\n", __func__);
 	return -EINVAL;
 #endif
 
@@ -1275,9 +1273,8 @@ wl_iw_set_scan(struct net_device *dev,
 		if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
 			struct iw_scan_req *req = (struct iw_scan_req *)extra;
 			if (g_scan_specified_ssid) {
-				WL_TRACE(("%s Specific SCAN is not done ignore "
-					"scan for = %s\n",
-					__func__, req->essid));
+				WL_TRACE("%s Specific SCAN is not done ignore scan for = %s\n",
+					 __func__, req->essid);
 				return -EBUSY;
 			} else {
 				g_specific_ssid.SSID_len = min_t(size_t,
@@ -1288,9 +1285,9 @@ wl_iw_set_scan(struct net_device *dev,
 				g_specific_ssid.SSID_len =
 				    htod32(g_specific_ssid.SSID_len);
 				g_scan_specified_ssid = 1;
-				WL_TRACE(("### Specific scan ssid=%s len=%d\n",
-					  g_specific_ssid.SSID,
-					  g_specific_ssid.SSID_len));
+				WL_TRACE("### Specific scan ssid=%s len=%d\n",
+					 g_specific_ssid.SSID,
+					 g_specific_ssid.SSID_len);
 			}
 		}
 	}
@@ -1298,8 +1295,8 @@ wl_iw_set_scan(struct net_device *dev,
 	error = dev_wlc_ioctl(dev, WLC_SCAN, &g_specific_ssid,
 				sizeof(g_specific_ssid));
 	if (error) {
-		WL_TRACE(("#### Set SCAN for %s failed with %d\n",
-			  g_specific_ssid.SSID, error));
+		WL_TRACE("#### Set SCAN for %s failed with %d\n",
+			 g_specific_ssid.SSID, error);
 		g_scan_specified_ssid = 0;
 		return -EBUSY;
 	}
@@ -1318,7 +1315,7 @@ int wl_iw_iscan_set_scan_broadcast_prep(struct net_device *dev, uint flag)
 
 	wl_iw_set_event_mask(dev);
 
-	WL_TRACE(("+++: Set Broadcast ISCAN\n"));
+	WL_TRACE("+++: Set Broadcast ISCAN\n");
 	memset(&ssid, 0, sizeof(ssid));
 
 	iscan->list_cur = iscan->list_hdr;
@@ -1347,20 +1344,20 @@ wl_iw_iscan_set_scan(struct net_device *dev,
 	wlc_ssid_t ssid;
 	iscan_info_t *iscan = g_iscan;
 
-	WL_TRACE(("%s: SIOCSIWSCAN : ISCAN\n", dev->name));
+	WL_TRACE("%s: SIOCSIWSCAN : ISCAN\n", dev->name);
 
 #if defined(CSCAN)
-	WL_ERROR(("%s: Scan from SIOCGIWSCAN not supported\n", __func__));
+	WL_ERROR("%s: Scan from SIOCGIWSCAN not supported\n", __func__);
 	return -EINVAL;
 #endif
 
 	if (g_onoff == G_WLAN_SET_OFF) {
-		WL_TRACE(("%s: driver is not up yet after START\n", __func__));
+		WL_TRACE("%s: driver is not up yet after START\n", __func__);
 		return 0;
 	}
 #ifdef PNO_SUPPORT
 	if (dhd_dev_get_pno_status(dev)) {
-		WL_ERROR(("%s: Scan called when PNO is active\n", __func__));
+		WL_ERROR("%s: Scan called when PNO is active\n", __func__);
 	}
 #endif
 
@@ -1368,8 +1365,8 @@ wl_iw_iscan_set_scan(struct net_device *dev,
 		return wl_iw_set_scan(dev, info, wrqu, extra);
 
 	if (g_scan_specified_ssid) {
-		WL_TRACE(("%s Specific SCAN already running ignoring BC scan\n",
-			  __func__));
+		WL_TRACE("%s Specific SCAN already running ignoring BC scan\n",
+			 __func__);
 		return EBUSY;
 	}
 
@@ -1387,8 +1384,8 @@ wl_iw_iscan_set_scan(struct net_device *dev,
 			g_scan_specified_ssid = 0;
 
 			if (iscan->iscan_state == ISCAN_STATE_SCANING) {
-				WL_TRACE(("%s ISCAN already in progress \n",
-					  __func__));
+				WL_TRACE("%s ISCAN already in progress\n",
+					 __func__);
 				return 0;
 			}
 		}
@@ -1502,9 +1499,8 @@ wl_iw_get_scan_prep(wl_scan_results_t *list,
 
 	for (i = 0; i < list->count && i < IW_MAX_AP; i++) {
 		if (list->version != WL_BSS_INFO_VERSION) {
-			WL_ERROR(("%s : list->version %d != "
-				"WL_BSS_INFO_VERSION\n",
-				__func__, list->version));
+			WL_ERROR("%s : list->version %d != WL_BSS_INFO_VERSION\n",
+				 __func__, list->version);
 			return ret;
 		}
 
@@ -1512,7 +1508,7 @@ wl_iw_get_scan_prep(wl_scan_results_t *list,
 					     dtoh32(bi->length)) : list->
 		    bss_info;
 
-		WL_TRACE(("%s : %s\n", __func__, bi->SSID));
+		WL_TRACE("%s : %s\n", __func__, bi->SSID);
 
 		iwe.cmd = SIOCGIWAP;
 		iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
@@ -1591,11 +1587,11 @@ wl_iw_get_scan_prep(wl_scan_results_t *list,
 
 	ret = event - extra;
 	if (ret < 0) {
-		WL_ERROR(("==> Wrong size\n"));
+		WL_ERROR("==> Wrong size\n");
 		ret = 0;
 	}
-	WL_TRACE(("%s: size=%d bytes prepared\n", __func__,
-		  (unsigned int)(event - extra)));
+	WL_TRACE("%s: size=%d bytes prepared\n",
+		 __func__, (unsigned int)(event - extra));
 	return (uint)ret;
 }
 
@@ -1615,10 +1611,10 @@ wl_iw_get_scan(struct net_device *dev,
 	iscan_buf_t *p_buf;
 #endif
 
-	WL_TRACE(("%s: buflen_from_user %d: \n", dev->name, buflen_from_user));
+	WL_TRACE("%s: buflen_from_user %d:\n", dev->name, buflen_from_user);
 
 	if (!extra) {
-		WL_TRACE(("%s: wl_iw_get_scan return -EINVAL\n", dev->name));
+		WL_TRACE("%s: wl_iw_get_scan return -EINVAL\n", dev->name);
 		return -EINVAL;
 	}
 
@@ -1632,8 +1628,8 @@ wl_iw_get_scan(struct net_device *dev,
 	if (g_scan_specified_ssid) {
 		list = kmalloc(len, GFP_KERNEL);
 		if (!list) {
-			WL_TRACE(("%s: wl_iw_get_scan return -ENOMEM\n",
-				  dev->name));
+			WL_TRACE("%s: wl_iw_get_scan return -ENOMEM\n",
+				 dev->name);
 			g_scan_specified_ssid = 0;
 			return -ENOMEM;
 		}
@@ -1643,8 +1639,8 @@ wl_iw_get_scan(struct net_device *dev,
 	list->buflen = htod32(len);
 	error = dev_wlc_ioctl(dev, WLC_SCAN_RESULTS, list, len);
 	if (error) {
-		WL_ERROR(("%s: %s : Scan_results ERROR %d\n", dev->name,
-			  __func__, error));
+		WL_ERROR("%s: %s : Scan_results ERROR %d\n",
+			 dev->name, __func__, error);
 		dwrq->length = len;
 		if (g_scan_specified_ssid) {
 			g_scan_specified_ssid = 0;
@@ -1657,8 +1653,8 @@ wl_iw_get_scan(struct net_device *dev,
 	list->count = dtoh32(list->count);
 
 	if (list->version != WL_BSS_INFO_VERSION) {
-		WL_ERROR(("%s : list->version %d != WL_BSS_INFO_VERSION\n",
-			  __func__, list->version));
+		WL_ERROR("%s : list->version %d != WL_BSS_INFO_VERSION\n",
+			 __func__, list->version);
 		if (g_scan_specified_ssid) {
 			g_scan_specified_ssid = 0;
 			kfree(list);
@@ -1667,8 +1663,8 @@ wl_iw_get_scan(struct net_device *dev,
 	}
 
 	if (g_scan_specified_ssid) {
-		WL_TRACE(("%s: Specified scan APs in the list =%d\n",
-			  __func__, list->count));
+		WL_TRACE("%s: Specified scan APs in the list =%d\n",
+			 __func__, list->count);
 		len_ret =
 		    (__u16) wl_iw_get_scan_prep(list, info, extra,
 						buflen_from_user);
@@ -1679,8 +1675,8 @@ wl_iw_get_scan(struct net_device *dev,
 		while (p_buf != iscan->list_cur) {
 			list_merge =
 			    &((wl_iscan_results_t *) p_buf->iscan_buf)->results;
-			WL_TRACE(("%s: Bcast APs list=%d\n", __func__,
-				  list_merge->count));
+			WL_TRACE("%s: Bcast APs list=%d\n",
+				 __func__, list_merge->count);
 			if (list_merge->count > 0)
 				len_ret +=
 				    (__u16) wl_iw_get_scan_prep(list_merge,
@@ -1690,8 +1686,8 @@ wl_iw_get_scan(struct net_device *dev,
 		}
 #else
 		list_merge = (wl_scan_results_t *) g_scan;
-		WL_TRACE(("%s: Bcast APs list=%d\n", __func__,
-			  list_merge->count));
+		WL_TRACE("%s: Bcast APs list=%d\n",
+			 __func__, list_merge->count);
 		if (list_merge->count > 0)
 			len_ret +=
 			    (__u16) wl_iw_get_scan_prep(list_merge, info,
@@ -1715,8 +1711,8 @@ wl_iw_get_scan(struct net_device *dev,
 	dwrq->length = len;
 	dwrq->flags = 0;
 
-	WL_TRACE(("%s return to WE %d bytes APs=%d\n", __func__,
-		  dwrq->length, list->count));
+	WL_TRACE("%s return to WE %d bytes APs=%d\n",
+		 __func__, dwrq->length, list->count);
 	return 0;
 }
 
@@ -1737,26 +1733,26 @@ wl_iw_iscan_get_scan(struct net_device *dev,
 	u32 counter = 0;
 	u8 channel;
 
-	WL_TRACE(("%s %s buflen_from_user %d:\n", dev->name, __func__,
-		  dwrq->length));
+	WL_TRACE("%s %s buflen_from_user %d:\n",
+		 dev->name, __func__, dwrq->length);
 
 	if (!extra) {
-		WL_TRACE(("%s: INVALID SIOCGIWSCAN GET bad parameter\n",
-			  dev->name));
+		WL_TRACE("%s: INVALID SIOCGIWSCAN GET bad parameter\n",
+			 dev->name);
 		return -EINVAL;
 	}
 
 	if ((!iscan) || (!iscan->sysioc_tsk)) {
-		WL_ERROR(("%ssysioc_tsk\n", __func__));
+		WL_ERROR("%ssysioc_tsk\n", __func__);
 		return wl_iw_get_scan(dev, info, dwrq, extra);
 	}
 
 	if (iscan->iscan_state == ISCAN_STATE_SCANING) {
-		WL_TRACE(("%s: SIOCGIWSCAN GET still scanning\n", dev->name));
+		WL_TRACE("%s: SIOCGIWSCAN GET still scanning\n", dev->name);
 		return -EAGAIN;
 	}
 
-	WL_TRACE(("%s: SIOCGIWSCAN GET broadcast results\n", dev->name));
+	WL_TRACE("%s: SIOCGIWSCAN GET broadcast results\n", dev->name);
 	apcnt = 0;
 	p_buf = iscan->list_hdr;
 	while (p_buf != iscan->list_cur) {
@@ -1765,9 +1761,8 @@ wl_iw_iscan_get_scan(struct net_device *dev,
 		counter += list->count;
 
 		if (list->version != WL_BSS_INFO_VERSION) {
-			WL_ERROR(("%s : list->version %d != "
-				"WL_BSS_INFO_VERSION\n",
-				__func__, list->version));
+			WL_ERROR("%s : list->version %d != WL_BSS_INFO_VERSION\n",
+				 __func__, list->version);
 			return -EINVAL;
 		}
 
@@ -1877,8 +1872,8 @@ wl_iw_iscan_get_scan(struct net_device *dev,
 	dwrq->length = event - extra;
 	dwrq->flags = 0;
 
-	WL_TRACE(("%s return to WE %d bytes APs=%d\n", __func__,
-		  dwrq->length, counter));
+	WL_TRACE("%s return to WE %d bytes APs=%d\n",
+		 __func__, dwrq->length, counter);
 
 	if (!dwrq->length)
 		return -EAGAIN;
@@ -1896,7 +1891,7 @@ wl_iw_set_essid(struct net_device *dev,
 	wl_join_params_t join_params;
 	int join_params_size;
 
-	WL_TRACE(("%s: SIOCSIWESSID\n", dev->name));
+	WL_TRACE("%s: SIOCSIWESSID\n", dev->name);
 
 	if (g_set_essid_before_scan)
 		return -EAGAIN;
@@ -1932,11 +1927,11 @@ wl_iw_set_essid(struct net_device *dev,
 	error = dev_wlc_ioctl(dev, WLC_SET_SSID, &join_params,
 				join_params_size);
 	if (error)
-		WL_ERROR(("Invalid ioctl data=%d\n", error));
+		WL_ERROR("Invalid ioctl data=%d\n", error);
 
 	if (g_ssid.SSID_len) {
-		WL_TRACE(("%s: join SSID=%s ch=%d\n", __func__,
-			  g_ssid.SSID, g_wl_iw_params.target_channel));
+		WL_TRACE("%s: join SSID=%s ch=%d\n",
+			 __func__, g_ssid.SSID, g_wl_iw_params.target_channel);
 	}
 	return 0;
 }
@@ -1949,14 +1944,14 @@ wl_iw_get_essid(struct net_device *dev,
 	wlc_ssid_t ssid;
 	int error;
 
-	WL_TRACE(("%s: SIOCGIWESSID\n", dev->name));
+	WL_TRACE("%s: SIOCGIWESSID\n", dev->name);
 
 	if (!extra)
 		return -EINVAL;
 
 	error = dev_wlc_ioctl(dev, WLC_GET_SSID, &ssid, sizeof(ssid));
 	if (error) {
-		WL_ERROR(("Error getting the SSID\n"));
+		WL_ERROR("Error getting the SSID\n");
 		return error;
 	}
 
@@ -1977,7 +1972,7 @@ wl_iw_set_nick(struct net_device *dev,
 {
 	wl_iw_t *iw = *(wl_iw_t **) netdev_priv(dev);
 
-	WL_TRACE(("%s: SIOCSIWNICKN\n", dev->name));
+	WL_TRACE("%s: SIOCSIWNICKN\n", dev->name);
 
 	if (!extra)
 		return -EINVAL;
@@ -1997,7 +1992,7 @@ wl_iw_get_nick(struct net_device *dev,
 {
 	wl_iw_t *iw = *(wl_iw_t **) netdev_priv(dev);
 
-	WL_TRACE(("%s: SIOCGIWNICKN\n", dev->name));
+	WL_TRACE("%s: SIOCGIWNICKN\n", dev->name);
 
 	if (!extra)
 		return -EINVAL;
@@ -2015,7 +2010,7 @@ wl_iw_set_rate(struct net_device *dev,
 	wl_rateset_t rateset;
 	int error, rate, i, error_bg, error_a;
 
-	WL_TRACE(("%s: SIOCSIWRATE\n", dev->name));
+	WL_TRACE("%s: SIOCSIWRATE\n", dev->name);
 
 	error = dev_wlc_ioctl(dev, WLC_GET_CURR_RATESET, &rateset,
 				sizeof(rateset));
@@ -2064,7 +2059,7 @@ wl_iw_get_rate(struct net_device *dev,
 {
 	int error, rate;
 
-	WL_TRACE(("%s: SIOCGIWRATE\n", dev->name));
+	WL_TRACE("%s: SIOCGIWRATE\n", dev->name);
 
 	error = dev_wlc_ioctl(dev, WLC_GET_RATE, &rate, sizeof(rate));
 	if (error)
@@ -2081,7 +2076,7 @@ wl_iw_set_rts(struct net_device *dev,
 {
 	int error, rts;
 
-	WL_TRACE(("%s: SIOCSIWRTS\n", dev->name));
+	WL_TRACE("%s: SIOCSIWRTS\n", dev->name);
 
 	if (vwrq->disabled)
 		rts = DOT11_DEFAULT_RTS_LEN;
@@ -2103,7 +2098,7 @@ wl_iw_get_rts(struct net_device *dev,
 {
 	int error, rts;
 
-	WL_TRACE(("%s: SIOCGIWRTS\n", dev->name));
+	WL_TRACE("%s: SIOCGIWRTS\n", dev->name);
 
 	error = dev_wlc_intvar_get(dev, "rtsthresh", &rts);
 	if (error)
@@ -2122,7 +2117,7 @@ wl_iw_set_frag(struct net_device *dev,
 {
 	int error, frag;
 
-	WL_TRACE(("%s: SIOCSIWFRAG\n", dev->name));
+	WL_TRACE("%s: SIOCSIWFRAG\n", dev->name);
 
 	if (vwrq->disabled)
 		frag = DOT11_DEFAULT_FRAG_LEN;
@@ -2144,7 +2139,7 @@ wl_iw_get_frag(struct net_device *dev,
 {
 	int error, fragthreshold;
 
-	WL_TRACE(("%s: SIOCGIWFRAG\n", dev->name));
+	WL_TRACE("%s: SIOCGIWFRAG\n", dev->name);
 
 	error = dev_wlc_intvar_get(dev, "fragthresh", &fragthreshold);
 	if (error)
@@ -2164,7 +2159,7 @@ wl_iw_set_txpow(struct net_device *dev,
 {
 	int error, disable;
 	u16 txpwrmw;
-	WL_TRACE(("%s: SIOCSIWTXPOW\n", dev->name));
+	WL_TRACE("%s: SIOCSIWTXPOW\n", dev->name);
 
 	disable = vwrq->disabled ? WL_RADIO_SW_DISABLE : 0;
 	disable += WL_RADIO_SW_DISABLE << 16;
@@ -2201,7 +2196,7 @@ wl_iw_get_txpow(struct net_device *dev,
 	int error, disable, txpwrdbm;
 	u8 result;
 
-	WL_TRACE(("%s: SIOCGIWTXPOW\n", dev->name));
+	WL_TRACE("%s: SIOCGIWTXPOW\n", dev->name);
 
 	error = dev_wlc_ioctl(dev, WLC_GET_RADIO, &disable, sizeof(disable));
 	if (error)
@@ -2230,7 +2225,7 @@ wl_iw_set_retry(struct net_device *dev,
 {
 	int error, lrl, srl;
 
-	WL_TRACE(("%s: SIOCSIWRETRY\n", dev->name));
+	WL_TRACE("%s: SIOCSIWRETRY\n", dev->name);
 
 	if (vwrq->disabled || (vwrq->flags & IW_RETRY_LIFETIME))
 		return -EINVAL;
@@ -2278,7 +2273,7 @@ wl_iw_get_retry(struct net_device *dev,
 {
 	int error, lrl, srl;
 
-	WL_TRACE(("%s: SIOCGIWRETRY\n", dev->name));
+	WL_TRACE("%s: SIOCGIWRETRY\n", dev->name);
 
 	vwrq->disabled = 0;
 
@@ -2318,7 +2313,7 @@ wl_iw_set_encode(struct net_device *dev,
 	wl_wsec_key_t key;
 	int error, val, wsec;
 
-	WL_TRACE(("%s: SIOCSIWENCODE\n", dev->name));
+	WL_TRACE("%s: SIOCSIWENCODE\n", dev->name);
 
 	memset(&key, 0, sizeof(key));
 
@@ -2410,7 +2405,7 @@ wl_iw_get_encode(struct net_device *dev,
 	wl_wsec_key_t key;
 	int error, val, wsec, auth;
 
-	WL_TRACE(("%s: SIOCGIWENCODE\n", dev->name));
+	WL_TRACE("%s: SIOCGIWENCODE\n", dev->name);
 
 	memset(&key, 0, sizeof(wl_wsec_key_t));
 
@@ -2466,7 +2461,7 @@ wl_iw_set_power(struct net_device *dev,
 {
 	int error, pm;
 
-	WL_TRACE(("%s: SIOCSIWPOWER\n", dev->name));
+	WL_TRACE("%s: SIOCSIWPOWER\n", dev->name);
 
 	pm = vwrq->disabled ? PM_OFF : PM_MAX;
 
@@ -2485,7 +2480,7 @@ wl_iw_get_power(struct net_device *dev,
 {
 	int error, pm;
 
-	WL_TRACE(("%s: SIOCGIWPOWER\n", dev->name));
+	WL_TRACE("%s: SIOCGIWPOWER\n", dev->name);
 
 	error = dev_wlc_ioctl(dev, WLC_GET_PM, &pm, sizeof(pm));
 	if (error)
@@ -2504,7 +2499,7 @@ wl_iw_set_wpaie(struct net_device *dev,
 		struct iw_request_info *info, struct iw_point *iwp, char *extra)
 {
 
-	WL_TRACE(("%s: SIOCSIWGENIE\n", dev->name));
+	WL_TRACE("%s: SIOCSIWGENIE\n", dev->name);
 
 	CHECK_EXTRA_FOR_NULL(extra);
 
@@ -2517,7 +2512,7 @@ static int
 wl_iw_get_wpaie(struct net_device *dev,
 		struct iw_request_info *info, struct iw_point *iwp, char *extra)
 {
-	WL_TRACE(("%s: SIOCGIWGENIE\n", dev->name));
+	WL_TRACE("%s: SIOCGIWGENIE\n", dev->name);
 	iwp->length = 64;
 	dev_wlc_bufvar_get(dev, "wpaie", extra, iwp->length);
 	return 0;
@@ -2532,7 +2527,7 @@ wl_iw_set_encodeext(struct net_device *dev,
 	int error;
 	struct iw_encode_ext *iwe;
 
-	WL_TRACE(("%s: SIOCSIWENCODEEXT\n", dev->name));
+	WL_TRACE("%s: SIOCSIWENCODEEXT\n", dev->name);
 
 	CHECK_EXTRA_FOR_NULL(extra);
 
@@ -2555,8 +2550,8 @@ wl_iw_set_encodeext(struct net_device *dev,
 
 	if (key.len == 0) {
 		if (iwe->ext_flags & IW_ENCODE_EXT_SET_TX_KEY) {
-			WL_WSEC(("Changing the the primary Key to %d\n",
-				 key.index));
+			WL_WSEC("Changing the the primary Key to %d\n",
+				key.index);
 			key.index = htod32(key.index);
 			error = dev_wlc_ioctl(dev, WLC_SET_KEY_PRIMARY,
 					      &key.index, sizeof(key.index));
@@ -2570,9 +2565,9 @@ wl_iw_set_encodeext(struct net_device *dev,
 		if (iwe->key_len > sizeof(key.data))
 			return -EINVAL;
 
-		WL_WSEC(("Setting the key index %d\n", key.index));
+		WL_WSEC("Setting the key index %d\n", key.index);
 		if (iwe->ext_flags & IW_ENCODE_EXT_SET_TX_KEY) {
-			WL_WSEC(("key is a Primary Key\n"));
+			WL_WSEC("key is a Primary Key\n");
 			key.flags = WL_PRIMARY_KEY;
 		}
 
@@ -2639,14 +2634,14 @@ wl_iw_set_pmksa(struct net_device *dev,
 	uint i;
 	int ret = 0;
 
-	WL_WSEC(("%s: SIOCSIWPMKSA\n", dev->name));
+	WL_WSEC("%s: SIOCSIWPMKSA\n", dev->name);
 
 	CHECK_EXTRA_FOR_NULL(extra);
 
 	iwpmksa = (struct iw_pmksa *)extra;
 
 	if (iwpmksa->cmd == IW_PMKSA_FLUSH) {
-		WL_WSEC(("wl_iw_set_pmksa - IW_PMKSA_FLUSH\n"));
+		WL_WSEC("wl_iw_set_pmksa - IW_PMKSA_FLUSH\n");
 		memset((char *)&pmkid_list, 0, sizeof(pmkid_list));
 	}
 
@@ -2661,11 +2656,11 @@ wl_iw_set_pmksa(struct net_device *dev,
 			bcopy(&iwpmksa->pmkid[0], &pmkidptr->pmkid[0].PMKID,
 			      WPA2_PMKID_LEN);
 
-			WL_WSEC(("wl_iw_set_pmksa:IW_PMKSA_REMOVE:PMKID: "
-				"%pM = ", &pmkidptr->pmkid[0].BSSID));
+			WL_WSEC("wl_iw_set_pmksa:IW_PMKSA_REMOVE:PMKID: %pM = ",
+				&pmkidptr->pmkid[0].BSSID);
 			for (j = 0; j < WPA2_PMKID_LEN; j++)
-				WL_WSEC(("%02x ", pmkidptr->pmkid[0].PMKID[j]));
-			WL_WSEC(("\n"));
+				WL_WSEC("%02x ", pmkidptr->pmkid[0].PMKID[j]);
+			WL_WSEC("\n");
 		}
 
 		for (i = 0; i < pmkid_list.pmkids.npmkid; i++)
@@ -2711,25 +2706,25 @@ wl_iw_set_pmksa(struct net_device *dev,
 			uint j;
 			uint k;
 			k = pmkid_list.pmkids.npmkid;
-			WL_WSEC(("wl_iw_set_pmksa,IW_PMKSA_ADD - PMKID: %pM = ",
-				&pmkid_list.pmkids.pmkid[k].BSSID));
+			WL_WSEC("wl_iw_set_pmksa,IW_PMKSA_ADD - PMKID: %pM = ",
+				&pmkid_list.pmkids.pmkid[k].BSSID);
 			for (j = 0; j < WPA2_PMKID_LEN; j++)
-				WL_WSEC(("%02x ",
-					 pmkid_list.pmkids.pmkid[k].PMKID[j]));
-			WL_WSEC(("\n"));
+				WL_WSEC("%02x ",
+					pmkid_list.pmkids.pmkid[k].PMKID[j]);
+			WL_WSEC("\n");
 		}
 	}
-	WL_WSEC(("PRINTING pmkid LIST - No of elements %d\n",
-		 pmkid_list.pmkids.npmkid));
+	WL_WSEC("PRINTING pmkid LIST - No of elements %d\n",
+		pmkid_list.pmkids.npmkid);
 	for (i = 0; i < pmkid_list.pmkids.npmkid; i++) {
 		uint j;
-		WL_WSEC(("PMKID[%d]: %pM = ", i,
-			&pmkid_list.pmkids.pmkid[i].BSSID));
+		WL_WSEC("PMKID[%d]: %pM = ",
+			i, &pmkid_list.pmkids.pmkid[i].BSSID);
 		for (j = 0; j < WPA2_PMKID_LEN; j++)
-			WL_WSEC(("%02x ", pmkid_list.pmkids.pmkid[i].PMKID[j]));
-		WL_WSEC(("\n"));
+			WL_WSEC("%02x ", pmkid_list.pmkids.pmkid[i].PMKID[j]);
+		WL_WSEC("\n");
 	}
-	WL_WSEC(("\n"));
+	WL_WSEC("\n");
 
 	if (!ret)
 		ret = dev_wlc_bufvar_set(dev, "pmkid_info", (char *)&pmkid_list,
@@ -2743,7 +2738,7 @@ wl_iw_get_encodeext(struct net_device *dev,
 		    struct iw_request_info *info,
 		    struct iw_param *vwrq, char *extra)
 {
-	WL_TRACE(("%s: SIOCGIWENCODEEXT\n", dev->name));
+	WL_TRACE("%s: SIOCGIWENCODEEXT\n", dev->name);
 	return 0;
 }
 
@@ -2758,13 +2753,13 @@ wl_iw_set_wpaauth(struct net_device *dev,
 	int val = 0;
 	wl_iw_t *iw = *(wl_iw_t **) netdev_priv(dev);
 
-	WL_TRACE(("%s: SIOCSIWAUTH\n", dev->name));
+	WL_TRACE("%s: SIOCSIWAUTH\n", dev->name);
 
 	paramid = vwrq->flags & IW_AUTH_INDEX;
 	paramval = vwrq->value;
 
-	WL_TRACE(("%s: SIOCSIWAUTH, paramid = 0x%0x, paramval = 0x%0x\n",
-		  dev->name, paramid, paramval));
+	WL_TRACE("%s: SIOCSIWAUTH, paramid = 0x%0x, paramval = 0x%0x\n",
+		 dev->name, paramid, paramval);
 
 	switch (paramid) {
 	case IW_AUTH_WPA_VERSION:
@@ -2774,8 +2769,8 @@ wl_iw_set_wpaauth(struct net_device *dev,
 			val = WPA_AUTH_PSK | WPA_AUTH_UNSPECIFIED;
 		else if (paramval & IW_AUTH_WPA_VERSION_WPA2)
 			val = WPA2_AUTH_PSK | WPA2_AUTH_UNSPECIFIED;
-		WL_INFORM(("%s: %d: setting wpa_auth to 0x%0x\n", __func__,
-			   __LINE__, val));
+		WL_INFORM("%s: %d: setting wpa_auth to 0x%0x\n",
+			  __func__, __LINE__, val);
 		error = dev_wlc_intvar_set(dev, "wpa_auth", val);
 		if (error)
 			return error;
@@ -2798,20 +2793,19 @@ wl_iw_set_wpaauth(struct net_device *dev,
 		}
 
 		if (iw->privacy_invoked && !val) {
-			WL_WSEC(("%s: %s: 'Privacy invoked' true but clearing "
-				"wsec, assuming " "we're a WPS enrollee\n",
-				dev->name, __func__));
+			WL_WSEC("%s: %s: 'Privacy invoked' true but clearing wsec, assuming we're a WPS enrollee\n",
+				dev->name, __func__);
 			error = dev_wlc_intvar_set(dev, "is_WPS_enrollee",
 							true);
 			if (error) {
-				WL_WSEC(("Failed to set is_WPS_enrollee\n"));
+				WL_WSEC("Failed to set is_WPS_enrollee\n");
 				return error;
 			}
 		} else if (val) {
 			error = dev_wlc_intvar_set(dev, "is_WPS_enrollee",
 							false);
 			if (error) {
-				WL_WSEC(("Failed to clear is_WPS_enrollee\n"));
+				WL_WSEC("Failed to clear is_WPS_enrollee\n");
 				return error;
 			}
 		}
@@ -2838,8 +2832,8 @@ wl_iw_set_wpaauth(struct net_device *dev,
 			else
 				val = WPA2_AUTH_UNSPECIFIED;
 		}
-		WL_INFORM(("%s: %d: setting wpa_auth to %d\n", __func__,
-			   __LINE__, val));
+		WL_INFORM("%s: %d: setting wpa_auth to %d\n",
+			  __func__, __LINE__, val);
 		error = dev_wlc_intvar_set(dev, "wpa_auth", val);
 		if (error)
 			return error;
@@ -2851,7 +2845,7 @@ wl_iw_set_wpaauth(struct net_device *dev,
 		break;
 
 	case IW_AUTH_80211_AUTH_ALG:
-		WL_INFORM(("Setting the D11auth %d\n", paramval));
+		WL_INFORM("Setting the D11auth %d\n", paramval);
 		if (paramval == IW_AUTH_ALG_OPEN_SYSTEM)
 			val = 0;
 		else if (paramval == IW_AUTH_ALG_SHARED_KEY)
@@ -2880,8 +2874,8 @@ wl_iw_set_wpaauth(struct net_device *dev,
 				dev_wlc_intvar_set(dev, "wsec", val);
 			}
 			val = 0;
-			WL_INFORM(("%s: %d: setting wpa_auth to %d\n",
-				   __func__, __LINE__, val));
+			WL_INFORM("%s: %d: setting wpa_auth to %d\n",
+				  __func__, __LINE__, val);
 			dev_wlc_intvar_set(dev, "wpa_auth", 0);
 			return error;
 		}
@@ -2898,7 +2892,7 @@ wl_iw_set_wpaauth(struct net_device *dev,
 
 #if WIRELESS_EXT > 17
 	case IW_AUTH_ROAMING_CONTROL:
-		WL_INFORM(("%s: IW_AUTH_ROAMING_CONTROL\n", __func__));
+		WL_INFORM("%s: IW_AUTH_ROAMING_CONTROL\n", __func__);
 		break;
 	case IW_AUTH_PRIVACY_INVOKED:
 		{
@@ -2909,8 +2903,7 @@ wl_iw_set_wpaauth(struct net_device *dev,
 				error = dev_wlc_intvar_set(dev,
 						"is_WPS_enrollee", false);
 				if (error) {
-					WL_WSEC(("Failed to clear iovar "
-						"is_WPS_enrollee\n"));
+					WL_WSEC("Failed to clear iovar is_WPS_enrollee\n");
 					return error;
 				}
 			} else {
@@ -2924,8 +2917,7 @@ wl_iw_set_wpaauth(struct net_device *dev,
 							"is_WPS_enrollee",
 							true);
 					if (error) {
-						WL_WSEC(("Failed to set iovar "
-						"is_WPS_enrollee\n"));
+						WL_WSEC("Failed to set iovar is_WPS_enrollee\n");
 						return error;
 					}
 				} else {
@@ -2933,8 +2925,7 @@ wl_iw_set_wpaauth(struct net_device *dev,
 							"is_WPS_enrollee",
 							false);
 					if (error) {
-						WL_WSEC(("Failed to clear "
-							"is_WPS_enrollee\n"));
+						WL_WSEC("Failed to clear is_WPS_enrollee\n");
 						return error;
 					}
 				}
@@ -2961,7 +2952,7 @@ wl_iw_get_wpaauth(struct net_device *dev,
 	int val;
 	wl_iw_t *iw = *(wl_iw_t **) netdev_priv(dev);
 
-	WL_TRACE(("%s: SIOCGIWAUTH\n", dev->name));
+	WL_TRACE("%s: SIOCGIWAUTH\n", dev->name);
 
 	paramid = vwrq->flags & IW_AUTH_INDEX;
 
@@ -3041,7 +3032,7 @@ wl_iw_get_wpaauth(struct net_device *dev,
 		break;
 #if WIRELESS_EXT > 17
 	case IW_AUTH_ROAMING_CONTROL:
-		WL_ERROR(("%s: IW_AUTH_ROAMING_CONTROL\n", __func__));
+		WL_ERROR("%s: IW_AUTH_ROAMING_CONTROL\n", __func__);
 		break;
 	case IW_AUTH_PRIVACY_INVOKED:
 		paramval = iw->privacy_invoked;
@@ -3158,19 +3149,19 @@ int wl_iw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	char *extra = NULL;
 	int token_size = 1, max_tokens = 0, ret = 0;
 
-	WL_TRACE(("\n%s, cmd:%x alled via dhd->do_ioctl()entry point\n",
-		  __func__, cmd));
+	WL_TRACE("\n%s, cmd:%x alled via dhd->do_ioctl()entry point\n",
+		 __func__, cmd);
 	if (cmd < SIOCIWFIRST ||
 		IW_IOCTL_IDX(cmd) >= ARRAY_SIZE(wl_iw_handler)) {
-		WL_ERROR(("%s: error in cmd=%x : out of range\n", __func__,
-			cmd));
+		WL_ERROR("%s: error in cmd=%x : out of range\n",
+			 __func__, cmd);
 		return -EOPNOTSUPP;
 	}
 
 	handler = wl_iw_handler[IW_IOCTL_IDX(cmd)];
 	if (!handler) {
-		WL_ERROR(("%s: error in cmd=%x : not supported\n",
-			__func__, cmd));
+		WL_ERROR("%s: error in cmd=%x : not supported\n",
+			 __func__, cmd);
 		return -EOPNOTSUPP;
 	}
 
@@ -3235,9 +3226,8 @@ int wl_iw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 	if (max_tokens && wrq->u.data.pointer) {
 		if (wrq->u.data.length > max_tokens) {
-			WL_ERROR(("%s: error in cmd=%x wrq->u.data.length=%d "
-			"> max_tokens=%d\n",
-			__func__, cmd, wrq->u.data.length, max_tokens));
+			WL_ERROR("%s: error in cmd=%x wrq->u.data.length=%d > max_tokens=%d\n",
+				 __func__, cmd, wrq->u.data.length, max_tokens);
 			return -E2BIG;
 		}
 		extra = kmalloc(max_tokens * token_size, GFP_KERNEL);
@@ -3340,7 +3330,7 @@ wl_iw_conn_status_str(u32 event_type, u32 status, u32 reason,
 		memset(stringBuf, 0, buflen);
 		snprintf(stringBuf, buflen, "%s %s %02d %02d",
 			 name, cause, status, reason);
-		WL_INFORM(("Connection status: %s\n", stringBuf));
+		WL_INFORM("Connection status: %s\n", stringBuf);
 		return true;
 	} else {
 		return false;
@@ -3384,13 +3374,13 @@ void wl_iw_event(struct net_device *dev, wl_event_msg_t *e, void *data)
 	iw = 0;
 
 	if (!dev) {
-		WL_ERROR(("%s: dev is null\n", __func__));
+		WL_ERROR("%s: dev is null\n", __func__);
 		return;
 	}
 
 	iw = *(wl_iw_t **) netdev_priv(dev);
 
-	WL_TRACE(("%s: dev=%s event=%d\n", __func__, dev->name, event_type));
+	WL_TRACE("%s: dev=%s event=%d\n", __func__, dev->name, event_type);
 
 	switch (event_type) {
 	case WLC_E_TXFAIL:
@@ -3423,7 +3413,7 @@ void wl_iw_event(struct net_device *dev, wl_event_msg_t *e, void *data)
 					  20 * HZ);
 		} else {
 			memcpy(wrqu.addr.sa_data, &e->addr, ETH_ALEN);
-			WL_TRACE(("Link UP\n"));
+			WL_TRACE("Link UP\n");
 
 		}
 		wrqu.addr.sa_family = ARPHRD_ETHER;
@@ -3434,8 +3424,8 @@ void wl_iw_event(struct net_device *dev, wl_event_msg_t *e, void *data)
 			wrqu.data.length = datalen + 1;
 			extra[0] = WLC_E_ACTION_FRAME;
 			memcpy(&extra[1], data, datalen);
-			WL_TRACE(("WLC_E_ACTION_FRAME len %d \n",
-				  wrqu.data.length));
+			WL_TRACE("WLC_E_ACTION_FRAME len %d\n",
+				 wrqu.data.length);
 		}
 		break;
 
@@ -3516,13 +3506,13 @@ void wl_iw_event(struct net_device *dev, wl_event_msg_t *e, void *data)
 		} else {
 			cmd = SIOCGIWSCAN;
 			wrqu.data.length = strlen(extra);
-			WL_TRACE(("Event WLC_E_SCAN_COMPLETE from specific "
-				"scan %d\n", g_iscan->iscan_state));
+			WL_TRACE("Event WLC_E_SCAN_COMPLETE from specific scan %d\n",
+				 g_iscan->iscan_state);
 		}
 #else
 		cmd = SIOCGIWSCAN;
 		wrqu.data.length = strlen(extra);
-		WL_TRACE(("Event WLC_E_SCAN_COMPLETE\n"));
+		WL_TRACE("Event WLC_E_SCAN_COMPLETE\n");
 #endif
 		break;
 
@@ -3530,9 +3520,9 @@ void wl_iw_event(struct net_device *dev, wl_event_msg_t *e, void *data)
 		{
 			wlc_ssid_t *ssid;
 			ssid = (wlc_ssid_t *) data;
-			WL_ERROR(("%s Event WLC_E_PFN_NET_FOUND, send %s up : "
-				"find %s len=%d\n", __func__, PNO_EVENT_UP,
-				ssid->SSID, ssid->SSID_len));
+			WL_ERROR("%s Event WLC_E_PFN_NET_FOUND, send %s up : find %s len=%d\n",
+				 __func__, PNO_EVENT_UP,
+				 ssid->SSID, ssid->SSID_len);
 			WAKE_LOCK_TIMEOUT(iw->pub, WAKE_LOCK_PNO_FIND_TMOUT,
 					  20 * HZ);
 			cmd = IWEVCUSTOM;
@@ -3543,7 +3533,7 @@ void wl_iw_event(struct net_device *dev, wl_event_msg_t *e, void *data)
 		break;
 
 	default:
-		WL_TRACE(("Unknown Event %d: ignoring\n", event_type));
+		WL_TRACE("Unknown Event %d: ignoring\n", event_type);
 		break;
 	}
 #ifndef SANDGATE2G
@@ -3584,7 +3574,7 @@ wl_iw_get_wireless_stats(struct net_device *dev, struct iw_statistics *wstats)
 		goto done;
 
 	phy_noise = dtoh32(phy_noise);
-	WL_TRACE(("wl_iw_get_wireless_stats phy noise=%d\n", phy_noise));
+	WL_TRACE("wl_iw_get_wireless_stats phy noise=%d\n", phy_noise);
 
 	memset(&scb_val, 0, sizeof(scb_val_t));
 	res = dev_wlc_ioctl(dev, WLC_GET_RSSI, &scb_val, sizeof(scb_val_t));
@@ -3592,7 +3582,7 @@ wl_iw_get_wireless_stats(struct net_device *dev, struct iw_statistics *wstats)
 		goto done;
 
 	rssi = dtoh32(scb_val.val);
-	WL_TRACE(("wl_iw_get_wireless_stats rssi=%d\n", rssi));
+	WL_TRACE("wl_iw_get_wireless_stats rssi=%d\n", rssi);
 	if (rssi <= WL_IW_RSSI_NO_SIGNAL)
 		wstats->qual.qual = 0;
 	else if (rssi <= WL_IW_RSSI_VERY_LOW)
@@ -3615,23 +3605,21 @@ wl_iw_get_wireless_stats(struct net_device *dev, struct iw_statistics *wstats)
 #endif
 
 #if WIRELESS_EXT > 11
-	WL_TRACE(("wl_iw_get_wireless_stats counters=%d\n",
-		  (int)sizeof(wl_cnt_t)));
+	WL_TRACE("wl_iw_get_wireless_stats counters=%zu\n", sizeof(wl_cnt_t));
 
 	memset(&cnt, 0, sizeof(wl_cnt_t));
 	res =
 	    dev_wlc_bufvar_get(dev, "counters", (char *)&cnt, sizeof(wl_cnt_t));
 	if (res) {
-		WL_ERROR(("wl_iw_get_wireless_stats counters failed error=%d\n",
-			  res));
+		WL_ERROR("wl_iw_get_wireless_stats counters failed error=%d\n",
+			 res);
 		goto done;
 	}
 
 	cnt.version = dtoh16(cnt.version);
 	if (cnt.version != WL_CNT_T_VERSION) {
-		WL_TRACE(("\tIncorrect version of counters struct: expected "
-			"%d; got %d\n",
-			WL_CNT_T_VERSION, cnt.version));
+		WL_TRACE("\tIncorrect version of counters struct: expected %d; got %d\n",
+			 WL_CNT_T_VERSION, cnt.version);
 		goto done;
 	}
 
@@ -3642,22 +3630,22 @@ wl_iw_get_wireless_stats(struct net_device *dev, struct iw_statistics *wstats)
 	wstats->discard.misc = dtoh32(cnt.rxrunt) + dtoh32(cnt.rxgiant);
 	wstats->miss.beacon = 0;
 
-	WL_TRACE(("wl_iw_get_wireless_stats counters txframe=%d txbyte=%d\n",
-		  dtoh32(cnt.txframe), dtoh32(cnt.txbyte)));
-	WL_TRACE(("wl_iw_get_wireless_stats counters rxfrmtoolong=%d\n",
-		  dtoh32(cnt.rxfrmtoolong)));
-	WL_TRACE(("wl_iw_get_wireless_stats counters rxbadplcp=%d\n",
-		  dtoh32(cnt.rxbadplcp)));
-	WL_TRACE(("wl_iw_get_wireless_stats counters rxundec=%d\n",
-		  dtoh32(cnt.rxundec)));
-	WL_TRACE(("wl_iw_get_wireless_stats counters rxfragerr=%d\n",
-		  dtoh32(cnt.rxfragerr)));
-	WL_TRACE(("wl_iw_get_wireless_stats counters txfail=%d\n",
-		  dtoh32(cnt.txfail)));
-	WL_TRACE(("wl_iw_get_wireless_stats counters rxrunt=%d\n",
-		  dtoh32(cnt.rxrunt)));
-	WL_TRACE(("wl_iw_get_wireless_stats counters rxgiant=%d\n",
-		  dtoh32(cnt.rxgiant)));
+	WL_TRACE("wl_iw_get_wireless_stats counters txframe=%d txbyte=%d\n",
+		 dtoh32(cnt.txframe), dtoh32(cnt.txbyte));
+	WL_TRACE("wl_iw_get_wireless_stats counters rxfrmtoolong=%d\n",
+		  dtoh32(cnt.rxfrmtoolong));
+	WL_TRACE("wl_iw_get_wireless_stats counters rxbadplcp=%d\n",
+		  dtoh32(cnt.rxbadplcp));
+	WL_TRACE("wl_iw_get_wireless_stats counters rxundec=%d\n",
+		  dtoh32(cnt.rxundec));
+	WL_TRACE("wl_iw_get_wireless_stats counters rxfragerr=%d\n",
+		  dtoh32(cnt.rxfragerr));
+	WL_TRACE("wl_iw_get_wireless_stats counters txfail=%d\n",
+		  dtoh32(cnt.txfail));
+	WL_TRACE("wl_iw_get_wireless_stats counters rxrunt=%d\n",
+		  dtoh32(cnt.rxrunt));
+	WL_TRACE("wl_iw_get_wireless_stats counters rxgiant=%d\n",
+		  dtoh32(cnt.rxgiant));
 #endif				/* WIRELESS_EXT > 11 */
 
 done:
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.h b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
index edbf61f..c8637c5 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
@@ -78,7 +78,7 @@ typedef struct wl_iw_extra_params {
 
 #define CHECK_EXTRA_FOR_NULL(extra) \
 if (!extra) { \
-	WL_ERROR(("%s: error : extra is null pointer\n", __func__)); \
+	WL_ERROR("%s: error : extra is null pointer\n", __func__);	\
 	return -EINVAL; \
 }
 
diff --git a/drivers/staging/brcm80211/sys/wl_dbg.h b/drivers/staging/brcm80211/sys/wl_dbg.h
index e63b27e..54af257 100644
--- a/drivers/staging/brcm80211/sys/wl_dbg.h
+++ b/drivers/staging/brcm80211/sys/wl_dbg.h
@@ -20,15 +20,20 @@
 /* wl_msg_level is a bit vector with defs in wlioctl.h */
 extern u32 wl_msg_level;
 
-#define WL_PRINT(args)		printf args
-#define WL_NONE(args)
+#define WL_NONE(fmt, args...) no_printk(fmt, ##args)
+
+#define WL_PRINT(level, fmt, args...)		\
+do {						\
+	if (wl_msg_level & level)		\
+		printk(fmt, ##args);		\
+} while (0)
 
 #ifdef BCMDBG
 
-#define	WL_ERROR(args)		do {if ((wl_msg_level & WL_ERROR_VAL)) WL_PRINT(args); } while (0)
-#define	WL_TRACE(args)		do {if (wl_msg_level & WL_TRACE_VAL) WL_PRINT(args); } while (0)
-#define WL_AMPDU(args)		do {if (wl_msg_level & WL_AMPDU_VAL) WL_PRINT(args); } while (0)
-#define WL_FFPLD(args)		do {if (wl_msg_level & WL_FFPLD_VAL) WL_PRINT(args); } while (0)
+#define	WL_ERROR(fmt, args...)	WL_PRINT(WL_ERROR_VAL, fmt, ##args)
+#define	WL_TRACE(fmt, args...)	WL_PRINT(WL_TRACE_VAL, fmt, ##args)
+#define WL_AMPDU(fmt, args...)	WL_PRINT(WL_AMPDU_VAL, fmt, ##args)
+#define WL_FFPLD(fmt, args...)	WL_PRINT(WL_FFPLD_VAL, fmt, ##args)
 
 #define WL_ERROR_ON()		(wl_msg_level & WL_ERROR_VAL)
 
@@ -44,35 +49,50 @@ extern u32 wl_msg_level;
 
 extern u32 wl_ampdu_dbg;
 
-#define WL_AMPDU_UPDN(args) do {if (wl_ampdu_dbg & WL_AMPDU_UPDN_VAL) {WL_AMPDU(args); } } while (0)
-#define WL_AMPDU_RX(args) do {if (wl_ampdu_dbg & WL_AMPDU_RX_VAL) {WL_AMPDU(args); } } while (0)
-#define WL_AMPDU_ERR(args) do {if (wl_ampdu_dbg & WL_AMPDU_ERR_VAL) {WL_AMPDU(args); } } while (0)
-#define WL_AMPDU_TX(args) do {if (wl_ampdu_dbg & WL_AMPDU_TX_VAL) {WL_AMPDU(args); } } while (0)
-#define WL_AMPDU_CTL(args) do {if (wl_ampdu_dbg & WL_AMPDU_CTL_VAL) {WL_AMPDU(args); } } while (0)
-#define WL_AMPDU_HW(args) do {if (wl_ampdu_dbg & WL_AMPDU_HW_VAL) {WL_AMPDU(args); } } while (0)
-#define WL_AMPDU_HWTXS(args) do {if (wl_ampdu_dbg & WL_AMPDU_HWTXS_VAL) {WL_AMPDU(args); } } while (0)
-#define WL_AMPDU_HWDBG(args) do {if (wl_ampdu_dbg & WL_AMPDU_HWDBG_VAL) {WL_AMPDU(args); } } while (0)
+#define WL_AMPDU_PRINT(level, fmt, args...)	\
+do {						\
+	if (wl_ampdu_dbg & level) {		\
+		WL_AMPDU(fmt, ##args);		\
+	}					\
+} while (0)
+
+#define WL_AMPDU_UPDN(fmt, args...)			\
+	WL_AMPDU_PRINT(WL_AMPDU_UPDN_VAL, fmt, ##args)
+#define WL_AMPDU_RX(fmt, args...)			\
+	WL_AMPDU_PRINT(WL_AMPDU_RX_VAL, fmt, ##args)
+#define WL_AMPDU_ERR(fmt, args...)			\
+	WL_AMPDU_PRINT(WL_AMPDU_ERR_VAL, fmt, ##args)
+#define WL_AMPDU_TX(fmt, args...)			\
+	WL_AMPDU_PRINT(WL_AMPDU_TX_VAL, fmt, ##args)
+#define WL_AMPDU_CTL(fmt, args...)			\
+	WL_AMPDU_PRINT(WL_AMPDU_CTL_VAL, fmt, ##args)
+#define WL_AMPDU_HW(fmt, args...)			\
+	WL_AMPDU_PRINT(WL_AMPDU_HW_VAL, fmt, ##args)
+#define WL_AMPDU_HWTXS(fmt, args...)			\
+	WL_AMPDU_PRINT(WL_AMPDU_HWTXS_VAL, fmt, ##args)
+#define WL_AMPDU_HWDBG(fmt, args...)			\
+	WL_AMPDU_PRINT(WL_AMPDU_HWDBG_VAL, fmt, ##args)
 #define WL_AMPDU_ERR_ON() (wl_ampdu_dbg & WL_AMPDU_ERR_VAL)
 #define WL_AMPDU_HW_ON() (wl_ampdu_dbg & WL_AMPDU_HW_VAL)
 #define WL_AMPDU_HWTXS_ON() (wl_ampdu_dbg & WL_AMPDU_HWTXS_VAL)
 
 #else				/* BCMDBG */
 
-#define	WL_ERROR(args)
-#define	WL_TRACE(args)
-#define WL_AMPDU(args)
-#define WL_FFPLD(args)
+#define	WL_ERROR(fmt, args...)		no_printk(fmt, ##args)
+#define	WL_TRACE(fmt, args...)		no_printk(fmt, ##args)
+#define WL_AMPDU(fmt, args...)		no_printk(fmt, ##args)
+#define WL_FFPLD(fmt, args...)		no_printk(fmt, ##args)
 
 #define WL_ERROR_ON()		0
 
-#define WL_AMPDU_UPDN(args)
-#define WL_AMPDU_RX(args)
-#define WL_AMPDU_ERR(args)
-#define WL_AMPDU_TX(args)
-#define WL_AMPDU_CTL(args)
-#define WL_AMPDU_HW(args)
-#define WL_AMPDU_HWTXS(args)
-#define WL_AMPDU_HWDBG(args)
+#define WL_AMPDU_UPDN(fmt, args...)	no_printk(fmt, ##args)
+#define WL_AMPDU_RX(fmt, args...)	no_printk(fmt, ##args)
+#define WL_AMPDU_ERR(fmt, args...)	no_printk(fmt, ##args)
+#define WL_AMPDU_TX(fmt, args...)	no_printk(fmt, ##args)
+#define WL_AMPDU_CTL(fmt, args...)	no_printk(fmt, ##args)
+#define WL_AMPDU_HW(fmt, args...)	no_printk(fmt, ##args)
+#define WL_AMPDU_HWTXS(fmt, args...)	no_printk(fmt, ##args)
+#define WL_AMPDU_HWDBG(fmt, args...)	no_printk(fmt, ##args)
 #define WL_AMPDU_ERR_ON()       0
 #define WL_AMPDU_HW_ON()        0
 #define WL_AMPDU_HWTXS_ON()     0
diff --git a/drivers/staging/brcm80211/sys/wl_mac80211.c b/drivers/staging/brcm80211/sys/wl_mac80211.c
index 4ae9974..bdd629d 100644
--- a/drivers/staging/brcm80211/sys/wl_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wl_mac80211.c
@@ -179,7 +179,7 @@ static int wl_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct wl_info *wl = hw->priv;
 	WL_LOCK(wl);
 	if (!wl->pub->up) {
-		WL_ERROR(("ops->tx called while down\n"));
+		WL_ERROR("ops->tx called while down\n");
 		status = -ENETDOWN;
 		goto done;
 	}
@@ -192,8 +192,10 @@ static int wl_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 static int wl_ops_start(struct ieee80211_hw *hw)
 {
 	struct wl_info *wl = hw->priv;
-	/* struct ieee80211_channel *curchan = hw->conf.channel; */
-	WL_NONE(("%s : Initial channel: %d\n", __func__, curchan->hw_value));
+	/*
+	  struct ieee80211_channel *curchan = hw->conf.channel;
+	  WL_NONE("%s : Initial channel: %d\n", __func__, curchan->hw_value);
+	*/
 
 	WL_LOCK(wl);
 	ieee80211_wake_queues(hw);
@@ -226,8 +228,8 @@ wl_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	    vif->type != NL80211_IFTYPE_STATION &&
 	    vif->type != NL80211_IFTYPE_WDS &&
 	    vif->type != NL80211_IFTYPE_ADHOC) {
-		WL_ERROR(("%s: Attempt to add type %d, only STA for now\n",
-			  __func__, vif->type));
+		WL_ERROR("%s: Attempt to add type %d, only STA for now\n",
+			 __func__, vif->type);
 		return -EOPNOTSUPP;
 	}
 
@@ -237,7 +239,7 @@ wl_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	WL_UNLOCK(wl);
 
 	if (err != 0)
-		WL_ERROR(("%s: wl_up() returned %d\n", __func__, err));
+		WL_ERROR("%s: wl_up() returned %d\n", __func__, err);
 	return err;
 }
 
@@ -263,8 +265,7 @@ ieee_set_channel(struct ieee80211_hw *hw, struct ieee80211_channel *chan,
 		break;
 	case NL80211_CHAN_HT40MINUS:
 	case NL80211_CHAN_HT40PLUS:
-		WL_ERROR(("%s: Need to implement 40 Mhz Channels!\n",
-			  __func__));
+		WL_ERROR("%s: Need to implement 40 Mhz Channels!\n", __func__);
 		break;
 	}
 
@@ -281,12 +282,12 @@ static int wl_ops_config(struct ieee80211_hw *hw, u32 changed)
 	int new_int;
 
 	if (changed & IEEE80211_CONF_CHANGE_LISTEN_INTERVAL) {
-		WL_NONE(("%s: Setting listen interval to %d\n",
-			 __func__, conf->listen_interval));
+		WL_NONE("%s: Setting listen interval to %d\n",
+			__func__, conf->listen_interval);
 		if (wlc_iovar_setint
 		    (wl->wlc, "bcn_li_bcn", conf->listen_interval)) {
-			WL_ERROR(("%s: Error setting listen_interval\n",
-				  __func__));
+			WL_ERROR("%s: Error setting listen_interval\n",
+				 __func__);
 			err = -EIO;
 			goto config_out;
 		}
@@ -294,41 +295,42 @@ static int wl_ops_config(struct ieee80211_hw *hw, u32 changed)
 		ASSERT(new_int == conf->listen_interval);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR)
-		WL_NONE(("Need to set monitor mode\n"));
+		WL_NONE("Need to set monitor mode\n");
 	if (changed & IEEE80211_CONF_CHANGE_PS)
-		WL_NONE(("Need to set Power-save mode\n"));
+		WL_NONE("Need to set Power-save mode\n");
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		WL_NONE(("%s: Setting tx power to %d dbm\n", __func__,
-			 conf->power_level));
+		WL_NONE("%s: Setting tx power to %d dbm\n",
+			__func__, conf->power_level);
 		if (wlc_iovar_setint
 		    (wl->wlc, "qtxpower", conf->power_level * 4)) {
-			WL_ERROR(("%s: Error setting power_level\n", __func__));
+			WL_ERROR("%s: Error setting power_level\n", __func__);
 			err = -EIO;
 			goto config_out;
 		}
 		wlc_iovar_getint(wl->wlc, "qtxpower", &new_int);
 		if (new_int != (conf->power_level * 4))
-			WL_ERROR(("%s: Power level req != actual, %d %d\n",
-				  __func__, conf->power_level * 4, new_int));
+			WL_ERROR("%s: Power level req != actual, %d %d\n",
+				 __func__, conf->power_level * 4, new_int);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		err = ieee_set_channel(hw, conf->channel, conf->channel_type);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
-		WL_NONE(("%s: srl %d, lrl %d\n", __func__,
-			 conf->short_frame_max_tx_count,
-			 conf->long_frame_max_tx_count));
+		WL_NONE("%s: srl %d, lrl %d\n",
+			__func__,
+			conf->short_frame_max_tx_count,
+			conf->long_frame_max_tx_count);
 		if (wlc_set
 		    (wl->wlc, WLC_SET_SRL,
 		     conf->short_frame_max_tx_count) < 0) {
-			WL_ERROR(("%s: Error setting srl\n", __func__));
+			WL_ERROR("%s: Error setting srl\n", __func__);
 			err = -EIO;
 			goto config_out;
 		}
 		if (wlc_set(wl->wlc, WLC_SET_LRL, conf->long_frame_max_tx_count)
 		    < 0) {
-			WL_ERROR(("%s: Error setting lrl\n", __func__));
+			WL_ERROR("%s: Error setting lrl\n", __func__);
 			err = -EIO;
 			goto config_out;
 		}
@@ -348,24 +350,24 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 
 
 	if (changed & BSS_CHANGED_ASSOC) {
-		WL_ERROR(("Associated:\t%s\n", info->assoc ? "True" : "False"));
+		WL_ERROR("Associated:\t%s\n", info->assoc ? "True" : "False");
 		/* association status changed (associated/disassociated)
 		 * also implies a change in the AID.
 		 */
 	}
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
-		WL_NONE(("Use_cts_prot:\t%s Implement me\n",
-			 info->use_cts_prot ? "True" : "False"));
+		WL_NONE("Use_cts_prot:\t%s Implement me\n",
+			info->use_cts_prot ? "True" : "False");
 		/* CTS protection changed */
 	}
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
-		WL_NONE(("Short preamble:\t%s Implement me\n",
-			 info->use_short_preamble ? "True" : "False"));
+		WL_NONE("Short preamble:\t%s Implement me\n",
+			info->use_short_preamble ? "True" : "False");
 		/* preamble changed */
 	}
 	if (changed & BSS_CHANGED_ERP_SLOT) {
-		WL_NONE(("Changing short slot:\t%s\n",
-			 info->use_short_slot ? "True" : "False"));
+		WL_NONE("Changing short slot:\t%s\n",
+			info->use_short_slot ? "True" : "False");
 		if (info->use_short_slot)
 			val = 1;
 		else
@@ -375,34 +377,34 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_HT) {
-		WL_NONE(("%s: HT mode - Implement me\n", __func__));
+		WL_NONE("%s: HT mode - Implement me\n", __func__);
 		/* 802.11n parameters changed */
 	}
 	if (changed & BSS_CHANGED_BASIC_RATES) {
-		WL_NONE(("Need to change Basic Rates:\t0x%x! Implement me\n",
-			 (u32) info->basic_rates));
+		WL_NONE("Need to change Basic Rates:\t0x%x! Implement me\n",
+			(u32) info->basic_rates);
 		/* Basic rateset changed */
 	}
 	if (changed & BSS_CHANGED_BEACON_INT) {
-		WL_NONE(("Beacon Interval:\t%d Implement me\n",
-			 info->beacon_int));
+		WL_NONE("Beacon Interval:\t%d Implement me\n",
+			info->beacon_int);
 		/* Beacon interval changed */
 	}
 	if (changed & BSS_CHANGED_BSSID) {
-		WL_NONE(("new BSSID:\taid %d  bss:%pM\n", info->aid,
-			info->bssid));
+		WL_NONE("new BSSID:\taid %d  bss:%pM\n",
+			info->aid, info->bssid);
 		/* BSSID changed, for whatever reason (IBSS and managed mode) */
 		/* FIXME: need to store bssid in bsscfg */
 		wlc_set_addrmatch(wl->wlc, RCM_BSSID_OFFSET,
 				  (struct ether_addr *)info->bssid);
 	}
 	if (changed & BSS_CHANGED_BEACON) {
-		WL_ERROR(("BSS_CHANGED_BEACON\n"));
+		WL_ERROR("BSS_CHANGED_BEACON\n");
 		/* Beacon data changed, retrieve new beacon (beaconing modes) */
 	}
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		WL_ERROR(("Beacon enabled:\t%s\n",
-			  info->enable_beacon ? "True" : "False"));
+		WL_ERROR("Beacon enabled:\t%s\n",
+			 info->enable_beacon ? "True" : "False");
 		/* Beaconing should be enabled/disabled (beaconing modes) */
 	}
 	return;
@@ -418,19 +420,19 @@ wl_ops_configure_filter(struct ieee80211_hw *hw,
 	changed_flags &= MAC_FILTERS;
 	*total_flags &= MAC_FILTERS;
 	if (changed_flags & FIF_PROMISC_IN_BSS)
-		WL_ERROR(("FIF_PROMISC_IN_BSS\n"));
+		WL_ERROR("FIF_PROMISC_IN_BSS\n");
 	if (changed_flags & FIF_ALLMULTI)
-		WL_ERROR(("FIF_ALLMULTI\n"));
+		WL_ERROR("FIF_ALLMULTI\n");
 	if (changed_flags & FIF_FCSFAIL)
-		WL_ERROR(("FIF_FCSFAIL\n"));
+		WL_ERROR("FIF_FCSFAIL\n");
 	if (changed_flags & FIF_PLCPFAIL)
-		WL_ERROR(("FIF_PLCPFAIL\n"));
+		WL_ERROR("FIF_PLCPFAIL\n");
 	if (changed_flags & FIF_CONTROL)
-		WL_ERROR(("FIF_CONTROL\n"));
+		WL_ERROR("FIF_CONTROL\n");
 	if (changed_flags & FIF_OTHER_BSS)
-		WL_ERROR(("FIF_OTHER_BSS\n"));
+		WL_ERROR("FIF_OTHER_BSS\n");
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		WL_NONE(("FIF_BCN_PRBRESP_PROMISC\n"));
+		WL_NONE("FIF_BCN_PRBRESP_PROMISC\n");
 		WL_LOCK(wl);
 		if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
 			wl->pub->mac80211_state |= MAC80211_PROMISC_BCNS;
@@ -447,25 +449,25 @@ wl_ops_configure_filter(struct ieee80211_hw *hw,
 static int
 wl_ops_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta, bool set)
 {
-	WL_ERROR(("%s: Enter\n", __func__));
+	WL_ERROR("%s: Enter\n", __func__);
 	return 0;
 }
 
 static void wl_ops_sw_scan_start(struct ieee80211_hw *hw)
 {
-	WL_NONE(("Scan Start\n"));
+	WL_NONE("Scan Start\n");
 	return;
 }
 
 static void wl_ops_sw_scan_complete(struct ieee80211_hw *hw)
 {
-	WL_NONE(("Scan Complete\n"));
+	WL_NONE("Scan Complete\n");
 	return;
 }
 
 static void wl_ops_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 {
-	WL_ERROR(("%s: Enter\n", __func__));
+	WL_ERROR("%s: Enter\n", __func__);
 	return;
 }
 
@@ -473,13 +475,13 @@ static int
 wl_ops_get_stats(struct ieee80211_hw *hw,
 		 struct ieee80211_low_level_stats *stats)
 {
-	WL_ERROR(("%s: Enter\n", __func__));
+	WL_ERROR("%s: Enter\n", __func__);
 	return 0;
 }
 
 static int wl_ops_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 {
-	WL_ERROR(("%s: Enter\n", __func__));
+	WL_ERROR("%s: Enter\n", __func__);
 	return 0;
 }
 
@@ -487,10 +489,10 @@ static void
 wl_ops_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		  enum sta_notify_cmd cmd, struct ieee80211_sta *sta)
 {
-	WL_NONE(("%s: Enter\n", __func__));
+	WL_NONE("%s: Enter\n", __func__);
 	switch (cmd) {
 	default:
-		WL_ERROR(("%s: Uknown cmd = %d\n", __func__, cmd));
+		WL_ERROR("%s: Unknown cmd = %d\n", __func__, cmd);
 		break;
 	}
 	return;
@@ -502,9 +504,9 @@ wl_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
 {
 	struct wl_info *wl = hw->priv;
 
-	WL_NONE(("%s: Enter (WME config)\n", __func__));
-	WL_NONE(("queue %d, txop %d, cwmin %d, cwmax %d, aifs %d\n", queue,
-		 params->txop, params->cw_min, params->cw_max, params->aifs));
+	WL_NONE("%s: Enter (WME config)\n", __func__);
+	WL_NONE("queue %d, txop %d, cwmin %d, cwmax %d, aifs %d\n", queue,
+		 params->txop, params->cw_min, params->cw_max, params->aifs);
 
 	WL_LOCK(wl);
 	wlc_wme_setparams(wl->wlc, queue, (void *)params, true);
@@ -515,7 +517,7 @@ wl_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
 
 static u64 wl_ops_get_tsf(struct ieee80211_hw *hw)
 {
-	WL_ERROR(("%s: Enter\n", __func__));
+	WL_ERROR("%s: Enter\n", __func__);
 	return 0;
 }
 
@@ -558,7 +560,7 @@ static int
 wl_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	      struct ieee80211_sta *sta)
 {
-	WL_NONE(("%s: Enter\n", __func__));
+	WL_NONE("%s: Enter\n", __func__);
 	return 0;
 }
 
@@ -576,14 +578,14 @@ wl_ampdu_action(struct ieee80211_hw *hw,
 	ASSERT(scb->magic == SCB_MAGIC);
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		WL_NONE(("%s: action = IEEE80211_AMPDU_RX_START\n", __func__));
+		WL_NONE("%s: action = IEEE80211_AMPDU_RX_START\n", __func__);
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
-		WL_NONE(("%s: action = IEEE80211_AMPDU_RX_STOP\n", __func__));
+		WL_NONE("%s: action = IEEE80211_AMPDU_RX_STOP\n", __func__);
 		break;
 	case IEEE80211_AMPDU_TX_START:
 		if (!wlc_aggregatable(wl->wlc, tid)) {
-			/* WL_ERROR(("START: tid %d is not agg' able, return FAILURE to stack\n", tid)); */
+			/* WL_ERROR("START: tid %d is not agg' able, return FAILURE to stack\n", tid); */
 			return -1;
 		}
 		/* XXX: Use the starting sequence number provided ... */
@@ -597,11 +599,11 @@ wl_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		/* Not sure what to do here */
 		/* Power save wakeup */
-		WL_NONE(("%s: action = IEEE80211_AMPDU_TX_OPERATIONAL\n",
-			 __func__));
+		WL_NONE("%s: action = IEEE80211_AMPDU_TX_OPERATIONAL\n",
+			__func__);
 		break;
 	default:
-		WL_ERROR(("%s: Invalid command, ignoring\n", __func__));
+		WL_ERROR("%s: Invalid command, ignoring\n", __func__);
 	}
 
 	return 0;
@@ -632,8 +634,8 @@ static const struct ieee80211_ops wl_ops = {
 
 static int wl_set_hint(struct wl_info *wl, char *abbrev)
 {
-	WL_ERROR(("%s: Sending country code %c%c to MAC80211\n", __func__,
-		  abbrev[0], abbrev[1]));
+	WL_ERROR("%s: Sending country code %c%c to MAC80211\n",
+		 __func__, abbrev[0], abbrev[1]);
 	return regulatory_hint(wl->pub->ieee_hw->wiphy, abbrev);
 }
 
@@ -663,7 +665,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	err = 0;
 
 	if (unit < 0) {
-		WL_ERROR(("wl%d: unit number overflow, exiting\n", unit));
+		WL_ERROR("wl%d: unit number overflow, exiting\n", unit);
 		return NULL;
 	}
 
@@ -691,13 +693,13 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 		/* Do nothing */
 	} else {
 		bustype = PCI_BUS;
-		WL_TRACE(("force to PCI\n"));
+		WL_TRACE("force to PCI\n");
 	}
 	wl->bcm_bustype = bustype;
 
 	wl->regsva = ioremap_nocache(base_addr, PCI_BAR0_WINSZ);
 	if (wl->regsva == NULL) {
-		WL_ERROR(("wl%d: ioremap() failed\n", unit));
+		WL_ERROR("wl%d: ioremap() failed\n", unit);
 		goto fail;
 	}
 	spin_lock_init(&wl->lock);
@@ -729,13 +731,12 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 
 	if (wlc_iovar_setint(wl->wlc, "mpc", 0)) {
-		WL_ERROR(("wl%d: Error setting MPC variable to 0\n",
-			  unit));
+		WL_ERROR("wl%d: Error setting MPC variable to 0\n", unit);
 	}
 
 	/* register our interrupt handler */
 	if (request_irq(irq, wl_isr, IRQF_SHARED, KBUILD_MODNAME, wl)) {
-		WL_ERROR(("wl%d: request_irq() failed\n", unit));
+		WL_ERROR("wl%d: request_irq() failed\n", unit);
 		goto fail;
 	}
 	wl->irq = irq;
@@ -745,7 +746,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 			    NULL);
 
 	if (ieee_hw_init(hw)) {
-		WL_ERROR(("wl%d: %s: ieee_hw_init failed!\n", unit, __func__));
+		WL_ERROR("wl%d: %s: ieee_hw_init failed!\n", unit, __func__);
 		goto fail;
 	}
 
@@ -755,8 +756,8 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 	err = ieee80211_register_hw(hw);
 	if (err) {
-		WL_ERROR(("%s: ieee80211_register_hw failed, status %d\n",
-			  __func__, err));
+		WL_ERROR("%s: ieee80211_register_hw failed, status %d\n",
+			 __func__, err);
 	}
 
 	if (wl->pub->srom_ccode[0])
@@ -764,11 +765,11 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	else
 		err = wl_set_hint(wl, "US");
 	if (err) {
-		WL_ERROR(("%s: regulatory_hint failed, status %d\n", __func__,
-			  err));
+		WL_ERROR("%s: regulatory_hint failed, status %d\n",
+			 __func__, err);
 	}
-	WL_ERROR(("wl%d: Broadcom BCM43xx 802.11 MAC80211 Driver "
-		  " (" PHY_VERSION_STR ")", unit));
+	WL_ERROR("wl%d: Broadcom BCM43xx 802.11 MAC80211 Driver (" PHY_VERSION_STR ")",
+		 unit);
 
 #ifdef BCMDBG
 	printf(" (Compiled at " __TIME__ " on " __DATE__ ")");
@@ -964,9 +965,9 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 	hw->wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
 
 	if (wlc_get(wl->wlc, WLC_GET_PHYLIST, (int *)&phy_list) < 0) {
-		WL_ERROR(("Phy list failed\n"));
+		WL_ERROR("Phy list failed\n");
 	}
-	WL_NONE(("%s: phylist = %c\n", __func__, phy_list[0]));
+	WL_NONE("%s: phylist = %c\n", __func__, phy_list[0]);
 
 	if (phy_list[0] == 'n' || phy_list[0] == 'c') {
 		if (phy_list[0] == 'c') {
@@ -991,7 +992,7 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 		}
 	}
 
-	WL_NONE(("%s: 2ghz = %d, 5ghz = %d\n", __func__, 1, has_5g));
+	WL_NONE("%s: 2ghz = %d, 5ghz = %d\n", __func__, 1, has_5g);
 
 	return 0;
 }
@@ -1039,9 +1040,9 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ASSERT(pdev);
 
-	WL_TRACE(("%s: bus %d slot %d func %d irq %d\n", __func__,
-		  pdev->bus->number, PCI_SLOT(pdev->devfn),
-		  PCI_FUNC(pdev->devfn), pdev->irq));
+	WL_TRACE("%s: bus %d slot %d func %d irq %d\n",
+		 __func__, pdev->bus->number, PCI_SLOT(pdev->devfn),
+		 PCI_FUNC(pdev->devfn), pdev->irq);
 
 	if ((pdev->vendor != PCI_VENDOR_ID_BROADCOM) ||
 	    (((pdev->device & 0xff00) != 0x4300) &&
@@ -1051,9 +1052,9 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	rc = pci_enable_device(pdev);
 	if (rc) {
-		WL_ERROR(("%s: Cannot enable device %d-%d_%d\n", __func__,
-			  pdev->bus->number, PCI_SLOT(pdev->devfn),
-			  PCI_FUNC(pdev->devfn)));
+		WL_ERROR("%s: Cannot enable device %d-%d_%d\n",
+			 __func__, pdev->bus->number, PCI_SLOT(pdev->devfn),
+			 PCI_FUNC(pdev->devfn));
 		return -ENODEV;
 	}
 	pci_set_master(pdev);
@@ -1064,7 +1065,7 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	hw = ieee80211_alloc_hw(sizeof(struct wl_info), &wl_ops);
 	if (!hw) {
-		WL_ERROR(("%s: ieee80211_alloc_hw failed\n", __func__));
+		WL_ERROR("%s: ieee80211_alloc_hw failed\n", __func__);
 		rc = -ENOMEM;
 		goto err_1;
 	}
@@ -1079,13 +1080,13 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		       PCI_BUS, pdev, pdev->irq);
 
 	if (!wl) {
-		WL_ERROR(("%s: %s: wl_attach failed!\n",
-			KBUILD_MODNAME, __func__));
+		WL_ERROR("%s: %s: wl_attach failed!\n",
+			 KBUILD_MODNAME, __func__);
 		return -ENODEV;
 	}
 	return 0;
  err_1:
-	WL_ERROR(("%s: err_1: Major hoarkage\n", __func__));
+	WL_ERROR("%s: err_1: Major hoarkage\n", __func__);
 	return 0;
 }
 
@@ -1095,12 +1096,12 @@ static int wl_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct wl_info *wl;
 	struct ieee80211_hw *hw;
 
-	WL_TRACE(("wl: wl_suspend\n"));
+	WL_TRACE("wl: wl_suspend\n");
 
 	hw = pci_get_drvdata(pdev);
 	wl = HW_TO_WL(hw);
 	if (!wl) {
-		WL_ERROR(("wl: wl_suspend: pci_get_drvdata failed\n"));
+		WL_ERROR("wl: wl_suspend: pci_get_drvdata failed\n");
 		return -ENODEV;
 	}
 
@@ -1120,11 +1121,11 @@ static int wl_resume(struct pci_dev *pdev)
 	int err = 0;
 	u32 val;
 
-	WL_TRACE(("wl: wl_resume\n"));
+	WL_TRACE("wl: wl_resume\n");
 	hw = pci_get_drvdata(pdev);
 	wl = HW_TO_WL(hw);
 	if (!wl) {
-		WL_ERROR(("wl: wl_resume: pci_get_drvdata failed\n"));
+		WL_ERROR("wl: wl_resume: pci_get_drvdata failed\n");
 		return -ENODEV;
 	}
 
@@ -1160,11 +1161,11 @@ static void wl_remove(struct pci_dev *pdev)
 	hw = pci_get_drvdata(pdev);
 	wl = HW_TO_WL(hw);
 	if (!wl) {
-		WL_ERROR(("wl: wl_remove: pci_get_drvdata failed\n"));
+		WL_ERROR("wl: wl_remove: pci_get_drvdata failed\n");
 		return;
 	}
 	if (!wlc_chipmatch(pdev->vendor, pdev->device)) {
-		WL_ERROR(("wl: wl_remove: wlc_chipmatch failed\n"));
+		WL_ERROR("wl: wl_remove: wlc_chipmatch failed\n");
 		return;
 	}
 	if (wl->wlc) {
@@ -1172,7 +1173,7 @@ static void wl_remove(struct pci_dev *pdev)
 		WL_LOCK(wl);
 		wl_down(wl);
 		WL_UNLOCK(wl);
-		WL_NONE(("%s: Down\n", __func__));
+		WL_NONE("%s: Down\n", __func__);
 	}
 	pci_disable_device(pdev);
 
@@ -1334,12 +1335,12 @@ wl_start_int(struct wl_info *wl, struct ieee80211_hw *hw, struct sk_buff *skb)
 void wl_txflowcontrol(struct wl_info *wl, struct wl_if *wlif, bool state,
 		      int prio)
 {
-	WL_ERROR(("Shouldn't be here %s\n", __func__));
+	WL_ERROR("Shouldn't be here %s\n", __func__);
 }
 
 void wl_init(struct wl_info *wl)
 {
-	WL_TRACE(("wl%d: wl_init\n", wl->pub->unit));
+	WL_TRACE("wl%d: wl_init\n", wl->pub->unit);
 
 	wl_reset(wl);
 
@@ -1348,7 +1349,7 @@ void wl_init(struct wl_info *wl)
 
 uint wl_reset(struct wl_info *wl)
 {
-	WL_TRACE(("wl%d: wl_reset\n", wl->pub->unit));
+	WL_TRACE("wl%d: wl_reset\n", wl->pub->unit);
 
 	wlc_reset(wl->wlc);
 
@@ -1494,12 +1495,12 @@ static void BCMFASTPATH wl_dpc(unsigned long data)
 
 static void wl_link_up(struct wl_info *wl, char *ifname)
 {
-	WL_ERROR(("wl%d: link up (%s)\n", wl->pub->unit, ifname));
+	WL_ERROR("wl%d: link up (%s)\n", wl->pub->unit, ifname);
 }
 
 static void wl_link_down(struct wl_info *wl, char *ifname)
 {
-	WL_ERROR(("wl%d: link down (%s)\n", wl->pub->unit, ifname));
+	WL_ERROR("wl%d: link down (%s)\n", wl->pub->unit, ifname);
 }
 
 void wl_event(struct wl_info *wl, char *ifname, wlc_event_t *e)
@@ -1551,7 +1552,7 @@ wl_timer_t *wl_init_timer(struct wl_info *wl, void (*fn) (void *arg), void *arg,
 
 	t = kmalloc(sizeof(wl_timer_t), GFP_ATOMIC);
 	if (!t) {
-		WL_ERROR(("wl%d: wl_init_timer: out of memory\n", wl->pub->unit));
+		WL_ERROR("wl%d: wl_init_timer: out of memory\n", wl->pub->unit);
 		return 0;
 	}
 
@@ -1582,8 +1583,8 @@ void wl_add_timer(struct wl_info *wl, wl_timer_t *t, uint ms, int periodic)
 {
 #ifdef BCMDBG
 	if (t->set) {
-		WL_ERROR(("%s: Already set. Name: %s, per %d\n",
-			  __func__, t->name, periodic));
+		WL_ERROR("%s: Already set. Name: %s, per %d\n",
+			 __func__, t->name, periodic);
 	}
 #endif
 	ASSERT(!t->set);
@@ -1752,7 +1753,7 @@ static int wl_request_fw(struct wl_info *wl, struct pci_dev *pdev)
 			break;
 		sprintf(fw_name, "%s-%d.fw", wl_firmwares[i],
 			UCODE_LOADER_API_VER);
-		WL_NONE(("request fw %s\n", fw_name));
+		WL_NONE("request fw %s\n", fw_name);
 		status = request_firmware(&wl->fw.fw_bin[i], fw_name, device);
 		if (status) {
 			printf("%s: fail to load firmware %s\n",
@@ -1760,7 +1761,7 @@ static int wl_request_fw(struct wl_info *wl, struct pci_dev *pdev)
 			wl_release_fw(wl);
 			return status;
 		}
-		WL_NONE(("request fw %s\n", fw_name));
+		WL_NONE("request fw %s\n", fw_name);
 		sprintf(fw_name, "%s_hdr-%d.fw", wl_firmwares[i],
 			UCODE_LOADER_API_VER);
 		status = request_firmware(&wl->fw.fw_hdr[i], fw_name, device);
@@ -1772,8 +1773,8 @@ static int wl_request_fw(struct wl_info *wl, struct pci_dev *pdev)
 		}
 		wl->fw.hdr_num_entries[i] =
 		    wl->fw.fw_hdr[i]->size / (sizeof(struct wl_fw_hdr));
-		WL_NONE(("request fw %s find: %d entries\n", fw_name,
-			 wl->fw.hdr_num_entries[i]));
+		WL_NONE("request fw %s find: %d entries\n",
+			fw_name, wl->fw.hdr_num_entries[i]);
 	}
 	wl->fw.fw_cnt = i;
 	return wl_ucode_data_init(wl);
@@ -1811,16 +1812,16 @@ int wl_check_firmwares(struct wl_info *wl)
 		if (fw == NULL && fw_hdr == NULL) {
 			break;
 		} else if (fw == NULL || fw_hdr == NULL) {
-			WL_ERROR(("%s: invalid bin/hdr fw\n", __func__));
+			WL_ERROR("%s: invalid bin/hdr fw\n", __func__);
 			rc = -EBADF;
 		} else if (fw_hdr->size % sizeof(struct wl_fw_hdr)) {
-			WL_ERROR(("%s: non integral fw hdr file size %d/%d\n",
-				  __func__, fw_hdr->size,
-				  sizeof(struct wl_fw_hdr)));
+			WL_ERROR("%s: non integral fw hdr file size %d/%zu\n",
+				 __func__, fw_hdr->size,
+				 sizeof(struct wl_fw_hdr));
 			rc = -EBADF;
 		} else if (fw->size < MIN_FW_SIZE || fw->size > MAX_FW_SIZE) {
-			WL_ERROR(("%s: out of bounds fw file size %d\n",
-				  __func__, fw->size));
+			WL_ERROR("%s: out of bounds fw file size %d\n",
+				 __func__, fw->size);
 			rc = -EBADF;
 		} else {
 			/* check if ucode section overruns firmware image */
@@ -1829,15 +1830,15 @@ int wl_check_firmwares(struct wl_info *wl)
 			     entry++, ucode_hdr++) {
 				if (ucode_hdr->offset + ucode_hdr->len >
 				    fw->size) {
-					WL_ERROR(("%s: conflicting bin/hdr\n",
-						  __func__));
+					WL_ERROR("%s: conflicting bin/hdr\n",
+						 __func__);
 					rc = -EBADF;
 				}
 			}
 		}
 	}
 	if (rc == 0 && wl->fw.fw_cnt != i) {
-		WL_ERROR(("%s: invalid fw_cnt=%d\n", __func__, wl->fw.fw_cnt));
+		WL_ERROR("%s: invalid fw_cnt=%d\n", __func__, wl->fw.fw_cnt);
 		rc = -EBADF;
 	}
 	return rc;
diff --git a/drivers/staging/brcm80211/sys/wlc_alloc.c b/drivers/staging/brcm80211/sys/wlc_alloc.c
index 9af2d17..746439e 100644
--- a/drivers/staging/brcm80211/sys/wlc_alloc.c
+++ b/drivers/staging/brcm80211/sys/wlc_alloc.c
@@ -43,7 +43,7 @@ void *wlc_calloc(struct osl_info *osh, uint unit, uint size)
 
 	item = kzalloc(size, GFP_ATOMIC);
 	if (item == NULL)
-		WL_ERROR(("wl%d: %s: out of memory\n", unit, __func__));
+		WL_ERROR("wl%d: %s: out of memory\n", unit, __func__);
 	return item;
 }
 
diff --git a/drivers/staging/brcm80211/sys/wlc_ampdu.c b/drivers/staging/brcm80211/sys/wlc_ampdu.c
index 0419c52..d749917 100644
--- a/drivers/staging/brcm80211/sys/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/sys/wlc_ampdu.c
@@ -174,7 +174,8 @@ struct ampdu_info *wlc_ampdu_attach(struct wlc_info *wlc)
 
 	ampdu = kzalloc(sizeof(struct ampdu_info), GFP_ATOMIC);
 	if (!ampdu) {
-		WL_ERROR(("wl%d: wlc_ampdu_attach: out of mem\n", wlc->pub->unit));
+		WL_ERROR("wl%d: wlc_ampdu_attach: out of mem\n",
+			 wlc->pub->unit);
 		return NULL;
 	}
 	ampdu->wlc = wlc;
@@ -244,7 +245,7 @@ void scb_ampdu_cleanup(struct ampdu_info *ampdu, struct scb *scb)
 	scb_ampdu_t *scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
 	u8 tid;
 
-	WL_AMPDU_UPDN(("scb_ampdu_cleanup: enter\n"));
+	WL_AMPDU_UPDN("scb_ampdu_cleanup: enter\n");
 	ASSERT(scb_ampdu);
 
 	for (tid = 0; tid < AMPDU_MAX_SCB_TID; tid++) {
@@ -257,7 +258,7 @@ void scb_ampdu_cleanup(struct ampdu_info *ampdu, struct scb *scb)
  */
 void wlc_ampdu_reset(struct ampdu_info *ampdu)
 {
-	WL_NONE(("%s: Entering\n", __func__));
+	WL_NONE("%s: Entering\n", __func__);
 }
 
 static void scb_ampdu_update_config(struct ampdu_info *ampdu, struct scb *scb)
@@ -338,7 +339,7 @@ static int wlc_ffpld_check_txfunfl(struct wlc_info *wlc, int fid)
 			 M_UCODE_MACSTAT + offsetof(macstat_t, txfunfl[fid]));
 	new_txunfl = (u16) (cur_txunfl - fifo->prev_txfunfl);
 	if (new_txunfl == 0) {
-		WL_FFPLD(("check_txunfl : TX status FRAG set but no tx underflows\n"));
+		WL_FFPLD("check_txunfl : TX status FRAG set but no tx underflows\n");
 		return -1;
 	}
 	fifo->prev_txfunfl = cur_txunfl;
@@ -348,7 +349,7 @@ static int wlc_ffpld_check_txfunfl(struct wlc_info *wlc, int fid)
 
 	/* check if fifo is big enough */
 	if (wlc_xmtfifo_sz_get(wlc, fid, &xmtfifo_sz)) {
-		WL_FFPLD(("check_txunfl : get xmtfifo_sz failed.\n"));
+		WL_FFPLD("check_txunfl : get xmtfifo_sz failed\n");
 		return -1;
 	}
 
@@ -362,8 +363,8 @@ static int wlc_ffpld_check_txfunfl(struct wlc_info *wlc, int fid)
 	if (fifo->accum_txfunfl < 10)
 		return 0;
 
-	WL_FFPLD(("ampdu_count %d  tx_underflows %d\n",
-		  current_ampdu_cnt, fifo->accum_txfunfl));
+	WL_FFPLD("ampdu_count %d  tx_underflows %d\n",
+		 current_ampdu_cnt, fifo->accum_txfunfl);
 
 	/*
 	   compute the current ratio of tx unfl per ampdu.
@@ -416,8 +417,8 @@ static int wlc_ffpld_check_txfunfl(struct wlc_info *wlc, int fid)
 		      (max_mpdu * FFPLD_MPDU_SIZE - fifo->ampdu_pld_size))
 		     / (max_mpdu * FFPLD_MPDU_SIZE)) * 100;
 
-		WL_FFPLD(("DMA estimated transfer rate %d; pre-load size %d\n",
-			  fifo->dmaxferrate, fifo->ampdu_pld_size));
+		WL_FFPLD("DMA estimated transfer rate %d; pre-load size %d\n",
+			 fifo->dmaxferrate, fifo->ampdu_pld_size);
 	} else {
 
 		/* decrease ampdu size */
@@ -552,7 +553,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, wlc_txq_info_t *qi,
 	wlc_ampdu_agg(ampdu, scb, p, tid);
 
 	if (wlc->block_datafifo) {
-		WL_ERROR(("%s: Fifo blocked\n", __func__));
+		WL_ERROR("%s: Fifo blocked\n", __func__);
 		return BCME_BUSY;
 	}
 	rr_retry_limit = ampdu->rr_retry_limit_tid[tid];
@@ -567,7 +568,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, wlc_txq_info_t *qi,
 		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 			err = wlc_prep_pdu(wlc, p, &fifo);
 		} else {
-			WL_ERROR(("%s: AMPDU flag is off!\n", __func__));
+			WL_ERROR("%s: AMPDU flag is off!\n", __func__);
 			*pdu = NULL;
 			err = 0;
 			break;
@@ -575,14 +576,16 @@ wlc_sendampdu(struct ampdu_info *ampdu, wlc_txq_info_t *qi,
 
 		if (err) {
 			if (err == BCME_BUSY) {
-				WL_ERROR(("wl%d: wlc_sendampdu: prep_xdu retry; seq 0x%x\n", wlc->pub->unit, seq));
+				WL_ERROR("wl%d: wlc_sendampdu: prep_xdu retry; seq 0x%x\n",
+					 wlc->pub->unit, seq);
 				WLCNTINCR(ampdu->cnt->sduretry);
 				*pdu = p;
 				break;
 			}
 
 			/* error in the packet; reject it */
-			WL_AMPDU_ERR(("wl%d: wlc_sendampdu: prep_xdu rejected; seq 0x%x\n", wlc->pub->unit, seq));
+			WL_AMPDU_ERR("wl%d: wlc_sendampdu: prep_xdu rejected; seq 0x%x\n",
+				     wlc->pub->unit, seq);
 			WLCNTINCR(ampdu->cnt->sdurejected);
 
 			*pdu = NULL;
@@ -624,8 +627,8 @@ wlc_sendampdu(struct ampdu_info *ampdu, wlc_txq_info_t *qi,
 		ndelim = txh->RTSPLCPFallback[AMPDU_FBR_NULL_DELIM];
 		seg_cnt += 1;
 
-		WL_AMPDU_TX(("wl%d: wlc_sendampdu: mpdu %d plcp_len %d\n",
-			     wlc->pub->unit, count, len));
+		WL_AMPDU_TX("wl%d: wlc_sendampdu: mpdu %d plcp_len %d\n",
+			    wlc->pub->unit, count, len);
 
 		/*
 		 * aggregateable mpdu. For ucode/hw agg,
@@ -656,7 +659,8 @@ wlc_sendampdu(struct ampdu_info *ampdu, wlc_txq_info_t *qi,
 
 		dma_len += (u16) pkttotlen(osh, p);
 
-		WL_AMPDU_TX(("wl%d: wlc_sendampdu: ampdu_len %d seg_cnt %d null delim %d\n", wlc->pub->unit, ampdu_len, seg_cnt, ndelim));
+		WL_AMPDU_TX("wl%d: wlc_sendampdu: ampdu_len %d seg_cnt %d null delim %d\n",
+			    wlc->pub->unit, ampdu_len, seg_cnt, ndelim);
 
 		txh->MacTxControlLow = htol16(mcl);
 
@@ -686,8 +690,8 @@ wlc_sendampdu(struct ampdu_info *ampdu, wlc_txq_info_t *qi,
 			    min(scb_ampdu->max_rxlen,
 				ampdu->max_txlen[mcs][is40][sgi]);
 
-			WL_NONE(("sendampdu: sgi %d, is40 %d, mcs %d\n", sgi,
-				 is40, mcs));
+			WL_NONE("sendampdu: sgi %d, is40 %d, mcs %d\n",
+				sgi, is40, mcs);
 
 			maxlen = 64 * 1024;	/* XXX Fix me to honor real max_rxlen */
 
@@ -730,13 +734,14 @@ wlc_sendampdu(struct ampdu_info *ampdu, wlc_txq_info_t *qi,
 		/* test whether to add more */
 		if ((MCS_RATE(mcs, true, false) >= f->dmaxferrate) &&
 		    (count == f->mcs2ampdu_table[mcs])) {
-			WL_AMPDU_ERR(("wl%d: PR 37644: stopping ampdu at %d for mcs %d", wlc->pub->unit, count, mcs));
+			WL_AMPDU_ERR("wl%d: PR 37644: stopping ampdu at %d for mcs %d\n",
+				     wlc->pub->unit, count, mcs);
 			break;
 		}
 
 		if (count == scb_ampdu->max_pdu) {
-			WL_NONE(("Stop taking from q, reached %d deep\n",
-				 scb_ampdu->max_pdu));
+			WL_NONE("Stop taking from q, reached %d deep\n",
+				scb_ampdu->max_pdu);
 			break;
 		}
 
@@ -754,15 +759,16 @@ wlc_sendampdu(struct ampdu_info *ampdu, wlc_txq_info_t *qi,
 
 				if ((plen + ampdu_len) > maxlen) {
 					p = NULL;
-					WL_ERROR(("%s: Bogus plen #1\n",
-						  __func__));
+					WL_ERROR("%s: Bogus plen #1\n",
+						 __func__);
 					ASSERT(3 == 4);
 					continue;
 				}
 
 				/* check if there are enough descriptors available */
 				if (TXAVAIL(wlc, fifo) <= (seg_cnt + 1)) {
-					WL_ERROR(("%s: No fifo space   !!!!!!\n", __func__));
+					WL_ERROR("%s: No fifo space   !!!!!!\n",
+						 __func__);
 					p = NULL;
 					continue;
 				}
@@ -869,13 +875,14 @@ wlc_sendampdu(struct ampdu_info *ampdu, wlc_txq_info_t *qi,
 			WLC_SET_MIMO_PLCP_AMPDU(txh->FragPLCPFallback);
 		}
 
-		WL_AMPDU_TX(("wl%d: wlc_sendampdu: count %d ampdu_len %d\n",
-			     wlc->pub->unit, count, ampdu_len));
+		WL_AMPDU_TX("wl%d: wlc_sendampdu: count %d ampdu_len %d\n",
+			    wlc->pub->unit, count, ampdu_len);
 
 		/* inform rate_sel if it this is a rate probe pkt */
 		frameid = ltoh16(txh->TxFrameID);
 		if (frameid & TXFID_RATE_PROBE_MASK) {
-			WL_ERROR(("%s: XXX what to do with TXFID_RATE_PROBE_MASK!?\n", __func__));
+			WL_ERROR("%s: XXX what to do with TXFID_RATE_PROBE_MASK!?\n",
+				 __func__);
 		}
 		for (i = 0; i < count; i++)
 			wlc_txfifo(wlc, fifo, pkt[i], i == (count - 1),
@@ -1029,13 +1036,16 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		if (supr_status) {
 			update_rate = false;
 			if (supr_status == TX_STATUS_SUPR_BADCH) {
-				WL_ERROR(("%s: Pkt tx suppressed, illegal channel possibly %d\n", __func__, CHSPEC_CHANNEL(wlc->default_bss->chanspec)));
+				WL_ERROR("%s: Pkt tx suppressed, illegal channel possibly %d\n",
+					 __func__,
+					 CHSPEC_CHANNEL(wlc->default_bss->chanspec));
 			} else {
 				if (supr_status == TX_STATUS_SUPR_FRAG)
-					WL_NONE(("%s: AMPDU frag err\n",
-						 __func__));
+					WL_NONE("%s: AMPDU frag err\n",
+						__func__);
 				else
-					WL_ERROR(("%s: wlc_ampdu_dotxstatus: supr_status 0x%x\n", __func__, supr_status));
+					WL_ERROR("%s: wlc_ampdu_dotxstatus: supr_status 0x%x\n",
+						 __func__, supr_status);
 			}
 			/* no need to retry for badch; will fail again */
 			if (supr_status == TX_STATUS_SUPR_BADCH ||
@@ -1059,7 +1069,8 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		} else if (txs->phyerr) {
 			update_rate = false;
 			WLCNTINCR(wlc->pub->_cnt->txphyerr);
-			WL_ERROR(("wl%d: wlc_ampdu_dotxstatus: tx phy error (0x%x)\n", wlc->pub->unit, txs->phyerr));
+			WL_ERROR("wl%d: wlc_ampdu_dotxstatus: tx phy error (0x%x)\n",
+				 wlc->pub->unit, txs->phyerr);
 
 #ifdef BCMDBG
 			if (WL_ERROR_ON()) {
@@ -1091,10 +1102,9 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		if (ba_recd) {
 			bindex = MODSUB_POW2(seq, start_seq, SEQNUM_MAX);
 
-			WL_AMPDU_TX(("%s: tid %d seq is %d, start_seq is %d, "
-				     "bindex is %d set %d, index %d\n",
-				     __func__, tid, seq, start_seq, bindex,
-				     isset(bitmap, bindex), index));
+			WL_AMPDU_TX("%s: tid %d seq is %d, start_seq is %d, bindex is %d set %d, index %d\n",
+				    __func__, tid, seq, start_seq, bindex,
+				    isset(bitmap, bindex), index);
 
 			/* if acked then clear bit and free packet */
 			if ((bindex < AMPDU_TX_BA_MAX_WSIZE)
@@ -1147,7 +1157,8 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				    IEEE80211_TX_STAT_AMPDU_NO_BACK;
 				skb_pull(p, D11_PHY_HDR_LEN);
 				skb_pull(p, D11_TXH_LEN);
-				WL_ERROR(("%s: BA Timeout, seq %d, in_transit %d\n", SHORTNAME, seq, ini->tx_in_transit));
+				WL_ERROR("%s: BA Timeout, seq %d, in_transit %d\n",
+					 SHORTNAME, seq, ini->tx_in_transit);
 				ieee80211_tx_status_irqsafe(wlc->pub->ieee_hw,
 							    p);
 			}
@@ -1183,8 +1194,8 @@ ampdu_cleanup_tid_ini(struct ampdu_info *ampdu, scb_ampdu_t *scb_ampdu, u8 tid,
 	if (!ini)
 		return;
 
-	WL_AMPDU_CTL(("wl%d: ampdu_cleanup_tid_ini: tid %d\n",
-		      ampdu->wlc->pub->unit, tid));
+	WL_AMPDU_CTL("wl%d: ampdu_cleanup_tid_ini: tid %d\n",
+		     ampdu->wlc->pub->unit, tid);
 
 	if (ini->tx_in_transit && !force)
 		return;
@@ -1210,7 +1221,7 @@ static scb_ampdu_tid_ini_t *wlc_ampdu_init_tid_ini(struct ampdu_info *ampdu,
 
 	/* check for per-tid control of ampdu */
 	if (!ampdu->ini_enable[tid]) {
-		WL_ERROR(("%s: Rejecting tid %d\n", __func__, tid));
+		WL_ERROR("%s: Rejecting tid %d\n", __func__, tid);
 		return NULL;
 	}
 
@@ -1231,13 +1242,13 @@ int wlc_ampdu_set(struct ampdu_info *ampdu, bool on)
 
 	if (on) {
 		if (!N_ENAB(wlc->pub)) {
-			WL_AMPDU_ERR(("wl%d: driver not nmode enabled\n",
-				      wlc->pub->unit));
+			WL_AMPDU_ERR("wl%d: driver not nmode enabled\n",
+				     wlc->pub->unit);
 			return BCME_UNSUPPORTED;
 		}
 		if (!wlc_ampdu_cap(ampdu)) {
-			WL_AMPDU_ERR(("wl%d: device not ampdu capable\n",
-				      wlc->pub->unit));
+			WL_AMPDU_ERR("wl%d: device not ampdu capable\n",
+				     wlc->pub->unit);
 			return BCME_UNSUPPORTED;
 		}
 		wlc->pub->_ampdu = on;
diff --git a/drivers/staging/brcm80211/sys/wlc_antsel.c b/drivers/staging/brcm80211/sys/wlc_antsel.c
index 27558fa..402ddf8 100644
--- a/drivers/staging/brcm80211/sys/wlc_antsel.c
+++ b/drivers/staging/brcm80211/sys/wlc_antsel.c
@@ -102,7 +102,7 @@ struct antsel_info *wlc_antsel_attach(struct wlc_info *wlc,
 
 	asi = kzalloc(sizeof(struct antsel_info), GFP_ATOMIC);
 	if (!asi) {
-		WL_ERROR(("wl%d: wlc_antsel_attach: out of mem\n", pub->unit));
+		WL_ERROR("wl%d: wlc_antsel_attach: out of mem\n", pub->unit);
 		return NULL;
 	}
 
@@ -131,7 +131,7 @@ struct antsel_info *wlc_antsel_attach(struct wlc_info *wlc,
 				asi->antsel_avail = false;
 			} else {
 				asi->antsel_avail = false;
-				WL_ERROR(("wlc_antsel_attach: 2o3 board cfg invalid\n"));
+				WL_ERROR("wlc_antsel_attach: 2o3 board cfg invalid\n");
 				ASSERT(0);
 			}
 			break;
diff --git a/drivers/staging/brcm80211/sys/wlc_bmac.c b/drivers/staging/brcm80211/sys/wlc_bmac.c
index 0c2625d..69f600a 100644
--- a/drivers/staging/brcm80211/sys/wlc_bmac.c
+++ b/drivers/staging/brcm80211/sys/wlc_bmac.c
@@ -217,18 +217,20 @@ static void WLBANDINITFN(wlc_ucode_bsinit) (struct wlc_hw_info *wlc_hw)
 		if (WLCISNPHY(wlc_hw->band)) {
 			wlc_write_inits(wlc_hw, d11n0bsinitvals16);
 		} else {
-			WL_ERROR(("%s: wl%d: unsupported phy in corerev %d\n",
-				  __func__, wlc_hw->unit, wlc_hw->corerev));
+			WL_ERROR("%s: wl%d: unsupported phy in corerev %d\n",
+				 __func__, wlc_hw->unit, wlc_hw->corerev);
 		}
 	} else {
 		if (D11REV_IS(wlc_hw->corerev, 24)) {
 			if (WLCISLCNPHY(wlc_hw->band)) {
 				wlc_write_inits(wlc_hw, d11lcn0bsinitvals24);
 			} else
-				WL_ERROR(("%s: wl%d: unsupported phy in corerev %d\n", __func__, wlc_hw->unit, wlc_hw->corerev));
+				WL_ERROR("%s: wl%d: unsupported phy in corerev %d\n",
+					 __func__, wlc_hw->unit,
+					 wlc_hw->corerev);
 		} else {
-			WL_ERROR(("%s: wl%d: unsupported corerev %d\n",
-				  __func__, wlc_hw->unit, wlc_hw->corerev));
+			WL_ERROR("%s: wl%d: unsupported corerev %d\n",
+				 __func__, wlc_hw->unit, wlc_hw->corerev);
 		}
 	}
 }
@@ -240,7 +242,7 @@ static u32 WLBANDINITFN(wlc_setband_inact) (struct wlc_info *wlc, uint bandunit)
 	u32 macintmask;
 	u32 tmp;
 
-	WL_TRACE(("wl%d: wlc_setband_inact\n", wlc_hw->unit));
+	WL_TRACE("wl%d: wlc_setband_inact\n", wlc_hw->unit);
 
 	ASSERT(bandunit != wlc_hw->band->bandunit);
 	ASSERT(si_iscoreup(wlc_hw->sih));
@@ -281,7 +283,7 @@ wlc_bmac_recv(struct wlc_hw_info *wlc_hw, uint fifo, bool bound)
 	u32 tsf_h, tsf_l;
 	wlc_d11rxhdr_t *wlc_rxhdr = NULL;
 
-	WL_TRACE(("wl%d: %s\n", wlc_hw->unit, __func__));
+	WL_TRACE("wl%d: %s\n", wlc_hw->unit, __func__);
 	/* gather received frames */
 	while ((p = dma_rx(wlc_hw->di[fifo]))) {
 
@@ -333,7 +335,7 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 	bool fatal = false;
 
 	if (DEVICEREMOVED(wlc)) {
-		WL_ERROR(("wl%d: %s: dead chip\n", wlc_hw->unit, __func__));
+		WL_ERROR("wl%d: %s: dead chip\n", wlc_hw->unit, __func__);
 		wl_down(wlc->wl);
 		return false;
 	}
@@ -342,8 +344,8 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 	macintstatus = wlc->macintstatus;
 	wlc->macintstatus = 0;
 
-	WL_TRACE(("wl%d: wlc_dpc: macintstatus 0x%x\n", wlc_hw->unit,
-		  macintstatus));
+	WL_TRACE("wl%d: wlc_dpc: macintstatus 0x%x\n",
+		 wlc_hw->unit, macintstatus);
 
 	if (macintstatus & MI_PRQ) {
 		/* Process probe request FIFO */
@@ -366,7 +368,7 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 		if (wlc_bmac_txstatus(wlc->hw, bounded, &fatal))
 			wlc->macintstatus |= MI_TFS;
 		if (fatal) {
-			WL_ERROR(("MI_TFS: fatal\n"));
+			WL_ERROR("MI_TFS: fatal\n");
 			goto fatal;
 		}
 	}
@@ -376,7 +378,7 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 
 	/* ATIM window end */
 	if (macintstatus & MI_ATIMWINEND) {
-		WL_TRACE(("wlc_isr: end of ATIM window\n"));
+		WL_TRACE("wlc_isr: end of ATIM window\n");
 
 		OR_REG(wlc_hw->osh, &regs->maccommand, wlc->qvalid);
 		wlc->qvalid = 0;
@@ -397,7 +399,7 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 	/* TX FIFO suspend/flush completion */
 	if (macintstatus & MI_TXSTOP) {
 		if (wlc_bmac_tx_fifo_suspended(wlc_hw, TX_DATA_FIFO)) {
-			/*      WL_ERROR(("dpc: fifo_suspend_comlete\n")); */
+			/*      WL_ERROR("dpc: fifo_suspend_comlete\n"); */
 		}
 	}
 
@@ -407,7 +409,8 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 	}
 
 	if (macintstatus & MI_GP0) {
-		WL_ERROR(("wl%d: PSM microcode watchdog fired at %d (seconds). Resetting.\n", wlc_hw->unit, wlc_hw->now));
+		WL_ERROR("wl%d: PSM microcode watchdog fired at %d (seconds). Resetting.\n",
+			 wlc_hw->unit, wlc_hw->now);
 
 		printk_once("%s : PSM Watchdog, chipid 0x%x, chiprev 0x%x\n",
 					__func__, wlc_hw->sih->chip,
@@ -429,7 +432,8 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 		u32 rfd = R_REG(wlc_hw->osh, &regs->phydebug) & PDBG_RFD;
 #endif
 
-		WL_ERROR(("wl%d: MAC Detected a change on the RF Disable Input 0x%x\n", wlc_hw->unit, rfd));
+		WL_ERROR("wl%d: MAC Detected a change on the RF Disable Input 0x%x\n",
+			 wlc_hw->unit, rfd);
 
 		WLCNTINCR(wlc->pub->_cnt->rfdisable);
 	}
@@ -457,7 +461,7 @@ void wlc_bmac_watchdog(void *arg)
 	struct wlc_info *wlc = (struct wlc_info *) arg;
 	struct wlc_hw_info *wlc_hw = wlc->hw;
 
-	WL_TRACE(("wl%d: wlc_bmac_watchdog\n", wlc_hw->unit));
+	WL_TRACE("wl%d: wlc_bmac_watchdog\n", wlc_hw->unit);
 
 	if (!wlc_hw->up)
 		return;
@@ -483,8 +487,8 @@ wlc_bmac_set_chanspec(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 {
 	uint bandunit;
 
-	WL_TRACE(("wl%d: wlc_bmac_set_chanspec 0x%x\n", wlc_hw->unit,
-		  chanspec));
+	WL_TRACE("wl%d: wlc_bmac_set_chanspec 0x%x\n",
+		 wlc_hw->unit, chanspec);
 
 	wlc_hw->chanspec = chanspec;
 
@@ -594,7 +598,8 @@ static bool wlc_bmac_attach_dmapio(struct wlc_info *wlc, uint j, bool wme)
 		    dma_addrwidth(wlc_hw->sih, DMAREG(wlc_hw, DMA_TX, 0));
 
 		if (!wl_alloc_dma_resources(wlc_hw->wlc->wl, addrwidth)) {
-			WL_ERROR(("wl%d: wlc_attach: alloc_dma_resources failed\n", unit));
+			WL_ERROR("wl%d: wlc_attach: alloc_dma_resources failed\n",
+				 unit);
 			return false;
 		}
 
@@ -667,8 +672,7 @@ static bool wlc_bmac_attach_dmapio(struct wlc_info *wlc, uint j, bool wme)
 /* Cleaner to leave this as if with AP defined */
 
 		if (dma_attach_err) {
-			WL_ERROR(("wl%d: wlc_attach: dma_attach failed\n",
-				  unit));
+			WL_ERROR("wl%d: wlc_attach: dma_attach failed\n", unit);
 			return false;
 		}
 
@@ -717,8 +721,8 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	bool wme = false;
 	shared_phy_params_t sha_params;
 
-	WL_TRACE(("wl%d: wlc_bmac_attach: vendor 0x%x device 0x%x\n", unit,
-		  vendor, device));
+	WL_TRACE("wl%d: wlc_bmac_attach: vendor 0x%x device 0x%x\n",
+		 unit, vendor, device);
 
 	ASSERT(sizeof(wlc_d11rxhdr_t) <= WL_HWRXOFF);
 
@@ -742,7 +746,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	wlc_hw->sih = si_attach((uint) device, osh, regsva, bustype, btparam,
 				&wlc_hw->vars, &wlc_hw->vars_size);
 	if (wlc_hw->sih == NULL) {
-		WL_ERROR(("wl%d: wlc_bmac_attach: si_attach failed\n", unit));
+		WL_ERROR("wl%d: wlc_bmac_attach: si_attach failed\n", unit);
 		err = 11;
 		goto fail;
 	}
@@ -762,21 +766,22 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		var = getvar(vars, "vendid");
 		if (var) {
 			vendor = (u16) simple_strtoul(var, NULL, 0);
-			WL_ERROR(("Overriding vendor id = 0x%x\n", vendor));
+			WL_ERROR("Overriding vendor id = 0x%x\n", vendor);
 		}
 		var = getvar(vars, "devid");
 		if (var) {
 			u16 devid = (u16) simple_strtoul(var, NULL, 0);
 			if (devid != 0xffff) {
 				device = devid;
-				WL_ERROR(("Overriding device id = 0x%x\n",
-					  device));
+				WL_ERROR("Overriding device id = 0x%x\n",
+					 device);
 			}
 		}
 
 		/* verify again the device is supported */
 		if (!wlc_chipmatch(vendor, device)) {
-			WL_ERROR(("wl%d: wlc_bmac_attach: Unsupported vendor/device (0x%x/0x%x)\n", unit, vendor, device));
+			WL_ERROR("wl%d: wlc_bmac_attach: Unsupported vendor/device (0x%x/0x%x)\n",
+				 unit, vendor, device);
 			err = 12;
 			goto fail;
 		}
@@ -811,7 +816,8 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	wlc_bmac_corereset(wlc_hw, WLC_USE_COREFLAGS);
 
 	if (!wlc_bmac_validate_chip_access(wlc_hw)) {
-		WL_ERROR(("wl%d: wlc_bmac_attach: validate_chip_access failed\n", unit));
+		WL_ERROR("wl%d: wlc_bmac_attach: validate_chip_access failed\n",
+			 unit);
 		err = 14;
 		goto fail;
 	}
@@ -823,7 +829,8 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		j = BOARDREV_PROMOTED;
 	wlc_hw->boardrev = (u16) j;
 	if (!wlc_validboardtype(wlc_hw)) {
-		WL_ERROR(("wl%d: wlc_bmac_attach: Unsupported Broadcom board type (0x%x)" " or revision level (0x%x)\n", unit, wlc_hw->sih->boardtype, wlc_hw->boardrev));
+		WL_ERROR("wl%d: wlc_bmac_attach: Unsupported Broadcom board type (0x%x)" " or revision level (0x%x)\n",
+			 unit, wlc_hw->sih->boardtype, wlc_hw->boardrev);
 		err = 15;
 		goto fail;
 	}
@@ -865,8 +872,8 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	wlc_hw->physhim = wlc_phy_shim_attach(wlc_hw, wlc->wl, wlc);
 
 	if (wlc_hw->physhim == NULL) {
-		WL_ERROR(("wl%d: wlc_bmac_attach: wlc_phy_shim_attach failed\n",
-			  unit));
+		WL_ERROR("wl%d: wlc_bmac_attach: wlc_phy_shim_attach failed\n",
+			 unit);
 		err = 25;
 		goto fail;
 	}
@@ -933,7 +940,8 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		wlc_hw->band->pi = wlc_phy_attach(wlc_hw->phy_sh,
 			(void *)regs, wlc_hw->band->bandtype, vars);
 		if (wlc_hw->band->pi == NULL) {
-			WL_ERROR(("wl%d: wlc_bmac_attach: wlc_phy_attach failed\n", unit));
+			WL_ERROR("wl%d: wlc_bmac_attach: wlc_phy_attach failed\n",
+				 unit);
 			err = 17;
 			goto fail;
 		}
@@ -963,7 +971,9 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 				goto bad_phy;
 		} else {
  bad_phy:
-			WL_ERROR(("wl%d: wlc_bmac_attach: unsupported phy type/rev (%d/%d)\n", unit, wlc_hw->band->phytype, wlc_hw->band->phyrev));
+			WL_ERROR("wl%d: wlc_bmac_attach: unsupported phy type/rev (%d/%d)\n",
+				 unit,
+				 wlc_hw->band->phytype, wlc_hw->band->phyrev);
 			err = 18;
 			goto fail;
 		}
@@ -1018,27 +1028,27 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	/* init etheraddr state variables */
 	macaddr = wlc_get_macaddr(wlc_hw);
 	if (macaddr == NULL) {
-		WL_ERROR(("wl%d: wlc_bmac_attach: macaddr not found\n", unit));
+		WL_ERROR("wl%d: wlc_bmac_attach: macaddr not found\n", unit);
 		err = 21;
 		goto fail;
 	}
 	bcm_ether_atoe(macaddr, &wlc_hw->etheraddr);
 	if (is_broadcast_ether_addr(wlc_hw->etheraddr.octet) ||
 	    is_zero_ether_addr(wlc_hw->etheraddr.octet)) {
-		WL_ERROR(("wl%d: wlc_bmac_attach: bad macaddr %s\n", unit,
-			  macaddr));
+		WL_ERROR("wl%d: wlc_bmac_attach: bad macaddr %s\n",
+			 unit, macaddr);
 		err = 22;
 		goto fail;
 	}
 
-	WL_ERROR(("%s:: deviceid 0x%x nbands %d board 0x%x macaddr: %s\n",
-		  __func__, wlc_hw->deviceid, wlc_hw->_nbands,
-		  wlc_hw->sih->boardtype, macaddr));
+	WL_ERROR("%s:: deviceid 0x%x nbands %d board 0x%x macaddr: %s\n",
+		 __func__, wlc_hw->deviceid, wlc_hw->_nbands,
+		 wlc_hw->sih->boardtype, macaddr);
 
 	return err;
 
  fail:
-	WL_ERROR(("wl%d: wlc_bmac_attach: failed with err %d\n", unit, err));
+	WL_ERROR("wl%d: wlc_bmac_attach: failed with err %d\n", unit, err);
 	return err;
 }
 
@@ -1122,7 +1132,7 @@ int wlc_bmac_detach(struct wlc_info *wlc)
 
 void wlc_bmac_reset(struct wlc_hw_info *wlc_hw)
 {
-	WL_TRACE(("wl%d: wlc_bmac_reset\n", wlc_hw->unit));
+	WL_TRACE("wl%d: wlc_bmac_reset\n", wlc_hw->unit);
 
 	WLCNTINCR(wlc_hw->wlc->pub->_cnt->reset);
 
@@ -1143,7 +1153,7 @@ wlc_bmac_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 	bool fastclk;
 	struct wlc_info *wlc = wlc_hw->wlc;
 
-	WL_TRACE(("wl%d: wlc_bmac_init\n", wlc_hw->unit));
+	WL_TRACE("wl%d: wlc_bmac_init\n", wlc_hw->unit);
 
 	/* request FAST clock if not on */
 	fastclk = wlc_hw->forcefastclk;
@@ -1192,7 +1202,7 @@ int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw)
 {
 	uint coremask;
 
-	WL_TRACE(("wl%d: %s:\n", wlc_hw->unit, __func__));
+	WL_TRACE("wl%d: %s:\n", wlc_hw->unit, __func__);
 
 	ASSERT(wlc_hw->wlc->pub->hw_up && wlc_hw->wlc->macintmask == 0);
 
@@ -1238,7 +1248,7 @@ int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw)
 
 int wlc_bmac_up_finish(struct wlc_hw_info *wlc_hw)
 {
-	WL_TRACE(("wl%d: %s:\n", wlc_hw->unit, __func__));
+	WL_TRACE("wl%d: %s:\n", wlc_hw->unit, __func__);
 
 	wlc_hw->up = true;
 	wlc_phy_hw_state_upd(wlc_hw->band->pi, true);
@@ -1255,7 +1265,7 @@ int wlc_bmac_down_prep(struct wlc_hw_info *wlc_hw)
 	bool dev_gone;
 	uint callbacks = 0;
 
-	WL_TRACE(("wl%d: %s:\n", wlc_hw->unit, __func__));
+	WL_TRACE("wl%d: %s:\n", wlc_hw->unit, __func__);
 
 	if (!wlc_hw->up)
 		return callbacks;
@@ -1283,7 +1293,7 @@ int wlc_bmac_down_finish(struct wlc_hw_info *wlc_hw)
 	uint callbacks = 0;
 	bool dev_gone;
 
-	WL_TRACE(("wl%d: %s:\n", wlc_hw->unit, __func__));
+	WL_TRACE("wl%d: %s:\n", wlc_hw->unit, __func__);
 
 	if (!wlc_hw->up)
 		return callbacks;
@@ -1719,7 +1729,7 @@ wlc_bmac_set_rcmta(struct wlc_hw_info *wlc_hw, int idx,
 	u16 mac_l;
 	struct osl_info *osh;
 
-	WL_TRACE(("wl%d: %s\n", wlc_hw->unit, __func__));
+	WL_TRACE("wl%d: %s\n", wlc_hw->unit, __func__);
 
 	ASSERT(wlc_hw->corerev > 4);
 
@@ -1752,7 +1762,7 @@ wlc_bmac_set_addrmatch(struct wlc_hw_info *wlc_hw, int match_reg_offset,
 	u16 mac_h;
 	struct osl_info *osh;
 
-	WL_TRACE(("wl%d: wlc_bmac_set_addrmatch\n", wlc_hw->unit));
+	WL_TRACE("wl%d: wlc_bmac_set_addrmatch\n", wlc_hw->unit);
 
 	ASSERT((match_reg_offset < RCM_SIZE) || (wlc_hw->corerev == 4));
 
@@ -1783,7 +1793,7 @@ wlc_bmac_write_template_ram(struct wlc_hw_info *wlc_hw, int offset, int len,
 #endif				/* IL_BIGENDIAN */
 	struct osl_info *osh;
 
-	WL_TRACE(("wl%d: wlc_bmac_write_template_ram\n", wlc_hw->unit));
+	WL_TRACE("wl%d: wlc_bmac_write_template_ram\n", wlc_hw->unit);
 
 	regs = wlc_hw->regs;
 	osh = wlc_hw->osh;
@@ -1937,8 +1947,8 @@ WLBANDINITFN(wlc_bmac_bsinit) (struct wlc_info *wlc, chanspec_t chanspec)
 {
 	struct wlc_hw_info *wlc_hw = wlc->hw;
 
-	WL_TRACE(("wl%d: wlc_bmac_bsinit: bandunit %d\n", wlc_hw->unit,
-		  wlc_hw->band->bandunit));
+	WL_TRACE("wl%d: wlc_bmac_bsinit: bandunit %d\n",
+		 wlc_hw->unit, wlc_hw->band->bandunit);
 
 	/* sanity check */
 	if (PHY_TYPE(R_REG(wlc_hw->osh, &wlc_hw->regs->phyversion)) !=
@@ -1974,7 +1984,7 @@ WLBANDINITFN(wlc_bmac_bsinit) (struct wlc_info *wlc, chanspec_t chanspec)
 
 void wlc_bmac_core_phy_clk(struct wlc_hw_info *wlc_hw, bool clk)
 {
-	WL_TRACE(("wl%d: wlc_bmac_core_phy_clk: clk %d\n", wlc_hw->unit, clk));
+	WL_TRACE("wl%d: wlc_bmac_core_phy_clk: clk %d\n", wlc_hw->unit, clk);
 
 	wlc_hw->phyclk = clk;
 
@@ -1999,7 +2009,7 @@ void wlc_bmac_core_phy_clk(struct wlc_hw_info *wlc_hw, bool clk)
 /* Perform a soft reset of the PHY PLL */
 void wlc_bmac_core_phypll_reset(struct wlc_hw_info *wlc_hw)
 {
-	WL_TRACE(("wl%d: wlc_bmac_core_phypll_reset\n", wlc_hw->unit));
+	WL_TRACE("wl%d: wlc_bmac_core_phypll_reset\n", wlc_hw->unit);
 
 	si_corereg(wlc_hw->sih, SI_CC_IDX,
 		   offsetof(chipcregs_t, chipcontrol_addr), ~0, 0);
@@ -2045,7 +2055,7 @@ void wlc_bmac_phy_reset(struct wlc_hw_info *wlc_hw)
 	u32 phy_bw_clkbits;
 	bool phy_in_reset = false;
 
-	WL_TRACE(("wl%d: wlc_bmac_phy_reset\n", wlc_hw->unit));
+	WL_TRACE("wl%d: wlc_bmac_phy_reset\n", wlc_hw->unit);
 
 	if (pih == NULL)
 		return;
@@ -2127,7 +2137,7 @@ WLBANDINITFN(wlc_bmac_setband) (struct wlc_hw_info *wlc_hw, uint bandunit,
 /* low-level band switch utility routine */
 void WLBANDINITFN(wlc_setxband) (struct wlc_hw_info *wlc_hw, uint bandunit)
 {
-	WL_TRACE(("wl%d: wlc_setxband: bandunit %d\n", wlc_hw->unit, bandunit));
+	WL_TRACE("wl%d: wlc_setxband: bandunit %d\n", wlc_hw->unit, bandunit);
 
 	wlc_hw->band = wlc_hw->bandstate[bandunit];
 
@@ -2146,7 +2156,7 @@ static bool wlc_isgoodchip(struct wlc_hw_info *wlc_hw)
 
 	/* reject unsupported corerev */
 	if (!VALID_COREREV(wlc_hw->corerev)) {
-		WL_ERROR(("unsupported core rev %d\n", wlc_hw->corerev));
+		WL_ERROR("unsupported core rev %d\n", wlc_hw->corerev);
 		return false;
 	}
 
@@ -2194,7 +2204,8 @@ static char *wlc_get_macaddr(struct wlc_hw_info *wlc_hw)
 
 	macaddr = getvar(wlc_hw->vars, varname);
 	if (macaddr == NULL) {
-		WL_ERROR(("wl%d: wlc_get_macaddr: macaddr getvar(%s) not found\n", wlc_hw->unit, varname));
+		WL_ERROR("wl%d: wlc_get_macaddr: macaddr getvar(%s) not found\n",
+			 wlc_hw->unit, varname);
 	}
 
 	return macaddr;
@@ -2257,7 +2268,7 @@ void wlc_bmac_hw_up(struct wlc_hw_info *wlc_hw)
 	if (wlc_hw->wlc->pub->hw_up)
 		return;
 
-	WL_TRACE(("wl%d: %s:\n", wlc_hw->unit, __func__));
+	WL_TRACE("wl%d: %s:\n", wlc_hw->unit, __func__);
 
 	/*
 	 * Enable pll and xtal, initialize the power control registers,
@@ -2312,7 +2323,8 @@ static bool wlc_dma_rxreset(struct wlc_hw_info *wlc_hw, uint fifo)
 			 50000);
 
 		if (!rxidle && (rcv_frm_cnt != 0))
-			WL_ERROR(("wl%d: %s: rxdma[%d] not idle && rcv_frm_cnt(%d) not zero\n", wlc_hw->unit, __func__, fifo, rcv_frm_cnt));
+			WL_ERROR("wl%d: %s: rxdma[%d] not idle && rcv_frm_cnt(%d) not zero\n",
+				 wlc_hw->unit, __func__, fifo, rcv_frm_cnt);
 		mdelay(2);
 	}
 
@@ -2337,7 +2349,7 @@ void wlc_bmac_corereset(struct wlc_hw_info *wlc_hw, u32 flags)
 	if (flags == WLC_USE_COREFLAGS)
 		flags = (wlc_hw->band->pi ? wlc_hw->band->core_flags : 0);
 
-	WL_TRACE(("wl%d: %s\n", wlc_hw->unit, __func__));
+	WL_TRACE("wl%d: %s\n", wlc_hw->unit, __func__);
 
 	regs = wlc_hw->regs;
 
@@ -2350,17 +2362,20 @@ void wlc_bmac_corereset(struct wlc_hw_info *wlc_hw, u32 flags)
 	if (si_iscoreup(wlc_hw->sih)) {
 		for (i = 0; i < NFIFO; i++)
 			if ((wlc_hw->di[i]) && (!dma_txreset(wlc_hw->di[i]))) {
-				WL_ERROR(("wl%d: %s: dma_txreset[%d]: cannot stop dma\n", wlc_hw->unit, __func__, i));
+				WL_ERROR("wl%d: %s: dma_txreset[%d]: cannot stop dma\n",
+					 wlc_hw->unit, __func__, i);
 			}
 
 		if ((wlc_hw->di[RX_FIFO])
 		    && (!wlc_dma_rxreset(wlc_hw, RX_FIFO))) {
-			WL_ERROR(("wl%d: %s: dma_rxreset[%d]: cannot stop dma\n", wlc_hw->unit, __func__, RX_FIFO));
+			WL_ERROR("wl%d: %s: dma_rxreset[%d]: cannot stop dma\n",
+				 wlc_hw->unit, __func__, RX_FIFO);
 		}
 		if (D11REV_IS(wlc_hw->corerev, 4)
 		    && wlc_hw->di[RX_TXSTATUS_FIFO]
 		    && (!wlc_dma_rxreset(wlc_hw, RX_TXSTATUS_FIFO))) {
-			WL_ERROR(("wl%d: %s: dma_rxreset[%d]: cannot stop dma\n", wlc_hw->unit, __func__, RX_TXSTATUS_FIFO));
+			WL_ERROR("wl%d: %s: dma_rxreset[%d]: cannot stop dma\n",
+				 wlc_hw->unit, __func__, RX_TXSTATUS_FIFO);
 		}
 	}
 	/* if noreset, just stop the psm and return */
@@ -2491,7 +2506,7 @@ static void wlc_coreinit(struct wlc_info *wlc)
 	regs = wlc_hw->regs;
 	osh = wlc_hw->osh;
 
-	WL_TRACE(("wl%d: wlc_coreinit\n", wlc_hw->unit));
+	WL_TRACE("wl%d: wlc_coreinit\n", wlc_hw->unit);
 
 	/* reset PSM */
 	wlc_bmac_mctrl(wlc_hw, ~0, (MCTL_IHR_EN | MCTL_PSM_JMP_0 | MCTL_WAKE));
@@ -2514,8 +2529,8 @@ static void wlc_coreinit(struct wlc_info *wlc)
 	SPINWAIT(((R_REG(osh, &regs->macintstatus) & MI_MACSSPNDD) == 0),
 		 1000 * 1000);
 	if ((R_REG(osh, &regs->macintstatus) & MI_MACSSPNDD) == 0)
-		WL_ERROR(("wl%d: wlc_coreinit: ucode did not self-suspend!\n",
-			  wlc_hw->unit));
+		WL_ERROR("wl%d: wlc_coreinit: ucode did not self-suspend!\n",
+			 wlc_hw->unit);
 
 	wlc_gpio_init(wlc);
 
@@ -2525,18 +2540,18 @@ static void wlc_coreinit(struct wlc_info *wlc)
 		if (WLCISNPHY(wlc_hw->band))
 			wlc_write_inits(wlc_hw, d11n0initvals16);
 		else
-			WL_ERROR(("%s: wl%d: unsupported phy in corerev %d\n",
-				  __func__, wlc_hw->unit, wlc_hw->corerev));
+			WL_ERROR("%s: wl%d: unsupported phy in corerev %d\n",
+				 __func__, wlc_hw->unit, wlc_hw->corerev);
 	} else if (D11REV_IS(wlc_hw->corerev, 24)) {
 		if (WLCISLCNPHY(wlc_hw->band)) {
 			wlc_write_inits(wlc_hw, d11lcn0initvals24);
 		} else {
-			WL_ERROR(("%s: wl%d: unsupported phy in corerev %d\n",
-				  __func__, wlc_hw->unit, wlc_hw->corerev));
+			WL_ERROR("%s: wl%d: unsupported phy in corerev %d\n",
+				 __func__, wlc_hw->unit, wlc_hw->corerev);
 		}
 	} else {
-		WL_ERROR(("%s: wl%d: unsupported corerev %d\n",
-			  __func__, wlc_hw->unit, wlc_hw->corerev));
+		WL_ERROR("%s: wl%d: unsupported corerev %d\n",
+			 __func__, wlc_hw->unit, wlc_hw->corerev);
 	}
 
 	/* For old ucode, txfifo sizes needs to be modified(increased) for Corerev >= 9 */
@@ -2578,7 +2593,8 @@ static void wlc_coreinit(struct wlc_info *wlc)
 		err = -1;
 	}
 	if (err != 0) {
-		WL_ERROR(("wlc_coreinit: txfifo mismatch: ucode size %d driver size %d index %d\n", buf[i], wlc_hw->xmtfifo_sz[i], i));
+		WL_ERROR("wlc_coreinit: txfifo mismatch: ucode size %d driver size %d index %d\n",
+			 buf[i], wlc_hw->xmtfifo_sz[i], i);
 		/* DO NOT ASSERT corerev < 4 even there is a mismatch
 		 * shmem, since driver don't overwrite those chip and
 		 * ucode initialize data will be used.
@@ -2797,16 +2813,16 @@ static void wlc_ucode_download(struct wlc_hw_info *wlc_hw)
 					bcm43xx_16_mimosz);
 			wlc_hw->ucode_loaded = true;
 		} else
-			WL_ERROR(("%s: wl%d: unsupported phy in corerev %d\n",
-				  __func__, wlc_hw->unit, wlc_hw->corerev));
+			WL_ERROR("%s: wl%d: unsupported phy in corerev %d\n",
+				 __func__, wlc_hw->unit, wlc_hw->corerev);
 	} else if (D11REV_IS(wlc_hw->corerev, 24)) {
 		if (WLCISLCNPHY(wlc_hw->band)) {
 			wlc_ucode_write(wlc_hw, bcm43xx_24_lcn,
 					bcm43xx_24_lcnsz);
 			wlc_hw->ucode_loaded = true;
 		} else {
-			WL_ERROR(("%s: wl%d: unsupported phy in corerev %d\n",
-				  __func__, wlc_hw->unit, wlc_hw->corerev));
+			WL_ERROR("%s: wl%d: unsupported phy in corerev %d\n",
+				 __func__, wlc_hw->unit, wlc_hw->corerev);
 		}
 	}
 }
@@ -2820,7 +2836,7 @@ static void wlc_ucode_write(struct wlc_hw_info *wlc_hw, const u32 ucode[],
 
 	osh = wlc_hw->osh;
 
-	WL_TRACE(("wl%d: wlc_ucode_write\n", wlc_hw->unit));
+	WL_TRACE("wl%d: wlc_ucode_write\n", wlc_hw->unit);
 
 	ASSERT(IS_ALIGNED(nbytes, sizeof(u32)));
 
@@ -2838,7 +2854,7 @@ static void wlc_write_inits(struct wlc_hw_info *wlc_hw, const d11init_t *inits)
 	struct osl_info *osh;
 	volatile u8 *base;
 
-	WL_TRACE(("wl%d: wlc_write_inits\n", wlc_hw->unit));
+	WL_TRACE("wl%d: wlc_write_inits\n", wlc_hw->unit);
 
 	osh = wlc_hw->osh;
 	base = (volatile u8 *)wlc_hw->regs;
@@ -2914,44 +2930,45 @@ void wlc_bmac_fifoerrors(struct wlc_hw_info *wlc_hw)
 		if (!intstatus)
 			continue;
 
-		WL_TRACE(("wl%d: wlc_bmac_fifoerrors: intstatus%d 0x%x\n", unit,
-			  idx, intstatus));
+		WL_TRACE("wl%d: wlc_bmac_fifoerrors: intstatus%d 0x%x\n",
+			 unit, idx, intstatus);
 
 		if (intstatus & I_RO) {
-			WL_ERROR(("wl%d: fifo %d: receive fifo overflow\n",
-				  unit, idx));
+			WL_ERROR("wl%d: fifo %d: receive fifo overflow\n",
+				 unit, idx);
 			WLCNTINCR(wlc_hw->wlc->pub->_cnt->rxoflo);
 			fatal = true;
 		}
 
 		if (intstatus & I_PC) {
-			WL_ERROR(("wl%d: fifo %d: descriptor error\n", unit,
-				  idx));
+			WL_ERROR("wl%d: fifo %d: descriptor error\n",
+				 unit, idx);
 			WLCNTINCR(wlc_hw->wlc->pub->_cnt->dmade);
 			fatal = true;
 		}
 
 		if (intstatus & I_PD) {
-			WL_ERROR(("wl%d: fifo %d: data error\n", unit, idx));
+			WL_ERROR("wl%d: fifo %d: data error\n", unit, idx);
 			WLCNTINCR(wlc_hw->wlc->pub->_cnt->dmada);
 			fatal = true;
 		}
 
 		if (intstatus & I_DE) {
-			WL_ERROR(("wl%d: fifo %d: descriptor protocol error\n",
-				  unit, idx));
+			WL_ERROR("wl%d: fifo %d: descriptor protocol error\n",
+				 unit, idx);
 			WLCNTINCR(wlc_hw->wlc->pub->_cnt->dmape);
 			fatal = true;
 		}
 
 		if (intstatus & I_RU) {
-			WL_ERROR(("wl%d: fifo %d: receive descriptor underflow\n", unit, idx));
+			WL_ERROR("wl%d: fifo %d: receive descriptor underflow\n",
+				 idx, unit);
 			WLCNTINCR(wlc_hw->wlc->pub->_cnt->rxuflo[idx]);
 		}
 
 		if (intstatus & I_XU) {
-			WL_ERROR(("wl%d: fifo %d: transmit fifo underflow\n",
-				  idx, unit));
+			WL_ERROR("wl%d: fifo %d: transmit fifo underflow\n",
+				 idx, unit);
 			WLCNTINCR(wlc_hw->wlc->pub->_cnt->txuflo);
 			fatal = true;
 		}
@@ -3185,7 +3202,7 @@ static inline u32 wlc_intstatus(struct wlc_info *wlc, bool in_isr)
 	/* macintstatus includes a DMA interrupt summary bit */
 	macintstatus = R_REG(osh, &regs->macintstatus);
 
-	WL_TRACE(("wl%d: macintstatus: 0x%x\n", wlc_hw->unit, macintstatus));
+	WL_TRACE("wl%d: macintstatus: 0x%x\n", wlc_hw->unit, macintstatus);
 
 	/* detect cardbus removed, in power down(suspend) and in reset */
 	if (DEVICEREMOVED(wlc))
@@ -3225,7 +3242,9 @@ static inline u32 wlc_intstatus(struct wlc_info *wlc, bool in_isr)
 			    R_REG(osh,
 				  &regs->intctrlregs[RX_TXSTATUS_FIFO].
 				  intstatus);
-			WL_TRACE(("wl%d: intstatus_rxfifo 0x%x, intstatus_txsfifo 0x%x\n", wlc_hw->unit, intstatus_rxfifo, intstatus_txsfifo));
+			WL_TRACE("wl%d: intstatus_rxfifo 0x%x, intstatus_txsfifo 0x%x\n",
+				 wlc_hw->unit,
+				 intstatus_rxfifo, intstatus_txsfifo);
 
 			/* defer unsolicited interrupt hints */
 			intstatus_rxfifo &= DEF_RXINTMASK;
@@ -3301,7 +3320,7 @@ bool BCMFASTPATH wlc_isr(struct wlc_info *wlc, bool *wantdpc)
 	macintstatus = wlc_intstatus(wlc, true);
 
 	if (macintstatus == 0xffffffff)
-		WL_ERROR(("DEVICEREMOVED detected in the ISR code path.\n"));
+		WL_ERROR("DEVICEREMOVED detected in the ISR code path\n");
 
 	/* it is not for us */
 	if (macintstatus == 0)
@@ -3325,7 +3344,7 @@ static bool wlc_bmac_txstatus_corerev4(struct wlc_hw_info *wlc_hw)
 	struct osl_info *osh;
 	bool fatal = false;
 
-	WL_TRACE(("wl%d: wlc_txstatusrecv\n", wlc_hw->unit));
+	WL_TRACE("wl%d: wlc_txstatusrecv\n", wlc_hw->unit);
 
 	osh = wlc_hw->osh;
 
@@ -3378,7 +3397,7 @@ wlc_bmac_txstatus(struct wlc_hw_info *wlc_hw, bool bound, bool *fatal)
 	bool morepending = false;
 	struct wlc_info *wlc = wlc_hw->wlc;
 
-	WL_TRACE(("wl%d: wlc_bmac_txstatus\n", wlc_hw->unit));
+	WL_TRACE("wl%d: wlc_bmac_txstatus\n", wlc_hw->unit);
 
 	if (D11REV_IS(wlc_hw->corerev, 4)) {
 		/* to retire soon */
@@ -3403,8 +3422,8 @@ wlc_bmac_txstatus(struct wlc_hw_info *wlc_hw, bool bound, bool *fatal)
 		       && (s1 = R_REG(osh, &regs->frmtxstatus)) & TXS_V) {
 
 			if (s1 == 0xffffffff) {
-				WL_ERROR(("wl%d: %s: dead chip\n",
-					  wlc_hw->unit, __func__));
+				WL_ERROR("wl%d: %s: dead chip\n",
+					 wlc_hw->unit, __func__);
 				ASSERT(s1 != 0xffffffff);
 				return morepending;
 			}
@@ -3444,8 +3463,8 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 	u32 mc, mi;
 	struct osl_info *osh;
 
-	WL_TRACE(("wl%d: wlc_suspend_mac_and_wait: bandunit %d\n", wlc_hw->unit,
-		  wlc_hw->band->bandunit));
+	WL_TRACE("wl%d: wlc_suspend_mac_and_wait: bandunit %d\n",
+		 wlc_hw->unit, wlc_hw->band->bandunit);
 
 	/*
 	 * Track overlapping suspend requests
@@ -3462,7 +3481,7 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 	mc = R_REG(osh, &regs->maccontrol);
 
 	if (mc == 0xffffffff) {
-		WL_ERROR(("wl%d: %s: dead chip\n", wlc_hw->unit, __func__));
+		WL_ERROR("wl%d: %s: dead chip\n", wlc_hw->unit, __func__);
 		wl_down(wlc->wl);
 		return;
 	}
@@ -3472,7 +3491,7 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 
 	mi = R_REG(osh, &regs->macintstatus);
 	if (mi == 0xffffffff) {
-		WL_ERROR(("wl%d: %s: dead chip\n", wlc_hw->unit, __func__));
+		WL_ERROR("wl%d: %s: dead chip\n", wlc_hw->unit, __func__);
 		wl_down(wlc->wl);
 		return;
 	}
@@ -3484,15 +3503,18 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 		 WLC_MAX_MAC_SUSPEND);
 
 	if (!(R_REG(osh, &regs->macintstatus) & MI_MACSSPNDD)) {
-		WL_ERROR(("wl%d: wlc_suspend_mac_and_wait: waited %d uS and "
-			  "MI_MACSSPNDD is still not on.\n",
-			  wlc_hw->unit, WLC_MAX_MAC_SUSPEND));
-		WL_ERROR(("wl%d: psmdebug 0x%08x, phydebug 0x%08x, psm_brc 0x%04x\n", wlc_hw->unit, R_REG(osh, &regs->psmdebug), R_REG(osh, &regs->phydebug), R_REG(osh, &regs->psm_brc)));
+		WL_ERROR("wl%d: wlc_suspend_mac_and_wait: waited %d uS and MI_MACSSPNDD is still not on.\n",
+			 wlc_hw->unit, WLC_MAX_MAC_SUSPEND);
+		WL_ERROR("wl%d: psmdebug 0x%08x, phydebug 0x%08x, psm_brc 0x%04x\n",
+			 wlc_hw->unit,
+			 R_REG(osh, &regs->psmdebug),
+			 R_REG(osh, &regs->phydebug),
+			 R_REG(osh, &regs->psm_brc));
 	}
 
 	mc = R_REG(osh, &regs->maccontrol);
 	if (mc == 0xffffffff) {
-		WL_ERROR(("wl%d: %s: dead chip\n", wlc_hw->unit, __func__));
+		WL_ERROR("wl%d: %s: dead chip\n", wlc_hw->unit, __func__);
 		wl_down(wlc->wl);
 		return;
 	}
@@ -3508,8 +3530,8 @@ void wlc_enable_mac(struct wlc_info *wlc)
 	u32 mc, mi;
 	struct osl_info *osh;
 
-	WL_TRACE(("wl%d: wlc_enable_mac: bandunit %d\n", wlc_hw->unit,
-		  wlc->band->bandunit));
+	WL_TRACE("wl%d: wlc_enable_mac: bandunit %d\n",
+		 wlc_hw->unit, wlc->band->bandunit);
 
 	/*
 	 * Track overlapping suspend requests
@@ -3671,7 +3693,7 @@ bool wlc_bmac_validate_chip_access(struct wlc_hw_info *wlc_hw)
 	volatile u16 *reg16;
 	struct osl_info *osh;
 
-	WL_TRACE(("wl%d: validate_chip_access\n", wlc_hw->unit));
+	WL_TRACE("wl%d: validate_chip_access\n", wlc_hw->unit);
 
 	regs = wlc_hw->regs;
 	osh = wlc_hw->osh;
@@ -3691,7 +3713,8 @@ bool wlc_bmac_validate_chip_access(struct wlc_hw_info *wlc_hw)
 	(void)R_REG(osh, &regs->objaddr);
 	val = R_REG(osh, &regs->objdata);
 	if (val != (u32) 0xaa5555aa) {
-		WL_ERROR(("wl%d: validate_chip_access: SHM = 0x%x, expected 0xaa5555aa\n", wlc_hw->unit, val));
+		WL_ERROR("wl%d: validate_chip_access: SHM = 0x%x, expected 0xaa5555aa\n",
+			 wlc_hw->unit, val);
 		return false;
 	}
 
@@ -3703,7 +3726,8 @@ bool wlc_bmac_validate_chip_access(struct wlc_hw_info *wlc_hw)
 	(void)R_REG(osh, &regs->objaddr);
 	val = R_REG(osh, &regs->objdata);
 	if (val != (u32) 0x55aaaa55) {
-		WL_ERROR(("wl%d: validate_chip_access: SHM = 0x%x, expected 0x55aaaa55\n", wlc_hw->unit, val));
+		WL_ERROR("wl%d: validate_chip_access: SHM = 0x%x, expected 0x55aaaa55\n",
+			 wlc_hw->unit, val);
 		return false;
 	}
 
@@ -3733,12 +3757,14 @@ bool wlc_bmac_validate_chip_access(struct wlc_hw_info *wlc_hw)
 		/* verify with the 16 bit registers that have no side effects */
 		val = R_REG(osh, &regs->tsf_cfpstrt_l);
 		if (val != (uint) 0xBBBB) {
-			WL_ERROR(("wl%d: validate_chip_access: tsf_cfpstrt_l = 0x%x, expected" " 0x%x\n", wlc_hw->unit, val, 0xBBBB));
+			WL_ERROR("wl%d: validate_chip_access: tsf_cfpstrt_l = 0x%x, expected 0x%x\n",
+				 wlc_hw->unit, val, 0xBBBB);
 			return false;
 		}
 		val = R_REG(osh, &regs->tsf_cfpstrt_h);
 		if (val != (uint) 0xCCCC) {
-			WL_ERROR(("wl%d: validate_chip_access: tsf_cfpstrt_h = 0x%x, expected" " 0x%x\n", wlc_hw->unit, val, 0xCCCC));
+			WL_ERROR("wl%d: validate_chip_access: tsf_cfpstrt_h = 0x%x, expected 0x%x\n",
+				 wlc_hw->unit, val, 0xCCCC);
 			return false;
 		}
 
@@ -3750,7 +3776,10 @@ bool wlc_bmac_validate_chip_access(struct wlc_hw_info *wlc_hw)
 	w = R_REG(osh, &regs->maccontrol);
 	if ((w != (MCTL_IHR_EN | MCTL_WAKE)) &&
 	    (w != (MCTL_IHR_EN | MCTL_GMODE | MCTL_WAKE))) {
-		WL_ERROR(("wl%d: validate_chip_access: maccontrol = 0x%x, expected 0x%x or 0x%x\n", wlc_hw->unit, w, (MCTL_IHR_EN | MCTL_WAKE), (MCTL_IHR_EN | MCTL_GMODE | MCTL_WAKE)));
+		WL_ERROR("wl%d: validate_chip_access: maccontrol = 0x%x, expected 0x%x or 0x%x\n",
+			 wlc_hw->unit, w,
+			 (MCTL_IHR_EN | MCTL_WAKE),
+			 (MCTL_IHR_EN | MCTL_GMODE | MCTL_WAKE));
 		return false;
 	}
 
@@ -3765,7 +3794,7 @@ void wlc_bmac_core_phypll_ctl(struct wlc_hw_info *wlc_hw, bool on)
 	struct osl_info *osh;
 	u32 tmp;
 
-	WL_TRACE(("wl%d: wlc_bmac_core_phypll_ctl\n", wlc_hw->unit));
+	WL_TRACE("wl%d: wlc_bmac_core_phypll_ctl\n", wlc_hw->unit);
 
 	tmp = 0;
 	regs = wlc_hw->regs;
@@ -3786,8 +3815,8 @@ void wlc_bmac_core_phypll_ctl(struct wlc_hw_info *wlc_hw, bool on)
 			tmp = R_REG(osh, &regs->clk_ctl_st);
 			if ((tmp & (CCS_ERSRC_AVAIL_HT)) !=
 			    (CCS_ERSRC_AVAIL_HT)) {
-				WL_ERROR(("%s: turn on PHY PLL failed\n",
-					  __func__));
+				WL_ERROR("%s: turn on PHY PLL failed\n",
+					 __func__);
 				ASSERT(0);
 			}
 		} else {
@@ -3804,8 +3833,8 @@ void wlc_bmac_core_phypll_ctl(struct wlc_hw_info *wlc_hw, bool on)
 			     (CCS_ERSRC_AVAIL_D11PLL | CCS_ERSRC_AVAIL_PHYPLL))
 			    !=
 			    (CCS_ERSRC_AVAIL_D11PLL | CCS_ERSRC_AVAIL_PHYPLL)) {
-				WL_ERROR(("%s: turn on PHY PLL failed\n",
-					  __func__));
+				WL_ERROR("%s: turn on PHY PLL failed\n",
+					 __func__);
 				ASSERT(0);
 			}
 		}
@@ -3822,7 +3851,7 @@ void wlc_coredisable(struct wlc_hw_info *wlc_hw)
 {
 	bool dev_gone;
 
-	WL_TRACE(("wl%d: %s\n", wlc_hw->unit, __func__));
+	WL_TRACE("wl%d: %s\n", wlc_hw->unit, __func__);
 
 	ASSERT(!wlc_hw->up);
 
@@ -3860,7 +3889,7 @@ void wlc_coredisable(struct wlc_hw_info *wlc_hw)
 /* power both the pll and external oscillator on/off */
 void wlc_bmac_xtal(struct wlc_hw_info *wlc_hw, bool want)
 {
-	WL_TRACE(("wl%d: wlc_bmac_xtal: want %d\n", wlc_hw->unit, want));
+	WL_TRACE("wl%d: wlc_bmac_xtal: want %d\n", wlc_hw->unit, want);
 
 	/* dont power down if plldown is false or we must poll hw radio disable */
 	if (!want && wlc_hw->pllreq)
@@ -3889,8 +3918,8 @@ static void wlc_flushqueues(struct wlc_info *wlc)
 		if (wlc_hw->di[i]) {
 			dma_txreclaim(wlc_hw->di[i], HNDDMA_RANGE_ALL);
 			TXPKTPENDCLR(wlc, i);
-			WL_TRACE(("wlc_flushqueues: pktpend fifo %d cleared\n",
-				  i));
+			WL_TRACE("wlc_flushqueues: pktpend fifo %d cleared\n",
+				 i);
 		}
 
 	/* free any posted rx packets */
@@ -4023,8 +4052,8 @@ wlc_bmac_copyfrom_objmem(struct wlc_hw_info *wlc_hw, uint offset, void *buf,
 
 void wlc_bmac_copyfrom_vars(struct wlc_hw_info *wlc_hw, char **buf, uint *len)
 {
-	WL_TRACE(("wlc_bmac_copyfrom_vars, nvram vars totlen=%d\n",
-		  wlc_hw->vars_size));
+	WL_TRACE("wlc_bmac_copyfrom_vars, nvram vars totlen=%d\n",
+		 wlc_hw->vars_size);
 
 	*buf = wlc_hw->vars;
 	*len = wlc_hw->vars_size;
@@ -4133,7 +4162,7 @@ void wlc_gpio_fast_deinit(struct wlc_hw_info *wlc_hw)
 		(wlc_hw->sih->buscorerev >= 13)))))
 		return;
 
-	WL_TRACE(("wl%d: %s\n", wlc_hw->unit, __func__));
+	WL_TRACE("wl%d: %s\n", wlc_hw->unit, __func__);
 	return;
 }
 
diff --git a/drivers/staging/brcm80211/sys/wlc_channel.c b/drivers/staging/brcm80211/sys/wlc_channel.c
index 33041e3..a35c152 100644
--- a/drivers/staging/brcm80211/sys/wlc_channel.c
+++ b/drivers/staging/brcm80211/sys/wlc_channel.c
@@ -567,8 +567,8 @@ struct chan20_info chan20_info[] = {
 const locale_info_t *wlc_get_locale_2g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_locale_2g_table)) {
-		WL_ERROR(("%s: locale 2g index size out of range %d\n",
-			  __func__, locale_idx));
+		WL_ERROR("%s: locale 2g index size out of range %d\n",
+			 __func__, locale_idx);
 		ASSERT(locale_idx < ARRAY_SIZE(g_locale_2g_table));
 		return NULL;
 	}
@@ -578,8 +578,8 @@ const locale_info_t *wlc_get_locale_2g(u8 locale_idx)
 const locale_info_t *wlc_get_locale_5g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_locale_5g_table)) {
-		WL_ERROR(("%s: locale 5g index size out of range %d\n",
-			  __func__, locale_idx));
+		WL_ERROR("%s: locale 5g index size out of range %d\n",
+			 __func__, locale_idx);
 		ASSERT(locale_idx < ARRAY_SIZE(g_locale_5g_table));
 		return NULL;
 	}
@@ -589,8 +589,8 @@ const locale_info_t *wlc_get_locale_5g(u8 locale_idx)
 const locale_mimo_info_t *wlc_get_mimo_2g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_mimo_2g_table)) {
-		WL_ERROR(("%s: mimo 2g index size out of range %d\n", __func__,
-			  locale_idx));
+		WL_ERROR("%s: mimo 2g index size out of range %d\n",
+			 __func__, locale_idx);
 		return NULL;
 	}
 	return g_mimo_2g_table[locale_idx];
@@ -599,8 +599,8 @@ const locale_mimo_info_t *wlc_get_mimo_2g(u8 locale_idx)
 const locale_mimo_info_t *wlc_get_mimo_5g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_mimo_5g_table)) {
-		WL_ERROR(("%s: mimo 5g index size out of range %d\n", __func__,
-			  locale_idx));
+		WL_ERROR("%s: mimo 5g index size out of range %d\n",
+			 __func__, locale_idx);
 		return NULL;
 	}
 	return g_mimo_5g_table[locale_idx];
@@ -614,11 +614,11 @@ wlc_cm_info_t *wlc_channel_mgr_attach(struct wlc_info *wlc)
 	struct wlc_pub *pub = wlc->pub;
 	char *ccode;
 
-	WL_TRACE(("wl%d: wlc_channel_mgr_attach\n", wlc->pub->unit));
+	WL_TRACE("wl%d: wlc_channel_mgr_attach\n", wlc->pub->unit);
 
 	wlc_cm = kzalloc(sizeof(wlc_cm_info_t), GFP_ATOMIC);
 	if (wlc_cm == NULL) {
-		WL_ERROR(("wl%d: %s: out of memory", pub->unit, __func__));
+		WL_ERROR("wl%d: %s: out of memory", pub->unit, __func__);
 		return NULL;
 	}
 	wlc_cm->pub = pub;
@@ -629,8 +629,9 @@ wlc_cm_info_t *wlc_channel_mgr_attach(struct wlc_info *wlc)
 	ccode = getvar(wlc->pub->vars, "ccode");
 	if (ccode) {
 		strncpy(wlc->pub->srom_ccode, ccode, WLC_CNTRY_BUF_SZ - 1);
-		WL_NONE(("%s: SROM country code is %c%c\n", __func__,
-			 wlc->pub->srom_ccode[0], wlc->pub->srom_ccode[1]));
+		WL_NONE("%s: SROM country code is %c%c\n",
+			__func__,
+			wlc->pub->srom_ccode[0], wlc->pub->srom_ccode[1]);
 	}
 
 	/* internal country information which must match regulatory constraints in firmware */
@@ -716,7 +717,9 @@ wlc_set_countrycode_rev(wlc_cm_info_t *wlc_cm,
 	char mapped_ccode[WLC_CNTRY_BUF_SZ];
 	uint mapped_regrev;
 
-	WL_NONE(("%s: (country_abbrev \"%s\", ccode \"%s\", regrev %d) SPROM \"%s\"/%u\n", __func__, country_abbrev, ccode, regrev, wlc_cm->srom_ccode, wlc_cm->srom_regrev));
+	WL_NONE("%s: (country_abbrev \"%s\", ccode \"%s\", regrev %d) SPROM \"%s\"/%u\n",
+		__func__, country_abbrev, ccode, regrev,
+		wlc_cm->srom_ccode, wlc_cm->srom_regrev);
 
 	/* if regrev is -1, lookup the mapped country code,
 	 * otherwise use the ccode and regrev directly
@@ -827,8 +830,8 @@ static const country_info_t *wlc_countrycode_map(wlc_cm_info_t *wlc_cm,
 
 	/* check for currently supported ccode size */
 	if (strlen(ccode) > (WLC_CNTRY_BUF_SZ - 1)) {
-		WL_ERROR(("wl%d: %s: ccode \"%s\" too long for match\n",
-			  wlc->pub->unit, __func__, ccode));
+		WL_ERROR("wl%d: %s: ccode \"%s\" too long for match\n",
+			 wlc->pub->unit, __func__, ccode);
 		return NULL;
 	}
 
@@ -843,7 +846,7 @@ static const country_info_t *wlc_countrycode_map(wlc_cm_info_t *wlc_cm,
 	if (!strcmp(srom_ccode, ccode)) {
 		*mapped_regrev = srom_regrev;
 		mapped = 0;
-		WL_ERROR(("srom_code == ccode %s\n", __func__));
+		WL_ERROR("srom_code == ccode %s\n", __func__);
 		ASSERT(0);
 	} else {
 		mapped =
@@ -895,7 +898,7 @@ static const country_info_t *wlc_country_lookup_direct(const char *ccode,
 		}
 	}
 
-	WL_ERROR(("%s: Returning NULL\n", __func__));
+	WL_ERROR("%s: Returning NULL\n", __func__);
 	ASSERT(0);
 	return NULL;
 }
@@ -974,7 +977,9 @@ static void wlc_channels_commit(wlc_cm_info_t *wlc_cm)
 	if (chan == INVCHANNEL) {
 		/* country/locale with no valid channels, set the radio disable bit */
 		mboolset(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
-		WL_ERROR(("wl%d: %s: no valid channel for \"%s\" nbands %d bandlocked %d\n", wlc->pub->unit, __func__, wlc_cm->country_abbrev, NBANDS(wlc), wlc->bandlocked));
+		WL_ERROR("wl%d: %s: no valid channel for \"%s\" nbands %d bandlocked %d\n",
+			 wlc->pub->unit, __func__,
+			 wlc_cm->country_abbrev, NBANDS(wlc), wlc->bandlocked);
 	} else
 	    if (mboolisset(wlc->pub->radio_disabled,
 		WL_RADIO_COUNTRY_DISABLE)) {
@@ -1538,8 +1543,8 @@ wlc_valid_chanspec_ext(wlc_cm_info_t *wlc_cm, chanspec_t chspec, bool dualband)
 
 	/* check the chanspec */
 	if (wf_chspec_malformed(chspec)) {
-		WL_ERROR(("wl%d: malformed chanspec 0x%x\n", wlc->pub->unit,
-			  chspec));
+		WL_ERROR("wl%d: malformed chanspec 0x%x\n",
+			 wlc->pub->unit, chspec);
 		ASSERT(0);
 		return false;
 	}
diff --git a/drivers/staging/brcm80211/sys/wlc_event.c b/drivers/staging/brcm80211/sys/wlc_event.c
index 9b503d8..dabd709 100644
--- a/drivers/staging/brcm80211/sys/wlc_event.c
+++ b/drivers/staging/brcm80211/sys/wlc_event.c
@@ -75,8 +75,8 @@ wlc_eventq_t *wlc_eventq_attach(struct wlc_pub *pub, struct wlc_info *wlc,
 
 	eq->timer = wl_init_timer(eq->wl, wlc_timer_cb, eq, "eventq");
 	if (!eq->timer) {
-		WL_ERROR(("wl%d: wlc_eventq_attach: timer failed\n",
-			  pub->unit));
+		WL_ERROR("wl%d: wlc_eventq_attach: timer failed\n",
+			 pub->unit);
 		kfree(eq);
 		return NULL;
 	}
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index 8a89b5f..1d5d01a 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -306,7 +306,7 @@ void wlc_get_rcmta(struct wlc_info *wlc, int idx, struct ether_addr *addr)
 	u32 v32;
 	struct osl_info *osh;
 
-	WL_TRACE(("wl%d: %s\n", WLCWLUNIT(wlc), __func__));
+	WL_TRACE("wl%d: %s\n", WLCWLUNIT(wlc), __func__);
 
 	ASSERT(wlc->pub->corerev > 4);
 
@@ -364,7 +364,7 @@ bool wlc_ps_allowed(struct wlc_info *wlc)
 
 void wlc_reset(struct wlc_info *wlc)
 {
-	WL_TRACE(("wl%d: wlc_reset\n", wlc->pub->unit));
+	WL_TRACE("wl%d: wlc_reset\n", wlc->pub->unit);
 
 	wlc->check_for_unaligned_tbtt = false;
 
@@ -385,7 +385,7 @@ void wlc_reset(struct wlc_info *wlc)
 
 void wlc_fatal_error(struct wlc_info *wlc)
 {
-	WL_ERROR(("wl%d: fatal error, reinitializing\n", wlc->pub->unit));
+	WL_ERROR("wl%d: fatal error, reinitializing\n", wlc->pub->unit);
 	wl_init(wlc->wl);
 }
 
@@ -426,7 +426,7 @@ void wlc_init(struct wlc_info *wlc)
 	wlc_bsscfg_t *bsscfg;
 	bool mute = false;
 
-	WL_TRACE(("wl%d: wlc_init\n", wlc->pub->unit));
+	WL_TRACE("wl%d: wlc_init\n", wlc->pub->unit);
 
 	regs = wlc->regs;
 
@@ -605,8 +605,8 @@ bool wlc_ps_check(struct wlc_info *wlc)
 		 * to avoid assert
 		 */
 		if (tmp == 0xffffffff) {
-			WL_ERROR(("wl%d: %s: dead chip\n", wlc->pub->unit,
-				  __func__));
+			WL_ERROR("wl%d: %s: dead chip\n",
+				 wlc->pub->unit, __func__);
 			return DEVICEREMOVED(wlc);
 		}
 
@@ -615,7 +615,8 @@ bool wlc_ps_check(struct wlc_info *wlc)
 		if (hps != ((tmp & MCTL_HPS) != 0)) {
 			int idx;
 			wlc_bsscfg_t *cfg;
-			WL_ERROR(("wl%d: hps not sync, sw %d, maccontrol 0x%x\n", wlc->pub->unit, hps, tmp));
+			WL_ERROR("wl%d: hps not sync, sw %d, maccontrol 0x%x\n",
+				 wlc->pub->unit, hps, tmp);
 			FOREACH_BSS(wlc, idx, cfg) {
 				if (!BSSCFG_STA(cfg))
 					continue;
@@ -629,7 +630,8 @@ bool wlc_ps_check(struct wlc_info *wlc)
 		wake = STAY_AWAKE(wlc) || wlc->hw->wake_override;
 		wake_ok = (wake == ((tmp & MCTL_WAKE) != 0));
 		if (hps && !wake_ok) {
-			WL_ERROR(("wl%d: wake not sync, sw %d maccontrol 0x%x\n", wlc->pub->unit, wake, tmp));
+			WL_ERROR("wl%d: wake not sync, sw %d maccontrol 0x%x\n",
+				 wlc->pub->unit, wake, tmp);
 			res = false;
 		}
 	}
@@ -647,8 +649,8 @@ void wlc_set_ps_ctrl(struct wlc_info *wlc)
 	hps = PS_ALLOWED(wlc);
 	wake = hps ? (STAY_AWAKE(wlc)) : true;
 
-	WL_TRACE(("wl%d: wlc_set_ps_ctrl: hps %d wake %d\n", wlc->pub->unit,
-		  hps, wake));
+	WL_TRACE("wl%d: wlc_set_ps_ctrl: hps %d wake %d\n",
+		 wlc->pub->unit, hps, wake);
 
 	v1 = R_REG(wlc->osh, &wlc->regs->maccontrol);
 	v2 = 0;
@@ -806,8 +808,8 @@ void wlc_set_chanspec(struct wlc_info *wlc, chanspec_t chanspec)
 	chanspec_t old_chanspec = wlc->chanspec;
 
 	if (!wlc_valid_chanspec_db(wlc->cmi, chanspec)) {
-		WL_ERROR(("wl%d: %s: Bad channel %d\n",
-			  wlc->pub->unit, __func__, CHSPEC_CHANNEL(chanspec)));
+		WL_ERROR("wl%d: %s: Bad channel %d\n",
+			 wlc->pub->unit, __func__, CHSPEC_CHANNEL(chanspec));
 		ASSERT(wlc_valid_chanspec_db(wlc->cmi, chanspec));
 		return;
 	}
@@ -818,7 +820,9 @@ void wlc_set_chanspec(struct wlc_info *wlc, chanspec_t chanspec)
 		if (wlc->band->bandunit != bandunit || wlc->bandinit_pending) {
 			switchband = true;
 			if (wlc->bandlocked) {
-				WL_ERROR(("wl%d: %s: chspec %d band is locked!\n", wlc->pub->unit, __func__, CHSPEC_CHANNEL(chanspec)));
+				WL_ERROR("wl%d: %s: chspec %d band is locked!\n",
+					 wlc->pub->unit, __func__,
+					 CHSPEC_CHANNEL(chanspec));
 				return;
 			}
 			/* BMAC_NOTE: should the setband call come after the wlc_bmac_chanspec() ?
@@ -1120,7 +1124,7 @@ void wlc_beacon_phytxctl_txant_upd(struct wlc_info *wlc, ratespec_t bcn_rspec)
 */
 void wlc_protection_upd(struct wlc_info *wlc, uint idx, int val)
 {
-	WL_TRACE(("wlc_protection_upd: idx %d, val %d\n", idx, val));
+	WL_TRACE("wlc_protection_upd: idx %d, val %d\n", idx, val);
 
 	switch (idx) {
 	case WLC_PROT_G_SPEC:
@@ -1228,7 +1232,7 @@ static void wlc_bandinit_ordered(struct wlc_info *wlc, chanspec_t chanspec)
 	uint parkband;
 	uint i, band_order[2];
 
-	WL_TRACE(("wl%d: wlc_bandinit_ordered\n", wlc->pub->unit));
+	WL_TRACE("wl%d: wlc_bandinit_ordered\n", wlc->pub->unit);
 	/*
 	 * We might have been bandlocked during down and the chip power-cycled (hibernate).
 	 * figure out the right band to park on
@@ -1271,8 +1275,8 @@ static void wlc_bandinit_ordered(struct wlc_info *wlc, chanspec_t chanspec)
 /* band-specific init */
 static void WLBANDINITFN(wlc_bsinit) (struct wlc_info *wlc)
 {
-	WL_TRACE(("wl%d: wlc_bsinit: bandunit %d\n", wlc->pub->unit,
-		  wlc->band->bandunit));
+	WL_TRACE("wl%d: wlc_bsinit: bandunit %d\n",
+		 wlc->pub->unit, wlc->band->bandunit);
 
 	/* write ucode ACK/CTS rate table */
 	wlc_set_ratetable(wlc);
@@ -1348,7 +1352,7 @@ void wlc_wme_setparams(struct wlc_info *wlc, u16 aci, void *arg, bool suspend)
 
 	/* Only apply params if the core is out of reset and has clocks */
 	if (!wlc->clk) {
-		WL_ERROR(("wl%d: %s : no-clock\n", wlc->pub->unit, __func__));
+		WL_ERROR("wl%d: %s : no-clock\n", wlc->pub->unit, __func__);
 		return;
 	}
 
@@ -1380,8 +1384,8 @@ void wlc_wme_setparams(struct wlc_info *wlc, u16 aci, void *arg, bool suspend)
 
 		if (acp_shm.aifs < EDCF_AIFSN_MIN
 		    || acp_shm.aifs > EDCF_AIFSN_MAX) {
-			WL_ERROR(("wl%d: wlc_edcf_setparams: bad aifs %d\n",
-				  wlc->pub->unit, acp_shm.aifs));
+			WL_ERROR("wl%d: wlc_edcf_setparams: bad aifs %d\n",
+				 wlc->pub->unit, acp_shm.aifs);
 			continue;
 		}
 
@@ -1464,8 +1468,8 @@ void wlc_edcf_setparams(wlc_bsscfg_t *cfg, bool suspend)
 
 		if (acp_shm.aifs < EDCF_AIFSN_MIN
 		    || acp_shm.aifs > EDCF_AIFSN_MAX) {
-			WL_ERROR(("wl%d: wlc_edcf_setparams: bad aifs %d\n",
-				  wlc->pub->unit, acp_shm.aifs));
+			WL_ERROR("wl%d: wlc_edcf_setparams: bad aifs %d\n",
+				 wlc->pub->unit, acp_shm.aifs);
 			continue;
 		}
 
@@ -1512,15 +1516,14 @@ bool wlc_timers_init(struct wlc_info *wlc, int unit)
 	wlc->wdtimer = wl_init_timer(wlc->wl, wlc_watchdog_by_timer,
 		wlc, "watchdog");
 	if (!wlc->wdtimer) {
-		WL_ERROR(("wl%d:  wl_init_timer for wdtimer failed\n", unit));
+		WL_ERROR("wl%d:  wl_init_timer for wdtimer failed\n", unit);
 		goto fail;
 	}
 
 	wlc->radio_timer = wl_init_timer(wlc->wl, wlc_radio_timer,
 		wlc, "radio");
 	if (!wlc->radio_timer) {
-		WL_ERROR(("wl%d:  wl_init_timer for radio_timer failed\n",
-			  unit));
+		WL_ERROR("wl%d:  wl_init_timer for radio_timer failed\n", unit);
 		goto fail;
 	}
 
@@ -1667,15 +1670,14 @@ static uint wlc_attach_module(struct wlc_info *wlc)
 
 	wlc->asi = wlc_antsel_attach(wlc, wlc->osh, wlc->pub, wlc->hw);
 	if (wlc->asi == NULL) {
-		WL_ERROR(("wl%d: wlc_attach: wlc_antsel_attach failed\n",
-			  unit));
+		WL_ERROR("wl%d: wlc_attach: wlc_antsel_attach failed\n", unit);
 		err = 44;
 		goto fail;
 	}
 
 	wlc->ampdu = wlc_ampdu_attach(wlc);
 	if (wlc->ampdu == NULL) {
-		WL_ERROR(("wl%d: wlc_attach: wlc_ampdu_attach failed\n", unit));
+		WL_ERROR("wl%d: wlc_attach: wlc_ampdu_attach failed\n", unit);
 		err = 50;
 		goto fail;
 	}
@@ -1684,13 +1686,13 @@ static uint wlc_attach_module(struct wlc_info *wlc)
 	wlc->eventq =
 	    wlc_eventq_attach(wlc->pub, wlc, wlc->wl, wlc_process_eventq);
 	if (wlc->eventq == NULL) {
-		WL_ERROR(("wl%d: wlc_attach: wlc_eventq_attachfailed\n", unit));
+		WL_ERROR("wl%d: wlc_attach: wlc_eventq_attachfailed\n", unit);
 		err = 57;
 		goto fail;
 	}
 
 	if ((wlc_stf_attach(wlc) != 0)) {
-		WL_ERROR(("wl%d: wlc_attach: wlc_stf_attach failed\n", unit));
+		WL_ERROR("wl%d: wlc_attach: wlc_stf_attach failed\n", unit);
 		err = 68;
 		goto fail;
 	}
@@ -1719,8 +1721,8 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	wlc_txq_info_t *qi;
 	uint n_disabled;
 
-	WL_NONE(("wl%d: %s: vendor 0x%x device 0x%x\n", unit, __func__, vendor,
-		 device));
+	WL_NONE("wl%d: %s: vendor 0x%x device 0x%x\n",
+		unit, __func__, vendor, device);
 
 	ASSERT(WSEC_MAX_RCMTA_KEYS <= WSEC_MAX_KEYS);
 	ASSERT(WSEC_MAX_DEFAULT_KEYS == WLC_DEFAULT_KEYS);
@@ -1897,7 +1899,7 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 		goto fail;
 
 	if (!wlc_timers_init(wlc, unit)) {
-		WL_ERROR(("wl%d: %s: wlc_init_timer failed\n", unit, __func__));
+		WL_ERROR("wl%d: %s: wlc_init_timer failed\n", unit, __func__);
 		err = 32;
 		goto fail;
 	}
@@ -1905,8 +1907,8 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	/* depend on rateset, gmode */
 	wlc->cmi = wlc_channel_mgr_attach(wlc);
 	if (!wlc->cmi) {
-		WL_ERROR(("wl%d: %s: wlc_channel_mgr_attach failed\n", unit,
-			  __func__));
+		WL_ERROR("wl%d: %s: wlc_channel_mgr_attach failed\n",
+			 unit, __func__);
 		err = 33;
 		goto fail;
 	}
@@ -1921,8 +1923,8 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	/* allocate our initial queue */
 	qi = wlc_txq_alloc(wlc, osh);
 	if (qi == NULL) {
-		WL_ERROR(("wl%d: %s: failed to malloc tx queue\n", unit,
-			  __func__));
+		WL_ERROR("wl%d: %s: failed to malloc tx queue\n",
+			 unit, __func__);
 		err = 100;
 		goto fail;
 	}
@@ -2008,7 +2010,7 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	return (void *)wlc;
 
  fail:
-	WL_ERROR(("wl%d: %s: failed with err %d\n", unit, __func__, err));
+	WL_ERROR("wl%d: %s: failed with err %d\n", unit, __func__, err);
 	if (wlc)
 		wlc_detach(wlc);
 
@@ -2026,7 +2028,8 @@ static void wlc_attach_antgain_init(struct wlc_info *wlc)
 		/* default antenna gain for srom rev 1 is 2 dBm (8 qdbm) */
 		wlc->band->antgain = 8;
 	} else if (wlc->band->antgain == -1) {
-		WL_ERROR(("wl%d: %s: Invalid antennas available in srom, using 2dB\n", unit, __func__));
+		WL_ERROR("wl%d: %s: Invalid antennas available in srom, using 2dB\n",
+			 unit, __func__);
 		wlc->band->antgain = 8;
 	} else {
 		s8 gain, fract;
@@ -2065,7 +2068,8 @@ static bool wlc_attach_stf_ant_init(struct wlc_info *wlc)
 		aa = (s8) getintvar(vars,
 				      (BAND_5G(bandtype) ? "aa1" : "aa0"));
 	if ((aa < 1) || (aa > 15)) {
-		WL_ERROR(("wl%d: %s: Invalid antennas available in srom (0x%x), using 3.\n", unit, __func__, aa));
+		WL_ERROR("wl%d: %s: Invalid antennas available in srom (0x%x), using 3\n",
+			 unit, __func__, aa);
 		aa = 3;
 	}
 
@@ -2132,7 +2136,7 @@ uint wlc_detach(struct wlc_info *wlc)
 	if (wlc == NULL)
 		return 0;
 
-	WL_TRACE(("wl%d: %s\n", wlc->pub->unit, __func__));
+	WL_TRACE("wl%d: %s\n", wlc->pub->unit, __func__);
 
 	ASSERT(!wlc->pub->up);
 
@@ -2340,7 +2344,7 @@ static void wlc_radio_timer(void *arg)
 	struct wlc_info *wlc = (struct wlc_info *) arg;
 
 	if (DEVICEREMOVED(wlc)) {
-		WL_ERROR(("wl%d: %s: dead chip\n", wlc->pub->unit, __func__));
+		WL_ERROR("wl%d: %s: dead chip\n", wlc->pub->unit, __func__);
 		wl_down(wlc->wl);
 		return;
 	}
@@ -2441,13 +2445,13 @@ static void wlc_watchdog(void *arg)
 	int i;
 	wlc_bsscfg_t *cfg;
 
-	WL_TRACE(("wl%d: wlc_watchdog\n", wlc->pub->unit));
+	WL_TRACE("wl%d: wlc_watchdog\n", wlc->pub->unit);
 
 	if (!wlc->pub->up)
 		return;
 
 	if (DEVICEREMOVED(wlc)) {
-		WL_ERROR(("wl%d: %s: dead chip\n", wlc->pub->unit, __func__));
+		WL_ERROR("wl%d: %s: dead chip\n", wlc->pub->unit, __func__);
 		wl_down(wlc->wl);
 		return;
 	}
@@ -2519,7 +2523,7 @@ static void wlc_watchdog(void *arg)
 /* make interface operational */
 int wlc_up(struct wlc_info *wlc)
 {
-	WL_TRACE(("wl%d: %s:\n", wlc->pub->unit, __func__));
+	WL_TRACE("wl%d: %s:\n", wlc->pub->unit, __func__);
 
 	/* HW is turned off so don't try to access it */
 	if (wlc->pub->hw_off || DEVICEREMOVED(wlc))
@@ -2564,7 +2568,8 @@ int wlc_up(struct wlc_info *wlc)
 					if (!BSSCFG_STA(bsscfg)
 					    || !bsscfg->enable || !bsscfg->BSS)
 						continue;
-					WL_ERROR(("wl%d.%d: wlc_up: rfdisable -> " "wlc_bsscfg_disable()\n", wlc->pub->unit, idx));
+					WL_ERROR("wl%d.%d: wlc_up: rfdisable -> " "wlc_bsscfg_disable()\n",
+						 wlc->pub->unit, idx);
 				}
 			}
 		} else
@@ -2664,12 +2669,12 @@ uint wlc_down(struct wlc_info *wlc)
 	bool dev_gone = false;
 	wlc_txq_info_t *qi;
 
-	WL_TRACE(("wl%d: %s:\n", wlc->pub->unit, __func__));
+	WL_TRACE("wl%d: %s:\n", wlc->pub->unit, __func__);
 
 	/* check if we are already in the going down path */
 	if (wlc->going_down) {
-		WL_ERROR(("wl%d: %s: Driver going down so return\n",
-			  wlc->pub->unit, __func__));
+		WL_ERROR("wl%d: %s: Driver going down so return\n",
+			 wlc->pub->unit, __func__);
 		return 0;
 	}
 	if (!wlc->pub->up)
@@ -2728,8 +2733,8 @@ uint wlc_down(struct wlc_info *wlc)
 
 	/* Verify all packets are flushed from the driver */
 	if (wlc->osh->pktalloced != 0) {
-		WL_ERROR(("%d packets not freed at wlc_down!!!!!!\n",
-			  wlc->osh->pktalloced));
+		WL_ERROR("%d packets not freed at wlc_down!!!!!!\n",
+			 wlc->osh->pktalloced);
 	}
 #ifdef BCMDBG
 	/* Since all the packets should have been freed,
@@ -2826,8 +2831,8 @@ int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config)
 
 	default:
 		/* Error */
-		WL_ERROR(("wl%d: %s: invalid gmode %d\n", wlc->pub->unit,
-			  __func__, gmode));
+		WL_ERROR("wl%d: %s: invalid gmode %d\n",
+			 wlc->pub->unit, __func__, gmode);
 		return BCME_UNSUPPORTED;
 	}
 
@@ -3082,7 +3087,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 	/* If the device is turned off, then it's not "removed" */
 	if (!wlc->pub->hw_off && DEVICEREMOVED(wlc)) {
-		WL_ERROR(("wl%d: %s: dead chip\n", wlc->pub->unit, __func__));
+		WL_ERROR("wl%d: %s: dead chip\n", wlc->pub->unit, __func__);
 		wl_down(wlc->wl);
 		return BCME_ERROR;
 	}
@@ -3102,8 +3107,8 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	bool_val = val != 0;
 
 	if (cmd != WLC_SET_CHANNEL)
-		WL_NONE(("WLC_IOCTL: cmd %d val 0x%x (%d) len %d\n", cmd,
-			 (uint) val, val, len));
+		WL_NONE("WLC_IOCTL: cmd %d val 0x%x (%d) len %d\n",
+			cmd, (uint)val, val, len);
 
 	bcmerror = 0;
 	regs = wlc->regs;
@@ -3123,8 +3128,8 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 	default:
 		if ((arg == NULL) || (len <= 0)) {
-			WL_ERROR(("wl%d: %s: Command %d needs arguments\n",
-				  wlc->pub->unit, __func__, cmd));
+			WL_ERROR("wl%d: %s: Command %d needs arguments\n",
+				 wlc->pub->unit, __func__, cmd);
 			bcmerror = BCME_BADARG;
 			goto done;
 		}
@@ -3457,8 +3462,8 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			/* 4322 supports antdiv in phy, no need to set it to ucode */
 			if (WLCISNPHY(wlc->band)
 			    && D11REV_IS(wlc->pub->corerev, 16)) {
-				WL_ERROR(("wl%d: can't set ucantdiv for 4322\n",
-					  wlc->pub->unit));
+				WL_ERROR("wl%d: can't set ucantdiv for 4322\n",
+					 wlc->pub->unit);
 				bcmerror = BCME_UNSUPPORTED;
 			} else
 				wlc_mhf(wlc, MHF1, MHF1_ANTDIV,
@@ -3555,8 +3560,8 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			if ((radiomask == 0) || (radiomask & ~validbits)
 			    || (radioval & ~validbits)
 			    || ((radioval & ~radiomask) != 0)) {
-				WL_ERROR(("SET_RADIO with wrong bits 0x%x\n",
-					  val));
+				WL_ERROR("SET_RADIO with wrong bits 0x%x\n",
+					 val);
 				bcmerror = BCME_RANGE;
 				break;
 			}
@@ -4192,7 +4197,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 #endif
 
 	case WLC_LAST:
-		WL_ERROR(("%s: WLC_LAST\n", __func__));
+		WL_ERROR("%s: WLC_LAST\n", __func__);
 	}
  done:
 
@@ -4402,8 +4407,8 @@ wlc_iovar_op(struct wlc_info *wlc, const char *name,
 
 	if (!set && (len == sizeof(int)) &&
 	    !(IS_ALIGNED((unsigned long)(arg), (uint) sizeof(int)))) {
-		WL_ERROR(("wl%d: %s unaligned get ptr for %s\n",
-			  wlc->pub->unit, __func__, name));
+		WL_ERROR("wl%d: %s unaligned get ptr for %s\n",
+			 wlc->pub->unit, __func__, name);
 		ASSERT(0);
 	}
 
@@ -4530,7 +4535,7 @@ wlc_doiovar(void *hdl, const bcm_iovar_t *vi, u32 actionid,
 	bool bool_val2;
 	wlc_bss_info_t *current_bss;
 
-	WL_TRACE(("wl%d: %s\n", wlc->pub->unit, __func__));
+	WL_TRACE("wl%d: %s\n", wlc->pub->unit, __func__);
 
 	bsscfg = NULL;
 	current_bss = NULL;
@@ -4553,8 +4558,8 @@ wlc_doiovar(void *hdl, const bcm_iovar_t *vi, u32 actionid,
 	bool_val = (int_val != 0) ? true : false;
 	bool_val2 = (int_val2 != 0) ? true : false;
 
-	WL_TRACE(("wl%d: %s: id %d\n", wlc->pub->unit, __func__,
-		  IOV_ID(actionid)));
+	WL_TRACE("wl%d: %s: id %d\n",
+		 wlc->pub->unit, __func__, IOV_ID(actionid));
 	/* Do the actual parameter implementation */
 	switch (actionid) {
 
@@ -4612,7 +4617,7 @@ wlc_doiovar(void *hdl, const bcm_iovar_t *vi, u32 actionid,
 		break;
 
 	default:
-		WL_ERROR(("wl%d: %s: unsupported\n", wlc->pub->unit, __func__));
+		WL_ERROR("wl%d: %s: unsupported\n", wlc->pub->unit, __func__);
 		err = BCME_UNSUPPORTED;
 		break;
 	}
@@ -4747,8 +4752,8 @@ void wlc_statsupd(struct wlc_info *wlc)
 	/* check for rx fifo 0 overflow */
 	delta = (u16) (wlc->core->macstat_snapshot->rxf0ovfl - rxf0ovfl);
 	if (delta)
-		WL_ERROR(("wl%d: %u rx fifo 0 overflows!\n", wlc->pub->unit,
-			  delta));
+		WL_ERROR("wl%d: %u rx fifo 0 overflows!\n",
+			 wlc->pub->unit, delta);
 
 	/* check for tx fifo underflows */
 	for (i = 0; i < NFIFO; i++) {
@@ -4756,8 +4761,8 @@ void wlc_statsupd(struct wlc_info *wlc)
 		    (u16) (wlc->core->macstat_snapshot->txfunfl[i] -
 			      txfunfl[i]);
 		if (delta)
-			WL_ERROR(("wl%d: %u tx fifo %d underflows!\n",
-				  wlc->pub->unit, delta, i));
+			WL_ERROR("wl%d: %u tx fifo %d underflows!\n",
+				 wlc->pub->unit, delta, i);
 	}
 #endif				/* BCMDBG */
 
@@ -4806,7 +4811,7 @@ void wlc_statsupd(struct wlc_info *wlc)
 bool wlc_chipmatch(u16 vendor, u16 device)
 {
 	if (vendor != VENDOR_BROADCOM) {
-		WL_ERROR(("wlc_chipmatch: unknown vendor id %04x\n", vendor));
+		WL_ERROR("wlc_chipmatch: unknown vendor id %04x\n", vendor);
 		return false;
 	}
 
@@ -4818,7 +4823,7 @@ bool wlc_chipmatch(u16 vendor, u16 device)
 	if ((device == BCM43236_D11N_ID) || (device == BCM43236_D11N2G_ID))
 		return true;
 
-	WL_ERROR(("wlc_chipmatch: unknown device id %04x\n", device));
+	WL_ERROR("wlc_chipmatch: unknown device id %04x\n", device);
 	return false;
 }
 
@@ -5009,8 +5014,8 @@ wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
 		p = pktq_peek_tail(q, &eprec);
 		ASSERT(p != NULL);
 		if (eprec > prec) {
-			WL_ERROR(("%s: Failing: eprec %d > prec %d\n", __func__,
-				  eprec, prec));
+			WL_ERROR("%s: Failing: eprec %d > prec %d\n",
+				 __func__, eprec, prec);
 			return false;
 		}
 	}
@@ -5026,8 +5031,8 @@ wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
 
 		/* Refuse newer packet unless configured to discard oldest */
 		if (eprec == prec && !discard_oldest) {
-			WL_ERROR(("%s: No where to go, prec == %d\n", __func__,
-				  prec));
+			WL_ERROR("%s: No where to go, prec == %d\n",
+				 __func__, prec);
 			return false;
 		}
 
@@ -5075,8 +5080,8 @@ void BCMFASTPATH wlc_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 	if (!wlc_prec_enq(wlc, q, sdu, prec)) {
 		if (!EDCF_ENAB(wlc->pub)
 		    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL))
-			WL_ERROR(("wl%d: wlc_txq_enq: txq overflow\n",
-				  wlc->pub->unit));
+			WL_ERROR("wl%d: wlc_txq_enq: txq overflow\n",
+				 wlc->pub->unit);
 
 		/* ASSERT(9 == 8); *//* XXX we might hit this condtion in case packet flooding from mac80211 stack */
 		pkt_buf_free_skb(wlc->osh, sdu, true);
@@ -5252,8 +5257,8 @@ wlc_txfifo(struct wlc_info *wlc, uint fifo, struct sk_buff *p, bool commit,
 	 */
 	if (commit) {
 		TXPKTPENDINC(wlc, fifo, txpktpend);
-		WL_TRACE(("wlc_txfifo, pktpend inc %d to %d\n", txpktpend,
-			  TXPKTPENDGET(wlc, fifo)));
+		WL_TRACE("wlc_txfifo, pktpend inc %d to %d\n",
+			 txpktpend, TXPKTPENDGET(wlc, fifo));
 	}
 
 	/* Commit BCMC sequence number in the SHM frame ID location */
@@ -5261,7 +5266,7 @@ wlc_txfifo(struct wlc_info *wlc, uint fifo, struct sk_buff *p, bool commit,
 		BCMCFID(wlc, frameid);
 
 	if (dma_txfast(wlc->hw->di[fifo], p, commit) < 0) {
-		WL_ERROR(("wlc_txfifo: fatal, toss frames !!!\n"));
+		WL_ERROR("wlc_txfifo: fatal, toss frames !!!\n");
 	}
 }
 
@@ -5301,7 +5306,8 @@ wlc_compute_airtime(struct wlc_info *wlc, ratespec_t rspec, uint length)
 			usec = (length << 3) / 11;
 			break;
 		default:
-			WL_ERROR(("wl%d: wlc_compute_airtime: unsupported rspec 0x%x\n", wlc->pub->unit, rspec));
+			WL_ERROR("wl%d: wlc_compute_airtime: unsupported rspec 0x%x\n",
+				 wlc->pub->unit, rspec);
 			ASSERT((const char *)"Bad phy_rate" == NULL);
 			break;
 		}
@@ -5397,7 +5403,7 @@ static void wlc_cck_plcp_set(int rate_500, uint length, u8 *plcp)
 		break;
 
 	default:
-		WL_ERROR(("wlc_cck_plcp_set: unsupported rate %d\n", rate_500));
+		WL_ERROR("wlc_cck_plcp_set: unsupported rate %d\n", rate_500);
 		rate_500 = WLC_RATE_1M;
 		usec = length << 3;
 		break;
@@ -5537,7 +5543,8 @@ u16 BCMFASTPATH wlc_phytxctl1_calc(struct wlc_info *wlc, ratespec_t rspec)
 		bw = RSPEC_GET_BW(rspec);
 		/* 10Mhz is not supported yet */
 		if (bw < PHY_TXC1_BW_20MHZ) {
-			WL_ERROR(("wlc_phytxctl1_calc: bw %d is not supported yet, set to 20L\n", bw));
+			WL_ERROR("wlc_phytxctl1_calc: bw %d is not supported yet, set to 20L\n",
+				 bw);
 			bw = PHY_TXC1_BW_20MHZ;
 		}
 
@@ -5562,7 +5569,7 @@ u16 BCMFASTPATH wlc_phytxctl1_calc(struct wlc_info *wlc, ratespec_t rspec)
 		/* get the phyctl byte from rate phycfg table */
 		phycfg = wlc_rate_legacy_phyctl(RSPEC2RATE(rspec));
 		if (phycfg == -1) {
-			WL_ERROR(("wlc_phytxctl1_calc: wrong legacy OFDM/CCK rate\n"));
+			WL_ERROR("wlc_phytxctl1_calc: wrong legacy OFDM/CCK rate\n");
 			ASSERT(0);
 			phycfg = 0;
 		}
@@ -5722,8 +5729,8 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 		/* non-AP STA should never use BCMC queue */
 		ASSERT(queue != TX_BCMC_FIFO);
 		if (queue == TX_BCMC_FIFO) {
-			WL_ERROR(("wl%d: %s: ASSERT queue == TX_BCMC!\n",
-				  WLCWLUNIT(wlc), __func__));
+			WL_ERROR("wl%d: %s: ASSERT queue == TX_BCMC!\n",
+				 WLCWLUNIT(wlc), __func__);
 			frameid = bcmc_fid_generate(wlc, NULL, txh);
 		} else {
 			/* Increment the counter for first fragment */
@@ -5901,7 +5908,8 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 
 			if ((txrate[k]->flags & IEEE80211_TX_RC_MCS)
 			    && (!IS_MCS(rspec[k]))) {
-				WL_ERROR(("wl%d: %s: IEEE80211_TX_RC_MCS != IS_MCS(rspec)\n", WLCWLUNIT(wlc), __func__));
+				WL_ERROR("wl%d: %s: IEEE80211_TX_RC_MCS != IS_MCS(rspec)\n",
+					 WLCWLUNIT(wlc), __func__);
 				ASSERT(0 && "Rate mismatch");
 			}
 
@@ -6295,12 +6303,16 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 					}
 				}
 			} else
-				WL_ERROR(("wl%d: %s txop invalid for rate %d\n",
-					  wlc->pub->unit, fifo_names[queue],
-					  RSPEC2RATE(rspec[0])));
+				WL_ERROR("wl%d: %s txop invalid for rate %d\n",
+					 wlc->pub->unit, fifo_names[queue],
+					 RSPEC2RATE(rspec[0]));
 
 			if (dur > wlc->edcf_txop[ac])
-				WL_ERROR(("wl%d: %s: %s txop exceeded phylen %d/%d dur %d/%d\n", wlc->pub->unit, __func__, fifo_names[queue], phylen, wlc->fragthresh[queue], dur, wlc->edcf_txop[ac]));
+				WL_ERROR("wl%d: %s: %s txop exceeded phylen %d/%d dur %d/%d\n",
+					 wlc->pub->unit, __func__,
+					 fifo_names[queue],
+					 phylen, wlc->fragthresh[queue],
+					 dur, wlc->edcf_txop[ac]);
 		}
 	}
 
@@ -6406,8 +6418,8 @@ void wlc_high_dpc(struct wlc_info *wlc, u32 macintstatus)
 	if (macintstatus & ~(MI_TBTT | MI_TXSTOP)) {
 		bcm_format_flags(int_flags, macintstatus, flagstr,
 				 sizeof(flagstr));
-		WL_TRACE(("wl%d: macintstatus 0x%x %s\n", wlc->pub->unit,
-			  macintstatus, flagstr));
+		WL_TRACE("wl%d: macintstatus 0x%x %s\n",
+			 wlc->pub->unit, macintstatus, flagstr);
 	}
 #endif				/* BCMDBG */
 
@@ -6422,7 +6434,8 @@ void wlc_high_dpc(struct wlc_info *wlc, u32 macintstatus)
 		wlc_tbtt(wlc, regs);
 
 	if (macintstatus & MI_GP0) {
-		WL_ERROR(("wl%d: PSM microcode watchdog fired at %d (seconds). Resetting.\n", wlc->pub->unit, wlc->pub->now));
+		WL_ERROR("wl%d: PSM microcode watchdog fired at %d (seconds). Resetting.\n",
+			 wlc->pub->unit, wlc->pub->now);
 
 		printk_once("%s : PSM Watchdog, chipid 0x%x, chiprev 0x%x\n",
 					__func__, wlc->pub->sih->chip,
@@ -6440,7 +6453,9 @@ void wlc_high_dpc(struct wlc_info *wlc, u32 macintstatus)
 	}
 
 	if (macintstatus & MI_RFDISABLE) {
-		WL_ERROR(("wl%d: MAC Detected a change on the RF Disable Input 0x%x\n", wlc->pub->unit, R_REG(wlc->osh, &regs->phydebug) & PDBG_RFD));
+		WL_ERROR("wl%d: MAC Detected a change on the RF Disable Input 0x%x\n",
+			 wlc->pub->unit,
+			 R_REG(wlc->osh, &regs->phydebug) & PDBG_RFD);
 		/* delay the cleanup to wl_down in IBSS case */
 		if ((R_REG(wlc->osh, &regs->phydebug) & PDBG_RFD)) {
 			int idx;
@@ -6449,7 +6464,8 @@ void wlc_high_dpc(struct wlc_info *wlc, u32 macintstatus)
 				if (!BSSCFG_STA(bsscfg) || !bsscfg->enable
 				    || !bsscfg->BSS)
 					continue;
-				WL_ERROR(("wl%d: wlc_dpc: rfdisable -> wlc_bsscfg_disable()\n", wlc->pub->unit));
+				WL_ERROR("wl%d: wlc_dpc: rfdisable -> wlc_bsscfg_disable()\n",
+					 wlc->pub->unit);
 			}
 		}
 	}
@@ -6485,7 +6501,8 @@ static void *wlc_15420war(struct wlc_info *wlc, uint queue)
 	if (dma_txactive(wlc->hw->di[queue]) == 0) {
 		WLCNTINCR(wlc->pub->_cnt->txdmawar);
 		if (!dma_txreset(di))
-			WL_ERROR(("wl%d: %s: dma_txreset[%d]: cannot stop dma\n", wlc->pub->unit, __func__, queue));
+			WL_ERROR("wl%d: %s: dma_txreset[%d]: cannot stop dma\n",
+				 wlc->pub->unit, __func__, queue);
 		dma_txinit(di);
 	}
 	return p;
@@ -6538,7 +6555,7 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 			 ((txs->
 			   status & TX_STATUS_FRM_RTX_MASK) >>
 			  TX_STATUS_FRM_RTX_SHIFT));
-		WL_ERROR(("%s: INTERMEDIATE but not AMPDU\n", __func__));
+		WL_ERROR("%s: INTERMEDIATE but not AMPDU\n", __func__);
 		return false;
 	}
 
@@ -6563,8 +6580,8 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 	mcl = ltoh16(txh->MacTxControlLow);
 
 	if (txs->phyerr) {
-		WL_ERROR(("phyerr 0x%x, rate 0x%x\n", txs->phyerr,
-			  txh->MainRates));
+		WL_ERROR("phyerr 0x%x, rate 0x%x\n",
+			 txs->phyerr, txh->MainRates);
 		wlc_print_txdesc(txh);
 		wlc_print_txstatus(txs);
 	}
@@ -6595,8 +6612,8 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 
 	supr_status = txs->status & TX_STATUS_SUPR_MASK;
 	if (supr_status == TX_STATUS_SUPR_BADCH)
-		WL_NONE(("%s: Pkt tx suppressed, possibly channel %d\n",
-			 __func__, CHSPEC_CHANNEL(wlc->default_bss->chanspec)));
+		WL_NONE("%s: Pkt tx suppressed, possibly channel %d\n",
+			__func__, CHSPEC_CHANNEL(wlc->default_bss->chanspec));
 
 	tx_rts = htol16(txh->MacTxControlLow) & TXC_SENDRTS;
 	tx_frame_count =
@@ -6607,7 +6624,7 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 	lastframe = (fc & FC_MOREFRAG) == 0;
 
 	if (!lastframe) {
-		WL_ERROR(("Not last frame!\n"));
+		WL_ERROR("Not last frame!\n");
 	} else {
 		u16 sfbl, lfbl;
 		ieee80211_tx_info_clear_status(tx_info);
@@ -6658,8 +6675,8 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 		ieee80211_tx_status_irqsafe(wlc->pub->ieee_hw, p);
 		WLCNTINCR(wlc->pub->_cnt->ieee_tx_status);
 	} else {
-		WL_ERROR(("%s: Not last frame => not calling tx_status\n",
-			  __func__));
+		WL_ERROR("%s: Not last frame => not calling tx_status\n",
+			 __func__);
 	}
 
 	return false;
@@ -6677,8 +6694,8 @@ void BCMFASTPATH
 wlc_txfifo_complete(struct wlc_info *wlc, uint fifo, s8 txpktpend)
 {
 	TXPKTPENDDEC(wlc, fifo, txpktpend);
-	WL_TRACE(("wlc_txfifo_complete, pktpend dec %d to %d\n", txpktpend,
-		  TXPKTPENDGET(wlc, fifo)));
+	WL_TRACE("wlc_txfifo_complete, pktpend dec %d to %d\n",
+		 txpktpend, TXPKTPENDGET(wlc, fifo));
 
 	/* There is more room; mark precedences related to this FIFO sendable */
 	WLC_TX_FIFO_ENAB(wlc, fifo);
@@ -6872,19 +6889,19 @@ prep_mac80211_status(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p,
 			rx_status->rate_idx = 11;
 			break;
 		default:
-			WL_ERROR(("%s: Unknown rate\n", __func__));
+			WL_ERROR("%s: Unknown rate\n", __func__);
 		}
 
 		/* Determine short preamble and rate_idx */
 		preamble = 0;
 		if (IS_CCK(rspec)) {
 			if (rxh->PhyRxStatus_0 & PRXS0_SHORTH)
-				WL_ERROR(("Short CCK\n"));
+				WL_ERROR("Short CCK\n");
 			rx_status->flag |= RX_FLAG_SHORTPRE;
 		} else if (IS_OFDM(rspec)) {
 			rx_status->flag |= RX_FLAG_SHORTPRE;
 		} else {
-			WL_ERROR(("%s: Unknown modulation\n", __func__));
+			WL_ERROR("%s: Unknown modulation\n", __func__);
 		}
 	}
 
@@ -6893,11 +6910,11 @@ prep_mac80211_status(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p,
 
 	if (rxh->RxStatus1 & RXS_DECERR) {
 		rx_status->flag |= RX_FLAG_FAILED_PLCP_CRC;
-		WL_ERROR(("%s:  RX_FLAG_FAILED_PLCP_CRC\n", __func__));
+		WL_ERROR("%s:  RX_FLAG_FAILED_PLCP_CRC\n", __func__);
 	}
 	if (rxh->RxStatus1 & RXS_FCSERR) {
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
-		WL_ERROR(("%s:  RX_FLAG_FAILED_FCS_CRC\n", __func__));
+		WL_ERROR("%s:  RX_FLAG_FAILED_FCS_CRC\n", __func__);
 	}
 }
 
@@ -6943,7 +6960,7 @@ void wlc_bss_list_free(struct wlc_info *wlc, wlc_bss_list_t *bss_list)
 	wlc_bss_info_t *bi;
 
 	if (!bss_list) {
-		WL_ERROR(("%s: Attempting to free NULL list\n", __func__));
+		WL_ERROR("%s: Attempting to free NULL list\n", __func__);
 		return;
 	}
 	/* inspect all BSS descriptor */
@@ -6975,7 +6992,7 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 	uint len;
 	bool is_amsdu;
 
-	WL_TRACE(("wl%d: wlc_recv\n", wlc->pub->unit));
+	WL_TRACE("wl%d: wlc_recv\n", wlc->pub->unit);
 
 	osh = wlc->osh;
 
@@ -6992,8 +7009,8 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 	if (rxh->RxStatus1 & RXS_PBPRES) {
 		if (p->len < 2) {
 			WLCNTINCR(wlc->pub->_cnt->rxrunt);
-			WL_ERROR(("wl%d: wlc_recv: rcvd runt of len %d\n",
-				  wlc->pub->unit, p->len));
+			WL_ERROR("wl%d: wlc_recv: rcvd runt of len %d\n",
+				 wlc->pub->unit, p->len);
 			goto toss;
 		}
 		skb_pull(p, 2);
@@ -7004,10 +7021,10 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 
 	if (rxh->RxStatus1 & RXS_FCSERR) {
 		if (wlc->pub->mac80211_state & MAC80211_PROMISC_BCNS) {
-			WL_ERROR(("FCSERR while scanning******* - tossing\n"));
+			WL_ERROR("FCSERR while scanning******* - tossing\n");
 			goto toss;
 		} else {
-			WL_ERROR(("RCSERR!!!\n"));
+			WL_ERROR("RCSERR!!!\n");
 			goto toss;
 		}
 	}
@@ -7028,9 +7045,8 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 		if (FC_TYPE(fc) == FC_TYPE_DATA || FC_TYPE(fc) == FC_TYPE_MNG) {
 			if ((is_zero_ether_addr(h->a2.octet) ||
 			     is_multicast_ether_addr(h->a2.octet))) {
-				WL_ERROR(("wl%d: %s: dropping a frame with "
-					"invalid src mac address, a2: %pM\n",
-					wlc->pub->unit, __func__, &h->a2));
+				WL_ERROR("wl%d: %s: dropping a frame with invalid src mac address, a2: %pM\n",
+					 wlc->pub->unit, __func__, &h->a2);
 				WLCNTINCR(wlc->pub->_cnt->rxbadsrcmac);
 				goto toss;
 			}
@@ -7045,7 +7061,7 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 	}
 
 	if (is_amsdu) {
-		WL_ERROR(("%s: is_amsdu causing toss\n", __func__));
+		WL_ERROR("%s: is_amsdu causing toss\n", __func__);
 		goto toss;
 	}
 
@@ -7067,8 +7083,8 @@ wlc_calc_lsig_len(struct wlc_info *wlc, ratespec_t ratespec, uint mac_len)
 {
 	uint nsyms, len = 0, kNdps;
 
-	WL_TRACE(("wl%d: wlc_calc_lsig_len: rate %d, len%d\n", wlc->pub->unit,
-		  RSPEC2RATE(ratespec), mac_len));
+	WL_TRACE("wl%d: wlc_calc_lsig_len: rate %d, len%d\n",
+		 wlc->pub->unit, RSPEC2RATE(ratespec), mac_len);
 
 	if (IS_MCS(ratespec)) {
 		uint mcs = ratespec & RSPEC_RATE_MASK;
@@ -7112,11 +7128,12 @@ wlc_calc_frame_time(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
 
 	if (rate == 0) {
 		ASSERT(0);
-		WL_ERROR(("wl%d: WAR: using rate of 1 mbps\n", wlc->pub->unit));
+		WL_ERROR("wl%d: WAR: using rate of 1 mbps\n", wlc->pub->unit);
 		rate = WLC_RATE_1M;
 	}
 
-	WL_TRACE(("wl%d: wlc_calc_frame_time: rspec 0x%x, preamble_type %d, len%d\n", wlc->pub->unit, ratespec, preamble_type, mac_len));
+	WL_TRACE("wl%d: wlc_calc_frame_time: rspec 0x%x, preamble_type %d, len%d\n",
+		 wlc->pub->unit, ratespec, preamble_type, mac_len);
 
 	if (IS_MCS(ratespec)) {
 		uint mcs = ratespec & RSPEC_RATE_MASK;
@@ -7180,7 +7197,8 @@ wlc_calc_frame_len(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
 	uint nsyms, mac_len, Ndps, kNdps;
 	uint rate = RSPEC2RATE(ratespec);
 
-	WL_TRACE(("wl%d: wlc_calc_frame_len: rspec 0x%x, preamble_type %d, dur %d\n", wlc->pub->unit, ratespec, preamble_type, dur));
+	WL_TRACE("wl%d: wlc_calc_frame_len: rspec 0x%x, preamble_type %d, dur %d\n",
+		 wlc->pub->unit, ratespec, preamble_type, dur);
 
 	if (IS_MCS(ratespec)) {
 		uint mcs = ratespec & RSPEC_RATE_MASK;
@@ -7222,8 +7240,8 @@ wlc_calc_frame_len(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
 static uint
 wlc_calc_ba_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 {
-	WL_TRACE(("wl%d: wlc_calc_ba_time: rspec 0x%x, preamble_type %d\n",
-		  wlc->pub->unit, rspec, preamble_type));
+	WL_TRACE("wl%d: wlc_calc_ba_time: rspec 0x%x, preamble_type %d\n",
+		 wlc->pub->unit, rspec, preamble_type);
 	/* Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that is less than
 	 * or equal to the rate of the immediately previous frame in the FES
 	 */
@@ -7241,8 +7259,8 @@ wlc_calc_ack_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 {
 	uint dur = 0;
 
-	WL_TRACE(("wl%d: wlc_calc_ack_time: rspec 0x%x, preamble_type %d\n",
-		  wlc->pub->unit, rspec, preamble_type));
+	WL_TRACE("wl%d: wlc_calc_ack_time: rspec 0x%x, preamble_type %d\n",
+		 wlc->pub->unit, rspec, preamble_type);
 	/* Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that is less than
 	 * or equal to the rate of the immediately previous frame in the FES
 	 */
@@ -7259,8 +7277,8 @@ wlc_calc_ack_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 static uint
 wlc_calc_cts_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 {
-	WL_TRACE(("wl%d: wlc_calc_cts_time: ratespec 0x%x, preamble_type %d\n",
-		  wlc->pub->unit, rspec, preamble_type));
+	WL_TRACE("wl%d: wlc_calc_cts_time: ratespec 0x%x, preamble_type %d\n",
+		 wlc->pub->unit, rspec, preamble_type);
 	return wlc_calc_ack_time(wlc, rspec, preamble_type);
 }
 
@@ -7289,7 +7307,8 @@ void wlc_rate_lookup_init(struct wlc_info *wlc, wlc_rateset_t *rateset)
 		rate = (rateset->rates[i] & RATE_MASK);
 
 		if (rate > WLC_MAXRATE) {
-			WL_ERROR(("wlc_rate_lookup_init: invalid rate 0x%X in rate set\n", rateset->rates[i]));
+			WL_ERROR("wlc_rate_lookup_init: invalid rate 0x%X in rate set\n",
+				 rateset->rates[i]);
 			continue;
 		}
 
@@ -7468,7 +7487,8 @@ bool wlc_valid_rate(struct wlc_info *wlc, ratespec_t rspec, int band,
 			return true;
  error:
 	if (verbose) {
-		WL_ERROR(("wl%d: wlc_valid_rate: rate spec 0x%x not in hw_rateset\n", wlc->pub->unit, rspec));
+		WL_ERROR("wl%d: wlc_valid_rate: rate spec 0x%x not in hw_rateset\n",
+			 wlc->pub->unit, rspec);
 	}
 
 	return false;
@@ -7550,8 +7570,8 @@ wlc_compute_bcntsfoff(struct wlc_info *wlc, ratespec_t rspec,
 	uint bcntsfoff = 0;
 
 	if (IS_MCS(rspec)) {
-		WL_ERROR(("wl%d: recd beacon with mcs rate; rspec 0x%x\n",
-			  wlc->pub->unit, rspec));
+		WL_ERROR("wl%d: recd beacon with mcs rate; rspec 0x%x\n",
+			 wlc->pub->unit, rspec);
 	} else if (IS_OFDM(rspec)) {
 		/* tx delay from MAC through phy to air (2.1 usec) +
 		 * phy header time (preamble + PLCP SIGNAL == 20 usec) +
@@ -7979,8 +7999,8 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 	if (N_ENAB(wlc->pub) && ismcs) {
 		/* mcs only allowed when nmode */
 		if (stf > PHY_TXC1_MODE_SDM) {
-			WL_ERROR(("wl%d: %s: Invalid stf\n", WLCWLUNIT(wlc),
-				  __func__));
+			WL_ERROR("wl%d: %s: Invalid stf\n",
+				 WLCWLUNIT(wlc), __func__);
 			bcmerror = BCME_RANGE;
 			goto done;
 		}
@@ -7990,8 +8010,8 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 			if (!CHSPEC_IS40(wlc->home_chanspec) ||
 			    ((stf != PHY_TXC1_MODE_SISO)
 			     && (stf != PHY_TXC1_MODE_CDD))) {
-				WL_ERROR(("wl%d: %s: Invalid mcs 32\n",
-					  WLCWLUNIT(wlc), __func__));
+				WL_ERROR("wl%d: %s: Invalid mcs 32\n",
+					 WLCWLUNIT(wlc), __func__);
 				bcmerror = BCME_RANGE;
 				goto done;
 			}
@@ -7999,7 +8019,8 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 		} else if (rate > HIGHEST_SINGLE_STREAM_MCS) {
 			/* mcs > 7 must use stf SDM */
 			if (stf != PHY_TXC1_MODE_SDM) {
-				WL_TRACE(("wl%d: %s: enabling SDM mode for mcs %d\n", WLCWLUNIT(wlc), __func__, rate));
+				WL_TRACE("wl%d: %s: enabling SDM mode for mcs %d\n",
+					 WLCWLUNIT(wlc), __func__, rate);
 				stf = PHY_TXC1_MODE_SDM;
 			}
 		} else {
@@ -8007,37 +8028,37 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 			if ((stf > PHY_TXC1_MODE_STBC) ||
 			    (!WLC_STBC_CAP_PHY(wlc)
 			     && (stf == PHY_TXC1_MODE_STBC))) {
-				WL_ERROR(("wl%d: %s: Invalid STBC\n",
-					  WLCWLUNIT(wlc), __func__));
+				WL_ERROR("wl%d: %s: Invalid STBC\n",
+					 WLCWLUNIT(wlc), __func__);
 				bcmerror = BCME_RANGE;
 				goto done;
 			}
 		}
 	} else if (IS_OFDM(rate)) {
 		if ((stf != PHY_TXC1_MODE_CDD) && (stf != PHY_TXC1_MODE_SISO)) {
-			WL_ERROR(("wl%d: %s: Invalid OFDM\n", WLCWLUNIT(wlc),
-				  __func__));
+			WL_ERROR("wl%d: %s: Invalid OFDM\n",
+				 WLCWLUNIT(wlc), __func__);
 			bcmerror = BCME_RANGE;
 			goto done;
 		}
 	} else if (IS_CCK(rate)) {
 		if ((cur_band->bandtype != WLC_BAND_2G)
 		    || (stf != PHY_TXC1_MODE_SISO)) {
-			WL_ERROR(("wl%d: %s: Invalid CCK\n", WLCWLUNIT(wlc),
-				  __func__));
+			WL_ERROR("wl%d: %s: Invalid CCK\n",
+				 WLCWLUNIT(wlc), __func__);
 			bcmerror = BCME_RANGE;
 			goto done;
 		}
 	} else {
-		WL_ERROR(("wl%d: %s: Unknown rate type\n", WLCWLUNIT(wlc),
-			  __func__));
+		WL_ERROR("wl%d: %s: Unknown rate type\n",
+			 WLCWLUNIT(wlc), __func__);
 		bcmerror = BCME_RANGE;
 		goto done;
 	}
 	/* make sure multiple antennae are available for non-siso rates */
 	if ((stf != PHY_TXC1_MODE_SISO) && (wlc->stf->txstreams == 1)) {
-		WL_ERROR(("wl%d: %s: SISO antenna but !SISO request\n",
-			  WLCWLUNIT(wlc), __func__));
+		WL_ERROR("wl%d: %s: SISO antenna but !SISO request\n",
+			 WLCWLUNIT(wlc), __func__);
 		bcmerror = BCME_RANGE;
 		goto done;
 	}
@@ -8068,7 +8089,7 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 
 	return rspec;
  done:
-	WL_ERROR(("Hoark\n"));
+	WL_ERROR("Hoark\n");
 	return rate;
 }
 
@@ -8082,8 +8103,7 @@ wlc_duty_cycle_set(struct wlc_info *wlc, int duty_cycle, bool isOFDM,
 	    isOFDM ? M_TX_IDLE_BUSY_RATIO_X_16_OFDM :
 	    M_TX_IDLE_BUSY_RATIO_X_16_CCK;
 	if (duty_cycle > 100 || duty_cycle < 0) {
-		WL_ERROR(("wl%d:  duty cycle value off limit\n",
-			  wlc->pub->unit));
+		WL_ERROR("wl%d:  duty cycle value off limit\n", wlc->pub->unit);
 		return BCME_RANGE;
 	}
 	if (duty_cycle)
@@ -8282,7 +8302,7 @@ void wlc_txflowcontrol(struct wlc_info *wlc, wlc_txq_info_t *qi,
 	uint prio_bits;
 	uint cur_bits;
 
-	WL_ERROR(("%s: flow contro kicks in\n", __func__));
+	WL_ERROR("%s: flow control kicks in\n", __func__);
 
 	if (prio == ALLPRIO) {
 		prio_bits = TXQ_STOP_FOR_PRIOFC_MASK;
diff --git a/drivers/staging/brcm80211/sys/wlc_phy_shim.c b/drivers/staging/brcm80211/sys/wlc_phy_shim.c
index 5dcaa7d..8bd4ede 100644
--- a/drivers/staging/brcm80211/sys/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/sys/wlc_phy_shim.c
@@ -70,7 +70,8 @@ wlc_phy_shim_info_t *wlc_phy_shim_attach(struct wlc_hw_info *wlc_hw,
 
 	physhim = kzalloc(sizeof(wlc_phy_shim_info_t), GFP_ATOMIC);
 	if (!physhim) {
-		WL_ERROR(("wl%d: wlc_phy_shim_attach: out of mem\n", wlc_hw->unit));
+		WL_ERROR("wl%d: wlc_phy_shim_attach: out of mem\n",
+			 wlc_hw->unit);
 		return NULL;
 	}
 	physhim->wlc_hw = wlc_hw;
diff --git a/drivers/staging/brcm80211/sys/wlc_stf.c b/drivers/staging/brcm80211/sys/wlc_stf.c
index 01ac0d2..8975b09 100644
--- a/drivers/staging/brcm80211/sys/wlc_stf.c
+++ b/drivers/staging/brcm80211/sys/wlc_stf.c
@@ -196,8 +196,8 @@ bool wlc_stf_stbc_rx_set(struct wlc_info *wlc, s32 int_val)
 
 static int wlc_stf_txcore_set(struct wlc_info *wlc, u8 Nsts, u8 core_mask)
 {
-	WL_TRACE(("wl%d: %s: Nsts %d core_mask %x\n",
-		  wlc->pub->unit, __func__, Nsts, core_mask));
+	WL_TRACE("wl%d: %s: Nsts %d core_mask %x\n",
+		 wlc->pub->unit, __func__, Nsts, core_mask);
 
 	ASSERT((Nsts > 0) && (Nsts <= MAX_STREAMS_SUPPORTED));
 
@@ -236,7 +236,7 @@ static int wlc_stf_spatial_policy_set(struct wlc_info *wlc, int val)
 	int i;
 	u8 core_mask = 0;
 
-	WL_TRACE(("wl%d: %s: val %x\n", wlc->pub->unit, __func__, val));
+	WL_TRACE("wl%d: %s: val %x\n", wlc->pub->unit, __func__, val);
 
 	wlc->stf->spatial_policy = (s8) val;
 	for (i = 1; i <= MAX_STREAMS_SUPPORTED; i++) {
@@ -278,13 +278,15 @@ int wlc_stf_txchain_set(struct wlc_info *wlc, s32 int_val, bool force)
 				if (RSPEC_STF(wlc->bandstate[i]->rspec_override)
 				    != PHY_TXC1_MODE_SISO) {
 					wlc->bandstate[i]->rspec_override = 0;
-					WL_ERROR(("%s(): temp sense override non-SISO" " rspec_override.\n", __func__));
+					WL_ERROR("%s(): temp sense override non-SISO rspec_override\n",
+						 __func__);
 				}
 				if (RSPEC_STF
 				    (wlc->bandstate[i]->mrspec_override) !=
 				    PHY_TXC1_MODE_SISO) {
 					wlc->bandstate[i]->mrspec_override = 0;
-					WL_ERROR(("%s(): temp sense override non-SISO" " mrspec_override.\n", __func__));
+					WL_ERROR("%s(): temp sense override non-SISO mrspec_override\n",
+						 __func__);
 				}
 			}
 	}
-- 
1.7.3.3.398.g0b0cd.dirty

