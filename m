Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab0DUUDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:03:19 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40177 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab0DUUCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:02:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 4/5] NFSv4: Fix the locking in nfs_inode_reclaim_delegation()
Date: Wed, 21 Apr 2010 13:02:10 -0700
Message-Id: <1271880131-3951-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100421200150.GA3818@linux.vnet.ibm.com>
References: <20100421200150.GA3818@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

Ensure that we correctly rcu-dereference the delegation itself, and that we
protect against removal while we're changing the contents.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 fs/nfs/delegation.c |   42 ++++++++++++++++++++++++++++--------------
 1 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 1567124..8d9ec49 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -129,21 +129,35 @@ again:
  */
 void nfs_inode_reclaim_delegation(struct inode *inode, struct rpc_cred *cred, struct nfs_openres *res)
 {
-	struct nfs_delegation *delegation = NFS_I(inode)->delegation;
-	struct rpc_cred *oldcred;
+	struct nfs_delegation *delegation;
+	struct rpc_cred *oldcred = NULL;
 
-	if (delegation == NULL)
-		return;
-	memcpy(delegation->stateid.data, res->delegation.data,
-			sizeof(delegation->stateid.data));
-	delegation->type = res->delegation_type;
-	delegation->maxsize = res->maxsize;
-	oldcred = delegation->cred;
-	delegation->cred = get_rpccred(cred);
-	clear_bit(NFS_DELEGATION_NEED_RECLAIM, &delegation->flags);
-	NFS_I(inode)->delegation_state = delegation->type;
-	smp_wmb();
-	put_rpccred(oldcred);
+	rcu_read_lock();
+	delegation = rcu_dereference(NFS_I(inode)->delegation);
+	if (delegation != NULL) {
+		spin_lock(&delegation->lock);
+		if (delegation->inode != NULL) {
+			memcpy(delegation->stateid.data, res->delegation.data,
+			       sizeof(delegation->stateid.data));
+			delegation->type = res->delegation_type;
+			delegation->maxsize = res->maxsize;
+			oldcred = delegation->cred;
+			delegation->cred = get_rpccred(cred);
+			clear_bit(NFS_DELEGATION_NEED_RECLAIM,
+				  &delegation->flags);
+			NFS_I(inode)->delegation_state = delegation->type;
+			spin_unlock(&delegation->lock);
+			put_rpccred(oldcred);
+			rcu_read_unlock();
+		} else {
+			/* We appear to have raced with a delegation return. */
+			spin_unlock(&delegation->lock);
+			rcu_read_unlock();
+			nfs_inode_set_delegation(inode, cred, res);
+		}
+	} else {
+		rcu_read_unlock();
+	}
 }
 
 static int nfs_do_return_delegation(struct inode *inode, struct nfs_delegation *delegation, int issync)
-- 
1.7.0

