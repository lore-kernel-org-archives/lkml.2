Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab1CREDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:03:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57613 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab1CREDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:03:36 -0400
Message-ID: <4D82DA02.1040401@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:05:22 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 22/36] security,rcu: convert call_rcu(sel_netnode_free) to
 kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:02:13,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:02:14,
	Serialize complete at 2011-03-18 12:02:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback sel_netnode_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(sel_netnode_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 security/selinux/netnode.c |   20 ++------------------
 1 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/security/selinux/netnode.c b/security/selinux/netnode.c
index 65ebfe9..692b857 100644
--- a/security/selinux/netnode.c
+++ b/security/selinux/netnode.c
@@ -69,22 +69,6 @@ static DEFINE_SPINLOCK(sel_netnode_lock);
 static struct sel_netnode_bkt sel_netnode_hash[SEL_NETNODE_HASH_SIZE];
 
 /**
- * sel_netnode_free - Frees a node entry
- * @p: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table node entry can be
- * released safely.
- *
- */
-static void sel_netnode_free(struct rcu_head *p)
-{
-	struct sel_netnode *node = container_of(p, struct sel_netnode, rcu);
-	kfree(node);
-}
-
-/**
  * sel_netnode_hashfn_ipv4 - IPv4 hashing function for the node table
  * @addr: IPv4 address
  *
@@ -192,7 +176,7 @@ static void sel_netnode_insert(struct sel_netnode *node)
 			rcu_dereference(sel_netnode_hash[idx].list.prev),
 			struct sel_netnode, list);
 		list_del_rcu(&tail->list);
-		call_rcu(&tail->rcu, sel_netnode_free);
+		kfree_rcu(tail, rcu);
 	} else
 		sel_netnode_hash[idx].size++;
 }
@@ -305,7 +289,7 @@ static void sel_netnode_flush(void)
 		list_for_each_entry_safe(node, node_tmp,
 					 &sel_netnode_hash[idx].list, list) {
 				list_del_rcu(&node->list);
-				call_rcu(&node->rcu, sel_netnode_free);
+				kfree_rcu(node, rcu);
 		}
 		sel_netnode_hash[idx].size = 0;
 	}
-- 
1.7.4
