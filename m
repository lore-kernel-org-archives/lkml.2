Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1ARQSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 11:18:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab1ARQSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 11:18:15 -0500
Date: Tue, 18 Jan 2011 17:10:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH 2/2] perf: validate cpu early in perf_event_alloc()
Message-ID: <20110118161032.GC693@redhat.com>
References: <20101108145647.GA3426@redhat.com> <20110117203459.GA32700@redhat.com> <1295297576.30950.382.camel@laptop> <20110118160942.GA693@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110118160942.GA693@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting from perf_event_alloc()->perf_init_event(), the kernel
assumes that event->cpu is either -1 or the valid CPU number.

Change perf_event_alloc() to validate this argument early. This
also means we can remove the similar check in find_get_context().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/perf_event.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- git/kernel/perf_event.c~2_perf_event_alloc	2011-01-18 16:56:40.000000000 +0100
+++ git/kernel/perf_event.c	2011-01-18 16:57:08.000000000 +0100
@@ -2233,9 +2233,6 @@ find_get_context(struct pmu *pmu, struct
 		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
 			return ERR_PTR(-EACCES);
 
-		if (cpu < 0 || cpu >= nr_cpumask_bits)
-			return ERR_PTR(-EINVAL);
-
 		/*
 		 * We could be clever and allow to attach a event to an
 		 * offline CPU and activate it when the CPU comes up, but
@@ -5541,6 +5538,11 @@ perf_event_alloc(struct perf_event_attr 
 	struct hw_perf_event *hwc;
 	long err;
 
+	if ((unsigned)cpu >= nr_cpu_ids) {
+		if (!task || cpu != -1)
+			return ERR_PTR(-EINVAL);
+	}
+
 	event = kzalloc(sizeof(*event), GFP_KERNEL);
 	if (!event)
 		return ERR_PTR(-ENOMEM);
@@ -5589,7 +5591,7 @@ perf_event_alloc(struct perf_event_attr 
 
 	if (!overflow_handler && parent_event)
 		overflow_handler = parent_event->overflow_handler;
-	
+
 	event->overflow_handler	= overflow_handler;
 
 	if (attr->disabled)

