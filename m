Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab0K3UMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:12:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:33371 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab0K3ULJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:11:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/11] perf session: Simplify termination checks
Date: Tue, 30 Nov 2010 18:10:51 -0200
Message-Id: <1291147856-17459-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291147856-17459-1-git-send-email-acme@infradead.org>
References: <1291147856-17459-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

No need to check twice.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20101130163820.152886642@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3c140da..9c806ab 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -738,7 +738,7 @@ int __perf_session__process_events(struct perf_session *session,
 				   u64 data_offset, u64 data_size,
 				   u64 file_size, struct perf_event_ops *ops)
 {
-	u64 head, page_offset, file_offset;
+	u64 head, page_offset, file_offset, file_pos;
 	int err, mmap_prot, mmap_flags;
 	struct ui_progress *progress;
 	size_t	page_size;
@@ -758,6 +758,9 @@ int __perf_session__process_events(struct perf_session *session,
 	file_offset = page_offset;
 	head = data_offset - page_offset;
 
+	if (data_offset + data_size < file_size)
+		file_size = data_offset + data_size;
+
 	mmap_prot  = PROT_READ;
 	mmap_flags = MAP_SHARED;
 
@@ -773,6 +776,7 @@ remap:
 		err = -errno;
 		goto out_err;
 	}
+	file_pos = file_offset + head;
 	ui_progress__update(progress, file_offset);
 
 more:
@@ -799,10 +803,10 @@ more:
 	size = event->header.size;
 
 	dump_printf("\n%#Lx [%#x]: event: %d\n",
-		    file_offset + head, event->header.size, event->header.type);
+		    file_pos, event->header.size, event->header.type);
 
-	if (size == 0 || perf_session__process_event(session, event, ops,
-						     file_offset + head) < 0) {
+	if (size == 0 ||
+	    perf_session__process_event(session, event, ops, file_pos) < 0) {
 		dump_printf("%#Lx [%#x]: skipping unknown header type: %d\n",
 			    file_offset + head, event->header.size,
 			    event->header.type);
@@ -817,13 +821,11 @@ more:
 	}
 
 	head += size;
+	file_pos += size;
 
-	if (file_offset + head >= data_offset + data_size)
-		goto done;
-
-	if (file_offset + head < file_size)
+	if (file_pos < file_size)
 		goto more;
-done:
+
 	err = 0;
 	/* do the final flush for ordered samples */
 	session->ordered_samples.next_flush = ULLONG_MAX;
-- 
1.6.2.5

