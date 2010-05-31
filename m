Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab0EaXC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 19:02:59 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:39034 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab0EaXCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 19:02:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=V8mVLtOdYhsy0RWhf23Y2O8kpevy1icY1UmUk/m310pP/ew2mPk18fexh0jvgp55J2
         4hk08tW7IBw8192i2bHUVF9stmK+ZSUjEglTxsP54zChHyEBNuE5fV3EHShtqT2R4rs7
         oHyda/VLpWP1L9F0cw+H6MRFVhbweTI0eKVRw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/4] perf: Use event__process_task from perf sched
Date: Tue,  1 Jun 2010 01:02:18 +0200
Message-Id: <1275346940-18498-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1275346940-18498-1-git-send-regression-fweisbec@gmail.com>
References: <1275346940-18498-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf sched uses event__process_comm(), which means it can resolve
comms from:

- tasks that have exec'ed (kernel comm events)
- tasks that were running when perf record started the actual
  recording (synthetized comm events)

But perf sched can't resolve the pids of tasks that were created
after the recording started.

To solve this, we need to inherit the comms on fork events using
event__process_task().

This fixes various unresolved pids in perf sched, easily visible
with:
	perf sched record perf bench sched messaging

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index f67bce2..55f3b5d 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1645,6 +1645,7 @@ static struct perf_event_ops event_ops = {
 	.sample			= process_sample_event,
 	.comm			= event__process_comm,
 	.lost			= event__process_lost,
+	.fork			= event__process_task,
 	.ordered_samples	= true,
 };
 
-- 
1.6.2.3

