Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab0CYFRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:17:42 -0400
Received: from mail.perches.com ([173.55.12.10]:1110 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab0CYFRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:17:37 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 13/13] drivers/staging/wlags49_h2: Hoist assign from if
Date: Wed, 24 Mar 2010 22:17:07 -0700
Message-Id: <e6013a61135c5b675ebf0c03131c999b77da3091.1269493047.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269493047.git.joe@perches.com>
References: <cover.1269493047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/wlags49_h2/hcf.c       |   15 ++++++++++-----
 drivers/staging/wlags49_h2/wl_main.c   |    3 ++-
 drivers/staging/wlags49_h2/wl_netdev.c |   12 ++++++++----
 drivers/staging/wlags49_h2/wl_priv.c   |    9 ++++++---
 drivers/staging/wlags49_h2/wl_sysfs.c  |    3 ++-
 5 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index 6e39f50..390628c 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -990,7 +990,8 @@ int	rc = HCF_ERR_INCOMP_FW;
 			ifbp->IFB_CntlOpt |= DMA_ENABLED;
 			HCFASSERT( NT_ASSERT, NEVER_TESTED )
 			// make the entire rx descriptor chain DMA-owned, so the DMA engine can (re-)use it.
-			if ( ( p = ifbp->IFB_FirstDesc[DMA_RX] ) != NULL ) {   //;? Think this over again in the light of the new chaining strategy
+			p = ifbp->IFB_FirstDesc[DMA_RX];
+			if (p != NULL) {   //;? Think this over again in the light of the new chaining strategy
 				if ( 1 ) 	{ //begin alternative
 					HCFASSERT( NT_ASSERT, NEVER_TESTED )
 					put_frame_lst( ifbp, ifbp->IFB_FirstDesc[DMA_RX], DMA_RX );
@@ -2087,7 +2088,8 @@ wci_bufp	pt;					//pointer with the "right" type, just to help ease writing macr
 			OPW( HREG_AUX_OFFSET, (hcf_16)(PLUG_DATA_OFFSET & 0x7E) );
 			io_port = ifbp->IFB_IOBase + HREG_AUX_DATA;		//to prevent side effects of the MSF-defined macro
 			p = ltvp->val;					//destination char pointer (in LTV record)
-			if ( ( i = len - 1 ) > 0 ) {
+			i = len - 1;
+			if (i > 0 ) {
 				pt = (wci_bufp)p;	//just to help ease writing macros with embedded assembly
 				IN_PORT_STRING_8_16( io_port, pt, i ); //space used by T: -1
 			}
@@ -2674,7 +2676,8 @@ hcf_16		fid = 0;
 
 #if (HCF_EXT) & HCF_EXT_TX_CONT				// Continuous transmit test
 	if ( tx_cntl == HFS_TX_CNTL_TX_CONT ) {
-	 	if ( ( fid = get_fid( ifbp ) ) != 0 ) {
+	 	fid = get_fid(ifbp);
+	 	if (fid != 0 ) {
 											//setup BAP to begin of TxFS
 			(void)setup_bap( ifbp, fid, 0, IO_OUT );
 											//copy all the fragments in a transparent fashion
@@ -2700,7 +2703,8 @@ hcf_16		fid = 0;
 #if (HCF_TYPE) & HCF_TYPE_WPA
 	tx_cntl |= ifbp->IFB_MICTxCntl;
 #endif // HCF_TYPE_WPA
-	if ( (fid = ifbp->IFB_TxFID) == 0 && ( fid = get_fid( ifbp ) ) != 0 ) 		/* 4 */
+	fid = ifbp->IFB_TxFID;
+	if (fid == 0 && ( fid = get_fid( ifbp ) ) != 0 ) 		/* 4 */
 			/* skip the next compound statement if:
 			   - pre-put message or
 			   - no fid available (which should never occur if the MSF adheres to the WCI)
@@ -4860,7 +4864,8 @@ PROT_CNT_INI
 int	rc;
 
 	HCFTRACE( ifbp, HCF_TRACE_STRIO );
-	if ( ( rc = ifbp->IFB_DefunctStat ) == HCF_SUCCESS ) {										/*2*/
+	rc = ifbp->IFB_DefunctStat;
+	if (rc == HCF_SUCCESS) {										/*2*/
 		OPW( HREG_SELECT_1, fid );																/*4*/
 		OPW( HREG_OFFSET_1, offset );
 		if ( type == IO_IN ) {
diff --git a/drivers/staging/wlags49_h2/wl_main.c b/drivers/staging/wlags49_h2/wl_main.c
index cf0c384..88d0d47 100644
--- a/drivers/staging/wlags49_h2/wl_main.c
+++ b/drivers/staging/wlags49_h2/wl_main.c
@@ -3591,7 +3591,8 @@ int scull_read_procmem(char *buf, char **start, off_t offset, int len, int *eof,
 
     len=0;
 
-	if ( ( lp = ((struct net_device *)data)->priv ) == NULL ) {
+	lp = ((struct net_device *)data)->priv;
+	if (lp == NULL) {
         len += sprintf(buf+len,"No wl_private in scull_read_procmem\n" );
 	} else if ( lp->wlags49_type == 0 ){
    	    ifbp = &lp->hcfCtx;
diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
index fa082d9..0999c71 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -929,8 +929,10 @@ int wl_rx(struct net_device *dev)
         port = ( hfs_stat >> 8 ) & 0x0007;
         DBG_RX( DbgInfo, "Rx frame for port %d\n", port );
 
-        if(( pktlen = lp->hcfCtx.IFB_RxLen ) != 0 ) {
-            if(( skb = ALLOC_SKB( pktlen )) != NULL ) {
+        pktlen = lp->hcfCtx.IFB_RxLen;
+        if (pktlen != 0) {
+            skb = ALLOC_SKB(pktlen);
+            if (skb != NULL) {
                 /* Set the netdev based on the port */
                 switch( port ) {
 #ifdef USE_WDS
@@ -1994,8 +1996,10 @@ int wl_rx_dma( struct net_device *dev )
                 port = ( hfs_stat >> 8 ) & 0x0007;
                 DBG_RX( DbgInfo, "Rx frame for port %d\n", port );
 
-                if(( pktlen = GET_BUF_CNT( desc_next )) != 0 ) {
-                    if(( skb = ALLOC_SKB( pktlen )) != NULL ) {
+                pktlen = GET_BUF_CNT(desc_next);
+                if (pktlen != 0) {
+                    skb = ALLOC_SKB(pktlen);
+                    if (skb != NULL) {
                         switch( port ) {
 #ifdef USE_WDS
                         case 1:
diff --git a/drivers/staging/wlags49_h2/wl_priv.c b/drivers/staging/wlags49_h2/wl_priv.c
index ee610c7..3cfa18a 100644
--- a/drivers/staging/wlags49_h2/wl_priv.c
+++ b/drivers/staging/wlags49_h2/wl_priv.c
@@ -502,7 +502,8 @@ int wvlan_uil_send_diag_msg( struct uilreq *urq, struct wl_private *lp )
 						return result;
 					}
 
-					if ((data = kmalloc(urq->len, GFP_KERNEL)) != NULL) {
+					data = kmalloc(urq->len, GFP_KERNEL);
+					if (data != NULL) {
 						memset( Descp, 0, sizeof( DESC_STRCT ));
 						memcpy( data, urq->data, urq->len );
 
@@ -616,7 +617,8 @@ int wvlan_uil_put_info( struct uilreq *urq, struct wl_private *lp )
 				   LTV record, try to allocate it from the kernel stack.
 				   Otherwise, we just use our local LTV record. */
 				if( urq->len > sizeof( lp->ltvRecord )) {
-					if(( pLtv = (ltv_t *)kmalloc( urq->len, GFP_KERNEL )) != NULL ) {
+					pLtv = (ltv_t *)kmalloc( urq->len, GFP_KERNEL );
+					if (pLtv != NULL) {
 						ltvAllocated = TRUE;
 					} else {
 						DBG_ERROR( DbgInfo, "Alloc FAILED\n" );
@@ -1295,7 +1297,8 @@ int wvlan_uil_get_info( struct uilreq *urq, struct wl_private *lp )
 				   LTV record, try to allocate it from the kernel stack.
 				   Otherwise, we just use our local LTV record. */
 				if( urq->len > sizeof( lp->ltvRecord )) {
-					if(( pLtv = (ltv_t *)kmalloc( urq->len, GFP_KERNEL )) != NULL ) {
+					pLtv = (ltv_t *)kmalloc( urq->len, GFP_KERNEL );
+					if (pLtv != NULL) {
 						ltvAllocated = TRUE;
 
 						/* Copy the command/length information into the new buffer. */
diff --git a/drivers/staging/wlags49_h2/wl_sysfs.c b/drivers/staging/wlags49_h2/wl_sysfs.c
index 864e01a..e4c8804 100644
--- a/drivers/staging/wlags49_h2/wl_sysfs.c
+++ b/drivers/staging/wlags49_h2/wl_sysfs.c
@@ -46,7 +46,8 @@ static ssize_t show_tallies(struct device *d, struct device_attribute *attr,
     if (dev_isalive(dev)) {
 	wl_lock(lp, &flags);
 
-	if ((ret = wl_get_tallies(lp, &tallies)) == 0) {
+	ret = wl_get_tallies(lp, &tallies);
+	if (ret == 0) {
 		wl_unlock(lp, &flags);
 		ret = snprintf(buf, PAGE_SIZE,
 		    "TxUnicastFrames:           %u\n"
-- 
1.7.0.14.g7e948

