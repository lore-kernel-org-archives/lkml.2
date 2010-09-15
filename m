Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab0IOKCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:02:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:53703 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab0IOKCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:02:10 -0400
Date: Wed, 15 Sep 2010 10:01:31 GMT
From: tip-bot for Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        seto.hidetoshi@jp.fujitsu.com, a.p.zijlstra@chello.nl,
        redhat-bugzilla@very.puzzling.org, sysman@etherpilot.com,
        tglx@linutronix.de, sgruszka@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, seto.hidetoshi@jp.fujitsu.com,
        redhat-bugzilla@very.puzzling.org, sysman@etherpilot.com,
        tglx@linutronix.de, sgruszka@redhat.com, mingo@elte.hu
In-Reply-To: <20100914143513.GB8415@redhat.com>
References: <20100914143513.GB8415@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix user time incorrectly accounted as system time on 32-bit
Message-ID: <tip-e75e863dd5c7d96b91ebbd241da5328fc38a78cc@git.kernel.org>
Git-Commit-ID: e75e863dd5c7d96b91ebbd241da5328fc38a78cc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Sep 2010 10:01:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e75e863dd5c7d96b91ebbd241da5328fc38a78cc
Gitweb:     http://git.kernel.org/tip/e75e863dd5c7d96b91ebbd241da5328fc38a78cc
Author:     Stanislaw Gruszka <sgruszka@redhat.com>
AuthorDate: Tue, 14 Sep 2010 16:35:14 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 15 Sep 2010 10:41:36 +0200

sched: Fix user time incorrectly accounted as system time on 32-bit

We have 32-bit variable overflow possibility when multiply in
task_times() and thread_group_times() functions. When the
overflow happens then the scaled utime value becomes erroneously
small and the scaled stime becomes i erroneously big.

Reported here:

 https://bugzilla.redhat.com/show_bug.cgi?id=633037
 https://bugzilla.kernel.org/show_bug.cgi?id=16559

Reported-by: Michael Chapman <redhat-bugzilla@very.puzzling.org>
Reported-by: Ciriaco Garcia de Celis <sysman@etherpilot.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: <stable@kernel.org>  # 2.6.32.19+ (partially) and 2.6.33+
LKML-Reference: <20100914143513.GB8415@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ed09d4f..dc85ceb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3513,9 +3513,9 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	rtime = nsecs_to_cputime(p->se.sum_exec_runtime);
 
 	if (total) {
-		u64 temp;
+		u64 temp = rtime;
 
-		temp = (u64)(rtime * utime);
+		temp *= utime;
 		do_div(temp, total);
 		utime = (cputime_t)temp;
 	} else
@@ -3546,9 +3546,9 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
 
 	if (total) {
-		u64 temp;
+		u64 temp = rtime;
 
-		temp = (u64)(rtime * cputime.utime);
+		temp *= cputime.utime;
 		do_div(temp, total);
 		utime = (cputime_t)temp;
 	} else
