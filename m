Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2FTJfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:35:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984Ab2FTJfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:35:37 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 14/17] nbd: Set SOCK_MEMALLOC for access to PFMEMALLOC reserves
Date: Wed, 20 Jun 2012 10:35:17 +0100
Message-Id: <1340184920-22288-15-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1340184920-22288-1-git-send-email-mgorman@suse.de>
References: <1340184920-22288-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set SOCK_MEMALLOC on the NBD socket to allow access to PFMEMALLOC
reserves so pages backed by NBD, particularly if swap related, can
be cleaned to prevent the machine being deadlocked. It is still
possible that the PFMEMALLOC reserves get depleted resulting in
deadlock but this can be resolved by the administrator by increasing
min_free_kbytes.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 drivers/block/nbd.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 061427a75d..76bc96f 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -154,6 +154,7 @@ static int sock_xmit(struct nbd_device *nbd, int send, void *buf, int size,
 	struct msghdr msg;
 	struct kvec iov;
 	sigset_t blocked, oldset;
+	unsigned long pflags = current->flags;
 
 	if (unlikely(!sock)) {
 		dev_err(disk_to_dev(nbd->disk),
@@ -167,8 +168,9 @@ static int sock_xmit(struct nbd_device *nbd, int send, void *buf, int size,
 	siginitsetinv(&blocked, sigmask(SIGKILL));
 	sigprocmask(SIG_SETMASK, &blocked, &oldset);
 
+	current->flags |= PF_MEMALLOC;
 	do {
-		sock->sk->sk_allocation = GFP_NOIO;
+		sock->sk->sk_allocation = GFP_NOIO | __GFP_MEMALLOC;
 		iov.iov_base = buf;
 		iov.iov_len = size;
 		msg.msg_name = NULL;
@@ -214,6 +216,7 @@ static int sock_xmit(struct nbd_device *nbd, int send, void *buf, int size,
 	} while (size > 0);
 
 	sigprocmask(SIG_SETMASK, &oldset, NULL);
+	tsk_restore_flags(current, pflags, PF_MEMALLOC);
 
 	return result;
 }
@@ -405,6 +408,7 @@ static int nbd_do_it(struct nbd_device *nbd)
 
 	BUG_ON(nbd->magic != NBD_MAGIC);
 
+	sk_set_memalloc(nbd->sock->sk);
 	nbd->pid = task_pid_nr(current);
 	ret = device_create_file(disk_to_dev(nbd->disk), &pid_attr);
 	if (ret) {
-- 
1.7.9.2

