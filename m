Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab2KEN4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:56:34 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:54282 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932681Ab2KEN4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:56:07 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: airlied@gmail.com, airlied@redhat.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 4/4] drm/ttm: Optimize reservation slightly
Date: Mon,  5 Nov 2012 14:55:44 +0100
Message-Id: <1352123744-13269-5-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1352123744-13269-1-git-send-email-thellstrom@vmware.com>
References: <1352123744-13269-1-git-send-email-thellstrom@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reservation locking currently always takes place under the LRU spinlock.
Hence, strictly there is no need for an atomic_cmpxchg call; we can use
atomic_read followed by atomic_write since nobody else will ever reserve
without the lru spinlock held.
At least on Intel this should remove a locked bus cycle on successful
reserve.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 drivers/gpu/drm/ttm/ttm_bo.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index bf6e4b5..46008ea 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -220,7 +220,7 @@ int ttm_bo_reserve_locked(struct ttm_buffer_object *bo,
 	struct ttm_bo_global *glob = bo->glob;
 	int ret;
 
-	while (unlikely(atomic_cmpxchg(&bo->reserved, 0, 1) != 0)) {
+	while (unlikely(atomic_read(&bo->reserved) != 0)) {
 		/**
 		 * Deadlock avoidance for multi-bo reserving.
 		 */
@@ -249,6 +249,7 @@ int ttm_bo_reserve_locked(struct ttm_buffer_object *bo,
 			return ret;
 	}
 
+	atomic_set(&bo->reserved, 1);
 	if (use_sequence) {
 		/**
 		 * Wake up waiters that may need to recheck for deadlock,
-- 
1.7.4.4

