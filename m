Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab2BCADv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 19:03:51 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34921 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab2BCADu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 19:03:50 -0500
Date: Fri, 3 Feb 2012 04:03:45 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v3] staging: android/lowmemorykiller: Don't grab tasklist_lock
Message-ID: <20120203000345.GA14338@oksana.dev.rtsoft.ru>
References: <20120202171659.GA29378@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120202171659.GA29378@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grabbing tasklist_lock has its disadvantages, i.e. it blocks
process creation and destruction. If there are lots of processes,
blocking doesn't sound as a great idea.

For LMK, it is sufficient to surround tasks list traverse with
rcu_read_{,un}lock().

>From now on using force_sig() is not safe, as it can race with an
already exiting task, so we use send_sig() now. As a downside, it
won't kill PID namespace init processes, but that's not what we
want anyway.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/staging/android/lowmemorykiller.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 2d8d2b7..63da844 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -34,6 +34,7 @@
 #include <linux/mm.h>
 #include <linux/oom.h>
 #include <linux/sched.h>
+#include <linux/rcupdate.h>
 #include <linux/profile.h>
 #include <linux/notifier.h>
 
@@ -132,7 +133,7 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 	}
 	selected_oom_adj = min_adj;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	for_each_process(p) {
 		struct mm_struct *mm;
 		struct signal_struct *sig;
@@ -180,12 +181,12 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 		lowmem_deathpending = selected;
 		task_handoff_register(&task_nb);
 #endif
-		force_sig(SIGKILL, selected);
+		send_sig(SIGKILL, selected, 0);
 		rem -= selected_tasksize;
 	}
 	lowmem_print(4, "lowmem_shrink %lu, %x, return %d\n",
 		     sc->nr_to_scan, sc->gfp_mask, rem);
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return rem;
 }
 
-- 
1.7.7.6
