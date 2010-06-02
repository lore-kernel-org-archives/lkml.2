Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab0FBNyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 09:54:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48066 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210Ab0FBNyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 09:54:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] oom: Make coredump interruptible
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100601201843.GA20732@redhat.com>
References: <20100601093951.2430.A69D9226@jp.fujitsu.com> <20100601201843.GA20732@redhat.com>
Message-Id: <20100602221805.F524.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  2 Jun 2010 22:54:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Otoh, if we make do_coredump() interruptible (and we should do this
> in any case), then perhaps the TIF_MEMDIE+PF_COREDUMP is not really
> needed? Afaics we always send SIGKILL along with TIF_MEMDIE.

How is to make per-process oom flag + interruptible coredump?

this per-process oom flag can be used vmscan shortcut exiting too.
(IOW, It can help DavidR mmap_sem issue)


===========================================================
Subject: [PATCH] oom: Make coredump interruptible

If oom victim process is under core dumping, sending SIGKILL cause
no-op. Unfortunately, coredump need relatively much memory. It mean
OOM vs coredump can makes deadlock.

Then, coredump logic should check the task has received SIGKILL
from OOM.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/binfmt_elf.c       |    5 +++++
 include/linux/sched.h |    3 +++
 mm/oom_kill.c         |    1 +
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 535e763..aa47979 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -2038,6 +2038,11 @@ static int elf_core_dump(struct coredump_params *cprm)
 				page_cache_release(page);
 			} else
 				stop = !dump_seek(cprm->file, PAGE_SIZE);
+
+			/* Now, The process received OOM. Exit soon! */
+			if (current->signal->oom_victim)
+				stop = 1;
+
 			if (stop)
 				goto end_coredump;
 		}
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8485aa2..1c4fa86 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -544,6 +544,9 @@ struct signal_struct {
 	int			notify_count;
 	struct task_struct	*group_exit_task;
 
+	/* true mean the process is OOM-killer victim. */
+	bool			oom_victim;
+
 	/* thread group stop support, overloads group_exit_code too */
 	int			group_stop_count;
 	unsigned int		flags; /* see SIGNAL_* flags below */
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index f33a1b8..39e31bf 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -400,6 +400,7 @@ static int __oom_kill_process(struct task_struct *p, struct mem_cgroup *mem,
 	 */
 	p->rt.time_slice = HZ;
 	set_tsk_thread_flag(p, TIF_MEMDIE);
+	p->signal->oom_victim = true;
 
 	force_sig(SIGKILL, p);
 
-- 
1.6.5.2



