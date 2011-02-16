Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab1BPAi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:38:27 -0500
Received: from kroah.org ([198.145.64.141]:49551 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207Ab1BPAXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:45 2011
Message-Id: <20110216001445.752474283@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [206/272] perf: Validate cpu early in perf_event_alloc()
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 66832eb4baaaa9abe4c993ddf9113a79e39b9915 upstream.

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
LKML-Reference: <20110118161032.GC693@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2105,9 +2105,6 @@ find_get_context(struct pmu *pmu, struct
 		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
 			return ERR_PTR(-EACCES);
 
-		if (cpu < 0 || cpu >= nr_cpumask_bits)
-			return ERR_PTR(-EINVAL);
-
 		/*
 		 * We could be clever and allow to attach a event to an
 		 * offline CPU and activate it when the CPU comes up, but
@@ -5304,6 +5301,11 @@ perf_event_alloc(struct perf_event_attr
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
@@ -5352,7 +5354,7 @@ perf_event_alloc(struct perf_event_attr
 
 	if (!overflow_handler && parent_event)
 		overflow_handler = parent_event->overflow_handler;
-	
+
 	event->overflow_handler	= overflow_handler;
 
 	if (attr->disabled)


