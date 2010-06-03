Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab0FCRz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:55:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:45916 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931Ab0FCRzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:55:23 -0400
Date: Thu, 3 Jun 2010 17:54:48 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1275557609.27810.35218.camel@twins>
References: <1275557609.27810.35218.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix crash in swevents
Message-ID: <tip-c6df8d5ab87a246942d138321e1721edbb69f6e1@git.kernel.org>
Git-Commit-ID: c6df8d5ab87a246942d138321e1721edbb69f6e1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 03 Jun 2010 17:54:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c6df8d5ab87a246942d138321e1721edbb69f6e1
Gitweb:     http://git.kernel.org/tip/c6df8d5ab87a246942d138321e1721edbb69f6e1
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 3 Jun 2010 11:21:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Jun 2010 17:03:08 +0200

perf: Fix crash in swevents

Frederic reported that because swevents handling doesn't disable IRQs
anymore, we can get a recursion of perf_adjust_period(), once from
overflow handling and once from the tick.

If both call ->disable, we get a double hlist_del_rcu() and trigger
a LIST_POISON2 dereference.

Since we don't actually need to stop/start a swevent to re-programm
the hardware (lack of hardware to program), simply nop out these
callbacks for the swevent pmu.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1275557609.27810.35218.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 858f56f..31d6afe 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4055,13 +4055,6 @@ static void perf_swevent_overflow(struct perf_event *event, u64 overflow,
 	}
 }
 
-static void perf_swevent_unthrottle(struct perf_event *event)
-{
-	/*
-	 * Nothing to do, we already reset hwc->interrupts.
-	 */
-}
-
 static void perf_swevent_add(struct perf_event *event, u64 nr,
 			       int nmi, struct perf_sample_data *data,
 			       struct pt_regs *regs)
@@ -4276,11 +4269,22 @@ static void perf_swevent_disable(struct perf_event *event)
 	hlist_del_rcu(&event->hlist_entry);
 }
 
+static void perf_swevent_void(struct perf_event *event)
+{
+}
+
+static int perf_swevent_int(struct perf_event *event)
+{
+	return 0;
+}
+
 static const struct pmu perf_ops_generic = {
 	.enable		= perf_swevent_enable,
 	.disable	= perf_swevent_disable,
+	.start		= perf_swevent_int,
+	.stop		= perf_swevent_void,
 	.read		= perf_swevent_read,
-	.unthrottle	= perf_swevent_unthrottle,
+	.unthrottle	= perf_swevent_void, /* hwc->interrupts already reset */
 };
 
 /*
@@ -4561,8 +4565,10 @@ static int swevent_hlist_get(struct perf_event *event)
 static const struct pmu perf_ops_tracepoint = {
 	.enable		= perf_trace_enable,
 	.disable	= perf_trace_disable,
+	.start		= perf_swevent_int,
+	.stop		= perf_swevent_void,
 	.read		= perf_swevent_read,
-	.unthrottle	= perf_swevent_unthrottle,
+	.unthrottle	= perf_swevent_void,
 };
 
 static int perf_tp_filter_match(struct perf_event *event,
