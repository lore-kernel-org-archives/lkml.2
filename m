Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760352Ab0G3TA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:00:56 -0400
Received: from kroah.org ([198.145.64.141]:51748 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405Ab0G3RTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:04 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:07 2010
Message-Id: <20100730171507.084356788@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Surbhi Palande <surbhi.palande@canonical.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [082/165] ext4: replace BUG() with return -EIO in ext4_ext_get_blocks
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 034fb4c95fc0fed4ec4a50778127b92c6f2aec01 upstream (as of v2.6.33-rc3)

This patch fixes the Kernel BZ #14286.  When the address of an extent
corresponding to a valid block is corrupted, a -EIO should be reported
instead of a BUG().  This situation should not normally not occur
except in the case of a corrupted filesystem.  If however it does,
then the system should not panic directly but depending on the mount
time options appropriate action should be taken. If the mount options
so permit, the I/O should be gracefully aborted by returning a -EIO.

http://bugzilla.kernel.org/show_bug.cgi?id=14286

Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/extents.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3196,7 +3196,13 @@ int ext4_ext_get_blocks(handle_t *handle
 	 * this situation is possible, though, _during_ tree modification;
 	 * this is why assert can't be put in ext4_ext_find_extent()
 	 */
-	BUG_ON(path[depth].p_ext == NULL && depth != 0);
+	if (path[depth].p_ext == NULL && depth != 0) {
+		ext4_error(inode->i_sb, __func__, "bad extent address "
+			   "inode: %lu, iblock: %d, depth: %d",
+			   inode->i_ino, iblock, depth);
+		err = -EIO;
+		goto out2;
+	}
 	eh = path[depth].p_hdr;
 
 	ex = path[depth].p_ext;


