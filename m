Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab1HaBvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 21:51:51 -0400
Received: from ozlabs.org ([203.10.76.45]:35123 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab1HaBvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 21:51:49 -0400
Date: Wed, 31 Aug 2011 11:51:45 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, emunson@mgebm.net,
        imunsie@au1.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] perf sort: Improve symbol sort output by separating
 unresolved samples by type
Message-ID: <20110831115145.4f598ab2@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I took a profile that suggested 60% of total CPU time was in the
hypervisor:

# perf report --sort symbol
...
    60.20%  [H] 0x33d43c        
     4.43%  [k] ._spin_lock_irqsave
     1.07%  [k] ._spin_lock

Using perf stat to get the user/kernel/hypervisor breakdown contradicted
this.

The problem is we merge all unresolved samples into the one unknown
bucket. If add a comparison by sample type to sort__sym_cmp we get the
real picture:

# perf report --sort symbol
...
    57.11%  [.] 0x80fbf63c
     4.43%  [k] ._spin_lock_irqsave 
     1.07%  [k] ._spin_lock
     0.65%  [H] 0x33d43c

So it was almost all userspace, not hypervisor as the initial profile
suggested.

I found another issue while adding this. Symbol sorting sometimes shows
multiple entries for the unknown bucket:

# perf report --sort symbol
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

# perf report --sort symbol
...
    39.12%  [.] 0x36b538        
     5.37%  [.] yylex
     4.79%  [.] malloc
     4.78%  [.] _int_malloc
     4.03%  [.] _int_free
     3.95%  [.] hash_source_code_string
     2.26%  [H] 0x800000000000e8b0

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-tip/tools/perf/util/sort.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/sort.c	2011-08-31 10:26:17.296618713 +1000
+++ linux-2.6-tip/tools/perf/util/sort.c	2011-08-31 10:32:12.703212452 +1000
@@ -157,11 +157,17 @@ sort__sym_cmp(struct hist_entry *left, s
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
