Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab1F2OZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:25:48 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:51203
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756129Ab1F2OW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:56 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 39/40] Staging: hv: storvsc: In case of scsi errors offline the device
Date: Wed, 29 Jun 2011 07:39:36 -0700
Message-Id: <1309358377-8537-39-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we do get fatal errors from the host, offline the device since the
host has already tried all possible recovery actions.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 0785947..cc4b128 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1251,7 +1251,15 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
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

