Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab1HIO3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:29:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:37392 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab1HIO3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:29:44 -0400
Date: Tue, 9 Aug 2011 14:29:36 GMT
From: tip-bot for Jason Baron <jbaron@redhat.com>
Message-ID: <tip-b77f0f3c1f587791aa5d9bd1b0012c9a89eb9258@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        pjt@google.com, jbaron@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
In-Reply-To: <20110805204040.GG2522@redhat.com>
References: <20110805204040.GG2522@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] jump label: Reduce the cycle count by changing the link order
Git-Commit-ID: b77f0f3c1f587791aa5d9bd1b0012c9a89eb9258
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Aug 2011 14:29:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b77f0f3c1f587791aa5d9bd1b0012c9a89eb9258
Gitweb:     http://git.kernel.org/tip/b77f0f3c1f587791aa5d9bd1b0012c9a89eb9258
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Fri, 5 Aug 2011 16:40:40 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 5 Aug 2011 23:57:33 +0200

jump label: Reduce the cycle count by changing the link order

In the course of testing jump labels for use with the CFS
bandwidth controller, Paul Turner, discovered that using jump
labels reduced the branch count and the instruction count, but
did not reduce the cycle count or wall time.

I noticed that having the jump_label.o included in the kernel
but not used in any way still caused this increase in cycle
count and wall time. Thus, I moved jump_label.o in the
kernel/Makefile, thus changing the link order, and presumably
moving it out of hot icache areas. This brought down the cycle
count/time as expected.

In addition to Paul's testing,  I've tested the patch using a
single 'static_branch()' in the getppid() path, and basically
running tight loops of calls to getppid(). Here are my results
for the branch disabled case:

With jump labels turned on (CONFIG_JUMP_LABEL), branch disabled:

 Performance counter stats for 'bash -c /tmp/getppid;true' (50 runs):

     3,969,510,217 instructions             #	   0.864 IPC     ( +-0.000% )
     4,592,334,954 cycles                     ( +-   0.046% )
       751,634,470 branches                   ( +-   0.000% )

        1.722635797  seconds time elapsed   ( +-   0.046% )

Jump labels turned off (CONFIG_JUMP_LABEL not set), branch
disabled:

 Performance counter stats for 'bash -c /tmp/getppid;true' (50 runs):

     4,009,611,846 instructions             #	   0.867 IPC     ( +-0.000% )
     4,622,210,580 cycles                     ( +-   0.012% )
       771,662,904 branches                   ( +-   0.000% )

        1.734341454  seconds time elapsed   ( +-   0.022% )

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: rth@redhat.com
Cc: a.p.zijlstra@chello.nl
Cc: rostedt@goodmis.org
Link: http://lkml.kernel.org/r/20110805204040.GG2522@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Tested-by: Paul Turner <pjt@google.com>
---
 kernel/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index d06467f..eca595e 100644
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
