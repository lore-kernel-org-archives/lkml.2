Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab2FGEUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:20:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978Ab2FGEUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:20:41 -0400
Message-Id: <20120607040345.410323140@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:38 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andreas Dilger <adilger@dilger.ca>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 62/82] ext4: disallow hard-linked directory in ext4_lookup
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Dilger <adilger@dilger.ca>

commit 7e936b737211e6b54e34b71a827e56b872e958d8 upstream.

A hard-linked directory to its parent can cause the VFS to deadlock,
and is a sign of a corrupted file system.  So detect this case in
ext4_lookup(), before the rmdir() lockup scenario can take place.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/namei.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1037,6 +1037,12 @@ static struct dentry *ext4_lookup(struct
 			EXT4_ERROR_INODE(dir, "bad inode number: %u", ino);
 			return ERR_PTR(-EIO);
 		}
+		if (unlikely(ino == dir->i_ino)) {
+			EXT4_ERROR_INODE(dir, "'%.*s' linked to parent dir",
+					 dentry->d_name.len,
+					 dentry->d_name.name);
+			return ERR_PTR(-EIO);
+		}
 		inode = ext4_iget(dir->i_sb, ino);
 		if (inode == ERR_PTR(-ESTALE)) {
 			EXT4_ERROR_INODE(dir,


