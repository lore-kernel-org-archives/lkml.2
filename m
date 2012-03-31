Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2CaHrL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 03:47:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54849 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab2CaHrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 03:47:08 -0400
Date: Sat, 31 Mar 2012 00:46:41 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-pqjaq4cr1xs2xen73pjhbav4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, davem@davemloft.net, dumitru.sorin87@gmail.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, davem@davemloft.net, dumitru.sorin87@gmail.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf annotate:
  Fix off by one symbol hist size allocation and hit accounting
Git-Commit-ID: 64c17be4ffb8d6971051aec77ca1de4cfadb166d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 31 Mar 2012 00:46:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  64c17be4ffb8d6971051aec77ca1de4cfadb166d
Gitweb:     http://git.kernel.org/tip/64c17be4ffb8d6971051aec77ca1de4cfadb166d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 28 Mar 2012 12:49:35 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 29 Mar 2012 17:13:45 -0300

perf annotate: Fix off by one symbol hist size allocation and hit accounting

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
 1 files changed, 3 insertions(+), 3 deletions(-)

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
