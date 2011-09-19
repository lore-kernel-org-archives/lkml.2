Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab1ISR01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 13:26:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45181 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab1ISR00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 13:26:26 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Seth Forshee <seth.forshee@canonical.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "drm/i915: Fix refleak during eviction." has been added to staging queue
Date: Mon, 19 Sep 2011 19:26:20 +0200
Message-Id: <1316453180-11636-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    drm/i915: Fix refleak during eviction.

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next
  or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From c56870dc2dc195a0aa99ab2095410d9611dab770 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Tue, 13 Sep 2011 08:46:49 -0500
Subject: [PATCH 2/2] drm/i915: Fix refleak during eviction.

Now that we hold onto a reference whilst evicting objects, we need to
be sure that we drop all the references taken -- even on the error
paths.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

BugLink: http://bugs.launchpad.net/bugs/843904

(backported from commit e39a01501b228e1be2037d5bddccae2a820af902 upstream)
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem_evict.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_evict.c b/drivers/gpu/drm/i915/i915_gem_evict.c
index c50c093..9e7f9c6 100644
--- a/drivers/gpu/drm/i915/i915_gem_evict.c
+++ b/drivers/gpu/drm/i915/i915_gem_evict.c
@@ -65,7 +65,7 @@ i915_gem_evict_something(struct drm_device *dev, int min_size, unsigned alignmen
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct list_head eviction_list, unwind_list;
-	struct drm_i915_gem_object *obj_priv, *tmp_obj_priv;
+	struct drm_i915_gem_object *obj_priv;
 	struct list_head *iter;
 	int ret = 0;

@@ -157,8 +157,10 @@ found:
 	 * scanning, therefore store to be evicted objects on a
 	 * temporary list. */
 	INIT_LIST_HEAD(&eviction_list);
-	list_for_each_entry_safe(obj_priv, tmp_obj_priv,
-				 &unwind_list, evict_list) {
+	while (!list_empty(&unwind_list)) {
+		obj_priv = list_first_entry(&unwind_list,
+					    struct drm_i915_gem_object,
+					    evict_list);
 		if (drm_mm_scan_remove_block(obj_priv->gtt_space)) {
 			list_move(&obj_priv->evict_list, &eviction_list);
 			continue;
@@ -179,7 +181,7 @@ found:
 		drm_gem_object_unreference(obj_priv->obj);
 	}

-	return 0;
+	return ret;
 }

 int
--
1.7.4.1

