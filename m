Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1AZMKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:10:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:39670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab1AZMKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:10:22 -0500
Date: Wed, 26 Jan 2011 12:09:50 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110122044851.734245014@google.com>
References: <20110122044851.734245014@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix sign under-flows in wake_affine
Message-ID: <tip-e37b6a7b27b400c3aa488db8c6629a05095bc79c@git.kernel.org>
Git-Commit-ID: e37b6a7b27b400c3aa488db8c6629a05095bc79c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 12:09:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e37b6a7b27b400c3aa488db8c6629a05095bc79c
Gitweb:     http://git.kernel.org/tip/e37b6a7b27b400c3aa488db8c6629a05095bc79c
Author:     Paul Turner <pjt@google.com>
AuthorDate: Fri, 21 Jan 2011 20:44:59 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 12:31:01 +0100

sched: Fix sign under-flows in wake_affine

While care is taken around the zero-point in effective_load to not exceed
the instantaneous rq->weight, it's still possible (e.g. using wake_idx != 0)
for (load + effective_load) to underflow.

In this case the comparing the unsigned values can result in incorrect balanced
decisions.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110122044851.734245014@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3547699..ccecfec 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1432,7 +1432,7 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
 
 static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
-	unsigned long this_load, load;
+	s64 this_load, load;
 	int idx, this_cpu, prev_cpu;
 	unsigned long tl_per_task;
 	struct task_group *tg;
@@ -1471,8 +1471,8 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	 * Otherwise check if either cpus are near enough in load to allow this
 	 * task to be woken on this_cpu.
 	 */
-	if (this_load) {
-		unsigned long this_eff_load, prev_eff_load;
+	if (this_load > 0) {
+		s64 this_eff_load, prev_eff_load;
 
 		this_eff_load = 100;
 		this_eff_load *= power_of(prev_cpu);
