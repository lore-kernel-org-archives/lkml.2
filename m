Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab1JILMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 07:12:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46379 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab1JILMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 07:12:06 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 6/7] staging: wlags49_h2: Fixup IW_AUTH handling
Date: Sun,  9 Oct 2011 12:11:36 +0100
Message-Id: <1318158697-15979-7-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318158697-15979-1-git-send-email-kilroyd@googlemail.com>
References: <1318158697-15979-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle more cases in IW_AUTH.

Avoid reporting errors (invalid parameter) on operations that we
can't do anything with.

Return -EINPROGRESS from some operations to get wpa_supplicant to
batch and commit changes.

In other operations apply the changes immediately.

Avoid writing WEP keys from the commit handler when WEP is not
being used.

Accept WPA_VERSION_DISABLED, which is received from wpa_supplicant
during WEP.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/wl_main.c |    6 +-
 drivers/staging/wlags49_h2/wl_wext.c |  179 ++++++++++++++++++++--------------
 2 files changed, 109 insertions(+), 76 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_main.c b/drivers/staging/wlags49_h2/wl_main.c
index 6d45ab3..483eee1 100644
--- a/drivers/staging/wlags49_h2/wl_main.c
+++ b/drivers/staging/wlags49_h2/wl_main.c
@@ -1993,8 +1993,10 @@ int wl_put_ltv( struct wl_private *lp )
 	lp->ltvRecord.typ       = CFG_SET_WPA_AUTH_KEY_MGMT_SUITE;
 	lp->ltvRecord.u.u16[0]  = CNV_INT_TO_LITTLE( lp->AuthKeyMgmtSuite );
 	hcf_status = hcf_put_info( &lp->hcfCtx, (LTVP)&( lp->ltvRecord ));
-	/* WEP Keys */
-	wl_set_wep_keys( lp );
+
+	/* If WEP (or no) keys are being used, write (or clear) them */
+	if (lp->wext_enc != IW_ENCODE_ALG_TKIP)
+		wl_set_wep_keys(lp);
 
 	/* Country Code */
 	/* countryInfo, ltvCountryInfo, CFG_CNF_COUNTRY_INFO */
diff --git a/drivers/staging/wlags49_h2/wl_wext.c b/drivers/staging/wlags49_h2/wl_wext.c
index 567a0dc..9884320 100644
--- a/drivers/staging/wlags49_h2/wl_wext.c
+++ b/drivers/staging/wlags49_h2/wl_wext.c
@@ -2894,7 +2894,24 @@ out:
 } // wireless_get_scan
 /*============================================================================*/
 
-
+#if DBG
+static const char * const auth_names[] = {
+	"IW_AUTH_WPA_VERSION",
+	"IW_AUTH_CIPHER_PAIRWISE",
+	"IW_AUTH_CIPHER_GROUP",
+	"IW_AUTH_KEY_MGMT",
+	"IW_AUTH_TKIP_COUNTERMEASURES",
+	"IW_AUTH_DROP_UNENCRYPTED",
+	"IW_AUTH_80211_AUTH_ALG",
+	"IW_AUTH_WPA_ENABLED",
+	"IW_AUTH_RX_UNENCRYPTED_EAPOL",
+	"IW_AUTH_ROAMING_CONTROL",
+	"IW_AUTH_PRIVACY_INVOKED",
+	"IW_AUTH_CIPHER_GROUP_MGMT",
+	"IW_AUTH_MFP",
+	"Unsupported"
+};
+#endif
 
 static int wireless_set_auth(struct net_device *dev,
 			  struct iw_request_info *info,
@@ -2902,14 +2919,15 @@ static int wireless_set_auth(struct net_device *dev,
 {
 	struct wl_private *lp = wl_priv(dev);
 	unsigned long flags;
-	int			      ret;
-	int			      iwa_idx = data->flags & IW_AUTH_INDEX;
-	int			      iwa_val = data->value;
+	ltv_t ltv;
+	int ret;
+	int iwa_idx = data->flags & IW_AUTH_INDEX;
+	int iwa_val = data->value;
 
 	DBG_FUNC( "wireless_set_auth" );
 	DBG_ENTER( DbgInfo );
 
-	if(lp->portState == WVLAN_PORT_STATE_DISABLED) {
+	if (lp->portState == WVLAN_PORT_STATE_DISABLED) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -2918,89 +2936,102 @@ static int wireless_set_auth(struct net_device *dev,
 
     	wl_act_int_off( lp );
 
+	if (iwa_idx > IW_AUTH_MFP)
+		iwa_idx = IW_AUTH_MFP + 1;
+	DBG_TRACE(DbgInfo, "%s\n", auth_names[iwa_idx]);
 	switch (iwa_idx) {
-		case IW_AUTH_WPA_VERSION:
-			DBG_TRACE( DbgInfo, "IW_AUTH_WPA_VERSION\n");
-			/* We do support WPA only; how should DISABLED be treated? */
-			if (iwa_val == IW_AUTH_WPA_VERSION_WPA)
-				ret = 0;
-			else
-				ret = -EINVAL;
-			break;
-
-		case IW_AUTH_WPA_ENABLED:
-			DBG_TRACE( DbgInfo, "IW_AUTH_WPA_ENABLED: val = %d\n", iwa_val);
-			if (iwa_val)
-				lp->EnableEncryption = 2;
-			else
-				lp->EnableEncryption = 0;
+	case IW_AUTH_WPA_VERSION:
+		/* We do support WPA */
+		if ((iwa_val == IW_AUTH_WPA_VERSION_WPA) ||
+		    (iwa_val == IW_AUTH_WPA_VERSION_DISABLED))
 			ret = 0;
-			break;
+		else
+			ret = -EINVAL;
+		break;
 
-		case IW_AUTH_TKIP_COUNTERMEASURES:
-			DBG_TRACE( DbgInfo, "IW_AUTH_TKIP_COUNTERMEASURES\n");
-			lp->driverEnable = !iwa_val;
-			if(lp->driverEnable)
-				hcf_cntl(&(lp->hcfCtx), HCF_CNTL_ENABLE | HCF_PORT_0);
-			else
-				hcf_cntl(&(lp->hcfCtx), HCF_CNTL_DISABLE | HCF_PORT_0);
-			ret = 0;
-			break;
+	case IW_AUTH_WPA_ENABLED:
+		DBG_TRACE(DbgInfo, "val = %d\n", iwa_val);
+		if (iwa_val)
+			lp->EnableEncryption = 2;
+		else
+			lp->EnableEncryption = 0;
 
-		case IW_AUTH_DROP_UNENCRYPTED:
-			DBG_TRACE( DbgInfo, "IW_AUTH_DROP_UNENCRYPTED\n");
-			/* We do not actually do anything here, just to silence
-			 * wpa_supplicant */
-			ret = 0;
-			break;
+		/* Write straight to the card */
+		ltv.len = 2;
+		ltv.typ = CFG_CNF_ENCRYPTION;
+		ltv.u.u16[0] = cpu_to_le16(lp->EnableEncryption);
+		ret = hcf_put_info(&lp->hcfCtx, (LTVP)&ltv);
 
-		case IW_AUTH_CIPHER_PAIRWISE:
-			DBG_TRACE( DbgInfo, "IW_AUTH_CIPHER_PAIRWISE\n");
-			/* not implemented, return an error */
-			ret = -EINVAL;
-			break;
+		break;
 
-		case IW_AUTH_CIPHER_GROUP:
-			DBG_TRACE( DbgInfo, "IW_AUTH_CIPHER_GROUP\n");
-			/* not implemented, return an error */
-			ret = -EINVAL;
-			break;
+	case IW_AUTH_TKIP_COUNTERMEASURES:
 
-		case IW_AUTH_KEY_MGMT:
-			DBG_TRACE( DbgInfo, "IW_AUTH_KEY_MGMT\n");
-			/* not implemented, return an error */
-			ret = -EINVAL;
-			break;
+		/* Immediately disable card */
+		lp->driverEnable = !iwa_val;
+		if (lp->driverEnable)
+			hcf_cntl(&(lp->hcfCtx), HCF_CNTL_ENABLE | HCF_PORT_0);
+		else
+			hcf_cntl(&(lp->hcfCtx), HCF_CNTL_DISABLE | HCF_PORT_0);
+		ret = 0;
+		break;
 
-		case IW_AUTH_80211_AUTH_ALG:
-			DBG_TRACE( DbgInfo, "IW_AUTH_80211_AUTH_ALG\n");
-			/* not implemented, return an error */
+	case IW_AUTH_MFP:
+		/* Management Frame Protection not supported.
+		 * Only fail if set to required.
+		 */
+		if (iwa_val == IW_AUTH_MFP_REQUIRED)
 			ret = -EINVAL;
-			break;
+		else
+			ret = 0;
+		break;
 
-		case IW_AUTH_RX_UNENCRYPTED_EAPOL:
-			DBG_TRACE( DbgInfo, "IW_AUTH_RX_UNENCRYPTED_EAPOL\n");
-			/* not implemented, return an error */
-			ret = -EINVAL;
-			break;
+	case IW_AUTH_KEY_MGMT:
 
-		case IW_AUTH_ROAMING_CONTROL:
-			DBG_TRACE( DbgInfo, "IW_AUTH_ROAMING_CONTROL\n");
-			/* not implemented, return an error */
-			ret = -EINVAL;
-			break;
+		/* Record required management suite.
+		 * Will take effect on next commit */
+		if (iwa_val != 0)
+			lp->AuthKeyMgmtSuite = 4;
+		else
+			lp->AuthKeyMgmtSuite = 0;
 
-		case IW_AUTH_PRIVACY_INVOKED:
-			DBG_TRACE( DbgInfo, "IW_AUTH_PRIVACY_INVOKED\n");
-			/* not implemented, return an error */
-			ret = -EINVAL;
-			break;
+		ret = -EINPROGRESS;
+		break;
 
-		default:
-			DBG_TRACE( DbgInfo, "IW_AUTH_?? (%d) unknown\n", iwa_idx);
-			/* return an error */
+	case IW_AUTH_80211_AUTH_ALG:
+
+		/* Just record whether open or shared is required.
+		 * Will take effect on next commit */
+		ret = -EINPROGRESS;
+
+		if (iwa_val & IW_AUTH_ALG_SHARED_KEY)
+			lp->authentication = 1;
+		else if (iwa_val & IW_AUTH_ALG_OPEN_SYSTEM)
+			lp->authentication = 0;
+		else
 			ret = -EINVAL;
-			break;
+		break;
+
+	case IW_AUTH_DROP_UNENCRYPTED:
+		/* Only needed for AP */
+		lp->ExcludeUnencrypted = iwa_val;
+		ret = -EINPROGRESS;
+		break;
+
+	case IW_AUTH_CIPHER_PAIRWISE:
+	case IW_AUTH_CIPHER_GROUP:
+	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
+	case IW_AUTH_ROAMING_CONTROL:
+	case IW_AUTH_PRIVACY_INVOKED:
+		/* Not used. May need to do something with
+		 * CIPHER_PAIRWISE and CIPHER_GROUP*/
+		ret = -EINPROGRESS;
+		break;
+
+	default:
+		DBG_TRACE(DbgInfo, "IW_AUTH_?? (%d) unknown\n", iwa_idx);
+		/* return an error */
+		ret = -EOPNOTSUPP;
+		break;
 	}
 
     	wl_act_int_on( lp );
-- 
1.7.4.1

