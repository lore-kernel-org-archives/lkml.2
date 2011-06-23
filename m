Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab1FWTnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 15:43:39 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:35917 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932726Ab1FWTni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 15:43:38 -0400
Subject: [PATCH 11/11] Remove support for v5 firmware
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
From: Ondrej Zary <linux@rainbow-software.org>
Date: Thu, 23 Jun 2011 21:43:30 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106232143.32017.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove support for v5 firmware images as all known firmware images are v6.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |  441 +++++++-------------
 1 files changed, 140 insertions(+), 301 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
index c8b73c6..9e594b0 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -94,18 +94,6 @@ void put_request_value(struct net_device *dev, long lvalue);
 u16 hdr_checksum(struct pseudo_hdr *pHdr);
 
 struct dsp_file_hdr {
-	u32  build_date;
-	u32  dsp_coff_date;
-	u32  loader_code_address;
-	u32  loader_code_size;
-	u32  loader_code_end;
-	u32  dsp_code_address;
-	u32  dsp_code_size;
-	u32  dsp_code_end;
-	u32  reserved[8];
-} __attribute__ ((packed));
-
-struct dsp_file_hdr_5 {
 	u32  version_id;	// Version ID of this image format.
 	u32  package_id;	// Package ID of code release.
 	u32  build_date;	// Date/time stamp when file was built.
@@ -126,15 +114,6 @@ struct dsp_image_info {
 	u32  run_address;	// On chip Start address of DSP code.
 	u32  image_size;	// Size of image.
 	u32  version;		// Embedded version # of DSP code.
-} __attribute__ ((packed));
-
-struct dsp_image_info_v6 {
-	u32  coff_date;		// Date/time when DSP Coff image was built.
-	u32  begin_offset;	// Offset in file where image begins.
-	u32  end_offset;	// Offset in file where image begins.
-	u32  run_address;	// On chip Start address of DSP code.
-	u32  image_size;	// Size of image.
-	u32  version;		// Embedded version # of DSP code.
 	unsigned short checksum;	// Dsp File checksum
 	unsigned short pad1;
 } __attribute__ ((packed));
@@ -312,20 +291,17 @@ int card_download(struct net_device *dev, const u8 *pFileStart, u32 FileLength)
 {
 	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
 	int Status = SUCCESS;
-	u16 DspWordCnt = 0;
 	u32 uiState;
 	u16 handshake;
 	struct pseudo_hdr *pHdr;
 	u16 usHdrLength;
-	struct dsp_file_hdr *pFileHdr;
 	long word_length;
 	u16 request;
 	u16 temp;
 	struct prov_record *pprov_record;
 	u8 *pbuffer;
-	struct dsp_file_hdr_5 *pFileHdr5;
-	struct dsp_image_info *pDspImageInfo = NULL;
-	struct dsp_image_info_v6 *pDspImageInfoV6 = NULL;
+	struct dsp_file_hdr *pFileHdr5;
+	struct dsp_image_info *pDspImageInfoV6 = NULL;
 	long requested_version;
 	bool bGoodVersion = 0;
 	struct drv_msg *pMailBoxData;
@@ -344,36 +320,22 @@ int card_download(struct net_device *dev, const u8 *pFileStart, u32 FileLength)
 	unsigned long templong;
 	unsigned long image_chksum = 0;
 
-	//
-	// Get version id of file, at first 4 bytes of file, for newer files.
-	//
 	file_version = *(long *)pFileStart;
+	if (file_version != 6) {
+	        printk(KERN_ERR "ft1000: unsupported firmware version %ld\n", file_version);
+	        Status = FAILURE;
+	}
 
 	uiState = STATE_START_DWNLD;
 
-	pFileHdr = (struct dsp_file_hdr *) pFileStart;
-	pFileHdr5 = (struct dsp_file_hdr_5 *) pFileStart;
-
-	switch (file_version) {
-	case 5:
-	case 6:
-		pUsFile =
-			(u16 *) ((long)pFileStart + pFileHdr5->loader_offset);
-		pUcFile =
-			(u8 *) ((long)pFileStart + pFileHdr5->loader_offset);
-
-		pBootEnd =
-			(u8 *) ((long)pFileStart + pFileHdr5->loader_code_end);
-
-		loader_code_address = pFileHdr5->loader_code_address;
-		loader_code_size = pFileHdr5->loader_code_size;
-		bGoodVersion = false;
-		break;
+	pFileHdr5 = (struct dsp_file_hdr *) pFileStart;
 
-	default:
-		Status = FAILURE;
-		break;
-	}
+	pUsFile = (u16 *) ((long)pFileStart + pFileHdr5->loader_offset);
+	pUcFile = (u8 *) ((long)pFileStart + pFileHdr5->loader_offset);
+	pBootEnd = (u8 *) ((long)pFileStart + pFileHdr5->loader_code_end);
+	loader_code_address = pFileHdr5->loader_code_address;
+	loader_code_size = pFileHdr5->loader_code_size;
+	bGoodVersion = false;
 
 	while ((Status == SUCCESS) && (uiState != STATE_DONE_FILE)) {
 
@@ -431,46 +393,26 @@ int card_download(struct net_device *dev, const u8 *pFileStart, u32 FileLength)
 					// Provide mutual exclusive access while reading ASIC registers.
 					spin_lock_irqsave(&info->dpram_lock,
 							  flags);
-					if (file_version == 5) {
-						/*
-						 * Position ASIC DPRAM auto-increment pointer.
-						 */
-						ft1000_write_reg(dev,
-								 FT1000_REG_DPRAM_ADDR,
-								 DWNLD_PS_HDR_LOC);
-
-						for (; word_length > 0; word_length--) {	/* In words */
-							//temp = *pUsFile;
-							//temp = RtlUshortByteSwap(temp);
-							ft1000_write_reg(dev,
-									 FT1000_REG_DPRAM_DATA,
-									 *pUsFile);
-							pUsFile++;
-							pUcFile += 2;
-							DspWordCnt++;
-						}
-					} else {
-						/*
-						 * Position ASIC DPRAM auto-increment pointer.
-						 */
-						outw(DWNLD_MAG_PS_HDR_LOC,
-							 dev->base_addr +
-							 FT1000_REG_DPRAM_ADDR);
-						if (word_length & 0x01) {
-							word_length++;
-						}
-						word_length = word_length / 2;
-
-						for (; word_length > 0; word_length--) {	/* In words */
-							templong = *pUsFile++;
-							templong |=
-								(*pUsFile++ << 16);
-							pUcFile += 4;
-							outl(templong,
-								 dev->base_addr +
-								 FT1000_REG_MAG_DPDATAL);
-						}
-					}
+                                        /*
+                                         * Position ASIC DPRAM auto-increment pointer.
+                                         */
+                                        outw(DWNLD_MAG_PS_HDR_LOC,
+                                                 dev->base_addr +
+                                                 FT1000_REG_DPRAM_ADDR);
+                                        if (word_length & 0x01) {
+                                                word_length++;
+                                        }
+                                        word_length = word_length / 2;
+
+                                        for (; word_length > 0; word_length--) {	/* In words */
+                                                templong = *pUsFile++;
+                                                templong |=
+                                                        (*pUsFile++ << 16);
+                                                pUcFile += 4;
+                                                outl(templong,
+                                                         dev->base_addr +
+                                                         FT1000_REG_MAG_DPDATAL);
+                                        }
 					spin_unlock_irqrestore(&info->
 								   dpram_lock,
 								   flags);
@@ -519,24 +461,8 @@ int card_download(struct net_device *dev, const u8 *pFileStart, u32 FileLength)
 					break;
 				case REQUEST_DONE_CL:
 					/* Reposition ptrs to beginning of provisioning section */
-					switch (file_version) {
-					case 5:
-					case 6:
-						pUsFile =
-							(u16 *) ((long)pFileStart
-								+
-								pFileHdr5->
-								commands_offset);
-						pUcFile =
-							(u8 *) ((long)pFileStart
-								   +
-								   pFileHdr5->
-								   commands_offset);
-						break;
-					default:
-						Status = FAILURE;
-						break;
-					}
+					pUsFile = (u16 *) ((long)pFileStart + pFileHdr5->commands_offset);
+					pUcFile = (u8 *) ((long)pFileStart + pFileHdr5->commands_offset);
 					uiState = STATE_DONE_DWNLD;
 					break;
 				case REQUEST_CODE_SEGMENT:
@@ -557,46 +483,26 @@ int card_download(struct net_device *dev, const u8 *pFileStart, u32 FileLength)
 						Status = FAILURE;
 						break;
 					}
-					if (file_version == 5) {
-						/*
-						 * Position ASIC DPRAM auto-increment pointer.
-						 */
-						ft1000_write_reg(dev,
-								 FT1000_REG_DPRAM_ADDR,
-								 DWNLD_PS_HDR_LOC);
-
-						for (; word_length > 0; word_length--) {	/* In words */
-							//temp = *pUsFile;
-							//temp = RtlUshortByteSwap(temp);
-							ft1000_write_reg(dev,
-									 FT1000_REG_DPRAM_DATA,
-									 *pUsFile);
-							pUsFile++;
-							pUcFile += 2;
-							DspWordCnt++;
-						}
-					} else {
-						/*
-						 * Position ASIC DPRAM auto-increment pointer.
-						 */
-						outw(DWNLD_MAG_PS_HDR_LOC,
-							 dev->base_addr +
-							 FT1000_REG_DPRAM_ADDR);
-						if (word_length & 0x01) {
-							word_length++;
-						}
-						word_length = word_length / 2;
-
-						for (; word_length > 0; word_length--) {	/* In words */
-							templong = *pUsFile++;
-							templong |=
-								(*pUsFile++ << 16);
-							pUcFile += 4;
-							outl(templong,
-								 dev->base_addr +
-								 FT1000_REG_MAG_DPDATAL);
-						}
-					}
+                                        /*
+                                         * Position ASIC DPRAM auto-increment pointer.
+                                         */
+                                        outw(DWNLD_MAG_PS_HDR_LOC,
+                                                 dev->base_addr +
+                                                 FT1000_REG_DPRAM_ADDR);
+                                        if (word_length & 0x01) {
+                                                word_length++;
+                                        }
+                                        word_length = word_length / 2;
+
+                                        for (; word_length > 0; word_length--) {	/* In words */
+                                                templong = *pUsFile++;
+                                                templong |=
+                                                        (*pUsFile++ << 16);
+                                                pUcFile += 4;
+                                                outl(templong,
+                                                         dev->base_addr +
+                                                         FT1000_REG_MAG_DPDATAL);
+                                        }
 					break;
 
 				case REQUEST_MAILBOX_DATA:
@@ -663,46 +569,28 @@ int card_download(struct net_device *dev, const u8 *pFileStart, u32 FileLength)
 					// Provide mutual exclusive access while reading ASIC registers.
 					spin_lock_irqsave(&info->dpram_lock,
 							  flags);
-					if (file_version == 5) {
-						/*
-						 * Position ASIC DPRAM auto-increment pointer.
-						 */
-						ft1000_write_reg(dev,
-								 FT1000_REG_DPRAM_ADDR,
-								 DWNLD_PS_HDR_LOC);
-
-						for (; word_length > 0; word_length--) {	/* In words */
-							ft1000_write_reg(dev,
-									 FT1000_REG_DPRAM_DATA,
-									 *pUsFile
-									 /*temp */
-								);
-							pUsFile++;
-						}
-					} else {
-						/*
-						 * Position ASIC DPRAM auto-increment pointer.
-						 */
-						outw(DWNLD_MAG_PS_HDR_LOC,
-							 dev->base_addr +
-							 FT1000_REG_DPRAM_ADDR);
-						if (word_length & 0x01) {
-							word_length++;
-						}
-						word_length = word_length / 2;
-
-						for (; word_length > 0; word_length--) {	/* In words */
-							templong =
-								ntohs(*pUsFile++);
-							temp =
-								ntohs(*pUsFile++);
-							templong |=
-								(temp << 16);
-							outl(templong,
-								 dev->base_addr +
-								 FT1000_REG_MAG_DPDATAL);
-						}
-					}
+                                        /*
+                                         * Position ASIC DPRAM auto-increment pointer.
+                                         */
+                                        outw(DWNLD_MAG_PS_HDR_LOC,
+                                                 dev->base_addr +
+                                                 FT1000_REG_DPRAM_ADDR);
+                                        if (word_length & 0x01) {
+                                                word_length++;
+                                        }
+                                        word_length = word_length / 2;
+
+                                        for (; word_length > 0; word_length--) {	/* In words */
+                                                templong =
+                                                        ntohs(*pUsFile++);
+                                                temp =
+                                                        ntohs(*pUsFile++);
+                                                templong |=
+                                                        (temp << 16);
+                                                outl(templong,
+                                                         dev->base_addr +
+                                                         FT1000_REG_MAG_DPDATAL);
+                                        }
 					spin_unlock_irqrestore(&info->
 								   dpram_lock,
 								   flags);
@@ -712,118 +600,69 @@ int card_download(struct net_device *dev, const u8 *pFileStart, u32 FileLength)
 					bGoodVersion = false;
 					requested_version =
 						get_request_value(dev);
-					if (file_version == 5) {
-						pDspImageInfo =
-							(struct dsp_image_info *) ((long)
-									   pFileStart
-									   +
-									   sizeof
-									   (struct dsp_file_hdr_5));
-						for (imageN = 0;
-							 imageN <
-							 pFileHdr5->nDspImages;
-							 imageN++) {
-							if (pDspImageInfo->
-								version ==
-								requested_version) {
-								bGoodVersion =
-									true;
-								pUsFile =
-									(u16
-									 *) ((long)
-									 pFileStart
-									 +
-									 pDspImageInfo->
-									 begin_offset);
-								pUcFile =
-									(u8
-									 *) ((long)
-									 pFileStart
-									 +
-									 pDspImageInfo->
-									 begin_offset);
-								pCodeEnd =
-									(u8
-									 *) ((long)
-									 pFileStart
-									 +
-									 pDspImageInfo->
-									 end_offset);
-								run_address =
-									pDspImageInfo->
-									run_address;
-								run_size =
-									pDspImageInfo->
-									image_size;
-								break;
-							}
-							pDspImageInfo++;
-						}
-					} else {
-						pDspImageInfoV6 =
-							(struct dsp_image_info_v6 *) ((long)
-									  pFileStart
-									  +
-									  sizeof
-									  (struct dsp_file_hdr_5));
-						for (imageN = 0;
-							 imageN <
-							 pFileHdr5->nDspImages;
-							 imageN++) {
-							temp = (u16)
-								(pDspImageInfoV6->
-								 version);
-							templong = temp;
-							temp = (u16)
-								(pDspImageInfoV6->
-								 version >> 16);
-							templong |=
-								(temp << 16);
-							if (templong ==
-								requested_version) {
-								bGoodVersion =
-									true;
-								pUsFile =
-									(u16
-									 *) ((long)
-									 pFileStart
-									 +
-									 pDspImageInfoV6->
-									 begin_offset);
-								pUcFile =
-									(u8
-									 *) ((long)
-									 pFileStart
-									 +
-									 pDspImageInfoV6->
-									 begin_offset);
-								pCodeEnd =
-									(u8
-									 *) ((long)
-									 pFileStart
-									 +
-									 pDspImageInfoV6->
-									 end_offset);
-								run_address =
-									pDspImageInfoV6->
-									run_address;
-								run_size =
-									pDspImageInfoV6->
-									image_size;
-								image_chksum =
-									(u32)
-									pDspImageInfoV6->
-									checksum;
-								DEBUG(0,
-									  "ft1000_dnld: image_chksum = 0x%8x\n",
-									  (unsigned
-									   int)
-									  image_chksum);
-								break;
-							}
-							pDspImageInfoV6++;
-						}
-					}
+                                        pDspImageInfoV6 =
+                                                (struct dsp_image_info *) ((long)
+                                                                  pFileStart
+                                                                  +
+                                                                  sizeof
+                                                                  (struct dsp_file_hdr));
+                                        for (imageN = 0;
+                                                 imageN <
+                                                 pFileHdr5->nDspImages;
+                                                 imageN++) {
+                                                temp = (u16)
+                                                        (pDspImageInfoV6->
+                                                         version);
+                                                templong = temp;
+                                                temp = (u16)
+                                                        (pDspImageInfoV6->
+                                                         version >> 16);
+                                                templong |=
+                                                        (temp << 16);
+                                                if (templong ==
+                                                        requested_version) {
+                                                        bGoodVersion =
+                                                                true;
+                                                        pUsFile =
+                                                                (u16
+                                                                 *) ((long)
+                                                                 pFileStart
+                                                                 +
+                                                                 pDspImageInfoV6->
+                                                                 begin_offset);
+                                                        pUcFile =
+                                                                (u8
+                                                                 *) ((long)
+                                                                 pFileStart
+                                                                 +
+                                                                 pDspImageInfoV6->
+                                                                 begin_offset);
+                                                        pCodeEnd =
+                                                                (u8
+                                                                 *) ((long)
+                                                                 pFileStart
+                                                                 +
+                                                                 pDspImageInfoV6->
+                                                                 end_offset);
+                                                        run_address =
+                                                                pDspImageInfoV6->
+                                                                run_address;
+                                                        run_size =
+                                                                pDspImageInfoV6->
+                                                                image_size;
+                                                        image_chksum =
+                                                                (u32)
+                                                                pDspImageInfoV6->
+                                                                checksum;
+                                                        DEBUG(0,
+                                                                  "ft1000_dnld: image_chksum = 0x%8x\n",
+                                                                  (unsigned
+                                                                   int)
+                                                                  image_chksum);
+                                                        break;
+                                                }
+                                                pDspImageInfoV6++;
+                                        }
 					if (!bGoodVersion) {
 						/*
 						 * Error, beyond boot code range.
-- 
Ondrej Zary

