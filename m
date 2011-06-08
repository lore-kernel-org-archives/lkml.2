Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab1FHTa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:30:56 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48419 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628Ab1FHTap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:30:45 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH tip/core/rcu 18/28] jbd2,rcu: Convert call_rcu(free_devcache) to kfree_rcu()
Date: Wed,  8 Jun 2011 12:29:57 -0700
Message-Id: <1307561407-13809-18-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110608192943.GA13211@linux.vnet.ibm.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback free_devcache() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(free_devcache).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/jbd2/journal.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index e0ec3db..13fb464 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2390,11 +2390,6 @@ struct devname_cache {
 static struct devname_cache *devcache[1 << CACHE_SIZE_BITS];
 static DEFINE_SPINLOCK(devname_cache_lock);
 
-static void free_devcache(struct rcu_head *rcu)
-{
-	kfree(rcu);
-}
-
 const char *jbd2_dev_to_name(dev_t device)
 {
 	int	i = hash_32(device, CACHE_SIZE_BITS);
@@ -2423,7 +2418,7 @@ const char *jbd2_dev_to_name(dev_t device)
 			spin_unlock(&devname_cache_lock);
 			return ret;
 		}
-		call_rcu(&devcache[i]->rcu, free_devcache);
+		kfree_rcu(devcache[i], rcu);
 	}
 	devcache[i] = new_dev;
 	devcache[i]->device = device;
-- 
1.7.3.2

