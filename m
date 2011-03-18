Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab1CRDlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:41:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61906 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab1CRDlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:41:15 -0400
Message-ID: <4D82D4C2.8020503@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 11:42:58 +0800
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
Subject: [PATCH 05/36] block,rcu: convert call_rcu(disk_free_ptbl_rcu_cb)
 to kfree_rcu()
References: <4D82D071.5020703@cn.fujitsu.com> <4D82D3FF.2080303@cn.fujitsu.com>
In-Reply-To: <4D82D3FF.2080303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:39:49,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 11:39:52,
	Serialize complete at 2011-03-18 11:39:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback disk_free_ptbl_rcu_cb() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(disk_free_ptbl_rcu_cb).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 block/genhd.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index cbf1112..2800cc8 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1018,14 +1018,6 @@ static const struct attribute_group *disk_attr_groups[] = {
 	NULL
 };
 
-static void disk_free_ptbl_rcu_cb(struct rcu_head *head)
-{
-	struct disk_part_tbl *ptbl =
-		container_of(head, struct disk_part_tbl, rcu_head);
-
-	kfree(ptbl);
-}
-
 /**
  * disk_replace_part_tbl - replace disk->part_tbl in RCU-safe way
  * @disk: disk to replace part_tbl for
@@ -1046,7 +1038,7 @@ static void disk_replace_part_tbl(struct gendisk *disk,
 
 	if (old_ptbl) {
 		rcu_assign_pointer(old_ptbl->last_lookup, NULL);
-		call_rcu(&old_ptbl->rcu_head, disk_free_ptbl_rcu_cb);
+		kfree_rcu(old_ptbl, rcu_head);
 	}
 }
 
-- 
1.7.4
