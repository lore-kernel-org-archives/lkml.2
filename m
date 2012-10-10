Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab2JJFet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 01:34:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:28430 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750740Ab2JJFer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 01:34:47 -0400
X-IronPort-AV: E=Sophos;i="4.80,564,1344182400"; 
   d="scan'208";a="5973647"
Message-ID: <5075098E.9090808@cn.fujitsu.com>
Date: Wed, 10 Oct 2012 13:37:18 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH V2] task_work: avoid unneeded cmpxchg() in task_work_run()
References: <50729A78.9090601@cn.fujitsu.com>	 <20121008123815.GA847@redhat.com> <1349780697.7880.14.camel@twins>
In-Reply-To: <1349780697.7880.14.camel@twins>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/10 13:34:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/10 13:34:36,
	Serialize complete at 2012/10/10 13:34:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 07:04 PM, Peter Zijlstra wrote:
> On Mon, 2012-10-08 at 14:38 +0200, Oleg Nesterov wrote:
>> But the code looks more complex, and the only advantage is that
>> non-exiting task does xchg() instead of cmpxchg(). Not sure this
>> worth the trouble, in this case task_work_run() will likey run
>> the callbacks (the caller checks ->task_works != NULL), I do not
>> think this can add any noticeable speedup. 
> 
> Yeah, I agree, the patch doesn't seem worth the trouble. It makes tricky
> code unreadable at best.
> 

To gain better readability, we need to move work_exited things out
from task_work_run() too.

Thanks,
Lai

Subject: task_work: avoid unneeded cmpxchg() in task_work_run()

We only require cmpxchg()&retry when task is exiting.
xchg() is enough in other cases like original code in ac3d0da8.

So we use xchg() for task_work_run() and move the logic
of exit_task_work() out from task_work_run().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---

diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index ca5a1cf..1e686a5 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -15,10 +15,6 @@ init_task_work(struct callback_head *twork, task_work_func_t func)
 int task_work_add(struct task_struct *task, struct callback_head *twork, bool);
 struct callback_head *task_work_cancel(struct task_struct *, task_work_func_t);
 void task_work_run(void);
-
-static inline void exit_task_work(struct task_struct *task)
-{
-	task_work_run();
-}
+void exit_task_work(struct task_struct *task);
 
 #endif	/* _LINUX_TASK_WORK_H */
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 65bd3c9..87ef3b7 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -52,16 +52,7 @@ void task_work_run(void)
 	struct callback_head *work, *head, *next;
 
 	for (;;) {
-		/*
-		 * work->func() can do task_work_add(), do not set
-		 * work_exited unless the list is empty.
-		 */
-		do {
-			work = ACCESS_ONCE(task->task_works);
-			head = !work && (task->flags & PF_EXITING) ?
-				&work_exited : NULL;
-		} while (cmpxchg(&task->task_works, work, head) != work);
-
+		work = xchg(&task->task_works, NULL);
 		if (!work)
 			break;
 		/*
@@ -90,3 +81,17 @@ void task_work_run(void)
 		} while (work);
 	}
 }
+
+void exit_task_work(struct task_struct *task)
+{
+	for (;;) {
+		/*
+		 * work->func() can do task_work_add(), do not set
+		 * work_exited unless the list is empty.
+		 */
+		if (unlikely(task->task_works))
+			task_work_run();
+		if (cmpxchg(&task->task_works, NULL, &work_exited) == NULL)
+			break;
+	}
+}
