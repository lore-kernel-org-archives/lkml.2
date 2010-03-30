Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab0C3Xpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:45:30 -0400
Received: from kroah.org ([198.145.64.141]:46086 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932539Ab0C3XUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:08 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:58 2010
Message-Id: <20100330224758.272422399@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Gal Rosen <galr@storwize.com>, James Smart <james.smart@emulex.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [058/156] SCSI: scsi_transport_fc: Fix synchronization issue while deleting vport
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Gal Rosen <galr@storwize.com>

commit 0d9dc7c8b9b7fa0f53647423b41056ee1beed735 upstream.

The issue occur while deleting 60 virtual ports through the sys
interface /sys/class/fc_vports/vport-X/vport_delete. It happen while in
a mistake each request sent twice for the same vport. This interface is
asynchronous, entering the delete request into a work queue, allowing
more than one request to enter to the delete work queue. The result is a
NULL pointer. The first request already delete the vport, while the
second request got a pointer to the vport before the device destroyed.
Re-create vport later cause system freeze.

Solution: Check vport flags before entering the request to the work queue.

[jejb: fixed int<->long problem on spinlock flags variable]
Signed-off-by: Gal Rosen <galr@storwize.com>
Acked-by: James Smart <james.smart@emulex.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_transport_fc.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1216,6 +1216,15 @@ store_fc_vport_delete(struct device *dev
 {
 	struct fc_vport *vport = transport_class_to_vport(dev);
 	struct Scsi_Host *shost = vport_to_shost(vport);
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING)) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		return -EBUSY;
+	}
+	vport->flags |= FC_VPORT_DELETING;
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	fc_queue_work(shost, &vport->vport_delete_work);
 	return count;
@@ -1805,6 +1814,9 @@ store_fc_host_vport_delete(struct device
 	list_for_each_entry(vport, &fc_host->vports, peers) {
 		if ((vport->channel == 0) &&
 		    (vport->port_name == wwpn) && (vport->node_name == wwnn)) {
+			if (vport->flags & (FC_VPORT_DEL | FC_VPORT_CREATING))
+				break;
+			vport->flags |= FC_VPORT_DELETING;
 			match = 1;
 			break;
 		}
@@ -3354,18 +3366,6 @@ fc_vport_terminate(struct fc_vport *vpor
 	unsigned long flags;
 	int stat;
 
-	spin_lock_irqsave(shost->host_lock, flags);
-	if (vport->flags & FC_VPORT_CREATING) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		return -EBUSY;
-	}
-	if (vport->flags & (FC_VPORT_DEL)) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		return -EALREADY;
-	}
-	vport->flags |= FC_VPORT_DELETING;
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
 	if (i->f->vport_delete)
 		stat = i->f->vport_delete(vport);
 	else


