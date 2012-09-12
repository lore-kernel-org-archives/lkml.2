Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab2ILXd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:33:27 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59246 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab2ILXdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:33:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 061/108] sched: fix divide by zero at {thread_group,task}_times
Date: Wed, 12 Sep 2012 16:28:59 -0700
Message-Id: <20120912232456.928692455@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit bea6832cc8c4a0a9a65dd17da6aaa657fe27bc3e upstream.

On architectures where cputime_t is 64 bit type, is possible to trigger
divide by zero on do_div(temp, (__force u32) total) line, if total is a
non zero number but has lower 32 bit's zeroed. Removing casting is not
a good solution since some do_div() implementations do cast to u32
internally.

This problem can be triggered in practice on very long lived processes:

  PID: 2331   TASK: ffff880472814b00  CPU: 2   COMMAND: "oraagent.bin"
   #0 [ffff880472a51b70] machine_kexec at ffffffff8103214b
   #1 [ffff880472a51bd0] crash_kexec at ffffffff810b91c2
   #2 [ffff880472a51ca0] oops_end at ffffffff814f0b00
   #3 [ffff880472a51cd0] die at ffffffff8100f26b
   #4 [ffff880472a51d00] do_trap at ffffffff814f03f4
   #5 [ffff880472a51d60] do_divide_error at ffffffff8100cfff
   #6 [ffff880472a51e00] divide_error at ffffffff8100be7b
      [exception RIP: thread_group_times+0x56]
      RIP: ffffffff81056a16  RSP: ffff880472a51eb8  RFLAGS: 00010046
      RAX: bc3572c9fe12d194  RBX: ffff880874150800  RCX: 0000000110266fad
      RDX: 0000000000000000  RSI: ffff880472a51eb8  RDI: 001038ae7d9633dc
      RBP: ffff880472a51ef8   R8: 00000000b10a3a64   R9: ffff880874150800
      R10: 00007fcba27ab680  R11: 0000000000000202  R12: ffff880472a51f08
      R13: ffff880472a51f10  R14: 0000000000000000  R15: 0000000000000007
      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
   #7 [ffff880472a51f00] do_sys_times at ffffffff8108845d
   #8 [ffff880472a51f40] sys_times at ffffffff81088524
   #9 [ffff880472a51f80] system_call_fastpath at ffffffff8100b0f2
      RIP: 0000003808caac3a  RSP: 00007fcba27ab6d8  RFLAGS: 00000202
      RAX: 0000000000000064  RBX: ffffffff8100b0f2  RCX: 0000000000000000
      RDX: 00007fcba27ab6e0  RSI: 000000000076d58e  RDI: 00007fcba27ab6e0
      RBP: 00007fcba27ab700   R8: 0000000000000020   R9: 000000000000091b
      R10: 00007fcba27ab680  R11: 0000000000000202  R12: 00007fff9ca41940
      R13: 0000000000000000  R14: 00007fcba27ac9c0  R15: 00007fff9ca41940
      ORIG_RAX: 0000000000000064  CS: 0033  SS: 002b

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120808092714.GA3580@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3142,6 +3142,20 @@ void thread_group_times(struct task_stru
 # define nsecs_to_cputime(__nsecs)	nsecs_to_jiffies(__nsecs)
 #endif
 
+static cputime_t scale_utime(cputime_t utime, cputime_t rtime, cputime_t total)
+{
+	u64 temp = (__force u64) rtime;
+
+	temp *= (__force u64) utime;
+
+	if (sizeof(cputime_t) == 4)
+		temp = div_u64(temp, (__force u32) total);
+	else
+		temp = div64_u64(temp, (__force u64) total);
+
+	return (__force cputime_t) temp;
+}
+
 void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
 	cputime_t rtime, utime = p->utime, total = utime + p->stime;
@@ -3151,13 +3165,9 @@ void task_times(struct task_struct *p, c
 	 */
 	rtime = nsecs_to_cputime(p->se.sum_exec_runtime);
 
-	if (total) {
-		u64 temp = (__force u64) rtime;
-
-		temp *= (__force u64) utime;
-		do_div(temp, (__force u32) total);
-		utime = (__force cputime_t) temp;
-	} else
+	if (total)
+		utime = scale_utime(utime, rtime, total);
+	else
 		utime = rtime;
 
 	/*
@@ -3184,13 +3194,9 @@ void thread_group_times(struct task_stru
 	total = cputime.utime + cputime.stime;
 	rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
 
-	if (total) {
-		u64 temp = (__force u64) rtime;
-
-		temp *= (__force u64) cputime.utime;
-		do_div(temp, (__force u32) total);
-		utime = (__force cputime_t) temp;
-	} else
+	if (total)
+		utime = scale_utime(cputime.utime, rtime, total);
+	else
 		utime = rtime;
 
 	sig->prev_utime = max(sig->prev_utime, utime);


