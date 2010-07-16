Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab0GPRbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 13:31:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54415 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab0GPRbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 13:31:01 -0400
Date: Fri, 16 Jul 2010 19:30:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20100716173035.GA13227@elte.hu>
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

Note, we included the version fixes because external tools started to rely on 
perf command output and we got a request to have more precise versioning 
available.

This tree also includes the simpler fix from Steve for syscalls.h. There was a 
second patch being worked on as well - this one fixes the crash for the time 
being.

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (2):
      perf: Resurrect flat callchains
      perf: Sync callchains with period based hits

Steven Rostedt (1):
      tracing: Add alignment to syscall metadata declarations

Thavidu Ranatunga (2):
      perf: Version String fix, using kernel version
      perf: Version String fix, for fallback if not from git


 include/linux/syscalls.h         |    6 ++++--
 tools/perf/builtin-report.c      |    2 +-
 tools/perf/util/PERF-VERSION-GEN |   17 +++++++++--------
 tools/perf/util/callchain.c      |   35 ++++++++++++++++++-----------------
 tools/perf/util/callchain.h      |    5 ++++-
 5 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 7f614ce..13ebb54 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -124,7 +124,8 @@ extern struct trace_event_functions enter_syscall_print_funcs;
 extern struct trace_event_functions exit_syscall_print_funcs;
 
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
-	static struct syscall_metadata __syscall_meta_##sname;		\
+	static struct syscall_metadata					\
+	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_enter_##sname;		\
 	static struct ftrace_event_call __used				\
@@ -138,7 +139,8 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	}
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
-	static struct syscall_metadata __syscall_meta_##sname;		\
+	static struct syscall_metadata					\
+	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_exit_##sname;		\
 	static struct ftrace_event_call __used				\
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3592057..fd7407c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -107,7 +107,7 @@ static int perf_session__add_hist_entry(struct perf_session *self,
 		goto out_free_syms;
 	err = 0;
 	if (symbol_conf.use_callchain) {
-		err = append_chain(he->callchain, data->callchain, syms);
+		err = append_chain(he->callchain, data->callchain, syms, data->period);
 		if (err)
 			goto out_free_syms;
 	}
diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 49ece79..97d7656 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -5,17 +5,13 @@ if [ $# -eq 1 ]  ; then
 fi
 
 GVF=${OUTPUT}PERF-VERSION-FILE
-DEF_VER=v0.0.2.PERF
 
 LF='
 '
 
-# First see if there is a version file (included in release tarballs),
-# then try git-describe, then default.
-if test -f version
-then
-	VN=$(cat version) || VN="$DEF_VER"
-elif test -d .git -o -f .git &&
+# First check if there is a .git to get the version from git describe
+# otherwise try to get the version from the kernel makefile
+if test -d ../../.git -o -f ../../.git &&
 	VN=$(git describe --abbrev=4 HEAD 2>/dev/null) &&
 	case "$VN" in
 	*$LF*) (exit 1) ;;
@@ -27,7 +23,12 @@ elif test -d .git -o -f .git &&
 then
 	VN=$(echo "$VN" | sed -e 's/-/./g');
 else
-	VN="$DEF_VER"
+	eval `grep '^VERSION\s*=' ../../Makefile|tr -d ' '`
+	eval `grep '^PATCHLEVEL\s*=' ../../Makefile|tr -d ' '`
+	eval `grep '^SUBLEVEL\s*=' ../../Makefile|tr -d ' '`
+	eval `grep '^EXTRAVERSION\s*=' ../../Makefile|tr -d ' '`
+
+	VN="${VERSION}.${PATCHLEVEL}.${SUBLEVEL}${EXTRAVERSION}"
 fi
 
 VN=$(expr "$VN" : v*'\(.*\)')
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 62b69ad..52c777e 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -230,7 +230,7 @@ fill_node(struct callchain_node *node, struct resolved_chain *chain, int start)
 
 static void
 add_child(struct callchain_node *parent, struct resolved_chain *chain,
-	  int start)
+	  int start, u64 period)
 {
 	struct callchain_node *new;
 
@@ -238,7 +238,7 @@ add_child(struct callchain_node *parent, struct resolved_chain *chain,
 	fill_node(new, chain, start);
 
 	new->children_hit = 0;
-	new->hit = 1;
+	new->hit = period;
 }
 
 /*
@@ -248,7 +248,8 @@ add_child(struct callchain_node *parent, struct resolved_chain *chain,
  */
 static void
 split_add_child(struct callchain_node *parent, struct resolved_chain *chain,
-		struct callchain_list *to_split, int idx_parents, int idx_local)
+		struct callchain_list *to_split, int idx_parents, int idx_local,
+		u64 period)
 {
 	struct callchain_node *new;
 	struct list_head *old_tail;
@@ -275,41 +276,41 @@ split_add_child(struct callchain_node *parent, struct resolved_chain *chain,
 	/* create a new child for the new branch if any */
 	if (idx_total < chain->nr) {
 		parent->hit = 0;
-		add_child(parent, chain, idx_total);
-		parent->children_hit++;
+		add_child(parent, chain, idx_total, period);
+		parent->children_hit += period;
 	} else {
-		parent->hit = 1;
+		parent->hit = period;
 	}
 }
 
 static int
 __append_chain(struct callchain_node *root, struct resolved_chain *chain,
-	       unsigned int start);
+	       unsigned int start, u64 period);
 
 static void
 __append_chain_children(struct callchain_node *root,
 			struct resolved_chain *chain,
-			unsigned int start)
+			unsigned int start, u64 period)
 {
 	struct callchain_node *rnode;
 
 	/* lookup in childrens */
 	chain_for_each_child(rnode, root) {
-		unsigned int ret = __append_chain(rnode, chain, start);
+		unsigned int ret = __append_chain(rnode, chain, start, period);
 
 		if (!ret)
 			goto inc_children_hit;
 	}
 	/* nothing in children, add to the current node */
-	add_child(root, chain, start);
+	add_child(root, chain, start, period);
 
 inc_children_hit:
-	root->children_hit++;
+	root->children_hit += period;
 }
 
 static int
 __append_chain(struct callchain_node *root, struct resolved_chain *chain,
-	       unsigned int start)
+	       unsigned int start, u64 period)
 {
 	struct callchain_list *cnode;
 	unsigned int i = start;
@@ -345,18 +346,18 @@ __append_chain(struct callchain_node *root, struct resolved_chain *chain,
 
 	/* we match only a part of the node. Split it and add the new chain */
 	if (i - start < root->val_nr) {
-		split_add_child(root, chain, cnode, start, i - start);
+		split_add_child(root, chain, cnode, start, i - start, period);
 		return 0;
 	}
 
 	/* we match 100% of the path, increment the hit */
 	if (i - start == root->val_nr && i == chain->nr) {
-		root->hit++;
+		root->hit += period;
 		return 0;
 	}
 
 	/* We match the node and still have a part remaining */
-	__append_chain_children(root, chain, i);
+	__append_chain_children(root, chain, i, period);
 
 	return 0;
 }
@@ -380,7 +381,7 @@ static void filter_context(struct ip_callchain *old, struct resolved_chain *new,
 
 
 int append_chain(struct callchain_node *root, struct ip_callchain *chain,
-		 struct map_symbol *syms)
+		 struct map_symbol *syms, u64 period)
 {
 	struct resolved_chain *filtered;
 
@@ -397,7 +398,7 @@ int append_chain(struct callchain_node *root, struct ip_callchain *chain,
 	if (!filtered->nr)
 		goto end;
 
-	__append_chain_children(root, filtered, 0);
+	__append_chain_children(root, filtered, 0, period);
 end:
 	free(filtered);
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 1ca73e4..f2e9ee1 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -49,6 +49,9 @@ static inline void callchain_init(struct callchain_node *node)
 	INIT_LIST_HEAD(&node->brothers);
 	INIT_LIST_HEAD(&node->children);
 	INIT_LIST_HEAD(&node->val);
+
+	node->parent = NULL;
+	node->hit = 0;
 }
 
 static inline u64 cumul_hits(struct callchain_node *node)
@@ -58,7 +61,7 @@ static inline u64 cumul_hits(struct callchain_node *node)
 
 int register_callchain_param(struct callchain_param *param);
 int append_chain(struct callchain_node *root, struct ip_callchain *chain,
-		 struct map_symbol *syms);
+		 struct map_symbol *syms, u64 period);
 
 bool ip_callchain__valid(struct ip_callchain *chain, event_t *event);
 #endif	/* __PERF_CALLCHAIN_H */
