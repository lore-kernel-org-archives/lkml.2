Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030510Ab2HWK7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:59:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41569 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030424Ab2HWK7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:59:32 -0400
Date: Thu, 23 Aug 2012 12:59:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120823105927.GA12453@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: f5042d037544215de530a375431c3fca60140823 Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

This tree contains misc fixlets: a perf script python binding 
fix, a uprobes fix and a syscall tracing fix.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf tools: Add missing files to build the python binding

Oleg Nesterov (1):
      uprobes: Fix mmap_region()'s mm->mm_rb corruption if uprobe_mmap() fails

Will Deacon (1):
      tracing/syscalls: Fix perf syscall tracing when syscall_nr == -1


 kernel/fork.c                      | 4 ++--
 kernel/trace/trace_syscalls.c      | 4 ++++
 mm/mmap.c                          | 5 ++---
 tools/perf/util/python-ext-sources | 2 ++
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 3bd2280..2c8857e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -455,8 +455,8 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		if (retval)
 			goto out;
 
-		if (file && uprobe_mmap(tmp))
-			goto out;
+		if (file)
+			uprobe_mmap(tmp);
 	}
 	/* a new mm has just been created */
 	arch_dup_mmap(oldmm, mm);
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 60e4d78..6b245f64 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -506,6 +506,8 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (syscall_nr < 0)
+		return;
 	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
 		return;
 
@@ -580,6 +582,8 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (syscall_nr < 0)
+		return;
 	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
 		return;
 
diff --git a/mm/mmap.c b/mm/mmap.c
index e3e8691..52e08fc 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1356,9 +1356,8 @@ out:
 	} else if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
 		make_pages_present(addr, addr + len);
 
-	if (file && uprobe_mmap(vma))
-		/* matching probes but cannot insert */
-		goto unmap_and_free_vma;
+	if (file)
+		uprobe_mmap(vma);
 
 	return addr;
 
diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index 2884e67..2133628 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -10,10 +10,12 @@ util/ctype.c
 util/evlist.c
 util/evsel.c
 util/cpumap.c
+util/hweight.c
 util/thread_map.c
 util/util.c
 util/xyarray.c
 util/cgroup.c
 util/debugfs.c
+util/rblist.c
 util/strlist.c
 ../../lib/rbtree.c
