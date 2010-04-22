Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab0DVTwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:52:16 -0400
Received: from kroah.org ([198.145.64.141]:40941 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab0DVT2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:44 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:15 2010
Message-Id: <20100422190915.711361015@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [093/197] sched: sched_getaffinity(): Allow less than NR_CPUS length
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit cd3d8031eb4311e516329aee03c79a08333141f1 upstream.

[ Note, this commit changes the syscall ABI for > 1024 CPUs systems. ]

Recently, some distro decided to use NR_CPUS=4096 for mysterious reasons.
Unfortunately, glibc sched interface has the following definition:

	# define __CPU_SETSIZE  1024
	# define __NCPUBITS     (8 * sizeof (__cpu_mask))
	typedef unsigned long int __cpu_mask;
	typedef struct
	{
	  __cpu_mask __bits[__CPU_SETSIZE / __NCPUBITS];
	} cpu_set_t;

It mean, if NR_CPUS is bigger than 1024, cpu_set_t makes an
ABI issue ...

More recently, Sharyathi Nagesh reported following test program makes
misterious syscall failure:

 -----------------------------------------------------------------------
 #define _GNU_SOURCE
 #include<stdio.h>
 #include<errno.h>
 #include<sched.h>

 int main()
 {
     cpu_set_t set;
     if (sched_getaffinity(0, sizeof(cpu_set_t), &set) < 0)
         printf("\n Call is failing with:%d", errno);
 }
 -----------------------------------------------------------------------

Because the kernel assumes len argument of sched_getaffinity() is bigger
than NR_CPUS. But now it is not correct.

Now we are faced with the following annoying dilemma, due to
the limitations of the glibc interface built in years ago:

 (1) if we change glibc's __CPU_SETSIZE definition, we lost
     binary compatibility of _all_ application.

 (2) if we don't change it, we also lost binary compatibility of
     Sharyathi's use case.

Then, I would propse to change the rule of the len argument of
sched_getaffinity().

Old:
	len should be bigger than NR_CPUS
New:
	len should be bigger than maximum possible cpu id

This creates the following behavior:

 (A) In the real 4096 cpus machine, the above test program still
     return -EINVAL.

 (B) NR_CPUS=4096 but the machine have less than 1024 cpus (almost
     all machines in the world), the above can run successfully.

Fortunatelly, BIG SGI machine is mainly used for HPC use case. It means
they can rebuild their programs.

IOW we hope they are not annoyed by this issue ...

Reported-by: Sharyathi Nagesh <sharyath@in.ibm.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Ulrich Drepper <drepper@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Mike Travis <travis@sgi.com>
LKML-Reference: <20100312161316.9520.A69D9226@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6669,7 +6669,9 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t
 	int ret;
 	cpumask_var_t mask;
 
-	if (len < cpumask_size())
+	if (len < nr_cpu_ids)
+		return -EINVAL;
+	if (len & (sizeof(unsigned long)-1))
 		return -EINVAL;
 
 	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
@@ -6677,10 +6679,12 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t
 
 	ret = sched_getaffinity(pid, mask);
 	if (ret == 0) {
-		if (copy_to_user(user_mask_ptr, mask, cpumask_size()))
+		int retlen = min(len, cpumask_size());
+
+		if (copy_to_user(user_mask_ptr, mask, retlen))
 			ret = -EFAULT;
 		else
-			ret = cpumask_size();
+			ret = retlen;
 	}
 	free_cpumask_var(mask);
 


