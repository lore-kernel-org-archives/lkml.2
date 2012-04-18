Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab2DRNqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:46:14 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:64194 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2DRNqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:46:13 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org,
        Hu Tao <hutao@cn.fujitsu.com>
Subject: [PATCH for 3.4] virtio-scsi: fix TMF use-after-free
Date: Wed, 18 Apr 2012 15:46:01 +0200
Message-Id: <1334756761-12312-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a race in TMF path, where cmd may have been already freed
by virtscsi_complete_free after waking up from the completion.

Cc: James Bottomley <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index efccd72..1b38431 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -175,7 +175,8 @@ static void virtscsi_complete_free(void *buf)
 
 	if (cmd->comp)
 		complete_all(cmd->comp);
-	mempool_free(cmd, virtscsi_cmd_pool);
+	else
+		mempool_free(cmd, virtscsi_cmd_pool);
 }
 
 static void virtscsi_ctrl_done(struct virtqueue *vq)
@@ -311,21 +312,22 @@ out:
 static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 {
 	DECLARE_COMPLETION_ONSTACK(comp);
-	int ret;
+	int ret = FAILED;
 
 	cmd->comp = &comp;
-	ret = virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd,
-			       sizeof cmd->req.tmf, sizeof cmd->resp.tmf,
-			       GFP_NOIO);
-	if (ret < 0)
-		return FAILED;
+	if (virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd,
+			      sizeof cmd->req.tmf, sizeof cmd->resp.tmf,
+			      GFP_NOIO) < 0)
+		goto out;
 
 	wait_for_completion(&comp);
-	if (cmd->resp.tmf.response != VIRTIO_SCSI_S_OK &&
-	    cmd->resp.tmf.response != VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
-		return FAILED;
+	if (cmd->resp.tmf.response == VIRTIO_SCSI_S_OK ||
+	    cmd->resp.tmf.response == VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
+		ret = SUCCESS;
 
-	return SUCCESS;
+out:
+	mempool_free(cmd, virtscsi_cmd_pool);
+	return ret;
 }
 
 static int virtscsi_device_reset(struct scsi_cmnd *sc)
-- 
1.7.9.3

