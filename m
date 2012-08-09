Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab2HIFx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 01:53:27 -0400
Received: from mail.ispras.ru ([83.149.199.43]:46055 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab2HIFx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 01:53:26 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: [PATCH] bio: Fix potential memory leak in bio_find_or_create_slab()
Date: Thu,  9 Aug 2012 09:52:12 +0400
Message-Id: <1344491532-4969-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not leak memory by updating pointer with potentially NULL realloc return value.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 fs/bio.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 5eaa70c..3fb4380 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -73,7 +73,7 @@ static struct kmem_cache *bio_find_or_create_slab(unsigned int extra_size)
 {
 	unsigned int sz = sizeof(struct bio) + extra_size;
 	struct kmem_cache *slab = NULL;
-	struct bio_slab *bslab;
+	struct bio_slab *bslab, *new_bio_slabs;
 	unsigned int i, entry = -1;
 
 	mutex_lock(&bio_slab_lock);
@@ -97,11 +97,12 @@ static struct kmem_cache *bio_find_or_create_slab(unsigned int extra_size)
 
 	if (bio_slab_nr == bio_slab_max && entry == -1) {
 		bio_slab_max <<= 1;
-		bio_slabs = krealloc(bio_slabs,
-				     bio_slab_max * sizeof(struct bio_slab),
-				     GFP_KERNEL);
-		if (!bio_slabs)
+		new_bio_slabs = krealloc(bio_slabs,
+					 bio_slab_max * sizeof(struct bio_slab),
+					 GFP_KERNEL);
+		if (!new_bio_slabs)
 			goto out_unlock;
+		bio_slabs = new_bio_slabs;
 	}
 	if (entry == -1)
 		entry = bio_slab_nr++;
-- 
1.7.9.5

