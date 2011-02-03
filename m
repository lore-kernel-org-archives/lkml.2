Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab1BCOLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:11:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:51340 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169Ab1BCOLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:11:15 -0500
Date: Thu, 3 Feb 2011 14:10:48 GMT
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
Subject: [tip:perf/urgent] perf: Fix reading in perf_event_read()
Message-ID: <tip-542e72fc90f5ed9eecb574f80f70868c7f296093@git.kernel.org>
Git-Commit-ID: 542e72fc90f5ed9eecb574f80f70868c7f296093
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 03 Feb 2011 14:10:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  542e72fc90f5ed9eecb574f80f70868c7f296093
Gitweb:     http://git.kernel.org/tip/542e72fc90f5ed9eecb574f80f70868c7f296093
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 26 Jan 2011 15:38:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Feb 2011 12:15:46 +0100

perf: Fix reading in perf_event_read()

It is quite possible for the event to have been disabled between
perf_event_read() sending the IPI and the CPU servicing the IPI and
calling __perf_event_read(), hence revalidate the state.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 852ae8c..999835b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1901,11 +1901,12 @@ static void __perf_event_read(void *info)
 		return;
 
 	raw_spin_lock(&ctx->lock);
-	update_context_time(ctx);
+	if (ctx->is_active)
+		update_context_time(ctx);
 	update_event_times(event);
+	if (event->state == PERF_EVENT_STATE_ACTIVE)
+		event->pmu->read(event);
 	raw_spin_unlock(&ctx->lock);
-
-	event->pmu->read(event);
 }
 
 static inline u64 perf_event_count(struct perf_event *event)
