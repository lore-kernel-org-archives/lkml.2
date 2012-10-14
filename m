Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab2JNOwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:52:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46662 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932276Ab2JNOnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:50 -0400
Message-Id: <20121014143540.649123968@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:23 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Martin Peschke <mpeschke@linux.vnet.ibm.com>,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 050/147] [SCSI] zfcp: only access zfcp_scsi_dev for valid scsi_device
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

commit d436de8ce25f53a8a880a931886821f632247943 upstream.

__scsi_remove_device (e.g. due to dev_loss_tmo) calls
zfcp_scsi_slave_destroy which in turn sends a close LUN FSF request to
the adapter. After 30 seconds without response,
zfcp_erp_timeout_handler kicks the ERP thread failing the close LUN
ERP action. zfcp_erp_wait in zfcp_erp_lun_shutdown_wait and thus
zfcp_scsi_slave_destroy returns and then scsi_device is no longer
valid. Sometime later the response to the close LUN FSF request may
finally come in. However, commit
b62a8d9b45b971a67a0f8413338c230e3117dff5
"[SCSI] zfcp: Use SCSI device data zfcp_scsi_dev instead of zfcp_unit"
introduced a number of attempts to unconditionally access struct
zfcp_scsi_dev through struct scsi_device causing a use-after-free.
This leads to an Oops due to kernel page fault in one of:
zfcp_fsf_abort_fcp_command_handler, zfcp_fsf_open_lun_handler,
zfcp_fsf_close_lun_handler, zfcp_fsf_req_trace,
zfcp_fsf_fcp_handler_common.
Move dereferencing of zfcp private data zfcp_scsi_dev allocated in
scsi_device via scsi_transport_reserve_device after the check for
potentially aborted FSF request and thus no longer valid scsi_device.
Only then assign sdev_to_zfcp(sdev) to the local auto variable struct
zfcp_scsi_dev *zfcp_sdev.

Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/s390/scsi/zfcp_fsf.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 9ffdc33..c96320d 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -801,12 +801,14 @@ out:
 static void zfcp_fsf_abort_fcp_command_handler(struct zfcp_fsf_req *req)
 {
 	struct scsi_device *sdev = req->data;
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_scsi_dev *zfcp_sdev;
 	union fsf_status_qual *fsq = &req->qtcb->header.fsf_status_qual;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		return;
 
+	zfcp_sdev = sdev_to_zfcp(sdev);
+
 	switch (req->qtcb->header.fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
 		if (fsq->word[0] == fsq->word[1]) {
@@ -1769,13 +1771,15 @@ static void zfcp_fsf_open_lun_handler(struct zfcp_fsf_req *req)
 {
 	struct zfcp_adapter *adapter = req->adapter;
 	struct scsi_device *sdev = req->data;
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_scsi_dev *zfcp_sdev;
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 	struct fsf_qtcb_bottom_support *bottom = &req->qtcb->bottom.support;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		return;
 
+	zfcp_sdev = sdev_to_zfcp(sdev);
+
 	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
 			  ZFCP_STATUS_COMMON_ACCESS_BOXED |
 			  ZFCP_STATUS_LUN_SHARED |
@@ -1886,11 +1890,13 @@ out:
 static void zfcp_fsf_close_lun_handler(struct zfcp_fsf_req *req)
 {
 	struct scsi_device *sdev = req->data;
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_scsi_dev *zfcp_sdev;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		return;
 
+	zfcp_sdev = sdev_to_zfcp(sdev);
+
 	switch (req->qtcb->header.fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
 		zfcp_erp_adapter_reopen(zfcp_sdev->port->adapter, 0, "fscuh_1");
@@ -1980,7 +1986,7 @@ static void zfcp_fsf_req_trace(struct zfcp_fsf_req *req, struct scsi_cmnd *scsi)
 {
 	struct fsf_qual_latency_info *lat_in;
 	struct latency_cont *lat = NULL;
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scsi->device);
+	struct zfcp_scsi_dev *zfcp_sdev;
 	struct zfcp_blk_drv_data blktrc;
 	int ticks = req->adapter->timer_ticks;
 
@@ -1995,6 +2001,7 @@ static void zfcp_fsf_req_trace(struct zfcp_fsf_req *req, struct scsi_cmnd *scsi)
 
 	if (req->adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA &&
 	    !(req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
+		zfcp_sdev = sdev_to_zfcp(scsi->device);
 		blktrc.flags |= ZFCP_BLK_LAT_VALID;
 		blktrc.channel_lat = lat_in->channel_lat * ticks;
 		blktrc.fabric_lat = lat_in->fabric_lat * ticks;
@@ -2032,12 +2039,14 @@ static void zfcp_fsf_fcp_handler_common(struct zfcp_fsf_req *req)
 {
 	struct scsi_cmnd *scmnd = req->data;
 	struct scsi_device *sdev = scmnd->device;
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_scsi_dev *zfcp_sdev;
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 
 	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ERROR))
 		return;
 
+	zfcp_sdev = sdev_to_zfcp(sdev);
+
 	switch (header->fsf_status) {
 	case FSF_HANDLE_MISMATCH:
 	case FSF_PORT_HANDLE_NOT_VALID:


