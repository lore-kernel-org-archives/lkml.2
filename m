Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163209Ab1FAI2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:28:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:45270 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163191Ab1FAI2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:28:49 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:25 2011
Message-Id: <20110601081224.507640653@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:12:05 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [155/165] NFSv4.1: Fix the handling of NFS4ERR_SEQ_MISORDERED errors
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1201
Lines: 38

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 444f72fe7e7b5f4db34cee933fa3546ebb8e9122 upstream.

Currently, the call to nfs4_schedule_session_recovery() will actually just
result in a test of the lease when what we really want is to force a
session reset.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfs4state.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1466,7 +1466,10 @@ static int nfs4_reclaim_lease(struct nfs
 #ifdef CONFIG_NFS_V4_1
 void nfs4_schedule_session_recovery(struct nfs4_session *session)
 {
-	nfs4_schedule_lease_recovery(session->clp);
+	struct nfs_client *clp = session->clp;
+
+	set_bit(NFS4CLNT_SESSION_RESET, &clp->cl_state);
+	nfs4_schedule_lease_recovery(clp);
 }
 EXPORT_SYMBOL_GPL(nfs4_schedule_session_recovery);
 
@@ -1549,6 +1552,7 @@ static int nfs4_reset_session(struct nfs
 		status = nfs4_recovery_handle_error(clp, status);
 		goto out;
 	}
+	clear_bit(NFS4CLNT_SESSION_RESET, &clp->cl_state);
 	/* create_session negotiated new slot table */
 	clear_bit(NFS4CLNT_RECALL_SLOT, &clp->cl_state);
 


