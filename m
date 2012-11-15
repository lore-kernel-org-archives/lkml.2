Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab2KOANh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 19:13:37 -0500
Received: from mail-bk0-f74.google.com ([209.85.214.74]:38965 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab2KOANe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 19:13:34 -0500
From: Greg Thelen <gthelen@google.com>
To: Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        Greg Thelen <gthelen@google.com>
Subject: [PATCH] res_counter: delete res_counter_write()
Date: Wed, 14 Nov 2012 16:06:57 -0800
Message-Id: <1352938017-32568-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 628f423553 "memcg: limit change shrink usage" both
res_counter_write() and write_strategy_fn have been unused.  This
patch deletes them both.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 include/linux/res_counter.h |    5 -----
 kernel/res_counter.c        |   22 ----------------------
 2 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index 4b173b6..5ae8456 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -74,14 +74,9 @@ ssize_t res_counter_read(struct res_counter *counter, int member,
 		const char __user *buf, size_t nbytes, loff_t *pos,
 		int (*read_strategy)(unsigned long long val, char *s));
 
-typedef int (*write_strategy_fn)(const char *buf, unsigned long long *val);
-
 int res_counter_memparse_write_strategy(const char *buf,
 					unsigned long long *res);
 
-int res_counter_write(struct res_counter *counter, int member,
-		      const char *buffer, write_strategy_fn write_strategy);
-
 /*
  * the field descriptors. one for each member of res_counter
  */
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 7b3d6dc..ff55247 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -198,25 +198,3 @@ int res_counter_memparse_write_strategy(const char *buf,
 	*res = PAGE_ALIGN(*res);
 	return 0;
 }
-
-int res_counter_write(struct res_counter *counter, int member,
-		      const char *buf, write_strategy_fn write_strategy)
-{
-	char *end;
-	unsigned long flags;
-	unsigned long long tmp, *val;
-
-	if (write_strategy) {
-		if (write_strategy(buf, &tmp))
-			return -EINVAL;
-	} else {
-		tmp = simple_strtoull(buf, &end, 10);
-		if (*end != '\0')
-			return -EINVAL;
-	}
-	spin_lock_irqsave(&counter->lock, flags);
-	val = res_counter_member(counter, member);
-	*val = tmp;
-	spin_unlock_irqrestore(&counter->lock, flags);
-	return 0;
-}
-- 
1.7.7.3

