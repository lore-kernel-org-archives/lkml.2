Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab2C2GdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:33:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37072 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab2C2GdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:33:18 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F7401C6.7020806@jp.fujitsu.com>
Date: Thu, 29 Mar 2012 15:31:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, davem@davemloft.net
Subject: [BUGFIX][PATCH 3/3] memcg/tcp: ignore tcp usage before accounting
 started.
References: <4F73FF9D.4090809@jp.fujitsu.com>
In-Reply-To: <4F73FF9D.4090809@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tcp memcontrol starts accouting after res->limit is set. So, if a sockets
starts before setting res->limit, there are already used resource.
After setting res->limit, the resource will be uncharged and make res_counter
below 0. This causes warning.

This patch fixes that by adding res_counter_uncharge_nowarn() and ignore the usage.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/res_counter.h |    2 ++
 include/net/sock.h          |    3 ++-
 kernel/res_counter.c        |   18 ++++++++++++++++++
 3 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index da81af0..e081948 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -134,6 +134,8 @@ int __must_check res_counter_charge_nofail(struct res_counter *counter,
 
 void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
 void res_counter_uncharge(struct res_counter *counter, unsigned long val);
+void res_counter_uncharge_nowarn(struct res_counter *counter,
+				unsigned long val);
 
 /**
  * res_counter_margin - calculate chargeable space of a counter
diff --git a/include/net/sock.h b/include/net/sock.h
index a6ba1f8..a1b3f4802 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1048,7 +1048,8 @@ static inline void memcg_memory_allocated_add(struct cg_proto *prot,
 static inline void memcg_memory_allocated_sub(struct cg_proto *prot,
 					      unsigned long amt)
 {
-	res_counter_uncharge(prot->memory_allocated, amt << PAGE_SHIFT);
+	res_counter_uncharge_nowarn(prot->memory_allocated,
+				amt << PAGE_SHIFT);
 }
 
 static inline u64 memcg_memory_allocated_read(struct cg_proto *prot)
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index d508363..2bb01ac 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -113,6 +113,24 @@ void res_counter_uncharge(struct res_counter *counter, unsigned long val)
 	local_irq_restore(flags);
 }
 
+void res_counter_uncharge_nowarn(struct res_counter *counter,
+					unsigned long val)
+{
+	struct res_counter *c;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	for (c = counter; c != NULL; c = c->parent) {
+		spin_lock(&c->lock);
+		if (c->usage < val)
+			val = c->usage;
+		res_counter_uncharge_locked(c, val);
+		spin_unlock(&c->lock);
+	}
+	local_irq_restore(flags);
+}
+
 
 static inline unsigned long long *
 res_counter_member(struct res_counter *counter, int member)
-- 
1.7.4.1


