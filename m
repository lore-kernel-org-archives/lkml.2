Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478Ab1DMQEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:04:30 -0400
Received: from kroah.org ([198.145.64.141]:54407 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758113Ab1DMPzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:47 2011
Message-Id: <20110413155147.139187670@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:51:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Goldwyn Rodrigues <rgoldwyn@suse.de>, jlbec <jlbec@evilplan.org>
Subject: [39/74] Treat writes as new when holes span across page boundaries
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


