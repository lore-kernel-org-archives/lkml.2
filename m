Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab2BGEsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 23:48:21 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49370 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab2BGEsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 23:48:19 -0500
Date: Tue, 7 Feb 2012 08:48:16 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: [PATCH v2 1/6] oom: Make find_lock_task_mm() sparse-aware
Message-ID: <20120207044816.GA31271@oksana.dev.rtsoft.ru>
References: <20120203163056.GA4190@redhat.com>
 <20120206162930.GA5117@oksana.dev.rtsoft.ru>
 <20120206163542.GA10104@kroah.com>
 <20120206185909.GB7741@oksana.dev.rtsoft.ru>
 <20120206191854.GA16702@kroah.com>
 <CAHGf_=r+nReQSfdvU7+FAhMRBkZPzQ2Jg6Puw9SmvW7WijpN7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHGf_=r+nReQSfdvU7+FAhMRBkZPzQ2Jg6Puw9SmvW7WijpN7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed so that callers would not get 'context imbalance'
warnings from the sparse tool.

As a side effect, this patch fixes the following sparse warnings:

  CHECK   mm/oom_kill.c
  mm/oom_kill.c:201:28: warning: context imbalance in 'oom_badness' -
  unexpected unlock
  include/linux/rcupdate.h:249:30: warning: context imbalance in
  'dump_tasks' - unexpected unlock
  mm/oom_kill.c:453:9: warning: context imbalance in 'oom_kill_task' -
  unexpected unlock
  CHECK   mm/memcontrol.c
  ...
  mm/memcontrol.c:1130:17: warning: context imbalance in
  'task_in_mem_cgroup' - unexpected unlock

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---

On Mon, Feb 06, 2012 at 04:27:32PM -0500, KOSAKI Motohiro wrote:
[...]
> >> Unfortunately this isn't possible in this case. Unlike '({})' GCC
> >> extension, do-while statement does not evaluate to a value, i.e.
> >> 'x = do { 123; } while (0);' is illegal.
> >
> > Ah, you are right, my bad, sorry about that.
> >
> > greg k-h
> 
> Some __cond_lock() caller are inline functions. Is this bad?

No, that's great, actually. :-) Not obvious, but seems like
sparse understands __cond_lock in inline functions, so I'd
better use it.

Thanks,

 include/linux/oom.h |   12 +++++++++++-
 mm/oom_kill.c       |    2 +-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index 552fba9..7c8946a 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -21,6 +21,7 @@
 
 #ifdef __KERNEL__
 
+#include <linux/compiler.h>
 #include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/nodemask.h>
@@ -65,7 +66,16 @@ static inline void oom_killer_enable(void)
 	oom_killer_disabled = false;
 }
 
-extern struct task_struct *find_lock_task_mm(struct task_struct *p);
+extern struct task_struct *__find_lock_task_mm(struct task_struct *p);
+
+static inline struct task_struct *find_lock_task_mm(struct task_struct *p)
+{
+	struct task_struct *ret;
+
+	ret = __find_lock_task_mm(p);
+	(void)__cond_lock(&p->alloc_lock, ret);
+	return ret;
+}
 
 /* sysctls */
 extern int sysctl_oom_dump_tasks;
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 2958fd8..0ebb383 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -136,7 +136,7 @@ static bool has_intersects_mems_allowed(struct task_struct *tsk,
  * pointer.  Return p, or any of its subthreads with a valid ->mm, with
  * task_lock() held.
  */
-struct task_struct *find_lock_task_mm(struct task_struct *p)
+struct task_struct *__find_lock_task_mm(struct task_struct *p)
 {
 	struct task_struct *t = p;
 
-- 
1.7.7.6

