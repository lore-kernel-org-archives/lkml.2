Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab0LLXsn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:43 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36890 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab0LLXsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:41 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: drosenberg@vsecurity.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [213/223] rds: Integer overflow in RDS cmsg handling
Message-Id: <20101212234840.A7E4FB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 218854af84038d828a32f061858b1902ed2beec6 upstream.

In rds_cmsg_rdma_args(), the user-provided args->nr_local value is
restricted to less than UINT_MAX.  This seems to need a tighter upper
bound, since the calculation of total iov_size can overflow, resulting
in a small sock_kmalloc() allocation.  This would probably just result
in walking off the heap and crashing when calling rds_rdma_pages() with
a high count value.  If it somehow doesn't crash here, then memory
corruption could occur soon after.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/rds/rdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/net/rds/rdma.c
===================================================================
--- linux.orig/net/rds/rdma.c
+++ linux/net/rds/rdma.c
@@ -474,7 +474,7 @@ static struct rds_rdma_op *rds_rdma_prep
 		goto out;
 	}
 
-	if (args->nr_local > (u64)UINT_MAX) {
+	if (args->nr_local > UIO_MAXIOV) {
 		ret = -EMSGSIZE;
 		goto out;
 	}
