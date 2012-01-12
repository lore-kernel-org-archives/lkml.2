Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2ALUfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:35:25 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35632
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755300Ab2ALUfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:35:22 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 04/15] Staging: hv: storvsc: Introduce defines for srb status codes
Date: Thu, 12 Jan 2012 12:37:57 -0800
Message-Id: <1326400688-13544-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1326400688-13544-1-git-send-email-kys@microsoft.com>
References: <1326400637-13494-1-git-send-email-kys@microsoft.com>
 <1326400688-13544-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce defines for srb status codes.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 71e50c3..979f25b 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -257,6 +257,16 @@ enum storvsc_request_type {
 	UNKNOWN_TYPE,
 };
 
+/*
+ * SRB status codes and masks; a subset of the codes used here.
+ */
+
+#define SRB_STATUS_AUTOSENSE_VALID	0x80
+#define SRB_STATUS_INVALID_LUN	0x20
+#define SRB_STATUS_SUCCESS	0x01
+#define SRB_STATUS_ERROR	0x04
+
+
 
 struct hv_storvsc_request {
 	struct hv_device *device;
@@ -561,7 +571,7 @@ static void storvsc_on_io_completion(struct hv_device *device,
 	if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
 		(stor_pkt->vm_srb.cdb[0] == MODE_SENSE)) {
 		vstor_packet->vm_srb.scsi_status = 0;
-		vstor_packet->vm_srb.srb_status = 0x1;
+		vstor_packet->vm_srb.srb_status = SRB_STATUS_SUCCESS;
 	}
 
 
@@ -572,7 +582,7 @@ static void storvsc_on_io_completion(struct hv_device *device,
 	vstor_packet->vm_srb.sense_info_length;
 
 	if (vstor_packet->vm_srb.scsi_status != 0 ||
-		vstor_packet->vm_srb.srb_status != 1){
+		vstor_packet->vm_srb.srb_status != SRB_STATUS_SUCCESS){
 		dev_warn(&device->device,
 			 "cmd 0x%x scsi status 0x%x srb status 0x%x\n",
 			 stor_pkt->vm_srb.cdb[0],
@@ -582,7 +592,8 @@ static void storvsc_on_io_completion(struct hv_device *device,
 
 	if ((vstor_packet->vm_srb.scsi_status & 0xFF) == 0x02) {
 		/* CHECK_CONDITION */
-		if (vstor_packet->vm_srb.srb_status & 0x80) {
+		if (vstor_packet->vm_srb.srb_status &
+			SRB_STATUS_AUTOSENSE_VALID) {
 			/* autosense data available */
 			dev_warn(&device->device,
 				 "stor pkt %p autosense data valid - len %d\n",
@@ -1191,7 +1202,7 @@ static void storvsc_command_completion(struct hv_storvsc_request *request)
 	 * error recovery strategies would have already been
 	 * deployed on the host side.
 	 */
-	if (vm_srb->srb_status == 0x4)
+	if (vm_srb->srb_status == SRB_STATUS_ERROR)
 		scmnd->result = DID_TARGET_FAILURE << 16;
 	else
 		scmnd->result = vm_srb->scsi_status;
@@ -1199,7 +1210,7 @@ static void storvsc_command_completion(struct hv_storvsc_request *request)
 	/*
 	 * If the LUN is invalid; remove the device.
 	 */
-	if (vm_srb->srb_status == 0x20) {
+	if (vm_srb->srb_status == SRB_STATUS_INVALID_LUN) {
 		struct storvsc_device *stor_dev;
 		struct hv_device *dev = host_dev->dev;
 		struct Scsi_Host *host;
-- 
1.7.4.1

