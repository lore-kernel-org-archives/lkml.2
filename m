Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab2GPQG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:06:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2GPQGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:06:09 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com
Subject: [PATCH 1/2] virtio-scsi: fix parsing of hotplug/hot-unplug LUN number
Date: Mon, 16 Jul 2012 18:05:50 +0200
Message-Id: <1342454751-8950-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342454751-8950-1-git-send-email-pbonzini@redhat.com>
References: <1342454751-8950-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hotplug/hot-unplug of a LUN whose number is greater than 255
uses the "flat" format for LUNs, which has bit 14 set.  Clear
the bit when parsing the event structs.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |    8 ++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index c7030fb..c937232 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -252,13 +252,19 @@ static void virtscsi_cancel_event_work(struct virtio_scsi *vscsi)
 		cancel_work_sync(&vscsi->event_list[i].work);
 }
 
+static unsigned int virtscsi_get_lun(u8 *lun_bytes)
+{
+	unsigned int lun = (lun_bytes[2] << 8) | lun_bytes[3];
+	return lun & 16383;
+}
+
 static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
 						struct virtio_scsi_event *event)
 {
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
 	unsigned int target = event->lun[1];
-	unsigned int lun = (event->lun[2] << 8) | event->lun[3];
+	unsigned int lun = virtscsi_get_lun(event->lun);
 
 	switch (event->reason) {
 	case VIRTIO_SCSI_EVT_RESET_RESCAN:
-- 
1.7.1


