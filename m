Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab0LHAum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:50:42 -0500
Received: from kroah.org ([198.145.64.141]:58729 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348Ab0LHAsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:48:19 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:36 2010
Message-Id: <20101208004436.125923613@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:45:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [118/127] rds: Integer overflow in RDS cmsg handling
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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

---
 net/rds/rdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -447,7 +447,7 @@ static struct rds_rdma_op *rds_rdma_prep
 		goto out;
 	}
 
-	if (args->nr_local > (u64)UINT_MAX) {
+	if (args->nr_local > UIO_MAXIOV) {
 		ret = -EMSGSIZE;
 		goto out;
 	}


