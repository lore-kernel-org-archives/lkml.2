Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab1ISR01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 13:26:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45173 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab1ISR00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 13:26:26 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Seth Forshee <seth.forshee@canonical.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "drm/i915: Hold a reference to the object whilst unbinding the eviction list" has been added to staging queue
Date: Mon, 19 Sep 2011 19:26:19 +0200
Message-Id: <1316453179-11600-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    drm/i915: Hold a reference to the object whilst unbinding the eviction list

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next
  or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From e223b34bd97f52b317899190f0b0b3df994faf2e Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Tue, 13 Sep 2011 08:46:48 -0500
Subject: [PATCH 1/2] drm/i915: Hold a reference to the object whilst unbinding the eviction list

During heavy aperture thrashing we may be forced to wait upon several active
objects during eviction. The active list may be the last reference to
these objects and so the action of waiting upon one of them may cause
another to be freed (and itself unbound). To prevent the object
disappearing underneath us, we need to acquire and hold a reference
whilst unbinding.

This should fix the reported page refcount OOPS:

kernel BUG at drivers/gpu/drm/i915/i915_gem.c:1444!
...
RIP: 0010:[<ffffffffa0093026>]  [<ffffffffa0093026>] i915_gem_object_put_pages+0x25/0xf5 [i915]
Call Trace:
 [<ffffffffa009481d>] i915_gem_object_unbind+0xc5/0x1a7 [i915]
 [<ffffffffa0098ab2>] i915_gem_evict_something+0x3bd/0x409 [i915]
 [<ffffffffa0027923>] ? drm_gem_object_lookup+0x27/0x57 [drm]
 [<ffffffffa0093bc3>] i915_gem_object_bind_to_gtt+0x1d3/0x279 [i915]
 [<ffffffffa0095b30>] i915_gem_object_pin+0xa3/0x146 [i915]
 [<ffffffffa0027948>] ? drm_gem_object_lookup+0x4c/0x57 [drm]
 [<ffffffffa00961bc>] i915_gem_do_execbuffer+0x50d/0xe32 [i915]

Reported-by: Shawn Starr <shawn.starr@rogers.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=18902
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

BugLink: http://bugs.launchpad.net/bugs/843904

(backported from commit af6261031317f646d22f994c0b467521e47aa49f upstream)
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem_evict.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_evict.c b/drivers/gpu/drm/i915/i915_gem_evict.c
index c4c6b6f..c50c093 100644
--- a/drivers/gpu/drm/i915/i915_gem_evict.c
+++ b/drivers/gpu/drm/i915/i915_gem_evict.c
@@ -52,6 +52,7 @@ mark_free(struct drm_i915_gem_object *obj_priv,
 	   struct list_head *unwind)
 {
 	list_add(&obj_priv->evict_list, unwind);
+	drm_gem_object_reference(obj_priv->obj);
 	return drm_mm_scan_add_block(obj_priv->gtt_space);
 }

@@ -143,6 +144,7 @@ i915_gem_evict_something(struct drm_device *dev, int min_size, unsigned alignmen
 		BUG_ON(ret);

 		list_del_init(&obj_priv->evict_list);
+		drm_gem_object_unreference(obj_priv->obj);
 	}

 	/* We expect the caller to unpin, evict all and try again, or give up.
@@ -162,6 +164,7 @@ found:
 			continue;
 		}
 		list_del_init(&obj_priv->evict_list);
+		drm_gem_object_unreference(obj_priv->obj);
 	}

 	/* Unbinding will emit any required flushes */
@@ -173,6 +176,7 @@ found:
 			ret = i915_gem_object_unbind(obj_priv->obj);

 		list_del_init(&obj_priv->evict_list);
+		drm_gem_object_unreference(obj_priv->obj);
 	}

 	return 0;
--
1.7.4.1

