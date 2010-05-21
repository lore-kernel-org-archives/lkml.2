Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab0EULbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 07:31:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:32881 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801Ab0EULbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 07:31:05 -0400
Date: Fri, 21 May 2010 11:30:33 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100521090710.904944001@chello.nl>
References: <20100521090710.904944001@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize perf_tp_event_match()
Message-ID: <tip-580d607cd666dfabfc1c7b0fb08c8ac690c7c87f@git.kernel.org>
Git-Commit-ID: 580d607cd666dfabfc1c7b0fb08c8ac690c7c87f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 May 2010 11:30:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  580d607cd666dfabfc1c7b0fb08c8ac690c7c87f
Gitweb:     http://git.kernel.org/tip/580d607cd666dfabfc1c7b0fb08c8ac690c7c87f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 20 May 2010 20:54:31 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 May 2010 11:38:00 +0200

perf: Optimize perf_tp_event_match()

Since we know tracepoints come from kernel context,
avoid conditionals that try and establish that very
fact.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100521090710.904944001@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index d25c864..e099650 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4496,7 +4496,10 @@ static int perf_tp_event_match(struct perf_event *event,
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
-	if (perf_exclude_event(event, regs))
+	/*
+	 * All tracepoints are from kernel-space.
+	 */
+	if (event->attr.exclude_kernel)
 		return 0;
 
 	if (!perf_tp_filter_match(event, data))
