Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab0INNqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 09:46:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab0INNp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 09:45:59 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>,
        stable@kernel.org.#.2.6.32.19+ (partially), 2.6.33+@redhat.com
Subject: [PATCH] sched: fix user time incorrectly accounted as system time on 32 bit
Date: Tue, 14 Sep 2010 15:44:52 +0200
Message-Id: <1284471892-8433-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have 32 bit variable overflow possibility when multiply in
task_times() and thread_group_times() functions. If overflow happens
calculated scaled utime value become wrongly small and scaled stime
wrongly big.

Reported here:
https://bugzilla.redhat.com/show_bug.cgi?id=633037
https://bugzilla.kernel.org/show_bug.cgi?id=16559

Reported-by: Michael Chapman <redhat-bugzilla@very.puzzling.org>
Reported-by: Ciriaco Garcia de Celis <sysman@etherpilot.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@kernel.org  # 2.6.32.19+ (partially), 2.6.33+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/sched.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 09b574e..eee9470 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3507,9 +3507,9 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	rtime = nsecs_to_cputime(p->se.sum_exec_runtime);
 
 	if (total) {
-		u64 temp;
+		u64 temp = rtime;
 
-		temp = (u64)(rtime * utime);
+		temp *= utime;
 		do_div(temp, total);
 		utime = (cputime_t)temp;
 	} else
@@ -3540,9 +3540,9 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
 
 	if (total) {
-		u64 temp;
+		u64 temp = rtime;
 
-		temp = (u64)(rtime * cputime.utime);
+		temp *= cputime.utime;
 		do_div(temp, total);
 		utime = (cputime_t)temp;
 	} else
-- 
1.7.1

