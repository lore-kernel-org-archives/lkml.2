Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab1DAGle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:41:34 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45590 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab1DAGlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:41:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=hWyaBmPasSyMT3QrlFpPurR0S+11WvnvIhdHUCuzq6uLR/ARI/WRZ/MKC6r8Z10avd
         n4XZrA9Ax3T+G0BT4C2nUOH3flBtj/pARuVH60sOqyOYz0JXyIIOY3tolfNqfdC922pD
         Ph/2dXmBCvurDGb8f6ZCOEp+FxcR0JQuH1Efo=
From: "Cho, Yu-Chen" <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, segooon@gmail.com, huajun.li.lee@gmail.com,
        kkatuev@gmail.com, devel@driverdev.osuosl.org, jlee@novell.com,
        acho@novell.com
Subject: [PATCH 3/5] staging/keucr: scsiglue use pr_<level> for messages
Date: Fri,  1 Apr 2011 14:38:41 +0800
Message-Id: <39c9fd8f54b4942e5106d310c1b0c3e0abc6a99a.1301638704.git.acho@novell.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1301638704.git.acho@novell.com>
References: <cover.1301638704.git.acho@novell.com>
In-Reply-To: <cover.1301638704.git.acho@novell.com>
References: <cover.1301638704.git.acho@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scsiglue.c use pr_<level> for messages

Signed-off-by: Cho, Yu-Chen <acho@novell.com>
---
 drivers/staging/keucr/scsiglue.c |   35 +++++++++++++++++++----------------
 1 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/keucr/scsiglue.c b/drivers/staging/keucr/scsiglue.c
index da4f42a..5e35d94 100644
--- a/drivers/staging/keucr/scsiglue.c
+++ b/drivers/staging/keucr/scsiglue.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
@@ -16,7 +18,7 @@
 //----- host_info() ---------------------
 static const char* host_info(struct Scsi_Host *host)
 {
-	//printk("scsiglue --- host_info\n");
+	/* pr_info("scsiglue --- host_info\n"); */
 	return "SCSI emulation for USB Mass Storage devices";
 }
 
@@ -25,7 +27,7 @@ static int slave_alloc(struct scsi_device *sdev)
 {
 	struct us_data *us = host_to_us(sdev->host);
 
-	//printk("scsiglue --- slave_alloc\n");
+	/* pr_info("scsiglue --- slave_alloc\n"); */
 	sdev->inquiry_len = 36;
 
 	blk_queue_update_dma_alignment(sdev->request_queue, (512 - 1));
@@ -41,7 +43,7 @@ static int slave_configure(struct scsi_device *sdev)
 {
 	struct us_data *us = host_to_us(sdev->host);
 
-	//printk("scsiglue --- slave_configure\n");
+	/* pr_info("scsiglue --- slave_configure\n"); */
 	if (us->fflags & (US_FL_MAX_SECTORS_64 | US_FL_MAX_SECTORS_MIN))
 	{
 		unsigned int max_sectors = 64;
@@ -91,19 +93,20 @@ static int queuecommand_lck(struct scsi_cmnd *srb, void (*done)(struct scsi_cmnd
 {
 	struct us_data *us = host_to_us(srb->device->host);
 
-	//printk("scsiglue --- queuecommand\n");
+	/* pr_info("scsiglue --- queuecommand\n"); */
 
 	/* check for state-transition errors */
 	if (us->srb != NULL)
 	{
-		printk("Error in %s: us->srb = %p\n", __FUNCTION__, us->srb);
+		/* pr_info("Error in %s: us->srb = %p\n"
+				 __FUNCTION__, us->srb); */
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
 	/* fail the command if we are disconnecting */
 	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags))
 	{
-		printk("Fail command during disconnect\n");
+		pr_info("Fail command during disconnect\n");
 		srb->result = DID_NO_CONNECT << 16;
 		done(srb);
 		return 0;
@@ -129,7 +132,7 @@ static int command_abort(struct scsi_cmnd *srb)
 {
 	struct us_data *us = host_to_us(srb->device->host);
 
-	//printk("scsiglue --- command_abort\n");
+	/* pr_info("scsiglue --- command_abort\n"); */
 
 	scsi_lock(us_to_host(us));
 	if (us->srb != srb)
@@ -159,7 +162,7 @@ static int device_reset(struct scsi_cmnd *srb)
 	struct us_data *us = host_to_us(srb->device->host);
 	int result;
 
-	//printk("scsiglue --- device_reset\n");
+	/* pr_info("scsiglue --- device_reset\n"); */
 
 	/* lock the device pointers and do the reset */
 	mutex_lock(&(us->dev_mutex));
@@ -175,7 +178,7 @@ static int bus_reset(struct scsi_cmnd *srb)
 	struct us_data *us = host_to_us(srb->device->host);
 	int result;
 
-	//printk("scsiglue --- bus_reset\n");
+	/* pr_info("scsiglue --- bus_reset\n"); */
 	result = usb_stor_port_reset(us);
 	return result < 0 ? FAILED : SUCCESS;
 }
@@ -186,7 +189,7 @@ void usb_stor_report_device_reset(struct us_data *us)
 	int i;
 	struct Scsi_Host *host = us_to_host(us);
 
-	//printk("scsiglue --- usb_stor_report_device_reset\n");
+	/* pr_info("scsiglue --- usb_stor_report_device_reset\n"); */
 	scsi_report_device_reset(host, 0, 0);
 	if (us->fflags & US_FL_SCM_MULT_TARG)
 	{
@@ -200,7 +203,7 @@ void usb_stor_report_bus_reset(struct us_data *us)
 {
 	struct Scsi_Host *host = us_to_host(us);
 
-	//printk("scsiglue --- usb_stor_report_bus_reset\n");
+	/* pr_info("scsiglue --- usb_stor_report_bus_reset\n"); */
 	scsi_lock(host);
 	scsi_report_bus_reset(host, 0);
 	scsi_unlock(host);
@@ -222,7 +225,7 @@ static int proc_info (struct Scsi_Host *host, char *buffer, char **start, off_t
 	char *pos = buffer;
 	const char *string;
 
-	//printk("scsiglue --- proc_info\n");
+	/* pr_info("scsiglue --- proc_info\n"); */
 	if (inout)
 		return length;
 
@@ -288,7 +291,7 @@ static ssize_t show_max_sectors(struct device *dev, struct device_attribute *att
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 
-	//printk("scsiglue --- ssize_t show_max_sectors\n");
+	/* pr_info("scsiglue --- ssize_t show_max_sectors\n"); */
 	return sprintf(buf, "%u\n", queue_max_sectors(sdev->request_queue));
 }
 
@@ -299,7 +302,7 @@ static ssize_t store_max_sectors(struct device *dev, struct device_attribute *at
 	struct scsi_device *sdev = to_scsi_device(dev);
 	unsigned short ms;
 
-	//printk("scsiglue --- ssize_t store_max_sectors\n");
+	/* pr_info("scsiglue --- ssize_t store_max_sectors\n"); */
 	if (sscanf(buf, "%hu", &ms) > 0 && ms <= SCSI_DEFAULT_MAX_SECTORS)
 	{
 		blk_queue_max_hw_sectors(sdev->request_queue, ms);
@@ -383,7 +386,7 @@ unsigned int usb_stor_access_xfer_buf(struct us_data *us, unsigned char *buffer,
 {
 	unsigned int cnt;
 
-	//printk("transport --- usb_stor_access_xfer_buf\n");
+	/* pr_info("transport --- usb_stor_access_xfer_buf\n"); */
 	struct scatterlist *sg = *sgptr;
 
 	if (!sg)
@@ -441,7 +444,7 @@ void usb_stor_set_xfer_buf(struct us_data *us, unsigned char *buffer, unsigned i
 	unsigned int offset = 0;
 	struct scatterlist *sg = NULL;
 
-	//printk("transport --- usb_stor_set_xfer_buf\n");
+	/* pr_info("transport --- usb_stor_set_xfer_buf\n"); */
 	// TO_XFER_BUF = 0, FROM_XFER_BUF = 1
 	buflen = min(buflen, scsi_bufflen(srb));
 	buflen = usb_stor_access_xfer_buf(us, buffer, buflen, srb, &sg, &offset, dir);
-- 
1.7.1

