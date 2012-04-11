Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965498Ab2DKX1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:27:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50538 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965390Ab2DKX1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:27:13 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] drm/i915: clear fencing tracking state when retiring request
Date: Thu, 12 Apr 2012 01:27:57 +0200
Message-Id: <1334186877-6299-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a regression introduce in

commit 7dd4906586274f3945f2aeaaa5a33b451c3b4bba
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Mar 21 10:48:18 2012 +0000

    drm/i915: Mark untiled BLT commands as fenced on gen2/3

which fixed fencing tracking for untiled blt commands.

A side effect of that patch was that now also untiled objects have a
non-zero obj->last_fenced_seqno to track when a fence can be set up
after a pipelined tiling change. Unfortunately this was only cleared
by the fence setup and teardown code, resulting in tons of untiled but
inactive objects with non-zero last_fenced_seqno.

Now after resume we completely reset the seqno tracking, both on the
driver side (by setting dev_priv->next_seqno = 1) and on the hw side
(by allocating a new hws page, which contains the seqnos). Hilarity
and indefinite waits ensued from the stale seqnos in
obj->last_fenced_seqno from before the suspend.

The fix is to properly clear the fencing tracking state like we
already do for the normal gpu rendering while moving objects off the
active list.

Reported-and-tested-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_gem.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 71934dd..cf50fbc 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1415,6 +1415,7 @@ i915_gem_object_move_off_active(struct drm_i915_gem_object *obj)
 {
 	list_del_init(&obj->ring_list);
 	obj->last_rendering_seqno = 0;
+	obj->last_fenced_seqno = 0;
 }
 
 static void
@@ -1443,6 +1444,7 @@ i915_gem_object_move_to_inactive(struct drm_i915_gem_object *obj)
 	BUG_ON(!list_empty(&obj->gpu_write_list));
 	BUG_ON(!obj->active);
 	obj->ring = NULL;
+	obj->last_fenced_ring = NULL;
 
 	i915_gem_object_move_off_active(obj);
 	obj->fenced_gpu_access = false;
-- 
1.7.9.1

