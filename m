Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2JNPPB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:15:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46109 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753969Ab2JNOlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:44 -0400
Message-Id: <20121014143553.639473578@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:38:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Jiri Slaby <jslaby@suse.cz>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [ 147/147] drm/i915: clear fencing tracking state when retiring requests
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 15a13bbdffb0d6288a5dd04aee9736267da1335f upstream.

This fixes a resume regression introduced in

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
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_gem.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 4c65c63..0e3c6ac 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1493,6 +1493,7 @@ i915_gem_object_move_off_active(struct drm_i915_gem_object *obj)
 {
 	list_del_init(&obj->ring_list);
 	obj->last_rendering_seqno = 0;
+	obj->last_fenced_seqno = 0;
 }
 
 static void
@@ -1521,6 +1522,7 @@ i915_gem_object_move_to_inactive(struct drm_i915_gem_object *obj)
 	BUG_ON(!list_empty(&obj->gpu_write_list));
 	BUG_ON(!obj->active);
 	obj->ring = NULL;
+	obj->last_fenced_ring = NULL;
 
 	i915_gem_object_move_off_active(obj);
 	obj->fenced_gpu_access = false;


