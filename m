Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423136Ab2CPQ3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:29:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53403 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1031359Ab2CPQ3M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:29:12 -0400
X-Authenticated: #5086196
X-Provags-ID: V01U2FsdGVkX19jGuBDrX5jtjME+oVnBudL0D1DmENn/Yd8MAOPES
	0SZn+mAG8oXTzq
From: Fawzi Mohamed <fawzi@gmx.ch>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] fix oops in updating thread cputime and task time
Date: Fri, 16 Mar 2012 17:29:09 +0100
Message-Id: <A4012A3B-7FF6-4ED8-8E00-51661D11CF4C@gmx.ch>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Dargel <td@chemie.hu-berlin.de>,
        Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1251.1)
X-Mailer: Apple Mail (2.1251.1)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a machine with a (back ported) fix working without problems since a few days.
We don´t consider it
	tested-by: Thomas Dargel <td@no-spam.hu-berlin.de>
because last time it did need 19 days of computation to happen, but it should be fixed.

Fawzi and Thomas.

>From fa4dccbaabaa1e08f3ca1835cc1b40e34a87fcdb Mon Sep 17 00:00:00 2001
From: Fawzi Mohamed <fawzi@gmx.ch>
Date: Mon, 12 Mar 2012 23:10:57 +0100
Subject: [PATCH] fix oops in updating thread cputime and task time

use div64_u64 instead of do_div to divide cputime_t with each other
because if cputime_t was u64 it would crash when overflowing u32.

    KERNEL: ./vmlinux-2.6.32.54-0.3-default.gz
 DEBUGINFO: .//vmlinux-2.6.32.54-0.3-default.debug
  DUMPFILE: ./vmcore
      CPUS: 24
      DATE: Mon Mar  5 00:58:10 2012
    UPTIME: 19 days, 11:01:56
LOAD AVERAGE: 0.74, 0.42, 0.40
     TASKS: 731
  NODENAME: node65
   RELEASE: 2.6.32.54-0.3-default
   VERSION: #1 SMP 2012-01-27 17:38:56 +0100
   MACHINE: x86_64  (3067 Mhz)
    MEMORY: 96 GB
     PANIC: ""
       PID: 11234
   COMMAND: "ricc2_smp"
      TASK: ffff881813de2240  [THREAD_INFO: ffff8818153c2000]
       CPU: 8
     STATE: TASK_RUNNING (PANIC)

crash> bt
PID: 11234  TASK: ffff881813de2240  CPU: 8   COMMAND: "ricc2_smp"
  RIP: 00007f5e4f418617  RSP: 00007f5e4dd3ebd0  RFLAGS: 00000202
  RAX: 0000000000000062  RBX: ffffffff81002f7b  RCX: 0000000000000179
  RDX: 00007f5e4dd3edb4  RSI: 00007f5e4dd3ec70  RDI: 0000000000000000
  RBP: 00007f5e4dd3ecf0   R8: 0000000000000001   R9: 00007f5e4dd3edc4
  R10: 0000000000000001  R11: 0000000000000246  R12: ffffffff8105eb81
  R13: 00007f5e4dd3ed30  R14: 00007f5e4dd3f2f0  R15: 0000000000000000
  ORIG_RAX: 0000000000000062  CS: 0033  SS: 002b

Basically the same problem was found earlier in kernel vmlinux-2.6.32.12-0.7-default.gz.

Signed-off-by: Fawzi Mohamed <fawzi@gmx.ch>
Signed-off-by: Thomas Dargel <td@no-spam.hu-berlin.de>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b342f57..f2cc092 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2934,7 +2934,7 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 		u64 temp = (__force u64) rtime;
 
 		temp *= (__force u64) utime;
-		do_div(temp, (__force u32) total);
+		temp = div64_u64(temp, total);
 		utime = (__force cputime_t) temp;
 	} else
 		utime = rtime;
@@ -2967,7 +2967,7 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 		u64 temp = (__force u64) rtime;
 
 		temp *= (__force u64) cputime.utime;
-		do_div(temp, (__force u32) total);
+		temp = div64_u64(temp, total);
 		utime = (__force cputime_t) temp;
 	} else
 		utime = rtime;
-- 
1.7.0.4

