Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab1GAJSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:18:31 -0400
Received: from adelie.canonical.com ([91.189.90.139]:33190 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab1GAJS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:18:27 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 08/10] drm/i915: Periodically flush the active lists and requests" has been added to staging queue
Date: Fri,  1 Jul 2011 10:18:25 +0100
Message-Id: <1309511905-3115-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 08/10] drm/i915: Periodically flush the active lists and requests

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 41516474bc14ea128b05bf65c9cbdb04739582ac Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Fri, 17 Jun 2011 10:04:22 -0500
Subject: [PATCH 08/10] drm/i915: Periodically flush the active lists and requests

BugLink: http://bugs.launchpad.net/bugs/599017

In order to retire active buffers whilst no client is active, we need to
insert our own flush requests onto the ring.

This is useful for servers that queue up some rendering and then go to
sleep as it allows us to the complete processing of those requests,
potentially making that memory available again much earlier.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
(backported from commit 0a58705b2fc3fa29525cf2fdae3d4276a5771280 upstream)

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index b3c7bd1..0314f7f 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1862,9 +1862,16 @@ i915_gem_retire_work_handler(struct work_struct *work)

 	mutex_lock(&dev->struct_mutex);
 	i915_gem_retire_requests(dev);
+
+	if (!list_empty(&dev_priv->mm.gpu_write_list)) {
+		i915_gem_flush(dev, 0, I915_GEM_GPU_DOMAINS);
+		i915_add_request(dev, NULL, I915_GEM_GPU_DOMAINS);
+	}
+
 	if (!dev_priv->mm.suspended &&
 	    !list_empty(&dev_priv->mm.request_list))
 		queue_delayed_work(dev_priv->wq, &dev_priv->mm.retire_work, HZ);
+
 	mutex_unlock(&dev->struct_mutex);
 }

--
1.7.4.1

