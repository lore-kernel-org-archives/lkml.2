Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565Ab0GTUfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:35:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:38629 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757653Ab0GTUfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:35:46 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, dhowells@redhat.com, sfrench@samba.org,
        anton@samba.org, swhiteho@redhat.com, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/7] cifs: use workqueue instead of slow-work
Date: Tue, 20 Jul 2010 22:34:59 +0200
Message-Id: <1279658102-20069-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279658102-20069-1-git-send-email-tj@kernel.org>
References: <1279658102-20069-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 20:35:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueue can now handle high concurrency.  Use system_nrt_wq
instead of slow-work.

* Updated is_valid_oplock_break() to not call cifs_oplock_break_put()
  as advised by Steve French.  It might cause deadlock.  Instead,
  reference is increased after queueing succeeded and
  cifs_oplock_break() briefly grabs GlobalSMBSeslock before putting
  the cfile to make sure it doesn't put before the matching get is
  finished.

* Anton Blanchard reported that cifs conversion was using now gone
  system_single_wq.  Use system_nrt_wq which provides non-reentrance
  guarantee which is enough and much better.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Steve French <sfrench@samba.org>
Cc: Anton Blanchard <anton@samba.org>
---
 fs/cifs/Kconfig    |    1 -
 fs/cifs/cifsfs.c   |    5 -----
 fs/cifs/cifsglob.h |    8 +++++---
 fs/cifs/dir.c      |    2 +-
 fs/cifs/file.c     |   30 +++++++++++++-----------------
 fs/cifs/misc.c     |   20 ++++++++++++--------
 6 files changed, 31 insertions(+), 35 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 80f3525..6994a0f 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -2,7 +2,6 @@ config CIFS
 	tristate "CIFS support (advanced network filesystem, SMBFS successor)"
 	depends on INET
 	select NLS
-	select SLOW_WORK
 	help
 	  This is the client VFS module for the Common Internet File System
 	  (CIFS) protocol which is the successor to the Server Message Block
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 78c02eb..4c07517 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -917,15 +917,10 @@ init_cifs(void)
 	if (rc)
 		goto out_unregister_key_type;
 #endif
-	rc = slow_work_register_user(THIS_MODULE);
-	if (rc)
-		goto out_unregister_resolver_key;
 
 	return 0;
 
- out_unregister_resolver_key:
 #ifdef CONFIG_CIFS_DFS_UPCALL
-	unregister_key_type(&key_type_dns_resolver);
  out_unregister_key_type:
 #endif
 #ifdef CONFIG_CIFS_UPCALL
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a88479c..f5a1f9b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -19,7 +19,7 @@
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <linux/slab.h>
-#include <linux/slow-work.h>
+#include <linux/workqueue.h>
 #include "cifs_fs_sb.h"
 #include "cifsacl.h"
 /*
@@ -363,7 +363,7 @@ struct cifsFileInfo {
 	atomic_t count;		/* reference count */
 	struct mutex fh_mutex; /* prevents reopen race after dead ses*/
 	struct cifs_search_info srch_inf;
-	struct slow_work oplock_break; /* slow_work job for oplock breaks */
+	struct work_struct oplock_break; /* work for oplock breaks */
 };
 
 /* Take a reference on the file private data */
@@ -732,4 +732,6 @@ GLOBAL_EXTERN unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
 GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
 GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
 
-extern const struct slow_work_ops cifs_oplock_break_ops;
+void cifs_oplock_break(struct work_struct *work);
+void cifs_oplock_break_get(struct cifsFileInfo *cfile);
+void cifs_oplock_break_put(struct cifsFileInfo *cfile);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 391816b..b066e73 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -162,7 +162,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
 	mutex_init(&pCifsFile->lock_mutex);
 	INIT_LIST_HEAD(&pCifsFile->llist);
 	atomic_set(&pCifsFile->count, 1);
-	slow_work_init(&pCifsFile->oplock_break, &cifs_oplock_break_ops);
+	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
 
 	write_lock(&GlobalSMBSeslock);
 	list_add(&pCifsFile->tlist, &cifs_sb->tcon->openFileList);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 75541af..e767bfa 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2295,8 +2295,7 @@ out:
 	return rc;
 }
 
-static void
-cifs_oplock_break(struct slow_work *work)
+void cifs_oplock_break(struct work_struct *work)
 {
 	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
 						  oplock_break);
@@ -2333,33 +2332,30 @@ cifs_oplock_break(struct slow_work *work)
 				 LOCKING_ANDX_OPLOCK_RELEASE, false);
 		cFYI(1, "Oplock release rc = %d", rc);
 	}
+
+	/*
+	 * We might have kicked in before is_valid_oplock_break()
+	 * finished grabbing reference for us.  Make sure it's done by
+	 * waiting for GlobalSMSSeslock.
+	 */
+	write_lock(&GlobalSMBSeslock);
+	write_unlock(&GlobalSMBSeslock);
+
+	cifs_oplock_break_put(cfile);
 }
 
-static int
-cifs_oplock_break_get(struct slow_work *work)
+void cifs_oplock_break_get(struct cifsFileInfo *cfile)
 {
-	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
-						  oplock_break);
 	mntget(cfile->mnt);
 	cifsFileInfo_get(cfile);
-	return 0;
 }
 
-static void
-cifs_oplock_break_put(struct slow_work *work)
+void cifs_oplock_break_put(struct cifsFileInfo *cfile)
 {
-	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
-						  oplock_break);
 	mntput(cfile->mnt);
 	cifsFileInfo_put(cfile);
 }
 
-const struct slow_work_ops cifs_oplock_break_ops = {
-	.get_ref	= cifs_oplock_break_get,
-	.put_ref	= cifs_oplock_break_put,
-	.execute	= cifs_oplock_break,
-};
-
 const struct address_space_operations cifs_addr_ops = {
 	.readpage = cifs_readpage,
 	.readpages = cifs_readpages,
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 1394aa3..3ccadc1 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -498,7 +498,6 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 	struct cifsTconInfo *tcon;
 	struct cifsInodeInfo *pCifsInode;
 	struct cifsFileInfo *netfile;
-	int rc;
 
 	cFYI(1, "Checking for oplock break or dnotify response");
 	if ((pSMB->hdr.Command == SMB_COM_NT_TRANSACT) &&
@@ -583,13 +582,18 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 				pCifsInode->clientCanCacheAll = false;
 				if (pSMB->OplockLevel == 0)
 					pCifsInode->clientCanCacheRead = false;
-				rc = slow_work_enqueue(&netfile->oplock_break);
-				if (rc) {
-					cERROR(1, "failed to enqueue oplock "
-						   "break: %d\n", rc);
-				} else {
-					netfile->oplock_break_cancelled = false;
-				}
+
+				/*
+				 * cifs_oplock_break_put() can't be called
+				 * from here.  Get reference after queueing
+				 * succeeded.  cifs_oplock_break() will
+				 * synchronize using GlobalSMSSeslock.
+				 */
+				if (queue_work(system_nrt_wq,
+					       &netfile->oplock_break))
+					cifs_oplock_break_get(netfile);
+				netfile->oplock_break_cancelled = false;
+
 				read_unlock(&GlobalSMBSeslock);
 				read_unlock(&cifs_tcp_ses_lock);
 				return true;
-- 
1.6.4.2

