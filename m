Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab2ICIUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:20:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:51049 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584Ab2ICIUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:20:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,359,1344236400"; 
   d="scan'208";a="140902953"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH 1/7] perf symbols: Filter samples with unresolved symbol when "--symbols" option is used
Date: Mon,  3 Sep 2012 16:14:27 +0800
Message-Id: <1346660073-20279-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346660073-20279-1-git-send-email-feng.tang@intel.com>
References: <1346660073-20279-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/util/event.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 3a0f1a5..08910f0 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -886,8 +886,9 @@ int perf_event__preprocess_sample(const union perf_event *event,
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

