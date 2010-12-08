Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab0LHBrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:47:04 -0500
Received: from kroah.org ([198.145.64.141]:48722 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181Ab0LHBAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:09 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:29 2010
Message-Id: <20101208005729.024162903@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [077/289] NFSv4: Dont call nfs4_reclaim_complete() on receiving NFS4ERR_STALE_CLIENTID
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 6eaa61496fb3b93cceface7a296415fc4c030bce upstream.

If the server sends us an NFS4ERR_STALE_CLIENTID while the state management
thread is busy reclaiming state, we do want to treat all state that wasn't
reclaimed before the STALE_CLIENTID as if a network partition occurred (see
the edge conditions described in RFC3530 and RFC5661).
What we do not want to do is to send an nfs4_reclaim_complete(), since we
haven't yet even started reclaiming state after the server rebooted.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfs4state.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1138,16 +1138,14 @@ static void nfs4_reclaim_complete(struct
 		(void)ops->reclaim_complete(clp);
 }
 
-static void nfs4_state_end_reclaim_reboot(struct nfs_client *clp)
+static int nfs4_state_clear_reclaim_reboot(struct nfs_client *clp)
 {
 	struct nfs4_state_owner *sp;
 	struct rb_node *pos;
 	struct nfs4_state *state;
 
 	if (!test_and_clear_bit(NFS4CLNT_RECLAIM_REBOOT, &clp->cl_state))
-		return;
-
-	nfs4_reclaim_complete(clp, clp->cl_mvops->reboot_recovery_ops);
+		return 0;
 
 	for (pos = rb_first(&clp->cl_state_owners); pos != NULL; pos = rb_next(pos)) {
 		sp = rb_entry(pos, struct nfs4_state_owner, so_client_node);
@@ -1161,6 +1159,14 @@ static void nfs4_state_end_reclaim_reboo
 	}
 
 	nfs_delegation_reap_unclaimed(clp);
+	return 1;
+}
+
+static void nfs4_state_end_reclaim_reboot(struct nfs_client *clp)
+{
+	if (!nfs4_state_clear_reclaim_reboot(clp))
+		return;
+	nfs4_reclaim_complete(clp, clp->cl_mvops->reboot_recovery_ops);
 }
 
 static void nfs_delegation_clear_all(struct nfs_client *clp)
@@ -1187,7 +1193,7 @@ static int nfs4_recovery_handle_error(st
 		case -NFS4ERR_STALE_CLIENTID:
 		case -NFS4ERR_LEASE_MOVED:
 			set_bit(NFS4CLNT_LEASE_EXPIRED, &clp->cl_state);
-			nfs4_state_end_reclaim_reboot(clp);
+			nfs4_state_clear_reclaim_reboot(clp);
 			nfs4_state_start_reclaim_reboot(clp);
 			break;
 		case -NFS4ERR_EXPIRED:


