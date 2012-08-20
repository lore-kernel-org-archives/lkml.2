Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab2HTPcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:32:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53970 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129Ab2HTPbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:31:19 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        Matthew Garrett <mjg59@srcf.ucam.org>, David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Andreas Heider <andreas@meetr.de>
Subject: [RFC PATCH 4/7] apple-gmux: Add switch_ddc support
Date: Mon, 20 Aug 2012 10:31:01 -0500
Message-Id: <1345476664-22066-5-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345476664-22066-1-git-send-email-seth.forshee@canonical.com>
References: <20120806045150.GA23652@thinkpad-t410>
 <1345476664-22066-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gmux allows muxing the DDC independently from the display, so
support this functionality. This will allow reading the EDID for the
inactive GPU, fixing issues with machines that either don't have a VBT
or have invalid mode data in the VBT.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/apple-gmux.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
index c72e81e..f702e90 100644
--- a/drivers/platform/x86/apple-gmux.c
+++ b/drivers/platform/x86/apple-gmux.c
@@ -269,14 +269,21 @@ static const struct backlight_ops gmux_bl_ops = {
 	.update_status = gmux_update_status,
 };
 
+static int gmux_switch_ddc(enum vga_switcheroo_client_id id)
+{
+	if (id == VGA_SWITCHEROO_IGD)
+		gmux_write8(apple_gmux_data, GMUX_PORT_SWITCH_DDC, 1);
+	else
+		gmux_write8(apple_gmux_data, GMUX_PORT_SWITCH_DDC, 2);
+	return 0;
+}
+
 static int gmux_switchto(enum vga_switcheroo_client_id id)
 {
 	if (id == VGA_SWITCHEROO_IGD) {
-		gmux_write8(apple_gmux_data, GMUX_PORT_SWITCH_DDC, 1);
 		gmux_write8(apple_gmux_data, GMUX_PORT_SWITCH_DISPLAY, 2);
 		gmux_write8(apple_gmux_data, GMUX_PORT_SWITCH_EXTERNAL, 2);
 	} else {
-		gmux_write8(apple_gmux_data, GMUX_PORT_SWITCH_DDC, 2);
 		gmux_write8(apple_gmux_data, GMUX_PORT_SWITCH_DISPLAY, 3);
 		gmux_write8(apple_gmux_data, GMUX_PORT_SWITCH_EXTERNAL, 3);
 	}
@@ -343,6 +350,7 @@ gmux_active_client(struct apple_gmux_data *gmux_data)
 }
 
 static struct vga_switcheroo_handler gmux_handler = {
+	.switch_ddc = gmux_switch_ddc,
 	.switchto = gmux_switchto,
 	.power_state = gmux_set_power_state,
 	.get_client_id = gmux_get_client_id,
-- 
1.7.9.5

