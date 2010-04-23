Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab0DWKvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:51:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:40724 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757171Ab0DWKvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:51:16 -0400
Date: Fri, 23 Apr 2010 10:49:40 GMT
From: tip-bot for Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       benh@kernel.crashing.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1271212509.13059.135.camel@pasglop>
References: <1271212509.13059.135.camel@pasglop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] mutex: Don't spin when the owner CPU is offline or other weird cases
Message-ID: <tip-4b402210486c6414fe5fbfd85934a0a22da56b04@git.kernel.org>
Git-Commit-ID: 4b402210486c6414fe5fbfd85934a0a22da56b04
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Apr 2010 10:49:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b402210486c6414fe5fbfd85934a0a22da56b04
Gitweb:     http://git.kernel.org/tip/4b402210486c6414fe5fbfd85934a0a22da56b04
Author:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
AuthorDate: Fri, 16 Apr 2010 23:20:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 23 Apr 2010 11:00:28 +0200

mutex: Don't spin when the owner CPU is offline or other weird cases

Due to recent load-balancer changes that delay the task migration to
the next wakeup, the adaptive mutex spinning ends up in a live lock
when the owner's CPU gets offlined because the cpu_online() check
lives before the owner running check.

This patch changes mutex_spin_on_owner() to return 0 (don't spin) in
any case where we aren't sure about the owner struct validity or CPU
number, and if the said CPU is offline. There is no point going back &
re-evaluate spinning in corner cases like that, let's just go to
sleep.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1271212509.13059.135.camel@pasglop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6af210a..de0bd26 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3780,7 +3780,7 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 	 * the mutex owner just released it and exited.
 	 */
 	if (probe_kernel_address(&owner->cpu, cpu))
-		goto out;
+		return 0;
 #else
 	cpu = owner->cpu;
 #endif
@@ -3790,14 +3790,14 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 	 * the cpu field may no longer be valid.
 	 */
 	if (cpu >= nr_cpumask_bits)
-		goto out;
+		return 0;
 
 	/*
 	 * We need to validate that we can do a
 	 * get_cpu() and that we have the percpu area.
 	 */
 	if (!cpu_online(cpu))
-		goto out;
+		return 0;
 
 	rq = cpu_rq(cpu);
 
@@ -3816,7 +3816,7 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 
 		cpu_relax();
 	}
-out:
+
 	return 1;
 }
 #endif
