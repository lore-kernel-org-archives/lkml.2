Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1CREIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:08:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49525 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab1CREIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:08:42 -0400
Message-ID: <4D82DB31.7050007@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:10:25 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 30/36] net,rcu: convert call_rcu(wq_free_rcu) to kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:07:17,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:07:17,
	Serialize complete at 2011-03-18 12:07:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback wq_free_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(wq_free_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 net/socket.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index ac2219f..3158271 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -261,21 +261,12 @@ static struct inode *sock_alloc_inode(struct super_block *sb)
 	return &ei->vfs_inode;
 }
 
-
-
-static void wq_free_rcu(struct rcu_head *head)
-{
-	struct socket_wq *wq = container_of(head, struct socket_wq, rcu);
-
-	kfree(wq);
-}
-
 static void sock_destroy_inode(struct inode *inode)
 {
 	struct socket_alloc *ei;
 
 	ei = container_of(inode, struct socket_alloc, vfs_inode);
-	call_rcu(&ei->socket.wq->rcu, wq_free_rcu);
+	kfree_rcu(ei->socket.wq, rcu);
 	kmem_cache_free(sock_inode_cachep, ei);
 }
 
-- 
1.7.4
