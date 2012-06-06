Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab2FFG4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 02:56:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35700 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2FFG4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 02:56:22 -0400
Date: Tue, 5 Jun 2012 23:55:43 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-8ylwubbcmu27ucc9ffrku3yv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com, wcohen@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, wcohen@redhat.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf report: Use the right symbol for annotation
Git-Commit-ID: 91557e847dbc715acf2d847a1ffec63f71b00b65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 05 Jun 2012 23:55:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91557e847dbc715acf2d847a1ffec63f71b00b65
Gitweb:     http://git.kernel.org/tip/91557e847dbc715acf2d847a1ffec63f71b00b65
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 30 May 2012 12:25:52 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 May 2012 12:25:52 -0300

perf report: Use the right symbol for annotation

In non symbolic views, i.e. --sort without "symbol", as in:

 perf report --sort comm

We're segfaulting in the --tui because we're testing the symbol resolved
and then trying to use the symbol on the histogram entry where we're
coalescing all hits for a COMM, and the first hist_entry for a comm may
have a NULL symbol, i.e. the RIP didn't resolve to any symbol.

In this case we're segfaulting, fix it by testing against the symbol in
the histogram entry.

Reported-by: William Cohen <wcohen@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8ylwubbcmu27ucc9ffrku3yv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8c767c6..2400e00 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -162,7 +162,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	 * so we don't allocated the extra space needed because the stdio
 	 * code will not use it.
 	 */
-	if (al->sym != NULL && use_browser > 0) {
+	if (he->ms.sym != NULL && use_browser > 0) {
 		struct annotation *notes = symbol__annotation(he->ms.sym);
 
 		assert(evsel != NULL);
