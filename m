Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab0C3Xfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:35:51 -0400
Received: from kroah.org ([198.145.64.141]:46423 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab0C3XVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:05 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:26 2010
Message-Id: <20100330224825.916895161@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Skeggs <bskeggs@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [099/156] drm/nouveau: report unknown connector state if lid closed
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit b30083bdb990bcc2829fce83d871a86059ff4fc1 upstream.

This is in preference to disconnected.  If there's no other outputs
connected this will cause LVDS to be programmed even with the lid
closed rather than having X fail to start because of no available
outputs.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -239,12 +239,14 @@ nouveau_connector_detect(struct drm_conn
 	if (connector->connector_type == DRM_MODE_CONNECTOR_LVDS)
 		nv_encoder = find_encoder_by_type(connector, OUTPUT_LVDS);
 	if (nv_encoder && nv_connector->native_mode) {
+		unsigned status = connector_status_connected;
+
 #ifdef CONFIG_ACPI
 		if (!nouveau_ignorelid && !acpi_lid_open())
-			return connector_status_disconnected;
+			status = connector_status_unknown;
 #endif
 		nouveau_connector_set_encoder(connector, nv_encoder);
-		return connector_status_connected;
+		return status;
 	}
 
 	/* Cleanup the previous EDID block. */


