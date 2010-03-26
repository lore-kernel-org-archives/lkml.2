Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0CZPRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 11:17:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46683 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab0CZPRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 11:17:15 -0400
Date: Fri, 26 Mar 2010 16:16:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20100326151653.GA30854@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (2):
      perf top: Improve the autosizing of column lenghts
      perf top: Add missing initialization to zero

Masami Hiramatsu (4):
      perf probe: Fix probe_point buffer overrun
      perf probe: Fix need_dwarf flag if lazy matching is used
      perf probe: Fix offset to allow signed value
      perf probe: Use original address instead of CU-based address

Paul Mackerras (1):
      powerpc/perf_events: Fix call-graph recording, add perf_arch_fetch_caller_regs


 arch/powerpc/include/asm/asm-compat.h |    2 ++
 arch/powerpc/kernel/misc.S            |   28 ++++++++++++++++++++++++++++
 tools/perf/builtin-probe.c            |    1 -
 tools/perf/builtin-top.c              |   13 +++++++++----
 tools/perf/util/probe-event.c         |    2 +-
 tools/perf/util/probe-finder.c        |   18 +++++++-----------
 tools/perf/util/probe-finder.h        |    1 -
 tools/perf/util/symbol.c              |   18 +++++++++++++-----
 tools/perf/util/symbol.h              |    3 ++-
 9 files changed, 62 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/include/asm/asm-compat.h b/arch/powerpc/include/asm/asm-compat.h
index c1b475a..a9b91ed 100644
--- a/arch/powerpc/include/asm/asm-compat.h
+++ b/arch/powerpc/include/asm/asm-compat.h
@@ -28,6 +28,7 @@
 #define PPC_LLARX(t, a, b, eh)	PPC_LDARX(t, a, b, eh)
 #define PPC_STLCX	stringify_in_c(stdcx.)
 #define PPC_CNTLZL	stringify_in_c(cntlzd)
+#define PPC_LR_STKOFF	16
 
 /* Move to CR, single-entry optimized version. Only available
  * on POWER4 and later.
@@ -51,6 +52,7 @@
 #define PPC_STLCX	stringify_in_c(stwcx.)
 #define PPC_CNTLZL	stringify_in_c(cntlzw)
 #define PPC_MTOCRF	stringify_in_c(mtcrf)
+#define PPC_LR_STKOFF	4
 
 #endif
 
diff --git a/arch/powerpc/kernel/misc.S b/arch/powerpc/kernel/misc.S
index 2d29752..b485a87 100644
--- a/arch/powerpc/kernel/misc.S
+++ b/arch/powerpc/kernel/misc.S
@@ -127,3 +127,31 @@ _GLOBAL(__setup_cpu_power7)
 _GLOBAL(__restore_cpu_power7)
 	/* place holder */
 	blr
+
+#ifdef CONFIG_EVENT_TRACING
+/*
+ * Get a minimal set of registers for our caller's nth caller.
+ * r3 = regs pointer, r5 = n.
+ *
+ * We only get R1 (stack pointer), NIP (next instruction pointer)
+ * and LR (link register).  These are all we can get in the
+ * general case without doing complicated stack unwinding, but
+ * fortunately they are enough to do a stack backtrace, which
+ * is all we need them for.
+ */
+_GLOBAL(perf_arch_fetch_caller_regs)
+	mr	r6,r1
+	cmpwi	r5,0
+	mflr	r4
+	ble	2f
+	mtctr	r5
+1:	PPC_LL	r6,0(r6)
+	bdnz	1b
+	PPC_LL	r4,PPC_LR_STKOFF(r6)
+2:	PPC_LL	r7,0(r6)
+	PPC_LL	r7,PPC_LR_STKOFF(r7)
+	PPC_STL	r6,GPR1-STACK_FRAME_OVERHEAD(r3)
+	PPC_STL	r4,_NIP-STACK_FRAME_OVERHEAD(r3)
+	PPC_STL	r7,_LINK-STACK_FRAME_OVERHEAD(r3)
+	blr
+#endif /* CONFIG_EVENT_TRACING */
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index c30a335..152d6c9 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -47,7 +47,6 @@
 #include "util/probe-event.h"
 
 #define MAX_PATH_LEN 256
-#define MAX_PROBES 128
 
 /* Session management structure */
 static struct {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 0b719e3..1f52932 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -455,7 +455,7 @@ static void print_sym_table(void)
 	struct sym_entry *syme, *n;
 	struct rb_root tmp = RB_ROOT;
 	struct rb_node *nd;
-	int sym_width = 0, dso_width = 0, max_dso_width;
+	int sym_width = 0, dso_width = 0, dso_short_width = 0;
 	const int win_width = winsize.ws_col - 1;
 
 	samples = userspace_samples = 0;
@@ -545,15 +545,20 @@ static void print_sym_table(void)
 		if (syme->map->dso->long_name_len > dso_width)
 			dso_width = syme->map->dso->long_name_len;
 
+		if (syme->map->dso->short_name_len > dso_short_width)
+			dso_short_width = syme->map->dso->short_name_len;
+
 		if (syme->name_len > sym_width)
 			sym_width = syme->name_len;
 	}
 
 	printed = 0;
 
-	max_dso_width = winsize.ws_col - sym_width - 29;
-	if (dso_width > max_dso_width)
-		dso_width = max_dso_width;
+	if (sym_width + dso_width > winsize.ws_col - 29) {
+		dso_width = dso_short_width;
+		if (sym_width + dso_width > winsize.ws_col - 29)
+			sym_width = winsize.ws_col - dso_width - 29;
+	}
 	putchar('\n');
 	if (nr_counters == 1)
 		printf("             samples  pcnt");
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 53181db..7c004b6 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -242,7 +242,7 @@ void parse_perf_probe_event(const char *str, struct probe_point *pp,
 
 	/* Parse probe point */
 	parse_perf_probe_probepoint(argv[0], pp);
-	if (pp->file || pp->line)
+	if (pp->file || pp->line || pp->lazy_line)
 		*need_dwarf = true;
 
 	/* Copy arguments and ensure return probe has no C argument */
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 1e6c65e..c171a24 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -333,8 +333,8 @@ static void show_location(Dwarf_Op *op, struct probe_finder *pf)
 		die("%u exceeds max register number.", regn);
 
 	if (deref)
-		ret = snprintf(pf->buf, pf->len, " %s=+%ju(%s)",
-			       pf->var, (uintmax_t)offs, regs);
+		ret = snprintf(pf->buf, pf->len, " %s=%+jd(%s)",
+			       pf->var, (intmax_t)offs, regs);
 	else
 		ret = snprintf(pf->buf, pf->len, " %s=%s", pf->var, regs);
 	DIE_IF(ret < 0);
@@ -352,8 +352,7 @@ static void show_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 	if (dwarf_attr(vr_die, DW_AT_location, &attr) == NULL)
 		goto error;
 	/* TODO: handle more than 1 exprs */
-	ret = dwarf_getlocation_addr(&attr, (pf->addr - pf->cu_base),
-				     &expr, &nexpr, 1);
+	ret = dwarf_getlocation_addr(&attr, pf->addr, &expr, &nexpr, 1);
 	if (ret <= 0 || nexpr == 0)
 		goto error;
 
@@ -437,8 +436,7 @@ static void show_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 
 	/* Get the frame base attribute/ops */
 	dwarf_attr(sp_die, DW_AT_frame_base, &fb_attr);
-	ret = dwarf_getlocation_addr(&fb_attr, (pf->addr - pf->cu_base),
-				     &pf->fb_ops, &nops, 1);
+	ret = dwarf_getlocation_addr(&fb_attr, pf->addr, &pf->fb_ops, &nops, 1);
 	if (ret <= 0 || nops == 0)
 		pf->fb_ops = NULL;
 
@@ -455,6 +453,9 @@ static void show_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 	/* *pf->fb_ops will be cached in libdw. Don't free it. */
 	pf->fb_ops = NULL;
 
+	if (pp->found == MAX_PROBES)
+		die("Too many( > %d) probe point found.\n", MAX_PROBES);
+
 	pp->probes[pp->found] = strdup(tmp);
 	pp->found++;
 }
@@ -641,7 +642,6 @@ static void find_probe_point_by_func(struct probe_finder *pf)
 int find_probe_point(int fd, struct probe_point *pp)
 {
 	struct probe_finder pf = {.pp = pp};
-	int ret;
 	Dwarf_Off off, noff;
 	size_t cuhl;
 	Dwarf_Die *diep;
@@ -668,10 +668,6 @@ int find_probe_point(int fd, struct probe_point *pp)
 			pf.fname = NULL;
 
 		if (!pp->file || pf.fname) {
-			/* Save CU base address (for frame_base) */
-			ret = dwarf_lowpc(&pf.cu_die, &pf.cu_base);
-			if (ret != 0)
-				pf.cu_base = 0;
 			if (pp->function)
 				find_probe_point_by_func(&pf);
 			else if (pp->lazy_line)
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index d1a6517..21f7354 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -71,7 +71,6 @@ struct probe_finder {
 
 	/* For variable searching */
 	Dwarf_Op		*fb_ops;	/* Frame base attribute */
-	Dwarf_Addr		cu_base;	/* Current CU base address */
 	const char		*var;		/* Current variable name */
 	char			*buf;		/* Current output buffer */
 	int			len;		/* Length of output buffer */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 323c0ae..c458c4a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -163,9 +163,17 @@ void dso__set_long_name(struct dso *self, char *name)
 	self->long_name_len = strlen(name);
 }
 
+static void dso__set_short_name(struct dso *self, const char *name)
+{
+	if (name == NULL)
+		return;
+	self->short_name = name;
+	self->short_name_len = strlen(name);
+}
+
 static void dso__set_basename(struct dso *self)
 {
-	self->short_name = basename(self->long_name);
+	dso__set_short_name(self, basename(self->long_name));
 }
 
 struct dso *dso__new(const char *name)
@@ -176,7 +184,7 @@ struct dso *dso__new(const char *name)
 		int i;
 		strcpy(self->name, name);
 		dso__set_long_name(self, self->name);
-		self->short_name = self->name;
+		dso__set_short_name(self, self->name);
 		for (i = 0; i < MAP__NR_TYPES; ++i)
 			self->symbols[i] = self->symbol_names[i] = RB_ROOT;
 		self->slen_calculated = 0;
@@ -897,7 +905,6 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 	struct kmap *kmap = self->kernel ? map__kmap(map) : NULL;
 	struct map *curr_map = map;
 	struct dso *curr_dso = self;
-	size_t dso_name_len = strlen(self->short_name);
 	Elf_Data *symstrs, *secstrs;
 	uint32_t nr_syms;
 	int err = -1;
@@ -987,7 +994,8 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 			char dso_name[PATH_MAX];
 
 			if (strcmp(section_name,
-				   curr_dso->short_name + dso_name_len) == 0)
+				   (curr_dso->short_name +
+				    self->short_name_len)) == 0)
 				goto new_symbol;
 
 			if (strcmp(section_name, ".text") == 0) {
@@ -1782,7 +1790,7 @@ struct dso *dso__new_kernel(const char *name)
 	struct dso *self = dso__new(name ?: "[kernel.kallsyms]");
 
 	if (self != NULL) {
-		self->short_name = "[kernel]";
+		dso__set_short_name(self, "[kernel]");
 		self->kernel	 = 1;
 	}
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 280dadd..f30a374 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -110,9 +110,10 @@ struct dso {
 	u8		 sorted_by_name;
 	u8		 loaded;
 	u8		 build_id[BUILD_ID_SIZE];
-	u16		 long_name_len;
 	const char	 *short_name;
 	char	 	 *long_name;
+	u16		 long_name_len;
+	u16		 short_name_len;
 	char		 name[0];
 };
 
