Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab0KDF1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 01:27:41 -0400
Received: from ns2.dvbank.ru ([195.137.171.2]:48112 "EHLO mx2.dvbank.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab0KDF1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 01:27:37 -0400
X-Greylist: delayed 1811 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2010 01:27:37 EDT
Message-ID: <4CD23D28.20707@dvbank.ru>
Date: Thu, 04 Nov 2010 14:57:12 +1000
From: Konstantin Katuev <katuev@dvbank.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11) Gecko/20101006 Thunderbird/3.1.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Greg KH <greg@kroah.com>
Subject: [PATCH v4] staging/keucr driver - uninitialized variable & proper
 memset length
References: <AANLkTi=oFai7Mh_VmzeV1TanF-dfmGs=KWOgj+03V2iH@mail.gmail.com> <20101103144545.GA3665@kroah.com>
In-Reply-To: <20101103144545.GA3665@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.2 (mail.dvbank.ru [192.168.1.100]); Thu, 04 Nov 2010 14:57:16 +1000 (VLD(+10))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resent patch from another address because of formatting problems.

There was commented out transfer_flags initialization.
And i think memset should fill entire structure, not only length of
pointer to it.
Driver now works.

Signed-off-by: Konstantin Katuev <katuev@dvbank.ru>

diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
index 1934805..978bf87 100644
--- a/drivers/staging/keucr/init.c
+++ b/drivers/staging/keucr/init.c
@@ -22,7 +22,7 @@ int ENE_InitMedia(struct us_data *us)
      int    result;
      BYTE    MiscReg03 = 0;

-    printk("--- Initial Nedia ---\n");
+    printk("--- Init Media ---\n");
      result = ENE_Read_BYTE(us, REG_CARD_STATUS, &MiscReg03);
      if (result != USB_STOR_XFER_GOOD)
      {
@@ -64,7 +64,7 @@ int ENE_Read_BYTE(struct us_data *us, WORD index, void 
*buf)
      struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
      int result;

-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength    = 0x01;
      bcb->Flags            = 0x80;
@@ -92,7 +92,7 @@ int ENE_SDInit(struct us_data *us)
          return USB_STOR_TRANSPORT_ERROR;
      }

-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->Flags = 0x80;
      bcb->CDB[0] = 0xF2;
@@ -112,7 +112,7 @@ int ENE_SDInit(struct us_data *us)
          return USB_STOR_TRANSPORT_ERROR;
      }

-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength    = 0x200;
      bcb->Flags            = 0x80;
@@ -161,7 +161,7 @@ int ENE_MSInit(struct us_data *us)
          return USB_STOR_TRANSPORT_ERROR;
      }

-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength    = 0x200;
      bcb->Flags            = 0x80;
@@ -219,7 +219,7 @@ int ENE_SMInit(struct us_data *us)
          return USB_STOR_TRANSPORT_ERROR;
      }

-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength    = 0x200;
      bcb->Flags            = 0x80;
@@ -341,7 +341,7 @@ int ENE_LoadBinCode(struct us_data *us, BYTE flag)
          break;
      }

-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength = 0x800;
      bcb->Flags =0x00;
@@ -433,7 +433,7 @@ int ENE_Read_Data(struct us_data *us, void *buf, 
unsigned int length)

      //printk("transport --- ENE_Read_Data\n");
      // set up the command wrapper
-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength = length;
      bcb->Flags =0x80;
@@ -470,7 +470,7 @@ int ENE_Write_Data(struct us_data *us, void *buf, 
unsigned int length)

      //printk("transport --- ENE_Write_Data\n");
      // set up the command wrapper
-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength = length;
      bcb->Flags =0x00;
diff --git a/drivers/staging/keucr/ms.c b/drivers/staging/keucr/ms.c
index d4340a9..9a3fdb4 100644
--- a/drivers/staging/keucr/ms.c
+++ b/drivers/staging/keucr/ms.c
@@ -15,7 +15,7 @@ int MS_ReaderCopyBlock(struct us_data *us, WORD 
oldphy, WORD newphy, WORD PhyBlo
      if (result != USB_STOR_XFER_GOOD)
          return USB_STOR_TRANSPORT_ERROR;

-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength = 0x200*len;
      bcb->Flags            = 0x00;
@@ -53,7 +53,7 @@ int MS_ReaderReadPage(struct us_data *us, DWORD 
PhyBlockAddr, BYTE PageNum, PDWO
          return USB_STOR_TRANSPORT_ERROR;

      // Read Page Data
-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength = 0x200;
      bcb->Flags            = 0x80;
@@ -69,7 +69,7 @@ int MS_ReaderReadPage(struct us_data *us, DWORD 
PhyBlockAddr, BYTE PageNum, PDWO
          return USB_STOR_TRANSPORT_ERROR;

      // Read Extra Data
-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength = 0x4;
      bcb->Flags            = 0x80;
@@ -108,7 +108,7 @@ int MS_ReaderEraseBlock(struct us_data *us, DWORD 
PhyBlockAddr)
      if (result != USB_STOR_XFER_GOOD)
          return USB_STOR_TRANSPORT_ERROR;

-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength = 0x200;
      bcb->Flags            = 0x80;
@@ -673,7 +673,7 @@ int MS_LibReadExtraBlock(struct us_data *us, DWORD 
PhyBlock, BYTE PageNum, BYTE
      //printk("MS_LibReadExtraBlock --- PhyBlock = %x, PageNum = %x, 
blen = %x\n", PhyBlock, PageNum, blen);

      // Read Extra Data
-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength = 0x4 * blen;
      bcb->Flags            = 0x80;
@@ -700,7 +700,7 @@ int MS_LibReadExtra(struct us_data *us, DWORD 
PhyBlock, BYTE PageNum, MS_LibType
      BYTE    ExtBuf[4];

      //printk("MS_LibReadExtra --- PhyBlock = %x, PageNum = %x\n", 
PhyBlock, PageNum);
-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength = 0x4;
      bcb->Flags            = 0x80;
@@ -807,7 +807,7 @@ int MS_LibOverwriteExtra(struct us_data *us, DWORD 
PhyBlockAddr, BYTE PageNum, B
      if (result != USB_STOR_XFER_GOOD)
          return USB_STOR_TRANSPORT_ERROR;

-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength = 0x4;
      bcb->Flags            = 0x80;
diff --git a/drivers/staging/keucr/msscsi.c b/drivers/staging/keucr/msscsi.c
index ad0c5c6..cb92d25 100644
--- a/drivers/staging/keucr/msscsi.c
+++ b/drivers/staging/keucr/msscsi.c
@@ -145,7 +145,7 @@ int MS_SCSI_Read(struct us_data *us, struct 
scsi_cmnd *srb)
          }

          // set up the command wrapper
-        memset(bcb, 0, sizeof(bcb));
+        memset(bcb, 0, sizeof(struct bulk_cb_wrap));
          bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
          bcb->DataTransferLength = blenByte;
          bcb->Flags  = 0x80;
@@ -193,7 +193,7 @@ int MS_SCSI_Read(struct us_data *us, struct 
scsi_cmnd *srb)
              blkno  = phyblk * 0x20 + PageNum;

              // set up the command wrapper
-            memset(bcb, 0, sizeof(bcb));
+            memset(bcb, 0, sizeof(struct bulk_cb_wrap));
              bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
              bcb->DataTransferLength = 0x200 * len;
              bcb->Flags  = 0x80;
@@ -250,7 +250,7 @@ int MS_SCSI_Write(struct us_data *us, struct 
scsi_cmnd *srb)
          }

          // set up the command wrapper
-        memset(bcb, 0, sizeof(bcb));
+        memset(bcb, 0, sizeof(struct bulk_cb_wrap));
          bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
          bcb->DataTransferLength = blenByte;
          bcb->Flags  = 0x00;
diff --git a/drivers/staging/keucr/sdscsi.c b/drivers/staging/keucr/sdscsi.c
index 6c332f8..d646507 100644
--- a/drivers/staging/keucr/sdscsi.c
+++ b/drivers/staging/keucr/sdscsi.c
@@ -152,7 +152,7 @@ int SD_SCSI_Read(struct us_data *us, struct 
scsi_cmnd *srb)
          bnByte = bn;

      // set up the command wrapper
-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength = blenByte;
      bcb->Flags  = 0x80;
@@ -192,7 +192,7 @@ int SD_SCSI_Write(struct us_data *us, struct 
scsi_cmnd *srb)
          bnByte = bn;

      // set up the command wrapper
-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength = blenByte;
      bcb->Flags  = 0x00;
diff --git a/drivers/staging/keucr/smilsub.c 
b/drivers/staging/keucr/smilsub.c
index 844b659..1b52535 100644
--- a/drivers/staging/keucr/smilsub.c
+++ b/drivers/staging/keucr/smilsub.c
@@ -266,7 +266,7 @@ int Ssfdc_D_ReadSect(struct us_data *us, BYTE 
*buf,BYTE *redundant)
      addr = addr*(WORD)Ssfdc.MaxSectors+Media.Sector;

      // Read sect data
-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength    = 0x200;
      bcb->Flags            = 0x80;
@@ -281,7 +281,7 @@ int Ssfdc_D_ReadSect(struct us_data *us, BYTE 
*buf,BYTE *redundant)
          return USB_STOR_TRANSPORT_ERROR;

      // Read redundant
-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength    = 0x10;
      bcb->Flags            = 0x80;
@@ -319,7 +319,7 @@ int Ssfdc_D_ReadBlock(struct us_data *us, WORD 
count, BYTE *buf,BYTE *redundant)
      addr = addr*(WORD)Ssfdc.MaxSectors+Media.Sector;

      // Read sect data
-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength    = 0x200*count;
      bcb->Flags            = 0x80;
@@ -334,7 +334,7 @@ int Ssfdc_D_ReadBlock(struct us_data *us, WORD 
count, BYTE *buf,BYTE *redundant)
          return USB_STOR_TRANSPORT_ERROR;

      // Read redundant
-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength    = 0x10;
      bcb->Flags            = 0x80;
@@ -536,7 +536,7 @@ int Ssfdc_D_CopyBlock(struct us_data *us, WORD 
count, BYTE *buf,BYTE *redundant)
      WriteAddr = WriteAddr*(WORD)Ssfdc.MaxSectors;

      // Write sect data
-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength    = 0x200*count;
      bcb->Flags            = 0x00;
@@ -754,7 +754,7 @@ int Ssfdc_D_WriteSectForCopy(struct us_data *us, 
BYTE *buf, BYTE *redundant)
      addr = addr*(WORD)Ssfdc.MaxSectors+Media.Sector;

      // Write sect data
-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength    = 0x200;
      bcb->Flags            = 0x00;
@@ -791,7 +791,7 @@ int Ssfdc_D_EraseBlock(struct us_data *us)
      addr=(WORD)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
      addr=addr*(WORD)Ssfdc.MaxSectors;

-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength    = 0x200;
      bcb->Flags            = 0x80;
@@ -827,7 +827,7 @@ int Ssfdc_D_ReadRedtData(struct us_data *us, BYTE 
*redundant)
      addr = (WORD)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
      addr = addr*(WORD)Ssfdc.MaxSectors+Media.Sector;

-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength    = 0x10;
      bcb->Flags            = 0x80;
@@ -870,7 +870,7 @@ int Ssfdc_D_WriteRedtData(struct us_data *us, BYTE 
*redundant)
      addr = (WORD)Media.Zone*Ssfdc.MaxBlocks+Media.PhyBlock;
      addr = addr*(WORD)Ssfdc.MaxSectors+Media.Sector;

-    memset(bcb, 0, sizeof(bcb));
+    memset(bcb, 0, sizeof(struct bulk_cb_wrap));
      bcb->Signature = cpu_to_le32(US_BULK_CB_SIGN);
      bcb->DataTransferLength    = 0x10;
      bcb->Flags            = 0x80;
diff --git a/drivers/staging/keucr/transport.c 
b/drivers/staging/keucr/transport.c
index 4697021..e3d3163 100644
--- a/drivers/staging/keucr/transport.c
+++ b/drivers/staging/keucr/transport.c
@@ -40,7 +40,7 @@ static int usb_stor_msg_common(struct us_data *us, int 
timeout)
      us->current_urb->error_count = 0;
      us->current_urb->status = 0;

-//    us->current_urb->transfer_flags = URB_NO_SETUP_DMA_MAP;
+    us->current_urb->transfer_flags = 0;
      if (us->current_urb->transfer_buffer == us->iobuf)
          us->current_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
      us->current_urb->transfer_dma = us->iobuf_dma;

