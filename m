Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1LLURX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:17:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45228 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab1LLURU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:17:20 -0500
Message-Id: <20111212201715.150165835@openvz.org>
User-Agent: quilt/0.48-1
Date: Tue, 13 Dec 2011 00:06:44 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 2/3] [PATCH] fs, proc: Add start_data, end_data, start_brk members to /proc/$pid/stat v4
References: <20111212200642.836001668@openvz.org>
Content-Disposition: inline; filename=fs-proc-Add-start_data-end_data-start_brk-members-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mm->start_code/end_code, mm->start_data/end_data,
mm->start_brk are involved into calculation of program
text/data segment sizes (which might be seen in
/proc/<pid>/statm) and into brk() call final address.

In a sake of restore we need to know all these values.
While mm->start_code/end_code already present in
/proc/$pid/stat, the rest members are not, so this
patch brings them in.

The restore procedure of these members is addressed
in another patch and uses prctl facility.

v2:
 - Kees and Alexey pointed out that "1" hack is unnecessary,
   so make it to have plain (mm && permitted) ? mm->member : 0
   form.

v3:
 - Andrew pointed that documentation update is missed.
   Chagelog is updated as well.

v4:
 - Update proc.txt to address concerns from Kees and Kame.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
---
 Documentation/filesystems/proc.txt |    3 +++
 fs/proc/array.c                    |    7 +++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6.git/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.git.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.git/Documentation/filesystems/proc.txt
@@ -305,6 +305,9 @@ Table 1-4: Contents of the stat files (a
   blkio_ticks   time spent waiting for block IO
   gtime         guest time of the task in jiffies
   cgtime        guest time of the task children in jiffies
+  start_data    address above which program data+bss is placed
+  end_data      address below which program data+bss is placed
+  start_brk     address above which program heap can be expaned with brk() call
 ..............................................................................
 
 The /proc/PID/maps file containing the currently mapped memory regions and
Index: linux-2.6.git/fs/proc/array.c
===================================================================
--- linux-2.6.git.orig/fs/proc/array.c
+++ linux-2.6.git/fs/proc/array.c
@@ -464,7 +464,7 @@ static int do_task_stat(struct seq_file
 
 	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
 %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
-%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
+%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
 		pid_nr_ns(pid, ns),
 		tcomm,
 		state,
@@ -511,7 +511,10 @@ static int do_task_stat(struct seq_file
 		task->policy,
 		(unsigned long long)delayacct_blkio_ticks(task),
 		cputime_to_clock_t(gtime),
-		cputime_to_clock_t(cgtime));
+		cputime_to_clock_t(cgtime),
+		(mm && permitted) ? mm->start_data : 0,
+		(mm && permitted) ? mm->end_data : 0,
+		(mm && permitted) ? mm->start_brk : 0);
 	if (mm)
 		mmput(mm);
 	return 0;

