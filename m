Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab2JBNrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:47:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:58158 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2JBNrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:47:01 -0400
Message-ID: <1349185609.7780.34.camel@twins>
Subject: Re: [PATCH] perf cgroups: Fix perf_cgroup_switch schedule in warning
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 02 Oct 2012 15:46:49 +0200
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
> And adding a comment in cgroup_switch()
> 
> +               /* ensure we process each cpuctx only once */
> +               if (cpuctx->active_pmu != pmu)
> +                       continue;
> 
---
Subject: perf: Fix perf_cgroup_switch for sw-events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Oct 02 15:41:23 CEST 2012

Jiri reported that he could trigger the WARN_ON_ONCE() in
perf_cgroup_switch() using sw-events. This is because sw-events share
a cpuctx with multiple PMUs.

Use the ->unique_pmu pointer to limit the pmu iteration to unique
cpuctx instances.

Reported-and-Tested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/events/core.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -372,6 +372,8 @@ void perf_cgroup_switch(struct task_stru
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		if (cpuctx->unique_pmu != pmu)
+			continue; /* ensure we process each cpuctx once */
 
 		/*
 		 * perf_cgroup_events says at least one
@@ -395,9 +397,10 @@ void perf_cgroup_switch(struct task_stru
 
 			if (mode & PERF_CGROUP_SWIN) {
 				WARN_ON_ONCE(cpuctx->cgrp);
-				/* set cgrp before ctxsw in to
-				 * allow event_filter_match() to not
-				 * have to pass task around
+				/*
+				 * set cgrp before ctxsw in to allow
+				 * event_filter_match() to not have to pass
+				 * task around
 				 */
 				cpuctx->cgrp = perf_cgroup_from_task(task);
 				cpu_ctx_sched_in(cpuctx, EVENT_ALL, task);

