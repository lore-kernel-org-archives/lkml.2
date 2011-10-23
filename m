Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab1JWGj6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:39:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab1JWGeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:02 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:39 2011
Message-Id: <20111023062539.325957570@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:41 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Skeggs <bskeggs@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: [13/27] drm/ttm: ensure ttm for new node is bound before calling move_notify()
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 8d3bb23609d4ae22803a15d232289fc09a7b61c4 upstream.

This was true for new TTM_PL_SYSTEM and new TTM_PL_TT cases, but wasn't
the case on TTM_PL_SYSTEM<->TTM_PL_TT moves, which causes trouble on some
paths as nouveau's move_notify() hook requires that the dma addresses be
valid at this point.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/ttm/ttm_bo.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -392,10 +392,12 @@ static int ttm_bo_handle_move_mem(struct
 	 * Create and bind a ttm if required.
 	 */
 
-	if (!(new_man->flags & TTM_MEMTYPE_FLAG_FIXED) && (bo->ttm == NULL)) {
-		ret = ttm_bo_add_ttm(bo, false);
-		if (ret)
-			goto out_err;
+	if (!(new_man->flags & TTM_MEMTYPE_FLAG_FIXED)) {
+		if (bo->ttm == NULL) {
+			ret = ttm_bo_add_ttm(bo, false);
+			if (ret)
+				goto out_err;
+		}
 
 		ret = ttm_tt_set_placement_caching(bo->ttm, mem->placement);
 		if (ret)


