Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1KCRL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:11:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:41559 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab1KCRLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:11:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf top: Fix live annotation in the --stdio interface
Date: Thu,  3 Nov 2011 15:11:46 -0200
Message-Id: <1320340306-24062-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1320340306-24062-1-git-send-email-acme@infradead.org>
References: <1320340306-24062-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In the old --stdio interface the annotation is done just after one
selects a symbol, while in --tui, now the default when the required libs
are installed, we annotate all symbols with samples so that when
annotation is asked we see what happened recently on that symbol.

To achieve that the --stdio variant checks if the hist_entry being
processed is the one selected by the user via the 's' hotkey. What
happens now that we share the hist_entry abstractions with 'perf report'
is that for minimizing locking contention multiple rb_trees are used,
one for collecting the samples and other to browse/show them after
resorting it by number of samples and decay them, which is done
periodically.

So the simple test in record_precise_ip doesn't work as we move
hist_entries between those rb_trees. To fix it just check that the
underlying struct symbol associated with those hist_entries is the same.

Reported-by: Mike Galbraith <efault@gmx.de>
Tested-by: Mike Galbraith <efault@gmx.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-bcfnraqkux88fox9ba9767ds@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a13f887..c9cdedb 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -200,7 +200,8 @@ static void record_precise_ip(struct hist_entry *he, int counter, u64 ip)
 	struct symbol *sym;
 
 	if (he == NULL || he->ms.sym == NULL ||
-	    (he != top.sym_filter_entry && use_browser != 1))
+	    ((top.sym_filter_entry == NULL ||
+	      top.sym_filter_entry->ms.sym != he->ms.sym) && use_browser != 1))
 		return;
 
 	sym = he->ms.sym;
-- 
1.6.2.5

