Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab1AEKLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 05:11:40 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:52176 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751426Ab1AEKLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 05:11:39 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19weDd/THxwdG7CmZ5Z/uBVUOrkBunmAlWb0Bp6pR
	eUxBubOftx0Dcy
Subject: [PATCH] sched: fix struct autogroup memory leak
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 11:11:25 +0100
Message-ID: <1294222285.8369.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems I lost a change somewhere, leaking memory.

sched: fix struct autogroup memory leak

Add missing change to actually use autogroup_free().

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>

---
 kernel/sched.c           |    1 +
 kernel/sched_autogroup.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -8382,6 +8382,7 @@ static void free_sched_group(struct task
 {
 	free_fair_sched_group(tg);
 	free_rt_sched_group(tg);
+	autogroup_free(tg);
 	kfree(tg);
 }
 
Index: linux-2.6/kernel/sched_autogroup.c
===================================================================
--- linux-2.6.orig/kernel/sched_autogroup.c
+++ linux-2.6/kernel/sched_autogroup.c
@@ -20,7 +20,8 @@ static void autogroup_init(struct task_s
 
 static inline void autogroup_free(struct task_group *tg)
 {
-	kfree(tg->autogroup);
+	if (tg->autogroup)
+		kfree(tg->autogroup);
 }
 
 static inline void autogroup_destroy(struct kref *kref)


