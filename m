Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2GYTfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:35:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58565 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2GYTfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:35:16 -0400
Date: Wed, 25 Jul 2012 12:33:37 -0700
From: tip-bot for Cody Schafer <cody@linux.vnet.ibm.com>
Message-ID: <tip-8696329b7bcf32e69ad12d5975ad1497936d43ec@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, cody@linux.vnet.ibm.com,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, tglx@linutronix.de,
        sukadev@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, cody@linux.vnet.ibm.com,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, tglx@linutronix.de,
        sukadev@linux.vnet.ibm.com
In-Reply-To: <1342753525-4521-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1342753525-4521-1-git-send-email-cody@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Prevent overflow in size calculation
Git-Commit-ID: 8696329b7bcf32e69ad12d5975ad1497936d43ec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Jul 2012 12:33:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8696329b7bcf32e69ad12d5975ad1497936d43ec
Gitweb:     http://git.kernel.org/tip/8696329b7bcf32e69ad12d5975ad1497936d43ec
Author:     Cody Schafer <cody@linux.vnet.ibm.com>
AuthorDate: Thu, 19 Jul 2012 20:05:25 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Jul 2012 13:06:42 -0300

perf annotate: Prevent overflow in size calculation

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
