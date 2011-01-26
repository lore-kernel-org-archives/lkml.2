Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1AZHRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:17:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:55819 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1AZHRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:17:39 -0500
Date: Wed, 26 Jan 2011 07:17:06 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Move perf_mmap__write_tail to perf.h
Message-ID: <tip-115d2d8963a426670ac3ce983fc4c4e001703943@git.kernel.org>
Git-Commit-ID: 115d2d8963a426670ac3ce983fc4c4e001703943
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:17:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  115d2d8963a426670ac3ce983fc4c4e001703943
Gitweb:     http://git.kernel.org/tip/115d2d8963a426670ac3ce983fc4c4e001703943
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 12 Jan 2011 17:11:53 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 22 Jan 2011 19:56:29 -0200

perf record: Move perf_mmap__write_tail to perf.h

Close to perf_mmap__read_head() and the perf_mmap struct definition.
This is useful for any recorder, and we will need it in 'perf test'.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   13 +------------
 tools/perf/perf.h           |   12 ++++++++++++
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d89e2f1..109f3b2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -80,17 +80,6 @@ static const char		*cpu_list;
 
 static struct perf_mmap		mmap_array[MAX_NR_CPUS];
 
-static void mmap_write_tail(struct perf_mmap *md, unsigned long tail)
-{
-	struct perf_event_mmap_page *pc = md->base;
-
-	/*
-	 * ensure all reads are done before we write the tail out.
-	 */
-	/* mb(); */
-	pc->data_tail = tail;
-}
-
 static void advance_output(size_t size)
 {
 	bytes_written += size;
@@ -165,7 +154,7 @@ static void mmap_read(struct perf_mmap *md)
 	write_output(buf, size);
 
 	md->prev = old;
-	mmap_write_tail(md, old);
+	perf_mmap__write_tail(md, old);
 }
 
 static volatile int done = 0;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 5fb5e1f..a5fc660 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -108,6 +108,18 @@ static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
 	return head;
 }
 
+static inline void perf_mmap__write_tail(struct perf_mmap *md,
+					 unsigned long tail)
+{
+	struct perf_event_mmap_page *pc = md->base;
+
+	/*
+	 * ensure all reads are done before we write the tail out.
+	 */
+	/* mb(); */
+	pc->data_tail = tail;
+}
+
 /*
  * prctl(PR_TASK_PERF_EVENTS_DISABLE) will (cheaply) disable all
  * counters in the current task.
