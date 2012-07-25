Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2GYRmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:42:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55672 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2GYRlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:41:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Cody Schafer <cody@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/19] perf annotate: Prevent overflow in size calculation
Date: Wed, 25 Jul 2012 14:41:34 -0300
Message-Id: <1343238094-12481-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1343238094-12481-1-git-send-email-acme@infradead.org>
References: <1343238094-12481-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody Schafer <cody@linux.vnet.ibm.com>

A large enough symbol size causes an overflow in the size parameter to
the histogram allocation, leading to a segfault in
symbol__inc_addr_samples later on when this histogram is accessed.

In the case of being called via perf-report, this returns back and
gracefully ignores the sample, eventually ignoring the chained return
value of perf_session_deliver_event in flush_sample_queue.

Signed-off-by: Cody Schafer <cody@linux.vnet.ibm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1342753525-4521-1-git-send-email-cody@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 7d3641f..3a282c0 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -426,7 +426,18 @@ int symbol__alloc_hist(struct symbol *sym)
 {
 	struct annotation *notes = symbol__annotation(sym);
 	const size_t size = symbol__size(sym);
-	size_t sizeof_sym_hist = (sizeof(struct sym_hist) + size * sizeof(u64));
+	size_t sizeof_sym_hist;
+
+	/* Check for overflow when calculating sizeof_sym_hist */
+	if (size > (SIZE_MAX - sizeof(struct sym_hist)) / sizeof(u64))
+		return -1;
+
+	sizeof_sym_hist = (sizeof(struct sym_hist) + size * sizeof(u64));
+
+	/* Check for overflow in zalloc argument */
+	if (sizeof_sym_hist > (SIZE_MAX - sizeof(*notes->src))
+				/ symbol_conf.nr_events)
+		return -1;
 
 	notes->src = zalloc(sizeof(*notes->src) + symbol_conf.nr_events * sizeof_sym_hist);
 	if (notes->src == NULL)
-- 
1.7.1

