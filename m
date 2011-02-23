Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab1BWMHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:07:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:56523 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab1BWMHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:07:18 -0500
Date: Wed, 23 Feb 2011 12:06:53 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Simplify task_clock_event_read()
Message-ID: <tip-768a06e2ca49cdf72389208cfc056a36cf8bc5e3@git.kernel.org>
Git-Commit-ID: 768a06e2ca49cdf72389208cfc056a36cf8bc5e3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 12:06:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  768a06e2ca49cdf72389208cfc056a36cf8bc5e3
Gitweb:     http://git.kernel.org/tip/768a06e2ca49cdf72389208cfc056a36cf8bc5e3
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 22 Feb 2011 16:52:24 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Feb 2011 11:35:47 +0100

perf: Simplify task_clock_event_read()

There is no point in us having different code paths for nmi and !nmi
here, so remove the !nmi one.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index dadeaea..64a018e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5810,16 +5810,9 @@ static void task_clock_event_del(struct perf_event *event, int flags)
 
 static void task_clock_event_read(struct perf_event *event)
 {
-	u64 time;
-
-	if (!in_nmi()) {
-		update_context_time(event->ctx);
-		time = event->ctx->time;
-	} else {
-		u64 now = perf_clock();
-		u64 delta = now - event->ctx->timestamp;
-		time = event->ctx->time + delta;
-	}
+	u64 now = perf_clock();
+	u64 delta = now - event->ctx->timestamp;
+	u64 time = event->ctx->time + delta;
 
 	task_clock_event_update(event, time);
 }
