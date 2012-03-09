Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031669Ab2CITw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:52:29 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47667 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031625Ab2CITwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:52:20 -0500
Message-Id: <20120309190217.059573677@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, CAI Qian <caiqian@redhat.com>,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>
Subject: [ 26/68] cifs: fix dentry refcount leak when opening a FIFO on lookup
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

Reported-by: CAI Qian <caiqian@redhat.com>
Tested-by: CAI Qian <caiqian@redhat.com>
Reviewed-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/dir.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -583,10 +583,26 @@ cifs_lookup(struct inode *parent_dir_ino
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


