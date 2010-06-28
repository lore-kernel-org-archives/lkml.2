Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab0F1GEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 02:04:51 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:51601 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab0F1GEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 02:04:48 -0400
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
Date: Mon, 28 Jun 2010 11:29:41 +0530
Message-Id: <20100628055941.6869.59092.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100628055740.6869.77397.sendpatchset@localhost6.localdomain6>
References: <20100628055740.6869.77397.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv6 2.6.35-rc3-tip 10/12]  perf: Dont adjust symbols on name lookup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf: Dont adjust symbols on name lookup

Adjusting symbols is not needed if we are searching by name even
if the symbols correspond to user space objects.
Infact if we adjust and search symbols by name, we get incorrect
results.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 tools/perf/util/symbol.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 971d0a0..e5cb705 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1016,12 +1016,14 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
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
