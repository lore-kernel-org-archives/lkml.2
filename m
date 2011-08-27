Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab1H0SLw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:11:52 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39841
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751496Ab1H0SLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:11 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 27/46] Staging: hv: storvsc: Fixup srb and scsi status for INQUIRY and MODE_SENSE
Date: Sat, 27 Aug 2011 11:31:26 -0700
Message-Id: <1314469905-7058-27-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current VHD handler on the Windows Host does not correctly handle
INQUIRY and MODE_SENSE commands with some options. Fixup srb_status
in these cases since the failure is not fatal.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 0bb4e0e..72ca25c 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -512,6 +512,23 @@ static void storvsc_on_io_completion(struct hv_device *device,
 
 	stor_pkt = &request->vstor_packet;
 
+	/*
+	 * The current SCSI handling on the host side does
+	 * not correctly handle:
+	 * INQUIRY command with page code parameter set to 0x80
+	 * MODE_SENSE command with cmd[2] == 0x1c
+	 *
+	 * Setup srb and scsi status so this won't be fatal.
+	 * We do this so we can distinguish truly fatal failues
+	 * (srb status == 0x4) and off-line the device in that case.
+	 */
+
+	if ((stor_pkt->vm_srb.cdb[0] == INQUIRY) ||
+		(stor_pkt->vm_srb.cdb[0] == MODE_SENSE)) {
+		vstor_packet->vm_srb.scsi_status = 0;
+		vstor_packet->vm_srb.srb_status = 0x1;
+	}
+
 
 	/* Copy over the status...etc */
 	stor_pkt->vm_srb.scsi_status = vstor_packet->vm_srb.scsi_status;
-- 
1.7.4.1

