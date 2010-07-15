Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab0GOOTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 10:19:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933326Ab0GOOTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 10:19:10 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 5/5] GFS2: rename causes kernel Oops
Date: Thu, 15 Jul 2010 14:57:54 +0100
Message-Id: <1279202274-4418-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1279202274-4418-1-git-send-email-swhiteho@redhat.com>
References: <1279202274-4418-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes a kernel Oops in the GFS2 rename code.

The problem was in the way the gfs2 directory code was trying
to re-use sentinel directory entries.

In the failing case, gfs2's rename function was renaming a
file to another name that had the same non-trivial length.
The file being renamed happened to be the first directory
entry on the leaf block.

First, the rename code (gfs2_rename in ops_inode.c) found the
original directory entry and decided it could do its job by
simply replacing the directory entry with another.  Therefore
it determined correctly that no block allocations were needed.

Next, the rename code deleted the old directory entry prior to
replacing it with the new name.  Therefore, the soon-to-be
replaced directory entry was temporarily made into a directory
entry "sentinel" or a place holder at the start of a leaf block.

Lastly, it went to re-add the replacement directory entry in
that leaf block.  However, when gfs2_dirent_find_space was
looking for space in the leaf block, it used the wrong value
for the sentinel.  That threw off its calculations so later
it decides it can't really re-use the sentinel and therefore
must allocate a new leaf block.  But because it previously decided
to re-use the directory entry, it didn't waste the time to
grab a new block allocation for the inode.  Therefore, the
inode's i_alloc pointer was still NULL and it crashes trying to
reference it.

In the case of sentinel directory entries, the entire dirent is
reused, not just the "free space" portion of it, and therefore
the function gfs2_dirent_find_space should use the value 0
rather than GFS2_DIRENT_SIZE(0) for the actual dirent size.

Fixing this calculation enables the reproducer programs to work
properly.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 8295c5b..26ca336 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -392,7 +392,7 @@ static int gfs2_dirent_find_space(const struct gfs2_dirent *dent,
 	unsigned totlen = be16_to_cpu(dent->de_rec_len);
 
 	if (gfs2_dirent_sentinel(dent))
-		actual = GFS2_DIRENT_SIZE(0);
+		actual = 0;
 	if (totlen - actual >= required)
 		return 1;
 	return 0;
-- 
1.7.1.1

