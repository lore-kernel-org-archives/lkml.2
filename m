Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762844Ab2FVXdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:33:16 -0400
Received: from mail-lb0-f202.google.com ([209.85.217.202]:36252 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab2FVXdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:33:15 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, Jens Axboe <axboe@kernel.dk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Cong Wang <amwang@redhat.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rob Clark <rob.clark@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Sonny Rao <sonnyrao@chromium.org>, Olof Johansson <olofj@chromium.org>
Subject: [PATCH] lib/scatterlist: do not re-write gfp_flags in __sg_alloc_table
Date: Fri, 22 Jun 2012 16:33:10 -0700
Message-Id: <1340407990-5122-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are seeing a lot of sg_alloc_table allocation failures using the
new drm prime infrastructure. We isolated the cause to code in
__sg_alloc_table that was re-writing the gfp_flags.

There is a comment in the code that suggest that there is an
assumption about the allocation coming from a memory pool. This was
likely true when sg lists were primarily used for disk I/O.

Change-Id: I459169f56e4a9aa859661b22ec9d4e6925f99e85
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <rob.clark@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Sonny Rao <sonnyrao@chromium.org>
Cc: Olof Johansson <olofj@chromium.org>
---
 lib/scatterlist.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 6096e89..d09bdd8 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -279,14 +279,6 @@ int __sg_alloc_table(struct sg_table *table, unsigned int nents,
 		if (!left)
 			sg_mark_end(&sg[sg_size - 1]);
 
-		/*
-		 * only really needed for mempool backed sg allocations (like
-		 * SCSI), a possible improvement here would be to pass the
-		 * table pointer into the allocator and let that clear these
-		 * flags
-		 */
-		gfp_mask &= ~__GFP_WAIT;
-		gfp_mask |= __GFP_HIGH;
 		prv = sg;
 	} while (left);
 
-- 
1.7.7.3

