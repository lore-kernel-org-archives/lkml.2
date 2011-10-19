Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab1JSWXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:23:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27905 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab1JSWUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:20:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        thellstrom@vmware.com, thomas@shipmail.org, airlied@redhat.com
Cc: xen-devel@lists.xensource.com, j.glisse@redhat.com, bskeggs@redhat.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 07/11] ttm: Do not set the ttm->be to NULL before calling the TTM page pool to free pages.
Date: Wed, 19 Oct 2011 18:19:28 -0400
Message-Id: <1319062772-2793-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319062772-2793-1-git-send-email-konrad.wilk@oracle.com>
References: <1319062772-2793-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4E9F4D09.00C9:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. as the ttm->be->func->[get|put]_pages can be called and they would
dereference on ttm->be which was set to NULL.

Instead of clearing it there, pass in a flag to the ttm_tt_free_allocated_pages
whether to clear the pages or not (you are not suppose to clear the pages
when destroying them).

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/ttm/ttm_tt.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 76c982f..31ae359 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -276,7 +276,7 @@ int ttm_tt_set_placement_caching(struct ttm_tt *ttm, uint32_t placement)
 }
 EXPORT_SYMBOL(ttm_tt_set_placement_caching);
 
-static void ttm_tt_free_alloced_pages(struct ttm_tt *ttm)
+static void ttm_tt_free_alloced_pages(struct ttm_tt *ttm, bool call_clear)
 {
 	int i;
 	unsigned count = 0;
@@ -286,7 +286,7 @@ static void ttm_tt_free_alloced_pages(struct ttm_tt *ttm)
 
 	INIT_LIST_HEAD(&h);
 
-	if (be)
+	if (be && call_clear)
 		be->func->clear(be);
 	for (i = 0; i < ttm->num_pages; ++i) {
 
@@ -317,16 +317,14 @@ void ttm_tt_destroy(struct ttm_tt *ttm)
 		return;
 
 	be = ttm->be;
-	if (likely(be != NULL)) {
+	if (likely(be != NULL))
 		be->func->destroy(be);
-		ttm->be = NULL;
-	}
 
 	if (likely(ttm->pages != NULL)) {
 		if (ttm->page_flags & TTM_PAGE_FLAG_USER)
 			ttm_tt_free_user_pages(ttm);
 		else
-			ttm_tt_free_alloced_pages(ttm);
+			ttm_tt_free_alloced_pages(ttm, false);
 
 		ttm_tt_free_page_directory(ttm);
 	}
@@ -335,6 +333,7 @@ void ttm_tt_destroy(struct ttm_tt *ttm)
 	    ttm->swap_storage)
 		fput(ttm->swap_storage);
 
+	ttm->be = NULL;
 	kfree(ttm);
 }
 
@@ -509,7 +508,7 @@ static int ttm_tt_swapin(struct ttm_tt *ttm)
 
 	return 0;
 out_err:
-	ttm_tt_free_alloced_pages(ttm);
+	ttm_tt_free_alloced_pages(ttm, true);
 	return ret;
 }
 
@@ -573,7 +572,7 @@ int ttm_tt_swapout(struct ttm_tt *ttm, struct file *persistent_swap_storage)
 		page_cache_release(to_page);
 	}
 
-	ttm_tt_free_alloced_pages(ttm);
+	ttm_tt_free_alloced_pages(ttm, true);
 	ttm->swap_storage = swap_storage;
 	ttm->page_flags |= TTM_PAGE_FLAG_SWAPPED;
 	if (persistent_swap_storage)
-- 
1.7.6.4

