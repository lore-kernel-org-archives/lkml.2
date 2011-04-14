Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683Ab1DNR5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:57:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:41437 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270Ab1DNR5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:57:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 125/209] rds: Integer overflow in RDS cmsg handling
Date: Thu, 14 Apr 2011 13:54:43 -0400
Message-Id: <1302803767-9715-12-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/rds/rdma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 5ce9437..cf0dfa7 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -472,7 +472,7 @@ static struct rds_rdma_op *rds_rdma_prepare(struct rds_sock *rs,
 		goto out;
 	}
 
-	if (args->nr_local > (u64)UINT_MAX) {
+	if (args->nr_local > UIO_MAXIOV) {
 		ret = -EMSGSIZE;
 		goto out;
 	}
-- 
1.7.4.4

