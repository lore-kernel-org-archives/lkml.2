Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab1LFWxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:53:21 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39752 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1LFWxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:53:20 -0500
Date: Wed, 7 Dec 2011 02:53:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Add start_data, end_data, start_brk members to
 /proc/$pid/stat v2
Message-ID: <20111206225315.GA20459@moon>
References: <20111205182010.GV14515@moon>
 <20111206140833.3b43fbeb.akpm@linux-foundation.org>
 <20111206221515.GP29781@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206221515.GP29781@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 02:15:15AM +0400, Cyrill Gorcunov wrote:
> On Tue, Dec 06, 2011 at 02:08:33PM -0800, Andrew Morton wrote:
> > On Mon, 5 Dec 2011 22:20:11 +0400
> > Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > 
> > > It helps to dump and restore this mm_struct members.
> > 
> > Sorry, I'm not going to apply a patch with a changelog like that.
> >
> 
> OK, I'll update it. The problem is that while we "read" this entries
> from procfs, the restoration is supposed to be done via prctl interface
> (the patch is in fly, and I'm trying to improve it at moment).
> 
> > It needs a full description of how this will be used and why it is
> > needed.  So that others can understand and evaluate the proposal, and
> > any possible alternatives.
> > 
> > Such a description would also let us see whether this is just some
> > "hey, maybe we'll use this sometime" thing, in which case it should not
> > yet be applied.
> 
> I understand.
> 
> > 
> > >  fs/proc/array.c |    7 +++++--
> > 
> > Also, every change to any procfs interface should have an associated
> > change to procfs documentation.  If no relevant document exists then
> > heck, write one.  No exceptions.
> >
> 
> ok, thanks.
> 
> 	Cyrill

What about such changelog? Does it look better?

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] fs, proc: Add start_data, end_data, start_brk members to /proc/$pid/stat v3

These members are involved into calculation of program
data segment size (which might be seen in /proc/<pid>/statm)
and brk() call, so in a sake of restore we need
these entries to be set to exactly same values
a process had at dumpimg time.

While setting these entries back to a running task
is supposed to be implemented via prctl interface (which is
not addressed in this patch) the export of these values
are done via /proc/$pid/stat, which btw already has
start_code, end_code and start_stack entries.

v2:
 - Kees and Alexey pointed out that "1" hack is unnecessary,
   so make it to have plain (mm && permitted) ? mm->member : 0
   form.

v3:
 - Andrew pointed that documentation update is missed.
   Chagelog is updated as well.

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
+  start_data    address above which program data is placed
+  end_data      address above which program data is placed
+  start_brk     address above which program data can be expanded with brk() call
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
