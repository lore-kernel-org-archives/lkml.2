Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934534Ab1ETICa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:02:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49028 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934364Ab1ETIC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:02:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD62007.6020600@jp.fujitsu.com>
Date: Fri, 20 May 2011 17:02:15 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: kosaki.motohiro@jp.fujitsu.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, rientjes@google.com,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com,
        minchan.kim@gmail.com, oleg@redhat.com
Subject: [PATCH 2/5] oom: kill younger process first
References: <4DD61F80.1020505@jp.fujitsu.com>
In-Reply-To: <4DD61F80.1020505@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces do_each_thread_reverse() and select_bad_process()
uses it. The benefits are two, 1) oom-killer can kill younger process
than older if they have a same oom score. Usually younger process is
less important. 2) younger task often have PF_EXITING because shell
script makes a lot of short lived processes. Reverse order search can
detect it faster.

Reported-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/sched.h |   11 +++++++++++
 mm/oom_kill.c         |    2 +-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 013314a..3698379 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2194,6 +2194,9 @@ static inline unsigned long wait_task_inactive(struct task_struct *p,
 #define next_task(p) \
 	list_entry_rcu((p)->tasks.next, struct task_struct, tasks)

+#define prev_task(p) \
+	list_entry((p)->tasks.prev, struct task_struct, tasks)
+
 #define for_each_process(p) \
 	for (p = &init_task ; (p = next_task(p)) != &init_task ; )

@@ -2206,6 +2209,14 @@ extern bool current_is_single_threaded(void);
 #define do_each_thread(g, t) \
 	for (g = t = &init_task ; (g = t = next_task(g)) != &init_task ; ) do

+/*
+ * Similar to do_each_thread(). but two difference are there.
+ *  - traverse tasks reverse order (i.e. younger to older)
+ *  - caller must hold tasklist_lock. rcu_read_lock isn't enough
+*/
+#define do_each_thread_reverse(g, t) \
+	for (g = t = &init_task ; (g = t = prev_task(g)) != &init_task ; ) do
+
 #define while_each_thread(g, t) \
 	while ((t = next_thread(t)) != g)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 43d32ae..e6a6c6f 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -282,7 +282,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 	struct task_struct *chosen = NULL;
 	*ppoints = 0;

-	do_each_thread(g, p) {
+	do_each_thread_reverse(g, p) {
 		unsigned int points;

 		if (!p->mm)
-- 
1.7.3.1



