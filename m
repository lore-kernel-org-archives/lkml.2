Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab0FDKzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 06:55:00 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43250 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab0FDKys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 06:54:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] oom: Make coredump interruptible
Cc: kosaki.motohiro@jp.fujitsu.com, Roland McGrath <roland@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100602203827.GA29244@redhat.com>
References: <20100602185812.4B5894A549@magilla.sf.frob.com> <20100602203827.GA29244@redhat.com>
Message-Id: <20100604194635.72D3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  4 Jun 2010 19:54:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 06/02, Roland McGrath wrote:
> >
> > > when select_bad_process() finds the task P to kill it can participate
> > > in the core dump (sleep in exit_mm), but we should somehow inform the
> > > thread which actually dumps the core: P->mm->core_state->dumper.
> >
> > Perhaps it should simply do that: if you would choose P to oom-kill, and
> > P->mm->core_state!=NULL, then choose P->mm->core_state->dumper instead.
> 
> ... to set TIF_MEMDIE which should be checked in elf_core_dump().
> 
> Probably yes.

Yep, probably. but can you please allow me additonal explanation?

In multi threaded OOM case, we have two problematic routine, coredump
and vmscan. Roland's idea can only solve the former. 

But I also interest vmscan quickly exit if OOM received. if other threads
get stuck in vmscan for freeing addional pages (this is very typical because
usually every thread call any syscall and eventually call kmalloc etc), 
recovering oom become very slow even if this doesn't makes deadlock.

Unfortunatelly, vmscan need much refactoring before appling this idea.
then, I didn't include such fixes.

I mean I hope to implement per-process OOM flag even if coredump don't
really need it.

So, I created MMF_OOM patch today. It is just for discussion, still.

(BFrom f099e1ba6e7b5654b35b468c13e1ae9e4f182ea4 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 4 Jun 2010 18:56:56 +0900
Subject: [RFC][PATCH v2] oom: make coredump interruptible

If oom victim process is under core dumping, sending SIGKILL cause
no-op. Unfortunately, coredump need relatively much memory. It mean
OOM vs coredump can makes deadlock.

Then, coredump logic should check the task has received SIGKILL
from OOM.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/binfmt_elf.c       |    4 ++++
 include/linux/sched.h |    1 +
 mm/oom_kill.c         |    3 ++-
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 535e763..2aca748 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -2038,6 +2038,10 @@ static int elf_core_dump(struct coredump_params *cprm)
 				page_cache_release(page);
 			} else
 				stop = !dump_seek(cprm->file, PAGE_SIZE);
+
+			/* The task need to exit ASAP if received OOM. */
+			if (test_bit(MMF_OOM_KILLED, &current->mm->flags))
+				stop = 1;
 			if (stop)
 				goto end_coredump;
 		}
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8485aa2..53b7caa 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -436,6 +436,7 @@ extern int get_dumpable(struct mm_struct *mm);
 #endif
 					/* leave room for more dump flags */
 #define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
+#define MMF_OOM_KILLED		17	/* Killed by OOM */
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 2678a04..29850c4 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -401,7 +401,6 @@ static int __oom_kill_process(struct task_struct *p, struct mem_cgroup *mem,
 		       K(p->mm->total_vm),
 		       K(get_mm_counter(p->mm, MM_ANONPAGES)),
 		       K(get_mm_counter(p->mm, MM_FILEPAGES)));
-	task_unlock(p);
 
 	/*
 	 * We give our sacrificial lamb high priority and access to
@@ -410,6 +409,8 @@ static int __oom_kill_process(struct task_struct *p, struct mem_cgroup *mem,
 	 */
 	p->rt.time_slice = HZ;
 	set_tsk_thread_flag(p, TIF_MEMDIE);
+	set_bit(MMF_OOM_KILLED, &p->mm->flags);
+	task_unlock(p);
 
 	force_sig(SIGKILL, p);
 
-- 
1.6.5.2



