Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab0LTPZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:25:52 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:42508 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab0LTPZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:25:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=E6M+9lLmKjrBAuHlYNTvqNxm7eEQRqp1SFAqYOGx5Qo4uyJDYxClgavh/9Ys5h/9W7
         daxgwzBRL9ZT5yOFaewYPOpWKiROpDmgpHh9+Cugi14L/AeSUoTtD0iBRZWLOznL7Mzv
         n7V2qkQKr8R18HyOwa0MWF76Be+9okhwuyncY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [RFC PATCH 13/15] sched: Protect nohz task cpu affinity
Date: Mon, 20 Dec 2010 16:24:20 +0100
Message-Id: <1292858662-5650-14-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow to change a nohz task cpu affinity as we want them
to be bound to a single CPU and we want this affinity not to
change.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 kernel/sched.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4412493..bd0a41f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5712,6 +5712,13 @@ again:
 		goto out;
 	}
 
+	/* Nohz tasks must keep their affinity */
+	if (test_tsk_thread_flag(p, TIF_NOHZ) &&
+	    !cpumask_equal(&p->cpus_allowed, new_mask)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	if (p->sched_class->set_cpus_allowed)
 		p->sched_class->set_cpus_allowed(p, new_mask);
 	else {
-- 
1.7.3.2

