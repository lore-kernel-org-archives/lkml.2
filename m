Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307Ab2CMASj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:18:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:46916 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664Ab2CMASe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:18:34 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Goldwyn Rodrigues <rgoldwyn@gmail.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>, jlbec <jlbec@evilplan.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 038/196] Treat writes as new when holes span across page boundaries
Date: Mon, 12 Mar 2012 20:12:46 -0400
Message-Id: <1331597724-31358-39-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 272b62c1f0f6f742046e45b50b6fec98860208a0 upstream.

When a hole spans across page boundaries, the next write forces
a read of the block. This could end up reading existing garbage
data from the disk in ocfs2_map_page_blocks. This leads to
non-zero holes. In order to avoid this, mark the writes as new
when the holes span across page boundaries.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
Signed-off-by: jlbec <jlbec@evilplan.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ocfs2/aops.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index e504ab7..3de08db 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1035,6 +1035,12 @@ static int ocfs2_prepare_page_for_write(struct inode *inode, u64 *p_blkno,
 	ocfs2_figure_cluster_boundaries(OCFS2_SB(inode->i_sb), cpos,
 					&cluster_start, &cluster_end);
 
+	/* treat the write as new if the a hole/lseek spanned across
+	 * the page boundary.
+	 */
+	new = new | ((i_size_read(inode) <= page_offset(page)) &&
+			(page_offset(page) <= user_pos));
+
 	if (page == wc->w_target_page) {
 		map_from = user_pos & (PAGE_CACHE_SIZE - 1);
 		map_to = map_from + user_len;
-- 
1.7.9.3

