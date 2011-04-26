Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab1DZVfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:35:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:19974 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758746Ab1DZVN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425950992"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: rgoldwyn@gmail.com, rgoldwyn@suse.de, jlbec@evilplan.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [28/106] Treat writes as new when holes span across page boundaries
Message-Id: <20110426211307.393173E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ocfs2/aops.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.35.y/fs/ocfs2/aops.c
===================================================================
--- linux-2.6.35.y.orig/fs/ocfs2/aops.c
+++ linux-2.6.35.y/fs/ocfs2/aops.c
@@ -1039,6 +1039,12 @@ static int ocfs2_prepare_page_for_write(
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
