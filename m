Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab0EaXCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 19:02:46 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51265 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab0EaXCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 19:02:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=tDZwKr0bDn9KNvjdGXbvotFuBcsH4NiNRNEAWYfAZHCzhg7TljarKGdvJdWf+/xQVm
         678Z7zajkBKib1XpY5aeOxwTKp85DvdJ++vlYuLQw19UBd4QqKEmD/oVK1YfQnmnNCBG
         0vLfdGKoFjFZQpo6kSA9b9khXLdVrg00UdS+E=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/4] perf: Do the comm inheritance per thread in event__process_task
Date: Tue,  1 Jun 2010 01:02:19 +0200
Message-Id: <1275346940-18498-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1275346940-18498-1-git-send-regression-fweisbec@gmail.com>
References: <1275346940-18498-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

event__process_task() doesn't propagate the comm copy on clone,
but only on process fork. So we loose all the tid:comm resolution
for tasks that aren't a main process thread.

Progragate the per thread granularity to event__process_task for
pid resolution.

This fixes various unresolved pids in perf sched, especially when
we trace multithread processes. The problem is quickly reproducible
with the messaging benchmark using the multithread mode "-t" :

	perf sched record perf bench sched messaging -t

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/event.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index d28d809..1f08f00 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -532,16 +532,11 @@ out_problem:
 
 int event__process_task(event_t *self, struct perf_session *session)
 {
-	struct thread *thread = perf_session__findnew(session, self->fork.pid);
-	struct thread *parent = perf_session__findnew(session, self->fork.ppid);
+	struct thread *thread = perf_session__findnew(session, self->fork.tid);
+	struct thread *parent = perf_session__findnew(session, self->fork.ptid);
 
 	dump_printf("(%d:%d):(%d:%d)\n", self->fork.pid, self->fork.tid,
 		    self->fork.ppid, self->fork.ptid);
-	/*
-	 * A thread clone will have the same PID for both parent and child.
-	 */
-	if (thread == parent)
-		return 0;
 
 	if (self->header.type == PERF_RECORD_EXIT)
 		return 0;
-- 
1.6.2.3

