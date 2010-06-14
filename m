Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab0FNIcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 04:32:11 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:50595 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab0FNIcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 04:32:07 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 14 Jun 2010 14:00:22 +0530
Message-Id: <20100614083022.29068.46544.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v5 12/14] perf: Dont adjust symbols on name lookup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_adjust_symbol_name.patch

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Adjusting symbols is not needed if we are searching by name even
if the symbols correspond to user space objects.
Infact if we adjust and search symbols by name, we get incorrect
results.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 tools/perf/util/symbol.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b63e571..2d53dfc 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -992,12 +992,14 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	memset(&sym, 0, sizeof(sym));
-	if (self->kernel == DSO_TYPE_USER) {
+	if (self->kernel != DSO_TYPE_USER || symbol_conf.sort_by_name)
+		self->adjust_symbols = 0;
+	else {
 		self->adjust_symbols = (ehdr.e_type == ET_EXEC ||
 				elf_section_by_name(elf, &ehdr, &shdr,
 						     ".gnu.prelink_undo",
 						     NULL) != NULL);
-	} else self->adjust_symbols = 0;
+	}
 
 	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
 		struct symbol *f;
