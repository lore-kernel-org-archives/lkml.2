Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab2KHJ4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:56:34 -0500
Received: from mail-lb0-f202.google.com ([209.85.217.202]:33359 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab2KHJ4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:56:32 -0500
From: Eric Northup <digitaleric@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Eric Northup <digitaleric@google.com>
Subject: [PATCH] virtio_scsi: fix memory leak on full queue condition.
Date: Thu,  8 Nov 2012 01:55:50 -0800
Message-Id: <1352368550-6694-1-git-send-email-digitaleric@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtscsi_queuecommand was leaking memory when the virtio queue was full.

Tested: Guest operates correctly even with very small queue sizes, validated
we're not leaking kmalloc-192 sized allocations anymore.

Signed-off-by: Eric Northup <digitaleric@google.com>
---
 drivers/scsi/virtio_scsi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 595af1a..dd8dc27 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -469,6 +469,8 @@ static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
 			      GFP_ATOMIC) >= 0)
 		ret = 0;
+	else
+		mempool_free(cmd, virtscsi_cmd_pool);
 
 out:
 	return ret;
-- 
1.7.7.3

