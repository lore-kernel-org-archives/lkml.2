Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab0LMA0L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:26:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44787 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab0LLXpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:38 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: Trond.Myklebust@netapp.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [40/223] NFSv4: Don't call nfs4_reclaim_complete() on receiving NFS4ERR_STALE_CLIENTID
Message-Id: <20101212234536.EECCDB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfs/nfs4state.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

Index: linux/fs/nfs/nfs4state.c
===================================================================
--- linux.orig/fs/nfs/nfs4state.c
+++ linux/fs/nfs/nfs4state.c
@@ -1111,17 +1111,14 @@ static void nfs4_reclaim_complete(struct
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
-	nfs4_reclaim_complete(clp,
-		nfs4_reboot_recovery_ops[clp->cl_minorversion]);
+		return 0;
 
 	for (pos = rb_first(&clp->cl_state_owners); pos != NULL; pos = rb_next(pos)) {
 		sp = rb_entry(pos, struct nfs4_state_owner, so_client_node);
@@ -1135,6 +1132,14 @@ static void nfs4_state_end_reclaim_reboo
 	}
 
 	nfs_delegation_reap_unclaimed(clp);
+	return 1;
+}
+
+static void nfs4_state_end_reclaim_reboot(struct nfs_client *clp)
+{
+	if (!nfs4_state_clear_reclaim_reboot(clp))
+		return;
+	nfs4_reclaim_complete(clp, nfs4_reboot_recovery_ops[clp->cl_minorversion]);
 }
 
 static void nfs_delegation_clear_all(struct nfs_client *clp)
@@ -1161,7 +1166,7 @@ static int nfs4_recovery_handle_error(st
 		case -NFS4ERR_STALE_CLIENTID:
 		case -NFS4ERR_LEASE_MOVED:
 			set_bit(NFS4CLNT_LEASE_EXPIRED, &clp->cl_state);
-			nfs4_state_end_reclaim_reboot(clp);
+			nfs4_state_clear_reclaim_reboot(clp);
 			nfs4_state_start_reclaim_reboot(clp);
 			break;
 		case -NFS4ERR_EXPIRED:
