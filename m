Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1DENyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:54:00 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42413
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752887Ab1DENxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:53:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 08/22] Staging: hv: Get rid of the host field from struct hv_storvsc_request
Date: Tue,  5 Apr 2011 07:04:52 -0700
Message-Id: <1302012306-21277-8-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302012306-21277-1-git-send-email-kys@microsoft.com>
References: <1302012261-21236-1-git-send-email-kys@microsoft.com>
 <1302012306-21277-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for consolidating all I/O request state, get rid of the
host field from struct hv_storvsc_request and instead use the
equivalent  state in struct vmscsi_request - port_number field.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |    2 +-
 drivers/staging/hv/storvsc.c     |    1 -
 drivers/staging/hv/storvsc_api.h |    1 -
 drivers/staging/hv/storvsc_drv.c |    2 +-
 4 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 00bc226..eb184ff 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -941,7 +941,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 	storvsc_req->on_io_completion = request_completion;
 	storvsc_req->context = blkvsc_req;
 
-	storvsc_req->host = blkdev->port;
+	vm_srb->port_number = blkdev->port;
 	storvsc_req->bus = blkdev->path;
 	storvsc_req->target_id = blkdev->target;
 	storvsc_req->lun_id = 0;	 /* this is not really used at all */
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index c1faf46..21ca3db 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -550,7 +550,6 @@ int stor_vsc_on_io_request(struct hv_device *device,
 
 	vstor_packet->vm_srb.length = sizeof(struct vmscsi_request);
 
-	vstor_packet->vm_srb.port_number = request->host;
 	vstor_packet->vm_srb.path_id = request->bus;
 	vstor_packet->vm_srb.target_id = request->target_id;
 	vstor_packet->vm_srb.lun = request->lun_id;
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 27781f4..f9dc4f1 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -66,7 +66,6 @@ struct storvsc_request_extension {
 };
 
 struct hv_storvsc_request {
-	u32 host;
 	u32 bus;
 	u32 target_id;
 	u32 lun_id;
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 9df723c..e772822 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -774,7 +774,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	request->context = cmd_request;/* scmnd; */
 
 	/* request->PortId = scmnd->device->channel; */
-	request->host = host_device_ctx->port;
+	vm_srb->port_number = host_device_ctx->port;
 	request->bus = scmnd->device->channel;
 	request->target_id = scmnd->device->id;
 	request->lun_id = scmnd->device->lun;
-- 
1.7.4.1

