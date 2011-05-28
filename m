Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab1E1Qm1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:42:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:55336 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab1E1QmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:42:25 -0400
Date: Sat, 28 May 2011 16:42:15 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-64ce312618ef0e11d88def80effcefd1b59fdb1e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110409192142.090431763@chello.nl>
References: <20110409192142.090431763@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: De-schedule a task context when removing the last event
Git-Commit-ID: 64ce312618ef0e11d88def80effcefd1b59fdb1e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 16:42:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  64ce312618ef0e11d88def80effcefd1b59fdb1e
Gitweb:     http://git.kernel.org/tip/64ce312618ef0e11d88def80effcefd1b59fdb1e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 9 Apr 2011 21:17:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 May 2011 18:01:23 +0200

perf: De-schedule a task context when removing the last event

Since perf_install_in_context() will now install a context when we
add the first event, we can de-schedule the context when the last
event is removed.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110409192142.090431763@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c378062..cc5d57d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1120,6 +1120,10 @@ static int __perf_remove_from_context(void *info)
 	raw_spin_lock(&ctx->lock);
 	event_sched_out(event, cpuctx, ctx);
 	list_del_event(event, ctx);
+	if (!ctx->nr_events && cpuctx->task_ctx == ctx) {
+		ctx->is_active = 0;
+		cpuctx->task_ctx = NULL;
+	}
 	raw_spin_unlock(&ctx->lock);
 
 	return 0;
