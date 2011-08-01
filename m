Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1HAX0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:26:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab1HAX0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:26:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:55 2011
Message-Id: <20110801232054.952991052@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [43/70] GFS2: make sure fallocate bytes is a multiple of blksize
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

commit 6905d9e4dda6112f007e9090bca80507da158e63 upstream.

The GFS2 fallocate code chooses a target size to for allocating chunks of
space.  Whenever it can't find any resource groups with enough space free, it
halves its target. Since this target is in bytes, eventually it will no longer
be a multiple of blksize.  As long as there is more space available in the
resource group than the target, this isn't a problem, since gfs2 will use the
actual space available, which is always a multiple of blksize.  However,
when gfs couldn't fallocate a bigger chunk than the target, it was using the
non-blksize aligned number. This caused a BUG in later code that required
blksize aligned offsets.  GFS2 now ensures that bytes is always a multiple of
blksize

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/gfs2/file.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -826,6 +826,7 @@ static long gfs2_fallocate(struct file *
 	loff_t bytes, max_bytes;
 	struct gfs2_alloc *al;
 	int error;
+	loff_t bsize_mask = ~((loff_t)sdp->sd_sb.sb_bsize - 1);
 	loff_t next = (offset + len - 1) >> sdp->sd_sb.sb_bsize_shift;
 	next = (next + 1) << sdp->sd_sb.sb_bsize_shift;
 
@@ -833,13 +834,15 @@ static long gfs2_fallocate(struct file *
 	if (mode & ~FALLOC_FL_KEEP_SIZE)
 		return -EOPNOTSUPP;
 
-	offset = (offset >> sdp->sd_sb.sb_bsize_shift) <<
-		 sdp->sd_sb.sb_bsize_shift;
+	offset &= bsize_mask;
 
 	len = next - offset;
 	bytes = sdp->sd_max_rg_data * sdp->sd_sb.sb_bsize / 2;
 	if (!bytes)
 		bytes = UINT_MAX;
+	bytes &= bsize_mask;
+	if (bytes == 0)
+		bytes = sdp->sd_sb.sb_bsize;
 
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &ip->i_gh);
 	error = gfs2_glock_nq(&ip->i_gh);
@@ -870,6 +873,9 @@ retry:
 		if (error) {
 			if (error == -ENOSPC && bytes > sdp->sd_sb.sb_bsize) {
 				bytes >>= 1;
+				bytes &= bsize_mask;
+				if (bytes == 0)
+					bytes = sdp->sd_sb.sb_bsize;
 				goto retry;
 			}
 			goto out_qunlock;


