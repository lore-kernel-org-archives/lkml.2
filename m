Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab1AUKMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 05:12:13 -0500
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:63961
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753753Ab1AUKMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 05:12:12 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915: Fix use of invalid array size for ring->sync_seqno
Date: Fri, 21 Jan 2011 10:11:55 +0000
Message-Id: <1295604715-24563-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <4D39455D.4070808@gmail.com>
References: <4D39455D.4070808@gmail.com>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are I915_NUM_RINGS-1 inter-ring synchronisation counters, but we
were clearing I915_NUM_RINGS of them. Oops.

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---

Jiri, does this catch the invalid array access? For 3 rings, there should
only be 2 sync counters...

---
 drivers/gpu/drm/i915/i915_gem.c            |    2 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 3dfc848..812b97b 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1857,7 +1857,7 @@ i915_gem_retire_requests_ring(struct drm_device *dev,
 
 	seqno = ring->get_seqno(ring);
 
-	for (i = 0; i < I915_NUM_RINGS; i++)
+	for (i = 0; i < ARRAY_SIZE(ring->sync_seqno); i++)
 		if (seqno >= ring->sync_seqno[i])
 			ring->sync_seqno[i] = 0;
 
diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index dcfdf41..d2f445e 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -1175,7 +1175,7 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 		goto err;
 
 	seqno = i915_gem_next_request_seqno(dev, ring);
-	for (i = 0; i < I915_NUM_RINGS-1; i++) {
+	for (i = 0; i < ARRAY_SIZE(ring->sync_seqno); i++) {
 		if (seqno < ring->sync_seqno[i]) {
 			/* The GPU can not handle its semaphore value wrapping,
 			 * so every billion or so execbuffers, we need to stall
-- 
1.7.2.3

