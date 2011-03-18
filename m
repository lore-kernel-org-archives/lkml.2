Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab1CREBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:01:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62563 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab1CREBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:01:32 -0400
Message-ID: <4D82D987.3050508@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:03:19 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 19/36] security,rcu: convert call_rcu(sel_netif_free) to kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:00:10,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:00:11,
	Serialize complete at 2011-03-18 12:00:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback sel_netif_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(sel_netif_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 security/selinux/netif.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/security/selinux/netif.c b/security/selinux/netif.c
index d6095d6..58cc481 100644
--- a/security/selinux/netif.c
+++ b/security/selinux/netif.c
@@ -104,22 +104,6 @@ static int sel_netif_insert(struct sel_netif *netif)
 }
 
 /**
- * sel_netif_free - Frees an interface entry
- * @p: the entry's RCU field
- *
- * Description:
- * This function is designed to be used as a callback to the call_rcu()
- * function so that memory allocated to a hash table interface entry can be
- * released safely.
- *
- */
-static void sel_netif_free(struct rcu_head *p)
-{
-	struct sel_netif *netif = container_of(p, struct sel_netif, rcu_head);
-	kfree(netif);
-}
-
-/**
  * sel_netif_destroy - Remove an interface record from the table
  * @netif: the existing interface record
  *
@@ -131,7 +115,7 @@ static void sel_netif_destroy(struct sel_netif *netif)
 {
 	list_del_rcu(&netif->list);
 	sel_netif_total--;
-	call_rcu(&netif->rcu_head, sel_netif_free);
+	kfree_rcu(netif, rcu_head);
 }
 
 /**
-- 
1.7.4
