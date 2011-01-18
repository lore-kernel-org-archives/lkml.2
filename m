Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1ARTH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:07:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:50275 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab1ARTHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:07:55 -0500
Date: Tue, 18 Jan 2011 19:07:23 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, stern@rowland.harvard.edu,
        a.p.zijlstra@chello.nl, roland@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu,
        prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, roland@redhat.com,
        oleg@redhat.com, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <20110118161032.GC693@redhat.com>
References: <20110118161032.GC693@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Validate cpu early in perf_event_alloc()
Message-ID: <tip-66832eb4baaaa9abe4c993ddf9113a79e39b9915@git.kernel.org>
Git-Commit-ID: 66832eb4baaaa9abe4c993ddf9113a79e39b9915
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 Jan 2011 19:07:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  66832eb4baaaa9abe4c993ddf9113a79e39b9915
Gitweb:     http://git.kernel.org/tip/66832eb4baaaa9abe4c993ddf9113a79e39b9915
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 18 Jan 2011 17:10:32 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Jan 2011 19:34:23 +0100

perf: Validate cpu early in perf_event_alloc()

Starting from perf_event_alloc()->perf_init_event(), the kernel
assumes that event->cpu is either -1 or the valid CPU number.

Change perf_event_alloc() to validate this argument early. This
also means we can remove the similar check in
find_get_context().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: gregkh@suse.de
Cc: stable@kernel.org
LKML-Reference: <20110118161032.GC693@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a962b19..67d9bd7 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2233,9 +2233,6 @@ find_get_context(struct pmu *pmu, struct task_struct *task, int cpu)
 		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
 			return ERR_PTR(-EACCES);
 
-		if (cpu < 0 || cpu >= nr_cpumask_bits)
-			return ERR_PTR(-EINVAL);
-
 		/*
 		 * We could be clever and allow to attach a event to an
 		 * offline CPU and activate it when the CPU comes up, but
@@ -5541,6 +5538,11 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
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
@@ -5589,7 +5591,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 	if (!overflow_handler && parent_event)
 		overflow_handler = parent_event->overflow_handler;
-	
+
 	event->overflow_handler	= overflow_handler;
 
 	if (attr->disabled)
