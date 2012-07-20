Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab2GTDG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 23:06:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40289 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2GTDGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 23:06:54 -0400
From: Cody Schafer <cody@linux.vnet.ibm.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v3] perf: prevent overflow in size calculation
Date: Thu, 19 Jul 2012 20:05:25 -0700
Message-Id: <1342753525-4521-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <5008C90A.50705@linux.vnet.ibm.com>
References: <5008C90A.50705@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072003-9360-0000-0000-000008942E8F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A large enough symbol size causes an overflow in the size parameter to the
histogram allocation, leading to a segfault in symbol__inc_addr_samples later
on when this histogram is accessed.

In the case of being called via perf-report, this returns back and
gracefully ignores the sample, eventually ignoring the chained return
value of perf_session_deliver_event in flush_sample_queue.

Signed-off-by: Cody Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/util/annotate.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 8069dfb..d88693e 100644
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
1.7.9.5

