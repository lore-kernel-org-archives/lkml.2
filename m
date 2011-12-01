Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab1LAOOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:14:35 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:51972
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754354Ab1LAOOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:14:34 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        James.Bottomley@HansenPartnership.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 3/5] Staging: hv: storvsc: Fix a bug in storvsc_command_completion()
Date: Thu,  1 Dec 2011 04:59:18 -0800
Message-Id: <1322744360-13067-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1322744360-13067-1-git-send-email-kys@microsoft.com>
References: <1322744315-13017-1-git-send-email-kys@microsoft.com>
 <1322744360-13067-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug in storvsc_command_completion() that leaks memory when scatter/gather
lists are used on the "write" side.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 14ecb69..8dafe52 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1123,13 +1123,12 @@ static void storvsc_command_completion(struct hv_storvsc_request *request)
 
 	vm_srb = &request->vstor_packet.vm_srb;
 	if (cmd_request->bounce_sgl_count) {
-		if (vm_srb->data_in == READ_TYPE) {
+		if (vm_srb->data_in == READ_TYPE)
 			copy_from_bounce_buffer(scsi_sglist(scmnd),
 					cmd_request->bounce_sgl,
 					scsi_sg_count(scmnd));
-			destroy_bounce_buffer(cmd_request->bounce_sgl,
+		destroy_bounce_buffer(cmd_request->bounce_sgl,
 					cmd_request->bounce_sgl_count);
-		}
 	}
 
 	/*
-- 
1.7.4.1

