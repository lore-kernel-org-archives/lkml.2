Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab1LGHHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 02:07:24 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48335 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab1LGHHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 02:07:23 -0500
Date: Wed, 7 Dec 2011 11:07:18 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Add start_data, end_data, start_brk members to
 /proc/$pid/stat v2
Message-ID: <20111207070718.GA21678@moon>
References: <20111205182010.GV14515@moon>
 <20111206140833.3b43fbeb.akpm@linux-foundation.org>
 <20111206221515.GP29781@moon>
 <20111206225315.GA20459@moon>
 <20111207090259.e2296dd3.kamezawa.hiroyu@jp.fujitsu.com>
 <20111207063308.GC20459@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207063308.GC20459@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 10:33:08AM +0400, Cyrill Gorcunov wrote:
> 
> No problem, I'll update (These segments are filled by binfmt handlers).
> 

This one should fit.

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] fs, proc: Add start_data, end_data, start_brk members to /proc/$pid/stat v4

These members are involved into calculation of program
data segment (which might be seen in /proc/<pid>/statm)
and into brk() call, so in a sake of restore we need
these entries to be set exactly to the same value the
process had at dumpimg time.

While setting these entries back to a running task
is supposed to be done via prctl interface (which is
not addressed in this patch) the export of these values
are done via /proc/$pid/stat, which already have start_code,
end_code and start_stack entries.

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
