Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab1AYR1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:27:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:46982 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1AYRWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:22:07 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 08/29] perf record: Use struct perf_mmap and helpers
Date: Tue, 25 Jan 2011 15:21:31 -0200
Message-Id: <1295976112-2796-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295976112-2796-1-git-send-email-acme@infradead.org>
References: <1295976112-2796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Paving the way to using perf_evsel->mmap, do this to reduce the patch
noise in the next ones.

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
 tools/perf/builtin-record.c |   25 ++++---------------------
 1 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ec43f2e..d89e2f1 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -78,26 +78,9 @@ static off_t			post_processing_offset;
 static struct perf_session	*session;
 static const char		*cpu_list;
 
-struct mmap_data {
-	void			*base;
-	unsigned int		mask;
-	unsigned int		prev;
-};
-
-static struct mmap_data		mmap_array[MAX_NR_CPUS];
-
-static unsigned long mmap_read_head(struct mmap_data *md)
-{
-	struct perf_event_mmap_page *pc = md->base;
-	long head;
-
-	head = pc->data_head;
-	rmb();
-
-	return head;
-}
+static struct perf_mmap		mmap_array[MAX_NR_CPUS];
 
-static void mmap_write_tail(struct mmap_data *md, unsigned long tail)
+static void mmap_write_tail(struct perf_mmap *md, unsigned long tail)
 {
 	struct perf_event_mmap_page *pc = md->base;
 
@@ -136,9 +119,9 @@ static int process_synthesized_event(event_t *event,
 	return 0;
 }
 
-static void mmap_read(struct mmap_data *md)
+static void mmap_read(struct perf_mmap *md)
 {
-	unsigned int head = mmap_read_head(md);
+	unsigned int head = perf_mmap__read_head(md);
 	unsigned int old = md->prev;
 	unsigned char *data = md->base + page_size;
 	unsigned long size;
-- 
1.6.2.5

