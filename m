Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719Ab1CZAUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:20:10 -0400
Received: from kroah.org ([198.145.64.141]:41715 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932407Ab1CYXwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:42 2011
Message-Id: <20110325234841.993088964@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:47:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [29/55] nfsd4: fix struct file leak
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

commit 0997b173609b9229ece28941c118a2a9b278796e upstream.

Make sure we properly reference count the struct files that a lock
depends on, and release them when the lock stateid is released.

This fixes a major leak of struct files when using locking over nfsv4.

Reported-by: Rick Koshi <nfs-bug-report@more-right-rudder.com>
Tested-by: Ivo Přikryl <prikryl@eurosat.cz>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4state.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -408,6 +408,9 @@ static void unhash_generic_stateid(struc
 
 static void free_generic_stateid(struct nfs4_stateid *stp)
 {
+	int oflag = nfs4_access_bmap_to_omode(stp);
+
+	nfs4_file_put_access(stp->st_file, oflag);
 	put_nfs4_file(stp->st_file);
 	kmem_cache_free(stateid_slab, stp);
 }
@@ -459,11 +462,8 @@ release_stateid_lockowners(struct nfs4_s
 
 static void release_open_stateid(struct nfs4_stateid *stp)
 {
-	int oflag = nfs4_access_bmap_to_omode(stp);
-
 	unhash_generic_stateid(stp);
 	release_stateid_lockowners(stp);
-	nfs4_file_put_access(stp->st_file, oflag);
 	free_generic_stateid(stp);
 }
 
@@ -3661,6 +3661,7 @@ alloc_init_lock_stateid(struct nfs4_stat
 	stp->st_stateid.si_stateownerid = sop->so_id;
 	stp->st_stateid.si_fileid = fp->fi_id;
 	stp->st_stateid.si_generation = 0;
+	stp->st_access_bmap = 0;
 	stp->st_deny_bmap = open_stp->st_deny_bmap;
 	stp->st_openstp = open_stp;
 
@@ -3675,6 +3676,17 @@ check_lock_length(u64 offset, u64 length
 	     LOFF_OVERFLOW(offset, length)));
 }
 
+static void get_lock_access(struct nfs4_stateid *lock_stp, u32 access)
+{
+	struct nfs4_file *fp = lock_stp->st_file;
+	int oflag = nfs4_access_to_omode(access);
+
+	if (test_bit(access, &lock_stp->st_access_bmap))
+		return;
+	nfs4_file_get_access(fp, oflag);
+	__set_bit(access, &lock_stp->st_access_bmap);
+}
+
 /*
  *  LOCK operation 
  */
@@ -3772,18 +3784,16 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 	switch (lock->lk_type) {
 		case NFS4_READ_LT:
 		case NFS4_READW_LT:
-			if (find_readable_file(lock_stp->st_file)) {
-				nfs4_get_vfs_file(rqstp, fp, &cstate->current_fh, NFS4_SHARE_ACCESS_READ);
-				filp = find_readable_file(lock_stp->st_file);
-			}
+			filp = find_readable_file(lock_stp->st_file);
+			if (filp)
+				get_lock_access(lock_stp, NFS4_SHARE_ACCESS_READ);
 			file_lock.fl_type = F_RDLCK;
 			break;
 		case NFS4_WRITE_LT:
 		case NFS4_WRITEW_LT:
-			if (find_writeable_file(lock_stp->st_file)) {
-				nfs4_get_vfs_file(rqstp, fp, &cstate->current_fh, NFS4_SHARE_ACCESS_WRITE);
-				filp = find_writeable_file(lock_stp->st_file);
-			}
+			filp = find_writeable_file(lock_stp->st_file);
+			if (filp)
+				get_lock_access(lock_stp, NFS4_SHARE_ACCESS_WRITE);
 			file_lock.fl_type = F_WRLCK;
 			break;
 		default:


