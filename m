Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750904Ab2BOO7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:59:24 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:42328 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab2BOO7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:59:18 -0500
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Chris Boot <bootc@bootc.net>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH v2 2/3] firewire-sbp2: Ignore SBP-2 targets on the local node
Date: Wed, 15 Feb 2012 14:59:09 +0000
Message-Id: <1329317950-101579-3-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329317950-101579-1-git-send-email-bootc@bootc.net>
References: <1328881314-26544-1-git-send-email-bootc@bootc.net>
 <1329317950-101579-1-git-send-email-bootc@bootc.net>
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
Cc: Clemens Ladisch <clemens@ladisch.de>
---
 drivers/firewire/sbp2.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index a8f43d2..9e9631f 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1133,6 +1133,10 @@ static int sbp2_probe(struct device *dev)
 	struct Scsi_Host *shost;
 	u32 model, firmware_revision;
 
+	/* ignore targets on the local node */
+	if (device->is_local)
+		return -ENODEV;
+
 	if (dma_get_max_seg_size(device->card->device) > SBP2_MAX_SEG_SIZE)
 		BUG_ON(dma_set_max_seg_size(device->card->device,
 					    SBP2_MAX_SEG_SIZE));
-- 
1.7.9

