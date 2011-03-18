Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1CREKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:10:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52527 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab1CREJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:09:58 -0400
Message-ID: <4D82DB80.6080103@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:11:44 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 32/36] ipc,rcu: convert call_rcu(ipc_immediate_free) to kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:08:35,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:08:36,
	Serialize complete at 2011-03-18 12:08:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback ipc_immediate_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(ipc_immediate_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 ipc/util.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 69a0cc1..e6fb418 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -576,19 +576,6 @@ static void ipc_schedule_free(struct rcu_head *head)
 	schedule_work(&sched->work);
 }
 
-/**
- * ipc_immediate_free - free ipc + rcu space
- * @head: RCU callback structure that contains pointer to be freed
- *
- * Free from the RCU callback context.
- */
-static void ipc_immediate_free(struct rcu_head *head)
-{
-	struct ipc_rcu_grace *free =
-		container_of(head, struct ipc_rcu_grace, rcu);
-	kfree(free);
-}
-
 void ipc_rcu_putref(void *ptr)
 {
 	if (--container_of(ptr, struct ipc_rcu_hdr, data)->refcount > 0)
@@ -598,8 +585,7 @@ void ipc_rcu_putref(void *ptr)
 		call_rcu(&container_of(ptr, struct ipc_rcu_grace, data)->rcu,
 				ipc_schedule_free);
 	} else {
-		call_rcu(&container_of(ptr, struct ipc_rcu_grace, data)->rcu,
-				ipc_immediate_free);
+		kfree_rcu(container_of(ptr, struct ipc_rcu_grace, data), rcu);
 	}
 }
 
-- 
1.7.4
