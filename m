Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab2EPHAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:00:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759444Ab2EPG7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:59:35 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, dsahern@gmail.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 7/7] perf, tool: Fix callchain ip printf
Date: Wed, 16 May 2012 08:59:08 +0200
Message-Id: <1337151548-2396-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1337151548-2396-1-git-send-email-jolsa@redhat.com>
References: <1337151548-2396-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callchain address is stored as u64. Current code uses following
format string to display callchain address:
  "%p\n", (void *)(long)chain->ip

This way we loose upper 32 bits if we report 64 bit addresses in
32 bit environment. Fixing this to always display whole 64 bits.

Note, running following to test perf endianity handling:
test 1)
  - origin system:
    # perf record -a -- sleep 10 (any perf record will do)
    # perf report > report.origin
    # perf archive perf.data

  - copy the perf.data, report.origin and perf.data.tar.bz2
    to a target system and run:
    # tar xjvf perf.data.tar.bz2 -C ~/.debug
    # perf report > report.target
    # diff -u report.origin report.target

  - the diff should produce no output
    (besides some white space stuff and possibly different
     date/TZ output)

test 2)
  - origin system:
    # perf record -ag -fo /tmp/perf.data -- sleep 1
  - mount origin system root to the target system on /mnt/origin
  - target system:
    # perf script --symfs /mnt/origin -I -i /mnt/origin/tmp/perf.data \
     --kallsyms /mnt/origin/proc/kallsyms
  - complete perf.data header is displayed

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/hist.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9f6d630..1293b5e 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -599,7 +599,7 @@ static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
 	if (chain->ms.sym)
 		ret += fprintf(fp, "%s\n", chain->ms.sym->name);
 	else
-		ret += fprintf(fp, "%p\n", (void *)(long)chain->ip);
+		ret += fprintf(fp, "0x%0" PRIx64 "\n", chain->ip);
 
 	return ret;
 }
-- 
1.7.7.6

