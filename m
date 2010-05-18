Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab0ERNq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 09:46:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:54186 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516Ab0ERNqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 09:46:45 -0400
Message-Id: <20100518133726.128688672@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 18 May 2010 15:33:02 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/5] perf: Avoid local_xchg
References: <20100518133258.000434886@chello.nl>
Content-Disposition: inline; filename=perf-buffer-no-xchg-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the x86 XCHG ins implies LOCK, avoid the use by using a sequence
count instead.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    1 +
 kernel/perf_event.c        |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -804,6 +804,7 @@ struct perf_output_handle {
 	struct perf_mmap_data		*data;
 	unsigned long			head;
 	unsigned long			offset;
+	unsigned long			wakeup;
 	int				nmi;
 	int				sample;
 };
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -2917,6 +2917,7 @@ static void perf_output_get_handle(struc
 
 	preempt_disable();
 	local_inc(&data->nest);
+	handle->wakeup = local_read(&data->wakeup);
 }
 
 static void perf_output_put_handle(struct perf_output_handle *handle)
@@ -2950,7 +2951,7 @@ again:
 		goto again;
 	}
 
-	if (local_xchg(&data->wakeup, 0))
+	if (handle->wakeup != local_read(&data->wakeup))
 		perf_output_wakeup(handle);
 
 	preempt_enable();


