Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab2JHJQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 05:16:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45553 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab2JHJQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 05:16:21 -0400
X-IronPort-AV: E=Sophos;i="4.80,552,1344182400"; 
   d="scan'208";a="5961380"
Message-ID: <50729A78.9090601@cn.fujitsu.com>
Date: Mon, 08 Oct 2012 17:18:48 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>, Eric Dumazet <edumazet@google.com>
Subject: [PATCH] task_work: avoid unneeded cmpxchg() in task_work_run()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/08 17:16:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/08 17:16:13,
	Serialize complete at 2012/10/08 17:16:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only require cmpxchg()&retry when task is exiting.
xchg() is enough in other cases like original code in ac3d0da8.

So we try our best to use xchg() and avoid competition&latency
from task_work_add().

Also remove the inner loop

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 65bd3c9..82a42e7 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -56,14 +56,13 @@ void task_work_run(void)
 		 * work->func() can do task_work_add(), do not set
 		 * work_exited unless the list is empty.
 		 */
-		do {
-			work = ACCESS_ONCE(task->task_works);
-			head = !work && (task->flags & PF_EXITING) ?
-				&work_exited : NULL;
-		} while (cmpxchg(&task->task_works, work, head) != work);
-
-		if (!work)
+		if (!ACCESS_ONCE(task->task_works) ||
+		    !(work = xchg(&task->task_works, NULL))) {
+			if ((task->flags & PF_EXITING) &&
+			    cmpxchg(&task->task_works, NULL, &work_exited))
+				continue;
 			break;
+		}
 		/*
 		 * Synchronize with task_work_cancel(). It can't remove
 		 * the first entry == work, cmpxchg(task_works) should
