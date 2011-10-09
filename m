Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab1JILMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 07:12:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51577 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1JILMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 07:12:03 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 5/7] staging: wlags49_h2: Make key setting more reliable
Date: Sun,  9 Oct 2011 12:11:35 +0100
Message-Id: <1318158697-15979-6-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318158697-15979-1-git-send-email-kilroyd@googlemail.com>
References: <1318158697-15979-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Share logic between encodeext and encode, so that we can handle
subtle differences between them (implied set_tx), and clear the
appropriate keys if you attempt to switch straight from WPA to
WEP and vice versa.

Also reinstate the TX buffer flush, and ensure the key index is
written to the card little endian.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/wl_internal.h |    6 +
 drivers/staging/wlags49_h2/wl_wext.c     |  655 +++++++++++++++---------------
 2 files changed, 340 insertions(+), 321 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_internal.h b/drivers/staging/wlags49_h2/wl_internal.h
index 9ed2857..5753408 100644
--- a/drivers/staging/wlags49_h2/wl_internal.h
+++ b/drivers/staging/wlags49_h2/wl_internal.h
@@ -980,6 +980,12 @@ struct wl_private
 #ifdef USE_WDS
 	WVLAN_WDS_IF                wds_port[NUM_WDS_PORTS];
 #endif // USE_WDS
+
+	/* Track whether the card is using WEP encryption or WPA
+	 * so we know what to disable next time through.
+	 *  IW_ENCODE_ALG_NONE, IW_ENCODE_ALG_WEP, IW_ENCODE_ALG_TKIP
+	 */
+	int wext_enc;
 }; // wl_private
 
 #define wl_priv(dev) ((struct wl_private *) netdev_priv(dev))
diff --git a/drivers/staging/wlags49_h2/wl_wext.c b/drivers/staging/wlags49_h2/wl_wext.c
index af9fec5..567a0dc 100644
--- a/drivers/staging/wlags49_h2/wl_wext.c
+++ b/drivers/staging/wlags49_h2/wl_wext.c
@@ -83,7 +83,223 @@ extern dbg_info_t *DbgInfo;
 #endif  // DBG
 
 
+/* Set up the LTV to program the appropriate key */
+static int hermes_set_tkip_keys(ltv_t *ltv, u16 key_idx, u8 *addr,
+				int set_tx, u8 *seq, u8 *key, size_t key_len)
+{
+	int ret = -EINVAL;
+	int buf_idx = 0;
+	hcf_8 tsc[IW_ENCODE_SEQ_MAX_SIZE] =
+		{ 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00 };
+
+	DBG_ENTER(DbgInfo);
+
+	/*
+	 * Check the key index here; if 0, load as Pairwise Key, otherwise,
+	 * load as a group key. Note that for the Hermes, the RIDs for
+	 * group/pairwise keys are different from each other and different
+	 * than the default WEP keys as well.
+	 */
+	switch (key_idx) {
+	case 0:
+		ltv->len = 28;
+		ltv->typ = CFG_ADD_TKIP_MAPPED_KEY;
+
+		/* Load the BSSID */
+		memcpy(&ltv->u.u8[buf_idx], addr, ETH_ALEN);
+		buf_idx += ETH_ALEN;
+
+		/* Load the TKIP key */
+		memcpy(&ltv->u.u8[buf_idx], &key[0], 16);
+		buf_idx += 16;
+
+		/* Load the TSC */
+		memcpy(&ltv->u.u8[buf_idx], tsc, IW_ENCODE_SEQ_MAX_SIZE);
+		buf_idx += IW_ENCODE_SEQ_MAX_SIZE;
+
+		/* Load the RSC */
+		memcpy(&ltv->u.u8[buf_idx], seq, IW_ENCODE_SEQ_MAX_SIZE);
+		buf_idx += IW_ENCODE_SEQ_MAX_SIZE;
+
+		/* Load the TxMIC key */
+		memcpy(&ltv->u.u8[buf_idx], &key[16], 8);
+		buf_idx += 8;
+
+		/* Load the RxMIC key */
+		memcpy(&ltv->u.u8[buf_idx], &key[24], 8);
+
+		ret = 0;
+		break;
+	case 1:
+	case 2:
+	case 3:
+		ltv->len = 26;
+		ltv->typ = CFG_ADD_TKIP_DEFAULT_KEY;
+
+		/* Load the key Index */
+
+		/* If this is a Tx Key, set bit 8000 */
+		if (set_tx)
+			key_idx |= 0x8000;
+		ltv->u.u16[buf_idx] = cpu_to_le16(key_idx);
+		buf_idx += 2;
+
+		/* Load the RSC */
+		memcpy(&ltv->u.u8[buf_idx], seq, IW_ENCODE_SEQ_MAX_SIZE);
+		buf_idx += IW_ENCODE_SEQ_MAX_SIZE;
+
+		/* Load the TKIP, TxMIC, and RxMIC keys in one shot, because in
+		   CFG_ADD_TKIP_DEFAULT_KEY they are back-to-back */
+		memcpy(&ltv->u.u8[buf_idx], key, key_len);
+		buf_idx += key_len;
+
+		/* Load the TSC */
+		memcpy(&ltv->u.u8[buf_idx], tsc, IW_ENCODE_SEQ_MAX_SIZE);
+
+		ret = 0;
+		break;
+	default:
+		break;
+	}
 
+	DBG_LEAVE(DbgInfo);
+	return ret;
+}
+
+/* Set up the LTV to clear the appropriate key */
+static int hermes_clear_tkip_keys(ltv_t *ltv, u16 key_idx, u8 *addr)
+{
+	int ret;
+
+	switch (key_idx) {
+	case 0:
+		if (memcmp(addr, "\xff\xff\xff\xff\xff\xff", ETH_ALEN) != 0) {
+			ltv->len = 7;
+			ltv->typ = CFG_REMOVE_TKIP_MAPPED_KEY;
+			memcpy(&ltv->u.u8[0], addr, ETH_ALEN);
+			ret = 0;
+		}
+		break;
+	case 1:
+	case 2:
+	case 3:
+		/* Clear the Group TKIP keys by index */
+		ltv->len = 2;
+		ltv->typ = CFG_REMOVE_TKIP_DEFAULT_KEY;
+		ltv->u.u16[0] = cpu_to_le16(key_idx);
+
+		ret = 0;
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+/* Set the WEP keys in the wl_private structure */
+static int hermes_set_wep_keys(struct wl_private *lp, u16 key_idx,
+			       u8 *key, size_t key_len,
+			       bool enable, bool set_tx)
+{
+	hcf_8  encryption_state = lp->EnableEncryption;
+	int tk = lp->TransmitKeyID - 1;	/* current key */
+	int ret = 0;
+
+	/* Is encryption supported? */
+	if (!wl_has_wep(&(lp->hcfCtx))) {
+		DBG_WARNING(DbgInfo, "WEP not supported on this device\n");
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	DBG_NOTICE(DbgInfo, "pointer: %p, length: %d\n",
+		   key, key_len);
+
+	/* Check the size of the key */
+	switch (key_len) {
+	case MIN_KEY_SIZE:
+	case MAX_KEY_SIZE:
+
+		/* Check the index */
+		if ((key_idx < 0) || (key_idx >= MAX_KEYS))
+			key_idx = tk;
+
+		/* Cleanup */
+		memset(lp->DefaultKeys.key[key_idx].key, 0, MAX_KEY_SIZE);
+
+		/* Copy the key in the driver */
+		memcpy(lp->DefaultKeys.key[key_idx].key, key, key_len);
+
+		/* Set the length */
+		lp->DefaultKeys.key[key_idx].len = key_len;
+
+		DBG_NOTICE(DbgInfo, "encoding.length: %d\n", key_len);
+		DBG_NOTICE(DbgInfo, "set key: %s(%d) [%d]\n",
+			   lp->DefaultKeys.key[key_idx].key,
+			   lp->DefaultKeys.key[key_idx].len, key_idx);
+
+		/* Enable WEP (if possible) */
+		if ((key_idx == tk) && (lp->DefaultKeys.key[tk].len > 0))
+			lp->EnableEncryption = 1;
+
+		break;
+
+	case 0:
+		/* Do we want to just set the current transmit key? */
+		if (set_tx && (key_idx >= 0) && (key_idx < MAX_KEYS)) {
+			DBG_NOTICE(DbgInfo, "index: %d; len: %d\n", key_idx,
+				   lp->DefaultKeys.key[key_idx].len);
+
+			if (lp->DefaultKeys.key[key_idx].len > 0) {
+				lp->TransmitKeyID    = key_idx + 1;
+				lp->EnableEncryption = 1;
+			} else {
+				DBG_WARNING(DbgInfo, "Problem setting the current TxKey\n");
+				ret = -EINVAL;
+			}
+		}
+		break;
+
+	default:
+		DBG_WARNING(DbgInfo, "Invalid Key length\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Read the flags */
+	if (enable) {
+		lp->EnableEncryption = 1;
+		lp->wext_enc = IW_ENCODE_ALG_WEP;
+	} else {
+		lp->EnableEncryption = 0;	/* disable encryption */
+		lp->wext_enc = IW_ENCODE_ALG_NONE;
+	}
+
+	DBG_TRACE(DbgInfo, "encryption_state :     %d\n", encryption_state);
+	DBG_TRACE(DbgInfo, "lp->EnableEncryption : %d\n", lp->EnableEncryption);
+	DBG_TRACE(DbgInfo, "erq->length          : %d\n", key_len);
+
+	/* Write the changes to the card */
+	if (ret == 0) {
+		DBG_NOTICE(DbgInfo, "encrypt: %d, ID: %d\n", lp->EnableEncryption,
+			   lp->TransmitKeyID);
+
+		if (lp->EnableEncryption == encryption_state) {
+			if (key_len != 0) {
+				/* Dynamic WEP key update */
+				wl_set_wep_keys(lp);
+			}
+		} else {
+			/* To switch encryption on/off, soft reset is
+			 * required */
+			wl_apply(lp);
+		}
+	}
+
+out:
+	return ret;
+}
 
 /*******************************************************************************
  *	wireless_commit()
@@ -1116,152 +1332,39 @@ static int wireless_set_encode(struct net_device *dev, struct iw_request_info *i
 {
 	struct wl_private *lp = wl_priv(dev);
 	unsigned long flags;
-	int     ret = 0;
-	hcf_8   encryption_state;
-	/*------------------------------------------------------------------------*/
-
+	int key_idx = (erq->flags & IW_ENCODE_INDEX) - 1;
+	int ret = 0;
+	bool enable = true;
 
-	DBG_FUNC( "wireless_set_encode" );
-	DBG_ENTER( DbgInfo );
+	DBG_ENTER(DbgInfo);
 
-	if(lp->portState == WVLAN_PORT_STATE_DISABLED) {
+	if (lp->portState == WVLAN_PORT_STATE_DISABLED) {
 		ret = -EBUSY;
 		goto out;
 	}
 
-	wl_lock( lp, &flags );
-
-    	wl_act_int_off( lp );
-
-	/* Is encryption supported? */
-	if( !wl_has_wep( &( lp->hcfCtx ))) {
-		DBG_WARNING( DbgInfo, "WEP not supported on this device\n" );
-		ret = -EOPNOTSUPP;
-		goto out_unlock;
-	}
-
-	DBG_NOTICE( DbgInfo, "pointer: %p, length: %d, flags: %#x\n",
-				keybuf, erq->length,
-				erq->flags);
-
-	/* Save state of Encryption switch */
-	encryption_state = lp->EnableEncryption;
-
-	/* Basic checking: do we have a key to set? */
-	if((erq->length) != 0) {
-		int index   = ( erq->flags & IW_ENCODE_INDEX ) - 1;
-		int tk      = lp->TransmitKeyID - 1;		// current key
-
-
-		/* Check the size of the key */
-		switch(erq->length) {
-		case 0:
-			break;
-
-		case MIN_KEY_SIZE:
-		case MAX_KEY_SIZE:
-
-			/* Check the index */
-			if(( index < 0 ) || ( index >= MAX_KEYS )) {
-				index = tk;
-			}
-
-			/* Cleanup */
-			memset( lp->DefaultKeys.key[index].key, 0, MAX_KEY_SIZE );
-
-			/* Copy the key in the driver */
-			memcpy( lp->DefaultKeys.key[index].key, keybuf, erq->length);
-
-			/* Set the length */
-			lp->DefaultKeys.key[index].len = erq->length;
-
-			DBG_NOTICE( DbgInfo, "encoding.length: %d\n", erq->length );
-			DBG_NOTICE( DbgInfo, "set key: %s(%d) [%d]\n", lp->DefaultKeys.key[index].key,
-						lp->DefaultKeys.key[index].len, index );
-
-			/* Enable WEP (if possible) */
-			if(( index == tk ) && ( lp->DefaultKeys.key[tk].len > 0 )) {
-				lp->EnableEncryption = 1;
-			}
-
-			break;
-
-		default:
-			DBG_WARNING( DbgInfo, "Invalid Key length\n" );
-			ret = -EINVAL;
-			goto out_unlock;
-		}
-	} else {
-		int index = ( erq->flags & IW_ENCODE_INDEX ) - 1;
-
-
-		/* Do we want to just set the current transmit key? */
-		if(( index >= 0 ) && ( index < MAX_KEYS )) {
-			DBG_NOTICE( DbgInfo, "index: %d; len: %d\n", index,
-						lp->DefaultKeys.key[index].len );
-
-			if( lp->DefaultKeys.key[index].len > 0 ) {
-				lp->TransmitKeyID       = index + 1;
-				lp->EnableEncryption    = 1;
-			} else {
-				DBG_WARNING( DbgInfo, "Problem setting the current TxKey\n" );
-				ret = -EINVAL;
-			}
-		}
-	}
-
-	/* Read the flags */
-	if( erq->flags & IW_ENCODE_DISABLED ) {
-		lp->EnableEncryption = 0;	// disable encryption
-	} else {
-		lp->EnableEncryption = 1;
-	}
+	if (erq->flags & IW_ENCODE_DISABLED)
+		enable = false;
 
-	if( erq->flags & IW_ENCODE_RESTRICTED ) {
-		DBG_WARNING( DbgInfo, "IW_ENCODE_RESTRICTED invalid\n" );
-		ret = -EINVAL;		// Invalid
-	}
+	wl_lock(lp, &flags);
 
-	DBG_TRACE( DbgInfo, "encryption_state :       %d\n", encryption_state );
-	DBG_TRACE( DbgInfo, "lp->EnableEncryption :   %d\n", lp->EnableEncryption );
-	DBG_TRACE( DbgInfo, "erq->length            : %d\n",
-			   erq->length);
-	DBG_TRACE( DbgInfo, "erq->flags             : 0x%x\n",
-			   erq->flags);
+	wl_act_int_off(lp);
 
-	/* Write the changes to the card */
-	if( ret == 0 ) {
-		DBG_NOTICE( DbgInfo, "encrypt: %d, ID: %d\n", lp->EnableEncryption,
-					lp->TransmitKeyID );
-
-		if( lp->EnableEncryption == encryption_state ) {
-			if( erq->length != 0 ) {
-				/* Dynamic WEP key update */
-				wl_set_wep_keys( lp );
-			}
-		} else {
-			/* To switch encryption on/off, soft reset is required */
-			wl_apply( lp );
-		}
-	}
+	ret = hermes_set_wep_keys(lp, key_idx, keybuf, erq->length,
+				  enable, true);
 
 	/* Send an event that Encryption has been set */
-	wl_wext_event_encode( dev );
+	if (ret == 0)
+		wl_wext_event_encode(dev);
 
-out_unlock:
-
-    	wl_act_int_on( lp );
+	wl_act_int_on(lp);
 
 	wl_unlock(lp, &flags);
 
 out:
-	DBG_LEAVE( DbgInfo );
+	DBG_LEAVE(DbgInfo);
 	return ret;
-} // wireless_set_encode
-/*============================================================================*/
-
-
-
+}
 
 /*******************************************************************************
  *	wireless_get_encode()
@@ -2911,243 +3014,153 @@ out:
 /*============================================================================*/
 
 
-
-static int hermes_set_key(ltv_t *ltv, int alg, int key_idx, u8 *addr,
-			  int set_tx, u8 *seq, u8 *key, size_t key_len)
+static void flush_tx(struct wl_private *lp)
 {
-	int ret = -EINVAL;
-	// int   count = 0;
-	int   buf_idx = 0;
-	hcf_8 tsc[IW_ENCODE_SEQ_MAX_SIZE] =
-		{ 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00 };
-
-	DBG_FUNC( "hermes_set_key" );
-	DBG_ENTER( DbgInfo );
+	ltv_t ltv;
+	int count;
 
 	/*
-         * Check the key index here; if 0, load as Pairwise Key, otherwise,
-         * load as a group key. Note that for the Hermes, the RIDs for
-         * group/pariwise keys are different from each other and different
-         * than the default WEP keys as well.
-         */
-	switch (alg)
-	{
-	case IW_ENCODE_ALG_TKIP:
-		DBG_TRACE( DbgInfo, "IW_ENCODE_ALG_TKIP: key(%d)\n", key_idx);
-#if 0
-		/*
-                 * Make sure that there is no data queued up in the firmware
-                 * before setting the TKIP keys. If this check is not
-                 * performed, some data may be sent out with incorrect MIC
-                 * and cause synchronizarion errors with the AP
-                 */
-		/* Check every 1ms for 100ms */
-		for( count = 0; count < 100; count++ )
-		{
-			usleep( 1000 );
+	 * Make sure that there is no data queued up in the firmware
+	 * before setting the TKIP keys. If this check is not
+	 * performed, some data may be sent out with incorrect MIC
+	 * and cause synchronizarion errors with the AP
+	 */
+	/* Check every 1ms for 100ms */
+	for (count = 0; count < 100; count++) {
+		udelay(1000);
+
+		ltv.len = 2;
+		ltv.typ = 0xFD91;  /* This RID not defined in HCF yet!!! */
+		ltv.u.u16[0] = 0;
+
+		hcf_get_info(&(lp->hcfCtx), (LTVP)&ltv);
+
+		if (ltv.u.u16[0] == 0)
+			break;
+	}
 
-			ltv.len = 2;
-			ltv.typ = 0xFD91;  // This RID not defined in HCF yet!!!
-			ltv.u.u16[0] = 0;
+	if (count >= 100)
+		DBG_TRACE(DbgInfo, "Timed out waiting for TxQ flush!\n");
 
-			wl_get_info( sock, &ltv, ifname );
+}
 
-			if( ltv.u.u16[0] == 0 )
-			{
-				break;
-			}
-		}
+static int wireless_set_encodeext(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_point *erq, char *keybuf)
+{
+	struct wl_private *lp = wl_priv(dev);
+	unsigned long flags;
+	int ret;
+	int key_idx = (erq->flags & IW_ENCODE_INDEX) - 1;
+	ltv_t ltv;
+	struct iw_encode_ext *ext = (struct iw_encode_ext *)keybuf;
+	bool enable = true;
+	bool set_tx = false;
 
-		if( count == 100 )
-		{
-			wpa_printf( MSG_DEBUG, "Timed out waiting for TxQ!" );
-		}
-#endif
+	DBG_ENTER(DbgInfo);
 
-		switch (key_idx) {
-		case 0:
-			ltv->len = 28;
-			ltv->typ = CFG_ADD_TKIP_MAPPED_KEY;
+	if (lp->portState == WVLAN_PORT_STATE_DISABLED) {
+		ret = -EBUSY;
+		goto out;
+	}
 
-			/* Load the BSSID */
-			memcpy(&ltv->u.u8[buf_idx], addr, ETH_ALEN);
-			buf_idx += ETH_ALEN;
+	if (erq->flags & IW_ENCODE_DISABLED) {
+		ext->alg = IW_ENCODE_ALG_NONE;
+		enable = false;
+	}
 
-			/* Load the TKIP key */
-			memcpy(&ltv->u.u8[buf_idx], &key[0], 16);
-			buf_idx += 16;
+	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)
+		set_tx = true;
 
-			/* Load the TSC */
-			memcpy(&ltv->u.u8[buf_idx], tsc, IW_ENCODE_SEQ_MAX_SIZE);
-			buf_idx += IW_ENCODE_SEQ_MAX_SIZE;
+	wl_lock(lp, &flags);
 
-			/* Load the RSC */
-			memcpy(&ltv->u.u8[buf_idx], seq, IW_ENCODE_SEQ_MAX_SIZE);
-			buf_idx += IW_ENCODE_SEQ_MAX_SIZE;
+	wl_act_int_off(lp);
 
-			/* Load the TxMIC key */
-			memcpy(&ltv->u.u8[buf_idx], &key[16], 8);
-			buf_idx += 8;
+	memset(&ltv, 0, sizeof(ltv));
 
-			/* Load the RxMIC key */
-			memcpy(&ltv->u.u8[buf_idx], &key[24], 8);
+	switch (ext->alg) {
+	case IW_ENCODE_ALG_TKIP:
+		DBG_TRACE(DbgInfo, "IW_ENCODE_ALG_TKIP: key(%d)\n", key_idx);
 
-			ret = 0;
-			break;
-		case 1:
-		case 2:
-		case 3:
-			ltv->len = 26;
-			ltv->typ = CFG_ADD_TKIP_DEFAULT_KEY;
+		if (sizeof(ext->rx_seq) != 8) {
+			DBG_TRACE(DbgInfo, "rx_seq size mismatch\n");
+			DBG_LEAVE(DbgInfo);
+			ret = -EINVAL;
+			goto out_unlock;
+		}
 
-			/* Load the key Index */
-			ltv->u.u16[buf_idx] = key_idx;
-			/* If this is a Tx Key, set bit 8000 */
-			if(set_tx)
-				ltv->u.u16[buf_idx] |= 0x8000;
-			buf_idx += 2;
+		ret = hermes_set_tkip_keys(&ltv, key_idx, ext->addr.sa_data,
+					   set_tx,
+					   ext->rx_seq, ext->key, ext->key_len);
 
-			/* Load the RSC */
-			memcpy(&ltv->u.u8[buf_idx], seq, IW_ENCODE_SEQ_MAX_SIZE);
-			buf_idx += IW_ENCODE_SEQ_MAX_SIZE;
+		if (ret != 0) {
+			DBG_TRACE(DbgInfo, "hermes_set_tkip_keys returned != 0, key not set\n");
+			goto out_unlock;
+		}
 
-			/* Load the TKIP, TxMIC, and RxMIC keys in one shot, because in
-			   CFG_ADD_TKIP_DEFAULT_KEY they are back-to-back */
-			memcpy(&ltv->u.u8[buf_idx], key, key_len);
-			buf_idx += key_len;
+		flush_tx(lp);
 
-			/* Load the TSC */
-			memcpy(&ltv->u.u8[buf_idx], tsc, IW_ENCODE_SEQ_MAX_SIZE);
+		lp->wext_enc = IW_ENCODE_ALG_TKIP;
 
-			ltv->u.u16[0] = CNV_INT_TO_LITTLE(ltv->u.u16[0]);
+		/* Write the key */
+		ret = hcf_put_info(&(lp->hcfCtx), (LTVP)&ltv);
+		break;
 
-			ret = 0;
-			break;
-		default:
-			break;
+	case IW_ENCODE_ALG_WEP:
+		DBG_TRACE(DbgInfo, "IW_ENCODE_ALG_WEP: key(%d)\n", key_idx);
+
+		if (erq->flags & IW_ENCODE_RESTRICTED) {
+			DBG_WARNING(DbgInfo, "IW_ENCODE_RESTRICTED invalid\n");
+			ret = -EINVAL;
+			goto out_unlock;
 		}
 
-		break;
+		ret = hermes_set_wep_keys(lp, key_idx, ext->key, ext->key_len,
+					  enable, set_tx);
 
-	case IW_ENCODE_ALG_WEP:
-		DBG_TRACE( DbgInfo, "IW_ENCODE_ALG_WEP: key(%d)\n", key_idx);
 		break;
 
 	case IW_ENCODE_ALG_CCMP:
-		DBG_TRACE( DbgInfo, "IW_ENCODE_ALG_CCMP: key(%d)\n", key_idx);
+		DBG_TRACE(DbgInfo, "IW_ENCODE_ALG_CCMP: key(%d)\n", key_idx);
+		ret = -EOPNOTSUPP;
 		break;
 
 	case IW_ENCODE_ALG_NONE:
-		DBG_TRACE( DbgInfo, "IW_ENCODE_ALG_NONE: key(%d)\n", key_idx);
-		switch (key_idx) {
-		case 0:
-			if (memcmp(addr, "\xff\xff\xff\xff\xff\xff", ETH_ALEN) != 0) {
-			//if (addr != NULL) {
-				ltv->len = 7;
-				ltv->typ = CFG_REMOVE_TKIP_MAPPED_KEY;
-				memcpy(&ltv->u.u8[0], addr, ETH_ALEN);
-				ret = 0;
-			}
-			break;
-		case 1:
-		case 2:
-		case 3:
-			/* Clear the Group TKIP keys by index */
-			ltv->len = 2;
-			ltv->typ = CFG_REMOVE_TKIP_DEFAULT_KEY;
-			ltv->u.u16[0] = key_idx;
-
+		DBG_TRACE(DbgInfo, "IW_ENCODE_ALG_NONE: key(%d)\n", key_idx);
+
+		if (lp->wext_enc == IW_ENCODE_ALG_TKIP) {
+			ret = hermes_clear_tkip_keys(&ltv, key_idx,
+						     ext->addr.sa_data);
+			flush_tx(lp);
+			lp->wext_enc = IW_ENCODE_ALG_NONE;
+			ret = hcf_put_info(&(lp->hcfCtx), (LTVP)&ltv);
+
+		} else if (lp->wext_enc == IW_ENCODE_ALG_WEP) {
+			ret = hermes_set_wep_keys(lp, key_idx,
+						  ext->key, ext->key_len,
+						  false, false);
+		} else {
 			ret = 0;
-			break;
-		default:
-			break;
 		}
+
 		break;
+
 	default:
 		DBG_TRACE( DbgInfo, "IW_ENCODE_??: key(%d)\n", key_idx);
+		ret = -EOPNOTSUPP;
 		break;
 	}
 
-	DBG_LEAVE( DbgInfo );
-	return ret;
-} // hermes_set_key
-/*============================================================================*/
-
-
-
-static int wireless_set_encodeext (struct net_device *dev,
-					struct iw_request_info *info,
-					struct iw_point *erq, char *keybuf)
-{
-	struct wl_private *lp = wl_priv(dev);
-	unsigned long flags;
-	int			      ret;
-	int key_idx = (erq->flags&IW_ENCODE_INDEX) - 1;
-	ltv_t ltv;
-	struct iw_encode_ext *ext = (struct iw_encode_ext *)keybuf;
-
-	DBG_FUNC( "wireless_set_encodeext" );
-	DBG_ENTER( DbgInfo );
-
-	if(lp->portState == WVLAN_PORT_STATE_DISABLED) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	if (sizeof(ext->rx_seq) != 8) {
-		DBG_TRACE(DbgInfo, "rz_seq size mismatch\n");
-		DBG_LEAVE(DbgInfo);
-		return -EINVAL;
-	}
-
-	/* Handle WEP keys via the old set encode procedure */
-	if(ext->alg == IW_ENCODE_ALG_WEP) {
-		struct iw_point  wep_erq;
-		char            *wep_keybuf;
-
-		/* Build request structure */
-		wep_erq.flags  = erq->flags;   // take over flags with key index
-		wep_erq.length = ext->key_len; // take length from extended key info
-		wep_keybuf     = ext->key;     // pointer to the key text
-
-		/* Call wireless_set_encode tot handle the WEP key */
-		ret = wireless_set_encode(dev, info, &wep_erq, wep_keybuf);
-		goto out;
-	}
-
-	/* Proceed for extended encode functions for WAP and NONE */
-	wl_lock( lp, &flags );
-
-    	wl_act_int_off( lp );
-
-	memset(&ltv, 0, sizeof(ltv));
-	ret = hermes_set_key(&ltv, ext->alg, key_idx, ext->addr.sa_data,
-				ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY,
-				ext->rx_seq, ext->key, ext->key_len);
-
-	if (ret != 0) {
-		DBG_TRACE( DbgInfo, "hermes_set_key returned != 0, key not set\n");
-		goto out_unlock;
-	}
-
-	/* Put the key in HCF */
-	ret = hcf_put_info(&(lp->hcfCtx), (LTVP)&ltv);
-
 out_unlock:
-	if(ret == HCF_SUCCESS) {
-		DBG_TRACE( DbgInfo, "Put key info succes\n");
-	} else {
-		DBG_TRACE( DbgInfo, "Put key info failed, key not set\n");
-	}
 
-    	wl_act_int_on( lp );
+	wl_act_int_on(lp);
 
 	wl_unlock(lp, &flags);
 
 out:
-	DBG_LEAVE( DbgInfo );
+	DBG_LEAVE(DbgInfo);
 	return ret;
-} // wireless_set_encodeext
+}
 /*============================================================================*/
 
 
-- 
1.7.4.1

