Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab1AMLIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 06:08:04 -0500
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:54055
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932488Ab1AMLIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 06:08:00 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915/execbuffer: Clear domains before beginning reloc processing
Date: Thu, 13 Jan 2011 11:07:49 +0000
Message-Id: <1294916869-2417-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <AANLkTinBnm+xkXPPM4-3PG_i2hJMuXhv8x42KN4o3kGg@mail.gmail.com>
References: <AANLkTinBnm+xkXPPM4-3PG_i2hJMuXhv8x42KN4o3kGg@mail.gmail.com>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After reordering the sequence of relocating objects, commit 6fe4f1404,
we can no longer rely on seeing all reloc targets prior to performing
the relocation. So we need to clear the relocation domains earlier.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 6b34e98..8db88e3 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -464,8 +464,6 @@ i915_gem_execbuffer_relocate(struct drm_device *dev,
 	int ret;
 
 	list_for_each_entry(obj, objects, exec_list) {
-		obj->base.pending_read_domains = 0;
-		obj->base.pending_write_domain = 0;
 		ret = i915_gem_execbuffer_relocate_object(obj, eb);
 		if (ret)
 			return ret;
@@ -505,6 +503,9 @@ i915_gem_execbuffer_reserve(struct intel_ring_buffer *ring,
 			list_move(&obj->exec_list, &ordered_objects);
 		else
 			list_move_tail(&obj->exec_list, &ordered_objects);
+
+		obj->base.pending_read_domains = 0;
+		obj->base.pending_write_domain = 0;
 	}
 	list_splice(&ordered_objects, objects);
 
@@ -712,8 +713,6 @@ i915_gem_execbuffer_relocate_slow(struct drm_device *dev,
 
 	list_for_each_entry(obj, objects, exec_list) {
 		int offset = obj->exec_entry - exec;
-		obj->base.pending_read_domains = 0;
-		obj->base.pending_write_domain = 0;
 		ret = i915_gem_execbuffer_relocate_object_slow(obj, eb,
 							       reloc + reloc_offset[offset]);
 		if (ret)
-- 
1.7.2.3

