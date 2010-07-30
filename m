Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329Ab0G3ReM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:34:12 -0400
Received: from kroah.org ([198.145.64.141]:51877 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758663Ab0G3RTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:23 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:08 2010
Message-Id: <20100730171508.663721228@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [100/165] ext4: make "offset" consistent in ext4_check_dir_entry()
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit b8b8afe236e97b6359d46d3a3f8c46455e192271 upstream (as of v2.6.33-git11)

The callers of ext4_check_dir_entry() usually pass in the "file
offset" (ext4_readdir, htree_dirblock_to_tree, search_dirblock,
ext4_dx_find_entry, empty_dir), but a few callers (add_dirent_to_buf,
ext4_delete_entry) only pass in the buffer offset.

To accomodate those last two (which would be hard to fix otherwise),
this patch changes ext4_check_dir_entry() to print the physical block
number and the relative offset as well as the passed-in offset.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/dir.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -84,9 +84,11 @@ int ext4_check_dir_entry(const char *fun
 
 	if (error_msg != NULL)
 		ext4_error(dir->i_sb, function,
-			"bad entry in directory #%lu: %s - "
-			"offset=%u, inode=%u, rec_len=%d, name_len=%d",
-			dir->i_ino, error_msg, offset,
+			"bad entry in directory #%lu: %s - block=%llu"
+			"offset=%u(%u), inode=%u, rec_len=%d, name_len=%d",
+			dir->i_ino, error_msg,
+			(unsigned long long) bh->b_blocknr,
+			(unsigned) (offset%bh->b_size), offset,
 			le32_to_cpu(de->inode),
 			rlen, de->name_len);
 	return error_msg == NULL ? 1 : 0;


