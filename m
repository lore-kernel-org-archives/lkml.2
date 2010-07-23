Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab0GWTmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 15:42:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60122 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab0GWTmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:42:07 -0400
Date: Fri, 23 Jul 2010 21:41:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20100723194106.GA27679@elte.hu>
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
Arnaldo Carvalho de Melo (1):
      perf annotate: Fix handling of goto labels that are valid hex numbers

Conny Seidel (1):
      perf tools: Fix fallback to cplus_demangle() when bfd_demangle() is not available

Frederic Weisbecker (1):
      perf: Fix various display bugs with parent filtering

Gui Jianfeng (1):
      perf symbols: Fix directory descriptor leaking

Sam Ravnborg (1):
      tracing: Properly align linker defined symbols


 include/asm-generic/vmlinux.lds.h |   10 +++++++++
 tools/perf/Makefile               |   40 +++++++++++++++++++-----------------
 tools/perf/util/hist.c            |   29 ++++++++++++++++++++------
 tools/perf/util/symbol.c          |   17 +++++++++------
 4 files changed, 63 insertions(+), 33 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 48c5299..4b5902a 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -63,6 +63,12 @@
 /* Align . to a 8 byte boundary equals to maximum function alignment. */
 #define ALIGN_FUNCTION()  . = ALIGN(8)
 
+/*
+ * Align to a 32 byte boundary equal to the
+ * alignment gcc 4.5 uses for a struct
+ */
+#define STRUCT_ALIGN() . = ALIGN(32)
+
 /* The actual configuration determine if the init/exit sections
  * are handled as text/data or they can be discarded (which
  * often happens at runtime)
@@ -166,7 +172,11 @@
 	LIKELY_PROFILE()		       				\
 	BRANCH_PROFILE()						\
 	TRACE_PRINTKS()							\
+									\
+	STRUCT_ALIGN();							\
 	FTRACE_EVENTS()							\
+									\
+	STRUCT_ALIGN();							\
 	TRACE_SYSCALLS()
 
 /*
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3d8f31e..d75c28a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -600,30 +600,32 @@ endif
 
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
-else ifdef HAVE_CPLUS_DEMANGLE
-	EXTLIBS += -liberty
-	BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
 else
-	has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd "$(QUIET_STDERR)" && echo y")
-
-	ifeq ($(has_bfd),y)
-		EXTLIBS += -lbfd
+	ifdef HAVE_CPLUS_DEMANGLE
+		EXTLIBS += -liberty
+		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
 	else
-		has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd -liberty "$(QUIET_STDERR)" && echo y")
-		ifeq ($(has_bfd_iberty),y)
-			EXTLIBS += -lbfd -liberty
+		has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd "$(QUIET_STDERR)" && echo y")
+
+		ifeq ($(has_bfd),y)
+			EXTLIBS += -lbfd
 		else
-			has_bfd_iberty_z := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd -liberty -lz "$(QUIET_STDERR)" && echo y")
-			ifeq ($(has_bfd_iberty_z),y)
-				EXTLIBS += -lbfd -liberty -lz
+			has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd -liberty "$(QUIET_STDERR)" && echo y")
+			ifeq ($(has_bfd_iberty),y)
+				EXTLIBS += -lbfd -liberty
 			else
-				has_cplus_demangle := $(shell sh -c "(echo 'extern char *cplus_demangle(const char *, int);'; echo 'int main(void) { cplus_demangle(0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -liberty "$(QUIET_STDERR)" && echo y")
-				ifeq ($(has_cplus_demangle),y)
-					EXTLIBS += -liberty
-					BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
+				has_bfd_iberty_z := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd -liberty -lz "$(QUIET_STDERR)" && echo y")
+				ifeq ($(has_bfd_iberty_z),y)
+					EXTLIBS += -lbfd -liberty -lz
 				else
-					msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
-					BASIC_CFLAGS += -DNO_DEMANGLE
+					has_cplus_demangle := $(shell sh -c "(echo 'extern char *cplus_demangle(const char *, int);'; echo 'int main(void) { cplus_demangle(0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -liberty "$(QUIET_STDERR)" && echo y")
+					ifeq ($(has_cplus_demangle),y)
+						EXTLIBS += -liberty
+						BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
+					else
+						msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
+						BASIC_CFLAGS += -DNO_DEMANGLE
+					endif
 				endif
 			endif
 		endif
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 07f89b6..784ee0b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -631,9 +631,14 @@ int hist_entry__fprintf(struct hist_entry *self, struct hists *pair_hists,
 			u64 session_total)
 {
 	char bf[512];
-	hist_entry__snprintf(self, bf, sizeof(bf), pair_hists,
-			     show_displacement, displacement,
-			     true, session_total);
+	int ret;
+
+	ret = hist_entry__snprintf(self, bf, sizeof(bf), pair_hists,
+				   show_displacement, displacement,
+				   true, session_total);
+	if (!ret)
+		return 0;
+
 	return fprintf(fp, "%s\n", bf);
 }
 
@@ -762,6 +767,7 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 print_entries:
 	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+		int cnt;
 
 		if (show_displacement) {
 			if (h->pair != NULL)
@@ -771,8 +777,13 @@ print_entries:
 				displacement = 0;
 			++position;
 		}
-		ret += hist_entry__fprintf(h, pair, show_displacement,
-					   displacement, fp, self->stats.total_period);
+		cnt = hist_entry__fprintf(h, pair, show_displacement,
+					  displacement, fp, self->stats.total_period);
+		/* Ignore those that didn't match the parent filter */
+		if (!cnt)
+			continue;
+
+		ret += cnt;
 
 		if (symbol_conf.use_callchain)
 			ret += hist_entry__fprintf_callchain(h, fp, self->stats.total_period);
@@ -965,13 +976,17 @@ static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
 		 * Parse hexa addresses followed by ':'
 		 */
 		line_ip = strtoull(tmp, &tmp2, 16);
-		if (*tmp2 != ':' || tmp == tmp2)
+		if (*tmp2 != ':' || tmp == tmp2 || tmp2[1] == '\0')
 			line_ip = -1;
 	}
 
 	if (line_ip != -1) {
-		u64 start = map__rip_2objdump(self->ms.map, sym->start);
+		u64 start = map__rip_2objdump(self->ms.map, sym->start),
+		    end = map__rip_2objdump(self->ms.map, sym->end);
+
 		offset = line_ip - start;
+		if (offset < 0 || (u64)line_ip > end)
+			offset = -1;
 	}
 
 	objdump_line = objdump_line__new(offset, line);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b63e571..5b27683 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1443,6 +1443,7 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
 {
 	struct dirent *dent;
 	DIR *dir = opendir(dir_name);
+	int ret = 0;
 
 	if (!dir) {
 		pr_debug("%s: cannot open %s dir\n", __func__, dir_name);
@@ -1465,8 +1466,9 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
 
 			snprintf(path, sizeof(path), "%s/%s",
 				 dir_name, dent->d_name);
-			if (map_groups__set_modules_path_dir(self, path) < 0)
-				goto failure;
+			ret = map_groups__set_modules_path_dir(self, path);
+			if (ret < 0)
+				goto out;
 		} else {
 			char *dot = strrchr(dent->d_name, '.'),
 			     dso_name[PATH_MAX];
@@ -1487,17 +1489,18 @@ static int map_groups__set_modules_path_dir(struct map_groups *self,
 				 dir_name, dent->d_name);
 
 			long_name = strdup(path);
-			if (long_name == NULL)
-				goto failure;
+			if (long_name == NULL) {
+				ret = -1;
+				goto out;
+			}
 			dso__set_long_name(map->dso, long_name);
 			dso__kernel_module_get_build_id(map->dso, "");
 		}
 	}
 
-	return 0;
-failure:
+out:
 	closedir(dir);
-	return -1;
+	return ret;
 }
 
 static char *get_kernel_version(const char *root_dir)
