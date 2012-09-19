Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab2ISPV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:21:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52802 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab2ISPVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:21:53 -0400
Date: Wed, 19 Sep 2012 08:21:21 -0700
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-1500b93b61fc70a1176871b64f1c8ae3bd4da9dd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, andi@firstfloor.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, dsahern@gmail.com, tglx@linutronix.de,
        feng.tang@intel.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, andi@firstfloor.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, dsahern@gmail.com, tglx@linutronix.de,
        feng.tang@intel.com, mingo@elte.hu
In-Reply-To: <1347007349-3102-2-git-send-email-feng.tang@intel.com>
References: <1347007349-3102-2-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Filter samples with unresolved symbol when "--symbols" option is used
Git-Commit-ID: 1500b93b61fc70a1176871b64f1c8ae3bd4da9dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 08:21:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1500b93b61fc70a1176871b64f1c8ae3bd4da9dd
Gitweb:     http://git.kernel.org/tip/1500b93b61fc70a1176871b64f1c8ae3bd4da9dd
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Fri, 7 Sep 2012 16:42:23 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 17 Sep 2012 13:10:57 -0300

perf symbols: Filter samples with unresolved symbol when "--symbols" option is used

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
