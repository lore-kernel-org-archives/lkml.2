Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2BFQ37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:29:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57593 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab2BFQ35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:29:57 -0500
Date: Mon, 6 Feb 2012 20:29:54 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Oleg Nesterov <oleg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 5/6] staging: android/lowmemorykiller: No need for
 task->signal check
Message-ID: <20120206162954.GE5117@oksana.dev.rtsoft.ru>
References: <20120203163056.GA4190@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120203163056.GA4190@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task->signal == NULL is not possible, so no need for these checks.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/staging/android/lowmemorykiller.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 0755e2f..6e800d3 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -136,19 +136,13 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 	rcu_read_lock();
 	for_each_process(tsk) {
 		struct task_struct *p;
-		struct signal_struct *sig;
 		int oom_adj;
 
 		p = find_lock_task_mm(tsk);
 		if (!p)
 			continue;
 
-		sig = p->signal;
-		if (!sig) {
-			task_unlock(p);
-			continue;
-		}
-		oom_adj = sig->oom_adj;
+		oom_adj = p->signal->oom_adj;
 		if (oom_adj < min_adj) {
 			task_unlock(p);
 			continue;
-- 
1.7.7.6

