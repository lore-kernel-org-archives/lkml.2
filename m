Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab1ISUIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 16:08:39 -0400
Received: from mail-wy0-f175.google.com ([74.125.82.175]:47330 "EHLO
	mail-wy0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1ISUIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 16:08:38 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 1/3] staging: wlags49_h2: Remove old WIRELESS_EXT support
Date: Mon, 19 Sep 2011 21:08:14 +0100
Message-Id: <1316462896-17846-2-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316462896-17846-1-git-send-email-kilroyd@googlemail.com>
References: <1316462896-17846-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the driver is now in-kernel remove support for building
against ancient WIRELESS_EXT versions.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/wl_internal.h |    7 --
 drivers/staging/wlags49_h2/wl_version.h  |    3 -
 drivers/staging/wlags49_h2/wl_wext.c     |   96 ------------------------------
 drivers/staging/wlags49_h2/wl_wext.h     |    8 ---
 4 files changed, 0 insertions(+), 114 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_internal.h b/drivers/staging/wlags49_h2/wl_internal.h
index cd129b3..1508063 100644
--- a/drivers/staging/wlags49_h2/wl_internal.h
+++ b/drivers/staging/wlags49_h2/wl_internal.h
@@ -75,15 +75,8 @@
 #include <pcmcia/ds.h>
 #endif  // BUS_PCMCIA
 
-#ifdef HAS_WIRELESS_EXTENSIONS
 #include <linux/wireless.h>
-#if WIRELESS_EXT > 13
 #include <net/iw_handler.h>
-#endif // WIRELESS_EXT > 13
-#define USE_DBM
-#define RETURN_CURRENT_NETWORKNAME
-#define USE_FREQUENCY
-#endif // HAS_WIRELESS_EXTENSIONS/
 
 #include <linux/list.h>
 
diff --git a/drivers/staging/wlags49_h2/wl_version.h b/drivers/staging/wlags49_h2/wl_version.h
index a5e604c..872d085 100644
--- a/drivers/staging/wlags49_h2/wl_version.h
+++ b/drivers/staging/wlags49_h2/wl_version.h
@@ -158,9 +158,6 @@ err: define bus type;
  * There doesn't seem to be a difference for PCMCIA and PCI anymore, at least
  * for PCMCIA the same defines are needed now as previously only used for PCI
  */
-#if USE_WEXT
-#define HAS_WIRELESS_EXTENSIONS
-#endif  // USE_WEXT
 
 #define NEW_MULTICAST
 #define ALLOC_SKB(len)   dev_alloc_skb(len+2)
diff --git a/drivers/staging/wlags49_h2/wl_wext.c b/drivers/staging/wlags49_h2/wl_wext.c
index 522a310..fc453a8 100644
--- a/drivers/staging/wlags49_h2/wl_wext.c
+++ b/drivers/staging/wlags49_h2/wl_wext.c
@@ -77,11 +77,6 @@
 
 
 
-/* If WIRELESS_EXT is not defined (as a result of HAS_WIRELESS_EXTENSIONS
-   #including linux/wireless.h), then these functions do not need to be included
-   in the build. */
-#ifdef WIRELESS_EXT
-
 #define IWE_STREAM_ADD_EVENT(info, buf, end, iwe, len) \
     iwe_stream_add_event(info, buf, end, iwe, len)
 #define IWE_STREAM_ADD_POINT(info, buf, end, iwe, msg) \
@@ -324,16 +319,8 @@ static int wireless_get_frequency(struct net_device *dev, struct iw_request_info
 	if( ret == HCF_SUCCESS ) {
 		hcf_16 channel = CNV_LITTLE_TO_INT( lp->ltvRecord.u.u16[0] );
 
-#ifdef USE_FREQUENCY
-
 		freq->m = wl_get_freq_from_chan( channel ) * 100000;
 		freq->e = 1;
-#else
-
-		freq->m = channel;
-		freq->e = 0;
-
-#endif /* USE_FREQUENCY */
 	}
 
     	wl_act_int_on( lp );
@@ -460,8 +447,6 @@ retry:
 
 
 	/* Link quality */
-#ifdef USE_DBM
-
 	range->max_qual.qual     = (u_char)HCF_MAX_COMM_QUALITY;
 
 	/* If the value returned in /proc/net/wireless is greater than the maximum range,
@@ -470,13 +455,6 @@ retry:
 
 	range->max_qual.level   = (u_char)( dbm( HCF_MIN_SIGNAL_LEVEL ) - 1 );
 	range->max_qual.noise   = (u_char)( dbm( HCF_MIN_NOISE_LEVEL ) - 1 );
-#else
-
-	range->max_qual.qual    = 100;
-	range->max_qual.level   = 100;
-	range->max_qual.noise   = 100;
-
-#endif /* USE_DBM */
 
 
 	/* Set available rates */
@@ -508,8 +486,6 @@ retry:
 
 	/* Encryption */
 
-#if WIRELESS_EXT > 8
-
 	/* Holding the lock too long, make a gap to allow other processes */
 	wl_unlock(lp, &flags);
 	wl_lock( lp, &flags );
@@ -526,26 +502,17 @@ retry:
 		range->max_encoding_tokens   = MAX_KEYS;
 	}
 
-#endif /* WIRELESS_EXT > 8 */
-
 	/* Tx Power Info */
 	range->txpower_capa  = IW_TXPOW_MWATT;
 	range->num_txpower   = 1;
 	range->txpower[0]    = RADIO_TX_POWER_MWATT;
 
-#if WIRELESS_EXT > 10
-
 	/* Wireless Extension Info */
 	range->we_version_compiled   = WIRELESS_EXT;
 	range->we_version_source     = WIRELESS_SUPPORT;
 
 	// Retry Limits and Lifetime - NOT SUPPORTED
 
-#endif
-
-
-#if WIRELESS_EXT > 11
-
 	/* Holding the lock too long, make a gap to allow other processes */
 	wl_unlock(lp, &flags);
 	wl_lock( lp, &flags );
@@ -555,8 +522,6 @@ retry:
 	range->avg_qual = lp->wstats.qual;
 	DBG_TRACE( DbgInfo, "wl_wireless_stats done\n" );
 
-#endif
-
 	/* Event capability (kernel + driver) */
 	range->event_capa[0] = (IW_EVENT_CAPA_K_0 |
 				IW_EVENT_CAPA_MASK(SIOCGIWAP) |
@@ -1087,7 +1052,6 @@ static int wireless_get_essid(struct net_device *dev, struct iw_request_info *in
 
 #if 1 //;? (HCF_TYPE) & HCF_TYPE_STA
 					//;?should we return an error status in AP mode
-#ifdef RETURN_CURRENT_NETWORKNAME
 
 		/* if desired is null ("any"), return current or "any" */
 		if( pName->name[0] == '\0' ) {
@@ -1116,7 +1080,6 @@ static int wireless_get_essid(struct net_device *dev, struct iw_request_info *in
 			}
 		}
 
-#endif // RETURN_CURRENT_NETWORKNAME
 #endif // HCF_STA
 
 		data->length--;
@@ -1170,10 +1133,7 @@ static int wireless_set_encode(struct net_device *dev, struct iw_request_info *i
 	struct wl_private *lp = wl_priv(dev);
 	unsigned long flags;
 	int     ret = 0;
-
-#if 1 //;? #if WIRELESS_EXT > 8 - used unconditionally in the rest of the code...
 	hcf_8   encryption_state;
-#endif // WIRELESS_EXT > 8
 	/*------------------------------------------------------------------------*/
 
 
@@ -2023,11 +1983,9 @@ static int wireless_set_rts_threshold (struct net_device *dev, struct iw_request
 		goto out;
 	}
 
-#if WIRELESS_EXT > 8
 	if( rts->disabled ) {
 		rthr = 2347;
 	}
-#endif /* WIRELESS_EXT > 8 */
 
 	if(( rthr < 256 ) || ( rthr > 2347 )) {
 		ret = -EINVAL;
@@ -2095,12 +2053,8 @@ static int wireless_get_rts_threshold (struct net_device *dev, struct iw_request
 
 	rts->value = lp->RTSThreshold;
 
-#if WIRELESS_EXT > 8
-
 	rts->disabled = ( rts->value == 2347 );
 
-#endif /* WIRELESS_EXT > 8 */
-
 	rts->fixed = 1;
 
     	wl_act_int_on( lp );
@@ -2527,8 +2481,6 @@ out:
 
 
 
-#if WIRELESS_EXT > 13
-
 /*******************************************************************************
  *	wireless_set_scan()
  *******************************************************************************
@@ -2810,7 +2762,6 @@ static int wireless_get_scan(struct net_device *dev, struct iw_request_info *inf
 		buf = IWE_STREAM_ADD_EVENT(info, buf, buf_end, &iwe, IW_EV_FREQ_LEN);
 
 
-#if WIRELESS_EXT > 14
 		/* Custom info (Beacon Interval) */
 		memset( &iwe, 0, sizeof( iwe ));
 		memset( msg, 0, sizeof( msg ));
@@ -2839,7 +2790,6 @@ static int wireless_get_scan(struct net_device *dev, struct iw_request_info *inf
 		}
 
 		/* Add other custom info in formatted string format as needed... */
-#endif
 	}
 
 	data->length = buf - extra;
@@ -2856,11 +2806,8 @@ out:
 } // wireless_get_scan
 /*============================================================================*/
 
-#endif  // WIRELESS_EXT > 13
 
 
-#if WIRELESS_EXT > 17
-
 static int wireless_set_auth(struct net_device *dev,
 			  struct iw_request_info *info,
 			  struct iw_param *data, char *extra)
@@ -3261,8 +3208,6 @@ out:
 /*============================================================================*/
 
 
-#endif // WIRELESS_EXT > 17
-
 /*******************************************************************************
  *	wl_wireless_stats()
  *******************************************************************************
@@ -3316,7 +3261,6 @@ struct iw_statistics * wl_wireless_stats( struct net_device *dev )
 		if( status == HCF_SUCCESS ) {
 			pQual = (CFG_COMMS_QUALITY_STRCT *)&( lp->ltvRecord );
 
-#ifdef USE_DBM
 			pStats->qual.qual  = (u_char) CNV_LITTLE_TO_INT( pQual->coms_qual );
 			pStats->qual.level = (u_char) dbm( CNV_LITTLE_TO_INT( pQual->signal_lvl ));
 			pStats->qual.noise = (u_char) dbm( CNV_LITTLE_TO_INT( pQual->noise_lvl ));
@@ -3325,23 +3269,6 @@ struct iw_statistics * wl_wireless_stats( struct net_device *dev )
                                                  IW_QUAL_LEVEL_UPDATED |
                                                  IW_QUAL_NOISE_UPDATED |
                                                  IW_QUAL_DBM);
-#else
-			pStats->qual.qual = percent( CNV_LITTLE_TO_INT( pQual->coms_qual ),
-						     HCF_MIN_COMM_QUALITY,
-						     HCF_MAX_COMM_QUALITY );
-
-			pStats->qual.level = percent( CNV_LITTLE_TO_INT( pQual->signal_lvl ),
-						      HCF_MIN_SIGNAL_LEVEL,
-						      HCF_MAX_SIGNAL_LEVEL );
-
-			pStats->qual.noise = percent( CNV_LITTLE_TO_INT( pQual->noise_lvl ),
-						      HCF_MIN_NOISE_LEVEL,
-						      HCF_MAX_NOISE_LEVEL );
-
-			pStats->qual.updated |= (IW_QUAL_QUAL_UPDATED  |
-                                                 IW_QUAL_LEVEL_UPDATED |
-                                                 IW_QUAL_NOISE_UPDATED);
-#endif /* USE_DBM */
 		} else {
 			memset( &( pStats->qual ), 0, sizeof( pStats->qual ));
 		}
@@ -3512,7 +3439,6 @@ inline void wl_spy_gather( struct net_device *dev, u_char *mac )
  ******************************************************************************/
 void wl_wext_event_freq( struct net_device *dev )
 {
-#if WIRELESS_EXT > 13
 	union iwreq_data wrqu;
 	struct wl_private *lp = wl_priv(dev);
 	/*------------------------------------------------------------------------*/
@@ -3524,7 +3450,6 @@ void wl_wext_event_freq( struct net_device *dev )
 	wrqu.freq.e = 0;
 
 	wireless_send_event( dev, SIOCSIWFREQ, &wrqu, NULL );
-#endif /* WIRELESS_EXT > 13 */
 
 	return;
 } // wl_wext_event_freq
@@ -3554,7 +3479,6 @@ void wl_wext_event_freq( struct net_device *dev )
  ******************************************************************************/
 void wl_wext_event_mode( struct net_device *dev )
 {
-#if WIRELESS_EXT > 13
 	union iwreq_data wrqu;
 	struct wl_private *lp = wl_priv(dev);
 	/*------------------------------------------------------------------------*/
@@ -3569,7 +3493,6 @@ void wl_wext_event_mode( struct net_device *dev )
 	}
 
 	wireless_send_event( dev, SIOCSIWMODE, &wrqu, NULL );
-#endif /* WIRELESS_EXT > 13 */
 
 	return;
 } // wl_wext_event_mode
@@ -3599,7 +3522,6 @@ void wl_wext_event_mode( struct net_device *dev )
  ******************************************************************************/
 void wl_wext_event_essid( struct net_device *dev )
 {
-#if WIRELESS_EXT > 13
 	union iwreq_data wrqu;
 	struct wl_private *lp = wl_priv(dev);
 	/*------------------------------------------------------------------------*/
@@ -3616,7 +3538,6 @@ void wl_wext_event_essid( struct net_device *dev )
 	wrqu.essid.flags   = 1;
 
 	wireless_send_event( dev, SIOCSIWESSID, &wrqu, lp->NetworkName );
-#endif /* WIRELESS_EXT > 13 */
 
 	return;
 } // wl_wext_event_essid
@@ -3646,7 +3567,6 @@ void wl_wext_event_essid( struct net_device *dev )
  ******************************************************************************/
 void wl_wext_event_encode( struct net_device *dev )
 {
-#if WIRELESS_EXT > 13
 	union iwreq_data wrqu;
 	struct wl_private *lp = wl_priv(dev);
 	int index = 0;
@@ -3688,7 +3608,6 @@ void wl_wext_event_encode( struct net_device *dev )
 
 	wireless_send_event( dev, SIOCSIWENCODE, &wrqu,
 						 lp->DefaultKeys.key[index].key );
-#endif /* WIRELESS_EXT > 13 */
 
 	return;
 } // wl_wext_event_encode
@@ -3718,7 +3637,6 @@ void wl_wext_event_encode( struct net_device *dev )
  ******************************************************************************/
 void wl_wext_event_ap( struct net_device *dev )
 {
-#if WIRELESS_EXT > 13
 	union iwreq_data wrqu;
 	struct wl_private *lp = wl_priv(dev);
 	int status;
@@ -3747,8 +3665,6 @@ void wl_wext_event_ap( struct net_device *dev )
 		wireless_send_event( dev, SIOCGIWAP, &wrqu, NULL );
 	}
 
-#endif /* WIRELESS_EXT > 13 */
-
 	return;
 } // wl_wext_event_ap
 /*============================================================================*/
@@ -3776,7 +3692,6 @@ void wl_wext_event_ap( struct net_device *dev )
  ******************************************************************************/
 void wl_wext_event_scan_complete( struct net_device *dev )
 {
-#if WIRELESS_EXT > 13
 	union iwreq_data wrqu;
 	/*------------------------------------------------------------------------*/
 
@@ -3785,7 +3700,6 @@ void wl_wext_event_scan_complete( struct net_device *dev )
 
 	wrqu.addr.sa_family = ARPHRD_ETHER;
 	wireless_send_event( dev, SIOCGIWSCAN, &wrqu, NULL );
-#endif /* WIRELESS_EXT > 13 */
 
 	return;
 } // wl_wext_event_scan_complete
@@ -3815,7 +3729,6 @@ void wl_wext_event_scan_complete( struct net_device *dev )
  ******************************************************************************/
 void wl_wext_event_new_sta( struct net_device *dev )
 {
-#if WIRELESS_EXT > 14
 	union iwreq_data wrqu;
 	/*------------------------------------------------------------------------*/
 
@@ -3826,7 +3739,6 @@ void wl_wext_event_new_sta( struct net_device *dev )
 	memcpy( wrqu.addr.sa_data, dev->dev_addr, ETH_ALEN );
 	wrqu.addr.sa_family = ARPHRD_ETHER;
 	wireless_send_event( dev, IWEVREGISTERED, &wrqu, NULL );
-#endif /* WIRELESS_EXT > 14 */
 
 	return;
 } // wl_wext_event_new_sta
@@ -3856,7 +3768,6 @@ void wl_wext_event_new_sta( struct net_device *dev )
  ******************************************************************************/
 void wl_wext_event_expired_sta( struct net_device *dev )
 {
-#if WIRELESS_EXT > 14
 	union iwreq_data wrqu;
 	/*------------------------------------------------------------------------*/
 
@@ -3866,7 +3777,6 @@ void wl_wext_event_expired_sta( struct net_device *dev )
 	memcpy( wrqu.addr.sa_data, dev->dev_addr, ETH_ALEN );
 	wrqu.addr.sa_family = ARPHRD_ETHER;
 	wireless_send_event( dev, IWEVEXPIRED, &wrqu, NULL );
-#endif /* WIRELESS_EXT > 14 */
 
 	return;
 } // wl_wext_event_expired_sta
@@ -3895,7 +3805,6 @@ void wl_wext_event_expired_sta( struct net_device *dev )
  ******************************************************************************/
 void wl_wext_event_mic_failed( struct net_device *dev )
 {
-#if WIRELESS_EXT > 14
 	char               msg[512];
 	union iwreq_data   wrqu;
 	struct wl_private *lp = wl_priv(dev);
@@ -3944,7 +3853,6 @@ void wl_wext_event_mic_failed( struct net_device *dev )
 #endif
 	wrqu.data.length = strlen( msg );
 	wireless_send_event( dev, IWEVCUSTOM, &wrqu, msg );
-#endif /* WIRELESS_EXT > 14 */
 
 	return;
 } // wl_wext_event_mic_failed
@@ -3974,7 +3882,6 @@ void wl_wext_event_mic_failed( struct net_device *dev )
  ******************************************************************************/
 void wl_wext_event_assoc_ie( struct net_device *dev )
 {
-#if WIRELESS_EXT > 14
 	char               msg[512];
 	union iwreq_data   wrqu;
 	struct wl_private *lp = wl_priv(dev);
@@ -4016,7 +3923,6 @@ void wl_wext_event_assoc_ie( struct net_device *dev )
 			wireless_send_event( dev, IWEVCUSTOM, &wrqu, msg );
 		}
 	}
-#endif /* WIRELESS_EXT > 14 */
 
 	return;
 }  // wl_wext_event_assoc_ie
@@ -4120,5 +4026,3 @@ const struct iw_handler_def wl_iw_handler_def =
         .standard           = (iw_handler *) wl_handler,
         .get_wireless_stats = wl_get_wireless_stats,
 };
-
-#endif // WIRELESS_EXT
diff --git a/drivers/staging/wlags49_h2/wl_wext.h b/drivers/staging/wlags49_h2/wl_wext.h
index 39d39a4..a713058 100644
--- a/drivers/staging/wlags49_h2/wl_wext.h
+++ b/drivers/staging/wlags49_h2/wl_wext.h
@@ -62,9 +62,6 @@
 #define __WL_WEXT_H__
 
 
-#ifdef WIRELESS_EXT
-
-
 /*******************************************************************************
  *  function protoypes
  ******************************************************************************/
@@ -88,9 +85,4 @@ void wl_wext_event_assoc_ie( struct net_device *dev );
 
 extern const struct iw_handler_def wl_iw_handler_def;
 
-#else
-#error WIRELESS_EXT
-#endif // WIRELESS_EXT
-
-
 #endif  // __WL_WEXT_H__
-- 
1.7.4.1

