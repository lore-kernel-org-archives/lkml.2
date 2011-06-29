Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab1F2O0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:26:46 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42870
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756109Ab1F2OWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:55 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 38/40] Staging: hv: storvsc: Fixup srb_status for INQUIRY and MODE_SENSE
Date: Wed, 29 Jun 2011 07:39:35 -0700
Message-Id: <1309358377-8537-38-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current handler on the Windows Host does not correctly handle
INQUIRY and MODE_SENSE commands with some options. Fixup srb_status
in these cases since the failure is not fatal.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 42689d3..0785947 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -542,6 +542,18 @@ static void storvsc_on_io_completion(struct hv_device *device,
 
 	stor_pkt = &request->vstor_packet;
 
+	/*
+	 * The current SCSI handling on the host side does
+	 * not correctly handle:
+	 * INQUIRY command with page code parameter set to 0x80
+	 * MODE_SENSE command with cmd[2] == 0x1c
+	 *
+	 * Setup srb status so this won't be fatal.
+	 */
+
+	if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
+	   (stor_pkt->vm_srb.cdb[0] == MODE_SENSE))
+		vstor_packet->vm_srb.srb_status = 0;
 
 	/* Copy over the status...etc */
 	stor_pkt->vm_srb.scsi_status = vstor_packet->vm_srb.scsi_status;
-- 
1.7.4.1

