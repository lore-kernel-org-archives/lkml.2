Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2BAEdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 23:33:36 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63859 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2BAEde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 23:33:34 -0500
Date: Wed, 1 Feb 2012 08:33:30 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg KH <gregkh@suse.de>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] staging: android/lowmemorykiller: Don't grab tasklist_lock
Message-ID: <20120201043330.GA25511@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grabbing tasklist_lock has its disadvantages, i.e. it blocks
process creation and destruction. If there are lots of processes,
blocking doesn't sound as a great idea.

For LMK, it is sufficient to surround tasks list traverse loop
with rcu_read_{,un}lock() pair.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---

Also thanks to Eric and Paul for the ideas.

 drivers/staging/android/lowmemorykiller.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 2d8d2b7..b3ade2f 100644
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
@@ -185,7 +186,7 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 	}
 	lowmem_print(4, "lowmem_shrink %lu, %x, return %d\n",
 		     sc->nr_to_scan, sc->gfp_mask, rem);
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return rem;
 }
 
-- 
1.7.7.6
