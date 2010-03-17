Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab0CQPY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:24:28 -0400
Received: from rsk.demon.co.uk ([80.176.90.227]:45161 "EHLO castor.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751882Ab0CQPYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:24:25 -0400
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, jmm@debian.org,
       mithlesh@linsyssoft.com
Subject: [PATCH 3/3] staging wlan-ng: refactor p80211wext.c to reduce text size.
Date: Wed, 17 Mar 2010 14:30:23 +0000
Message-Id: <1268836223-31620-4-git-send-email-richard@rsk.demon.co.uk>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1268836223-31620-1-git-send-email-richard@rsk.demon.co.uk>
References: <1268836223-31620-1-git-send-email-richard@rsk.demon.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the wext interface to reduce lines of code & module text size.

- add a helper function p80211wext_getmib
- rename p80211wext_dorequest to p80211wext_setmib
- refactor wext to call the get/set mib helpers and so reduce repeated code.

size reported text reduction :-
   text	   data	    bss	    dec	    hex	filename
   8343	    720	      0	   9063	   2367	p80211wext.o.patch
   9907	    720	      0	  10631	   2987	p80211wext.o.orig

Tested on x86_32 laptop, everything works correctly using NetworkManager,
and iwconfig & iwlist return sensible results when reading from the card.


Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
 drivers/staging/wlan-ng/p80211wext.c |  298 +++++++++++++---------------------
 1 files changed, 116 insertions(+), 182 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211wext.c b/drivers/staging/wlan-ng/p80211wext.c
index 6b4d3e4..6a6e612 100644
--- a/drivers/staging/wlan-ng/p80211wext.c
+++ b/drivers/staging/wlan-ng/p80211wext.c
@@ -127,18 +127,38 @@ static int qual_as_percent(int snr)
 	return 100;
 }
 
-static int p80211wext_dorequest(wlandevice_t *wlandev, u32 did, u32 data)
+static int p80211wext_setmib(wlandevice_t *wlandev, u32 did, u32 data)
 {
 	p80211msg_dot11req_mibset_t msg;
-	p80211item_uint32_t mibitem;
+	p80211item_uint32_t *mibitem =
+		(p80211item_uint32_t *)&msg.mibattribute.data;
 	int result;
 
 	msg.msgcode = DIDmsg_dot11req_mibset;
-	memset(&mibitem, 0, sizeof(mibitem));
-	mibitem.did = did;
-	mibitem.data = data;
-	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
+	memset(mibitem, 0, sizeof(*mibitem));
+	mibitem->did = did;
+	mibitem->data = data;
+	result = p80211req_dorequest(wlandev, (u8 *) &msg);
+
+	return result;
+}
+
+/*
+ * get a 32 bit mib value
+ */
+static int p80211wext_getmib(wlandevice_t *wlandev, u32 did, u32 *data)
+{
+	p80211msg_dot11req_mibset_t msg;
+	p80211item_uint32_t *mibitem =
+		(p80211item_uint32_t *)&msg.mibattribute.data;
+	int result;
+
+	msg.msgcode = DIDmsg_dot11req_mibget;
+	memset(mibitem, 0, sizeof(*mibitem));
+	mibitem->did = did;
 	result = p80211req_dorequest(wlandev, (u8 *) &msg);
+	if (!result)
+		*data = mibitem->data;
 
 	return result;
 }
@@ -264,32 +284,26 @@ static int p80211wext_giwfreq(netdevice_t *dev,
 			      struct iw_freq *freq, char *extra)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
-	p80211item_uint32_t mibitem;
-	p80211msg_dot11req_mibset_t msg;
 	int result;
 	int err = 0;
+	unsigned int value;
 
-	msg.msgcode = DIDmsg_dot11req_mibget;
-	memset(&mibitem, 0, sizeof(mibitem));
-	mibitem.did = DIDmib_dot11phy_dot11PhyDSSSTable_dot11CurrentChannel;
-	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
-
+	result = p80211wext_getmib(wlandev,
+				   DIDmib_dot11phy_dot11PhyDSSSTable_dot11CurrentChannel,
+				   &value);
 	if (result) {
 		err = -EFAULT;
 		goto exit;
 	}
 
-	memcpy(&mibitem, &msg.mibattribute.data, sizeof(mibitem));
-
-	if (mibitem.data > NUM_CHANNELS) {
+	if (value > NUM_CHANNELS) {
 		err = -EFAULT;
 		goto exit;
 	}
 
 	/* convert into frequency instead of a channel */
 	freq->e = 1;
-	freq->m = p80211_channel_to_mhz(mibitem.data, 0) * 100000;
+	freq->m = p80211_channel_to_mhz(value, 0) * 100000;
 
 exit:
 	return err;
@@ -300,28 +314,23 @@ static int p80211wext_siwfreq(netdevice_t *dev,
 			      struct iw_freq *freq, char *extra)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
-	p80211item_uint32_t mibitem;
-	p80211msg_dot11req_mibset_t msg;
 	int result;
 	int err = 0;
+	unsigned int value;
 
 	if (!wlan_wext_write) {
-		err = (-EOPNOTSUPP);
+		err = -EOPNOTSUPP;
 		goto exit;
 	}
 
-	msg.msgcode = DIDmsg_dot11req_mibset;
-	memset(&mibitem, 0, sizeof(mibitem));
-	mibitem.did = DIDmib_dot11phy_dot11PhyDSSSTable_dot11CurrentChannel;
-	mibitem.status = P80211ENUM_msgitem_status_data_ok;
-
 	if ((freq->e == 0) && (freq->m <= 1000))
-		mibitem.data = freq->m;
+		value = freq->m;
 	else
-		mibitem.data = p80211_mhz_to_channel(freq->m);
+		value = p80211_mhz_to_channel(freq->m);
 
-	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
+	result = p80211wext_setmib(wlandev,
+			     DIDmib_dot11phy_dot11PhyDSSSTable_dot11CurrentChannel,
+			     value);
 
 	if (result) {
 		err = -EFAULT;
@@ -361,13 +370,11 @@ static int p80211wext_siwmode(netdevice_t *dev,
 			      __u32 *mode, char *extra)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
-	p80211item_uint32_t mibitem;
-	p80211msg_dot11req_mibset_t msg;
 	int result;
 	int err = 0;
 
 	if (!wlan_wext_write) {
-		err = (-EOPNOTSUPP);
+		err = -EOPNOTSUPP;
 		goto exit;
 	}
 
@@ -398,16 +405,11 @@ static int p80211wext_siwmode(netdevice_t *dev,
 	}
 
 	/* Set Operation mode to the PORT TYPE RID */
-	msg.msgcode = DIDmsg_dot11req_mibset;
-	memset(&mibitem, 0, sizeof(mibitem));
-	mibitem.did = DIDmib_p2_p2Static_p2CnfPortType;
-	mibitem.data = (*mode == IW_MODE_ADHOC) ? 0 : 1;
-	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
-
+	result = p80211wext_setmib(wlandev,
+				DIDmib_p2_p2Static_p2CnfPortType,
+				(*mode == IW_MODE_ADHOC) ? 0 : 1);
 	if (result)
 		err = -EFAULT;
-
 exit:
 	return err;
 }
@@ -564,9 +566,9 @@ static int p80211wext_siwencode(netdevice_t *dev,
 		/* Set current key number only if no keys are given */
 		if (erq->flags & IW_ENCODE_NOKEY) {
 			result =
-			    p80211wext_dorequest(wlandev,
-						 DIDmib_dot11smt_dot11PrivacyTable_dot11WEPDefaultKeyID,
-						 i);
+				p80211wext_setmib(wlandev,
+						  DIDmib_dot11smt_dot11PrivacyTable_dot11WEPDefaultKeyID,
+						  i);
 
 			if (result) {
 				err = -EFAULT;
@@ -588,7 +590,6 @@ static int p80211wext_siwencode(netdevice_t *dev,
 		 -------------------------------------------------------------*/
 
 		if (erq->length > 0) {
-
 			/* copy the key from the driver cache as the keys are read-only MIBs */
 			wlandev->wep_keylens[i] = erq->length;
 			memcpy(wlandev->wep_keys[i], key, erq->length);
@@ -638,12 +639,12 @@ static int p80211wext_siwencode(netdevice_t *dev,
 	/* Check the PrivacyInvoked flag */
 	if (erq->flags & IW_ENCODE_DISABLED) {
 		result =
-		    p80211wext_dorequest(wlandev,
+		    p80211wext_setmib(wlandev,
 					 DIDmib_dot11smt_dot11PrivacyTable_dot11PrivacyInvoked,
 					 P80211ENUM_truth_false);
 	} else {
 		result =
-		    p80211wext_dorequest(wlandev,
+		    p80211wext_setmib(wlandev,
 					 DIDmib_dot11smt_dot11PrivacyTable_dot11PrivacyInvoked,
 					 P80211ENUM_truth_true);
 	}
@@ -662,12 +663,12 @@ static int p80211wext_siwencode(netdevice_t *dev,
 	 */
 	if (erq->flags & IW_ENCODE_RESTRICTED) {
 		result =
-		    p80211wext_dorequest(wlandev,
+		    p80211wext_setmib(wlandev,
 					 DIDmib_dot11smt_dot11PrivacyTable_dot11ExcludeUnencrypted,
 					 P80211ENUM_truth_true);
 	} else if (erq->flags & IW_ENCODE_OPEN) {
 		result =
-		    p80211wext_dorequest(wlandev,
+		    p80211wext_setmib(wlandev,
 					 DIDmib_dot11smt_dot11PrivacyTable_dot11ExcludeUnencrypted,
 					 P80211ENUM_truth_false);
 	}
@@ -769,24 +770,16 @@ static int p80211wext_giwrate(netdevice_t *dev,
 			      struct iw_param *rrq, char *extra)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
-	p80211item_uint32_t mibitem;
-	p80211msg_dot11req_mibset_t msg;
 	int result;
 	int err = 0;
+	unsigned int value;
 
-	msg.msgcode = DIDmsg_dot11req_mibget;
-	memset(&mibitem, 0, sizeof(mibitem));
-	mibitem.did = DIDmib_p2_p2MAC_p2CurrentTxRate;
-	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
-
+	result = p80211wext_getmib(wlandev, DIDmib_p2_p2MAC_p2CurrentTxRate, &value);
 	if (result) {
 		err = -EFAULT;
 		goto exit;
 	}
 
-	memcpy(&mibitem, &msg.mibattribute.data, sizeof(mibitem));
-
 	rrq->fixed = 0;		/* can it change? */
 	rrq->disabled = 0;
 	rrq->value = 0;
@@ -796,7 +789,7 @@ static int p80211wext_giwrate(netdevice_t *dev,
 #define		HFA384x_RATEBIT_5dot5			((u16)4)
 #define		HFA384x_RATEBIT_11			((u16)8)
 
-	switch (mibitem.data) {
+	switch (value) {
 	case HFA384x_RATEBIT_1:
 		rrq->value = 1000000;
 		break;
@@ -821,25 +814,19 @@ static int p80211wext_giwrts(netdevice_t *dev,
 			     struct iw_param *rts, char *extra)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
-	p80211item_uint32_t mibitem;
-	p80211msg_dot11req_mibset_t msg;
 	int result;
 	int err = 0;
+	unsigned int value;
 
-	msg.msgcode = DIDmsg_dot11req_mibget;
-	memset(&mibitem, 0, sizeof(mibitem));
-	mibitem.did = DIDmib_dot11mac_dot11OperationTable_dot11RTSThreshold;
-	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
-
+	result = p80211wext_getmib(wlandev,
+				   DIDmib_dot11mac_dot11OperationTable_dot11RTSThreshold,
+				   &value);
 	if (result) {
 		err = -EFAULT;
 		goto exit;
 	}
 
-	memcpy(&mibitem, &msg.mibattribute.data, sizeof(mibitem));
-
-	rts->value = mibitem.data;
+	rts->value = value;
 	rts->disabled = (rts->value == 2347);
 	rts->fixed = 1;
 
@@ -852,27 +839,23 @@ static int p80211wext_siwrts(netdevice_t *dev,
 			     struct iw_param *rts, char *extra)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
-	p80211item_uint32_t mibitem;
-	p80211msg_dot11req_mibset_t msg;
 	int result;
 	int err = 0;
+	unsigned int value;
 
 	if (!wlan_wext_write) {
-		err = (-EOPNOTSUPP);
+		err = -EOPNOTSUPP;
 		goto exit;
 	}
 
-	msg.msgcode = DIDmsg_dot11req_mibget;
-	memset(&mibitem, 0, sizeof(mibitem));
-	mibitem.did = DIDmib_dot11mac_dot11OperationTable_dot11RTSThreshold;
 	if (rts->disabled)
-		mibitem.data = 2347;
+		value = 2347;
 	else
-		mibitem.data = rts->value;
-
-	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
+		value = rts->value;
 
+	result = p80211wext_setmib(wlandev,
+				   DIDmib_dot11mac_dot11OperationTable_dot11RTSThreshold,
+				   value);
 	if (result) {
 		err = -EFAULT;
 		goto exit;
@@ -887,26 +870,19 @@ static int p80211wext_giwfrag(netdevice_t *dev,
 			      struct iw_param *frag, char *extra)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
-	p80211item_uint32_t mibitem;
-	p80211msg_dot11req_mibset_t msg;
 	int result;
 	int err = 0;
+	unsigned int value;
 
-	msg.msgcode = DIDmsg_dot11req_mibget;
-	memset(&mibitem, 0, sizeof(mibitem));
-	mibitem.did =
-	    DIDmib_dot11mac_dot11OperationTable_dot11FragmentationThreshold;
-	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
-
+	result = p80211wext_getmib(wlandev,
+				   DIDmib_dot11mac_dot11OperationTable_dot11FragmentationThreshold,
+				   &value);
 	if (result) {
 		err = -EFAULT;
 		goto exit;
 	}
 
-	memcpy(&mibitem, &msg.mibattribute.data, sizeof(mibitem));
-
-	frag->value = mibitem.data;
+	frag->value = value;
 	frag->disabled = (frag->value == 2346);
 	frag->fixed = 1;
 
@@ -919,28 +895,23 @@ static int p80211wext_siwfrag(netdevice_t *dev,
 			      struct iw_param *frag, char *extra)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
-	p80211item_uint32_t mibitem;
-	p80211msg_dot11req_mibset_t msg;
 	int result;
 	int err = 0;
+	int value;
 
 	if (!wlan_wext_write) {
 		err = (-EOPNOTSUPP);
 		goto exit;
 	}
 
-	msg.msgcode = DIDmsg_dot11req_mibset;
-	memset(&mibitem, 0, sizeof(mibitem));
-	mibitem.did =
-	    DIDmib_dot11mac_dot11OperationTable_dot11FragmentationThreshold;
-
 	if (frag->disabled)
-		mibitem.data = 2346;
+		value = 2346;
 	else
-		mibitem.data = frag->value;
+		value = frag->value;
 
-	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
+	result = p80211wext_setmib(wlandev,
+		   DIDmib_dot11mac_dot11OperationTable_dot11FragmentationThreshold,
+				      value);
 
 	if (result) {
 		err = -EFAULT;
@@ -964,56 +935,40 @@ static int p80211wext_giwretry(netdevice_t *dev,
 			       struct iw_param *rrq, char *extra)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
-	p80211item_uint32_t mibitem;
-	p80211msg_dot11req_mibset_t msg;
 	int result;
 	int err = 0;
 	u16 shortretry, longretry, lifetime;
+	unsigned int value;
 
-	msg.msgcode = DIDmsg_dot11req_mibget;
-	memset(&mibitem, 0, sizeof(mibitem));
-	mibitem.did = DIDmib_dot11mac_dot11OperationTable_dot11ShortRetryLimit;
-
-	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
-
+	result = p80211wext_getmib(wlandev,
+				   DIDmib_dot11mac_dot11OperationTable_dot11ShortRetryLimit,
+				   &value);
 	if (result) {
 		err = -EFAULT;
 		goto exit;
 	}
 
-	memcpy(&mibitem, &msg.mibattribute.data, sizeof(mibitem));
-
-	shortretry = mibitem.data;
-
-	mibitem.did = DIDmib_dot11mac_dot11OperationTable_dot11LongRetryLimit;
-
-	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
+	shortretry = value;
 
+	result = p80211wext_getmib(wlandev,
+				   DIDmib_dot11mac_dot11OperationTable_dot11LongRetryLimit,
+				   &value);
 	if (result) {
 		err = -EFAULT;
 		goto exit;
 	}
 
-	memcpy(&mibitem, &msg.mibattribute.data, sizeof(mibitem));
-
-	longretry = mibitem.data;
-
-	mibitem.did =
-	    DIDmib_dot11mac_dot11OperationTable_dot11MaxTransmitMSDULifetime;
-
-	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
+	longretry = value;
 
+	result = p80211wext_getmib(wlandev,
+				   DIDmib_dot11mac_dot11OperationTable_dot11MaxTransmitMSDULifetime,
+				   &value);
 	if (result) {
 		err = -EFAULT;
 		goto exit;
 	}
 
-	memcpy(&mibitem, &msg.mibattribute.data, sizeof(mibitem));
-
-	lifetime = mibitem.data;
+	lifetime = value;
 
 	rrq->disabled = 0;
 
@@ -1046,8 +1001,7 @@ static int p80211wext_siwretry(netdevice_t *dev,
 	p80211msg_dot11req_mibset_t msg;
 	int result;
 	int err = 0;
-
-	memset(&mibitem, 0, sizeof(mibitem));
+	unsigned int value;
 
 	if (!wlan_wext_write) {
 		err = (-EOPNOTSUPP);
@@ -1062,26 +1016,20 @@ static int p80211wext_siwretry(netdevice_t *dev,
 	msg.msgcode = DIDmsg_dot11req_mibset;
 
 	if ((rrq->flags & IW_RETRY_TYPE) == IW_RETRY_LIFETIME) {
-		mibitem.did =
-		    DIDmib_dot11mac_dot11OperationTable_dot11MaxTransmitMSDULifetime;
-		mibitem.data = rrq->value /= 1024;
-
-		memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
-		result = p80211req_dorequest(wlandev, (u8 *) &msg);
 
+		value = rrq->value /= 1024;
+		result = p80211wext_setmib(wlandev,
+					   DIDmib_dot11mac_dot11OperationTable_dot11MaxTransmitMSDULifetime,
+					   value);
 		if (result) {
 			err = -EFAULT;
 			goto exit;
 		}
 	} else {
 		if (rrq->flags & IW_RETRY_LONG) {
-			mibitem.did =
-			    DIDmib_dot11mac_dot11OperationTable_dot11LongRetryLimit;
-			mibitem.data = rrq->value;
-
-			memcpy(&msg.mibattribute.data, &mibitem,
-			       sizeof(mibitem));
-			result = p80211req_dorequest(wlandev, (u8 *) &msg);
+			result = p80211wext_setmib(wlandev,
+						   DIDmib_dot11mac_dot11OperationTable_dot11LongRetryLimit,
+						   rrq->value);
 
 			if (result) {
 				err = -EFAULT;
@@ -1090,13 +1038,9 @@ static int p80211wext_siwretry(netdevice_t *dev,
 		}
 
 		if (rrq->flags & IW_RETRY_SHORT) {
-			mibitem.did =
-			    DIDmib_dot11mac_dot11OperationTable_dot11ShortRetryLimit;
-			mibitem.data = rrq->value;
-
-			memcpy(&msg.mibattribute.data, &mibitem,
-			       sizeof(mibitem));
-			result = p80211req_dorequest(wlandev, (u8 *) &msg);
+			result = p80211wext_setmib(wlandev,
+						   DIDmib_dot11mac_dot11OperationTable_dot11ShortRetryLimit,
+						   rrq->value);
 
 			if (result) {
 				err = -EFAULT;
@@ -1119,22 +1063,20 @@ static int p80211wext_siwtxpow(netdevice_t *dev,
 	p80211msg_dot11req_mibset_t msg;
 	int result;
 	int err = 0;
+	unsigned int value;
 
 	if (!wlan_wext_write) {
 		err = (-EOPNOTSUPP);
 		goto exit;
 	}
 
-	msg.msgcode = DIDmsg_dot11req_mibset;
-	memset(&mibitem, 0, sizeof(mibitem));
-	mibitem.did =
-	    DIDmib_dot11phy_dot11PhyTxPowerTable_dot11CurrentTxPowerLevel;
 	if (rrq->fixed == 0)
-		mibitem.data = 30;
+		value = 30;
 	else
-		mibitem.data = rrq->value;
-	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
+		value = rrq->value;
+	result = p80211wext_setmib(wlandev,
+				   DIDmib_dot11phy_dot11PhyTxPowerTable_dot11CurrentTxPowerLevel,
+				   value);
 
 	if (result) {
 		err = -EFAULT;
@@ -1150,33 +1092,25 @@ static int p80211wext_giwtxpow(netdevice_t *dev,
 			       struct iw_param *rrq, char *extra)
 {
 	wlandevice_t *wlandev = dev->ml_priv;
-	p80211item_uint32_t mibitem;
-	p80211msg_dot11req_mibset_t msg;
 	int result;
 	int err = 0;
+	unsigned int value;
 
-	msg.msgcode = DIDmsg_dot11req_mibget;
-
-	memset(&mibitem, 0, sizeof(mibitem));
-	mibitem.did =
-	    DIDmib_dot11phy_dot11PhyTxPowerTable_dot11CurrentTxPowerLevel;
-
-	memcpy(&msg.mibattribute.data, &mibitem, sizeof(mibitem));
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
+	result = p80211wext_getmib(wlandev,
+				   DIDmib_dot11phy_dot11PhyTxPowerTable_dot11CurrentTxPowerLevel,
+				   &value);
 
 	if (result) {
 		err = -EFAULT;
 		goto exit;
 	}
 
-	memcpy(&mibitem, &msg.mibattribute.data, sizeof(mibitem));
-
 	/* XXX handle OFF by setting disabled = 1; */
 
 	rrq->flags = 0;		/* IW_TXPOW_DBM; */
 	rrq->disabled = 0;
 	rrq->fixed = 0;
-	rrq->value = mibitem.data;
+	rrq->value = value;
 
 exit:
 	return err;
@@ -1481,7 +1415,7 @@ static int p80211wext_set_encodeext(struct net_device *dev,
 		}
 		pr_debug("setting default key (%d)\n", idx);
 		result =
-		    p80211wext_dorequest(wlandev,
+		    p80211wext_setmib(wlandev,
 					 DIDmib_dot11smt_dot11PrivacyTable_dot11WEPDefaultKeyID,
 					 idx);
 		if (result)
@@ -1601,12 +1535,12 @@ static int p80211_wext_set_iwauth(struct net_device *dev,
 		pr_debug("drop_unencrypted %d\n", param->value);
 		if (param->value)
 			result =
-			    p80211wext_dorequest(wlandev,
+			    p80211wext_setmib(wlandev,
 						 DIDmib_dot11smt_dot11PrivacyTable_dot11ExcludeUnencrypted,
 						 P80211ENUM_truth_true);
 		else
 			result =
-			    p80211wext_dorequest(wlandev,
+			    p80211wext_setmib(wlandev,
 						 DIDmib_dot11smt_dot11PrivacyTable_dot11ExcludeUnencrypted,
 						 P80211ENUM_truth_false);
 		break;
@@ -1615,12 +1549,12 @@ static int p80211_wext_set_iwauth(struct net_device *dev,
 		pr_debug("privacy invoked %d\n", param->value);
 		if (param->value)
 			result =
-			    p80211wext_dorequest(wlandev,
+			    p80211wext_setmib(wlandev,
 						 DIDmib_dot11smt_dot11PrivacyTable_dot11PrivacyInvoked,
 						 P80211ENUM_truth_true);
 		else
 			result =
-			    p80211wext_dorequest(wlandev,
+			    p80211wext_setmib(wlandev,
 						 DIDmib_dot11smt_dot11PrivacyTable_dot11PrivacyInvoked,
 						 P80211ENUM_truth_false);
 
-- 
1.6.6.1

