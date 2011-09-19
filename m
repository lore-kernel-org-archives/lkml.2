Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab1ISUIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 16:08:43 -0400
Received: from mail-wy0-f175.google.com ([74.125.82.175]:47330 "EHLO
	mail-wy0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1ISUIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 16:08:41 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 2/3] staging: wlags49_h2: Support standard WEXT events
Date: Mon, 19 Sep 2011 21:08:15 +0100
Message-Id: <1316462896-17846-3-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316462896-17846-1-git-send-email-kilroyd@googlemail.com>
References: <1316462896-17846-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... instead of using IWEVCUSTOM. Use the defined events for
michael mic failure, association request info and association
response info.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/wl_wext.c |   56 +++++++++++-----------------------
 1 files changed, 18 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_wext.c b/drivers/staging/wlags49_h2/wl_wext.c
index fc453a8..917c949 100644
--- a/drivers/staging/wlags49_h2/wl_wext.c
+++ b/drivers/staging/wlags49_h2/wl_wext.c
@@ -3805,9 +3805,9 @@ void wl_wext_event_expired_sta( struct net_device *dev )
  ******************************************************************************/
 void wl_wext_event_mic_failed( struct net_device *dev )
 {
-	char               msg[512];
 	union iwreq_data   wrqu;
 	struct wl_private *lp = wl_priv(dev);
+	struct iw_michaelmicfailure wxmic;
 	int                key_idx;
 	char              *addr1;
 	char              *addr2;
@@ -3829,30 +3829,17 @@ void wl_wext_event_mic_failed( struct net_device *dev )
 	DBG_PRINT( "MIC FAIL - KEY USED : %d, STATUS : 0x%04x\n", key_idx,
 			   hdr->status );
 
-	memset( &wrqu, 0, sizeof( wrqu ));
-	memset( msg, 0, sizeof( msg ));
-
+	memset(&wrqu, 0, sizeof(wrqu));
+	memset(&wxmic, 0, sizeof(wxmic));
 
-	/* Because MIC failures are not part of the Wireless Extensions yet, they
-	   must be passed as a string using an IWEVCUSTOM event. In order for the
-	   event to be effective, the string format must be known by both the
-	   driver and the supplicant. The following is the string format used by the
-	   hostap project's WPA supplicant, and will be used here until the Wireless
-	   Extensions interface adds this support:
+	wxmic.flags = key_idx & IW_MICFAILURE_KEY_ID;
+	wxmic.flags |= (addr1[0] & 1) ?
+		IW_MICFAILURE_GROUP : IW_MICFAILURE_PAIRWISE;
+	wxmic.src_addr.sa_family = ARPHRD_ETHER;
+	memcpy(wxmic.src_addr.sa_data, addr2, ETH_ALEN);
 
-	   MLME-MICHAELMICFAILURE.indication(keyid=# broadcast/unicast addr=addr2)
-   */
-
-	/* NOTE: Format of MAC address (using colons to separate bytes) may cause
-			 a problem in future versions of the supplicant, if they ever
-			 actually parse these parameters */
-#if DBG
-	sprintf(msg, "MLME-MICHAELMICFAILURE.indication(keyid=%d %scast "
-			"addr=%pM)", key_idx, addr1[0] & 0x01 ? "broad" : "uni",
-			addr2);
-#endif
-	wrqu.data.length = strlen( msg );
-	wireless_send_event( dev, IWEVCUSTOM, &wrqu, msg );
+	wrqu.data.length = sizeof(wxmic);
+	wireless_send_event(dev, IWEVMICHAELMICFAILURE, &wrqu, (char *)&wxmic);
 
 	return;
 } // wl_wext_event_mic_failed
@@ -3882,7 +3869,6 @@ void wl_wext_event_mic_failed( struct net_device *dev )
  ******************************************************************************/
 void wl_wext_event_assoc_ie( struct net_device *dev )
 {
-	char               msg[512];
 	union iwreq_data   wrqu;
 	struct wl_private *lp = wl_priv(dev);
 	int status;
@@ -3893,7 +3879,6 @@ void wl_wext_event_assoc_ie( struct net_device *dev )
 
 
 	memset( &wrqu, 0, sizeof( wrqu ));
-	memset( msg, 0, sizeof( msg ));
 
 	/* Retrieve the Association Request IE */
 	lp->ltvRecord.len = 45;
@@ -3906,21 +3891,16 @@ void wl_wext_event_assoc_ie( struct net_device *dev )
 		memcpy( &data.rawData, &( lp->ltvRecord.u.u8[1] ), 88 );
 		wpa_ie = wl_parse_wpa_ie( &data, &length );
 
-		/* Because this event (Association WPA-IE) is not part of the Wireless
-		Extensions yet, it must be passed as a string using an IWEVCUSTOM event.
-		In order for the event to be effective, the string format must be known
-		by both the driver and the supplicant. The following is the string format
-		used by the hostap project's WPA supplicant, and will be used here until
-		the Wireless Extensions interface adds this support:
-
-		ASSOCINFO(ReqIEs=WPA-IE RespIEs=WPA-IE)
-		*/
-
 		if( length != 0 )
 		{
-			sprintf( msg, "ASSOCINFO(ReqIEs=%s)", wl_print_wpa_ie( wpa_ie, length ));
-			wrqu.data.length = strlen( msg );
-			wireless_send_event( dev, IWEVCUSTOM, &wrqu, msg );
+			wrqu.data.length = wpa_ie[1] + 2;
+			wireless_send_event(dev, IWEVASSOCREQIE,
+					    &wrqu, wpa_ie);
+
+			/* This bit is a hack. We send the respie
+			 * event at the same time */
+			wireless_send_event(dev, IWEVASSOCRESPIE,
+					    &wrqu, wpa_ie);
 		}
 	}
 
-- 
1.7.4.1

