Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315Ab2BJWvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:51:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55384 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933305Ab2BJWug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:50:36 -0500
MIME-Version: 1.0
Message-Id: <20120210224851.078179929@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:47:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [03/21] NFSv4: Fix up the callers of nfs4_state_end_reclaim_reboot
In-Reply-To: <20120210224858.GA30752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit e345e88a774875cec26e097ea3ff2dc40c4f9da2 upstream.

In practice, we need to ensure that we call nfs4_state_end_reclaim_reboot
in 2 cases:

 - If we lose the lease while we were reclaiming state
OR
 - After we're done with reboot recovery

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4state.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1060,6 +1060,7 @@ static void nfs4_recovery_handle_error(s
 		case -NFS4ERR_STALE_CLIENTID:
 		case -NFS4ERR_LEASE_MOVED:
 			set_bit(NFS4CLNT_LEASE_EXPIRED, &clp->cl_state);
+			nfs4_state_end_reclaim_reboot(clp);
 			nfs4_state_start_reclaim_reboot(clp);
 			break;
 		case -NFS4ERR_EXPIRED:
@@ -1263,7 +1264,7 @@ static void nfs4_state_manager(struct nf
 			}
 		}
 		/* First recover reboot state... */
-		if (test_and_clear_bit(NFS4CLNT_RECLAIM_REBOOT, &clp->cl_state)) {
+		if (test_bit(NFS4CLNT_RECLAIM_REBOOT, &clp->cl_state)) {
 			status = nfs4_do_reclaim(clp,
 				nfs4_reboot_recovery_ops[clp->cl_minorversion]);
 			if (status == -NFS4ERR_STALE_CLIENTID)
@@ -1309,8 +1310,6 @@ static void nfs4_state_manager(struct nf
 out_error:
 	printk(KERN_WARNING "Error: state manager failed on NFSv4 server %s"
 			" with error %d\n", clp->cl_hostname, -status);
-	if (test_bit(NFS4CLNT_RECLAIM_REBOOT, &clp->cl_state))
-		nfs4_state_end_reclaim_reboot(clp);
 	nfs4_clear_state_manager_bit(clp);
 }
 


