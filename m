Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab1IWU0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:26:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:39413 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab1IWU0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:26:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Eric B Munson <emunson@mgebm.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ian Munsie <imunsie@au1.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/12] perf sort: Fix symbol sort output by separating unresolved samples by type
Date: Fri, 23 Sep 2011 17:26:22 -0300
Message-Id: <1316809586-28529-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1316809586-28529-1-git-send-email-acme@infradead.org>
References: <1316809586-28529-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

I took a profile that suggested 60% of total CPU time was in the
hypervisor:

...
    60.20%  [H] 0x33d43c
     4.43%  [k] ._spin_lock_irqsave
     1.07%  [k] ._spin_lock

Using perf stat to get the user/kernel/hypervisor breakdown contradicted
this.

The problem is we merge all unresolved samples into the one unknown
bucket. If add a comparison by sample type to sort__sym_cmp we get the
real picture:

...
    57.11%  [.] 0x80fbf63c
     4.43%  [k] ._spin_lock_irqsave
     1.07%  [k] ._spin_lock
     0.65%  [H] 0x33d43c

So it was almost all userspace, not hypervisor as the initial profile
suggested.

I found another issue while adding this. Symbol sorting sometimes shows
multiple entries for the unknown bucket:

...
    16.65%  [.] 0x6cd3a8
     7.25%  [.] 0x422460
     5.37%  [.] yylex
     4.79%  [.] malloc
     4.78%  [.] _int_malloc
     4.03%  [.] _int_free
     3.95%  [.] hash_source_code_string
     2.82%  [.] 0x532908
     2.64%  [.] 0x36b538
     0.94%  [H] 0x8000000000e132a4
     0.82%  [H] 0x800000000000e8b0

This happens because we aren't consistent with our sorting. On
one hand we check to see if both symbols match and for two unresolved
samples sym is NULL so we match:

        if (left->ms.sym == right->ms.sym)
                return 0;

On the other hand we use sample IP for unresolved samples when
comparing against a symbol:

       ip_l = left->ms.sym ? left->ms.sym->start : left->ip;
       ip_r = right->ms.sym ? right->ms.sym->start : right->ip;

This means unresolved samples end up spread across the rbtree and we
can't merge them all.

If we use cmp_null all unresolved samples will end up in the one bucket
and the output makes more sense:

...
    39.12%  [.] 0x36b538
     5.37%  [.] yylex
     4.79%  [.] malloc
     4.78%  [.] _int_malloc
     4.03%  [.] _int_free
     3.95%  [.] hash_source_code_string
     2.26%  [H] 0x800000000000e8b0

Acked-by: Eric B Munson <emunson@mgebm.net>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Link: http://lkml.kernel.org/r/20110831115145.4f598ab2@kryten
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 401e220..1ee8f1e 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -151,11 +151,17 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	u64 ip_l, ip_r;
 
+	if (!left->ms.sym && !right->ms.sym)
+		return right->level - left->level;
+
+	if (!left->ms.sym || !right->ms.sym)
+		return cmp_null(left->ms.sym, right->ms.sym);
+
 	if (left->ms.sym == right->ms.sym)
 		return 0;
 
-	ip_l = left->ms.sym ? left->ms.sym->start : left->ip;
-	ip_r = right->ms.sym ? right->ms.sym->start : right->ip;
+	ip_l = left->ms.sym->start;
+	ip_r = right->ms.sym->start;
 
 	return (int64_t)(ip_r - ip_l);
 }
-- 
1.6.2.5

