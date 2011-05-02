Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1EBBUL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 21:20:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54581 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab1EBBT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 21:19:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=Td3OdO/PRnZXvZZ0E+TxVghn/xSw11MwWH/UT0mh8RHe4Qxm5GCMZqZ8yw5FbZIbC
	nUE6M+y3paiVY8ybDkvRQ==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v1 05/19] sched: update this_cpu_load() to return u64 value
Date: Sun,  1 May 2011 18:19:03 -0700
Message-Id: <1304299157-25769-6-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1304299157-25769-1-git-send-email-ncrao@google.com>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
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
index 7badde6..f2eb816 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3061,7 +3061,7 @@ unsigned long nr_iowait_cpu(int cpu)
 	return atomic_read(&this->nr_iowait);
 }
 
-unsigned long this_cpu_load(void)
+u64 this_cpu_load(void)
 {
 	struct rq *this = this_rq();
 	return this->cpu_load[0];
-- 
1.7.3.1

