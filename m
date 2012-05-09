Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab2EIFw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:52:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38744 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755602Ab2EIFwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:53 -0400
Message-Id: <20120509055037.184635021@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:23 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 054/167] [PATCH 1/4] ocfs2: ->l_next_free_req breakage on big-endian
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 3a251f04fe97c3d335b745c98e4b377e3c3899f2 upstream.

It's le16, not le32...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ocfs2/alloc.c        |    2 +-
 fs/ocfs2/refcounttree.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 3165aeb..31b9463 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1134,7 +1134,7 @@ static int ocfs2_adjust_rightmost_branch(handle_t *handle,
 	}
 
 	el = path_leaf_el(path);
-	rec = &el->l_recs[le32_to_cpu(el->l_next_free_rec) - 1];
+	rec = &el->l_recs[le16_to_cpu(el->l_next_free_rec) - 1];
 
 	ocfs2_adjust_rightmost_records(handle, et, path, rec);
 
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index cf78233..a7b7217 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1036,14 +1036,14 @@ static int ocfs2_get_refcount_cpos_end(struct ocfs2_caching_info *ci,
 
 	tmp_el = left_path->p_node[subtree_root].el;
 	blkno = left_path->p_node[subtree_root+1].bh->b_blocknr;
-	for (i = 0; i < le32_to_cpu(tmp_el->l_next_free_rec); i++) {
+	for (i = 0; i < le16_to_cpu(tmp_el->l_next_free_rec); i++) {
 		if (le64_to_cpu(tmp_el->l_recs[i].e_blkno) == blkno) {
 			*cpos_end = le32_to_cpu(tmp_el->l_recs[i+1].e_cpos);
 			break;
 		}
 	}
 
-	BUG_ON(i == le32_to_cpu(tmp_el->l_next_free_rec));
+	BUG_ON(i == le16_to_cpu(tmp_el->l_next_free_rec));
 
 out:
 	ocfs2_free_path(left_path);
-- 
1.7.10



