Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750892Ab1AVFEm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 00:04:42 -0500
Received: from smtp-out.google.com ([216.239.44.51]:5504 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab1AVFEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 00:04:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:
	content-disposition:x-system-of-record;
	b=QAPx8U2eyK3aKm/ZmyG6onqu13PG+QFeMeCE9mqjiNqmljisFfz2OYYBTokt7cmx5
	xH71B8wvYxQuLaAGLSzQA==
Message-Id: <20110122044851.734245014@google.com>
User-Agent: quilt/0.48-1
Date: Fri, 21 Jan 2011 20:44:59 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: [patch 1/5] sched: fix sign under-flows in wake_affine
References: <20110122044458.058531078@google.com>
Content-Disposition: inline; filename=sched-signed_wake_affine.patch
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While care is taken around the zero-point in effective_load to not exceed
the instantaneous rq->weight, it's still possible (e.g. using wake_idx != 0)
for (load + effective_load) to underflow.

In this case the comparing the unsigned values can result in incorrect balanced
decisions.

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched_fair.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: tip3/kernel/sched_fair.c
===================================================================
--- tip3.orig/kernel/sched_fair.c
+++ tip3/kernel/sched_fair.c
@@ -1404,7 +1404,7 @@ static inline unsigned long effective_lo
 
 static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
-	unsigned long this_load, load;
+	s64 this_load, load;
 	int idx, this_cpu, prev_cpu;
 	unsigned long tl_per_task;
 	struct task_group *tg;
@@ -1443,8 +1443,8 @@ static int wake_affine(struct sched_doma
 	 * Otherwise check if either cpus are near enough in load to allow this
 	 * task to be woken on this_cpu.
 	 */
-	if (this_load) {
-		unsigned long this_eff_load, prev_eff_load;
+	if (this_load > 0) {
+		s64 this_eff_load, prev_eff_load;
 
 		this_eff_load = 100;
 		this_eff_load *= power_of(prev_cpu);


