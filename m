Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248Ab2CMAv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:51:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:48028 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758832Ab2CMAXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 104/196] NFSv4.1: Ensure state manager thread dies on last umount
Date: Mon, 12 Mar 2012 20:20:17 -0400
Message-Id: <1331598109-31424-59-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 47c2199b6eb5fbe38ddb844db7cdbd914d304f9c upstream.

Currently, the state manager may continue to try recovering state forever
even after the last filesystem to reference that nfs_client has umounted.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfs/nfs4state.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 6c5ed51..c03bdcc 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1399,7 +1399,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 	int status = 0;
 
 	/* Ensure exclusive access to NFSv4 state */
-	for(;;) {
+	do {
 		if (test_and_clear_bit(NFS4CLNT_LEASE_EXPIRED, &clp->cl_state)) {
 			/* We're going to have to re-establish a clientid */
 			status = nfs4_reclaim_lease(clp);
@@ -1482,7 +1482,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			break;
 		if (test_and_set_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state) != 0)
 			break;
-	}
+	} while (atomic_read(&clp->cl_count) > 1);
 	return;
 out_error:
 	printk(KERN_WARNING "Error: state manager failed on NFSv4 server %s"
-- 
1.7.9.3

