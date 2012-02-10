Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275Ab2BJWuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:50:25 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55384 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021Ab2BJWuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:50:20 -0500
MIME-Version: 1.0
Message-Id: <20120210224851.179969794@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:47:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [04/21] NFSv4: The state manager shouldnt exit on errors that were handled
In-Reply-To: <20120210224858.GA30752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 4f7cdf18e14f81860b856ef7694ef58eb1a751c0 upstream.

nfs4_recovery_handle_error() will correctly handle errors such as
NFS4ERR_CB_PATH_DOWN, however because they are still passed back to the
main loop in nfs4_state_manager(), they can cause the latter to exit
prematurely.

Fix this by letting nfs4_recovery_handle_error() change the error value in
cases where there is no action required by the caller.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4state.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1051,12 +1051,12 @@ static void nfs4_state_end_reclaim_nogra
 	clear_bit(NFS4CLNT_RECLAIM_NOGRACE, &clp->cl_state);
 }
 
-static void nfs4_recovery_handle_error(struct nfs_client *clp, int error)
+static int nfs4_recovery_handle_error(struct nfs_client *clp, int error)
 {
 	switch (error) {
 		case -NFS4ERR_CB_PATH_DOWN:
 			nfs_handle_cb_pathdown(clp);
-			break;
+			return 0;
 		case -NFS4ERR_STALE_CLIENTID:
 		case -NFS4ERR_LEASE_MOVED:
 			set_bit(NFS4CLNT_LEASE_EXPIRED, &clp->cl_state);
@@ -1075,6 +1075,7 @@ static void nfs4_recovery_handle_error(s
 		case -NFS4ERR_SEQ_MISORDERED:
 			set_bit(NFS4CLNT_SESSION_SETUP, &clp->cl_state);
 	}
+	return error;
 }
 
 static int nfs4_do_reclaim(struct nfs_client *clp, const struct nfs4_state_recovery_ops *ops)
@@ -1094,8 +1095,7 @@ restart:
 		if (status < 0) {
 			set_bit(ops->owner_flag_bit, &sp->so_flags);
 			nfs4_put_state_owner(sp);
-			nfs4_recovery_handle_error(clp, status);
-			return status;
+			return nfs4_recovery_handle_error(clp, status);
 		}
 		nfs4_put_state_owner(sp);
 		goto restart;
@@ -1125,8 +1125,7 @@ static int nfs4_check_lease(struct nfs_c
 	status = ops->renew_lease(clp, cred);
 	put_rpccred(cred);
 out:
-	nfs4_recovery_handle_error(clp, status);
-	return status;
+	return nfs4_recovery_handle_error(clp, status);
 }
 
 static int nfs4_reclaim_lease(struct nfs_client *clp)


