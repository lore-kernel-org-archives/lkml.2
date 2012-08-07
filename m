Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab2HGWaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:30:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34616 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684Ab2HGWan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:30:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>
Subject: [ 071/122] cifs: ensure that we always do cifsFileInfo_get under the spinlock
Date: Tue,  7 Aug 2012 15:25:59 -0700
Message-Id: <20120807221954.959761503@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 764a1b1acecedfe204cb2e80d8e2cc7c6df1b0b8 upstream.

The readpages bug is a regression that was introduced in 6993f74a5.
This also fixes a couple of similar bugs in the uncached read and write
codepaths.

Also, prevent this sort of thing in the future by having cifsFileInfo_get
take the spinlock itself, and adding a _locked variant for use in places
that are already holding the lock. The _put code has always done that
so this makes for a less confusing interface.

Reviewed-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifsglob.h |    6 +++---
 fs/cifs/file.c     |   17 ++++++++++++-----
 2 files changed, 15 insertions(+), 8 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -657,13 +657,13 @@ struct cifs_io_parms {
  * Take a reference on the file private data. Must be called with
  * cifs_file_list_lock held.
  */
-static inline
-struct cifsFileInfo *cifsFileInfo_get(struct cifsFileInfo *cifs_file)
+static inline void
+cifsFileInfo_get_locked(struct cifsFileInfo *cifs_file)
 {
 	++cifs_file->count;
-	return cifs_file;
 }
 
+struct cifsFileInfo *cifsFileInfo_get(struct cifsFileInfo *cifs_file);
 void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
 
 /*
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -284,6 +284,15 @@ cifs_new_fileinfo(__u16 fileHandle, stru
 
 static void cifs_del_lock_waiters(struct cifsLockInfo *lock);
 
+struct cifsFileInfo *
+cifsFileInfo_get(struct cifsFileInfo *cifs_file)
+{
+	spin_lock(&cifs_file_list_lock);
+	cifsFileInfo_get_locked(cifs_file);
+	spin_unlock(&cifs_file_list_lock);
+	return cifs_file;
+}
+
 /*
  * Release a reference on the file private data. This may involve closing
  * the filehandle out on the server. Must be called without holding
@@ -1563,7 +1572,7 @@ struct cifsFileInfo *find_readable_file(
 			if (!open_file->invalidHandle) {
 				/* found a good file */
 				/* lock it so it will not be closed on us */
-				cifsFileInfo_get(open_file);
+				cifsFileInfo_get_locked(open_file);
 				spin_unlock(&cifs_file_list_lock);
 				return open_file;
 			} /* else might as well continue, and look for
@@ -1615,7 +1624,7 @@ refind_writable:
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
 			if (!open_file->invalidHandle) {
 				/* found a good writable file */
-				cifsFileInfo_get(open_file);
+				cifsFileInfo_get_locked(open_file);
 				spin_unlock(&cifs_file_list_lock);
 				return open_file;
 			} else {
@@ -1632,7 +1641,7 @@ refind_writable:
 
 	if (inv_file) {
 		any_available = false;
-		cifsFileInfo_get(inv_file);
+		cifsFileInfo_get_locked(inv_file);
 	}
 
 	spin_unlock(&cifs_file_list_lock);
@@ -3082,8 +3091,6 @@ static int cifs_readpages(struct file *f
 			break;
 		}
 
-		spin_lock(&cifs_file_list_lock);
-		spin_unlock(&cifs_file_list_lock);
 		rdata->cfile = cifsFileInfo_get(open_file);
 		rdata->mapping = mapping;
 		rdata->offset = offset;


