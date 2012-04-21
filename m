Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab2DUIYf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 04:24:35 -0400
Received: from nk11p00mm-asmtp003.mac.com ([17.158.161.2]:52724 "EHLO
	nk11p00mm-asmtp003.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709Ab2DUIYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 04:24:31 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Apr 2012 04:24:31 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.6.7580,1.0.260,0.0.0000
 definitions=2012-04-21_02:2012-04-20,2012-04-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1204210007
Subject: Re: [PATCH] fix oops in updating thread cputime and task time
From: Fawzi Mohamed <fmohamed@me.com>
In-reply-to: <A4012A3B-7FF6-4ED8-8E00-51661D11CF4C@gmx.ch>
Date: Sat, 21 Apr 2012 09:23:52 +0200
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Dargel <td@chemie.hu-berlin.de>,
        Hillf Danton <dhillf@gmail.com>
Message-id: <301628B7-B058-4C01-9A65-F2A4AAF05EE6@me.com>
References: <A4012A3B-7FF6-4ED8-8E00-51661D11CF4C@gmx.ch>
To: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An update on this, it successfully passed our testing (more than 35 days of uptime/computation without problems), so we rebased, added tested-by it and submit it again.

>From d0a7d56c283205806d122442448063d2c8812669 Mon Sep 17 00:00:00 2001
From: Fawzi Mohamed <fawzi@gmx.ch>
Date: Mon, 12 Mar 2012 23:10:57 +0100
Subject: [PATCH] fix oops in updating thread cputime and task time

use div64_u64 instead of do_div to divide cputime_t with each other
because if cputime_t is u64 it does crash when overflowing u32.

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

This patch was tested on 2.6.32 (as some kernel modules we need
require it) and the computation ran for more than 35 days without
any problems, before it would crash after 19 days of that ricc2 computation.

Signed-off-by: Fawzi Mohamed <fawzi@gmx.ch>
Signed-off-by: Thomas Dargel <td@no-spam.hu-berlin.de>
Tested-by: Thomas Dargel <td@no-spam.hu-berlin.de>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4603b9d..03a2d89 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2966,7 +2966,7 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 		u64 temp = (__force u64) rtime;
 
 		temp *= (__force u64) utime;
-		do_div(temp, (__force u32) total);
+		temp = div64_u64(temp, total);
 		utime = (__force cputime_t) temp;
 	} else
 		utime = rtime;
@@ -2999,7 +2999,7 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 		u64 temp = (__force u64) rtime;
 
 		temp *= (__force u64) cputime.utime;
-		do_div(temp, (__force u32) total);
+		temp = div64_u64(temp, total);
 		utime = (__force cputime_t) temp;
 	} else
 		utime = rtime;
-- 
1.7.0.4

