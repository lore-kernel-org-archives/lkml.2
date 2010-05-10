Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab0EJXNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:13:51 -0400
Received: from kroah.org ([198.145.64.141]:45259 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932900Ab0EJW6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:17 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:40 2010
Message-Id: <20100510223540.159779581@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bill Pemberton <wfp5p@virginia.edu>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       jfs-discussion@lists.sourceforge.net
Subject: [64/98] jfs: fix diAllocExt error in resizing filesystem
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bill Pemberton <wfp5p@virginia.edu>

commit 2b0b39517d1af5294128dbc2fd7ed39c8effa540 upstream.

Resizing the filesystem would result in an diAllocExt error in some
instances because changes in bmp->db_agsize would not get noticed if
goto extendBmap was called.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: jfs-discussion@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jfs/resize.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/jfs/resize.c
+++ b/fs/jfs/resize.c
@@ -81,6 +81,7 @@ int jfs_extendfs(struct super_block *sb,
 	struct inode *iplist[1];
 	struct jfs_superblock *j_sb, *j_sb2;
 	uint old_agsize;
+	int agsizechanged = 0;
 	struct buffer_head *bh, *bh2;
 
 	/* If the volume hasn't grown, get out now */
@@ -333,6 +334,9 @@ int jfs_extendfs(struct super_block *sb,
 	 */
 	if ((rc = dbExtendFS(ipbmap, XAddress, nblocks)))
 		goto error_out;
+
+	agsizechanged |= (bmp->db_agsize != old_agsize);
+
 	/*
 	 * the map now has extended to cover additional nblocks:
 	 * dn_mapsize = oldMapsize + nblocks;
@@ -432,7 +436,7 @@ int jfs_extendfs(struct super_block *sb,
 	 * will correctly identify the new ag);
 	 */
 	/* if new AG size the same as old AG size, done! */
-	if (bmp->db_agsize != old_agsize) {
+	if (agsizechanged) {
 		if ((rc = diExtendFS(ipimap, ipbmap)))
 			goto error_out;
 


