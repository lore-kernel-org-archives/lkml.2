Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3ACMRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:17:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab3ACMQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:16:38 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/4] GFS2: Stop looking for free blocks at end of rgrp
Date: Thu,  3 Jan 2013 11:50:09 +0000
Message-Id: <1357213810-3739-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1357213810-3739-1-git-send-email-swhiteho@redhat.com>
References: <1357213810-3739-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch adds a return code check after calling function
gfs2_rbm_from_block while determining the free extent size.
That way, when the end of an rgrp is reached, it won't try
to process unaligned blocks after the end.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 738b388..712dd4f 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -350,10 +350,14 @@ static u32 gfs2_free_extlen(const struct gfs2_rbm *rrbm, u32 len)
 		BUG_ON(len < chunk_size);
 		len -= chunk_size;
 		block = gfs2_rbm_to_block(&rbm);
-		gfs2_rbm_from_block(&rbm, block + chunk_size);
-		n_unaligned = 3;
-		if (ptr)
+		if (gfs2_rbm_from_block(&rbm, block + chunk_size)) {
+			n_unaligned = 0;
 			break;
+		}
+		if (ptr) {
+			n_unaligned = 3;
+			break;
+		}
 		n_unaligned = len & 3;
 	}
 
-- 
1.7.4

