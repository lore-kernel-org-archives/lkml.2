Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab1DFSOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 14:14:24 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:43283
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752918Ab1DFSOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 14:14:23 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/2] Staging: hv: Properly capture the error state
Date: Wed,  6 Apr 2011 11:25:38 -0700
Message-Id: <1302114339-2198-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302114286-2127-1-git-send-email-kys@microsoft.com>
References: <1302114286-2127-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly capture the error state after the completion of I/O. This fixes a bug
that was introduced in the patch-set titled:
Staging: hv: Cleanup-storage-drivers-phase-II.
A corrected version of this patch-set was sent out earlier, however
the earlier (buggy) version of this patch-set was already applied.
This patch fixes the problem.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 55865fa..d7ce393 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -279,6 +279,7 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 				  struct hv_storvsc_request *request)
 {
 	struct storvsc_device *stor_device;
+	struct vstor_packet *stor_pkt;
 
 	stor_device = must_get_stor_device(device);
 	if (!stor_device) {
@@ -287,19 +288,24 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 		return;
 	}
 
-	DPRINT_DBG(STORVSC, "IO_COMPLETE_OPERATION - request  %p "
+	DPRINT_DBG(STORVSC, "IO_COMPLETE_OPERATION - request %p "
 		   "completed bytes xfer %u", request,
 		   vstor_packet->vm_srb.data_transfer_length);
 
+	stor_pkt = &request->vstor_packet;
 
 
 	/* Copy over the status...etc */
+	stor_pkt->vm_srb.scsi_status = vstor_packet->vm_srb.scsi_status;
+	stor_pkt->vm_srb.srb_status = vstor_packet->vm_srb.srb_status;
+	stor_pkt->vm_srb.sense_info_length =
+	vstor_packet->vm_srb.sense_info_length;
 
 	if (vstor_packet->vm_srb.scsi_status != 0 ||
 		vstor_packet->vm_srb.srb_status != 1) {
 		DPRINT_WARN(STORVSC,
 			    "cmd 0x%x scsi status 0x%x srb status 0x%x\n",
-			    vstor_packet->vm_srb.cdb[0],
+			    stor_pkt->vm_srb.cdb[0],
 			    vstor_packet->vm_srb.scsi_status,
 			    vstor_packet->vm_srb.srb_status);
 	}
@@ -319,6 +325,8 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 		}
 	}
 
+	stor_pkt->vm_srb.data_transfer_length =
+	vstor_packet->vm_srb.data_transfer_length;
 
 	request->on_io_completion(request);
 
@@ -535,6 +543,7 @@ int stor_vsc_on_io_request(struct hv_device *device,
 
 	request->device  = device;
 
+
 	vstor_packet->flags |= REQUEST_COMPLETION_FLAG;
 
 	vstor_packet->vm_srb.length = sizeof(struct vmscsi_request);
-- 
1.7.4.1

