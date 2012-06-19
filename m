Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab2FSSCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:02:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33399 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab2FSSAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:00:18 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/20] perf tools: Add sort by src line/number
Date: Tue, 19 Jun 2012 14:50:02 -0300
Message-Id: <1340128221-17348-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1340128221-17348-1-git-send-email-acme@infradead.org>
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Using addr2line for now, requires debuginfo, needs more work to support
detached debuginfo, aka foo-debuginfo packages.

Example:

	[root@sandy ~]# perf record -a sleep 3
	[ perf record: Woken up 1 times to write data ]
	[ perf record: Captured and wrote 0.555 MB perf.data (~24236 samples) ]
	[root@sandy ~]# perf report -s dso,srcline 2>&1 | grep -v ^# | head -5
	    22.41%  [kernel.kallsyms]  /home/git/linux/drivers/idle/intel_idle.c:280
	     4.79%  [kernel.kallsyms]  /home/git/linux/drivers/cpuidle/cpuidle.c:148
	     4.78%  [kernel.kallsyms]  /home/git/linux/arch/x86/include/asm/atomic64_64.h:121
	     4.49%  [kernel.kallsyms]  /home/git/linux/kernel/sched/core.c:1690
	     4.30%  [kernel.kallsyms]  /home/git/linux/include/linux/seqlock.h:90
	[root@sandy ~]#

[root@sandy ~]# perf top -U -s dso,symbol,srcline
Samples: 1K of event 'cycles', Event count (approx.): 589617389
 18.66%  [kernel]  [k] copy_user_generic_unrolled   /home/git/linux/arch/x86/lib/copy_user_64.S:143
  7.83%  [kernel]  [k] clear_page                   /home/git/linux/arch/x86/lib/clear_page_64.S:39
  6.59%  [kernel]  [k] clear_page                   /home/git/linux/arch/x86/lib/clear_page_64.S:38
  3.66%  [kernel]  [k] page_fault                   /home/git/linux/arch/x86/kernel/entry_64.S:1379
  3.25%  [kernel]  [k] clear_page                   /home/git/linux/arch/x86/lib/clear_page_64.S:40
  3.12%  [kernel]  [k] clear_page                   /home/git/linux/arch/x86/lib/clear_page_64.S:37
  2.74%  [kernel]  [k] clear_page                   /home/git/linux/arch/x86/lib/clear_page_64.S:36
  2.39%  [kernel]  [k] clear_page                   /home/git/linux/arch/x86/lib/clear_page_64.S:43
  2.12%  [kernel]  [k] ioread32                     /home/git/linux/lib/iomap.c:90
  1.51%  [kernel]  [k] copy_user_generic_unrolled   /home/git/linux/arch/x86/lib/copy_user_64.S:144
  1.19%  [kernel]  [k] copy_user_generic_unrolled   /home/git/linux/arch/x86/lib/copy_user_64.S:154

Suggested-by: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-pdmqbng9twz06jzkbgtuwbp8@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |    2 +-
 tools/perf/Documentation/perf-top.txt    |    2 +-
 tools/perf/util/hist.h                   |    1 +
 tools/perf/util/sort.c                   |   49 ++++++++++++++++++++++++++++++
 tools/perf/util/sort.h                   |    2 +
 5 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 2d89f02..495210a 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -57,7 +57,7 @@ OPTIONS
 
 -s::
 --sort=::
-	Sort by key(s): pid, comm, dso, symbol, parent.
+	Sort by key(s): pid, comm, dso, symbol, parent, srcline.
 
 -p::
 --parent=<regex>::
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 4a5680c..5b80d84 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -112,7 +112,7 @@ Default is to monitor all CPUS.
 
 -s::
 --sort::
-	Sort by key(s): pid, comm, dso, symbol, parent
+	Sort by key(s): pid, comm, dso, symbol, parent, srcline.
 
 -n::
 --show-nr-samples::
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 34bb556..0b096c2 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -47,6 +47,7 @@ enum hist_column {
 	HISTC_SYMBOL_TO,
 	HISTC_DSO_FROM,
 	HISTC_DSO_TO,
+	HISTC_SRCLINE,
 	HISTC_NR_COLS, /* Last entry */
 };
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index a272374..0f5a0a4 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -241,6 +241,54 @@ struct sort_entry sort_sym = {
 	.se_width_idx	= HISTC_SYMBOL,
 };
 
+/* --sort srcline */
+
+static int64_t
+sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return (int64_t)(right->ip - left->ip);
+}
+
+static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
+				   size_t size, unsigned int width __used)
+{
+	FILE *fp;
+	char cmd[PATH_MAX + 2], *path = self->srcline, *nl;
+	size_t line_len;
+
+	if (path != NULL)
+		goto out_path;
+
+	snprintf(cmd, sizeof(cmd), "addr2line -e %s %016" PRIx64,
+		 self->ms.map->dso->long_name, self->ip);
+	fp = popen(cmd, "r");
+	if (!fp)
+		goto out_ip;
+
+	if (getline(&path, &line_len, fp) < 0 || !line_len)
+		goto out_ip;
+	fclose(fp);
+	self->srcline = strdup(path);
+	if (self->srcline == NULL)
+		goto out_ip;
+
+	nl = strchr(self->srcline, '\n');
+	if (nl != NULL)
+		*nl = '\0';
+	path = self->srcline;
+out_path:
+	return repsep_snprintf(bf, size, "%s", path);
+out_ip:
+	return repsep_snprintf(bf, size, "%-#*llx", BITS_PER_LONG / 4, self->ip);
+}
+
+struct sort_entry sort_srcline = {
+	.se_header	= "Source:Line",
+	.se_cmp		= sort__srcline_cmp,
+	.se_snprintf	= hist_entry__srcline_snprintf,
+	.se_width_idx	= HISTC_SRCLINE,
+};
+
 /* --sort parent */
 
 static int64_t
@@ -439,6 +487,7 @@ static struct sort_dimension sort_dimensions[] = {
 	DIM(SORT_PARENT, "parent", sort_parent),
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_MISPREDICT, "mispredict", sort_mispredict),
+	DIM(SORT_SRCLINE, "srcline", sort_srcline),
 };
 
 int sort_dimension__add(const char *tok)
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 472aa5a..e724b26 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -71,6 +71,7 @@ struct hist_entry {
 	char			level;
 	bool			used;
 	u8			filtered;
+	char			*srcline;
 	struct symbol		*parent;
 	union {
 		unsigned long	  position;
@@ -93,6 +94,7 @@ enum sort_type {
 	SORT_SYM_FROM,
 	SORT_SYM_TO,
 	SORT_MISPREDICT,
+	SORT_SRCLINE,
 };
 
 /*
-- 
1.7.1

