Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1C1C6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 22:58:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56339 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab1C1C6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 22:58:14 -0400
Message-ID: <4D8FF9BC.7050609@cn.fujitsu.com>
Date: Mon, 28 Mar 2011 11:00:12 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Jan Beulich <jbeulich@novell.com>, David Howells <dhowells@redhat.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <clameter@sgi.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
References: <4D8FF8AD.5080607@cn.fujitsu.com>
In-Reply-To: <4D8FF8AD.5080607@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-28 10:56:41,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-28 10:56:45,
	Serialize complete at 2011-03-28 10:56:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



We can not include linux/sched.h in linux/rcupdate.h.
If we access task's task_rcu_strut without linux/sched.h included,
We will failed with compiling error.

So we add TASK_RCU_OFFSET, which help us access
task's task_rcu_strut without linux/sched.h included.
Now, task_rcu_struct(), current_task_rcu_struct(), task_of_task_rcu() and
rcu_copy_process() can be used anywhere without linux/sched.h included.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/rcupdate.h |   49 +++++++++++++++++++++++++++++++++++++++++----
 kernel/kernel-offsets.c  |    3 ++
 2 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3500138..a5ed3fe 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -140,11 +140,50 @@ static inline void init_task_rcu_struct(struct task_rcu_struct *task_rcu)
 #endif
 }
 
-#define task_rcu_struct(t) (&(t)->task_rcu_struct)
-#define current_task_rcu_struct() task_rcu_struct(current)
-#define task_of_task_rcu(task_rcu) container_of(task_rcu, struct task_struct,\
-				   task_rcu_struct)
-#define rcu_copy_process(tsk) init_task_rcu_struct(task_rcu_struct(tsk))
+#ifdef __KBUILD_GENARATING__
+/*
+ * Very eary kbuild stage, many important defines including TASK_RCU_OFFSET
+ * are not available, use dummies to avoid compiling errors.
+ */
+static inline
+struct task_rcu_struct *task_rcu_struct(struct task_struct *t)
+{
+	(void)t;
+	return (struct task_rcu_struct *)0x3L;
+}
+
+static inline
+struct task_struct *task_of_task_rcu(struct task_rcu_struct *task_rcu)
+{
+	(void)task_rcu;
+	return (struct task_struct *)-0x3L;
+}
+#else
+/* for generated TASK_RCU_OFFSET */
+#include <generated/kernel-offsets.h>
+
+static inline
+struct task_rcu_struct *task_rcu_struct(struct task_struct *t)
+{
+	return (struct task_rcu_struct *)(((void *)t) + TASK_RCU_OFFSET);
+}
+
+static inline
+struct task_struct *task_of_task_rcu(struct task_rcu_struct *task_rcu)
+{
+	return (struct task_struct *)(((void *)task_rcu) - TASK_RCU_OFFSET);
+}
+#endif
+
+static inline struct task_rcu_struct *current_task_rcu_struct(void)
+{
+	return task_rcu_struct(current);
+}
+
+static inline void rcu_copy_process(struct task_struct *tsk)
+{
+	init_task_rcu_struct(task_rcu_struct(tsk));
+}
 
 #ifdef CONFIG_PREEMPT_RCU
 
diff --git a/kernel/kernel-offsets.c b/kernel/kernel-offsets.c
index fb73ccf..a890511 100644
--- a/kernel/kernel-offsets.c
+++ b/kernel/kernel-offsets.c
@@ -4,11 +4,14 @@
  * Copyright (C) 2010 Lai Jiangshan
  */
 
+#include <linux/rcupdate.h>
+#include <linux/sched.h>
 #include <linux/kbuild.h>
 
 void foo(void);
 
 void foo(void)
 {
+	OFFSET(TASK_RCU_OFFSET, task_struct, task_rcu_struct);
 }
 
-- 
1.7.4

