Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab2L1UmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:42:06 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38098 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab2L1UmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 15:42:00 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/24] blkcg: cosmetic updates to blkg_create()
Date: Fri, 28 Dec 2012 12:35:31 -0800
Message-Id: <1356726946-26037-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rename out_* labels to err_*.

* Do ERR_PTR() conversion once in the error return path.

This patch is cosmetic and to prepare for the hierarchy support.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 2012754..18ae480 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -187,16 +187,16 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 
 	/* blkg holds a reference to blkcg */
 	if (!css_tryget(&blkcg->css)) {
-		blkg = ERR_PTR(-EINVAL);
-		goto out_free;
+		ret = -EINVAL;
+		goto err_free_blkg;
 	}
 
 	/* allocate */
 	if (!new_blkg) {
 		new_blkg = blkg_alloc(blkcg, q, GFP_ATOMIC);
 		if (unlikely(!new_blkg)) {
-			blkg = ERR_PTR(-ENOMEM);
-			goto out_put;
+			ret = -ENOMEM;
+			goto err_put_css;
 		}
 	}
 	blkg = new_blkg;
@@ -213,12 +213,11 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 	if (!ret)
 		return blkg;
 
-	blkg = ERR_PTR(ret);
-out_put:
+err_put_css:
 	css_put(&blkcg->css);
-out_free:
+err_free_blkg:
 	blkg_free(new_blkg);
-	return blkg;
+	return ERR_PTR(ret);
 }
 
 /**
-- 
1.8.0.2

