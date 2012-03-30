Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559Ab2C3QKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 12:10:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42810 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761008Ab2C3QJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:09:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sorin Dumitru <dumitru.sorin87@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 8/9] perf annotate: Fix off by one symbol hist size allocation and hit accounting
Date: Fri, 30 Mar 2012 13:09:23 -0300
Message-Id: <1333123764-15662-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1333123764-15662-1-git-send-email-acme@infradead.org>
References: <1333123764-15662-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We were not noticing it because symbol__inc_addr_samples was erroneously
dropping samples that hit the last byte in a function.

Working on a fix for a problem reported by David Miller, Stephane
Eranian and Sorin Dumitru, where addresses < sym->start were causing
problems, I noticed this other problem.

Cc: David Ahern <dsahern@gmail.com>
Cc: David Miller <davem@davemloft.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sorin Dumitru <dumitru.sorin87@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-pqjaq4cr1xs2xen73pjhbav4@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 31ba2a2..199f69e 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -28,8 +28,8 @@ int symbol__annotate_init(struct map *map __used, struct symbol *sym)
 int symbol__alloc_hist(struct symbol *sym)
 {
 	struct annotation *notes = symbol__annotation(sym);
-	size_t sizeof_sym_hist = (sizeof(struct sym_hist) +
-				  (sym->end - sym->start) * sizeof(u64));
+	const size_t size = sym->end - sym->start + 1;
+	size_t sizeof_sym_hist = (sizeof(struct sym_hist) + size * sizeof(u64));
 
 	notes->src = zalloc(sizeof(*notes->src) + symbol_conf.nr_events * sizeof_sym_hist);
 	if (notes->src == NULL)
@@ -64,7 +64,7 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 
 	pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
 
-	if (addr >= sym->end)
+	if (addr > sym->end)
 		return 0;
 
 	offset = addr - sym->start;
-- 
1.7.9.2.358.g22243

