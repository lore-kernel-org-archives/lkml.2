Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab1HCXaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:30:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33920 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab1HCX3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:29:21 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:52 2011
Message-Id: <20110803221251.977690774@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [079/102] NFSv4: Dont use the delegation->inode in nfs_mark_return_delegation()
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit ed1e6211a0a134ff23592c6f057af982ad5dab52 upstream.

nfs_mark_return_delegation() is usually called without any locking, and
so it is not safe to dereference delegation->inode. Since the inode is
only used to discover the nfs_client anyway, it makes more sense to
have the callers pass a valid pointer to the nfs_server as a parameter.

Reported-by: Ian Kent <raven@themaw.net>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/delegation.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -398,12 +398,11 @@ int nfs_inode_return_delegation(struct i
 	return err;
 }
 
-static void nfs_mark_return_delegation(struct nfs_delegation *delegation)
+static void nfs_mark_return_delegation(struct nfs_server *server,
+		struct nfs_delegation *delegation)
 {
-	struct nfs_client *clp = NFS_SERVER(delegation->inode)->nfs_client;
-
 	set_bit(NFS_DELEGATION_RETURN, &delegation->flags);
-	set_bit(NFS4CLNT_DELEGRETURN, &clp->cl_state);
+	set_bit(NFS4CLNT_DELEGRETURN, &server->nfs_client->cl_state);
 }
 
 /**
@@ -441,7 +440,7 @@ static void nfs_mark_return_all_delegati
 		if ((delegation->type == (FMODE_READ|FMODE_WRITE)) && !(flags & FMODE_WRITE))
 			continue;
 		if (delegation->type & flags)
-			nfs_mark_return_delegation(delegation);
+			nfs_mark_return_delegation(server, delegation);
 	}
 }
 
@@ -508,7 +507,7 @@ static void nfs_mark_return_unreferenced
 	list_for_each_entry_rcu(delegation, &server->delegations, super_list) {
 		if (test_and_clear_bit(NFS_DELEGATION_REFERENCED, &delegation->flags))
 			continue;
-		nfs_mark_return_delegation(delegation);
+		nfs_mark_return_delegation(server, delegation);
 	}
 }
 
@@ -539,7 +538,8 @@ void nfs_expire_unreferenced_delegations
 int nfs_async_inode_return_delegation(struct inode *inode,
 				      const nfs4_stateid *stateid)
 {
-	struct nfs_client *clp = NFS_SERVER(inode)->nfs_client;
+	struct nfs_server *server = NFS_SERVER(inode);
+	struct nfs_client *clp = server->nfs_client;
 	struct nfs_delegation *delegation;
 
 	rcu_read_lock();
@@ -549,7 +549,7 @@ int nfs_async_inode_return_delegation(st
 		rcu_read_unlock();
 		return -ENOENT;
 	}
-	nfs_mark_return_delegation(delegation);
+	nfs_mark_return_delegation(server, delegation);
 	rcu_read_unlock();
 
 	nfs_delegation_run_state_manager(clp);


