Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935444Ab1IOXWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:22:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44687 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935433Ab1IOXW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:22:26 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 10/13] staging: wlags49_h2: Remove CKIP support from hcf
Date: Fri, 16 Sep 2011 00:20:54 +0100
Message-Id: <1316128857-9781-11-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
References: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CKIP is a Cisco proprietary alternative to TKIP. Support removed to
simplify code - the defines to interact with the firmware are left in
place.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/hcf.c |  194 ++++++++++++--------------------------
 drivers/staging/wlags49_h2/hcf.h |    3 -
 2 files changed, 60 insertions(+), 137 deletions(-)

diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index 0453b90..5935b42 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -512,8 +512,6 @@ HCF_STATIC hcf_16* BASED xxxx[ ] = {
  *.ARGUMENTS
  *   ifbp                    address of the Interface Block
  *   action                  number identifying the type of change
- *    - HCF_ACT_CCX_OFF      disable CKIP
- *    - HCF_ACT_CCX_ON       enable CKIP
  *    - HCF_ACT_INT_FORCE_ON enable interrupt generation by WaveLAN NIC
  *    - HCF_ACT_INT_OFF      disable interrupt generation by WaveLAN NIC
  *    - HCF_ACT_INT_ON       compensate 1 HCF_ACT_INT_OFF, enable interrupt generation if balance reached
@@ -537,7 +535,6 @@ HCF_STATIC hcf_16* BASED xxxx[ ] = {
  *
  *.DESCRIPTION
  * hcf_action supports the following mode changing action-code pairs that are antonyms
- *    - HCF_ACT_CCX_OFF / HCF_ACT_CCX_ON
  *    - HCF_ACT_INT_[FORCE_]ON / HCF_ACT_INT_OFF
  *
  * Additionally hcf_action can start the following actions in the NIC:
@@ -573,11 +570,6 @@ HCF_STATIC hcf_16* BASED xxxx[ ] = {
  *!  The INT_OFF/INT_ON housekeeping is initialized at 0x0000 by hcf_connect, causing the interrupt generation
  *   mechanism to be disabled at first. This suits MSF implementation based on a polling strategy.
  *
- * o HCF_ACT_CCX_OFF / HCF_ACT_CCX_ON
- *!! This can use some more explanation;?
- * Disables and Enables support in the HCF runtime code for the CCX feature. Each time one of these action
- * codes is used, the effects of the preceding use cease.
- *
  * o HCF_ACT_SLEEP: Initiates the Disconnected DeepSleep process
  * This command is only available if the HCF_DDS compile time option is set. It triggers the F/W to start the
  * sleep handshaking. Regardless whether the Host initiates a Disconnected DeepSleep (DDS) or the F/W initiates
@@ -791,13 +783,6 @@ hcf_action( IFBP ifbp, hcf_16 action )
 //		break;
 #endif // HCF_DDS
 
-#if (HCF_TYPE) & HCF_TYPE_CCX
-	case HCF_ACT_CCX_ON:                      // enable CKIP
-	case HCF_ACT_CCX_OFF:                     // disable CKIP
-		ifbp->IFB_CKIPStat = action;
-		break;
-#endif // HCF_TYPE_CCX
-
 	case HCF_ACT_RX_ACK:                      //Receiver ACK
 	/*6*/   if ( ifbp->IFB_RxFID ) {
 			DAWA_ACK( HREG_EV_RX );
@@ -1501,34 +1486,30 @@ hcf_dma_rx_get (IFBP ifbp)
 	DESC_STRCT *descp;  // pointer to start of FrameList
 
 	descp = get_frame_lst( ifbp, DMA_RX );
-	if ( descp && descp->buf_addr )  //!be aware of the missing curly bracket
+	if ( descp && descp->buf_addr ) {
 
 		                                //skip decapsulation at confined descriptor
 #if (HCF_ENCAP) == HCF_ENC
-#if (HCF_TYPE) & HCF_TYPE_CCX
-		if ( ifbp->IFB_CKIPStat == HCF_ACT_CCX_OFF )
-#endif // HCF_TYPE_CCX
-		{
-			int i;
-			DESC_STRCT *p = descp->next_desc_addr;  //pointer to 2nd descriptor of frame
-			HCFASSERT(p, 0);
-			// The 2nd descriptor contains (maybe) a SNAP header plus part or whole of the payload.
-			//determine decapsulation sub-flag in RxFS
-			i = *(wci_recordp)&descp->buf_addr[HFS_STAT] & ( HFS_STAT_MSG_TYPE | HFS_STAT_ERR );
-			if ( i == HFS_STAT_TUNNEL ||
-			     ( i == HFS_STAT_1042 && hcf_encap( (wci_bufp)&p->buf_addr[HCF_DASA_SIZE] ) != ENC_TUNNEL )) {
-				// The 2nd descriptor contains a SNAP header plus part or whole of the payload.
-				HCFASSERT( p->BUF_CNT == (p->buf_addr[5] + (p->buf_addr[4]<<8) + 2*6 + 2 - 8), p->BUF_CNT );
-				// perform decapsulation
-				HCFASSERT(p->BUF_SIZE >=8, p->BUF_SIZE);
-				// move SA[2:5] in the second buffer to replace part of the SNAP header
-				for ( i=3; i >= 0; i--) p->buf_addr[i+8] = p->buf_addr[i];
-				// copy DA[0:5], SA[0:1] from first buffer to second buffer
-				for ( i=0; i<8; i++) p->buf_addr[i] = descp->buf_addr[HFS_ADDR_DEST + i];
-				// make first buffer shorter in count
-				descp->BUF_CNT = HFS_ADDR_DEST;
-			}
+		int i;
+		DESC_STRCT *p = descp->next_desc_addr;  //pointer to 2nd descriptor of frame
+		HCFASSERT(p, 0);
+		// The 2nd descriptor contains (maybe) a SNAP header plus part or whole of the payload.
+		//determine decapsulation sub-flag in RxFS
+		i = *(wci_recordp)&descp->buf_addr[HFS_STAT] & ( HFS_STAT_MSG_TYPE | HFS_STAT_ERR );
+		if ( i == HFS_STAT_TUNNEL ||
+		     ( i == HFS_STAT_1042 && hcf_encap( (wci_bufp)&p->buf_addr[HCF_DASA_SIZE] ) != ENC_TUNNEL )) {
+			// The 2nd descriptor contains a SNAP header plus part or whole of the payload.
+			HCFASSERT( p->BUF_CNT == (p->buf_addr[5] + (p->buf_addr[4]<<8) + 2*6 + 2 - 8), p->BUF_CNT );
+			// perform decapsulation
+			HCFASSERT(p->BUF_SIZE >=8, p->BUF_SIZE);
+			// move SA[2:5] in the second buffer to replace part of the SNAP header
+			for ( i=3; i >= 0; i--) p->buf_addr[i+8] = p->buf_addr[i];
+			// copy DA[0:5], SA[0:1] from first buffer to second buffer
+			for ( i=0; i<8; i++) p->buf_addr[i] = descp->buf_addr[HFS_ADDR_DEST + i];
+			// make first buffer shorter in count
+			descp->BUF_CNT = HFS_ADDR_DEST;
 		}
+	}
 #endif // HCF_ENC
 	if ( descp == NULL ) ifbp->IFB_DmaPackets &= (hcf_16)~HREG_EV_RDMAD;  //;?could be integrated into get_frame_lst
 	HCFLOGEXIT( HCF_TRACE_DMA_RX_GET );
@@ -1634,18 +1615,16 @@ hcf_dma_tx_get( IFBP ifbp )
 	DESC_STRCT *descp;  // pointer to start of FrameList
 
 	descp = get_frame_lst( ifbp, DMA_TX );
-	if ( descp && descp->buf_addr )  //!be aware of the missing curly bracket
+	if ( descp && descp->buf_addr ) {
 		                                //skip decapsulation at confined descriptor
 #if (HCF_ENCAP) == HCF_ENC
-		if ( ( descp->BUF_CNT == HFS_TYPE )
-#if (HCF_TYPE) & HCF_TYPE_CCX
-		     || ( descp->BUF_CNT == HFS_DAT )
-#endif // HCF_TYPE_CCX
-			) { // perform decapsulation if needed
+		if ( ( descp->BUF_CNT == HFS_TYPE )) {
+			// perform decapsulation if needed
 			descp->next_desc_addr->buf_phys_addr -= HCF_DASA_SIZE;
 			descp->next_desc_addr->BUF_CNT       += HCF_DASA_SIZE;
 		}
 #endif // HCF_ENC
+	}
 	if ( descp == NULL ) {  //;?could be integrated into get_frame_lst
 		ifbp->IFB_DmaPackets &= (hcf_16)~HREG_EV_TDMAD;
 	}
@@ -1792,49 +1771,20 @@ hcf_dma_tx_put( IFBP ifbp, DESC_STRCT *descp, hcf_16 tx_cntl )
 		HCFASSERT( descp->BUF_SIZE >= HCF_DMA_TX_BUF1_SIZE, descp->BUF_SIZE );   //minimal storage for encapsulation
 		HCFASSERT( p->BUF_CNT >= 14, p->BUF_CNT );                  //at least DA, SA and 'type' in 2nd buffer
 
-#if (HCF_TYPE) & HCF_TYPE_CCX
-		/* if we are doing PPK +/- CMIC, or we are sending a DDP frame */
-		if ( ( ifbp->IFB_CKIPStat == HCF_ACT_CCX_ON ) ||
-		     ( ( p->BUF_CNT >= 20 )      && ( ifbp->IFB_CKIPStat == HCF_ACT_CCX_OFF ) &&
-		       ( p->buf_addr[12] == 0xAA ) && ( p->buf_addr[13] == 0xAA ) &&
-		       ( p->buf_addr[14] == 0x03 ) && ( p->buf_addr[15] == 0x00 ) &&
-		       ( p->buf_addr[16] == 0x40 ) && ( p->buf_addr[17] == 0x96 ) &&
-		       ( p->buf_addr[18] == 0x00 ) && ( p->buf_addr[19] == 0x00 )))
-		{
-			/* copy the DA/SA to the first buffer */
-			for ( i = 0; i < HCF_DASA_SIZE; i++ ) {
-				descp->buf_addr[i + HFS_ADDR_DEST] = p->buf_addr[i];
+		descp->buf_addr[HFS_TYPE-1] = hcf_encap(&descp->next_desc_addr->buf_addr[HCF_DASA_SIZE]);       /*4*/
+		if ( descp->buf_addr[HFS_TYPE-1] != ENC_NONE ) {
+			for ( i=0; i < HCF_DASA_SIZE; i++ ) {                                                       /*6*/
+				descp->buf_addr[i + HFS_ADDR_DEST] = descp->next_desc_addr->buf_addr[i];
 			}
-			/* calculate the length of the second fragment only */
-			i = 0;
-			do { i += p->BUF_CNT; } while( p = p->next_desc_addr );
-			i -= HCF_DASA_SIZE ;
-			/* convert the length field to big endian, using the endian friendly macros */
-			i = CNV_SHORT_TO_BIG(i);        //!! this converts ONLY on LE platforms, how does that relate to the non-CCX code
-			*(hcf_16*)(&descp->buf_addr[HFS_LEN]) = (hcf_16)i;
-			descp->BUF_CNT = HFS_DAT;
-			// modify 2nd descriptor to skip the 'Da/Sa' fields
-			descp->next_desc_addr->buf_phys_addr += HCF_DASA_SIZE;
-			descp->next_desc_addr->BUF_CNT       -= HCF_DASA_SIZE;
-		}
-		else
-#endif // HCF_TYPE_CCX
-		{
-			descp->buf_addr[HFS_TYPE-1] = hcf_encap(&descp->next_desc_addr->buf_addr[HCF_DASA_SIZE]);       /*4*/
-			if ( descp->buf_addr[HFS_TYPE-1] != ENC_NONE ) {
-				for ( i=0; i < HCF_DASA_SIZE; i++ ) {                                                       /*6*/
-					descp->buf_addr[i + HFS_ADDR_DEST] = descp->next_desc_addr->buf_addr[i];
-				}
-				i = sizeof(snap_header) + 2 - ( 2*6 + 2 );
-				do { i += p->BUF_CNT; } while ( ( p = p->next_desc_addr ) != NULL );
-				*(hcf_16*)(&descp->buf_addr[HFS_LEN]) = CNV_END_SHORT(i);   //!! this converts on ALL platforms, how does that relate to the CCX code
-				for ( i=0; i < sizeof(snap_header) - 1; i++) {
-					descp->buf_addr[HFS_TYPE - sizeof(snap_header) + i] = snap_header[i];
-				}
-				descp->BUF_CNT = HFS_TYPE;                                                                  /*8*/
-				descp->next_desc_addr->buf_phys_addr    += HCF_DASA_SIZE;
-				descp->next_desc_addr->BUF_CNT          -= HCF_DASA_SIZE;
+			i = sizeof(snap_header) + 2 - ( 2*6 + 2 );
+			do { i += p->BUF_CNT; } while ( ( p = p->next_desc_addr ) != NULL );
+			*(hcf_16*)(&descp->buf_addr[HFS_LEN]) = CNV_END_SHORT(i);   //!! this converts on ALL platforms, how does that relate to the CCX code
+			for ( i=0; i < sizeof(snap_header) - 1; i++) {
+				descp->buf_addr[HFS_TYPE - sizeof(snap_header) + i] = snap_header[i];
 			}
+			descp->BUF_CNT = HFS_TYPE;                                                                  /*8*/
+			descp->next_desc_addr->buf_phys_addr    += HCF_DASA_SIZE;
+			descp->next_desc_addr->BUF_CNT          -= HCF_DASA_SIZE;
 		}
 #endif // HCF_ENC
 	}
@@ -2708,54 +2658,36 @@ hcf_send_msg( IFBP ifbp, DESC_STRCT *descp, hcf_16 tx_cntl )
 #endif // HCF_TYPE_TX_DELAY
 		OPW( HREG_DATA_1, tx_cntl ) ;
 		OPW( HREG_DATA_1, 0 );
-#if ! ( (HCF_TYPE) & HCF_TYPE_CCX )
+
 		HCFASSERT( p->BUF_CNT >= 14, p->BUF_CNT );
 		                                /* assume DestAddr/SrcAddr/Len/Type ALWAYS contained in 1st fragment
 		                                 * otherwise life gets too cumbersome for MIC and Encapsulation !!!!!!!!
 		 if ( p->BUF_CNT >= 14 ) {   alternatively: add a safety escape !!!!!!!!!!!! }   */
-#endif // HCF_TYPE_CCX
+
 		CALC_TX_MIC( NULL, -1 );        //initialize MIC
 	/*10*/  put_frag( ifbp, p->buf_addr, HCF_DASA_SIZE BE_PAR(0) ); //write DA, SA with MIC calculation
 		CALC_TX_MIC( p->buf_addr, HCF_DASA_SIZE );      //MIC over DA, SA
 		CALC_TX_MIC( null_addr, 4 );        //MIC over (virtual) priority field
-#if (HCF_TYPE) & HCF_TYPE_CCX
-		//!!be careful do not use positive test on HCF_ACT_CCX_OFF, because IFB_CKIPStat is initially 0
-		if(( ifbp->IFB_CKIPStat == HCF_ACT_CCX_ON ) ||
-		   ((GET_BUF_CNT(p) >= 20 )   && ( ifbp->IFB_CKIPStat == HCF_ACT_CCX_OFF ) &&
-		    (p->buf_addr[12] == 0xAA) && (p->buf_addr[13] == 0xAA) &&
-		    (p->buf_addr[14] == 0x03) && (p->buf_addr[15] == 0x00) &&
-		    (p->buf_addr[16] == 0x40) && (p->buf_addr[17] == 0x96) &&
-		    (p->buf_addr[18] == 0x00) && (p->buf_addr[19] == 0x00)))
-		{
-			i = HCF_DASA_SIZE;
-
-			OPW( HREG_DATA_1, CNV_SHORT_TO_BIG( len - i ));
 
-			/* need to send out the remainder of the fragment */
-			put_frag( ifbp, &p->buf_addr[i], GET_BUF_CNT(p) - i BE_PAR(0) );
-		}
-		else
-#endif // HCF_TYPE_CCX
-		{
 			                        //if encapsulation needed
 #if (HCF_ENCAP) == HCF_ENC
 			                        //write length (with SNAP-header,Type, without //DA,SA,Length ) no MIC calc.
-			if ( ( snap_header[sizeof(snap_header)-1] = hcf_encap( &p->buf_addr[HCF_DASA_SIZE] ) ) != ENC_NONE ) {
-				OPW( HREG_DATA_1, CNV_END_SHORT( len + (sizeof(snap_header) + 2) - ( 2*6 + 2 ) ) );
+		if ( ( snap_header[sizeof(snap_header)-1] = hcf_encap( &p->buf_addr[HCF_DASA_SIZE] ) ) != ENC_NONE ) {
+			OPW( HREG_DATA_1, CNV_END_SHORT( len + (sizeof(snap_header) + 2) - ( 2*6 + 2 ) ) );
 				                //write splice with MIC calculation
-				put_frag( ifbp, snap_header, sizeof(snap_header) BE_PAR(0) );
-				CALC_TX_MIC( snap_header, sizeof(snap_header) );    //MIC over 6 byte SNAP
-				i = HCF_DASA_SIZE;
-			} else
+			put_frag( ifbp, snap_header, sizeof(snap_header) BE_PAR(0) );
+			CALC_TX_MIC( snap_header, sizeof(snap_header) );    //MIC over 6 byte SNAP
+			i = HCF_DASA_SIZE;
+		} else
 #endif // HCF_ENC
-			{
-				OPW( HREG_DATA_1, *(wci_recordp)&p->buf_addr[HCF_DASA_SIZE] );
-				i = 14;
-			}
-			                        //complete 1st fragment starting with Type with MIC calculation
-			put_frag( ifbp, &p->buf_addr[i], p->BUF_CNT - i BE_PAR(0) );
-			CALC_TX_MIC( &p->buf_addr[i], p->BUF_CNT - i );
+		{
+			OPW( HREG_DATA_1, *(wci_recordp)&p->buf_addr[HCF_DASA_SIZE] );
+			i = 14;
 		}
+			                        //complete 1st fragment starting with Type with MIC calculation
+		put_frag( ifbp, &p->buf_addr[i], p->BUF_CNT - i BE_PAR(0) );
+		CALC_TX_MIC( &p->buf_addr[i], p->BUF_CNT - i );
+
 		                                //do the remaining fragments with MIC calculation
 		while ( ( p = p->next_desc_addr ) != NULL ) {
 			/* obnoxious c:/hcf/hcf.c(1480) : warning C4769: conversion of near pointer to long integer,
@@ -3116,25 +3048,19 @@ hcf_service_nic( IFBP ifbp, wci_bufp bufp, unsigned int len )
 					CALC_RX_MIC( null_addr, 4 );    //.  MIC over (virtual) priority field
 					CALC_RX_MIC( buf_addr+14, 8 );  //.  skip Len, MIC over SNAP,Type or 8 data bytes)
 					buf_addr += 22;
-#if (HCF_TYPE) & HCF_TYPE_CCX
-//!!be careful do not use positive test on HCF_ACT_CCX_OFF, because IFB_CKIPStat is initially 0
-					if( ifbp->IFB_CKIPStat != HCF_ACT_CCX_ON  )
-#endif // HCF_TYPE_CCX
-					{
 #if (HCF_ENCAP) == HCF_ENC
-						HCFASSERT( len >= HFS_DAT + 2 + sizeof(snap_header), len );
-					/*34*/  i = *(wci_recordp)&bufp[HFS_STAT] & ( HFS_STAT_MSG_TYPE | HFS_STAT_ERR );
-						if ( i == HFS_STAT_TUNNEL ||
-						     ( i == HFS_STAT_1042 && hcf_encap( (wci_bufp)&bufp[HFS_TYPE] ) != ENC_TUNNEL ) ) {
+					HCFASSERT( len >= HFS_DAT + 2 + sizeof(snap_header), len );
+				/*34*/  i = *(wci_recordp)&bufp[HFS_STAT] & ( HFS_STAT_MSG_TYPE | HFS_STAT_ERR );
+					if ( i == HFS_STAT_TUNNEL ||
+					     ( i == HFS_STAT_1042 && hcf_encap( (wci_bufp)&bufp[HFS_TYPE] ) != ENC_TUNNEL ) ) {
 							                //.  copy E-II Type to 802.3 LEN field
-						/*36*/  bufp[HFS_LEN  ] = bufp[HFS_TYPE  ];
-							bufp[HFS_LEN+1] = bufp[HFS_TYPE+1];
+				/*36*/  bufp[HFS_LEN  ] = bufp[HFS_TYPE  ];
+						bufp[HFS_LEN+1] = bufp[HFS_TYPE+1];
 							                //.  discard Snap by overwriting with data
-							ifbp->IFB_RxLen -= (HFS_TYPE - HFS_LEN);
-							buf_addr -= ( HFS_TYPE - HFS_LEN ); // this happens to bring us at a DW boundary of 36
-						}
-#endif // HCF_ENC
+						ifbp->IFB_RxLen -= (HFS_TYPE - HFS_LEN);
+						buf_addr -= ( HFS_TYPE - HFS_LEN ); // this happens to bring us at a DW boundary of 36
 					}
+#endif // HCF_ENC
 				}
 			/*40*/  ifbp->IFB_lal = min( (hcf_16)(len - HFS_ADDR_DEST), ifbp->IFB_RxLen );
 				i = ifbp->IFB_lal - ( buf_addr - ( bufp + HFS_ADDR_DEST ) );
diff --git a/drivers/staging/wlags49_h2/hcf.h b/drivers/staging/wlags49_h2/hcf.h
index fc8c355..cf55e8e 100644
--- a/drivers/staging/wlags49_h2/hcf.h
+++ b/drivers/staging/wlags49_h2/hcf.h
@@ -336,9 +336,6 @@ typedef struct  {
 #endif // HCF_ASSERT_PRINTF
 #endif // HCF_ASSERT
   hcf_16 volatile IFB_IntOffCnt;		// 0xFFFF based HCF_ACT_INT_OFF nesting counter, DeepSleep flag
-#if (HCF_TYPE) & HCF_TYPE_CCX
-  hcf_16         IFB_CKIPStat;			// CKIP Status flag
-#endif // HCF_TYPE_CCX
 #if (HCF_TALLIES) & ( HCF_TALLIES_NIC | HCF_TALLIES_HCF )	//Hermes and/or HCF tally support
   hcf_32		IFB_Silly_you_should_align;	//;?
   hcf_16		IFB_TallyLen;			// Tally length (to build an LTV)
-- 
1.7.4.1

