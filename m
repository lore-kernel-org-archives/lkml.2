Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab1DYUj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:39:58 -0400
Received: from 1wt.eu ([62.212.114.60]:34406 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326Ab1DYUY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:58 -0400
Message-Id: <20110425200238.902101275@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, jlbec <jlbec@evilplan.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 136/173] Treat writes as new when holes span across page boundaries
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Goldwyn Rodrigues <rgoldwyn@gmail.com>

commit 272b62c1f0f6f742046e45b50b6fec98860208a0 upstream.

When a hole spans across page boundaries, the next write forces
a read of the block. This could end up reading existing garbage
data from the disk in ocfs2_map_page_blocks. This leads to
non-zero holes. In order to avoid this, mark the writes as new
when the holes span across page boundaries.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
Signed-off-by: jlbec <jlbec@evilplan.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/aops.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1091,6 +1091,12 @@ static int ocfs2_prepare_page_for_write(
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


