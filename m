Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab2IZI4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:56:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab2IZIvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:38 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/27] GFS2: Fix case where reservation finished at end of rgrp
Date: Wed, 26 Sep 2012 09:25:29 +0100
Message-Id: <1348647948-3219-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One corner case which the original patch failed to take into
account was when there is a reservation which ended such that
the following block was one beyond the end of the rgrp in
question. This extra test fixes that case.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-by: Bob Peterson <rpeterso@redhat.com>
Tested-by: Bob Peterson <rpeterso@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 7ce22d8..c17029a 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1596,6 +1596,12 @@ find_next:
 			n += (rbm->bi - initial_bi);
 			goto find_next;
 		}
+		if (ret == -E2BIG) {
+			index = 0;
+			rbm->offset = 0;
+			n += (rbm->bi - initial_bi);
+			goto res_covered_end_of_rgrp;
+		}
 		return ret;
 
 bitmap_full:	/* Mark bitmap as full and fall through */
@@ -1608,6 +1614,7 @@ next_bitmap:	/* Find next bitmap in the rgrp */
 		index++;
 		if (index == rbm->rgd->rd_length)
 			index = 0;
+res_covered_end_of_rgrp:
 		rbm->bi = &rbm->rgd->rd_bits[index];
 		if ((index == 0) && nowrap)
 			break;
-- 
1.7.4

