Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab2ATPDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:03:20 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:5245 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab2ATPDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:03:18 -0500
From: Glauber Costa <glommer@parallels.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        cgroups@vger.kernel.org, Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/3] cgroup: make sure memcg margin is 0 when over limit
Date: Fri, 20 Jan 2012 18:57:15 +0400
Message-Id: <1327071436-20763-3-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1327071436-20763-1-git-send-email-glommer@parallels.com>
References: <1327071436-20763-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the memcg sock code, we'll need to register allocations
that are temporarily over limit. Let's make sure that margin
is 0 in this case.

I am keeping this as a separate patch, so that if any weirdness
interaction appears in the future, we can now exactly what caused
it.

Suggested by Johannes Weiner 

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Johannes Weiner <hannes@cmpxchg.org>
CC: Michal Hocko <mhocko@suse.cz>
CC: Tejun Heo <tj@kernel.org>
CC: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/res_counter.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index c9d625c..d06d014 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -142,7 +142,10 @@ static inline unsigned long long res_counter_margin(struct res_counter *cnt)
 	unsigned long flags;
 
 	spin_lock_irqsave(&cnt->lock, flags);
-	margin = cnt->limit - cnt->usage;
+	if (cnt->limit > cnt->usage)
+		margin = cnt->limit - cnt->usage;
+	else
+		margin = 0;
 	spin_unlock_irqrestore(&cnt->lock, flags);
 	return margin;
 }
-- 
1.7.7.4

