Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab2AXC5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:57:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661Ab2AXCrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:47:21 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:30 2012
Message-Id: <20120124023930.032997450@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@redhat.com>
Subject: [069/129] nfsd4: fix lockowner matching
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1592
Lines: 53

From: "J. Bruce Fields" <bfields@redhat.com>

commit b93d87c19821ba7d3ee11557403d782e541071ad upstream.

Lockowners are looked up by file as well as by owner, but we were
forgetting to do a comparison on the file.  This could cause an
incorrect result from lockt.

(Note looking up the inode from the lockowner is pretty awkward here.
The data structures need fixing.)

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4state.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3809,16 +3809,29 @@ nevermind:
 		deny->ld_type = NFS4_WRITE_LT;
 }
 
+static bool same_lockowner_ino(struct nfs4_lockowner *lo, struct inode *inode, clientid_t *clid, struct xdr_netobj *owner)
+{
+	struct nfs4_ol_stateid *lst;
+
+	if (!same_owner_str(&lo->lo_owner, owner, clid))
+		return false;
+	lst = list_first_entry(&lo->lo_owner.so_stateids,
+			       struct nfs4_ol_stateid, st_perstateowner);
+	return lst->st_file->fi_inode == inode;
+}
+
 static struct nfs4_lockowner *
 find_lockowner_str(struct inode *inode, clientid_t *clid,
 		struct xdr_netobj *owner)
 {
 	unsigned int hashval = lock_ownerstr_hashval(inode, clid->cl_id, owner);
+	struct nfs4_lockowner *lo;
 	struct nfs4_stateowner *op;
 
 	list_for_each_entry(op, &lock_ownerstr_hashtbl[hashval], so_strhash) {
-		if (same_owner_str(op, owner, clid))
-			return lockowner(op);
+		lo = lockowner(op);
+		if (same_lockowner_ino(lo, inode, clid, owner))
+			return lo;
 	}
 	return NULL;
 }


