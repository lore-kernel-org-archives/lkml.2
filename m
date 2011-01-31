Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1AaMtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:49:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:33111 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab1AaMtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:49:22 -0500
Date: Mon, 31 Jan 2011 12:48:45 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: No need to check for overwrites
Message-ID: <tip-dc82009aac6ee6e423b48de43a251745c62ab012@git.kernel.org>
Git-Commit-ID: dc82009aac6ee6e423b48de43a251745c62ab012
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 12:48:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc82009aac6ee6e423b48de43a251745c62ab012
Gitweb:     http://git.kernel.org/tip/dc82009aac6ee6e423b48de43a251745c62ab012
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 28 Jan 2011 14:49:19 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 29 Jan 2011 16:23:58 -0200

perf record: No need to check for overwrites

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
 
