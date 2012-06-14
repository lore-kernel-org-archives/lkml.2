Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab2FOAHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:07:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45919 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727Ab2FNX7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:59:31 -0400
Message-Id: <20120614235625.157134606@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Hellstrom <thellstrom@vmware.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 14/42] drm/ttm: Fix buffer object metadata accounting regression v2
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit a393c730ab69617c3291a3b0b2a228c9be2fc28c upstream.

A regression was introduced in the 3.3 rc series, commit
"drm/ttm: simplify memory accounting for ttm user v2",
causing the metadata of buffer objects created using the ttm_bo_create()
function to be accounted twice.
That causes massive leaks with the vmwgfx driver running for example
SpecViewperf Catia-03 test 2, eventually killing the app.

Furthermore, the same commit introduces a regression where
metadata accounting is leaked if a buffer object is
initialized with an illegal size. This is also fixed with this commit.

v2: Fixed an error path and removed an unused variable.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ttm/ttm_bo.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -1193,6 +1193,7 @@ int ttm_bo_init(struct ttm_bo_device *bd
 			(*destroy)(bo);
 		else
 			kfree(bo);
+		ttm_mem_global_free(mem_glob, acc_size);
 		return -EINVAL;
 	}
 	bo->destroy = destroy;
@@ -1294,22 +1295,14 @@ int ttm_bo_create(struct ttm_bo_device *
 			struct ttm_buffer_object **p_bo)
 {
 	struct ttm_buffer_object *bo;
-	struct ttm_mem_global *mem_glob = bdev->glob->mem_glob;
 	size_t acc_size;
 	int ret;
 
-	acc_size = ttm_bo_acc_size(bdev, size, sizeof(struct ttm_buffer_object));
-	ret = ttm_mem_global_alloc(mem_glob, acc_size, false, false);
-	if (unlikely(ret != 0))
-		return ret;
-
 	bo = kzalloc(sizeof(*bo), GFP_KERNEL);
-
-	if (unlikely(bo == NULL)) {
-		ttm_mem_global_free(mem_glob, acc_size);
+	if (unlikely(bo == NULL))
 		return -ENOMEM;
-	}
 
+	acc_size = ttm_bo_acc_size(bdev, size, sizeof(struct ttm_buffer_object));
 	ret = ttm_bo_init(bdev, bo, size, type, placement, page_alignment,
 				buffer_start, interruptible,
 				persistent_swap_storage, acc_size, NULL);


