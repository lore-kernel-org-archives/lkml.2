Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab2CMAr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:47:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:48244 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758945Ab2CMAXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:34 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Abhijith Das <adas@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 124/196] GFS2: BUG in gfs2_adjust_quota
Date: Mon, 12 Mar 2012 20:20:37 -0400
Message-Id: <1331598109-31424-79-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8b4216018bdbfbb1b76150d202b15ee68c38e991 upstream.

HighMem pages on i686 do not get mapped to the buffer_heads and this was
causing a NULL pointer dereference when we were trying to memset page buffers
to zero.
We now use zero_user() that kmaps the page and directly manipulates page data.
This patch also fixes a boundary condition that was incorrect.

Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/gfs2/quota.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index f1c8d79..f9358a2 100644
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
1.7.9.3

