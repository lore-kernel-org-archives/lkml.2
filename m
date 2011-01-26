Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1AZHRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:17:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:55791 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab1AZHRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:17:04 -0500
Date: Wed, 26 Jan 2011 07:16:40 GMT
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
Subject: [tip:perf/core] perf record: Use struct perf_mmap and helpers
Message-ID: <tip-744bd8aa3c8b43447f689a27872fa95e700b8a4f@git.kernel.org>
Git-Commit-ID: 744bd8aa3c8b43447f689a27872fa95e700b8a4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:16:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  744bd8aa3c8b43447f689a27872fa95e700b8a4f
Gitweb:     http://git.kernel.org/tip/744bd8aa3c8b43447f689a27872fa95e700b8a4f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 12 Jan 2011 17:07:28 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 22 Jan 2011 19:56:29 -0200

perf record: Use struct perf_mmap and helpers

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
