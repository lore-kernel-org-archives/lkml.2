Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab0IRTCB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:01 -0400
Received: from kroah.org ([198.145.64.141]:51165 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab0IRTBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:20 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:54 2010
Message-Id: <20100918185954.353847533@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sunil Mushran <sunil.mushran@oracle.com>
Subject: [018/123] ocfs2: Fix incorrect checksum validation error
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=ocfs2-fix-incorrect-checksum-validation-error.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Mushran <sunil.mushran@oracle.com>

commit f5ce5a08a40f2086435858ddc80cb40394b082eb upstream.

For local mounts, ocfs2_read_locked_inode() calls ocfs2_read_blocks_sync() to
read the inode off the disk. The latter first checks to see if that block is
cached in the journal, and, if so, returns that block. That is ok.

But ocfs2_read_locked_inode() goes wrong when it tries to validate the checksum
of such blocks. Blocks that are cached in the journal may not have had their
checksum computed as yet. We should not validate the checksums of such blocks.

Fixes ossbz#1282
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1282

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Singed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -485,7 +485,11 @@ static int ocfs2_read_locked_inode(struc
 						     OCFS2_BH_IGNORE_CACHE);
 	} else {
 		status = ocfs2_read_blocks_sync(osb, args->fi_blkno, 1, &bh);
-		if (!status)
+		/*
+		 * If buffer is in jbd, then its checksum may not have been
+		 * computed as yet.
+		 */
+		if (!status && !buffer_jbd(bh))
 			status = ocfs2_validate_inode_block(osb->sb, bh);
 	}
 	if (status < 0) {


