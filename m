Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab2IYL5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:57:50 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:37063 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab2IYL5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:57:47 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] gpu/drm/ttm: use copy_highpage
Date: Tue, 25 Sep 2012 20:57:02 +0900
Message-Id: <1348574222-3512-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348574222-3512-1-git-send-email-akinobu.mita@gmail.com>
References: <n>
 <1348574222-3512-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use copy_highpage() to copy from one page to another.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/ttm/ttm_tt.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index fa09daf..11c9369 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -290,8 +290,6 @@ int ttm_tt_swapin(struct ttm_tt *ttm)
 	struct file *swap_storage;
 	struct page *from_page;
 	struct page *to_page;
-	void *from_virtual;
-	void *to_virtual;
 	int i;
 	int ret = -ENOMEM;
 
@@ -311,11 +309,7 @@ int ttm_tt_swapin(struct ttm_tt *ttm)
 			goto out_err;
 
 		preempt_disable();
-		from_virtual = kmap_atomic(from_page);
-		to_virtual = kmap_atomic(to_page);
-		memcpy(to_virtual, from_virtual, PAGE_SIZE);
-		kunmap_atomic(to_virtual);
-		kunmap_atomic(from_virtual);
+		copy_highpage(to_page, from_page);
 		preempt_enable();
 		page_cache_release(from_page);
 	}
@@ -336,8 +330,6 @@ int ttm_tt_swapout(struct ttm_tt *ttm, struct file *persistent_swap_storage)
 	struct file *swap_storage;
 	struct page *from_page;
 	struct page *to_page;
-	void *from_virtual;
-	void *to_virtual;
 	int i;
 	int ret = -ENOMEM;
 
@@ -367,11 +359,7 @@ int ttm_tt_swapout(struct ttm_tt *ttm, struct file *persistent_swap_storage)
 			goto out_err;
 		}
 		preempt_disable();
-		from_virtual = kmap_atomic(from_page);
-		to_virtual = kmap_atomic(to_page);
-		memcpy(to_virtual, from_virtual, PAGE_SIZE);
-		kunmap_atomic(to_virtual);
-		kunmap_atomic(from_virtual);
+		copy_highpage(to_page, from_page);
 		preempt_enable();
 		set_page_dirty(to_page);
 		mark_page_accessed(to_page);
-- 
1.7.11.4

