Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab0ERNqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 09:46:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:54185 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757534Ab0ERNqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 09:46:45 -0400
Message-Id: <20100518133725.885757039@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 18 May 2010 15:32:59 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/5] perf: Disallow mmap() on per-task inherited events
References: <20100518133258.000434886@chello.nl>
Content-Disposition: inline; filename=perf-disallow-inherited-mmap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we now have working per-task-per-cpu events for a while,
disallow mmap() on per-task inherited events. Those things were
a performance problem anyway, and doing away with it allows
us to optimize the buffer somewhat by assuming there is only a single
writer.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -2580,6 +2580,14 @@ static int perf_mmap(struct file *file, 
 	long user_extra, extra;
 	int ret = 0;
 
+	/*
+	 * Don't allow mmap() of inherited per-task counters. This would
+	 * create a performance issue due to all children writing to the
+	 * same buffer.
+	 */
+	if (event->cpu == -1 && event->attr.inherit)
+		return -EINVAL;
+
 	if (!(vma->vm_flags & VM_SHARED))
 		return -EINVAL;
 


