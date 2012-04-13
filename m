Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab2DMSDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:03:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51359 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab2DMSDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:03:23 -0400
Date: Fri, 13 Apr 2012 11:02:40 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-hcae5oxa22syjrnalsxz7s6n@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        mgalbraith@suse.de, acme@redhat.com, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, mgalbraith@suse.de,
        paulus@samba.org, eranian@google.com, linux-kernel@vger.kernel.org,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Fix hist decay
Git-Commit-ID: 8b84a568117fde9b77575f2060274eddab424c32
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:02:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b84a568117fde9b77575f2060274eddab424c32
Gitweb:     http://git.kernel.org/tip/8b84a568117fde9b77575f2060274eddab424c32
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 5 Apr 2012 16:15:59 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Apr 2012 18:49:18 -0300

perf annotate: Fix hist decay

We were only decaying the entries for the offsets that were associated
with an objdump line.

That way, when we accrued the whole instruction addr range, more than
100% was appearing in some cases in the live annotation TUI.

Fix it by not traversing the source code line at all, just iterate thru
the complete addr range decaying each one.

Reported-by: Mike Galbraith <mgalbraith@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-hcae5oxa22syjrnalsxz7s6n@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 199f69e..70f5a4d 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -561,16 +561,12 @@ void symbol__annotate_decay_histogram(struct symbol *sym, int evidx)
 {
 	struct annotation *notes = symbol__annotation(sym);
 	struct sym_hist *h = annotation__histogram(notes, evidx);
-	struct objdump_line *pos;
-	int len = sym->end - sym->start;
+	int len = sym->end - sym->start, offset;
 
 	h->sum = 0;
-
-	list_for_each_entry(pos, &notes->src->source, node) {
-		if (pos->offset != -1 && pos->offset < len) {
-			h->addr[pos->offset] = h->addr[pos->offset] * 7 / 8;
-			h->sum += h->addr[pos->offset];
-		}
+	for (offset = 0; offset < len; ++offset) {
+		h->addr[offset] = h->addr[offset] * 7 / 8;
+		h->sum += h->addr[offset];
 	}
 }
 
