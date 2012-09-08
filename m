Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab2IHNZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 09:25:21 -0400
Received: from mail-wi0-f194.google.com ([209.85.212.194]:60112 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab2IHNZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 09:25:18 -0400
From: Anna Leuschner <anna.m.leuschner@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anna Leuschner <anna.m.leuschner@gmail.com>
Subject: [PATCH 1/1] vfs: bio.c: fix: increment capacity only if krealloc() succeeded
Date: Sat,  8 Sep 2012 15:06:55 +0200
Message-Id: <1347109615-19556-1-git-send-email-anna.m.leuschner@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix: only increment bio_slab_max if bio_slabs reallocation succeeded

Signed-off-by: Anna Leuschner <anna.m.leuschner@gmail.com>
---
 fs/bio.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 71072ab..58707ff 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -74,6 +74,7 @@ static struct kmem_cache *bio_find_or_create_slab(unsigned int extra_size)
 	unsigned int sz = sizeof(struct bio) + extra_size;
 	struct kmem_cache *slab = NULL;
 	struct bio_slab *bslab, *new_bio_slabs;
+	unsigned int new_bio_slab_max;
 	unsigned int i, entry = -1;
 
 	mutex_lock(&bio_slab_lock);
@@ -96,12 +97,13 @@ static struct kmem_cache *bio_find_or_create_slab(unsigned int extra_size)
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
1.7.9.5

