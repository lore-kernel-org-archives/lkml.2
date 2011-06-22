Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab1FVSkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:40:40 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:39790 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932270Ab1FVSkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:40:37 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Subject: [3/15] staging: ft1000-pcmcia: remove PSEUDO_HDR typedefs
Date: Wed, 22 Jun 2011 20:40:26 +0200
User-Agent: KMail/1.9.10
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106222040.29645.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove PSEUDO_HDR typedefs.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -42,7 +42,7 @@
 #define CALDATESZ               6
 
 // Pseudo Header structure
-typedef struct _PSEUDO_HDR
+struct pseudo_hdr
 {
    unsigned short    length;        // length of msg body
    unsigned char     source;        // hardware source id
@@ -65,7 +65,7 @@ typedef struct _PSEUDO_HDR
    unsigned char     rsvd2;
    unsigned short    qos_class;     // not used
    unsigned short    checksum;      // pseudo header checksum
-} __attribute__ ((packed)) PSEUDO_HDR, *PPSEUDO_HDR;
+} __attribute__ ((packed));
 
 // Definitions to maintain compatibility between other platforms
 #define UCHAR                u8
@@ -286,14 +286,14 @@ typedef struct _PSEUDO_HDR
 #define MAXIMUM_ASIC_HB_CNT      15
 
 typedef struct _DRVMSG {
-	PSEUDO_HDR pseudo;
+	struct pseudo_hdr pseudo;
 	u16 type;
 	u16 length;
 	u8  data[0];
 } __attribute__ ((packed)) DRVMSG, *PDRVMSG;
 
 typedef struct _MEDIAMSG {
-	PSEUDO_HDR pseudo;
+	struct pseudo_hdr pseudo;
 	u16 type;
 	u16 length;
 	u16 state;
@@ -305,14 +305,14 @@ typedef struct _MEDIAMSG {
 } __attribute__ ((packed)) MEDIAMSG, *PMEDIAMSG;
 
 typedef struct _TIMEMSG {
-	PSEUDO_HDR pseudo;
+	struct pseudo_hdr pseudo;
 	u16 type;
 	u16 length;
 	u8  timeval[8];
 } __attribute__ ((packed)) TIMEMSG, *PTIMEMSG;
 
 typedef struct _DSPINITMSG {
-    PSEUDO_HDR pseudo;
+    struct pseudo_hdr pseudo;
     u16 type;
     u16 length;
     u8 DspVer[DSPVERSZ];        // DSP version number
@@ -325,7 +325,7 @@ typedef struct _DSPINITMSG {
 } __attribute__ ((packed)) DSPINITMSG, *PDSPINITMSG;
 
 typedef struct _DSPHIBERNATE {
-	PSEUDO_HDR pseudo;
+	struct pseudo_hdr pseudo;
 	u16 type;
 	u16 length;
 	u32 timeout;
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -91,7 +91,7 @@ void put_handshake(struct net_device *dev, USHORT handshake_value);
 USHORT get_request_type(struct net_device *dev);
 long get_request_value(struct net_device *dev);
 void put_request_value(struct net_device *dev, long lvalue);
-USHORT hdr_checksum(PPSEUDO_HDR pHdr);
+USHORT hdr_checksum(struct pseudo_hdr *pHdr);
 
 typedef struct _DSP_FILE_HDR {
 	u32  build_date;
@@ -297,7 +297,7 @@ void put_request_value(struct net_device *dev, long lvalue)
 
 }
 
-USHORT hdr_checksum(PPSEUDO_HDR pHdr)
+USHORT hdr_checksum(struct pseudo_hdr *pHdr)
 {
 	USHORT *usPtr = (USHORT *) pHdr;
 	USHORT chksum;
@@ -315,7 +315,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 	USHORT DspWordCnt = 0;
 	UINT uiState;
 	USHORT handshake;
-	PPSEUDO_HDR pHdr;
+	struct pseudo_hdr *pHdr;
 	USHORT usHdrLength;
 	PDSP_FILE_HDR pFileHdr;
 	long word_length;
@@ -851,7 +851,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 				break;
 			}
 
-			pHdr = (PPSEUDO_HDR) pUsFile;
+			pHdr = (struct pseudo_hdr *) pUsFile;
 
 			if (pHdr->portdest == 0x80	/* DspOAM */
 				&& (pHdr->portsrc == 0x00	/* Driver */
@@ -871,7 +871,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 
 		case STATE_SECTION_PROV:
 
-			pHdr = (PPSEUDO_HDR) pUcFile;
+			pHdr = (struct pseudo_hdr *) pUcFile;
 
 			if (pHdr->checksum == hdr_checksum(pHdr)) {
 				if (pHdr->portdest != 0x80 /* Dsp OAM */ ) {
@@ -882,12 +882,12 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 
 				// Get buffer for provisioning data
 				pbuffer =
-					kmalloc((usHdrLength + sizeof(PSEUDO_HDR)),
+					kmalloc((usHdrLength + sizeof(struct pseudo_hdr)),
 						GFP_ATOMIC);
 				if (pbuffer) {
 					memcpy(pbuffer, (void *)pUcFile,
 						   (UINT) (usHdrLength +
-							   sizeof(PSEUDO_HDR)));
+							   sizeof(struct pseudo_hdr)));
 					// link provisioning data
 					pprov_record =
 						kmalloc(sizeof(PROV_RECORD),
@@ -901,7 +901,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 						// Move to next entry if available
 						pUcFile =
 							(UCHAR *) ((unsigned long) pUcFile +
-								   (unsigned long) ((usHdrLength + 1) & 0xFFFFFFFE) + sizeof(PSEUDO_HDR));
+								   (unsigned long) ((usHdrLength + 1) & 0xFFFFFFFE) + sizeof(struct pseudo_hdr));
 						if ((unsigned long) (pUcFile) -
 							(unsigned long) (pFileStart) >=
 							(unsigned long) FileLength) {
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -1021,7 +1021,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 	u16 len;
 	u16 i;
 	PPROV_RECORD ptr;
-	PPSEUDO_HDR ppseudo_hdr;
+	struct pseudo_hdr *ppseudo_hdr;
 	PUSHORT pmsg;
 	struct timeval tv;
 	union {
@@ -1066,7 +1066,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 				len = htons(len);
 
 				pmsg = (PUSHORT) ptr->pprov_data;
-				ppseudo_hdr = (PPSEUDO_HDR) pmsg;
+				ppseudo_hdr = (struct pseudo_hdr *) pmsg;
 				// Insert slow queue sequence number
 				ppseudo_hdr->seq_num = info->squeseqnum++;
 				ppseudo_hdr->portsrc = 0;
@@ -1185,7 +1185,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 				// Put message into Slow Queue
 				// Form Pseudo header
 				pmsg = (PUSHORT) info->DSPInfoBlk;
-				ppseudo_hdr = (PPSEUDO_HDR) pmsg;
+				ppseudo_hdr = (struct pseudo_hdr *) pmsg;
 				ppseudo_hdr->length =
 					htons(info->DSPInfoBlklen + 4);
 				ppseudo_hdr->source = 0x10;
@@ -1234,7 +1234,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 				// Put message into Slow Queue
 				// Form Pseudo header
 				pmsg = (PUSHORT) & tempbuffer[0];
-				ppseudo_hdr = (PPSEUDO_HDR) pmsg;
+				ppseudo_hdr = (struct pseudo_hdr *) pmsg;
 				ppseudo_hdr->length = htons(0x0012);
 				ppseudo_hdr->source = 0x10;
 				ppseudo_hdr->destination = 0x20;
@@ -1788,9 +1788,9 @@ int ft1000_copy_down_pkt(struct net_device *dev, u16 * packet, u16 len)
 {
 	FT1000_INFO *info = netdev_priv(dev);
 	union {
-		PSEUDO_HDR blk;
-		u16 buff[sizeof(PSEUDO_HDR) >> 1];
-		u8 buffc[sizeof(PSEUDO_HDR)];
+		struct pseudo_hdr blk;
+		u16 buff[sizeof(struct pseudo_hdr) >> 1];
+		u8 buffc[sizeof(struct pseudo_hdr)];
 	} pseudo;
 	int i;
 	u32 *plong;

-- 
Ondrej Zary
