Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab0DVT26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:28:58 -0400
Received: from kroah.org ([198.145.64.141]:41014 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab0DVT2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:52 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:16 2010
Message-Id: <20100422190916.584001910@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [103/197] drm/radeon/kms: fix tv dac conflict resolver
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 08d075116db3592db218bfe0f554cd93c9e12505 upstream.

On systems with the tv dac shared between DVI and TV,
we can only use the dac for one of the connectors.
However, when using a digital monitor on the DVI port,
you can use the dac for the TV connector just fine.
Check the use_digital status when resolving the conflict.

Fixes fdo bug 27649, possibly others.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_connectors.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -140,12 +140,14 @@ radeon_connector_analog_encoder_conflict
 {
 	struct drm_device *dev = connector->dev;
 	struct drm_connector *conflict;
+	struct radeon_connector *radeon_conflict;
 	int i;
 
 	list_for_each_entry(conflict, &dev->mode_config.connector_list, head) {
 		if (conflict == connector)
 			continue;
 
+		radeon_conflict = to_radeon_connector(conflict);
 		for (i = 0; i < DRM_CONNECTOR_MAX_ENCODER; i++) {
 			if (conflict->encoder_ids[i] == 0)
 				break;
@@ -155,6 +157,9 @@ radeon_connector_analog_encoder_conflict
 				if (conflict->status != connector_status_connected)
 					continue;
 
+				if (radeon_conflict->use_digital)
+					continue;
+
 				if (priority == true) {
 					DRM_INFO("1: conflicting encoders switching off %s\n", drm_get_connector_name(conflict));
 					DRM_INFO("in favor of %s\n", drm_get_connector_name(connector));


