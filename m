Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1ABHte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:49:34 -0500
Received: from mail.windriver.com ([147.11.1.11]:35870 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab1ABHXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:49 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 129/260] sched: Fix user time incorrectly accounted as system time on 32-bit
Date: Sun,  2 Jan 2011 02:17:05 -0500
Message-Id: <1293952756-15010-130-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:31.0087 (UTC) FILETIME=[D14CDBF0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit e75e863dd5c7d96b91ebbd241da5328fc38a78cc upstream.

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
LKML-Reference: <20100914143513.GB8415@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sched.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b741de5..dd7c170 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3428,9 +3428,9 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	rtime = nsecs_to_cputime(p->se.sum_exec_runtime);
 
 	if (total) {
-		u64 temp;
+		u64 temp = rtime;
 
-		temp = (u64)(rtime * utime);
+		temp *= utime;
 		do_div(temp, total);
 		utime = (cputime_t)temp;
 	} else
@@ -3461,9 +3461,9 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
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
1.7.3.3

