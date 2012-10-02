Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab2JBNqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:46:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:58139 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab2JBNqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:46:17 -0400
Message-ID: <1349185563.7780.33.camel@twins>
Subject: Re: [PATCH] perf cgroups: Fix perf_cgroup_switch schedule in warning
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 02 Oct 2012 15:46:03 +0200
In-Reply-To: <CABPqkBSRTDbN7Sq9Pg0GOUFNiKGpVgOBY82ZMK--4Tgy9=iZDA@mail.gmail.com>
References: <20121002114218.GA5891@krava.brq.redhat.com>
	 <1349178781.7780.29.camel@twins>
	 <20121002123921.GB6379@krava.brq.redhat.com>
	 <CABPqkBQvhUk=3OU4brv0LefZnRn2xSALA2-cVmE3A1wazDT=XA@mail.gmail.com>
	 <1349183446.7780.32.camel@twins>
	 <CABPqkBSRTDbN7Sq9Pg0GOUFNiKGpVgOBY82ZMK--4Tgy9=iZDA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 15:34 +0200, Stephane Eranian wrote:
> > If you've got a good suggestion I'd be glad to rename it.
> 
> how about unique_pmu? 

Done!

---
Subject: perf: Clarify perf_cpu_context::active_pmu by renaming it
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Oct 02 15:38:52 CEST 2012

Stephane thought the perf_cpu_context::active_pmu name confusing and
suggested using unique_pmu instead.

This pointer is a pointer to a 'random' pmu sharing the cpuctx
instance, therefore limiting a for_each_pmu loop to those where
cpuctx->unique_pmu matches the pmu we get a loop over unique cpuctx
instances.

Suggested-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    2 +-
 kernel/events/core.c       |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1110,7 +1110,7 @@ struct perf_cpu_context {
 	int				exclusive;
 	struct list_head		rotation_list;
 	int				jiffies_interval;
-	struct pmu			*active_pmu;
+	struct pmu			*unique_pmu;
 	struct perf_cgroup		*cgrp;
 };
 
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4419,7 +4419,7 @@ static void perf_event_task_event(struct
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->active_pmu != pmu)
+		if (cpuctx->unique_pmu != pmu)
 			goto next;
 		perf_event_task_ctx(&cpuctx->ctx, task_event);
 
@@ -4565,7 +4565,7 @@ static void perf_event_comm_event(struct
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->active_pmu != pmu)
+		if (cpuctx->unique_pmu != pmu)
 			goto next;
 		perf_event_comm_ctx(&cpuctx->ctx, comm_event);
 
@@ -4761,7 +4761,7 @@ static void perf_event_mmap_event(struct
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->active_pmu != pmu)
+		if (cpuctx->unique_pmu != pmu)
 			goto next;
 		perf_event_mmap_ctx(&cpuctx->ctx, mmap_event,
 					vma->vm_flags & VM_EXEC);
@@ -5862,8 +5862,8 @@ static void update_pmu_context(struct pm
 
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 
-		if (cpuctx->active_pmu == old_pmu)
-			cpuctx->active_pmu = pmu;
+		if (cpuctx->unique_pmu == old_pmu)
+			cpuctx->unique_pmu = pmu;
 	}
 }
 
@@ -5998,7 +5998,7 @@ int perf_pmu_register(struct pmu *pmu, c
 		cpuctx->ctx.pmu = pmu;
 		cpuctx->jiffies_interval = 1;
 		INIT_LIST_HEAD(&cpuctx->rotation_list);
-		cpuctx->active_pmu = pmu;
+		cpuctx->unique_pmu = pmu;
 	}
 
 got_cpu_context:

