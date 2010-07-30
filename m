Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487Ab0G3Sry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:47:54 -0400
Received: from kroah.org ([198.145.64.141]:35768 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759320Ab0G3Req (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:46 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:07 2010
Message-Id: <20100730173107.774640361@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [056/140] drm/radeon/kms: fix shared ddc harder
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 42f14c4b454946650cf0bf66e0b631d02e328f61 upstream.

This fixes a regression caused by b2ea4aa67bfd084834edd070e0a4a47857d6db59
due to the way shared ddc with multiple digital connectors was handled.

You generally have two cases where DDC lines are shared:
- HDMI + VGA
- HDMI + DVI-D

HDMI + VGA is easy to deal with because you can check the EDID for the
to see if the attached monitor is digital.  A shared DDC line with two
digital connectors is more complex.  You can't use the hdmi bits in the
EDID since they may not be there with DVI<->HDMI adapters.  In this case
all we can do is check the HPD pins to see which is connected as we have
no way of knowing using the EDID.

Reported-by: trapdoor6@gmail.com
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -779,14 +779,14 @@ static enum drm_connector_status radeon_
 			} else
 				ret = connector_status_connected;
 
-			/* multiple connectors on the same encoder with the same ddc line
-			 * This tends to be HDMI and DVI on the same encoder with the
-			 * same ddc line.  If the edid says HDMI, consider the HDMI port
-			 * connected and the DVI port disconnected.  If the edid doesn't
-			 * say HDMI, vice versa.
+			/* This gets complicated.  We have boards with VGA + HDMI with a
+			 * shared DDC line and we have boards with DVI-D + HDMI with a shared
+			 * DDC line.  The latter is more complex because with DVI<->HDMI adapters
+			 * you don't really know what's connected to which port as both are digital.
 			 */
 			if (radeon_connector->shared_ddc && (ret == connector_status_connected)) {
 				struct drm_device *dev = connector->dev;
+				struct radeon_device *rdev = dev->dev_private;
 				struct drm_connector *list_connector;
 				struct radeon_connector *list_radeon_connector;
 				list_for_each_entry(list_connector, &dev->mode_config.connector_list, head) {
@@ -796,15 +796,10 @@ static enum drm_connector_status radeon_
 					if (list_radeon_connector->shared_ddc &&
 					    (list_radeon_connector->ddc_bus->rec.i2c_id ==
 					     radeon_connector->ddc_bus->rec.i2c_id)) {
-						if (drm_detect_hdmi_monitor(radeon_connector->edid)) {
-							if (connector->connector_type == DRM_MODE_CONNECTOR_DVID) {
-								kfree(radeon_connector->edid);
-								radeon_connector->edid = NULL;
-								ret = connector_status_disconnected;
-							}
-						} else {
-							if ((connector->connector_type == DRM_MODE_CONNECTOR_HDMIA) ||
-							    (connector->connector_type == DRM_MODE_CONNECTOR_HDMIB)) {
+						/* cases where both connectors are digital */
+						if (list_connector->connector_type != DRM_MODE_CONNECTOR_VGA) {
+							/* hpd is our only option in this case */
+							if (!radeon_hpd_sense(rdev, radeon_connector->hpd.hpd)) {
 								kfree(radeon_connector->edid);
 								radeon_connector->edid = NULL;
 								ret = connector_status_disconnected;


