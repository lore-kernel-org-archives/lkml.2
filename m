Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761806Ab2FHFST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:18:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43251 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761205Ab2FHFHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:25 -0400
Message-Id: <20120608041845.945062242@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andreas Dilger <adilger@dilger.ca>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 38/82] ext4: disallow hard-linked directory in ext4_lookup
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Dilger <adilger@dilger.ca>

commit 7e936b737211e6b54e34b71a827e56b872e958d8 upstream.

A hard-linked directory to its parent can cause the VFS to deadlock,
and is a sign of a corrupted file system.  So detect this case in
ext4_lookup(), before the rmdir() lockup scenario can take place.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/namei.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a9fd5f4..daf8260 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1330,6 +1330,12 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, stru
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


