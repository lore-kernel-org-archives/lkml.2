Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0LAJM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:12:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:54163 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab0LAJMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:12:22 -0500
Date: Wed, 1 Dec 2010 09:11:54 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101130163820.152886642@linutronix.de>
References: <20101130163820.152886642@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Simplify termination checks
Message-ID: <tip-d6513281c5f728d138ba895d600b9788e51508b1@git.kernel.org>
Git-Commit-ID: d6513281c5f728d138ba895d600b9788e51508b1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Dec 2010 09:11:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6513281c5f728d138ba895d600b9788e51508b1
Gitweb:     http://git.kernel.org/tip/d6513281c5f728d138ba895d600b9788e51508b1
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 30 Nov 2010 17:49:44 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 30 Nov 2010 19:58:10 -0200

perf session: Simplify termination checks

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
