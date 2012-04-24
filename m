Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964915Ab2DXWlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:41:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964838Ab2DXWjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:39:05 -0400
Message-Id: <20120424223256.752310329@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Subject: [ 38/42] ocfs2: ->l_next_free_req breakage on big-endian
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 3a251f04fe97c3d335b745c98e4b377e3c3899f2 upstream.

It's le16, not le32...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/alloc.c        |    2 +-
 fs/ocfs2/refcounttree.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1134,7 +1134,7 @@ static int ocfs2_adjust_rightmost_branch
 	}
 
 	el = path_leaf_el(path);
-	rec = &el->l_recs[le32_to_cpu(el->l_next_free_rec) - 1];
+	rec = &el->l_recs[le16_to_cpu(el->l_next_free_rec) - 1];
 
 	ocfs2_adjust_rightmost_records(handle, et, path, rec);
 
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -1036,14 +1036,14 @@ static int ocfs2_get_refcount_cpos_end(s
 
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


