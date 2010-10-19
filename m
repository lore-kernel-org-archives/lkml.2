Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab0JSKtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:49:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:52412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab0JSKtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:49:33 -0400
Date: Tue, 19 Oct 2010 10:48:55 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, aik@au1.ibm.com,
        benh@kernel.crashing.org, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, aik@au1.ibm.com,
        benh@kernel.crashing.org, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101019055535.GA10398@drongo>
References: <20101019055535.GA10398@drongo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, powerpc: Fix power_pmu_event_init to not use event->ctx
Message-ID: <tip-57fa7214330be2e292ddb1402834ff0b221ef29a@git.kernel.org>
Git-Commit-ID: 57fa7214330be2e292ddb1402834ff0b221ef29a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Oct 2010 10:48:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57fa7214330be2e292ddb1402834ff0b221ef29a
Gitweb:     http://git.kernel.org/tip/57fa7214330be2e292ddb1402834ff0b221ef29a
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Tue, 19 Oct 2010 16:55:35 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 19 Oct 2010 09:18:34 +0200

perf, powerpc: Fix power_pmu_event_init to not use event->ctx

Commit c3f00c70 ("perf: Separate find_get_context() from event
initialization") changed the generic perf_event code to call
perf_event_alloc, which calls the arch-specific event_init code,
before looking up the context for the new event.  Unfortunately,
power_pmu_event_init uses event->ctx->task to see whether the
new event is a per-task event or a system-wide event, and thus
crashes since event->ctx is NULL at the point where
power_pmu_event_init gets called.

(The reason it needs to know whether it is a per-task event is
because there are some hardware events on Power systems which
only count when the processor is not idle, and there are some
fixed-function counters which count such events.  For example,
the "run cycles" event counts cycles when the processor is not
idle.  If the user asks to count cycles, we can use "run cycles"
if this is a per-task event, since the processor is running when
the task is running, by definition.  We can't use "run cycles"
if the user asks for "cycles" on a system-wide counter.)

Fortunately the information we need is in the
event->attach_state field, so we just use that instead.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20101019055535.GA10398@drongo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Alexey Kardashevskiy <aik@au1.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 9cb4924..3129c85 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1092,7 +1092,7 @@ static int power_pmu_event_init(struct perf_event *event)
 	 * XXX we should check if the task is an idle task.
 	 */
 	flags = 0;
-	if (event->ctx->task)
+	if (event->attach_state & PERF_ATTACH_TASK)
 		flags |= PPMU_ONLY_COUNT_RUN;
 
 	/*
