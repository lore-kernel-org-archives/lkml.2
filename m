Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1ASTTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 14:19:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:49581 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab1ASTTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 14:19:42 -0500
Date: Wed, 19 Jan 2011 19:19:12 GMT
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
In-Reply-To: <20110119182228.GC12183@redhat.com>
References: <20110119182228.GC12183@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix perf_event_init_task()/perf_event_free_task() interaction
Message-ID: <tip-8550d7cb6ed6c89add49c3b6ad4c753ab8a3d7f9@git.kernel.org>
Git-Commit-ID: 8550d7cb6ed6c89add49c3b6ad4c753ab8a3d7f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 Jan 2011 19:19:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8550d7cb6ed6c89add49c3b6ad4c753ab8a3d7f9
Gitweb:     http://git.kernel.org/tip/8550d7cb6ed6c89add49c3b6ad4c753ab8a3d7f9
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Wed, 19 Jan 2011 19:22:28 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 Jan 2011 20:04:28 +0100

perf: Fix perf_event_init_task()/perf_event_free_task() interaction

perf_event_init_task() should clear child->perf_event_ctxp[]
before anything else. Otherwise, if
perf_event_init_context(perf_hw_context) fails,
perf_event_free_task() can free perf_event_ctxp[perf_sw_context]
copied from parent->perf_event_ctxp[] by dup_task_struct().

Also move the initialization of perf_event_mutex and
perf_event_list from perf_event_init_context() to
perf_event_init_context().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
LKML-Reference: <20110119182228.GC12183@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 4ec55ef..244ca3a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -6446,11 +6446,6 @@ int perf_event_init_context(struct task_struct *child, int ctxn)
 	unsigned long flags;
 	int ret = 0;
 
-	child->perf_event_ctxp[ctxn] = NULL;
-
-	mutex_init(&child->perf_event_mutex);
-	INIT_LIST_HEAD(&child->perf_event_list);
-
 	if (likely(!parent->perf_event_ctxp[ctxn]))
 		return 0;
 
@@ -6539,6 +6534,10 @@ int perf_event_init_task(struct task_struct *child)
 {
 	int ctxn, ret;
 
+	memset(child->perf_event_ctxp, 0, sizeof(child->perf_event_ctxp));
+	mutex_init(&child->perf_event_mutex);
+	INIT_LIST_HEAD(&child->perf_event_list);
+
 	for_each_task_context_nr(ctxn) {
 		ret = perf_event_init_context(child, ctxn);
 		if (ret)
