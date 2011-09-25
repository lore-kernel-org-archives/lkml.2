Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab1IYI4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 04:56:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57690 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab1IYI4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 04:56:19 -0400
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: [PATCH 5/5] slub: Only IPI CPUs that have per cpu obj to flush
Date: Sun, 25 Sep 2011 11:54:50 +0300
Message-Id: <1316940890-24138-6-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to send IPI to flush per cpu objects back to free lists
to CPUs to seems to have such objects.

The check which CPU to IPI is racy but we don't care since
asking a CPU without per cpu objects to flush does no
damage and as far as I can tell the flush_all by itself is
racy against allocs on remote CPUs anyway, so if you meant
the flush_all to be determinstic, you had to arrange for
locking regardless.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: Chris Metcalf <cmetcalf@tilera.com>
CC: linux-mm@kvack.org
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Pekka Enberg <penberg@kernel.org>
CC: Matt Mackall <mpm@selenic.com>
---
 mm/slub.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9f662d7..8baae30 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1948,7 +1948,20 @@ static void flush_cpu_slab(void *d)
 
 static void flush_all(struct kmem_cache *s)
 {
-	on_each_cpu(flush_cpu_slab, s, 1);
+	cpumask_var_t cpus;
+	struct kmem_cache_cpu *c;
+	int cpu;
+
+	if (likely(zalloc_cpumask_var(&cpus, GFP_ATOMIC))) {
+		for_each_online_cpu(cpu) {
+			c = per_cpu_ptr(s->cpu_slab, cpu);
+			if (c && c->page)
+				cpumask_set_cpu(cpu, cpus);
+		}
+		on_each_cpu_mask(cpus, flush_cpu_slab, s, 1);
+		free_cpumask_var(cpus);
+	} else
+		on_each_cpu(flush_cpu_slab, s, 1);
 }
 
 /*
-- 
1.7.0.4

