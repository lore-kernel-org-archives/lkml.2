Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab1CZAUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:20:45 -0400
Received: from kroah.org ([198.145.64.141]:41589 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401Ab1CYXwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:41 2011
Message-Id: <20110325234841.866369042@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:47:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [28/55] nfsd4: minor nfs4state.c reshuffling
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

commit 529d7b2a7fa31e9f7d08bc790d232c3cbe64fa24 upstream.

Minor cleanup in preparation for a bugfix--moving some code to avoid
forward references, etc.  No change in functionality.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4state.c |  125 +++++++++++++++++++++++++---------------------------
 1 file changed, 61 insertions(+), 64 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -327,64 +327,6 @@ static struct list_head	unconf_id_hashtb
 static struct list_head client_lru;
 static struct list_head close_lru;
 
-static void unhash_generic_stateid(struct nfs4_stateid *stp)
-{
-	list_del(&stp->st_hash);
-	list_del(&stp->st_perfile);
-	list_del(&stp->st_perstateowner);
-}
-
-static void free_generic_stateid(struct nfs4_stateid *stp)
-{
-	put_nfs4_file(stp->st_file);
-	kmem_cache_free(stateid_slab, stp);
-}
-
-static void release_lock_stateid(struct nfs4_stateid *stp)
-{
-	struct file *file;
-
-	unhash_generic_stateid(stp);
-	file = find_any_file(stp->st_file);
-	if (file)
-		locks_remove_posix(file, (fl_owner_t)stp->st_stateowner);
-	free_generic_stateid(stp);
-}
-
-static void unhash_lockowner(struct nfs4_stateowner *sop)
-{
-	struct nfs4_stateid *stp;
-
-	list_del(&sop->so_idhash);
-	list_del(&sop->so_strhash);
-	list_del(&sop->so_perstateid);
-	while (!list_empty(&sop->so_stateids)) {
-		stp = list_first_entry(&sop->so_stateids,
-				struct nfs4_stateid, st_perstateowner);
-		release_lock_stateid(stp);
-	}
-}
-
-static void release_lockowner(struct nfs4_stateowner *sop)
-{
-	unhash_lockowner(sop);
-	nfs4_put_stateowner(sop);
-}
-
-static void
-release_stateid_lockowners(struct nfs4_stateid *open_stp)
-{
-	struct nfs4_stateowner *lock_sop;
-
-	while (!list_empty(&open_stp->st_lockowners)) {
-		lock_sop = list_entry(open_stp->st_lockowners.next,
-				struct nfs4_stateowner, so_perstateid);
-		/* list_del(&open_stp->st_lockowners);  */
-		BUG_ON(lock_sop->so_is_open_owner);
-		release_lockowner(lock_sop);
-	}
-}
-
 /*
  * We store the NONE, READ, WRITE, and BOTH bits separately in the
  * st_{access,deny}_bmap field of the stateid, in order to track not
@@ -457,6 +399,64 @@ static int nfs4_access_bmap_to_omode(str
 	return nfs4_access_to_omode(access);
 }
 
+static void unhash_generic_stateid(struct nfs4_stateid *stp)
+{
+	list_del(&stp->st_hash);
+	list_del(&stp->st_perfile);
+	list_del(&stp->st_perstateowner);
+}
+
+static void free_generic_stateid(struct nfs4_stateid *stp)
+{
+	put_nfs4_file(stp->st_file);
+	kmem_cache_free(stateid_slab, stp);
+}
+
+static void release_lock_stateid(struct nfs4_stateid *stp)
+{
+	struct file *file;
+
+	unhash_generic_stateid(stp);
+	file = find_any_file(stp->st_file);
+	if (file)
+		locks_remove_posix(file, (fl_owner_t)stp->st_stateowner);
+	free_generic_stateid(stp);
+}
+
+static void unhash_lockowner(struct nfs4_stateowner *sop)
+{
+	struct nfs4_stateid *stp;
+
+	list_del(&sop->so_idhash);
+	list_del(&sop->so_strhash);
+	list_del(&sop->so_perstateid);
+	while (!list_empty(&sop->so_stateids)) {
+		stp = list_first_entry(&sop->so_stateids,
+				struct nfs4_stateid, st_perstateowner);
+		release_lock_stateid(stp);
+	}
+}
+
+static void release_lockowner(struct nfs4_stateowner *sop)
+{
+	unhash_lockowner(sop);
+	nfs4_put_stateowner(sop);
+}
+
+static void
+release_stateid_lockowners(struct nfs4_stateid *open_stp)
+{
+	struct nfs4_stateowner *lock_sop;
+
+	while (!list_empty(&open_stp->st_lockowners)) {
+		lock_sop = list_entry(open_stp->st_lockowners.next,
+				struct nfs4_stateowner, so_perstateid);
+		/* list_del(&open_stp->st_lockowners);  */
+		BUG_ON(lock_sop->so_is_open_owner);
+		release_lockowner(lock_sop);
+	}
+}
+
 static void release_open_stateid(struct nfs4_stateid *stp)
 {
 	int oflag = nfs4_access_bmap_to_omode(stp);
@@ -3691,7 +3691,6 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 	struct file_lock conflock;
 	__be32 status = 0;
 	unsigned int strhashval;
-	unsigned int cmd;
 	int err;
 
 	dprintk("NFSD: nfsd4_lock: start=%Ld length=%Ld\n",
@@ -3778,8 +3777,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 				filp = find_readable_file(lock_stp->st_file);
 			}
 			file_lock.fl_type = F_RDLCK;
-			cmd = F_SETLK;
-		break;
+			break;
 		case NFS4_WRITE_LT:
 		case NFS4_WRITEW_LT:
 			if (find_writeable_file(lock_stp->st_file)) {
@@ -3787,8 +3785,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 				filp = find_writeable_file(lock_stp->st_file);
 			}
 			file_lock.fl_type = F_WRLCK;
-			cmd = F_SETLK;
-		break;
+			break;
 		default:
 			status = nfserr_inval;
 		goto out;
@@ -3812,7 +3809,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 	* Note: locks.c uses the BKL to protect the inode's lock list.
 	*/
 
-	err = vfs_lock_file(filp, cmd, &file_lock, &conflock);
+	err = vfs_lock_file(filp, F_SETLK, &file_lock, &conflock);
 	switch (-err) {
 	case 0: /* success! */
 		update_stateid(&lock_stp->st_stateid);


