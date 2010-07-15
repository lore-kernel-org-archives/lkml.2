Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388Ab0GOOTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 10:19:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933344Ab0GOOTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 10:19:08 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/5] GFS2: BUG in gfs2_adjust_quota
Date: Thu, 15 Jul 2010 14:57:53 +0100
Message-Id: <1279202274-4418-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1279202274-4418-1-git-send-email-swhiteho@redhat.com>
References: <1279202274-4418-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

HighMem pages on i686 do not get mapped to the buffer_heads and this was
causing a NULL pointer dereference when we were trying to memset page buffers
to zero.
We now use zero_user() that kmaps the page and directly manipulates page data.
This patch also fixes a boundary condition that was incorrect.

Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 49667d6..b256d6f 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -694,10 +694,8 @@ get_a_page:
 		if (!buffer_mapped(bh))
 			goto unlock_out;
 		/* If it's a newly allocated disk block for quota, zero it */
-		if (buffer_new(bh)) {
-			memset(bh->b_data, 0, bh->b_size);
-			set_buffer_uptodate(bh);
-		}
+		if (buffer_new(bh))
+			zero_user(page, pos - blocksize, bh->b_size);
 	}
 
 	if (PageUptodate(page))
@@ -723,7 +721,7 @@ get_a_page:
 
 	/* If quota straddles page boundary, we need to update the rest of the
 	 * quota at the beginning of the next page */
-	if (offset != 0) { /* first page, offset is closer to PAGE_CACHE_SIZE */
+	if ((offset + sizeof(struct gfs2_quota)) > PAGE_CACHE_SIZE) {
 		ptr = ptr + nbytes;
 		nbytes = sizeof(struct gfs2_quota) - nbytes;
 		offset = 0;
-- 
1.7.1.1

