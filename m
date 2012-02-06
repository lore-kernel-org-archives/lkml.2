Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2BFQ3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:29:41 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57593 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab2BFQ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:29:38 -0500
Date: Mon, 6 Feb 2012 20:29:35 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Oleg Nesterov <oleg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 2/6] oom: Get rid of sparse warnings
Message-ID: <20120206162935.GB5117@oksana.dev.rtsoft.ru>
References: <20120203163056.GA4190@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120203163056.GA4190@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse flood makes it hard to catch newly-introduced warnings. So let's
fix the the sparse warnings in the oom killer:

  CHECK   mm/oom_kill.c
  mm/oom_kill.c:139:20: warning: context imbalance in
	  '__find_lock_task_mm' - wrong count at exit
  mm/oom_kill.c:771:9: warning: context imbalance in 'out_of_memory' -
	  different lock contexts for basic block

The first one is fixed by assuring sparse that we know that we exit
with the lock held.

The second one is caused by the fact that sparse isn't smart enough
to handle noreturn attribute.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 mm/oom_kill.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 0ebb383..49569b6 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -142,8 +142,14 @@ struct task_struct *__find_lock_task_mm(struct task_struct *p)
 
 	do {
 		task_lock(t);
-		if (likely(t->mm))
+		if (likely(t->mm)) {
+			/*
+			 * Shut up sparse: we do know that we exit w/ the
+			 * task locked.
+			 */
+			__release(&t->alloc_loc);
 			return t;
+		}
 		task_unlock(t);
 	} while_each_thread(p, t);
 
@@ -766,6 +772,7 @@ retry:
 		dump_header(NULL, gfp_mask, order, NULL, mpol_mask);
 		read_unlock(&tasklist_lock);
 		panic("Out of memory and no killable processes...\n");
+		return;
 	}
 
 	if (oom_kill_process(p, gfp_mask, order, points, totalpages, NULL,
-- 
1.7.7.6

