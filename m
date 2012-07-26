Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab2GZN2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 09:28:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34848 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2GZN2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 09:28:34 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, JBottomley@parallels.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 2/2] virtio-scsi: support online resizing of disks
Date: Thu, 26 Jul 2012 15:28:08 +0200
Message-Id: <1343309288-32615-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1343309288-32615-1-git-send-email-pbonzini@redhat.com>
References: <1343309288-32615-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support the LUN parameter change event.  Currently, the host fires this event
when the capacity of a disk is changed from the virtual machine monitor.
The resize then appears in the kernel log like this:

  sd 0:0:0:0: [sda] 46137344 512-byte logical blocks: (23.6 GB/22.0 GIb)
  sda: detected capacity change from 22548578304 to 23622320128

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c  |   31 ++++++++++++++++++++++++++++++-
 include/linux/virtio_scsi.h |    2 ++
 2 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 8b6b927..c1a5e60 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -279,6 +279,31 @@ static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
 	}
 }
 
+static void virtscsi_handle_param_change(struct virtio_scsi *vscsi,
+					 struct virtio_scsi_event *event)
+{
+	struct scsi_device *sdev;
+	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
+	unsigned int target = event->lun[1];
+	unsigned int lun = (event->lun[2] << 8) | event->lun[3];
+	u8 asc = event->reason & 255;
+	u8 ascq = event->reason >> 8;
+
+	sdev = scsi_device_lookup(shost, 0, target, lun);
+	if (!sdev) {
+		pr_err("SCSI device %d 0 %d %d not found\n",
+			shost->host_no, target, lun);
+		return;
+	}
+
+	/* Handle "Parameters changed", "Mode parameters changed", and
+	   "Capacity data has changed".  */
+	if (asc == 0x2a && (ascq == 0x00 || ascq == 0x01 || ascq == 0x09))
+		scsi_rescan_device(&sdev->sdev_gendev);
+
+	scsi_device_put(sdev);
+}
+
 static void virtscsi_handle_event(struct work_struct *work)
 {
 	struct virtio_scsi_event_node *event_node =
@@ -297,6 +322,9 @@ static void virtscsi_handle_event(struct work_struct *work)
 	case VIRTIO_SCSI_T_TRANSPORT_RESET:
 		virtscsi_handle_transport_reset(vscsi, event);
 		break;
+	case VIRTIO_SCSI_T_PARAM_CHANGE:
+		virtscsi_handle_param_change(vscsi, event);
+		break;
 	default:
 		pr_err("Unsupport virtio scsi event %x\n", event->event);
 	}
@@ -737,7 +765,8 @@ static struct virtio_device_id id_table[] = {
 };
 
 static unsigned int features[] = {
-	VIRTIO_SCSI_F_HOTPLUG
+	VIRTIO_SCSI_F_HOTPLUG,
+	VIRTIO_SCSI_F_CHANGE,
 };
 
 static struct virtio_driver virtio_scsi_driver = {
diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
index dc8d305..d6b4440 100644
--- a/include/linux/virtio_scsi.h
+++ b/include/linux/virtio_scsi.h
@@ -72,6 +72,7 @@ struct virtio_scsi_config {
 /* Feature Bits */
 #define VIRTIO_SCSI_F_INOUT                    0
 #define VIRTIO_SCSI_F_HOTPLUG                  1
+#define VIRTIO_SCSI_F_CHANGE                   2
 
 /* Response codes */
 #define VIRTIO_SCSI_S_OK                       0
@@ -108,6 +109,7 @@ struct virtio_scsi_config {
 #define VIRTIO_SCSI_T_NO_EVENT                 0
 #define VIRTIO_SCSI_T_TRANSPORT_RESET          1
 #define VIRTIO_SCSI_T_ASYNC_NOTIFY             2
+#define VIRTIO_SCSI_T_PARAM_CHANGE             3
 
 /* Reasons of transport reset event */
 #define VIRTIO_SCSI_EVT_RESET_HARD             0
-- 
1.7.1

