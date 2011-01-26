Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab1AZLsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:48:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54458 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab1AZLss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:48:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=GBGYuQogS6ODa5JVkTjHNKvmChRAHQwpqvrrt1D+yd/bg1gOTm3s/2FjX+n68/9QEG
         gCDz4NwbjQB+6Pq/HgNj/8UrXLDL07lcdRHBq0tSAGqdVXW/pX/Oys0zWQtOPX8Oh+5N
         YfdaROwtyMatuYt9kdbsdzgDwCzI7IP+18Wus=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 5/5] staging: ft1000: Fix indentation in scram_dnldr() function.
Date: Wed, 26 Jan 2011 12:49:15 +0100
Message-Id: <1296042555-29145-5-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
References: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |  934 +++++++++++---------
 1 files changed, 509 insertions(+), 425 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 1e12c41..942d923 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -689,450 +689,533 @@ static u32 write_blk_fifo(struct ft1000_device *ft1000dev, u16 **pUsFile,
 //  Returns:    status                  - return code
 //---------------------------------------------------------------------------
 
-u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLength)
+u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart,
+		u32 FileLength)
 {
-   u16                     status = STATUS_SUCCESS;
-   u32                    state;
-   u16                  handshake;
+	u16 status = STATUS_SUCCESS;
+	u32 state;
+	u16 handshake;
 	struct pseudo_hdr *pseudo_header;
-   u16                  pseudo_header_len;
-   long                    word_length;
-   u16                  request;
-   u16                  temp;
-   u16                  tempword;
+	u16 pseudo_header_len;
+	long word_length;
+	u16 request;
+	u16 temp;
+	u16 tempword;
 
 	struct dsp_file_hdr *file_hdr;
 	struct dsp_image_info *dsp_img_info = NULL;
-   long                    requested_version;
-   bool                 correct_version;
+	long requested_version;
+	bool correct_version;
 	struct drv_msg *mailbox_data;
-   u16                  *data = NULL;
-   u16                  *s_file = NULL;
-   u8                   *c_file = NULL;
-   u8                   *boot_end = NULL, *code_end= NULL;
-   int                     image;
-   long                    loader_code_address, loader_code_size = 0;
-   long                    run_address = 0, run_size = 0;
-
-   u32                   templong;
-   u32                   image_chksum = 0;
-
-   u16                  dpram = 0;
-   u8 *pbuffer;
+	u16 *data = NULL;
+	u16 *s_file = NULL;
+	u8 *c_file = NULL;
+	u8 *boot_end = NULL, *code_end = NULL;
+	int image;
+	long loader_code_address, loader_code_size = 0;
+	long run_address = 0, run_size = 0;
+
+	u32 templong;
+	u32 image_chksum = 0;
+
+	u16 dpram = 0;
+	u8 *pbuffer;
 	struct prov_record *pprov_record;
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
-   DEBUG("Entered   scram_dnldr...\n");
+	DEBUG("Entered   scram_dnldr...\n");
 
-   pft1000info->fcodeldr = 0;
-   pft1000info->usbboot = 0;
-   pft1000info->dspalive = 0xffff;
+	pft1000info->fcodeldr = 0;
+	pft1000info->usbboot = 0;
+	pft1000info->dspalive = 0xffff;
 
+	//
+	// Get version id of file, at first 4 bytes of file, for newer files.
+	//
 
-   //
-   // Get version id of file, at first 4 bytes of file, for newer files.
-   //
+	state = STATE_START_DWNLD;
 
-   state = STATE_START_DWNLD;
+	file_hdr = (struct dsp_file_hdr *)pFileStart;
 
-   file_hdr = (struct dsp_file_hdr *)pFileStart;
+	ft1000_write_register(ft1000dev, 0x800, FT1000_REG_MAG_WATERMARK);
 
-   ft1000_write_register (ft1000dev, 0x800, FT1000_REG_MAG_WATERMARK);
+	s_file = (u16 *) (pFileStart + file_hdr->loader_offset);
+	c_file = (u8 *) (pFileStart + file_hdr->loader_offset);
 
-      s_file = (u16 *)(pFileStart + file_hdr->loader_offset);
-      c_file = (u8 *)(pFileStart + file_hdr->loader_offset);
+	boot_end = (u8 *) (pFileStart + file_hdr->loader_code_end);
 
-      boot_end = (u8 *)(pFileStart + file_hdr->loader_code_end);
+	loader_code_address = file_hdr->loader_code_address;
+	loader_code_size = file_hdr->loader_code_size;
+	correct_version = FALSE;
+
+	while ((status == STATUS_SUCCESS) && (state != STATE_DONE_FILE)) {
+		switch (state) {
+		case STATE_START_DWNLD:
+			DEBUG("FT1000:STATE_START_DWNLD\n");
+			if (pft1000info->usbboot)
+				handshake =
+				    get_handshake_usb(ft1000dev,
+						      HANDSHAKE_DSP_BL_READY);
+			else
+				handshake =
+				    get_handshake(ft1000dev,
+						  HANDSHAKE_DSP_BL_READY);
+
+			if (handshake == HANDSHAKE_DSP_BL_READY) {
+				DEBUG
+				    ("scram_dnldr: handshake is HANDSHAKE_DSP_BL_READY, call put_handshake(HANDSHAKE_DRIVER_READY)\n");
+				put_handshake(ft1000dev,
+					      HANDSHAKE_DRIVER_READY);
+			} else {
+				DEBUG
+				    ("FT1000:download:Download error: Handshake failed\n");
+				status = STATUS_FAILURE;
+			}
 
-      loader_code_address = file_hdr->loader_code_address;
-      loader_code_size = file_hdr->loader_code_size;
-      correct_version = FALSE;
+			state = STATE_BOOT_DWNLD;
 
-   while ((status == STATUS_SUCCESS) && (state != STATE_DONE_FILE))
-   {
-      switch (state)
-      {
-      case  STATE_START_DWNLD:
-         DEBUG("FT1000:STATE_START_DWNLD\n");
-         if (pft1000info->usbboot)
-             handshake = get_handshake_usb(ft1000dev, HANDSHAKE_DSP_BL_READY);
-         else
-             handshake = get_handshake(ft1000dev, HANDSHAKE_DSP_BL_READY);
-
-         if (handshake == HANDSHAKE_DSP_BL_READY)
-         {
-            DEBUG("scram_dnldr: handshake is HANDSHAKE_DSP_BL_READY, call put_handshake(HANDSHAKE_DRIVER_READY)\n");
-            put_handshake(ft1000dev, HANDSHAKE_DRIVER_READY);
-         }
-         else
-         {
-            DEBUG("FT1000:download:Download error: Handshake failed\n");
-            status = STATUS_FAILURE;
-         }
-
-         state = STATE_BOOT_DWNLD;
-
-         break;
-
-      case STATE_BOOT_DWNLD:
-         DEBUG("FT1000:STATE_BOOT_DWNLD\n");
-         pft1000info->bootmode = 1;
-         handshake = get_handshake(ft1000dev, HANDSHAKE_REQUEST);
-         if (handshake == HANDSHAKE_REQUEST)
-         {
-            /*
-             * Get type associated with the request.
-             */
-            request = get_request_type(ft1000dev);
-            switch (request)
-            {
-            case  REQUEST_RUN_ADDRESS:
-               DEBUG("FT1000:REQUEST_RUN_ADDRESS\n");
-               put_request_value(ft1000dev, loader_code_address);
-               break;
-            case  REQUEST_CODE_LENGTH:
-               DEBUG("FT1000:REQUEST_CODE_LENGTH\n");
-               put_request_value(ft1000dev, loader_code_size);
-               break;
-            case  REQUEST_DONE_BL:
-               DEBUG("FT1000:REQUEST_DONE_BL\n");
-               /* Reposition ptrs to beginning of code section */
-               s_file = (u16 *)(boot_end);
-               c_file = (u8 *)(boot_end);
-               //DEBUG("FT1000:download:s_file = 0x%8x\n", (int)s_file);
-               //DEBUG("FT1000:download:c_file = 0x%8x\n", (int)c_file);
-               state = STATE_CODE_DWNLD;
-               pft1000info->fcodeldr = 1;
-               break;
-            case  REQUEST_CODE_SEGMENT:
-               //DEBUG("FT1000:REQUEST_CODE_SEGMENT\n");
-               word_length = get_request_value(ft1000dev);
-               //DEBUG("FT1000:word_length = 0x%x\n", (int)word_length);
-               //NdisMSleep (100);
-               if (word_length > MAX_LENGTH)
-               {
-                  DEBUG("FT1000:download:Download error: Max length exceeded\n");
-                  status = STATUS_FAILURE;
-                  break;
-               }
-               if ( (word_length*2 + c_file) > boot_end)
-               {
-                  /*
-                   * Error, beyond boot code range.
-                   */
-                  DEBUG("FT1000:download:Download error: Requested len=%d exceeds BOOT code boundry.\n",
-                                                            (int)word_length);
-                  status = STATUS_FAILURE;
-                  break;
-               }
-               /*
-                * Position ASIC DPRAM auto-increment pointer.
-                */
-				    dpram = (u16)DWNLD_MAG1_PS_HDR_LOC;
+			break;
+
+		case STATE_BOOT_DWNLD:
+			DEBUG("FT1000:STATE_BOOT_DWNLD\n");
+			pft1000info->bootmode = 1;
+			handshake = get_handshake(ft1000dev, HANDSHAKE_REQUEST);
+			if (handshake == HANDSHAKE_REQUEST) {
+				/*
+				 * Get type associated with the request.
+				 */
+				request = get_request_type(ft1000dev);
+				switch (request) {
+				case REQUEST_RUN_ADDRESS:
+					DEBUG("FT1000:REQUEST_RUN_ADDRESS\n");
+					put_request_value(ft1000dev,
+							  loader_code_address);
+					break;
+				case REQUEST_CODE_LENGTH:
+					DEBUG("FT1000:REQUEST_CODE_LENGTH\n");
+					put_request_value(ft1000dev,
+							  loader_code_size);
+					break;
+				case REQUEST_DONE_BL:
+					DEBUG("FT1000:REQUEST_DONE_BL\n");
+					/* Reposition ptrs to beginning of code section */
+					s_file = (u16 *) (boot_end);
+					c_file = (u8 *) (boot_end);
+					//DEBUG("FT1000:download:s_file = 0x%8x\n", (int)s_file);
+					//DEBUG("FT1000:download:c_file = 0x%8x\n", (int)c_file);
+					state = STATE_CODE_DWNLD;
+					pft1000info->fcodeldr = 1;
+					break;
+				case REQUEST_CODE_SEGMENT:
+					//DEBUG("FT1000:REQUEST_CODE_SEGMENT\n");
+					word_length =
+					    get_request_value(ft1000dev);
+					//DEBUG("FT1000:word_length = 0x%x\n", (int)word_length);
+					//NdisMSleep (100);
+					if (word_length > MAX_LENGTH) {
+						DEBUG
+						    ("FT1000:download:Download error: Max length exceeded\n");
+						status = STATUS_FAILURE;
+						break;
+					}
+					if ((word_length * 2 + c_file) >
+					    boot_end) {
+						/*
+						 * Error, beyond boot code range.
+						 */
+						DEBUG
+						    ("FT1000:download:Download error: Requested len=%d exceeds BOOT code boundry.\n",
+						     (int)word_length);
+						status = STATUS_FAILURE;
+						break;
+					}
+					/*
+					 * Position ASIC DPRAM auto-increment pointer.
+					 */
+					dpram = (u16) DWNLD_MAG1_PS_HDR_LOC;
 					if (word_length & 0x1)
 						word_length++;
 					word_length = word_length / 2;
 
-			status =   write_blk(ft1000dev, &s_file, &c_file, word_length);
-			//DEBUG("write_blk returned %d\n", status);
-               break;
-            default:
-               DEBUG("FT1000:download:Download error: Bad request type=%d in BOOT download state.\n",request);
-               status = STATUS_FAILURE;
-               break;
-            }
-            if (pft1000info->usbboot)
-                put_handshake_usb(ft1000dev, HANDSHAKE_RESPONSE);
-            else
-                put_handshake(ft1000dev, HANDSHAKE_RESPONSE);
-         }
-         else
-         {
-            DEBUG("FT1000:download:Download error: Handshake failed\n");
-            status = STATUS_FAILURE;
-         }
-
-         break;
-
-      case STATE_CODE_DWNLD:
-         //DEBUG("FT1000:STATE_CODE_DWNLD\n");
-         pft1000info->bootmode = 0;
-         if (pft1000info->usbboot)
-            handshake = get_handshake_usb(ft1000dev, HANDSHAKE_REQUEST);
-         else
-            handshake = get_handshake(ft1000dev, HANDSHAKE_REQUEST);
-         if (handshake == HANDSHAKE_REQUEST)
-         {
-            /*
-             * Get type associated with the request.
-             */
-            if (pft1000info->usbboot)
-                request = get_request_type_usb(ft1000dev);
-            else
-                request = get_request_type(ft1000dev);
-            switch (request)
-            {
-            case REQUEST_FILE_CHECKSUM:
-                DEBUG("FT1000:download:image_chksum = 0x%8x\n", image_chksum);
-                put_request_value(ft1000dev, image_chksum);
-                break;
-            case  REQUEST_RUN_ADDRESS:
-               DEBUG("FT1000:download:  REQUEST_RUN_ADDRESS\n");
-               if (correct_version)
-               {
-                  DEBUG("FT1000:download:run_address = 0x%8x\n", (int)run_address);
-                  put_request_value(ft1000dev, run_address);
-               }
-               else
-               {
-                  DEBUG("FT1000:download:Download error: Got Run address request before image offset request.\n");
-                  status = STATUS_FAILURE;
-                  break;
-               }
-               break;
-            case  REQUEST_CODE_LENGTH:
-               DEBUG("FT1000:download:REQUEST_CODE_LENGTH\n");
-               if (correct_version)
-               {
-                  DEBUG("FT1000:download:run_size = 0x%8x\n", (int)run_size);
-                  put_request_value(ft1000dev, run_size);
-               }
-               else
-               {
-                  DEBUG("FT1000:download:Download error: Got Size request before image offset request.\n");
-                  status = STATUS_FAILURE;
-                  break;
-               }
-               break;
-            case  REQUEST_DONE_CL:
-               pft1000info->usbboot = 3;
-               /* Reposition ptrs to beginning of provisioning section */
-                  s_file = (u16 *)(pFileStart + file_hdr->commands_offset);
-                  c_file = (u8 *)(pFileStart + file_hdr->commands_offset);
-               state = STATE_DONE_DWNLD;
-               break;
-            case  REQUEST_CODE_SEGMENT:
-               //DEBUG("FT1000:download: REQUEST_CODE_SEGMENT - CODELOADER\n");
-               if (!correct_version)
-               {
-                  DEBUG("FT1000:download:Download error: Got Code Segment request before image offset request.\n");
-                  status = STATUS_FAILURE;
-                  break;
-               }
-
-               word_length = get_request_value(ft1000dev);
-               //DEBUG("FT1000:download:word_length = %d\n", (int)word_length);
-               if (word_length > MAX_LENGTH)
-               {
-                  DEBUG("FT1000:download:Download error: Max length exceeded\n");
-                  status = STATUS_FAILURE;
-                  break;
-               }
-               if ( (word_length*2 + c_file) > code_end)
-               {
-                  /*
-                   * Error, beyond boot code range.
-                   */
-                  DEBUG("FT1000:download:Download error: Requested len=%d exceeds DSP code boundry.\n",
-                               (int)word_length);
-                  status = STATUS_FAILURE;
-                  break;
-               }
-               /*
-                * Position ASIC DPRAM auto-increment pointer.
-                */
-		   dpram = (u16)DWNLD_MAG1_PS_HDR_LOC;
-		   if (word_length & 0x1)
-			word_length++;
-		   word_length = word_length / 2;
-
-   	       write_blk_fifo (ft1000dev, &s_file, &c_file, word_length);
-               if (pft1000info->usbboot == 0)
-                   pft1000info->usbboot++;
-               if (pft1000info->usbboot == 1) {
-                   tempword = 0;
-                   ft1000_write_dpram16 (ft1000dev, DWNLD_MAG1_PS_HDR_LOC, tempword, 0);
-               }
-
-               break;
-
-            case  REQUEST_MAILBOX_DATA:
-               DEBUG("FT1000:download: REQUEST_MAILBOX_DATA\n");
-               // Convert length from byte count to word count. Make sure we round up.
-               word_length = (long)(pft1000info->DSPInfoBlklen + 1)/2;
-               put_request_value(ft1000dev, word_length);
-		mailbox_data = (struct drv_msg *)&(pft1000info->DSPInfoBlk[0]);
-               /*
-                * Position ASIC DPRAM auto-increment pointer.
-                */
-
-
-                   data = (u16 *)&mailbox_data->data[0];
-                   dpram = (u16)DWNLD_MAG1_PS_HDR_LOC;
-                   if (word_length & 0x1)
-                       word_length++;
-
-                   word_length = (word_length / 2);
-
-
-               for (; word_length > 0; word_length--) /* In words */
-               {
-
-                      templong = *data++;
-					  templong |= (*data++ << 16);
-                      status = fix_ft1000_write_dpram32 (ft1000dev, dpram++, (u8 *)&templong);
-
-               }
-               break;
-
-            case  REQUEST_VERSION_INFO:
-               DEBUG("FT1000:download:REQUEST_VERSION_INFO\n");
-               word_length = file_hdr->version_data_size;
-               put_request_value(ft1000dev, word_length);
-               /*
-                * Position ASIC DPRAM auto-increment pointer.
-                */
-
-               s_file = (u16 *)(pFileStart + file_hdr->version_data_offset);
-
-
-                   dpram = (u16)DWNLD_MAG1_PS_HDR_LOC;
-                   if (word_length & 0x1)
-                       word_length++;
-
-                   word_length = (word_length / 2);
-
-
-               for (; word_length > 0; word_length--) /* In words */
-               {
-
-                      templong = ntohs(*s_file++);
-					  temp = ntohs(*s_file++);
-					  templong |= (temp << 16);
-                      status = fix_ft1000_write_dpram32 (ft1000dev, dpram++, (u8 *)&templong);
-
-               }
-               break;
-
-            case  REQUEST_CODE_BY_VERSION:
-               DEBUG("FT1000:download:REQUEST_CODE_BY_VERSION\n");
-               correct_version = FALSE;
-               requested_version = get_request_value(ft1000dev);
-
-                   dsp_img_info = (struct dsp_image_info *)(pFileStart + sizeof(struct dsp_file_hdr ));
-
-               for (image = 0; image < file_hdr->nDspImages; image++)
-               {
-                   if (dsp_img_info->version == requested_version)
-                       {
-                           correct_version = TRUE;
-                           DEBUG("FT1000:download: correct_version is TRUE\n");
-                           s_file = (u16 *)(pFileStart + dsp_img_info->begin_offset);
-                           c_file = (u8 *)(pFileStart + dsp_img_info->begin_offset);
-                           code_end = (u8 *)(pFileStart + dsp_img_info->end_offset);
-                           run_address = dsp_img_info->run_address;
-                           run_size = dsp_img_info->image_size;
-                           image_chksum = (u32)dsp_img_info->checksum;
-                           break;
-                        }
-                        dsp_img_info++;
-
-
-               } //end of for
-
-               if (!correct_version)
-               {
-                  /*
-                   * Error, beyond boot code range.
-                   */
-                  DEBUG("FT1000:download:Download error: Bad Version Request = 0x%x.\n",(int)requested_version);
-                  status = STATUS_FAILURE;
-                  break;
-               }
-               break;
-
-            default:
-               DEBUG("FT1000:download:Download error: Bad request type=%d in CODE download state.\n",request);
-               status = STATUS_FAILURE;
-               break;
-            }
-            if (pft1000info->usbboot)
-                put_handshake_usb(ft1000dev, HANDSHAKE_RESPONSE);
-            else
-                put_handshake(ft1000dev, HANDSHAKE_RESPONSE);
-         }
-         else
-         {
-            DEBUG("FT1000:download:Download error: Handshake failed\n");
-            status = STATUS_FAILURE;
-         }
-
-         break;
-
-      case STATE_DONE_DWNLD:
-         DEBUG("FT1000:download:Code loader is done...\n");
-         state = STATE_SECTION_PROV;
-         break;
-
-      case  STATE_SECTION_PROV:
-         DEBUG("FT1000:download:STATE_SECTION_PROV\n");
-		pseudo_header = (struct pseudo_hdr *)c_file;
-
-         if (pseudo_header->checksum == hdr_checksum(pseudo_header))
-         {
-            if (pseudo_header->portdest != 0x80 /* Dsp OAM */)
-            {
-               state = STATE_DONE_PROV;
-               break;
-            }
-            pseudo_header_len = ntohs(pseudo_header->length);    /* Byte length for PROV records */
-
-            // Get buffer for provisioning data
-		pbuffer = kmalloc((pseudo_header_len + sizeof(struct pseudo_hdr)), GFP_ATOMIC);
-            if (pbuffer) {
-		memcpy(pbuffer, (void *)c_file, (u32)(pseudo_header_len + sizeof(struct pseudo_hdr)));
-                // link provisioning data
-		pprov_record = kmalloc(sizeof(struct prov_record), GFP_ATOMIC);
-                if (pprov_record) {
-                    pprov_record->pprov_data = pbuffer;
-                    list_add_tail (&pprov_record->list, &pft1000info->prov_list);
-                    // Move to next entry if available
-			c_file = (u8 *)((unsigned long)c_file + (u32)((pseudo_header_len + 1) & 0xFFFFFFFE) + sizeof(struct pseudo_hdr));
-                    if ( (unsigned long)(c_file) - (unsigned long)(pFileStart) >= (unsigned long)FileLength) {
-                       state = STATE_DONE_FILE;
-                    }
-                }
-                else {
-                    kfree(pbuffer);
-                    status = STATUS_FAILURE;
-                }
-            }
-            else {
-                status = STATUS_FAILURE;
-            }
-         }
-         else
-         {
-            /* Checksum did not compute */
-            status = STATUS_FAILURE;
-         }
-         DEBUG("ft1000:download: after STATE_SECTION_PROV, state = %d, status= %d\n", state, status);
-         break;
-
-      case  STATE_DONE_PROV:
-         DEBUG("FT1000:download:STATE_DONE_PROV\n");
-         state = STATE_DONE_FILE;
-         break;
-
-
-      default:
-         status = STATUS_FAILURE;
-         break;
-      } /* End Switch */
-
-      if (status != STATUS_SUCCESS) {
-          break;
-      }
+					status =
+					    write_blk(ft1000dev, &s_file,
+						      &c_file, word_length);
+					//DEBUG("write_blk returned %d\n", status);
+					break;
+				default:
+					DEBUG
+					    ("FT1000:download:Download error: Bad request type=%d in BOOT download state.\n",
+					     request);
+					status = STATUS_FAILURE;
+					break;
+				}
+				if (pft1000info->usbboot)
+					put_handshake_usb(ft1000dev,
+							  HANDSHAKE_RESPONSE);
+				else
+					put_handshake(ft1000dev,
+						      HANDSHAKE_RESPONSE);
+			} else {
+				DEBUG
+				    ("FT1000:download:Download error: Handshake failed\n");
+				status = STATUS_FAILURE;
+			}
+
+			break;
+
+		case STATE_CODE_DWNLD:
+			//DEBUG("FT1000:STATE_CODE_DWNLD\n");
+			pft1000info->bootmode = 0;
+			if (pft1000info->usbboot)
+				handshake =
+				    get_handshake_usb(ft1000dev,
+						      HANDSHAKE_REQUEST);
+			else
+				handshake =
+				    get_handshake(ft1000dev, HANDSHAKE_REQUEST);
+			if (handshake == HANDSHAKE_REQUEST) {
+				/*
+				 * Get type associated with the request.
+				 */
+				if (pft1000info->usbboot)
+					request =
+					    get_request_type_usb(ft1000dev);
+				else
+					request = get_request_type(ft1000dev);
+				switch (request) {
+				case REQUEST_FILE_CHECKSUM:
+					DEBUG
+					    ("FT1000:download:image_chksum = 0x%8x\n",
+					     image_chksum);
+					put_request_value(ft1000dev,
+							  image_chksum);
+					break;
+				case REQUEST_RUN_ADDRESS:
+					DEBUG
+					    ("FT1000:download:  REQUEST_RUN_ADDRESS\n");
+					if (correct_version) {
+						DEBUG
+						    ("FT1000:download:run_address = 0x%8x\n",
+						     (int)run_address);
+						put_request_value(ft1000dev,
+								  run_address);
+					} else {
+						DEBUG
+						    ("FT1000:download:Download error: Got Run address request before image offset request.\n");
+						status = STATUS_FAILURE;
+						break;
+					}
+					break;
+				case REQUEST_CODE_LENGTH:
+					DEBUG
+					    ("FT1000:download:REQUEST_CODE_LENGTH\n");
+					if (correct_version) {
+						DEBUG
+						    ("FT1000:download:run_size = 0x%8x\n",
+						     (int)run_size);
+						put_request_value(ft1000dev,
+								  run_size);
+					} else {
+						DEBUG
+						    ("FT1000:download:Download error: Got Size request before image offset request.\n");
+						status = STATUS_FAILURE;
+						break;
+					}
+					break;
+				case REQUEST_DONE_CL:
+					pft1000info->usbboot = 3;
+					/* Reposition ptrs to beginning of provisioning section */
+					s_file =
+					    (u16 *) (pFileStart +
+						     file_hdr->commands_offset);
+					c_file =
+					    (u8 *) (pFileStart +
+						    file_hdr->commands_offset);
+					state = STATE_DONE_DWNLD;
+					break;
+				case REQUEST_CODE_SEGMENT:
+					//DEBUG("FT1000:download: REQUEST_CODE_SEGMENT - CODELOADER\n");
+					if (!correct_version) {
+						DEBUG
+						    ("FT1000:download:Download error: Got Code Segment request before image offset request.\n");
+						status = STATUS_FAILURE;
+						break;
+					}
+
+					word_length =
+					    get_request_value(ft1000dev);
+					//DEBUG("FT1000:download:word_length = %d\n", (int)word_length);
+					if (word_length > MAX_LENGTH) {
+						DEBUG
+						    ("FT1000:download:Download error: Max length exceeded\n");
+						status = STATUS_FAILURE;
+						break;
+					}
+					if ((word_length * 2 + c_file) >
+					    code_end) {
+						/*
+						 * Error, beyond boot code range.
+						 */
+						DEBUG
+						    ("FT1000:download:Download error: Requested len=%d exceeds DSP code boundry.\n",
+						     (int)word_length);
+						status = STATUS_FAILURE;
+						break;
+					}
+					/*
+					 * Position ASIC DPRAM auto-increment pointer.
+					 */
+					dpram = (u16) DWNLD_MAG1_PS_HDR_LOC;
+					if (word_length & 0x1)
+						word_length++;
+					word_length = word_length / 2;
+
+					write_blk_fifo(ft1000dev, &s_file,
+						       &c_file, word_length);
+					if (pft1000info->usbboot == 0)
+						pft1000info->usbboot++;
+					if (pft1000info->usbboot == 1) {
+						tempword = 0;
+						ft1000_write_dpram16(ft1000dev,
+								     DWNLD_MAG1_PS_HDR_LOC,
+								     tempword,
+								     0);
+					}
+
+					break;
+
+				case REQUEST_MAILBOX_DATA:
+					DEBUG
+					    ("FT1000:download: REQUEST_MAILBOX_DATA\n");
+					// Convert length from byte count to word count. Make sure we round up.
+					word_length =
+					    (long)(pft1000info->DSPInfoBlklen +
+						   1) / 2;
+					put_request_value(ft1000dev,
+							  word_length);
+					mailbox_data =
+					    (struct drv_msg *)&(pft1000info->
+								DSPInfoBlk[0]);
+					/*
+					 * Position ASIC DPRAM auto-increment pointer.
+					 */
+
+					data = (u16 *) & mailbox_data->data[0];
+					dpram = (u16) DWNLD_MAG1_PS_HDR_LOC;
+					if (word_length & 0x1)
+						word_length++;
+
+					word_length = (word_length / 2);
+
+					for (; word_length > 0; word_length--) {	/* In words */
+
+						templong = *data++;
+						templong |= (*data++ << 16);
+						status =
+						    fix_ft1000_write_dpram32
+						    (ft1000dev, dpram++,
+						     (u8 *) & templong);
+
+					}
+					break;
+
+				case REQUEST_VERSION_INFO:
+					DEBUG
+					    ("FT1000:download:REQUEST_VERSION_INFO\n");
+					word_length =
+					    file_hdr->version_data_size;
+					put_request_value(ft1000dev,
+							  word_length);
+					/*
+					 * Position ASIC DPRAM auto-increment pointer.
+					 */
+
+					s_file =
+					    (u16 *) (pFileStart +
+						     file_hdr->
+						     version_data_offset);
+
+					dpram = (u16) DWNLD_MAG1_PS_HDR_LOC;
+					if (word_length & 0x1)
+						word_length++;
+
+					word_length = (word_length / 2);
+
+					for (; word_length > 0; word_length--) {	/* In words */
+
+						templong = ntohs(*s_file++);
+						temp = ntohs(*s_file++);
+						templong |= (temp << 16);
+						status =
+						    fix_ft1000_write_dpram32
+						    (ft1000dev, dpram++,
+						     (u8 *) & templong);
+
+					}
+					break;
+
+				case REQUEST_CODE_BY_VERSION:
+					DEBUG
+					    ("FT1000:download:REQUEST_CODE_BY_VERSION\n");
+					correct_version = FALSE;
+					requested_version =
+					    get_request_value(ft1000dev);
+
+					dsp_img_info =
+					    (struct dsp_image_info *)(pFileStart
+								      +
+								      sizeof
+								      (struct
+								       dsp_file_hdr));
+
+					for (image = 0;
+					     image < file_hdr->nDspImages;
+					     image++) {
+						if (dsp_img_info->version ==
+						    requested_version) {
+							correct_version = TRUE;
+							DEBUG
+							    ("FT1000:download: correct_version is TRUE\n");
+							s_file =
+							    (u16 *) (pFileStart
+								     +
+								     dsp_img_info->
+								     begin_offset);
+							c_file =
+							    (u8 *) (pFileStart +
+								    dsp_img_info->
+								    begin_offset);
+							code_end =
+							    (u8 *) (pFileStart +
+								    dsp_img_info->
+								    end_offset);
+							run_address =
+							    dsp_img_info->
+							    run_address;
+							run_size =
+							    dsp_img_info->
+							    image_size;
+							image_chksum =
+							    (u32) dsp_img_info->
+							    checksum;
+							break;
+						}
+						dsp_img_info++;
+
+					}	//end of for
+
+					if (!correct_version) {
+						/*
+						 * Error, beyond boot code range.
+						 */
+						DEBUG
+						    ("FT1000:download:Download error: Bad Version Request = 0x%x.\n",
+						     (int)requested_version);
+						status = STATUS_FAILURE;
+						break;
+					}
+					break;
+
+				default:
+					DEBUG
+					    ("FT1000:download:Download error: Bad request type=%d in CODE download state.\n",
+					     request);
+					status = STATUS_FAILURE;
+					break;
+				}
+				if (pft1000info->usbboot)
+					put_handshake_usb(ft1000dev,
+							  HANDSHAKE_RESPONSE);
+				else
+					put_handshake(ft1000dev,
+						      HANDSHAKE_RESPONSE);
+			} else {
+				DEBUG
+				    ("FT1000:download:Download error: Handshake failed\n");
+				status = STATUS_FAILURE;
+			}
+
+			break;
+
+		case STATE_DONE_DWNLD:
+			DEBUG("FT1000:download:Code loader is done...\n");
+			state = STATE_SECTION_PROV;
+			break;
+
+		case STATE_SECTION_PROV:
+			DEBUG("FT1000:download:STATE_SECTION_PROV\n");
+			pseudo_header = (struct pseudo_hdr *)c_file;
+
+			if (pseudo_header->checksum ==
+			    hdr_checksum(pseudo_header)) {
+				if (pseudo_header->portdest !=
+				    0x80 /* Dsp OAM */ ) {
+					state = STATE_DONE_PROV;
+					break;
+				}
+				pseudo_header_len = ntohs(pseudo_header->length);	/* Byte length for PROV records */
+
+				// Get buffer for provisioning data
+				pbuffer =
+				    kmalloc((pseudo_header_len +
+					     sizeof(struct pseudo_hdr)),
+					    GFP_ATOMIC);
+				if (pbuffer) {
+					memcpy(pbuffer, (void *)c_file,
+					       (u32) (pseudo_header_len +
+						      sizeof(struct
+							     pseudo_hdr)));
+					// link provisioning data
+					pprov_record =
+					    kmalloc(sizeof(struct prov_record),
+						    GFP_ATOMIC);
+					if (pprov_record) {
+						pprov_record->pprov_data =
+						    pbuffer;
+						list_add_tail(&pprov_record->
+							      list,
+							      &pft1000info->
+							      prov_list);
+						// Move to next entry if available
+						c_file =
+						    (u8 *) ((unsigned long)
+							    c_file +
+							    (u32) ((pseudo_header_len + 1) & 0xFFFFFFFE) + sizeof(struct pseudo_hdr));
+						if ((unsigned long)(c_file) -
+						    (unsigned long)(pFileStart)
+						    >=
+						    (unsigned long)FileLength) {
+							state = STATE_DONE_FILE;
+						}
+					} else {
+						kfree(pbuffer);
+						status = STATUS_FAILURE;
+					}
+				} else {
+					status = STATUS_FAILURE;
+				}
+			} else {
+				/* Checksum did not compute */
+				status = STATUS_FAILURE;
+			}
+			DEBUG
+			    ("ft1000:download: after STATE_SECTION_PROV, state = %d, status= %d\n",
+			     state, status);
+			break;
+
+		case STATE_DONE_PROV:
+			DEBUG("FT1000:download:STATE_DONE_PROV\n");
+			state = STATE_DONE_FILE;
+			break;
+
+		default:
+			status = STATUS_FAILURE;
+			break;
+		}		/* End Switch */
+
+		if (status != STATUS_SUCCESS) {
+			break;
+		}
 
 /****
       // Check if Card is present
@@ -1147,11 +1230,12 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
       }
 ****/
 
-   } /* End while */
+	}			/* End while */
 
-   DEBUG("Download exiting with status = 0x%8x\n", status);
-   ft1000_write_register(ft1000dev, FT1000_DB_DNLD_TX, FT1000_REG_DOORBELL);
+	DEBUG("Download exiting with status = 0x%8x\n", status);
+	ft1000_write_register(ft1000dev, FT1000_DB_DNLD_TX,
+			      FT1000_REG_DOORBELL);
 
-   return status;
+	return status;
 }
 
-- 
1.7.1

