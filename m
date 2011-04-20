Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab1DTUwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:52:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7882 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab1DTUwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:52:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=ORQo9/S4VIa3/Mgn85Xm3vPy7utYRNH9VcAI7W1UauKxRVdK9W7iYNR4pRWsXCRKG
	y1TmeRRVOI+Mlb4ULpKVg==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [RFC][Patch 05/18] sched: update this_cpu_load() to return u64 value
Date: Wed, 20 Apr 2011 13:51:24 -0700
Message-Id: <1303332697-16426-6-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idlecpu governor uses this_cpu_load() for calculations which is now returns
u64. Update idlecpu governor to also use u64.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 drivers/cpuidle/governors/menu.c |    5 ++---
 include/linux/sched.h            |    2 +-
 kernel/sched.c                   |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index f508690..2051134 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -127,10 +127,9 @@ struct menu_device {
 
 static int get_loadavg(void)
 {
-	unsigned long this = this_cpu_load();
+	u64 this = this_cpu_load();
 
-
-	return LOAD_INT(this) * 10 + LOAD_FRAC(this) / 10;
+	return div_u64(LOAD_INT(this) * 10 + LOAD_FRAC(this), 10);
 }
 
 static inline int which_bucket(unsigned int duration)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6d88be1..546a418 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -140,7 +140,7 @@ extern unsigned long nr_running(void);
 extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_iowait(void);
 extern unsigned long nr_iowait_cpu(int cpu);
-extern unsigned long this_cpu_load(void);
+extern u64 this_cpu_load(void);
 
 
 extern void calc_global_load(unsigned long ticks);
diff --git a/kernel/sched.c b/kernel/sched.c
index 94dd1df..175764b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3062,7 +3062,7 @@ unsigned long nr_iowait_cpu(int cpu)
 	return atomic_read(&this->nr_iowait);
 }
 
-unsigned long this_cpu_load(void)
+u64 this_cpu_load(void)
 {
 	struct rq *this = this_rq();
 	return this->cpu_load[0];
-- 
1.7.3.1

