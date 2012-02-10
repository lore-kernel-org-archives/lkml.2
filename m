Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab2BJNmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:42:49 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:46446 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759284Ab2BJNmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:42:35 -0500
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Chris Boot <bootc@bootc.net>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/3] firewire-sbp2: Ignore SBP-2 targets on the local node
Date: Fri, 10 Feb 2012 13:41:53 +0000
Message-Id: <1328881314-26544-3-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328881314-26544-1-git-send-email-bootc@bootc.net>
References: <EE1CAC85-DF0C-4C21-B2BD-446C481C938F@bootc.net>
 <1328881314-26544-1-git-send-email-bootc@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The firewire-sbp2 module tries to login to an SBP-2/3 target even when
it is running on the local node, which fails because of the inability to
fetch data from DMA mapped regions using firewire transactions on the
local node. It also doesn't make much sense to have the initiator and
target on the same node, so this patch prevents this behaviour.

Signed-off-by: Chris Boot <bootc@bootc.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/sbp2.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index ed5bbbf..1572a79 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1138,6 +1138,12 @@ static int sbp2_probe(struct device *dev)
 	struct Scsi_Host *shost;
 	u32 model, firmware_revision;
 
+	/* ignore targets on the local node */
+	if (device->node == device->card->local_node) {
+		dev_set_drvdata(&unit->device, NULL);
+		return 0;
+	}
+
 	if (dma_get_max_seg_size(device->card->device) > SBP2_MAX_SEG_SIZE)
 		BUG_ON(dma_set_max_seg_size(device->card->device,
 					    SBP2_MAX_SEG_SIZE));
@@ -1204,6 +1210,10 @@ static void sbp2_update(struct fw_unit *unit)
 	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
 	struct sbp2_logical_unit *lu;
 
+	/* no drvdata means a target on a local node; ignoring */
+	if (!tgt)
+		return;
+
 	fw_device_enable_phys_dma(fw_parent_device(unit));
 
 	/*
@@ -1223,10 +1233,15 @@ static int sbp2_remove(struct device *dev)
 	struct fw_device *device = fw_parent_device(unit);
 	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
 	struct sbp2_logical_unit *lu, *next;
-	struct Scsi_Host *shost =
-		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
+	struct Scsi_Host *shost;
 	struct scsi_device *sdev;
 
+	/* no drvdata means a target on a local node; ignoring */
+	if (!tgt)
+		return 0;
+
+	shost = container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
+
 	/* prevent deadlocks */
 	sbp2_unblock(tgt);
 
-- 
1.7.8.3

