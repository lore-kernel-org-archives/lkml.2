Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab2IQRSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:18:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:46451 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab2IQRSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:18:36 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/18] perf symbols: Filter samples with unresolved symbol when "--symbols" option is used
Date: Mon, 17 Sep 2012 14:18:06 -0300
Message-Id: <1347902292-14536-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347902292-14536-1-git-send-email-acme@infradead.org>
References: <1347902292-14536-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Report/top commands support to only handle specific symbols with
"--symbols" option, but current code will keep those samples whose
symbol can't be resolved, which should actually be filtered.

If we run following commands:
$perf record -a tree
$perf report --symbols intel_idle -n
the output will be:

Without the patch:
==================
    46.27%        156     sshd  [unknown]
    26.05%         48  swapper  [kernel.kallsyms]
    17.26%         38     tree  libc-2.12.1.so
     7.69%         17     tree  tree
     2.73%          6     tree  ld-2.12.1.so

With the patch:
===============
   100.00%         48  swapper  [kernel.kallsyms]

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347007349-3102-2-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 8202f5c..6715b19 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -904,8 +904,9 @@ int perf_event__preprocess_sample(const union perf_event *event,
 		al->sym = map__find_symbol(al->map, al->addr, filter);
 	}
 
-	if (symbol_conf.sym_list && al->sym &&
-	    !strlist__has_entry(symbol_conf.sym_list, al->sym->name))
+	if (symbol_conf.sym_list &&
+		(!al->sym || !strlist__has_entry(symbol_conf.sym_list,
+						al->sym->name)))
 		goto out_filtered;
 
 	return 0;
-- 
1.7.1

