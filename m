Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2LRMdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 07:33:49 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:50583 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab2LRMda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 07:33:30 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gaowanlong@cn.fujitsu.com, hutao@cn.fujitsu.com,
        linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org,
        mst@redhat.com, rusty@rustcorp.com.au, asias@redhat.com,
        stefanha@redhat.com, nab@linux-iscsi.org
Subject: [PATCH v2 4/5] virtio-scsi: pass struct virtio_scsi to virtqueue completion function
Date: Tue, 18 Dec 2012 13:32:51 +0100
Message-Id: <1355833972-20319-5-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be needed soon in order to retrieve the per-target
struct.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 4a3abaf..4f6c6a3 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -104,7 +104,7 @@ static void virtscsi_compute_resid(struct scsi_cmnd *sc, u32 resid)
  *
  * Called with vq_lock held.
  */
-static void virtscsi_complete_cmd(void *buf)
+static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_cmd *cmd = buf;
 	struct scsi_cmnd *sc = cmd->sc;
@@ -165,7 +165,8 @@ static void virtscsi_complete_cmd(void *buf)
 	sc->scsi_done(sc);
 }
 
-static void virtscsi_vq_done(struct virtqueue *vq, void (*fn)(void *buf))
+static void virtscsi_vq_done(struct virtio_scsi *vscsi, struct virtqueue *vq,
+			     void (*fn)(struct virtio_scsi *vscsi, void *buf))
 {
 	void *buf;
 	unsigned int len;
@@ -173,7 +174,7 @@ static void virtscsi_vq_done(struct virtqueue *vq, void (*fn)(void *buf))
 	do {
 		virtqueue_disable_cb(vq);
 		while ((buf = virtqueue_get_buf(vq, &len)) != NULL)
-			fn(buf);
+			fn(vscsi, buf);
 	} while (!virtqueue_enable_cb(vq));
 }
 
@@ -184,11 +185,11 @@ static void virtscsi_req_done(struct virtqueue *vq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&vscsi->req_vq.vq_lock, flags);
-	virtscsi_vq_done(vq, virtscsi_complete_cmd);
+	virtscsi_vq_done(vscsi, vq, virtscsi_complete_cmd);
 	spin_unlock_irqrestore(&vscsi->req_vq.vq_lock, flags);
 };
 
-static void virtscsi_complete_free(void *buf)
+static void virtscsi_complete_free(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_cmd *cmd = buf;
 
@@ -205,7 +206,7 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&vscsi->ctrl_vq.vq_lock, flags);
-	virtscsi_vq_done(vq, virtscsi_complete_free);
+	virtscsi_vq_done(vscsi, vq, virtscsi_complete_free);
 	spin_unlock_irqrestore(&vscsi->ctrl_vq.vq_lock, flags);
 };
 
@@ -329,7 +330,7 @@ static void virtscsi_handle_event(struct work_struct *work)
 	virtscsi_kick_event(vscsi, event_node);
 }
 
-static void virtscsi_complete_event(void *buf)
+static void virtscsi_complete_event(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_event_node *event_node = buf;
 
@@ -344,7 +345,7 @@ static void virtscsi_event_done(struct virtqueue *vq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
-	virtscsi_vq_done(vq, virtscsi_complete_event);
+	virtscsi_vq_done(vscsi, vq, virtscsi_complete_event);
 	spin_unlock_irqrestore(&vscsi->event_vq.vq_lock, flags);
 };
 
-- 
1.7.1


