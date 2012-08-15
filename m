Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab2HOTtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:49:10 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62728 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab2HOTtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 011/165] cifs: fix dentry refcount leak when opening a FIFO on lookup
Date: Wed, 15 Aug 2012 15:45:55 -0400
Message-ID: <1345060109-9187-12-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 5bccda0ebc7c0331b81ac47d39e4b920b198b2cd upstream.

The cifs code will attempt to open files on lookup under certain
circumstances. What happens though if we find that the file we opened
was actually a FIFO or other special file?

Currently, the open filehandle just ends up being leaked leading to
a dentry refcount mismatch and oops on umount. Fix this by having the
code close the filehandle on the server if it turns out not to be a
regular file. While we're at it, change this spaghetti if statement
into a switch too.

Reported-by: CAI Qian <caiqian@redhat.com>
Tested-by: CAI Qian <caiqian@redhat.com>
Reviewed-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/cifs/dir.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index ff3d891..fc79b95 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -692,10 +692,26 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
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
-- 
1.7.12.rc2

