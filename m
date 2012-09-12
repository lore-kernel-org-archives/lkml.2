Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012Ab2ILPHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:07:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59171 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab2ILPHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:07:14 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: kernel-janitors@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] drivers/gpu/drm/ttm/ttm_page_alloc_dma.c: Remove useless kfree
Date: Wed, 12 Sep 2012 17:06:41 +0200
Message-Id: <1347462407-13499-3-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Remove useless kfree() and clean up code related to the removal.

The semantic patch that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
position p1,p2;
expression x;
@@

if (x@p1 == NULL) { ... kfree@p2(x); ... return ...; }

@unchanged exists@
position r.p1,r.p2;
expression e <= r.x,x,e1;
iterator I;
statement S;
@@

if (x@p1 == NULL) { ... when != I(x,...) S
                        when != e = e1
                        when != e += e1
                        when != e -= e1
                        when != ++e
                        when != --e
                        when != e++
                        when != e--
                        when != &e
   kfree@p2(x); ... return ...; }

@ok depends on unchanged exists@
position any r.p1;
position r.p2;
expression x;
@@

... when != true x@p1 == NULL
kfree@p2(x);

@depends on !ok && unchanged@
position r.p2;
expression x;
@@

*kfree@p2(x);
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
index 4f9e548..969d765 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -1060,7 +1060,7 @@ int ttm_dma_page_alloc_init(struct ttm_mem_global *glob, unsigned max_pages)
 
 	_manager = kzalloc(sizeof(*_manager), GFP_KERNEL);
 	if (!_manager)
-		goto err_manager;
+		goto err;
 
 	mutex_init(&_manager->lock);
 	INIT_LIST_HEAD(&_manager->pools);
@@ -1078,9 +1078,6 @@ int ttm_dma_page_alloc_init(struct ttm_mem_global *glob, unsigned max_pages)
 	}
 	ttm_dma_pool_mm_shrink_init(_manager);
 	return 0;
-err_manager:
-	kfree(_manager);
-	_manager = NULL;
 err:
 	return ret;
 }

