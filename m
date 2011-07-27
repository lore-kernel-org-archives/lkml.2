Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab1G0AfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:35:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:18089 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab1G0AfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="32380310"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: Trond.Myklebust@netapp.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [17/98] NFSv4.1: Ensure state manager thread dies on last umount
Message-Id: <20110727003509.46A912403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 47c2199b6eb5fbe38ddb844db7cdbd914d304f9c upstream.

Currently, the state manager may continue to try recovering state forever
even after the last filesystem to reference that nfs_client has umounted.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfs/nfs4state.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/fs/nfs/nfs4state.c
===================================================================
--- linux-2.6.35.y.orig/fs/nfs/nfs4state.c
+++ linux-2.6.35.y/fs/nfs/nfs4state.c
@@ -1410,7 +1410,7 @@ static void nfs4_state_manager(struct nf
 	int status = 0;
 
 	/* Ensure exclusive access to NFSv4 state */
-	for(;;) {
+	do {
 		if (test_and_clear_bit(NFS4CLNT_LEASE_EXPIRED, &clp->cl_state)) {
 			/* We're going to have to re-establish a clientid */
 			status = nfs4_reclaim_lease(clp);
@@ -1493,7 +1493,7 @@ static void nfs4_state_manager(struct nf
 			break;
 		if (test_and_set_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state) != 0)
 			break;
-	}
+	} while (atomic_read(&clp->cl_count) > 1);
 	return;
 out_error:
 	printk(KERN_WARNING "Error: state manager failed on NFSv4 server %s"
