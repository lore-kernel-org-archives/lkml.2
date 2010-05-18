Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab0ERRE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:04:59 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:33077 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991Ab0ERRAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:00:48 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 18 May 2010 22:30:44 +0530
Message-Id: <20100518170044.20070.98772.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100518165826.20070.11594.sendpatchset@localhost6.localdomain6>
References: <20100518165826.20070.11594.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v4 12/13] perf: Dont adjust symbols on name lookup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adjusting symbols is not needed if we are searching by name.
Infact if we adjust and search symbols by name, we get incorrect
results.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 tools/perf/util/symbol.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c458c4a..7267050 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -958,12 +958,14 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	memset(&sym, 0, sizeof(sym));
-	if (!self->kernel) {
+	if (self->kernel || symbol_conf.sort_by_name)
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
