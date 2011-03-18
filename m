Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab1CRDiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:38:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58870 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab1CRDh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:37:58 -0400
Message-ID: <4D82D3FF.2080303@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 11:39:43 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
        Robert Love <robert.w.love@intel.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>, Tejun Heo <tj@kernel.org>,
        Jarek Poplawski <jarkao2@gmail.com>, linux-kernel@vger.kernel.org,
        devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 01/36] net,rcu: convert call_rcu(free_dm_hw_stat) to kfree_rcu()
References: <4D82D071.5020703@cn.fujitsu.com>
In-Reply-To: <4D82D071.5020703@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:36:34,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:36:35,
	Serialize complete at 2011-03-18 11:36:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback free_dm_hw_stat() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(free_dm_hw_stat).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 net/core/drop_monitor.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 36e603c..32365e7 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -207,14 +207,6 @@ static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi)
 	rcu_read_unlock();
 }
 
-
-static void free_dm_hw_stat(struct rcu_head *head)
-{
-	struct dm_hw_stat_delta *n;
-	n = container_of(head, struct dm_hw_stat_delta, rcu);
-	kfree(n);
-}
-
 static int set_all_monitor_traces(int state)
 {
 	int rc = 0;
@@ -245,7 +237,7 @@ static int set_all_monitor_traces(int state)
 		list_for_each_entry_safe(new_stat, temp, &hw_stats_list, list) {
 			if (new_stat->dev == NULL) {
 				list_del_rcu(&new_stat->list);
-				call_rcu(&new_stat->rcu, free_dm_hw_stat);
+				kfree_rcu(new_stat, rcu);
 			}
 		}
 		break;
@@ -314,7 +306,7 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 				new_stat->dev = NULL;
 				if (trace_state == TRACE_OFF) {
 					list_del_rcu(&new_stat->list);
-					call_rcu(&new_stat->rcu, free_dm_hw_stat);
+					kfree_rcu(new_stat, rcu);
 					break;
 				}
 			}
-- 
1.7.4
