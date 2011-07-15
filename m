Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab1GORd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:33:29 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37393
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754253Ab1GORaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:11 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 108/117] Staging: hv: storvsc: In case of scsi errors offline the device
Date: Fri, 15 Jul 2011 10:47:36 -0700
Message-Id: <1310752065-27895-108-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we do get fatal errors from the host, offline the device since the
host has already tried all possible recovery actions.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 2d7bb41..8756cdf 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1187,7 +1187,15 @@ static void storvsc_command_completion(struct hv_storvsc_request *request)
 		}
 	}
 
-	scmnd->result = vm_srb->scsi_status;
+	/*
+	 * If there is an error; offline the device since all
+	 * error recovery strategies would have already been
+	 * deployed on the host side.
+	 */
+	if (vm_srb->srb_status == 0x4)
+		scmnd->result = DID_TARGET_FAILURE << 16;
+	else
+		scmnd->result = vm_srb->scsi_status;
 
 	if (scmnd->result) {
 		if (scsi_normalize_sense(scmnd->sense_buffer,
-- 
1.7.4.1

