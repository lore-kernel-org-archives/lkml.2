Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab1HEUlC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 16:41:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab1HEUk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 16:40:59 -0400
Date: Fri, 5 Aug 2011 16:40:40 -0400
From: Jason Baron <jbaron@redhat.com>
To: a.p.zijlstra@chello.nl, rostedt@goodmis.org
Cc: pjt@google.com, mingo@elte.hu, rth@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] jump label: Reduce the cycle count by changing the link order
Message-ID: <20110805204040.GG2522@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the course of testing jump labels for use with the CFS bandwidth controller,
Paul Turner, discovered that using jump labels reduced the branch count and the
instruction count, but did not reduce the cycle count or wall time.

I noticed that having the jump_label.o included in the kernel but not used in
any way still caused this increase in cycle count and wall time. Thus, I moved
jump_label.o in the kernel/Makefile, thus changing the link order, and
presumably moving it out of hot icache areas. This brought down the cycle
count/time as expected.

In addition to Paul's testing,  I've tested the patch using a single
'static_branch()' in the getppid() path, and basically running tight loops of
calls to getppid(). Here are my results for the branch disabled case:

With jump labels turned on (CONFIG_JUMP_LABEL), branch disabled:

 Performance counter stats for 'bash -c /tmp/getppid;true' (50 runs):

     3,969,510,217 instructions             #	   0.864 IPC     ( +-0.000% )
     4,592,334,954 cycles                     ( +-   0.046% )
       751,634,470 branches                   ( +-   0.000% )

        1.722635797  seconds time elapsed   ( +-   0.046% )

Jump labels turned off (CONFIG_JUMP_LABEL not set), branch disabled:

 Performance counter stats for 'bash -c /tmp/getppid;true' (50 runs):

     4,009,611,846 instructions             #	   0.867 IPC     ( +-0.000% )
     4,622,210,580 cycles                     ( +-   0.012% )
       771,662,904 branches                   ( +-   0.000% )

        1.734341454  seconds time elapsed   ( +-   0.022% )

Signed-off-by: Jason Baron <jbaron@redhat.com>
Tested-by: Paul Turner <pjt@google.com>
---
 kernel/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 2d64cfc..329dfcc 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
-	    async.o range.o jump_label.o
+	    async.o range.o
 obj-y += groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
@@ -107,6 +107,7 @@ obj-$(CONFIG_PERF_EVENTS) += events/
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
+obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
-- 
1.7.5.4

