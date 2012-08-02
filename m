Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab2HBHV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 03:21:27 -0400
Received: from mailout10.t-online.de ([194.25.134.21]:32846 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab2HBHV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 03:21:26 -0400
Message-ID: <501A2A6F.4030502@t-online.de>
Date: Thu, 02 Aug 2012 09:21:19 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm: ignore disconnected <-> unknown status changes
Content-Type: multipart/mixed;
 boundary="------------090608040106050907050606"
X-ID: EXXWR-Z-ghfyJrw7WJGr6QexvVZOpDawtt+kIVgghe8AJ2ngOGxjISXNf85w48cQ2p
X-TOI-MSGID: 952ebd05-d27a-4f1c-b720-c9a97f5b3c44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090608040106050907050606
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On an AOpen i915GMm-hfs the hotplug events generated
by transitions between connector_status_unknown and
connector_status_disconnected cause screen distortions.

The attached patch cures the problem by disabling the
generation of hotplug events in those cases. That should
be safe for everybody as the only relevant changes are
those from / to connector_status_connected.

cu,
  Knut

--------------090608040106050907050606
Content-Type: text/x-patch;
 name="0001-drm-ignore-disconnected-unknown-status-changes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-drm-ignore-disconnected-unknown-status-changes.patch"

>From f631128c46f916eb58bbdabf867248a04a0d2fc5 Mon Sep 17 00:00:00 2001
From: Knut Petersen <Knut_Petersen@t-online.de>
Date: Thu, 2 Aug 2012 08:52:04 +0200
Subject: [PATCH] drm: ignore disconnected <-> unknown status changes

Only generate a hotplug event if the status changed
to / from connector_status_connected.

On some hardware the connector status is oscillating
between disconnected and unknown, and the hotplug
events mirroring these transitions cause screen
distortions. As the only reasonable action on such
a status change is to ignore it, it also is safe
not to genereate a hotplug event at all.

Needed for / tested on AOpen i915GMm-hfs mobo.

Signed-off-by: Knut Petersen <Knut_Petersen@t-online.de>
---
 drivers/gpu/drm/drm_crtc_helper.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index 3252e70..fb6160b 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -954,7 +954,11 @@ static void output_poll_execute(struct work_struct *work)
 			      connector->base.id,
 			      drm_get_connector_name(connector),
 			      old_status, connector->status);
-		if (old_status != connector->status)
+		/* changes are only relevant if previous or
+		    current status is connector_status_connected */
+		if (old_status != connector->status &&
+		    (old_status == connector_status_connected ||
+		    connector->status == connector_status_connected))
 			changed = true;
 	}
 
-- 
1.7.7


--------------090608040106050907050606--
