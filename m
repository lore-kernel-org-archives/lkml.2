Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935785Ab0HFTK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:10:29 -0400
Received: from kroah.org ([198.145.64.141]:58605 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965117Ab0HFTAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:00:22 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:58:35 2010
Message-Id: <20100806185835.904336974@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:57:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [23/34] GFS2: rename causes kernel Oops
In-Reply-To: <20100806185853.GA28270@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bob Peterson <rpeterso@redhat.com>

commit 728a756b8fcd22d80e2dbba8117a8a3aafd3f203 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/gfs2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -392,7 +392,7 @@ static int gfs2_dirent_find_space(const
 	unsigned totlen = be16_to_cpu(dent->de_rec_len);
 
 	if (gfs2_dirent_sentinel(dent))
-		actual = GFS2_DIRENT_SIZE(0);
+		actual = 0;
 	if (totlen - actual >= required)
 		return 1;
 	return 0;


