Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab1ASSaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 13:30:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab1ASSaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:30:19 -0500
Date: Wed, 19 Jan 2011 19:22:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] perf: fix
	perf_event_init_task()/perf_event_free_task() interaction
Message-ID: <20110119182228.GC12183@redhat.com>
References: <20101108145647.GA3426@redhat.com> <20101108145725.GA3434@redhat.com> <20110119182141.GA12183@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119182141.GA12183@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_event_init_task() should clear child->perf_event_ctxp[] before
anything else. Otherwise, if perf_event_init_context(perf_hw_context)
fails, perf_event_free_task() can free perf_event_ctxp[perf_sw_context]
copied from parent->perf_event_ctxp[] by dup_task_struct().

Also move the initialization of perf_event_mutex and perf_event_list
from perf_event_init_context() to perf_event_init_context().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/perf_event.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- git/kernel/perf_event.c~4_perf_event_init_task	2011-01-19 17:41:16.000000000 +0100
+++ git/kernel/perf_event.c	2011-01-19 18:49:23.000000000 +0100
@@ -6446,11 +6446,6 @@ int perf_event_init_context(struct task_
 	unsigned long flags;
 	int ret = 0;
 
-	child->perf_event_ctxp[ctxn] = NULL;
-
-	mutex_init(&child->perf_event_mutex);
-	INIT_LIST_HEAD(&child->perf_event_list);
-
 	if (likely(!parent->perf_event_ctxp[ctxn]))
 		return 0;
 
@@ -6540,6 +6535,10 @@ int perf_event_init_task(struct task_str
 {
 	int ctxn, ret;
 
+	memset(child->perf_event_ctxp, 0, sizeof(child->perf_event_ctxp));
+	mutex_init(&child->perf_event_mutex);
+	INIT_LIST_HEAD(&child->perf_event_list);
+
 	for_each_task_context_nr(ctxn) {
 		ret = perf_event_init_context(child, ctxn);
 		if (ret)

