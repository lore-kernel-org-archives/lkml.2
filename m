Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab2JBP0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:26:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48885 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab2JBP0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:26:12 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Subject: [PATCH 2/3] virtio-scsi: fix LUNs greater than 255
Date: Tue,  2 Oct 2012 17:25:47 +0200
Message-Id: <1349191548-7120-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1349191548-7120-1-git-send-email-pbonzini@redhat.com>
References: <1349191548-7120-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio-scsi needs to report LUNs greater than 256 using the "flat"
format.  Because the Linux SCSI layer just maps the SCSI LUN to
an u32, without any parsing, these end up in the range from 16640
to 32767.  Fix max_lun to account for the possibility that logical
unit numbers are encoded with the "flat" format.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 7554d78..a7cf726 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -677,7 +677,11 @@ static int __devinit virtscsi_probe(struct virtio_device *vdev)
 	cmd_per_lun = virtscsi_config_get(vdev, cmd_per_lun) ?: 1;
 	shost->cmd_per_lun = min_t(u32, cmd_per_lun, shost->can_queue);
 	shost->max_sectors = virtscsi_config_get(vdev, max_sectors) ?: 0xFFFF;
-	shost->max_lun = virtscsi_config_get(vdev, max_lun) + 1;
+
+	/* LUNs > 256 are reported with format 1, so they go in the range
+	 * 16640-32767.
+	 */
+	shost->max_lun = virtscsi_config_get(vdev, max_lun) + 1 + 0x4000;
 	shost->max_id = num_targets;
 	shost->max_channel = 0;
 	shost->max_cmd_len = VIRTIO_SCSI_CDB_SIZE;
-- 
1.7.1


