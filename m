Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab1FSXwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 19:52:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55794 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab1FSXv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 19:51:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=we0VW8gEy4KeK+PvvRO7XAbRxS0Jc4ms+ikd0ZFarkWXVFmfwpJnYL6CS9uIuEPvWU
         mKrgi5M/E03w1GNLn8rZ1cDhIAD7QZOPjDSM0UhwMCnMeAdfEDghcheKFCyO1mVA27SP
         bBb0jGrYnoCPsNmqCxnFfiw3fNvGNO8kWya90=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 2/4] cgroups: Add res_counter_write_u64() API
Date: Mon, 20 Jun 2011 01:51:12 +0200
Message-Id: <1308527474-20704-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the resource counter API with a mirror of
res_counter_read_u64() to make it handy to update a resource
counter value from a cgroup subsystem u64 value file.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/res_counter.h |    2 ++
 kernel/res_counter.c        |   21 +++++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index c9d625c..1b3fe05 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -82,6 +82,8 @@ int res_counter_memparse_write_strategy(const char *buf,
 int res_counter_write(struct res_counter *counter, int member,
 		      const char *buffer, write_strategy_fn write_strategy);
 
+void res_counter_write_u64(struct res_counter *counter, int member, u64 val);
+
 /*
  * the field descriptors. one for each member of res_counter
  */
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 34683ef..806d041 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -168,12 +168,22 @@ int res_counter_memparse_write_strategy(const char *buf,
 	return 0;
 }
 
+void res_counter_write_u64(struct res_counter *counter, int member, u64 val)
+{
+	unsigned long long *target;
+	unsigned long flags;
+
+	spin_lock_irqsave(&counter->lock, flags);
+	target = res_counter_member(counter, member);
+	*target = val;
+	spin_unlock_irqrestore(&counter->lock, flags);
+}
+
 int res_counter_write(struct res_counter *counter, int member,
 		      const char *buf, write_strategy_fn write_strategy)
 {
 	char *end;
-	unsigned long flags;
-	unsigned long long tmp, *val;
+	unsigned long long tmp;
 
 	if (write_strategy) {
 		if (write_strategy(buf, &tmp))
@@ -183,9 +193,8 @@ int res_counter_write(struct res_counter *counter, int member,
 		if (*end != '\0')
 			return -EINVAL;
 	}
-	spin_lock_irqsave(&counter->lock, flags);
-	val = res_counter_member(counter, member);
-	*val = tmp;
-	spin_unlock_irqrestore(&counter->lock, flags);
+
+	res_counter_write_u64(counter, member, tmp);
+
 	return 0;
 }
-- 
1.7.5.4

