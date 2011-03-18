Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab1CRD43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:56:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54560 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab1CRD4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:56:22 -0400
Message-ID: <4D82D850.6090702@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 11:58:08 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/36] jbd2,rcu: convert call_rcu(free_devcache) to kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:54:59,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:54:59,
	Serialize complete at 2011-03-18 11:54:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback free_devcache() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(free_devcache).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 fs/jbd2/journal.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 97e7346..2f2e40f 100644
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
@@ -2421,7 +2416,7 @@ const char *jbd2_dev_to_name(dev_t device)
 			spin_unlock(&devname_cache_lock);
 			return ret;
 		}
-		call_rcu(&devcache[i]->rcu, free_devcache);
+		kfree_rcu(devcache[i], rcu);
 	}
 	devcache[i] = new_dev;
 	devcache[i]->device = device;
-- 
1.7.4
