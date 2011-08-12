Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1HLQbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:31:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45363 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1HLQ3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 12:29:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/12] perf probe: Fix to search nested inlined functions in CU
Date: Fri, 12 Aug 2011 13:28:58 -0300
Message-Id: <1313166544-6209-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1313166544-6209-1-git-send-email-acme@infradead.org>
References: <1313166544-6209-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix perf probe to walk through the lines of all nested inlined function
call sites and declared lines when a whole CU is passed to the line
walker.

The die_walk_lines() can have two different type of DIEs, subprogram (or
inlined-subroutine) DIE and CU DIE.

If a caller passes a subprogram DIE, this means that the walker walk on
lines of given subprogram. In this case, it just needs to search on
direct children of DIE tree for finding call-site information of inlined
function which directly called from given subprogram.

On the other hand, if a caller passes a CU DIE to the walker, this means
that the walker have to walk on all lines in the source files included
in given CU DIE. In this case, it has to search whole DIE trees of all
subprograms to find the call-site information of all nested inlined
functions.

Without this patch:

$ perf probe --line kernel/cpu.c:151-157
</home/mhiramat/ksrc/linux-2.6/kernel/cpu.c:151>

         static int cpu_notify(unsigned long val, void *v)
         {
    154         return __cpu_notify(val, v, -1, NULL);
         }

With this:
$ perf probe --line kernel/cpu.c:151-157
</home/mhiramat/ksrc/linux-2.6/kernel/cpu.c:151>

    152  static int cpu_notify(unsigned long val, void *v)
         {
    154         return __cpu_notify(val, v, -1, NULL);
         }

As you can see, --line option with source line range shows the declared
lines as probe-able.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20110811110241.19900.34994.stgit@fedora15
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dwarf-aux.c |   91 +++++++++++++++++++++++++++++++++++++------
 tools/perf/util/dwarf-aux.h |    3 +
 2 files changed, 82 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index d35b454..d9b8ad0 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -198,6 +198,19 @@ static int die_get_attr_udata(Dwarf_Die *tp_die, unsigned int attr_name,
 	return 0;
 }
 
+/* Get attribute and translate it as a sdata */
+static int die_get_attr_sdata(Dwarf_Die *tp_die, unsigned int attr_name,
+			      Dwarf_Sword *result)
+{
+	Dwarf_Attribute attr;
+
+	if (dwarf_attr(tp_die, attr_name, &attr) == NULL ||
+	    dwarf_formsdata(&attr, result) != 0)
+		return -ENOENT;
+
+	return 0;
+}
+
 /**
  * die_is_signed_type - Check whether a type DIE is signed or not
  * @tp_die: a DIE of a type
@@ -250,6 +263,39 @@ int die_get_data_member_location(Dwarf_Die *mb_die, Dwarf_Word *offs)
 	return 0;
 }
 
+/* Get the call file index number in CU DIE */
+static int die_get_call_fileno(Dwarf_Die *in_die)
+{
+	Dwarf_Sword idx;
+
+	if (die_get_attr_sdata(in_die, DW_AT_call_file, &idx) == 0)
+		return (int)idx;
+	else
+		return -ENOENT;
+}
+
+/**
+ * die_get_call_file - Get callsite file name of inlined function instance
+ * @in_die: a DIE of an inlined function instance
+ *
+ * Get call-site file name of @in_die. This means from which file the inline
+ * function is called.
+ */
+const char *die_get_call_file(Dwarf_Die *in_die)
+{
+	Dwarf_Die cu_die;
+	Dwarf_Files *files;
+	int idx;
+
+	idx = die_get_call_fileno(in_die);
+	if (idx < 0 || !dwarf_diecu(in_die, &cu_die, NULL, NULL) ||
+	    dwarf_getsrcfiles(&cu_die, &files, NULL) != 0)
+		return NULL;
+
+	return dwarf_filesrc(files, idx, NULL, NULL);
+}
+
+
 /**
  * die_find_child - Generic DIE search function in DIE tree
  * @rt_die: a root DIE
@@ -376,7 +422,7 @@ Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
 
 /* Line walker internal parameters */
 struct __line_walk_param {
-	const char *fname;
+	bool recursive;
 	line_walk_callback_t callback;
 	void *data;
 	int retval;
@@ -385,39 +431,56 @@ struct __line_walk_param {
 static int __die_walk_funclines_cb(Dwarf_Die *in_die, void *data)
 {
 	struct __line_walk_param *lw = data;
-	Dwarf_Addr addr;
+	Dwarf_Addr addr = 0;
+	const char *fname;
 	int lineno;
 
 	if (dwarf_tag(in_die) == DW_TAG_inlined_subroutine) {
+		fname = die_get_call_file(in_die);
 		lineno = die_get_call_lineno(in_die);
-		if (lineno > 0 && dwarf_entrypc(in_die, &addr) == 0) {
-			lw->retval = lw->callback(lw->fname, lineno, addr,
-						  lw->data);
+		if (fname && lineno > 0 && dwarf_entrypc(in_die, &addr) == 0) {
+			lw->retval = lw->callback(fname, lineno, addr, lw->data);
 			if (lw->retval != 0)
 				return DIE_FIND_CB_END;
 		}
 	}
-	return DIE_FIND_CB_SIBLING;
+	if (!lw->recursive)
+		/* Don't need to search recursively */
+		return DIE_FIND_CB_SIBLING;
+
+	if (addr) {
+		fname = dwarf_decl_file(in_die);
+		if (fname && dwarf_decl_line(in_die, &lineno) == 0) {
+			lw->retval = lw->callback(fname, lineno, addr, lw->data);
+			if (lw->retval != 0)
+				return DIE_FIND_CB_END;
+		}
+	}
+
+	/* Continue to search nested inlined function call-sites */
+	return DIE_FIND_CB_CONTINUE;
 }
 
 /* Walk on lines of blocks included in given DIE */
-static int __die_walk_funclines(Dwarf_Die *sp_die,
+static int __die_walk_funclines(Dwarf_Die *sp_die, bool recursive,
 				line_walk_callback_t callback, void *data)
 {
 	struct __line_walk_param lw = {
+		.recursive = recursive,
 		.callback = callback,
 		.data = data,
 		.retval = 0,
 	};
 	Dwarf_Die die_mem;
 	Dwarf_Addr addr;
+	const char *fname;
 	int lineno;
 
 	/* Handle function declaration line */
-	lw.fname = dwarf_decl_file(sp_die);
-	if (lw.fname && dwarf_decl_line(sp_die, &lineno) == 0 &&
+	fname = dwarf_decl_file(sp_die);
+	if (fname && dwarf_decl_line(sp_die, &lineno) == 0 &&
 	    dwarf_entrypc(sp_die, &addr) == 0) {
-		lw.retval = callback(lw.fname, lineno, addr, data);
+		lw.retval = callback(fname, lineno, addr, data);
 		if (lw.retval != 0)
 			goto done;
 	}
@@ -430,7 +493,7 @@ static int __die_walk_culines_cb(Dwarf_Die *sp_die, void *data)
 {
 	struct __line_walk_param *lw = data;
 
-	lw->retval = __die_walk_funclines(sp_die, lw->callback, lw->data);
+	lw->retval = __die_walk_funclines(sp_die, true, lw->callback, lw->data);
 	if (lw->retval != 0)
 		return DWARF_CB_ABORT;
 
@@ -509,7 +572,11 @@ int die_walk_lines(Dwarf_Die *rt_die, line_walk_callback_t callback, void *data)
 	 * subroutines. We have to check functions list or given function.
 	 */
 	if (rt_die != cu_die)
-		ret = __die_walk_funclines(rt_die, callback, data);
+		/*
+		 * Don't need walk functions recursively, because nested
+		 * inlined functions don't have lines of the specified DIE.
+		 */
+		ret = __die_walk_funclines(rt_die, false, callback, data);
 	else {
 		struct __line_walk_param param = {
 			.callback = callback,
diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
index bc3b211..c8e491b 100644
--- a/tools/perf/util/dwarf-aux.h
+++ b/tools/perf/util/dwarf-aux.h
@@ -40,6 +40,9 @@ extern bool die_compare_name(Dwarf_Die *dw_die, const char *tname);
 /* Get callsite line number of inline-function instance */
 extern int die_get_call_lineno(Dwarf_Die *in_die);
 
+/* Get callsite file name of inlined function instance */
+extern const char *die_get_call_file(Dwarf_Die *in_die);
+
 /* Get type die */
 extern Dwarf_Die *die_get_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem);
 
-- 
1.6.2.5

