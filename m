Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab1DFWyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:54:10 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:59625
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756451Ab1DFWyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:54:03 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 10/22] Staging: hv: Simplify blkvsc_init_rw()
Date: Wed,  6 Apr 2011 16:05:10 -0700
Message-Id: <1302131122-15530-10-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302131122-15530-1-git-send-email-kys@microsoft.com>
References: <1302131006-15411-1-git-send-email-kys@microsoft.com>
 <1302131122-15530-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplyfify blkvsc_init_rw() by using a single scsi command independent of
the start sector.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   58 +++++++++------------------------------
 1 files changed, 13 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index b2cd04a..5cf82f0 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -305,53 +305,21 @@ static void blkvsc_init_rw(struct blkvsc_request *blkvsc_req)
 
 	blkvsc_req->cmd_len = 16;
 
-	if (blkvsc_req->sector_start > 0xffffffff) {
-		if (rq_data_dir(blkvsc_req->req)) {
-			blkvsc_req->write = 1;
-			blkvsc_req->cmnd[0] = WRITE_16;
-		} else {
-			blkvsc_req->write = 0;
-			blkvsc_req->cmnd[0] = READ_16;
-		}
-
-		blkvsc_req->cmnd[1] |=
-			(blkvsc_req->req->cmd_flags & REQ_FUA) ? 0x8 : 0;
-
-		*(unsigned long long *)&blkvsc_req->cmnd[2] =
-				cpu_to_be64(blkvsc_req->sector_start);
-		*(unsigned int *)&blkvsc_req->cmnd[10] =
-				cpu_to_be32(blkvsc_req->sector_count);
-	} else if ((blkvsc_req->sector_count > 0xff) ||
-		   (blkvsc_req->sector_start > 0x1fffff)) {
-		if (rq_data_dir(blkvsc_req->req)) {
-			blkvsc_req->write = 1;
-			blkvsc_req->cmnd[0] = WRITE_10;
-		} else {
-			blkvsc_req->write = 0;
-			blkvsc_req->cmnd[0] = READ_10;
-		}
-
-		blkvsc_req->cmnd[1] |=
-			(blkvsc_req->req->cmd_flags & REQ_FUA) ? 0x8 : 0;
-
-		*(unsigned int *)&blkvsc_req->cmnd[2] =
-				cpu_to_be32(blkvsc_req->sector_start);
-		*(unsigned short *)&blkvsc_req->cmnd[7] =
-				cpu_to_be16(blkvsc_req->sector_count);
+	if (rq_data_dir(blkvsc_req->req)) {
+		blkvsc_req->write = 1;
+		blkvsc_req->cmnd[0] = WRITE_16;
 	} else {
-		if (rq_data_dir(blkvsc_req->req)) {
-			blkvsc_req->write = 1;
-			blkvsc_req->cmnd[0] = WRITE_6;
-		} else {
-			blkvsc_req->write = 0;
-			blkvsc_req->cmnd[0] = READ_6;
-		}
-
-		*(unsigned int *)&blkvsc_req->cmnd[1] =
-				cpu_to_be32(blkvsc_req->sector_start) >> 8;
-		blkvsc_req->cmnd[1] &= 0x1f;
-		blkvsc_req->cmnd[4] = (unsigned char)blkvsc_req->sector_count;
+		blkvsc_req->write = 0;
+		blkvsc_req->cmnd[0] = READ_16;
 	}
+
+	blkvsc_req->cmnd[1] |=
+	(blkvsc_req->req->cmd_flags & REQ_FUA) ? 0x8 : 0;
+
+	*(unsigned long long *)&blkvsc_req->cmnd[2] =
+	cpu_to_be64(blkvsc_req->sector_start);
+	*(unsigned int *)&blkvsc_req->cmnd[10] =
+	cpu_to_be32(blkvsc_req->sector_count);
 }
 
 
-- 
1.7.4.1

