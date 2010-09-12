Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab0ILS4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:56:54 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41655 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab0ILS4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:56:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RT91SUpDMRYLHRP+lNZ/6GL//TY9mRNVt/mzxDNmMdG28W1WND60izxE2A0WLtxhNj
         4r7xHdNfHjlJlo87kMZx0gcTyByvHMIjVEBATUxnTPyc7HyaDXd0CYzLNWcf5nM4N9I/
         tHbAzJ4VmZ42/U5GCH+bhGRSdFUhq8f79CADs=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Al Cho <acho@novell.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: keucr: check kmalloc() return value
Date: Sun, 12 Sep 2010 22:56:43 +0400
Message-Id: <1284317808-4850-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc() may fail, if so return error code.
Also don't alloc 16 bytes from the heap, use stack instead.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/staging/keucr/init.c            |    2 +
 drivers/staging/keucr/msscsi.c          |    4 ++
 drivers/staging/keucr/smilsub.c         |    4 +--
 drivers/staging/keucr/smscsi.c          |    4 ++
 5 files changed, 71 insertions(+), 3 deletions(-)
 create mode 100644 drivers/staging/keucr/check-return.list

diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
index 2ae129b..1934805 100644
--- a/drivers/staging/keucr/init.c
+++ b/drivers/staging/keucr/init.c
@@ -300,6 +300,8 @@ int ENE_LoadBinCode(struct us_data *us, BYTE flag)
 		return USB_STOR_TRANSPORT_GOOD;
 
 	buf = kmalloc(0x800, GFP_KERNEL);
+	if (buf == NULL)
+		return USB_STOR_TRANSPORT_ERROR;
 	switch ( flag )
 	{
 		// For SD
diff --git a/drivers/staging/keucr/msscsi.c b/drivers/staging/keucr/msscsi.c
index b908a23..ad0c5c6 100644
--- a/drivers/staging/keucr/msscsi.c
+++ b/drivers/staging/keucr/msscsi.c
@@ -168,6 +168,8 @@ int MS_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 		DWORD	blkno;
 
 		buf = kmalloc(blenByte, GFP_KERNEL);
+		if (buf == NULL)
+			return USB_STOR_TRANSPORT_ERROR;
 
 		result = ENE_LoadBinCode(us, MS_RW_PATTERN);
 		if (result != USB_STOR_XFER_GOOD)
@@ -271,6 +273,8 @@ int MS_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 		WORD	len, oldphy, newphy;
 
 		buf = kmalloc(blenByte, GFP_KERNEL);
+		if (buf == NULL)
+			return USB_STOR_TRANSPORT_ERROR;
 		usb_stor_set_xfer_buf(us, buf, blenByte, srb, FROM_XFER_BUF);
 
 		result = ENE_LoadBinCode(us, MS_RW_PATTERN);
diff --git a/drivers/staging/keucr/smilsub.c b/drivers/staging/keucr/smilsub.c
index 844b659..293ea09 100644
--- a/drivers/staging/keucr/smilsub.c
+++ b/drivers/staging/keucr/smilsub.c
@@ -815,7 +815,7 @@ int Ssfdc_D_ReadRedtData(struct us_data *us, BYTE *redundant)
 	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
 	int	result;
 	WORD	addr;
-	BYTE  *buf;
+	BYTE buf[0x10];
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD)
@@ -839,11 +839,9 @@ int Ssfdc_D_ReadRedtData(struct us_data *us, BYTE *redundant)
 	bcb->CDB[8]			= 0;
 	bcb->CDB[9]			= 1;
 
-	buf = kmalloc(0x10, GFP_KERNEL);
 	//result = ENE_SendScsiCmd(us, FDIR_READ, redundant, 0);
 	result = ENE_SendScsiCmd(us, FDIR_READ, buf, 0);
 	memcpy(redundant, buf, 0x10);
-	kfree(buf);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
diff --git a/drivers/staging/keucr/smscsi.c b/drivers/staging/keucr/smscsi.c
index 43e32c6..6211686 100644
--- a/drivers/staging/keucr/smscsi.c
+++ b/drivers/staging/keucr/smscsi.c
@@ -145,6 +145,8 @@ int SM_SCSI_Read(struct us_data *us, struct scsi_cmnd *srb)
 		return USB_STOR_TRANSPORT_ERROR;
 
 	buf = kmalloc(blenByte, GFP_KERNEL);
+	if (buf == NULL)
+		return USB_STOR_TRANSPORT_ERROR;
 	result = Media_D_ReadSector(us, bn, blen, buf);
 	usb_stor_set_xfer_buf(us, buf, blenByte, srb, TO_XFER_BUF);
 	kfree(buf);
@@ -175,6 +177,8 @@ int SM_SCSI_Write(struct us_data *us, struct scsi_cmnd *srb)
 		return USB_STOR_TRANSPORT_ERROR;
 
 	buf = kmalloc(blenByte, GFP_KERNEL);
+	if (buf == NULL)
+		return USB_STOR_TRANSPORT_ERROR;
 	usb_stor_set_xfer_buf(us, buf, blenByte, srb, FROM_XFER_BUF);
 	result = Media_D_CopySector(us, bn, blen, buf);
 	kfree(buf);
-- 
1.7.0.4

