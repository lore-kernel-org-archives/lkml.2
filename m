Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab0EaXCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 19:02:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33476 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab0EaXC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 19:02:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=qWZf9TK5JHy7Vu5P/1jpzyHlaG3lnLzx6Dd766vf7HmL8a6Twg48SvqABVkrlsZ+kA
         YHASlFrtpwuNfrV6R1SNPYLTlHVvKgLA+F7okYgvKxFsNz56rLQTfjbjMHpMTmxnFnVB
         Jgrmg09MMZykathZch7QN67nMmYZFpFmxD2qQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/4] perf: Process comm events by tid
Date: Tue,  1 Jun 2010 01:02:17 +0200
Message-Id: <1275346940-18498-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1275346940-18498-1-git-send-regression-fweisbec@gmail.com>
References: <1275346940-18498-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we synthetize the existing running tasks though procfs,
we walk through every threads of a process, queuing one comm
events per tid.

But then on report time, event__process_comm() only creates and
sets the comm on a per process granularity. This is the right
thing for comm events that came from the kernel, as they are
only created on exec. Sub-threads then inherit their comm
from fork events. But that doesn't work with our synthetized
comm events taken from procfs informations as the per thread
granularity is done on comm events directly there.

Hence we need event__process_comm() to work with the tid rather
than the pid. It won't change anything for comm events coming
from the kernel but this will fix the synthetized ones.

Before:

	$ ./perf report -D | grep COMM | grep firefox

	0x2c7b8 [0x18]: PERF_RECORD_COMM: firefox:5297
	0x2c7d0 [0x18]: PERF_RECORD_COMM: firefox:5297
	0x2c7e8 [0x18]: PERF_RECORD_COMM: firefox:5297
	0x2c800 [0x18]: PERF_RECORD_COMM: firefox:5297
	0x2c818 [0x18]: PERF_RECORD_COMM: firefox:5297
	0x2c830 [0x18]: PERF_RECORD_COMM: firefox:5297

After:
	$ ./perf report -D | grep COMM | grep firefox

	0x2c7b8 [0x18]: PERF_RECORD_COMM: firefox:5297
	0x2c7d0 [0x18]: PERF_RECORD_COMM: firefox:5299
	0x2c7e8 [0x18]: PERF_RECORD_COMM: firefox:5300
	0x2c800 [0x18]: PERF_RECORD_COMM: firefox:5308
	0x2c818 [0x18]: PERF_RECORD_COMM: firefox:5309
	0x2c830 [0x18]: PERF_RECORD_COMM: firefox:5312

This fixes various unresolved pid on perf sched.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/event.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 50771b5..d28d809 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -370,9 +370,9 @@ static int thread__set_comm_adjust(struct thread *self, const char *comm)
 
 int event__process_comm(event_t *self, struct perf_session *session)
 {
-	struct thread *thread = perf_session__findnew(session, self->comm.pid);
+	struct thread *thread = perf_session__findnew(session, self->comm.tid);
 
-	dump_printf(": %s:%d\n", self->comm.comm, self->comm.pid);
+	dump_printf(": %s:%d\n", self->comm.comm, self->comm.tid);
 
 	if (thread == NULL || thread__set_comm_adjust(thread, self->comm.comm)) {
 		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
-- 
1.6.2.3

