Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936084Ab1KJELi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:11:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965597Ab1KJDn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:43:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:59 2011
Message-Id: <20111109213159.212094162@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Darrick J. Wong" <djwong@us.ibm.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [169/264] ext4: ext4_rename should dirty dir_bh with the correct directory
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@us.ibm.com>

commit bcaa992975041e40449be8c010c26192b8c8b409 upstream.

When ext4_rename performs a directory rename (move), dir_bh is a
buffer that is modified to update the '..' link in the directory being
moved (old_inode).  However, ext4_handle_dirty_metadata is called with
the old parent directory inode (old_dir) and dir_bh, which is
incorrect because dir_bh does not belong to the parent inode.  Fix
this error.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2530,7 +2530,7 @@ static int ext4_rename(struct inode *old
 		PARENT_INO(dir_bh->b_data, new_dir->i_sb->s_blocksize) =
 						cpu_to_le32(new_dir->i_ino);
 		BUFFER_TRACE(dir_bh, "call ext4_handle_dirty_metadata");
-		retval = ext4_handle_dirty_metadata(handle, old_dir, dir_bh);
+		retval = ext4_handle_dirty_metadata(handle, old_inode, dir_bh);
 		if (retval) {
 			ext4_std_error(old_dir->i_sb, retval);
 			goto end_rename;


