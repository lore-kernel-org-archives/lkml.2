Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab2JUUeA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 16:34:00 -0400
Received: from mail-wi0-f194.google.com ([209.85.212.194]:33637 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab2JUUd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 16:33:59 -0400
From: Anna Leuschner <anna.m.leuschner@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Anna Leuschner <anna.m.leuschner@gmail.com>
Subject: [PATCH] vfs: fix: don't increase bio_slab_max if krealloc() fails
Date: Sun, 21 Oct 2012 22:33:29 +0200
Message-Id: <1350851609-10541-1-git-send-email-anna.m.leuschner@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bio.c: fix: don't increase bio_slab_max if krealloc() of bio_slabs fails

Signed-off-by: Anna Leuschner <anna.m.leuschner@gmail.com>
---
 fs/bio.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 9298c65..b96fc6c 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -75,6 +75,7 @@ static struct kmem_cache *bio_find_or_create_slab(unsigned int extra_size)
 	unsigned int sz = sizeof(struct bio) + extra_size;
 	struct kmem_cache *slab = NULL;
 	struct bio_slab *bslab, *new_bio_slabs;
+	unsigned int new_bio_slab_max;
 	unsigned int i, entry = -1;
 
 	mutex_lock(&bio_slab_lock);
@@ -97,12 +98,13 @@ static struct kmem_cache *bio_find_or_create_slab(unsigned int extra_size)
 		goto out_unlock;
 
 	if (bio_slab_nr == bio_slab_max && entry == -1) {
-		bio_slab_max <<= 1;
+		new_bio_slab_max = bio_slab_max << 1;
 		new_bio_slabs = krealloc(bio_slabs,
-					 bio_slab_max * sizeof(struct bio_slab),
+					 new_bio_slab_max * sizeof(struct bio_slab),
 					 GFP_KERNEL);
 		if (!new_bio_slabs)
 			goto out_unlock;
+		bio_slab_max = new_bio_slab_max;
 		bio_slabs = new_bio_slabs;
 	}
 	if (entry == -1)
-- 
1.7.10.4

