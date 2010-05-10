Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab0EJAUK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 20:20:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59304 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab0EJAUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 20:20:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH v2 2/4] perf symbols: Check if a struct machine instance was found
Date: Sun,  9 May 2010 21:19:57 -0300
Message-Id: <1273450799-12808-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273450799-12808-1-git-send-email-acme@infradead.org>
References: <1273450799-12808-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Which can happen when processing old files that had no fake kernel MMAP,
events.

That shouldn't result in perf_session__create_kernel_maps not being
called, this will be fixed in a followup patch, for now do these checks
to avoid segfaulting.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 46563e1..dfc8bf6 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -493,8 +493,10 @@ int event__process_mmap(event_t *self, struct perf_session *session)
 		return 0;
 	}
 
-	thread = perf_session__findnew(session, self->mmap.pid);
 	machine = perf_session__find_host_machine(session);
+	if (machine == NULL)
+		goto out_problem;
+	thread = perf_session__findnew(session, self->mmap.pid);
 	map = map__new(&machine->user_dsos, self->mmap.start,
 			self->mmap.len, self->mmap.pgoff,
 			self->mmap.pid, self->mmap.filename,
@@ -552,6 +554,10 @@ void thread__find_addr_map(struct thread *self,
 	if (cpumode == PERF_RECORD_MISC_KERNEL && perf_host) {
 		al->level = 'k';
 		machine = perf_session__find_host_machine(session);
+		if (machine == NULL) {
+			al->map = NULL;
+			return;
+		}
 		mg = &machine->kmaps;
 	} else if (cpumode == PERF_RECORD_MISC_USER && perf_host) {
 		al->level = '.';
@@ -559,7 +565,7 @@ void thread__find_addr_map(struct thread *self,
 	} else if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL && perf_guest) {
 		al->level = 'g';
 		machine = perf_session__find_machine(session, pid);
-		if (!machine) {
+		if (machine == NULL) {
 			al->map = NULL;
 			return;
 		}
-- 
1.6.2.5

