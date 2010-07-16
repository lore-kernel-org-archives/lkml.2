Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935476Ab0GPC6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 22:58:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64274 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935288Ab0GPC6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 22:58:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=oaVCaJr9T0C8QsgZ1P6ClCwOjhLCXo07sssjTEJDRDjxmhBct5RzifeIvR4zXvC4tV
         Sc9z5jhO7EFJSZuOewhEy6W+1KU/xnIc2ZtNrUryeFDt60LEH8PocMDxdziItzTsbV/Q
         jw5OSPhzQ0l4u5hzTc31OPWavwmaekjC9E7Oc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perf fixlet
Date: Fri, 16 Jul 2010 04:58:41 +0200
Message-Id: <1279249121-11847-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

Thanks,
	Frederic
---

Frederic Weisbecker (1):
      perf: Fix various display bugs with parent filtering


 tools/perf/util/hist.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

---
commit 58c3439083f8fde61de842c93d1407f0f881cd92
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Fri Jul 16 04:02:14 2010 +0200

    perf: Fix various display bugs with parent filtering
    
    Hists that have been filtered, because they don't have callchains
    matching the parent filter, won't be printed. As such,
    hist_entry__snprintf() returns 0 for them, but we don't control
    this value and we always print the buffer, which might be
    untouched and then only made of random stack garbage.
    
    Not only does it paint the screen with barf, it also prints
    the callchains for these hists, even though they have been filtered,
    since the hist has been filtered as well.
    
    We need to check the return value of hist_entry__snprintf() and
    ignore the hist if it is 0, which means it didn't get any callchain
    matching the parent filter. This fixes the barf and the undesired
    callchains.
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
    Cc: Paul Mackerras <paulus@samba.org>

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 07f89b6..699cf81 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -631,9 +631,14 @@ int hist_entry__fprintf(struct hist_entry *self, struct hists *pair_hists,
 			u64 session_total)
 {
 	char bf[512];
-	hist_entry__snprintf(self, bf, sizeof(bf), pair_hists,
-			     show_displacement, displacement,
-			     true, session_total);
+	int ret;
+
+	ret = hist_entry__snprintf(self, bf, sizeof(bf), pair_hists,
+				   show_displacement, displacement,
+				   true, session_total);
+	if (!ret)
+		return 0;
+
 	return fprintf(fp, "%s\n", bf);
 }
 
@@ -762,6 +767,7 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 print_entries:
 	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+		int cnt;
 
 		if (show_displacement) {
 			if (h->pair != NULL)
@@ -771,8 +777,13 @@ print_entries:
 				displacement = 0;
 			++position;
 		}
-		ret += hist_entry__fprintf(h, pair, show_displacement,
-					   displacement, fp, self->stats.total_period);
+		cnt = hist_entry__fprintf(h, pair, show_displacement,
+					  displacement, fp, self->stats.total_period);
+		/* Ignore those that didn't match the parent filter */
+		if (!cnt)
+			continue;
+
+		ret += cnt;
 
 		if (symbol_conf.use_callchain)
 			ret += hist_entry__fprintf_callchain(h, fp, self->stats.total_period);
