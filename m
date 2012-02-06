Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab2BFQ3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:29:52 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57593 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab2BFQ3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:29:50 -0500
Date: Mon, 6 Feb 2012 20:29:47 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Oleg Nesterov <oleg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 4/6] staging: android/lowmemorykiller: Better mm handling
Message-ID: <20120206162947.GD5117@oksana.dev.rtsoft.ru>
References: <20120203163056.GA4190@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120203163056.GA4190@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LMK should not directly check for task->mm. The reason is that the
process' threads may exit or detach its mm via use_mm(), but other
threads may still have a valid mm. To catch this we use
find_lock_task_mm(), which walks up all threads and returns an
appropriate task (with lock held).

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/staging/android/lowmemorykiller.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 63da844..0755e2f 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -82,7 +82,7 @@ task_notify_func(struct notifier_block *self, unsigned long val, void *data)
 
 static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 {
-	struct task_struct *p;
+	struct task_struct *tsk;
 	struct task_struct *selected = NULL;
 	int rem = 0;
 	int tasksize;
@@ -134,15 +134,17 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 	selected_oom_adj = min_adj;
 
 	rcu_read_lock();
-	for_each_process(p) {
-		struct mm_struct *mm;
+	for_each_process(tsk) {
+		struct task_struct *p;
 		struct signal_struct *sig;
 		int oom_adj;
 
-		task_lock(p);
-		mm = p->mm;
+		p = find_lock_task_mm(tsk);
+		if (!p)
+			continue;
+
 		sig = p->signal;
-		if (!mm || !sig) {
+		if (!sig) {
 			task_unlock(p);
 			continue;
 		}
@@ -151,7 +153,7 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 			task_unlock(p);
 			continue;
 		}
-		tasksize = get_mm_rss(mm);
+		tasksize = get_mm_rss(p->mm);
 		task_unlock(p);
 		if (tasksize <= 0)
 			continue;
-- 
1.7.7.6

