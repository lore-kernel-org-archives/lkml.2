Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1CREER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:04:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57220 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab1CREEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:04:11 -0400
Message-ID: <4D82DA25.40404@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:05:57 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 23/36] security,rcu: convert call_rcu(sel_netport_free) to
 kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:02:48,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:02:49,
	Serialize complete at 2011-03-18 12:02:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback sel_netport_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(sel_netport_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 security/selinux/netport.c |   20 ++------------------
 1 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/security/selinux/netport.c b/security/selinux/netport.c
index cfe2d72..ae76e29 100644
--- a/security/selinux/netport.c
+++ b/security/selinux/netport.c
@@ -68,22 +68,6 @@ static DEFINE_SPINLOCK(sel_netport_lock);
 static struct sel_netport_bkt sel_netport_hash[SEL_NETPORT_HASH_SIZE];
 
 /**
- * sel_netport_free - Frees a port entry
- * @p: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table port entry can be
- * released safely.
- *
- */
-static void sel_netport_free(struct rcu_head *p)
-{
-	struct sel_netport *port = container_of(p, struct sel_netport, rcu);
-	kfree(port);
-}
-
-/**
  * sel_netport_hashfn - Hashing function for the port table
  * @pnum: port number
  *
@@ -142,7 +126,7 @@ static void sel_netport_insert(struct sel_netport *port)
 			rcu_dereference(sel_netport_hash[idx].list.prev),
 			struct sel_netport, list);
 		list_del_rcu(&tail->list);
-		call_rcu(&tail->rcu, sel_netport_free);
+		kfree_rcu(tail, rcu);
 	} else
 		sel_netport_hash[idx].size++;
 }
@@ -241,7 +225,7 @@ static void sel_netport_flush(void)
 		list_for_each_entry_safe(port, port_tmp,
 					 &sel_netport_hash[idx].list, list) {
 			list_del_rcu(&port->list);
-			call_rcu(&port->rcu, sel_netport_free);
+			kfree_rcu(port, rcu);
 		}
 		sel_netport_hash[idx].size = 0;
 	}
-- 
1.7.4
