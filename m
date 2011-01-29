Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab1A2WT3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 17:19:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:52191 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab1A2WT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 17:19:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/7] perf record: No need to check for overwrites
Date: Sat, 29 Jan 2011 20:19:13 -0200
Message-Id: <1296339559-20914-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1296339559-20914-1-git-send-email-acme@infradead.org>
References: <1296339559-20914-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

As we open the mmap with (PROT_READ | PROT_WRITE), signalling the kernel
with perf_mmap__write_tail() when consuming data, so the kernel will not
overwrite.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
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
 tools/perf/builtin-record.c |   24 ++++--------------------
 1 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d788630..caf9279 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -115,27 +115,11 @@ static void mmap_read(struct perf_mmap *md)
 	unsigned char *data = md->base + page_size;
 	unsigned long size;
 	void *buf;
-	int diff;
 
-	/*
-	 * If we're further behind than half the buffer, there's a chance
-	 * the writer will bite our tail and mess up the samples under us.
-	 *
-	 * If we somehow ended up ahead of the head, we got messed up.
-	 *
-	 * In either case, truncate and restart at head.
-	 */
-	diff = head - old;
-	if (diff < 0) {
-		fprintf(stderr, "WARNING: failed to keep up with mmap data\n");
-		/*
-		 * head points to a known good entry, start there.
-		 */
-		old = head;
-	}
+	if (old == head)
+		return;
 
-	if (old != head)
-		samples++;
+	samples++;
 
 	size = head - old;
 
-- 
1.6.2.5

