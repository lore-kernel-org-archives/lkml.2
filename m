Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761700Ab2FHFLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:11:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43258 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761297Ab2FHFHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:33 -0400
Message-Id: <20120608041841.708907420@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:18:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [ 06/82] cifs: fix oops while traversing open file list (try #4)
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

commit 2c0c2a08bed7a3b791f88d09d16ace56acb3dd98 upstream.

While traversing the linked list of open file handles, if the identfied
file handle is invalid, a reopen is attempted and if it fails, we
resume traversing where we stopped and cifs can oops while accessing
invalid next element, for list might have changed.

So mark the invalid file handle and attempt reopen if no
valid file handle is found in rest of the list.
If reopen fails, move the invalid file handle to the end of the list
and start traversing the list again from the begining.
Repeat this four times before giving up and returning an error if
file reopen keeps failing.

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/cifsglob.h |    1 +
 fs/cifs/file.c     |   57 ++++++++++++++++++++++++++++++----------------------
 2 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index c0a027e..20350a9 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -43,6 +43,7 @@
 
 #define CIFS_MIN_RCV_POOL 4
 
+#define MAX_REOPEN_ATT	5 /* these many maximum attempts to reopen a file */
 /*
  * default attribute cache timeout (jiffies)
  */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ed9b5a8..253170d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1565,10 +1565,11 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
 					bool fsuid_only)
 {
-	struct cifsFileInfo *open_file;
+	struct cifsFileInfo *open_file, *inv_file = NULL;
 	struct cifs_sb_info *cifs_sb;
 	bool any_available = false;
 	int rc;
+	unsigned int refind = 0;
 
 	/* Having a null inode here (because mapping->host was set to zero by
 	the VFS or MM) should not happen but we had reports of on oops (due to
@@ -1588,40 +1589,25 @@ struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
 
 	spin_lock(&cifs_file_list_lock);
 refind_writable:
+	if (refind > MAX_REOPEN_ATT) {
+		spin_unlock(&cifs_file_list_lock);
+		return NULL;
+	}
 	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
 		if (!any_available && open_file->pid != current->tgid)
 			continue;
 		if (fsuid_only && open_file->uid != current_fsuid())
 			continue;
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
-			cifsFileInfo_get(open_file);
-
 			if (!open_file->invalidHandle) {
 				/* found a good writable file */
+				cifsFileInfo_get(open_file);
 				spin_unlock(&cifs_file_list_lock);
 				return open_file;
+			} else {
+				if (!inv_file)
+					inv_file = open_file;
 			}
-
-			spin_unlock(&cifs_file_list_lock);
-
-			/* Had to unlock since following call can block */
-			rc = cifs_reopen_file(open_file, false);
-			if (!rc)
-				return open_file;
-
-			/* if it fails, try another handle if possible */
-			cFYI(1, "wp failed on reopen file");
-			cifsFileInfo_put(open_file);
-
-			spin_lock(&cifs_file_list_lock);
-
-			/* else we simply continue to the next entry. Thus
-			   we do not loop on reopen errors.  If we
-			   can not reopen the file, for example if we
-			   reconnected to a server with another client
-			   racing to delete or lock the file we would not
-			   make progress if we restarted before the beginning
-			   of the loop here. */
 		}
 	}
 	/* couldn't find useable FH with same pid, try any available */
@@ -1629,7 +1615,30 @@ refind_writable:
 		any_available = true;
 		goto refind_writable;
 	}
+
+	if (inv_file) {
+		any_available = false;
+		cifsFileInfo_get(inv_file);
+	}
+
 	spin_unlock(&cifs_file_list_lock);
+
+	if (inv_file) {
+		rc = cifs_reopen_file(inv_file, false);
+		if (!rc)
+			return inv_file;
+		else {
+			spin_lock(&cifs_file_list_lock);
+			list_move_tail(&inv_file->flist,
+					&cifs_inode->openFileList);
+			spin_unlock(&cifs_file_list_lock);
+			cifsFileInfo_put(inv_file);
+			spin_lock(&cifs_file_list_lock);
+			++refind;
+			goto refind_writable;
+		}
+	}
+
 	return NULL;
 }
 


