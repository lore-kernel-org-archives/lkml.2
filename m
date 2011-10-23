Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab1JWGjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:39:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab1JWGeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:03 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:39 2011
Message-Id: <20111023062539.476500327@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:42 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Skeggs <bskeggs@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: [14/27] drm/ttm: unbind ttm before destroying node in accel move cleanup
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit eac2095398668f989a3dd8d00be1b87850d78c01 upstream.

Nouveau makes the assumption that if a TTM is bound there will be a mm_node
around for it and the backwards ordering here resulted in a use-after-free
on some eviction paths.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/ttm/ttm_bo_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -635,13 +635,13 @@ int ttm_bo_move_accel_cleanup(struct ttm
 		if (ret)
 			return ret;
 
-		ttm_bo_free_old_node(bo);
 		if ((man->flags & TTM_MEMTYPE_FLAG_FIXED) &&
 		    (bo->ttm != NULL)) {
 			ttm_tt_unbind(bo->ttm);
 			ttm_tt_destroy(bo->ttm);
 			bo->ttm = NULL;
 		}
+		ttm_bo_free_old_node(bo);
 	} else {
 		/**
 		 * This should help pipeline ordinary buffer moves.


