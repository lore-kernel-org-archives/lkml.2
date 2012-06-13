Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab2FMO45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:56:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56209 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab2FMO4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:56:54 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 1/4] virtio-scsi: unlock during kick
Date: Wed, 13 Jun 2012 16:56:31 +0200
Message-Id: <1339599394-13880-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1339599394-13880-1-git-send-email-pbonzini@redhat.com>
References: <1339599394-13880-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate virtqueue_kick_prepare from virtqueue_notify, so that the
expensive vmexit is done without holding the lock.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 1b38431..b0ad5aa 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -264,9 +264,11 @@ static int virtscsi_kick_cmd(struct virtio_scsi *vscsi, struct virtqueue *vq,
 
 	ret = virtqueue_add_buf(vq, vscsi->sg, out_num, in_num, cmd, gfp);
 	if (ret >= 0)
-		virtqueue_kick(vq);
+		ret = virtqueue_kick_prepare(vq);
 
 	spin_unlock_irqrestore(&vscsi->vq_lock, flags);
+	if (ret > 0)
+		virtqueue_notify(vq);
 	return ret;
 }
 
-- 
1.7.1


