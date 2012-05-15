Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965569Ab2EOC1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:27:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:49872 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965520Ab2EOCSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 170/179] drm/ttm: fix ttm_bo_add_ttm(user) failure path
Date: Mon, 14 May 2012 22:14:26 -0400
Message-ID: <1337048075-6132-171-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 7c4c3960dff109bc5db4c35da481c212dadb5eb5 upstream.

ttm_tt_destroy kfrees passed object, so we need to nullify
a reference to it.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/gpu/drm/ttm/ttm_bo.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 0e3754a3..778fa1a 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -343,8 +343,10 @@ static int ttm_bo_add_ttm(struct ttm_buffer_object *bo, bool zero_alloc)
 
 		ret = ttm_tt_set_user(bo->ttm, current,
 				      bo->buffer_start, bo->num_pages);
-		if (unlikely(ret != 0))
+		if (unlikely(ret != 0)) {
 			ttm_tt_destroy(bo->ttm);
+			bo->ttm = NULL;
+		}
 		break;
 	default:
 		printk(KERN_ERR TTM_PFX "Illegal buffer object type\n");
-- 
1.7.9.6

