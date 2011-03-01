Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab1CAIv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:51:56 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:58617 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab1CAIvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:51:54 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 5/6] net/9p: Convert the in the 9p rpc call path to GFP_NOFS
Date: Tue,  1 Mar 2011 14:21:23 +0530
Message-Id: <1298969484-16199-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298969484-16199-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1298969484-16199-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this we can cause reclaim allocation in writepage.

[ 3433.448430] =================================
[ 3433.449117] [ INFO: inconsistent lock state ]
[ 3433.449117] 2.6.38-rc5+ #84
[ 3433.449117] ---------------------------------
[ 3433.449117] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
[ 3433.449117] kswapd0/505 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 3433.449117]  (iprune_sem){+++++-}, at: [<ffffffff810ebbab>] shrink_icache_memory+0x45/0x2b1
[ 3433.449117] {RECLAIM_FS-ON-W} state was registered at:
[ 3433.449117]   [<ffffffff8107fe5f>] mark_held_locks+0x52/0x70
[ 3433.449117]   [<ffffffff8107ff02>] lockdep_trace_alloc+0x85/0x9f
[ 3433.449117]   [<ffffffff810d353d>] slab_pre_alloc_hook+0x18/0x3c
[ 3433.449117]   [<ffffffff810d3fd5>] kmem_cache_alloc+0x23/0xa2
[ 3433.449117]   [<ffffffff8127be77>] idr_pre_get+0x2d/0x6f
[ 3433.449117]   [<ffffffff815434eb>] p9_idpool_get+0x30/0xae
[ 3433.449117]   [<ffffffff81540123>] p9_client_rpc+0xd7/0x9b0
[ 3433.449117]   [<ffffffff815427b0>] p9_client_clunk+0x88/0xdb
[ 3433.449117]   [<ffffffff811d56e5>] v9fs_evict_inode+0x3c/0x48
[ 3433.449117]   [<ffffffff810eb511>] evict+0x1f/0x87
[ 3433.449117]   [<ffffffff810eb5c0>] dispose_list+0x47/0xe3
[ 3433.449117]   [<ffffffff810eb8da>] evict_inodes+0x138/0x14f
[ 3433.449117]   [<ffffffff810d90e2>] generic_shutdown_super+0x57/0xe8
[ 3433.449117]   [<ffffffff810d91e8>] kill_anon_super+0x11/0x50
[ 3433.449117]   [<ffffffff811d4951>] v9fs_kill_super+0x49/0xab
[ 3433.449117]   [<ffffffff810d926e>] deactivate_locked_super+0x21/0x46
[ 3433.449117]   [<ffffffff810d9e84>] deactivate_super+0x40/0x44
[ 3433.449117]   [<ffffffff810ef848>] mntput_no_expire+0x100/0x109
[ 3433.449117]   [<ffffffff810f0aeb>] sys_umount+0x2f1/0x31c
[ 3433.449117]   [<ffffffff8102c87b>] system_call_fastpath+0x16/0x1b
[ 3433.449117] irq event stamp: 192941
[ 3433.449117] hardirqs last  enabled at (192941): [<ffffffff81568dcf>] _raw_spin_unlock_irq+0x2b/0x30
[ 3433.449117] hardirqs last disabled at (192940): [<ffffffff810b5f97>] shrink_inactive_list+0x290/0x2f5
[ 3433.449117] softirqs last  enabled at (188470): [<ffffffff8105fd65>] __do_softirq+0x133/0x152
[ 3433.449117] softirqs last disabled at (188455): [<ffffffff8102d7cc>] call_softirq+0x1c/0x28
[ 3433.449117]
[ 3433.449117] other info that might help us debug this:
[ 3433.449117] 1 lock held by kswapd0/505:
[ 3433.449117]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff810b52e2>] shrink_slab+0x38/0x15f
[ 3433.449117]
[ 3433.449117] stack backtrace:
[ 3433.449117] Pid: 505, comm: kswapd0 Not tainted 2.6.38-rc5+ #84
[ 3433.449117] Call Trace:
[ 3433.449117]  [<ffffffff8107fbce>] ? valid_state+0x17e/0x191
[ 3433.449117]  [<ffffffff81036896>] ? save_stack_trace+0x28/0x45
[ 3433.449117]  [<ffffffff81080426>] ? check_usage_forwards+0x0/0x87
[ 3433.449117]  [<ffffffff8107fcf4>] ? mark_lock+0x113/0x22c
[ 3433.449117]  [<ffffffff8108105f>] ? __lock_acquire+0x37a/0xcf7
[ 3433.449117]  [<ffffffff8107fc0e>] ? mark_lock+0x2d/0x22c
[ 3433.449117]  [<ffffffff81081077>] ? __lock_acquire+0x392/0xcf7
[ 3433.449117]  [<ffffffff810b14d2>] ? determine_dirtyable_memory+0x15/0x28
[ 3433.449117]  [<ffffffff81081a33>] ? lock_acquire+0x57/0x6d
[ 3433.449117]  [<ffffffff810ebbab>] ? shrink_icache_memory+0x45/0x2b1
[ 3433.449117]  [<ffffffff81567d85>] ? down_read+0x47/0x5c
[ 3433.449117]  [<ffffffff810ebbab>] ? shrink_icache_memory+0x45/0x2b1
[ 3433.449117]  [<ffffffff810ebbab>] ? shrink_icache_memory+0x45/0x2b1
[ 3433.449117]  [<ffffffff810b5385>] ? shrink_slab+0xdb/0x15f
[ 3433.449117]  [<ffffffff810b69bc>] ? kswapd+0x574/0x96a
[ 3433.449117]  [<ffffffff810b6448>] ? kswapd+0x0/0x96a
[ 3433.449117]  [<ffffffff810714e2>] ? kthread+0x7d/0x85
[ 3433.449117]  [<ffffffff8102d6d4>] ? kernel_thread_helper+0x4/0x10
[ 3433.449117]  [<ffffffff81569200>] ? restore_args+0x0/0x30
[ 3433.449117]  [<ffffffff81071465>] ? kthread+0x0/0x85
[ 3433.449117]  [<ffffffff8102d6d0>] ? kernel_thread_helper+0x0/0x10

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 net/9p/client.c     |   10 +++++-----
 net/9p/protocol.c   |    6 +++---
 net/9p/trans_fd.c   |    2 +-
 net/9p/trans_rdma.c |    6 +++---
 net/9p/util.c       |    2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 347ec0c..2ccbf04 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -223,7 +223,7 @@ static struct p9_req_t *p9_tag_alloc(struct p9_client *c, u16 tag)
 
 	req = &c->reqs[row][col];
 	if (!req->tc) {
-		req->wq = kmalloc(sizeof(wait_queue_head_t), GFP_KERNEL);
+		req->wq = kmalloc(sizeof(wait_queue_head_t), GFP_NOFS);
 		if (!req->wq) {
 			printk(KERN_ERR "Couldn't grow tag array\n");
 			return ERR_PTR(-ENOMEM);
@@ -233,17 +233,17 @@ static struct p9_req_t *p9_tag_alloc(struct p9_client *c, u16 tag)
 				P9_TRANS_PREF_PAYLOAD_SEP) {
 			int alloc_msize = min(c->msize, 4096);
 			req->tc = kmalloc(sizeof(struct p9_fcall)+alloc_msize,
-					GFP_KERNEL);
+					  GFP_NOFS);
 			req->tc->capacity = alloc_msize;
 			req->rc = kmalloc(sizeof(struct p9_fcall)+alloc_msize,
-					GFP_KERNEL);
+					  GFP_NOFS);
 			req->rc->capacity = alloc_msize;
 		} else {
 			req->tc = kmalloc(sizeof(struct p9_fcall)+c->msize,
-					GFP_KERNEL);
+					  GFP_NOFS);
 			req->tc->capacity = c->msize;
 			req->rc = kmalloc(sizeof(struct p9_fcall)+c->msize,
-					GFP_KERNEL);
+					  GFP_NOFS);
 			req->rc->capacity = c->msize;
 		}
 		if ((!req->tc) || (!req->rc)) {
diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index 2ce515b..8a4084f 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -205,7 +205,7 @@ p9pdu_vreadf(struct p9_fcall *pdu, int proto_version, const char *fmt,
 				if (errcode)
 					break;
 
-				*sptr = kmalloc(len + 1, GFP_KERNEL);
+				*sptr = kmalloc(len + 1, GFP_NOFS);
 				if (*sptr == NULL) {
 					errcode = -EFAULT;
 					break;
@@ -273,7 +273,7 @@ p9pdu_vreadf(struct p9_fcall *pdu, int proto_version, const char *fmt,
 				if (!errcode) {
 					*wnames =
 					    kmalloc(sizeof(char *) * *nwname,
-						    GFP_KERNEL);
+						    GFP_NOFS);
 					if (!*wnames)
 						errcode = -ENOMEM;
 				}
@@ -317,7 +317,7 @@ p9pdu_vreadf(struct p9_fcall *pdu, int proto_version, const char *fmt,
 					*wqids =
 					    kmalloc(*nwqid *
 						    sizeof(struct p9_qid),
-						    GFP_KERNEL);
+						    GFP_NOFS);
 					if (*wqids == NULL)
 						errcode = -ENOMEM;
 				}
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 078eb16..800c55b 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -349,7 +349,7 @@ static void p9_read_work(struct work_struct *work)
 
 		if (m->req->rc == NULL) {
 			m->req->rc = kmalloc(sizeof(struct p9_fcall) +
-						m->client->msize, GFP_KERNEL);
+						m->client->msize, GFP_NOFS);
 			if (!m->req->rc) {
 				m->req = NULL;
 				err = -ENOMEM;
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 17c5ba7..ccac42a 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -425,7 +425,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 	struct p9_rdma_context *rpl_context = NULL;
 
 	/* Allocate an fcall for the reply */
-	rpl_context = kmalloc(sizeof *rpl_context, GFP_KERNEL);
+	rpl_context = kmalloc(sizeof *rpl_context, GFP_NOFS);
 	if (!rpl_context) {
 		err = -ENOMEM;
 		goto err_close;
@@ -438,7 +438,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 	 */
 	if (!req->rc) {
 		req->rc = kmalloc(sizeof(struct p9_fcall)+client->msize,
-								GFP_KERNEL);
+				  GFP_NOFS);
 		if (req->rc) {
 			req->rc->sdata = (char *) req->rc +
 						sizeof(struct p9_fcall);
@@ -469,7 +469,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 	req->rc = NULL;
 
 	/* Post the request */
-	c = kmalloc(sizeof *c, GFP_KERNEL);
+	c = kmalloc(sizeof *c, GFP_NOFS);
 	if (!c) {
 		err = -ENOMEM;
 		goto err_free1;
diff --git a/net/9p/util.c b/net/9p/util.c
index e048701..b84619b 100644
--- a/net/9p/util.c
+++ b/net/9p/util.c
@@ -92,7 +92,7 @@ int p9_idpool_get(struct p9_idpool *p)
 	unsigned long flags;
 
 retry:
-	if (idr_pre_get(&p->pool, GFP_KERNEL) == 0)
+	if (idr_pre_get(&p->pool, GFP_NOFS) == 0)
 		return 0;
 
 	spin_lock_irqsave(&p->lock, flags);
-- 
1.7.1

