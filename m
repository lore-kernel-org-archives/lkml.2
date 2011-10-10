Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1JJIdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:33:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab1JJIdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:33:52 -0400
From: Dave Airlie <airlied@gmail.com>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH] vgaarb: a NULL bridge is acceptable for root devices.
Date: Mon, 10 Oct 2011 09:33:26 +0100
Message-Id: <1318235606-14346-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

I assumed all PCI buses had a bridge, but playing with qemu recently, I
discovered vgaarb bug where it wasn't detecting both devices shared a bridge
at the root level.

Don't check for NULL, if two buses have a NULL bridge, assume the share the
root bus.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/vga/vgaarb.c |   44 +++++++++++++++++++++-----------------------
 1 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index c72f1c0..bdde899 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -465,31 +465,29 @@ static void vga_arbiter_check_bridge_sharing(struct vga_device *vgadev)
 	while (new_bus) {
 		new_bridge = new_bus->self;
 
-		if (new_bridge) {
-			/* go through list of devices already registered */
-			list_for_each_entry(same_bridge_vgadev, &vga_list, list) {
-				bus = same_bridge_vgadev->pdev->bus;
-				bridge = bus->self;
-
-				/* see if the share a bridge with this device */
-				if (new_bridge == bridge) {
-					/* if their direct parent bridge is the same
-					   as any bridge of this device then it can't be used
-					   for that device */
-					same_bridge_vgadev->bridge_has_one_vga = false;
-				}
+		/* go through list of devices already registered */
+		list_for_each_entry(same_bridge_vgadev, &vga_list, list) {
+			bus = same_bridge_vgadev->pdev->bus;
+			bridge = bus->self;
+
+			/* see if the share a bridge with this device */
+			if (new_bridge == bridge) {
+				/* if their direct parent bridge is the same
+				   as any bridge of this device then it can't be used
+				   for that device */
+				same_bridge_vgadev->bridge_has_one_vga = false;
+			}
 
-				/* now iterate the previous devices bridge hierarchy */
-				/* if the new devices parent bridge is in the other devices
-				   hierarchy then we can't use it to control this device */
-				while (bus) {
-					bridge = bus->self;
-					if (bridge) {
-						if (bridge == vgadev->pdev->bus->self)
-							vgadev->bridge_has_one_vga = false;
-					}
-					bus = bus->parent;
+			/* now iterate the previous devices bridge hierarchy */
+			/* if the new devices parent bridge is in the other devices
+			   hierarchy then we can't use it to control this device */
+			while (bus) {
+				bridge = bus->self;
+				if (bridge) {
+					if (bridge == vgadev->pdev->bus->self)
+						vgadev->bridge_has_one_vga = false;
 				}
+				bus = bus->parent;
 			}
 		}
 		new_bus = new_bus->parent;
-- 
1.7.6

