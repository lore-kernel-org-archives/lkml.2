Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab2CLAt0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:49:26 -0400
Received: from 1wt.eu ([62.212.114.60]:63044 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568Ab2CLAsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:48:18 -0400
Message-Id: <20120312002046.242691731@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:20:52 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>
Subject: [ 07/12] cifs: fix dentry refcount leak when opening a FIFO on lookup
In-Reply-To: <feb44625a10a45049eddf27890e95d54@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 5bccda0ebc7c0331b81ac47d39e4b920b198b2cd upstream.

The cifs code will attempt to open files on lookup under certain
circumstances. What happens though if we find that the file we opened
was actually a FIFO or other special file?

Currently, the open filehandle just ends up being leaked leading to
a dentry refcount mismatch and oops on umount. Fix this by having the
code close the filehandle on the server if it turns out not to be a
regular file. While we're at it, change this spaghetti if statement
into a switch too.

Cc: stable@vger.kernel.org
Reported-by: CAI Qian <caiqian@redhat.com>
Tested-by: CAI Qian <caiqian@redhat.com>
Reviewed-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 63a196b..bc7e244 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -584,10 +584,26 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 			 * If either that or op not supported returned, follow
 			 * the normal lookup.
 			 */
-			if ((rc == 0) || (rc == -ENOENT))
+			switch (rc) {
+			case 0:
+				/*
+				 * The server may allow us to open things like
+				 * FIFOs, but the client isn't set up to deal
+				 * with that. If it's not a regular file, just
+				 * close it and proceed as if it were a normal
+				 * lookup.
+				 */
+				if (newInode && !S_ISREG(newInode->i_mode)) {
+					CIFSSMBClose(xid, pTcon, fileHandle);
+					break;
+				}
+			case -ENOENT:
 				posix_open = true;
-			else if ((rc == -EINVAL) || (rc != -EOPNOTSUPP))
+			case -EOPNOTSUPP:
+				break;
+			default:
 				pTcon->broken_posix_open = true;
+			}
 		}
 		if (!posix_open)
 			rc = cifs_get_inode_info_unix(&newInode, full_path,


