Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1F3WFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:05:22 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:52889 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753393Ab1F3WET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:04:19 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/28] staging: ft1000-pcmcia: remove custom defines for standard types
Date: Fri,  1 Jul 2011 00:03:47 +0200
Message-Id: <1309471437-12633-19-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
References: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove custom defines for standard types (u8, u16, u32...)

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h      |   13 --
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |  132 ++++++++++----------
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |   52 ++++----
 3 files changed, 92 insertions(+), 105 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
index 227fcbb..f4c8735 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -67,17 +67,6 @@ struct pseudo_hdr
    unsigned short    checksum;      // pseudo header checksum
 } __attribute__ ((packed));
 
-// Definitions to maintain compatibility between other platforms
-#define UCHAR                u8
-#define USHORT               u16
-#define ULONG                u32
-#define BOOLEAN              u8
-#define PULONG               u32 *
-#define PUSHORT              u16 *
-#define PUCHAR               u8 *
-#define PCHAR                u8 *
-#define UINT                 u32
-
 #define ELECTRABUZZ_ID       0          // ASIC ID for Electrabuzz
 #define MAGNEMITE_ID         0x1a01     // ASIC ID for Magnemite
 
@@ -278,8 +267,6 @@ struct pseudo_hdr
 
 #define  SUCCESS                0x00
 #define  FAILURE                0x01
-#define  TRUE                   0x1
-#define  FALSE                  0x0
 
 #define MAXIMUM_ASIC_HB_CNT      15
 
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
index 26437a6..c8b73c6 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -86,12 +86,12 @@
 #define  STATE_DONE_PROV         0x06
 #define  STATE_DONE_FILE         0x07
 
-USHORT get_handshake(struct net_device *dev, USHORT expected_value);
-void put_handshake(struct net_device *dev, USHORT handshake_value);
-USHORT get_request_type(struct net_device *dev);
+u16 get_handshake(struct net_device *dev, u16 expected_value);
+void put_handshake(struct net_device *dev, u16 handshake_value);
+u16 get_request_type(struct net_device *dev);
 long get_request_value(struct net_device *dev);
 void put_request_value(struct net_device *dev, long lvalue);
-USHORT hdr_checksum(struct pseudo_hdr *pHdr);
+u16 hdr_checksum(struct pseudo_hdr *pHdr);
 
 struct dsp_file_hdr {
 	u32  build_date;
@@ -143,14 +143,14 @@ void card_bootload(struct net_device *dev)
 {
 	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
 	unsigned long flags;
-	PULONG pdata;
-	UINT size;
-	UINT i;
-	ULONG templong;
+	u32 *pdata;
+	u32 size;
+	u32 i;
+	u32 templong;
 
 	DEBUG(0, "card_bootload is called\n");
 
-	pdata = (PULONG) bootimage;
+	pdata = (u32 *) bootimage;
 	size = sizeof(bootimage);
 
 	// check for odd word
@@ -171,11 +171,11 @@ void card_bootload(struct net_device *dev)
 	spin_unlock_irqrestore(&info->dpram_lock, flags);
 }
 
-USHORT get_handshake(struct net_device *dev, USHORT expected_value)
+u16 get_handshake(struct net_device *dev, u16 expected_value)
 {
 	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
-	USHORT handshake;
-	ULONG tempx;
+	u16 handshake;
+	u32 tempx;
 	int loopcnt;
 
 	loopcnt = 0;
@@ -189,7 +189,7 @@ USHORT get_handshake(struct net_device *dev, USHORT expected_value)
 			tempx =
 				ntohl(ft1000_read_dpram_mag_32
 				  (dev, DWNLD_MAG_HANDSHAKE_LOC));
-			handshake = (USHORT) tempx;
+			handshake = (u16) tempx;
 		}
 
 		if ((handshake == expected_value)
@@ -206,27 +206,27 @@ USHORT get_handshake(struct net_device *dev, USHORT expected_value)
 
 }
 
-void put_handshake(struct net_device *dev, USHORT handshake_value)
+void put_handshake(struct net_device *dev, u16 handshake_value)
 {
 	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
-	ULONG tempx;
+	u32 tempx;
 
 	if (info->AsicID == ELECTRABUZZ_ID) {
 		ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR,
 				 DWNLD_HANDSHAKE_LOC);
 		ft1000_write_reg(dev, FT1000_REG_DPRAM_DATA, handshake_value);	/* Handshake */
 	} else {
-		tempx = (ULONG) handshake_value;
+		tempx = (u32) handshake_value;
 		tempx = ntohl(tempx);
 		ft1000_write_dpram_mag_32(dev, DWNLD_MAG_HANDSHAKE_LOC, tempx);	/* Handshake */
 	}
 }
 
-USHORT get_request_type(struct net_device *dev)
+u16 get_request_type(struct net_device *dev)
 {
 	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
-	USHORT request_type;
-	ULONG tempx;
+	u16 request_type;
+	u32 tempx;
 
 	if (info->AsicID == ELECTRABUZZ_ID) {
 		ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR, DWNLD_TYPE_LOC);
@@ -234,7 +234,7 @@ USHORT get_request_type(struct net_device *dev)
 	} else {
 		tempx = ft1000_read_dpram_mag_32(dev, DWNLD_MAG_TYPE_LOC);
 		tempx = ntohl(tempx);
-		request_type = (USHORT) tempx;
+		request_type = (u16) tempx;
 	}
 
 	return request_type;
@@ -245,7 +245,7 @@ long get_request_value(struct net_device *dev)
 {
 	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
 	long value;
-	USHORT w_val;
+	u16 w_val;
 
 	if (info->AsicID == ELECTRABUZZ_ID) {
 		ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR,
@@ -273,18 +273,18 @@ long get_request_value(struct net_device *dev)
 void put_request_value(struct net_device *dev, long lvalue)
 {
 	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
-	USHORT size;
-	ULONG tempx;
+	u16 size;
+	u32 tempx;
 
 	if (info->AsicID == ELECTRABUZZ_ID) {
-		size = (USHORT) (lvalue >> 16);
+		size = (u16) (lvalue >> 16);
 
 		ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR,
 				 DWNLD_SIZE_MSW_LOC);
 
 		ft1000_write_reg(dev, FT1000_REG_DPRAM_DATA, size);
 
-		size = (USHORT) (lvalue);
+		size = (u16) (lvalue);
 
 		ft1000_write_reg(dev, FT1000_REG_DPRAM_ADDR,
 				 DWNLD_SIZE_LSW_LOC);
@@ -297,10 +297,10 @@ void put_request_value(struct net_device *dev, long lvalue)
 
 }
 
-USHORT hdr_checksum(struct pseudo_hdr *pHdr)
+u16 hdr_checksum(struct pseudo_hdr *pHdr)
 {
-	USHORT *usPtr = (USHORT *) pHdr;
-	USHORT chksum;
+	u16 *usPtr = (u16 *) pHdr;
+	u16 chksum;
 
 	chksum = ((((((usPtr[0] ^ usPtr[1]) ^ usPtr[2]) ^ usPtr[3]) ^
 			usPtr[4]) ^ usPtr[5]) ^ usPtr[6]);
@@ -308,32 +308,32 @@ USHORT hdr_checksum(struct pseudo_hdr *pHdr)
 	return chksum;
 }
 
-int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
+int card_download(struct net_device *dev, const u8 *pFileStart, u32 FileLength)
 {
 	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
 	int Status = SUCCESS;
-	USHORT DspWordCnt = 0;
-	UINT uiState;
-	USHORT handshake;
+	u16 DspWordCnt = 0;
+	u32 uiState;
+	u16 handshake;
 	struct pseudo_hdr *pHdr;
-	USHORT usHdrLength;
+	u16 usHdrLength;
 	struct dsp_file_hdr *pFileHdr;
 	long word_length;
-	USHORT request;
-	USHORT temp;
+	u16 request;
+	u16 temp;
 	struct prov_record *pprov_record;
-	PUCHAR pbuffer;
+	u8 *pbuffer;
 	struct dsp_file_hdr_5 *pFileHdr5;
 	struct dsp_image_info *pDspImageInfo = NULL;
 	struct dsp_image_info_v6 *pDspImageInfoV6 = NULL;
 	long requested_version;
-	BOOLEAN bGoodVersion = 0;
+	bool bGoodVersion = 0;
 	struct drv_msg *pMailBoxData;
-	USHORT *pUsData = NULL;
-	USHORT *pUsFile = NULL;
-	UCHAR *pUcFile = NULL;
-	UCHAR *pBootEnd = NULL;
-	UCHAR *pCodeEnd = NULL;
+	u16 *pUsData = NULL;
+	u16 *pUsFile = NULL;
+	u8 *pUcFile = NULL;
+	u8 *pBootEnd = NULL;
+	u8 *pCodeEnd = NULL;
 	int imageN;
 	long file_version;
 	long loader_code_address = 0;
@@ -358,16 +358,16 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 	case 5:
 	case 6:
 		pUsFile =
-			(USHORT *) ((long)pFileStart + pFileHdr5->loader_offset);
+			(u16 *) ((long)pFileStart + pFileHdr5->loader_offset);
 		pUcFile =
-			(UCHAR *) ((long)pFileStart + pFileHdr5->loader_offset);
+			(u8 *) ((long)pFileStart + pFileHdr5->loader_offset);
 
 		pBootEnd =
-			(UCHAR *) ((long)pFileStart + pFileHdr5->loader_code_end);
+			(u8 *) ((long)pFileStart + pFileHdr5->loader_code_end);
 
 		loader_code_address = pFileHdr5->loader_code_address;
 		loader_code_size = pFileHdr5->loader_code_size;
-		bGoodVersion = FALSE;
+		bGoodVersion = false;
 		break;
 
 	default:
@@ -410,8 +410,8 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 					break;
 				case REQUEST_DONE_BL:
 					/* Reposition ptrs to beginning of code section */
-					pUsFile = (USHORT *) ((long)pBootEnd);
-					pUcFile = (UCHAR *) ((long)pBootEnd);
+					pUsFile = (u16 *) ((long)pBootEnd);
+					pUcFile = (u8 *) ((long)pBootEnd);
 					uiState = STATE_CODE_DWNLD;
 					break;
 				case REQUEST_CODE_SEGMENT:
@@ -523,12 +523,12 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 					case 5:
 					case 6:
 						pUsFile =
-							(USHORT *) ((long)pFileStart
+							(u16 *) ((long)pFileStart
 								+
 								pFileHdr5->
 								commands_offset);
 						pUcFile =
-							(UCHAR *) ((long)pFileStart
+							(u8 *) ((long)pFileStart
 								   +
 								   pFileHdr5->
 								   commands_offset);
@@ -607,7 +607,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 					pMailBoxData =
 						(struct drv_msg *) & info->DSPInfoBlk[0];
 					pUsData =
-						(USHORT *) & pMailBoxData->data[0];
+						(u16 *) & pMailBoxData->data[0];
 					// Provide mutual exclusive access while reading ASIC registers.
 					spin_lock_irqsave(&info->dpram_lock,
 							  flags);
@@ -657,7 +657,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 						pFileHdr5->version_data_size;
 					put_request_value(dev, word_length);
 					pUsFile =
-						(USHORT *) ((long)pFileStart +
+						(u16 *) ((long)pFileStart +
 							pFileHdr5->
 							version_data_offset);
 					// Provide mutual exclusive access while reading ASIC registers.
@@ -709,7 +709,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 					break;
 
 				case REQUEST_CODE_BY_VERSION:
-					bGoodVersion = FALSE;
+					bGoodVersion = false;
 					requested_version =
 						get_request_value(dev);
 					if (file_version == 5) {
@@ -727,23 +727,23 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 								version ==
 								requested_version) {
 								bGoodVersion =
-									TRUE;
+									true;
 								pUsFile =
-									(USHORT
+									(u16
 									 *) ((long)
 									 pFileStart
 									 +
 									 pDspImageInfo->
 									 begin_offset);
 								pUcFile =
-									(UCHAR
+									(u8
 									 *) ((long)
 									 pFileStart
 									 +
 									 pDspImageInfo->
 									 begin_offset);
 								pCodeEnd =
-									(UCHAR
+									(u8
 									 *) ((long)
 									 pFileStart
 									 +
@@ -770,11 +770,11 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 							 imageN <
 							 pFileHdr5->nDspImages;
 							 imageN++) {
-							temp = (USHORT)
+							temp = (u16)
 								(pDspImageInfoV6->
 								 version);
 							templong = temp;
-							temp = (USHORT)
+							temp = (u16)
 								(pDspImageInfoV6->
 								 version >> 16);
 							templong |=
@@ -782,23 +782,23 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 							if (templong ==
 								requested_version) {
 								bGoodVersion =
-									TRUE;
+									true;
 								pUsFile =
-									(USHORT
+									(u16
 									 *) ((long)
 									 pFileStart
 									 +
 									 pDspImageInfoV6->
 									 begin_offset);
 								pUcFile =
-									(UCHAR
+									(u8
 									 *) ((long)
 									 pFileStart
 									 +
 									 pDspImageInfoV6->
 									 begin_offset);
 								pCodeEnd =
-									(UCHAR
+									(u8
 									 *) ((long)
 									 pFileStart
 									 +
@@ -811,7 +811,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 									pDspImageInfoV6->
 									image_size;
 								image_chksum =
-									(ULONG)
+									(u32)
 									pDspImageInfoV6->
 									checksum;
 								DEBUG(0,
@@ -886,7 +886,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 						GFP_ATOMIC);
 				if (pbuffer) {
 					memcpy(pbuffer, (void *)pUcFile,
-						   (UINT) (usHdrLength +
+						   (u32) (usHdrLength +
 							   sizeof(struct pseudo_hdr)));
 					// link provisioning data
 					pprov_record =
@@ -900,7 +900,7 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 								  &info->prov_list);
 						// Move to next entry if available
 						pUcFile =
-							(UCHAR *) ((unsigned long) pUcFile +
+							(u8 *) ((unsigned long) pUcFile +
 								   (unsigned long) ((usHdrLength + 1) & 0xFFFFFFFE) + sizeof(struct pseudo_hdr));
 						if ((unsigned long) (pUcFile) -
 							(unsigned long) (pFileStart) >=
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index d8fa797..b3739b9 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -56,7 +56,7 @@
 #include <linux/delay.h>
 #include "ft1000.h"
 
-int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength);
+int card_download(struct net_device *dev, const u8 *pFileStart, u32 FileLength);
 
 void ft1000InitProc(struct net_device *dev);
 void ft1000CleanupProc(struct net_device *dev);
@@ -405,8 +405,8 @@ static void ft1000_reset_asic(struct net_device *dev)
 // Input:
 //     dev    - device structure
 // Output:
-//     status - FALSE (card reset fail)
-//              TRUE  (card reset successful)
+//     status - false (card reset fail)
+//              true  (card reset successful)
 //
 //---------------------------------------------------------------------------
 static int ft1000_reset_card(struct net_device *dev)
@@ -506,7 +506,7 @@ static int ft1000_reset_card(struct net_device *dev)
 		if (i == 50) {
 			DEBUG(0,
 				  "ft1000_hw:ft1000_reset_card:No FEFE detected from DSP\n");
-			return FALSE;
+			return false;
 		}
 
 	} else {
@@ -517,7 +517,7 @@ static int ft1000_reset_card(struct net_device *dev)
 
 	if (card_download(dev, fw_entry->data, fw_entry->size)) {
 		DEBUG(1, "card download unsuccessful\n");
-		return FALSE;
+		return false;
 	} else {
 		DEBUG(1, "card download successful\n");
 	}
@@ -553,7 +553,7 @@ static int ft1000_reset_card(struct net_device *dev)
 //	poll_timer.data = (u_long)dev;
 //	add_timer(&poll_timer);
 
-	return TRUE;
+	return true;
 
 }
 
@@ -565,8 +565,8 @@ static int ft1000_reset_card(struct net_device *dev)
 // Input:
 //     dev    - device structure
 // Output:
-//     status - FALSE (device is not present)
-//              TRUE  (device is present)
+//     status - false (device is not present)
+//              true  (device is present)
 //
 //---------------------------------------------------------------------------
 static int ft1000_chkcard(struct net_device *dev)
@@ -579,7 +579,7 @@ static int ft1000_chkcard(struct net_device *dev)
 	if (tempword == 0) {
 		DEBUG(1,
 			  "ft1000_hw:ft1000_chkcard: IMASK = 0 Card not detected\n");
-		return FALSE;
+		return false;
 	}
 	// The system will return the value of 0xffff for the version register
 	// if the device is not present.
@@ -587,9 +587,9 @@ static int ft1000_chkcard(struct net_device *dev)
 	if (tempword == 0xffff) {
 		DEBUG(1,
 			  "ft1000_hw:ft1000_chkcard: Version = 0xffff Card not detected\n");
-		return FALSE;
+		return false;
 	}
-	return TRUE;
+	return true;
 }
 
 
@@ -609,7 +609,7 @@ static void ft1000_hbchk(u_long data)
 	struct net_device *dev = (struct net_device *)data;
 
 	struct ft1000_info *info;
-	USHORT tempword;
+	u16 tempword;
 
 	info = netdev_priv(dev);
 
@@ -907,7 +907,7 @@ void ft1000_send_cmd (struct net_device *dev, u16 *ptempbuffer, int size, u16 qt
 //          = 1 (successful)
 //
 //---------------------------------------------------------------------------
-BOOLEAN ft1000_receive_cmd(struct net_device *dev, u16 * pbuffer, int maxsz, u16 *pnxtph)
+bool ft1000_receive_cmd(struct net_device *dev, u16 * pbuffer, int maxsz, u16 *pnxtph)
 {
 	struct ft1000_info *info = netdev_priv(dev);
 	u16 size;
@@ -928,7 +928,7 @@ BOOLEAN ft1000_receive_cmd(struct net_device *dev, u16 * pbuffer, int maxsz, u16
 		DEBUG(1,
 			  "FT1000:ft1000_receive_cmd:Invalid command length = %d\n",
 			  size);
-		return FALSE;
+		return false;
 	} else {
 		ppseudohdr = (u16 *) pbuffer;
 		spin_lock_irqsave(&info->dpram_lock, flags);
@@ -983,9 +983,9 @@ BOOLEAN ft1000_receive_cmd(struct net_device *dev, u16 * pbuffer, int maxsz, u16
 			DEBUG(1,
 				  "FT1000:ft1000_receive_cmd:Pseudo header checksum mismatch\n");
 			// Drop this message
-			return FALSE;
+			return false;
 		}
-		return TRUE;
+		return true;
 	}
 }
 
@@ -1012,7 +1012,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 	u16 i;
 	struct prov_record *ptr;
 	struct pseudo_hdr *ppseudo_hdr;
-	PUSHORT pmsg;
+	u16 *pmsg;
 	struct timeval tv;
 	union {
 		u8 byte[2];
@@ -1055,7 +1055,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 				len = *(u16 *) ptr->pprov_data;
 				len = htons(len);
 
-				pmsg = (PUSHORT) ptr->pprov_data;
+				pmsg = (u16 *) ptr->pprov_data;
 				ppseudo_hdr = (struct pseudo_hdr *) pmsg;
 				// Insert slow queue sequence number
 				ppseudo_hdr->seq_num = info->squeseqnum++;
@@ -1146,7 +1146,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 			tempword = ntohs(pdrvmsg->length);
 			info->DSPInfoBlklen = tempword;
 			if (tempword < (MAX_DSP_SESS_REC - 4)) {
-				pmsg = (PUSHORT) & pdrvmsg->data[0];
+				pmsg = (u16 *) & pdrvmsg->data[0];
 				for (i = 0; i < ((tempword + 1) / 2); i++) {
 					DEBUG(1,
 						  "FT1000:drivermsg:dsp info data = 0x%x\n",
@@ -1173,7 +1173,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 			if ((tempword & FT1000_DB_DPRAM_TX) == 0) {
 				// Put message into Slow Queue
 				// Form Pseudo header
-				pmsg = (PUSHORT) info->DSPInfoBlk;
+				pmsg = (u16 *) info->DSPInfoBlk;
 				ppseudo_hdr = (struct pseudo_hdr *) pmsg;
 				ppseudo_hdr->length =
 					htons(info->DSPInfoBlklen + 4);
@@ -1198,7 +1198,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 				info->DSPInfoBlk[8] = 0x7200;
 				info->DSPInfoBlk[9] =
 					htons(info->DSPInfoBlklen);
-				ft1000_send_cmd (dev, (PUSHORT)info->DSPInfoBlk, (USHORT)(info->DSPInfoBlklen+4), 0);
+				ft1000_send_cmd (dev, (u16 *)info->DSPInfoBlk, (u16)(info->DSPInfoBlklen+4), 0);
 			}
 
 			break;
@@ -1220,7 +1220,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 			if ((tempword & FT1000_DB_DPRAM_TX) == 0) {
 				// Put message into Slow Queue
 				// Form Pseudo header
-				pmsg = (PUSHORT) & tempbuffer[0];
+				pmsg = (u16 *) & tempbuffer[0];
 				ppseudo_hdr = (struct pseudo_hdr *) pmsg;
 				ppseudo_hdr->length = htons(0x0012);
 				ppseudo_hdr->source = 0x10;
@@ -1241,7 +1241,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
                 for (i=1; i<7; i++) {
                     ppseudo_hdr->checksum ^= *pmsg++;
                 }
-				pmsg = (PUSHORT) & tempbuffer[16];
+				pmsg = (u16 *) & tempbuffer[16];
 				*pmsg++ = htons(RSP_DRV_ERR_RPT_MSG);
 				*pmsg++ = htons(0x000e);
 				*pmsg++ = htons(info->DSP_TIME[0]);
@@ -1256,7 +1256,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 				*pmsg++ = convert.wrd;
 				*pmsg++ = htons(info->DrvErrNum);
 
-				ft1000_send_cmd (dev, (PUSHORT)&tempbuffer[0], (USHORT)(0x0012), 0);
+				ft1000_send_cmd (dev, (u16 *)&tempbuffer[0], (u16)(0x0012), 0);
 				info->DrvErrNum = 0;
 			}
 
@@ -1698,7 +1698,7 @@ int ft1000_copy_up_pkt(struct net_device *dev)
 			tempword = ft1000_read_reg(dev, FT1000_REG_DFIFO);
 			*pbuffer++ = (u8) (tempword >> 8);
 			*pbuffer++ = (u8) tempword;
-			if (ft1000_chkcard(dev) == FALSE) {
+			if (ft1000_chkcard(dev) == false) {
 				kfree_skb(skb);
 				return FAILURE;
 			}
@@ -2025,7 +2025,7 @@ static irqreturn_t ft1000_interrupt(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
-	if (ft1000_chkcard(dev) == FALSE) {
+	if (ft1000_chkcard(dev) == false) {
 		ft1000_disable_interrupts(dev);
 		return IRQ_HANDLED;
 	}
-- 
Ondrej Zary

