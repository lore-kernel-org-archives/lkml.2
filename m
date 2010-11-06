Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab0KFEq4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 00:46:56 -0400
Received: from web31805.mail.mud.yahoo.com ([68.142.207.68]:41951 "HELO
	web31805.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750985Ab0KFEqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 00:46:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=Pnx0MP7fcm34qlgsQc22PYQRrrDP2uXHLJiJ2v2bNGD9kzCMk4YN2BtO3qbGKwLyt40/52YTM6G8A5/0jqvqmh0/BiYo3Ckvx5WEbkkGKKNoP+2tCW/kEMd35D0dBC7c2c+J6uvpf6l8EWmcwclJwWKDTiF+u/QO5gamr8oAbhs=;
Message-ID: <130.74979.qm@web31805.mail.mud.yahoo.com>
X-YMail-OSG: WGQLz5YVM1nyeyIZgqe.YatTip8bsHfkLn9sDM5B_K44UVg
 BoIQ1BV.xx1rKvX48ku6c1lSVeu0MGzFhXzu8frGnqoHEtepGSHTCRHzx4yY
 O.eN18AytXJteI66YdcUExf3o9JfdlRJOwYhrzlHvKwmZIYZayvnCprdGH5G
 S1D0LeCUYVJbfDiu8LkPTYGCyZ8_4xjJLDJRRTdCrbO0tfsa2rvo27P432iq
 NVex_mFAL1Z0mPe9Sw8lrKJcI2Q4qoAwan.ImXaqBu6k71jAz21q_RyywaCt
 OEWRwPrHfgVsY.YJdwed4fd6DgbZDuHYrNK96zRjbhHkz88X5ZQI5MIQ8UVB
 Yei5wEys-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Fri, 5 Nov 2010 21:46:49 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: [PATCH] [USB] UAS: Achitecture; TMF; more
To: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * Fix sense IU layout

 * Command delivery to the service delivery subsystem should
   be an atomic transaction. Fix this in this driver by
   removing the work thread which retried allocating and
   sending urbs. First allocate the urbs we'll need up
   front; second recycle them (sense<-RRIU in High-Speed
   UAS); third if any operation with the SDS fails, report
   this to the application client.

 * Rename uas_dev_info->uas_tport_info to more correctly
   portray the capabilities of the target port. Decouple
   that from the sdev structure as it now has a uas_lu_info
   (new) which assists in TMF processing and error
   recovery. So now uas_cmd_info lives in scsi_cmd;
   uas_lu_info lives in scsi_device and uas_tport_info lives
   in scsi_host.

 * Redo uas_sense. Make it more general and print a more
   informative message if the sense data were short.

 * uas_xfer_data for High-Speed doesn't retry but fails if
   the SDS is down. This means that we cannot reach the
   target port, so we let error recovery kick in.

 * Add common urb initializers/fillers for the command and
   status pipe. This generalizes output transactions on the
   command pipe to always free the urb and the buffer, and
   input transactions on the status pipe to always have a
   buffer holding the max size of struct sense_iu and
   complete in the same place, uas_stat_cmplt, in order to
   accommodate both High-Speed devices and SuperSpeed
   (USB3.0) devices.

 * Gracefully free the urbs if the SDS is down or we have no
   memory for all urbs, at queuecommand entry.

 * Fix a shortcoming of SCSI Core where some commands coming
   into the driver are NOT tagged and some are tagged. The
   SDS (UAS) needs everything to be tagged and tagged
   correctly. Use tag 1 for untagged commands and tags 2 to
   FFEFh for tagged commands. In practice we use much less
   and target ports will report much less than that.

 * If the target port is SuperSpeed request a macro defined
   number of streams (128) for this I_T nexus. Target ports
   will report less. If usb_alloc_streams complains, we know
   we can handle at least one stream. Else if the port is
   High-Speed, set the number of tags we use to some sane
   value (32). Else the desired number of tags is set.

 * Implement TMF. All TMFs are supported. As we're not in
   control of the tags, nor can we, at the time of this
   commit, request a free tag from the block layer, we
   allocate tags for TMFs with range [130, 1153]
   (130+1024-1), as an increasing sequence.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---

This patch changes 86% of the driver. More is to come, but this is
a self-contained patch so it can be applied.

 drivers/usb/storage/uas.c |  970 ++++++++++++++++++++++++++++++---------------
 1 files changed, 656 insertions(+), 314 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index ef6e707..ed1a82f 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -4,6 +4,7 @@
  *
  * Copyright Matthew Wilcox for Intel Corp, 2010
  * Copyright Sarah Sharp for Intel Corp, 2010
+ * Copyright Luben Tuikov, 2010
  *
  * Distributed under the terms of the GNU GPL, version two.
  */
@@ -13,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/usb.h>
 #include <linux/usb/storage.h>
+#include <linux/completion.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
@@ -29,12 +31,18 @@
 #define UAS_DPRINTK(fmt, ...)
 #endif
 
+/* Define the number of streams to ask to allocate, essentially
+ * the maximum number of tags which we are asking to be able to send
+ * to the device.  Devices may report much less.
+ */
+#define UAS_MAX_STREAMS	128
+
 /* Common header for all IUs */
 struct iu {
 	__u8 iu_id;
 	__u8 rsvd1;
 	__be16 tag;
-};
+} __packed;
 
 enum {
 	IU_ID_COMMAND		= 0x01,
@@ -55,7 +63,7 @@ struct command_iu {
 	__u8 rsvd7;
 	struct scsi_lun lun;
 	__u8 cdb[16];	/* XXX: Overflow-checking tools may misunderstand */
-};
+} __packed;
 
 struct sense_iu {
 	__u8 iu_id;
@@ -63,11 +71,12 @@ struct sense_iu {
 	__be16 tag;
 	__be16 status_qual;
 	__u8 status;
-	__u8 service_response;
-	__u8 rsvd8[6];
+	__u8 rsvd8[7];
 	__be16 len;
 	__u8 sense[SCSI_SENSE_BUFFERSIZE];
-};
+} __packed;
+
+#define SENSE_IU_SIZE	sizeof(struct sense_iu)
 
 /*
  * The r00-r01c specs define this version of the SENSE IU data structure.
@@ -81,6 +90,56 @@ struct sense_iu_old {
 	__u8 status;
 	__u8 service_response;
 	__u8 sense[SCSI_SENSE_BUFFERSIZE];
+} __packed;
+
+struct tmf_iu {
+	__u8	iu_id;
+	__u8    rsvd1;
+	__be16	tag;
+	__u8	tmf;
+	__u8	rsvd5;
+	__u16	ttbm;
+	struct scsi_lun lun;
+} __packed;
+
+enum {
+	TMF_ABORT_TASK = 1,
+	TMF_ABORT_TASK_SET = 2,
+	TMF_CLEAR_TASK_SET = 4,
+	TMF_LU_RESET = 8,
+	TMF_IT_NEXUS_RESET = 0x10,
+	TMF_CLEAR_ACA = 0x40,
+	TMF_QUERY_TASK = 0x80,
+	TMF_QUERY_TASK_SET = 0x81,
+	TMF_QUERY_ASYNC_EVENT = 0x82,
+};
+
+struct resp_iu {
+	__u8	iu_id;
+	__u8    rsvd1;
+	__be16	tag;
+	__be32	resp;
+} __packed;
+
+#define TMR_RESPONSE_CODE_MASK	0xFF
+#define TMR_RESPONSE_CODE_SHIFT 0
+#define TMR_RESPONSE_INFO_MASK  0xFFFFFF00
+#define TMR_RESPONSE_INFO_SHIFT 8
+
+#define TMR_RESPONSE_CODE(__Val)					\
+	(((__Val) & TMR_RESPONSE_CODE_MASK) >> TMR_RESPONSE_CODE_SHIFT)
+
+#define TMR_RESPONSE_INFO(__Val)					\
+	(((__Val) & TMR_RESPONSE_INFO_MASK) >> TMR_RESPONSE_INFO_SHIFT)
+
+enum tmf_resp_code {
+	TMR_COMPLETE	= 0,
+	TMR_IIU		= 2,
+	TMR_UNSUPP	= 4,
+	TMR_FAILED	= 5,
+	TMR_SUCC	= 8,
+	TMR_ILUN	= 9,
+	TMR_OLAP	= 0xA,
 };
 
 enum {
@@ -95,89 +154,73 @@ enum {
 	UAS_ACA			= 4,
 };
 
-struct uas_dev_info {
+/* Lives in the SCSI host, hostdata points to it.
+ */
+struct uas_tport_info {
 	struct usb_interface *intf;
 	struct usb_device *udev;
-	int qdepth;
+	int num_tags;
 	unsigned cmd_pipe, status_pipe, data_in_pipe, data_out_pipe;
 	unsigned use_streams:1;
 	unsigned uas_sense_old:1;
 };
 
-enum {
-	ALLOC_STATUS_URB	= (1 << 0),
-	SUBMIT_STATUS_URB	= (1 << 1),
-	ALLOC_DATA_IN_URB	= (1 << 2),
-	SUBMIT_DATA_IN_URB	= (1 << 3),
-	ALLOC_DATA_OUT_URB	= (1 << 4),
-	SUBMIT_DATA_OUT_URB	= (1 << 5),
-	ALLOC_CMD_URB		= (1 << 6),
-	SUBMIT_CMD_URB		= (1 << 7),
+/* Lives in the scsi device, hostdata points to it.
+ */
+struct uas_lu_info {
+	struct completion tmf_completion;
+	struct resp_iu resp;
+	struct urb *freed_urb;
 };
 
-/* Overrides scsi_pointer */
+/* Lives in the scsi command, overrides SCp.
+ */
 struct uas_cmd_info {
-	unsigned int state;
-	unsigned int stream;
+	int tag;
 	struct urb *cmd_urb;
 	struct urb *status_urb;
 	struct urb *data_in_urb;
 	struct urb *data_out_urb;
-	struct list_head list;
 };
 
-static int uas_submit_urbs(struct scsi_cmnd *cmnd,
-				struct uas_dev_info *devinfo, gfp_t gfp);
+#define UAS_CMD_INFO(__Scmd) ((struct uas_cmd_info *)(&(__Scmd)->SCp))
+#define UAS_TPORT_INFO(__Scmd) \
+	((struct uas_tport_info *)((__Scmd)->device->host->hostdata[0]))
+#define SDEV_TPORT_INFO(__Sdev)  \
+	((struct uas_tport_info *)((__Sdev)->host->hostdata[0]))
 
-static DEFINE_SPINLOCK(uas_work_lock);
-static LIST_HEAD(uas_work_list);
+#define SDEV_LU_INFO(__Sdev) ((struct uas_lu_info *)((__Sdev)->hostdata))
 
-static void uas_do_work(struct work_struct *work)
-{
-	struct uas_cmd_info *cmdinfo;
-	struct list_head list;
-	int res;
-
-	spin_lock_irq(&uas_work_lock);
-	list_replace_init(&uas_work_list, &list);
-	spin_unlock_irq(&uas_work_lock);
-
-	list_for_each_entry(cmdinfo, &list, list) {
-		struct scsi_pointer *scp = (void *)cmdinfo;
-		struct scsi_cmnd *cmnd = container_of(scp,
-						      struct scsi_cmnd, SCp);
-		res = uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_KERNEL);
-		UAS_DPRINTK("%s: cmd:%p, res:%d, state:0x%x\n", __FUNCTION__,
-			    cmnd, res, cmdinfo->state);
-	}
-}
-
-static DECLARE_WORK(uas_work, uas_do_work);
+/* ---------- IU processors ---------- */
 
-static void uas_sense(struct urb *urb, struct scsi_cmnd *cmnd)
+static void uas_sense(struct urb *urb, struct scsi_cmnd *cmd)
 {
 	struct sense_iu *sense_iu = urb->transfer_buffer;
-	struct scsi_device *sdev = cmnd->device;
+	struct scsi_device *sdev = cmd->device;
+
+	cmd->result = sense_iu->status;
 
 	if (urb->actual_length > 16) {
-		unsigned len = be16_to_cpup(&sense_iu->len);
-		if (len + 16 != urb->actual_length) {
-			int newlen = min(len + 16, urb->actual_length) - 16;
-			if (newlen < 0)
-				newlen = 0;
-			sdev_printk(KERN_INFO, sdev, "%s: urb length %d "
-				"disagrees with IU sense data length %d, "
-				"using %d bytes of sense data\n", __func__,
-					urb->actual_length, len, newlen);
-			len = newlen;
+		unsigned slen = be16_to_cpup(&sense_iu->len);
+
+		if (urb->actual_length >= 16 + slen) {
+			slen = min(slen, (unsigned) SCSI_SENSE_BUFFERSIZE);
+		} else {
+			unsigned dlen = slen;
+
+			slen = min(urb->actual_length - 16,
+				   (unsigned) SCSI_SENSE_BUFFERSIZE);
+
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: short SENSE IU by %d bytes, "
+				    "using %d/%d bytes of sense data\n",
+				    __func__, 16 + slen - urb->actual_length,
+				    slen, dlen);
 		}
-		memcpy(cmnd->sense_buffer, sense_iu->sense, len);
+		memcpy(cmd->sense_buffer, sense_iu->sense, slen);
 	}
-
-	cmnd->result = sense_iu->status;
-	if (sdev->current_cmnd)
-		sdev->current_cmnd = NULL;
-	cmnd->scsi_done(cmnd);
+	sdev->current_cmnd = NULL;
+	cmd->scsi_done(cmd);
 	usb_free_urb(urb);
 }
 
@@ -200,73 +243,105 @@ static void uas_sense_old(struct urb *urb, struct scsi_cmnd *cmnd)
 		}
 		memcpy(cmnd->sense_buffer, sense_iu->sense, len);
 	}
-
 	cmnd->result = sense_iu->status;
-	if (sdev->current_cmnd)
-		sdev->current_cmnd = NULL;
+	sdev->current_cmnd = NULL;
 	cmnd->scsi_done(cmnd);
 	usb_free_urb(urb);
 }
 
-static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
-			  unsigned direction)
+/* Let High-Speed devices fail here instead of accommodating EAGAIN
+ * and racing with the error handler, if EAGAIN takes longer than the
+ * command completion timeout.  SuperSpeed devices never get here.
+ */
+static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmd,
+			  struct uas_tport_info *tpinfo,
+			  enum dma_data_direction dir, int tag)
 {
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
-	int err;
+	struct uas_cmd_info *cmdinfo = UAS_CMD_INFO(cmd);
+	int res = 0;
+
+	res = usb_submit_urb(urb, GFP_ATOMIC);
 
-	cmdinfo->state = direction | SUBMIT_STATUS_URB;
-	err = uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_ATOMIC);
-	UAS_DPRINTK("%s: cmd:%p, err:%d, state:0x%x\n", __FUNCTION__,
-		    cmnd, err, cmdinfo->state);
-	if (err) {
-		spin_lock(&uas_work_lock);
-		list_add_tail(&cmdinfo->list, &uas_work_list);
-		spin_unlock(&uas_work_lock);
-		schedule_work(&uas_work);
+	if (res == 0) {
+		if (dir == DMA_FROM_DEVICE)
+			res = usb_submit_urb(cmdinfo->data_in_urb, GFP_ATOMIC);
+		else
+			res = usb_submit_urb(cmdinfo->data_out_urb,GFP_ATOMIC);
 	}
+
+	UAS_DPRINTK("%s: cmd:%p res:%d tag:%d\n", __func__, cmd, res,
+		    cmdinfo->tag);
 }
 
+/**
+ * uas_stat_cmplt -- Status pipe urb completion
+ * @urb: the URB that completed
+ *
+ * Anything we expect to come back on the status pipe
+ * comes here.
+ */
 static void uas_stat_cmplt(struct urb *urb)
 {
 	struct iu *iu = urb->transfer_buffer;
 	struct scsi_device *sdev = urb->context;
-	struct uas_dev_info *devinfo = sdev->hostdata;
+	struct uas_tport_info *tpinfo = SDEV_TPORT_INFO(sdev);
 	struct scsi_cmnd *cmnd;
-	u16 tag;
+	int tag;
+
+	UAS_DPRINTK("%s: IU ID:%d tag:%d\n", __func__, iu->iu_id,
+		    be16_to_cpup(&iu->tag));
 
 	if (urb->status) {
 		dev_err(&urb->dev->dev, "%s: URB BAD STATUS %d\n",
-			__FUNCTION__, urb->status);
+			__func__, urb->status);
+		usb_free_urb(urb);
+		return;
+	}
+
+	if (iu->iu_id == IU_ID_RESPONSE) {
+		struct uas_lu_info *luinfo = SDEV_LU_INFO(sdev);
+
+		memcpy(&luinfo->resp, urb->transfer_buffer,
+		       sizeof(struct resp_iu));
+		complete(&luinfo->tmf_completion);
+		luinfo->freed_urb = urb;
 		usb_free_urb(urb);
 		return;
 	}
 
-	tag = be16_to_cpup(&iu->tag) - 1;
+	tag = be16_to_cpup(&iu->tag);
 	if (sdev->current_cmnd)
 		cmnd = sdev->current_cmnd;
 	else
-		cmnd = scsi_find_tag(sdev, tag);
-	if (!cmnd)
+		cmnd = scsi_find_tag(sdev, tag-2);
+
+	if (!cmnd) {
+		UAS_DPRINTK("%s: No command!?\n", __func__);
+		usb_free_urb(urb);
 		return;
+	}
 
 	switch (iu->iu_id) {
 	case IU_ID_STATUS:
-		if (urb->actual_length < 16)
-			devinfo->uas_sense_old = 1;
-		if (devinfo->uas_sense_old)
+		if (unlikely(urb->actual_length < 16))
+			tpinfo->uas_sense_old = 1;
+		if (unlikely(tpinfo->uas_sense_old))
 			uas_sense_old(urb, cmnd);
 		else
 			uas_sense(urb, cmnd);
 		break;
 	case IU_ID_READ_READY:
-		uas_xfer_data(urb, cmnd, SUBMIT_DATA_IN_URB);
+		uas_xfer_data(urb, cmnd, tpinfo, DMA_FROM_DEVICE, tag);
 		break;
 	case IU_ID_WRITE_READY:
-		uas_xfer_data(urb, cmnd, SUBMIT_DATA_OUT_URB);
+		uas_xfer_data(urb, cmnd, tpinfo, DMA_TO_DEVICE, tag);
 		break;
 	default:
 		scmd_printk(KERN_ERR, cmnd,
-			"Bogus IU (%d) received on status pipe\n", iu->iu_id);
+			    "Unknown IU ID %d received on the status pipe\n",
+			    iu->iu_id);
+		usb_free_urb(urb);
+		break;
 	}
 }
 
@@ -274,333 +349,594 @@ static void uas_data_cmplt(struct urb *urb)
 {
 	struct scsi_data_buffer *sdb = urb->context;
 
-	if (urb->status) {
+	if (!urb->status)
+		sdb->resid = sdb->length - urb->actual_length;
+	else
 		dev_err(&urb->dev->dev, "%s: URB BAD STATUS %d\n",
-			__FUNCTION__, urb->status);
-		usb_free_urb(urb);
-		return;
-	}
-	
-	sdb->resid = sdb->length - urb->actual_length;
+			__func__, urb->status);
+
 	usb_free_urb(urb);
 }
 
-static struct urb *uas_alloc_data_urb(struct uas_dev_info *devinfo, gfp_t gfp,
-				unsigned int pipe, u16 stream_id,
-				struct scsi_data_buffer *sdb,
-				enum dma_data_direction dir)
+/* ---------- URB allocators and submission ---------- */
+
+/**
+ * uas_fill_cmdp_urb -- Fill in a command pipe urb
+ * @urb: the urb
+ * @tpinfo: the UAS device info struct
+ * @transfer_buffer: the IU
+ * @buffer_length: the size of the IU
+ *
+ * A unified place to initialize a command pipe urb so that
+ * all command pipe urbs are freed in the same manner.
+ */
+static void uas_fill_cmdp_urb(struct urb *urb, struct uas_tport_info *tpinfo,
+			      void *transfer_buffer, int buffer_length)
+{
+	usb_fill_bulk_urb(urb, tpinfo->udev, tpinfo->cmd_pipe,
+			  transfer_buffer, buffer_length,
+			  usb_free_urb, NULL);
+	urb->transfer_flags |= URB_FREE_BUFFER;
+}
+
+/**
+ * uas_fill_statp_urb -- Fill in a status pipe urb
+ * @urb: the urb
+ * @dev: the scsi device
+ * @transfer_buffer: the transfer buffer of size SENSE_IU_SIZE
+ * @tag: the tag
+ *
+ * The callback is responsible to free/recycle the urb and the
+ * transfer buffer.
+ */
+static void uas_fill_statp_urb(struct urb *urb, struct scsi_device *sdev,
+			       void *transfer_buffer, int tag)
+{
+	struct uas_tport_info *tpinfo = SDEV_TPORT_INFO(sdev);
+
+	usb_fill_bulk_urb(urb, tpinfo->udev, tpinfo->status_pipe,
+			  transfer_buffer, SENSE_IU_SIZE,
+			  uas_stat_cmplt, sdev);
+	urb->transfer_flags |= URB_FREE_BUFFER;
+	if (tpinfo->use_streams)
+		urb->stream_id = tag;
+}
+
+static struct urb *uas_alloc_data_urb(struct uas_tport_info *tpinfo, gfp_t gfp,
+				      unsigned int data_pipe, u16 tag,
+				      struct scsi_data_buffer *sdb)
 {
-	struct usb_device *udev = devinfo->udev;
+	struct usb_device *udev = tpinfo->udev;
 	struct urb *urb = usb_alloc_urb(0, gfp);
 
 	if (!urb)
-		goto out;
-	usb_fill_bulk_urb(urb, udev, pipe, NULL, sdb->length, uas_data_cmplt,
-									sdb);
-	if (devinfo->use_streams)
-		urb->stream_id = stream_id;
+		goto Out;
+
+	usb_fill_bulk_urb(urb, udev, data_pipe, NULL, sdb->length,
+			  uas_data_cmplt, sdb);
+	if (tpinfo->use_streams)
+		urb->stream_id = tag;
 	urb->num_sgs = udev->bus->sg_tablesize ? sdb->table.nents : 0;
 	urb->sg = sdb->table.sgl;
- out:
+ Out:
 	return urb;
 }
 
-static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
-					struct scsi_cmnd *cmnd, u16 stream_id)
+static struct urb *uas_alloc_status_urb(struct scsi_cmnd *cmd, gfp_t gfp)
+					
 {
-	struct usb_device *udev = devinfo->udev;
-	struct urb *urb = usb_alloc_urb(0, gfp);
-	struct sense_iu *iu;
+	struct sense_iu *siu;
+	struct urb *urb;
 
+	urb = usb_alloc_urb(0, gfp);
 	if (!urb)
-		goto out;
+		return NULL;
 
-	iu = kzalloc(sizeof(*iu), gfp);
-	if (!iu)
-		goto free;
+	siu = kzalloc(SENSE_IU_SIZE, gfp);
+	if (!siu)
+		goto Out_free;
+
+	uas_fill_statp_urb(urb, cmd->device, siu, UAS_CMD_INFO(cmd)->tag);
 
-	usb_fill_bulk_urb(urb, udev, devinfo->status_pipe, iu, sizeof(*iu),
-						uas_stat_cmplt, cmnd->device);
-	urb->stream_id = stream_id;
-	urb->transfer_flags |= URB_FREE_BUFFER;
- out:
 	return urb;
- free:
+ Out_free:
 	usb_free_urb(urb);
 	return NULL;
 }
 
-static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
-					struct scsi_cmnd *cmnd, u16 stream_id)
+static struct urb *uas_alloc_cmd_urb(struct scsi_cmnd *cmd, gfp_t gfp)
 {
-	struct usb_device *udev = devinfo->udev;
-	struct scsi_device *sdev = cmnd->device;
+	struct uas_cmd_info *cmdinfo = UAS_CMD_INFO(cmd);
+	struct uas_tport_info *tpinfo = UAS_TPORT_INFO(cmd);
+	struct usb_device *udev = tpinfo->udev;
+	struct scsi_device *sdev = cmd->device;
 	struct urb *urb = usb_alloc_urb(0, gfp);
-	struct command_iu *iu;
+	struct command_iu *ciu;
 	int len;
 
 	if (!urb)
-		goto out;
+		return NULL;
 
-	len = cmnd->cmd_len - 16;
+	len = cmd->cmd_len - 16;
 	if (len < 0)
 		len = 0;
-	len = ALIGN(len, 4);
-	iu = kzalloc(sizeof(*iu) + len, gfp);
-	if (!iu)
+	else
+		len = ALIGN(len, 4);
+
+	ciu = kzalloc(sizeof(*ciu) + len, gfp);
+	if (!ciu)
 		goto free;
 
-	iu->iu_id = IU_ID_COMMAND;
-	iu->tag = cpu_to_be16(stream_id);
-	if (sdev->ordered_tags && (cmnd->request->cmd_flags & REQ_HARDBARRIER))
-		iu->prio_attr = UAS_ORDERED_TAG;
+	ciu->iu_id = IU_ID_COMMAND;
+	ciu->tag = cpu_to_be16(cmdinfo->tag);
+	if (sdev->ordered_tags && (cmd->request->cmd_flags & REQ_HARDBARRIER))
+		ciu->prio_attr = UAS_ORDERED_TAG;
 	else
-		iu->prio_attr = UAS_SIMPLE_TAG;
-	iu->len = len;
-	int_to_scsilun(sdev->lun, &iu->lun);
-	memcpy(iu->cdb, cmnd->cmnd, cmnd->cmd_len);
+		ciu->prio_attr = UAS_SIMPLE_TAG;
+	ciu->len = len;
+	int_to_scsilun(sdev->lun, &ciu->lun);
+	memcpy(ciu->cdb, cmd->cmnd, cmd->cmd_len);
 
-	usb_fill_bulk_urb(urb, udev, devinfo->cmd_pipe, iu, sizeof(*iu) + len,
+	usb_fill_bulk_urb(urb, udev, tpinfo->cmd_pipe, ciu, sizeof(*ciu) + len,
 			  usb_free_urb, NULL);
 	urb->transfer_flags |= URB_FREE_BUFFER;
- out:
 	return urb;
  free:
 	usb_free_urb(urb);
 	return NULL;
 }
 
-/*
- * Why should I request the Status IU before sending the Command IU?  Spec
- * says to, but also says the device may receive them in any order.  Seems
- * daft to me.
- */
-
-static int uas_submit_urbs(struct scsi_cmnd *cmnd,
-			   struct uas_dev_info *devinfo, gfp_t gfp)
+static int uas_alloc_urbs(struct scsi_cmnd *cmd, gfp_t gfp)
 {
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
-	int res;
+	struct uas_cmd_info *cmdinfo = UAS_CMD_INFO(cmd);
+	struct uas_tport_info *tpinfo = UAS_TPORT_INFO(cmd);
 
-	if (cmdinfo->state & ALLOC_STATUS_URB) {
-		cmdinfo->status_urb = uas_alloc_sense_urb(devinfo, gfp, cmnd,
-							  cmdinfo->stream);
-		if (!cmdinfo->status_urb)
-			return -ENOMEM;
-		cmdinfo->state &= ~ALLOC_STATUS_URB;
-	}
+	cmdinfo->status_urb = NULL;
+	cmdinfo->data_in_urb = NULL;
+	cmdinfo->data_out_urb = NULL;
+	cmdinfo->cmd_urb = NULL;
 
-	if (cmdinfo->state & SUBMIT_STATUS_URB) {
-		res = usb_submit_urb(cmdinfo->status_urb, gfp);
-		if (res) {
-			scmd_printk(KERN_INFO, cmnd,
-				    "sense urb submission failure (%d)\n",
-				    res);
-			return res;
+	cmdinfo->status_urb = uas_alloc_status_urb(cmd, gfp);
+	cmdinfo->cmd_urb = uas_alloc_cmd_urb(cmd, gfp);
+	if (!cmdinfo->cmd_urb || !cmdinfo->status_urb)
+		goto Out_err1;
+
+	switch (cmd->sc_data_direction) {
+	case DMA_BIDIRECTIONAL:
+	case DMA_TO_DEVICE:
+		cmdinfo->data_out_urb =
+			uas_alloc_data_urb(tpinfo, gfp,
+					   tpinfo->data_out_pipe,
+					   cmdinfo->tag,
+					   scsi_out(cmd));
+		if (!cmdinfo->data_out_urb)
+			goto Out_err2;
+		if (cmd->sc_data_direction != DMA_BIDIRECTIONAL)
+			break;
+		else {
+	case DMA_FROM_DEVICE:
+		cmdinfo->data_in_urb =
+			uas_alloc_data_urb(tpinfo, gfp,
+					   tpinfo->data_in_pipe,
+					   cmdinfo->tag,
+					   scsi_in(cmd));
+		if (!cmdinfo->data_in_urb)
+			goto Out_err2;
 		}
-		cmdinfo->state &= ~SUBMIT_STATUS_URB;
+		break;
+	case DMA_NONE:
+		break;
 	}
 
-	if (cmdinfo->state & ALLOC_DATA_IN_URB) {
-		cmdinfo->data_in_urb = uas_alloc_data_urb(devinfo, gfp,
-					devinfo->data_in_pipe, cmdinfo->stream,
-					scsi_in(cmnd), DMA_FROM_DEVICE);
-		if (!cmdinfo->data_in_urb)
-			return -ENOMEM;
-		cmdinfo->state &= ~ALLOC_DATA_IN_URB;
+	return 0;
+	
+ Out_err2:
+	usb_free_urb(cmdinfo->data_in_urb);
+	usb_free_urb(cmdinfo->data_out_urb);
+ Out_err1:
+	usb_free_urb(cmdinfo->cmd_urb);
+	return -ENOMEM;
+}
+
+static int uas_submit_urbs(struct scsi_cmnd *cmd, gfp_t gfp)
+{
+	struct uas_cmd_info *cmdinfo = UAS_CMD_INFO(cmd);
+	struct uas_tport_info *tpinfo = UAS_TPORT_INFO(cmd);
+	int res;
+
+	UAS_DPRINTK("%s: cmd:%p (0x%02x) tag:%d\n", __func__,
+		    cmd, cmd->cmnd[0], cmdinfo->tag);
+
+	res = usb_submit_urb(cmdinfo->status_urb, gfp);
+	if (res) {
+		scmd_printk(KERN_INFO, cmd,
+			    "sense urb submission failure (%d)\n", res);
+		return res;
 	}
 
-	if (cmdinfo->state & SUBMIT_DATA_IN_URB) {
+	if (cmdinfo->data_in_urb && tpinfo->use_streams) {
 		res = usb_submit_urb(cmdinfo->data_in_urb, gfp);
 		if (res) {
-			scmd_printk(KERN_INFO, cmnd,
+			scmd_printk(KERN_INFO, cmd,
 				    "data in urb submission failure (%d)\n",
 				    res);
 			return res;
 		}
-		cmdinfo->state &= ~SUBMIT_DATA_IN_URB;
 	}
 
-	if (cmdinfo->state & ALLOC_DATA_OUT_URB) {
-		cmdinfo->data_out_urb = uas_alloc_data_urb(devinfo, gfp,
-					devinfo->data_out_pipe, cmdinfo->stream,
-					scsi_out(cmnd), DMA_TO_DEVICE);
-		if (!cmdinfo->data_out_urb)
-			return -ENOMEM;
-		cmdinfo->state &= ~ALLOC_DATA_OUT_URB;
-	}
-
-	if (cmdinfo->state & SUBMIT_DATA_OUT_URB) {
+	if (cmdinfo->data_out_urb && tpinfo->use_streams) {
 		res = usb_submit_urb(cmdinfo->data_out_urb, gfp);
 		if (res) {
-			scmd_printk(KERN_INFO, cmnd,
+			scmd_printk(KERN_INFO, cmd,
 				    "data out urb submission failure (%d)\n",
 				    res);
 			return res;
 		}
-		cmdinfo->state &= ~SUBMIT_DATA_OUT_URB;
-	}
-
-	if (cmdinfo->state & ALLOC_CMD_URB) {
-		cmdinfo->cmd_urb = uas_alloc_cmd_urb(devinfo, gfp, cmnd,
-							cmdinfo->stream);
-		if (!cmdinfo->cmd_urb)
-			return -ENOMEM;
-		cmdinfo->state &= ~ALLOC_CMD_URB;
 	}
 
-	if (cmdinfo->state & SUBMIT_CMD_URB) {
-		res = usb_submit_urb(cmdinfo->cmd_urb, gfp);
-		if (res) {
-			scmd_printk(KERN_INFO, cmnd,
-				    "cmd urb submission failure (%d)\n", res);
-			return res;
-		}
-		cmdinfo->state &= ~SUBMIT_CMD_URB;
+	res = usb_submit_urb(cmdinfo->cmd_urb, gfp);
+	if (res) {
+		scmd_printk(KERN_INFO, cmd,
+			    "cmd urb submission failure (%d)\n", res);
+		return res;
 	}
 
 	return 0;
 }
 
-static int uas_queuecommand(struct scsi_cmnd *cmnd,
+static void uas_free_urbs(struct scsi_cmnd *cmd)
+{
+	struct uas_cmd_info *cmdinfo = UAS_CMD_INFO(cmd);
+	int res;
+
+	if (cmdinfo->cmd_urb) {
+		res = usb_unlink_urb(cmdinfo->cmd_urb);
+		if (res != -EINPROGRESS)
+			usb_free_urb(cmdinfo->cmd_urb);
+	}
+	if (cmdinfo->status_urb) {
+		res = usb_unlink_urb(cmdinfo->status_urb);
+		if (res != -EINPROGRESS)
+			usb_free_urb(cmdinfo->status_urb);
+	}
+	if (cmdinfo->data_in_urb) {
+		res = usb_unlink_urb(cmdinfo->data_in_urb);
+		if (res != -EINPROGRESS)
+			usb_free_urb(cmdinfo->data_in_urb);
+	}
+	if (cmdinfo->data_out_urb) {
+		res = usb_unlink_urb(cmdinfo->data_out_urb);
+		if (res != -EINPROGRESS)
+			usb_free_urb(cmdinfo->data_out_urb);
+	}
+}
+
+static int uas_queuecommand(struct scsi_cmnd *cmd,
 			    void (*done)(struct scsi_cmnd *))
 {
-	struct scsi_device *sdev = cmnd->device;
-	struct uas_dev_info *devinfo = sdev->hostdata;
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct scsi_device *sdev = cmd->device;
+	struct uas_cmd_info *cmdinfo = UAS_CMD_INFO(cmd);
 	int res;
 
 	BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));
 
-	if (!cmdinfo->status_urb && sdev->current_cmnd)
-		return SCSI_MLQUEUE_DEVICE_BUSY;
-
-	if (blk_rq_tagged(cmnd->request)) {
-		cmdinfo->stream = cmnd->request->tag + 1;
+	/* If LLDD are NOT to maintain their own tags, (but the block
+	 * layer would), THEN ANY AND ALL scsi_cmnds passed to the
+	 * queuecommand entry of a LLDD MUST HAVE A VALID,
+	 * REVERSE-MAPPABLE tag, REGARDLESS of where the command came
+	 * from, regardless of whether the device supports tags, and
+	 * regardless of how many tags it supports.
+	 */
+	if (blk_rq_tagged(cmd->request)) {
+		cmdinfo->tag = cmd->request->tag + 2;
+	} else if (sdev->current_cmnd == NULL) {
+		sdev->current_cmnd = cmd; /* Hilarious, isn't it?! */
+		cmdinfo->tag = 1;
 	} else {
-		sdev->current_cmnd = cmnd;
-		cmdinfo->stream = 1;
+		cmd->result = DID_ABORT << 16;
+		goto Out_err;
 	}
 
-	cmnd->scsi_done = done;
-
-	cmdinfo->state = ALLOC_STATUS_URB | SUBMIT_STATUS_URB |
-			ALLOC_CMD_URB | SUBMIT_CMD_URB;
+	cmd->scsi_done = done;
 
-	switch (cmnd->sc_data_direction) {
-	case DMA_FROM_DEVICE:
-		cmdinfo->state |= ALLOC_DATA_IN_URB | SUBMIT_DATA_IN_URB;
-		break;
-	case DMA_BIDIRECTIONAL:
-		cmdinfo->state |= ALLOC_DATA_IN_URB | SUBMIT_DATA_IN_URB;
-	case DMA_TO_DEVICE:
-		cmdinfo->state |= ALLOC_DATA_OUT_URB | SUBMIT_DATA_OUT_URB;
-	case DMA_NONE:
-		break;
+	res = uas_alloc_urbs(cmd, GFP_ATOMIC);
+	if (res) {
+		cmd->result = DID_ABORT << 16;
+		goto Out_err;
 	}
 
-	if (!devinfo->use_streams) {
-		cmdinfo->state &= ~(SUBMIT_DATA_IN_URB | SUBMIT_DATA_OUT_URB);
-		cmdinfo->stream = 0;
+	res = uas_submit_urbs(cmd, GFP_ATOMIC);
+	if (res) {
+		cmd->result = DID_NO_CONNECT << 16;
+		uas_free_urbs(cmd);
+		goto Out_err;
 	}
+	
+	UAS_DPRINTK("%s: cmd:%p (0x%02x) res:%d tag:%d\n",
+		    __func__, cmd, cmd->cmnd[0], res, cmdinfo->tag);
 
-	res = uas_submit_urbs(cmnd, devinfo, GFP_ATOMIC);
-	UAS_DPRINTK("%s: cmd:%p (0x%02x), err:%d, state:0x%x\n", __FUNCTION__,
-		    cmnd, cmnd->cmnd[0], res, cmdinfo->state);
-	if (res) {
-		usb_unlink_urb(cmdinfo->status_urb);
-		usb_unlink_urb(cmdinfo->data_in_urb);
-		usb_unlink_urb(cmdinfo->data_out_urb);
-		usb_unlink_urb(cmdinfo->cmd_urb);
+	return 0;
+ Out_err:
+	sdev->current_cmnd = NULL;
+	done(cmd);
+
+	return 0;
+}
 
-		sdev->current_cmnd = NULL;
+/* ---------- Error Recovery ---------- */
 
-		cmnd->result = DID_NO_CONNECT << 16;
-		done(cmnd);
-	}
+/* [1, UAS_MAX_STREAMS+1] belong to commands.
+ * [UAS_MAX_STREAMS+2, UAS_MAX_STREAMS+2+TMF_MAX_TAGS) belong to TMFs.
+ */
+#define TMF_TAG_FIRST 	(UAS_MAX_STREAMS + 2)
+#define TMF_MAX_TAGS	1024
+
+static int uas_get_tmf_tag(void)
+{
+	static int tmf_tag = 0;
+	int res;
+
+	/* [TMF_TAG_FIRST, TMF_MAX_TAGS + TMF_MAX_TAGS) */
+	res = tmf_tag + TMF_TAG_FIRST;
+
+	tmf_tag += 1;
+	tmf_tag %= TMF_MAX_TAGS; /* [0,TMF_MAX_TAGS) */
+
+	return res;
+}
+
+static int uas_alloc_tmf_urb(struct urb **urb, struct uas_tport_info *tpinfo,
+			     u8 tmf, u16 ttbm, struct scsi_lun *lun)
+{
+	struct tmf_iu *tmf_iu;
+	
+	*urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!*urb)
+		return -ENOMEM;
+	tmf_iu = kzalloc(sizeof(*tmf_iu), GFP_KERNEL);
+	if (!tmf_iu)
+		goto Out_err;
+
+	/* If LLDD are NOT to maintain their own tags, (but the block
+	 * layer would), THEN LLDDs must be able to call a function of
+	 * some sort and reserve a tag from the same pool and obtain
+	 * it for their own use, as well as being able to free it back
+	 * later.
+	 */
+	tmf_iu->iu_id = IU_ID_TASK_MGMT;
+	tmf_iu->tag = cpu_to_be16(uas_get_tmf_tag());
+	tmf_iu->tmf = tmf;
+	tmf_iu->ttbm = cpu_to_be16(ttbm);
+	tmf_iu->lun = *lun;
+
+	uas_fill_cmdp_urb(*urb, tpinfo, tmf_iu, sizeof(*tmf_iu));
 
 	return 0;
+ Out_err:
+	usb_free_urb(*urb);
+	return -ENOMEM;
 }
 
-static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
+static int uas_alloc_resp_urb(struct urb **urb, struct scsi_device *sdev,
+			      struct resp_iu *resp, int tag)
 {
-	struct scsi_device *sdev = cmnd->device;
-	sdev_printk(KERN_INFO, sdev, "%s tag %d\n", __func__,
-							cmnd->request->tag);
+	*urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!*urb)
+		return -ENOMEM;
 
-/* XXX: Send ABORT TASK Task Management command */
-	return FAILED;
+	uas_fill_statp_urb(*urb, sdev, resp, tag);
+
+	return 0;
 }
 
-static int uas_eh_device_reset_handler(struct scsi_cmnd *cmnd)
+#define UAS_TMF_TIMEOUT	(5*HZ)
+
+/**
+ * uas_do_tmf -- Execute the desired TMF
+ * @sdev: the device to which we should send the TMF
+ * @tmf:  the task management function to execute
+ * @ttbm: the tag of task to be managed
+ *
+ * This function returns a negative value on error (-ENOMEM, etc), or
+ * an integer with bytes 3, 2 and 1 being the high to low byte of the
+ * Additional Response Information field and byte 0 being the Response
+ * code of the Response IU.
+ * 
+ * If the response code is 0xFF, then the TMF timed out.
+ */
+static int uas_do_tmf(struct scsi_cmnd *cmd, u8 tmf, u8 ttbm)
 {
-	struct scsi_device *sdev = cmnd->device;
-	sdev_printk(KERN_INFO, sdev, "%s tag %d\n", __func__,
-							cmnd->request->tag);
+	struct scsi_device *sdev = cmd->device;
+	struct uas_tport_info *tpinfo = SDEV_TPORT_INFO(sdev);
+	struct uas_lu_info   *luinfo= SDEV_LU_INFO(sdev);
+	struct uas_cmd_info *cmdinfo = UAS_CMD_INFO(cmd);
+	struct urb *tmf_urb = NULL;
+	struct urb *resp_urb = NULL;
+	struct scsi_lun lun;
+	long   timeout;
+	int res;
 
-/* XXX: Send LOGICAL UNIT RESET Task Management command */
-	return FAILED;
+	/* scsi_dev should contain u8[8] for a LUN, not an unsigned int!
+	 */
+	int_to_scsilun(sdev->lun, &lun);
+	res = uas_alloc_tmf_urb(&tmf_urb, tpinfo, tmf, ttbm, &lun);
+	if (res)
+		return -ENOMEM;
+
+	/* If we're not using streams, we'll get the Response IU via
+	 * the sense urb we previosly submitted, so there is no need
+	 * to allocate a response urb.
+	 * If we're using streams, we need a response urb.
+	 * Or we need a response urb if we've previosly executed a TMF
+	 * which used up the sense urb as a response urb.
+	 */
+	if (tpinfo->use_streams || luinfo->freed_urb == cmdinfo->status_urb) {
+		struct tmf_iu *tmf_iu;
+		struct resp_iu *resp = NULL;
+
+		resp = kzalloc(SENSE_IU_SIZE, GFP_KERNEL);
+		if (!resp) {
+			usb_free_urb(tmf_urb);
+			return -ENOMEM;
+		}
+
+		tmf_iu = tmf_urb->transfer_buffer;
+		res = uas_alloc_resp_urb(&resp_urb, sdev, resp,
+					 be16_to_cpu(tmf_iu->tag));
+		if (res) {
+			usb_free_urb(tmf_urb);
+			kfree(resp);
+			return -ENOMEM;
+		}
+	}
+
+	/* Now submit them */
+
+	init_completion(&luinfo->tmf_completion);
+	luinfo->resp.resp = 0xFFFFFFFF;
+
+	if (tpinfo->use_streams || luinfo->freed_urb == cmdinfo->status_urb) {
+		res = usb_submit_urb(resp_urb, GFP_KERNEL);
+		if (res) {
+			complete(&luinfo->tmf_completion);
+			usb_free_urb(tmf_urb);
+			res = usb_unlink_urb(resp_urb);
+			if (res != -EINPROGRESS)
+				usb_free_urb(resp_urb);
+			return res;
+		}
+	}
+
+	res = usb_submit_urb(tmf_urb, GFP_KERNEL);
+	if (res) {
+		complete(&luinfo->tmf_completion);
+		res = usb_unlink_urb(tmf_urb);
+		if (res != -EINPROGRESS)
+			usb_free_urb(tmf_urb);
+		if (tpinfo->use_streams ||
+		    luinfo->freed_urb == cmdinfo->status_urb) {
+			res = usb_unlink_urb(resp_urb);
+			if (res != -EINPROGRESS)
+				usb_free_urb(resp_urb);
+			return res;
+		}
+	}
+
+	timeout = wait_for_completion_timeout(&luinfo->tmf_completion,
+					      UAS_TMF_TIMEOUT);
+	if (timeout && luinfo->resp.iu_id == IU_ID_RESPONSE &&
+	    be16_to_cpup(&luinfo->resp.tag) >= TMF_TAG_FIRST) {
+		res = be32_to_cpup(&luinfo->resp.resp);
+	} else {
+		res = 0xFF;
+	}
+	return res;
 }
 
-static int uas_eh_target_reset_handler(struct scsi_cmnd *cmnd)
+static int uas_er_tmf(struct scsi_cmnd *cmd, u8 tmf)
 {
-	struct scsi_device *sdev = cmnd->device;
-	sdev_printk(KERN_INFO, sdev, "%s tag %d\n", __func__,
-							cmnd->request->tag);
+	struct scsi_device *sdev = cmd->device;
+	int tag;
+	int res;
 
-/* XXX: Can we reset just the one USB interface?
- * Would calling usb_set_interface() have the right effect?
- */
-	return FAILED;
+	if (sdev->current_cmnd == cmd)
+		tag = 1;
+	else
+		tag = cmd->request->tag + 2;
+
+	res = uas_do_tmf(cmd, tmf, tag);
+
+	UAS_DPRINTK("%s: cmd:%p (0x%02x) tag:%d tmf:0x%02x resp:0x%08x\n",
+		    __func__, cmd, cmd->cmnd[0], tag, tmf, res);
+
+	switch (TMR_RESPONSE_CODE(res)) {
+	case TMR_COMPLETE:
+	case TMR_SUCC:
+		return SUCCESS;
+	default:
+		return FAILED;
+	}
 }
 
-static int uas_eh_bus_reset_handler(struct scsi_cmnd *cmnd)
+static int uas_eh_abort_handler(struct scsi_cmnd *cmd)
 {
-	struct scsi_device *sdev = cmnd->device;
-	struct uas_dev_info *devinfo = sdev->hostdata;
-	struct usb_device *udev = devinfo->udev;
+	return uas_er_tmf(cmd, TMF_ABORT_TASK);
+}
+
+static int uas_eh_device_reset_handler(struct scsi_cmnd *cmd)
+{
+	return uas_er_tmf(cmd, TMF_LU_RESET);
+}
 
-	sdev_printk(KERN_INFO, sdev, "%s tag %d\n", __func__,
-							cmnd->request->tag);
+static int uas_eh_target_reset_handler(struct scsi_cmnd *cmd)
+{
+	return uas_er_tmf(cmd, TMF_IT_NEXUS_RESET);
+}
+
+static int uas_eh_bus_reset_handler(struct scsi_cmnd *cmd)
+{
+	struct scsi_device *sdev = cmd->device;
+	struct uas_tport_info *tpinfo = SDEV_TPORT_INFO(sdev);
+	struct usb_device *udev = tpinfo->udev;
+	int res;
+
+	res = usb_reset_device(udev);
 
-	if (usb_reset_device(udev))
+	UAS_DPRINTK("%s: cmd:%p (0x%02x) res:0x%08x\n",
+		    __func__, cmd, cmd->cmnd[0], res);
+
+	if (res)
 		return SUCCESS;
 
 	return FAILED;
 }
 
+/* ---------- SCSI Host support ---------- */
+
 static int uas_slave_alloc(struct scsi_device *sdev)
 {
-	sdev->hostdata = (void *)sdev->host->hostdata[0];
+	sdev->hostdata = kzalloc(sizeof(struct uas_lu_info), GFP_KERNEL);
+	if (sdev->hostdata == NULL)
+		return -ENOMEM;
 	return 0;
 }
 
 static int uas_slave_configure(struct scsi_device *sdev)
 {
-	struct uas_dev_info *devinfo = sdev->hostdata;
+	struct uas_tport_info *tpinfo = SDEV_TPORT_INFO(sdev);
+
 	scsi_set_tag_type(sdev, MSG_ORDERED_TAG);
-	scsi_activate_tcq(sdev, devinfo->qdepth - 1);
+	scsi_activate_tcq(sdev, tpinfo->num_tags);
+
 	return 0;
 }
 
+static void uas_slave_destroy(struct scsi_device *sdev)
+{
+	kfree(sdev->hostdata);
+}
+
 static struct scsi_host_template uas_host_template = {
 	.module = THIS_MODULE,
 	.name = "uas",
 	.queuecommand = uas_queuecommand,
 	.slave_alloc = uas_slave_alloc,
 	.slave_configure = uas_slave_configure,
+	.slave_destroy = uas_slave_destroy,
 	.eh_abort_handler = uas_eh_abort_handler,
 	.eh_device_reset_handler = uas_eh_device_reset_handler,
 	.eh_target_reset_handler = uas_eh_target_reset_handler,
 	.eh_bus_reset_handler = uas_eh_bus_reset_handler,
-	.can_queue = 65536,	/* Is there a limit on the _host_ ? */
+	.can_queue = 0xFFEF,	  /* [1, 0xFFF0) */
 	.this_id = -1,
 	.sg_tablesize = SG_NONE,
-	.cmd_per_lun = 1,	/* until we override it */
+	.cmd_per_lun = 1,	  /* until we override it */
 	.skip_settle_delay = 1,
 	.ordered_tag = 1,
 };
 
+/* ---------- USB related ---------- */
+
 static struct usb_device_id uas_usb_ids[] = {
 	{ USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB_PR_BULK) },
 	{ USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB_PR_UAS) },
@@ -610,15 +946,15 @@ static struct usb_device_id uas_usb_ids[] = {
 };
 MODULE_DEVICE_TABLE(usb, uas_usb_ids);
 
-static void uas_configure_endpoints(struct uas_dev_info *devinfo)
+static void uas_configure_endpoints(struct uas_tport_info *tpinfo)
 {
 	struct usb_host_endpoint *eps[4] = { };
-	struct usb_interface *intf = devinfo->intf;
-	struct usb_device *udev = devinfo->udev;
+	struct usb_interface *intf = tpinfo->intf;
+	struct usb_device *udev = tpinfo->udev;
 	struct usb_host_endpoint *endpoint = intf->cur_altsetting->endpoint;
 	unsigned i, n_endpoints = intf->cur_altsetting->desc.bNumEndpoints;
 
-	devinfo->uas_sense_old = 0;
+	tpinfo->uas_sense_old = 0;
 
 	for (i = 0; i < n_endpoints; i++) {
 		unsigned char *extra = endpoint[i].extra;
@@ -641,32 +977,38 @@ static void uas_configure_endpoints(struct uas_dev_info *devinfo)
 	 * this.
 	 */
 	if (!eps[0]) {
-		devinfo->cmd_pipe = usb_sndbulkpipe(udev, 1);
-		devinfo->status_pipe = usb_rcvbulkpipe(udev, 1);
-		devinfo->data_in_pipe = usb_rcvbulkpipe(udev, 2);
-		devinfo->data_out_pipe = usb_sndbulkpipe(udev, 2);
-
-		eps[1] = usb_pipe_endpoint(udev, devinfo->status_pipe);
-		eps[2] = usb_pipe_endpoint(udev, devinfo->data_in_pipe);
-		eps[3] = usb_pipe_endpoint(udev, devinfo->data_out_pipe);
+		tpinfo->cmd_pipe = usb_sndbulkpipe(udev, 1);
+		tpinfo->status_pipe = usb_rcvbulkpipe(udev, 1);
+		tpinfo->data_in_pipe = usb_rcvbulkpipe(udev, 2);
+		tpinfo->data_out_pipe = usb_sndbulkpipe(udev, 2);
+
+		eps[1] = usb_pipe_endpoint(udev, tpinfo->status_pipe);
+		eps[2] = usb_pipe_endpoint(udev, tpinfo->data_in_pipe);
+		eps[3] = usb_pipe_endpoint(udev, tpinfo->data_out_pipe);
 	} else {
-		devinfo->cmd_pipe = usb_sndbulkpipe(udev,
+		tpinfo->cmd_pipe = usb_sndbulkpipe(udev,
 						eps[0]->desc.bEndpointAddress);
-		devinfo->status_pipe = usb_rcvbulkpipe(udev,
+		tpinfo->status_pipe = usb_rcvbulkpipe(udev,
 						eps[1]->desc.bEndpointAddress);
-		devinfo->data_in_pipe = usb_rcvbulkpipe(udev,
+		tpinfo->data_in_pipe = usb_rcvbulkpipe(udev,
 						eps[2]->desc.bEndpointAddress);
-		devinfo->data_out_pipe = usb_sndbulkpipe(udev,
+		tpinfo->data_out_pipe = usb_sndbulkpipe(udev,
 						eps[3]->desc.bEndpointAddress);
 	}
 
-	devinfo->qdepth = usb_alloc_streams(devinfo->intf, eps + 1, 3, 256,
-								GFP_KERNEL);
-	if (devinfo->qdepth < 0) {
-		devinfo->qdepth = 256;
-		devinfo->use_streams = 0;
+	if (udev->speed == USB_SPEED_SUPER) {
+		tpinfo->use_streams = 1;
+		tpinfo->num_tags = usb_alloc_streams(tpinfo->intf,
+						     eps + 1, 3,
+						     UAS_MAX_STREAMS,
+						     GFP_KERNEL);
+			
+		if (tpinfo->num_tags <= 0)
+			tpinfo->num_tags = 1;
 	} else {
-		devinfo->use_streams = 1;
+		/* Be conservative */
+		tpinfo->num_tags = 32;
+		tpinfo->use_streams = 0;
 	}
 }
 
@@ -680,7 +1022,7 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 	int result;
 	struct Scsi_Host *shost;
-	struct uas_dev_info *devinfo;
+	struct uas_tport_info *tpinfo;
 	struct usb_device *udev = interface_to_usbdev(intf);
 
 	if (id->bInterfaceProtocol == 0x50) {
@@ -691,8 +1033,8 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 			return -ENODEV;
 	}
 
-	devinfo = kzalloc(sizeof(struct uas_dev_info), GFP_KERNEL);
-	if (!devinfo)
+	tpinfo = kzalloc(sizeof(struct uas_tport_info), GFP_KERNEL);
+	if (!tpinfo)
 		return -ENOMEM;
 
 	result = -ENOMEM;
@@ -707,17 +1049,17 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	result = scsi_add_host(shost, &intf->dev);
 	if (result)
 		goto free;
-	shost->hostdata[0] = (unsigned long)devinfo;
+	shost->hostdata[0] = (unsigned long)tpinfo;
 
-	devinfo->intf = intf;
-	devinfo->udev = udev;
-	uas_configure_endpoints(devinfo);
+	tpinfo->intf = intf;
+	tpinfo->udev = udev;
+	uas_configure_endpoints(tpinfo);
 
 	scsi_scan_host(shost);
 	usb_set_intfdata(intf, shost);
 	return result;
  free:
-	kfree(devinfo);
+	kfree(tpinfo);
 	if (shost)
 		scsi_host_put(shost);
 	return result;
@@ -740,16 +1082,16 @@ static void uas_disconnect(struct usb_interface *intf)
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct usb_host_endpoint *eps[3];
 	struct Scsi_Host *shost = usb_get_intfdata(intf);
-	struct uas_dev_info *devinfo = (void *)shost->hostdata[0];
+	struct uas_tport_info *tpinfo = (void *)shost->hostdata[0];
 
 	scsi_remove_host(shost);
 
-	eps[0] = usb_pipe_endpoint(udev, devinfo->status_pipe);
-	eps[1] = usb_pipe_endpoint(udev, devinfo->data_in_pipe);
-	eps[2] = usb_pipe_endpoint(udev, devinfo->data_out_pipe);
+	eps[0] = usb_pipe_endpoint(udev, tpinfo->status_pipe);
+	eps[1] = usb_pipe_endpoint(udev, tpinfo->data_in_pipe);
+	eps[2] = usb_pipe_endpoint(udev, tpinfo->data_out_pipe);
 	usb_free_streams(intf, eps, 3, GFP_KERNEL);
 
-	kfree(devinfo);
+	kfree(tpinfo);
 }
 
 /*
-- 
1.7.0.1

