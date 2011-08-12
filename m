Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab1HLQbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:31:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45362 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1HLQ3T (ORCPT
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
Subject: [PATCH 11/12] perf probe: Search concrete out-of-line instances
Date: Fri, 12 Aug 2011 13:29:03 -0300
Message-Id: <1313166544-6209-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1313166544-6209-1-git-send-email-acme@infradead.org>
References: <1313166544-6209-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

gcc 4.6 generates a concrete out-of-line instance when there is a
function which is implicitly inlined somewhere but also has its own
instance. The concrete out-of-line instance means that it has an
abstract origin of the function which is referred by not only
inlined-subroutines but also a concrete subprogram.

Since current dwarf_func_inline_instances() can find only instances of
inlined-subroutines, this introduces new die_walk_instances() to find
both of subprogram and inlined-subroutines.

e.g. without this,
Available variables at sched_group_rt_period
        @<cpu_rt_period_read_uint+9>
                struct task_group*      tg

perf probe failed to find actual subprogram instance of
sched_group_rt_period().

With this,

Available variables at sched_group_rt_period
        @<cpu_rt_period_read_uint+9>
                struct task_group*      tg
        @<sched_group_rt_period+0>
                struct task_group*      tg

Now it found the sched_group_rt_period() itself.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20110811110311.19900.63997.stgit@fedora15
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dwarf-aux.c    |   58 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/dwarf-aux.h    |    4 +++
 tools/perf/util/probe-finder.c |   56 ++++++++++++++------------------------
 3 files changed, 83 insertions(+), 35 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 425703a..d0f4048 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -453,6 +453,64 @@ Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
 	return die_mem;
 }
 
+struct __instance_walk_param {
+	void    *addr;
+	int	(*callback)(Dwarf_Die *, void *);
+	void    *data;
+	int	retval;
+};
+
+static int __die_walk_instances_cb(Dwarf_Die *inst, void *data)
+{
+	struct __instance_walk_param *iwp = data;
+	Dwarf_Attribute attr_mem;
+	Dwarf_Die origin_mem;
+	Dwarf_Attribute *attr;
+	Dwarf_Die *origin;
+
+	attr = dwarf_attr(inst, DW_AT_abstract_origin, &attr_mem);
+	if (attr == NULL)
+		return DIE_FIND_CB_CONTINUE;
+
+	origin = dwarf_formref_die(attr, &origin_mem);
+	if (origin == NULL || origin->addr != iwp->addr)
+		return DIE_FIND_CB_CONTINUE;
+
+	iwp->retval = iwp->callback(inst, iwp->data);
+
+	return (iwp->retval) ? DIE_FIND_CB_END : DIE_FIND_CB_CONTINUE;
+}
+
+/**
+ * die_walk_instances - Walk on instances of given DIE
+ * @or_die: an abstract original DIE
+ * @callback: a callback function which is called with instance DIE
+ * @data: user data
+ *
+ * Walk on the instances of give @in_die. @in_die must be an inlined function
+ * declartion. This returns the return value of @callback if it returns
+ * non-zero value, or -ENOENT if there is no instance.
+ */
+int die_walk_instances(Dwarf_Die *or_die, int (*callback)(Dwarf_Die *, void *),
+		       void *data)
+{
+	Dwarf_Die cu_die;
+	Dwarf_Die die_mem;
+	struct __instance_walk_param iwp = {
+		.addr = or_die->addr,
+		.callback = callback,
+		.data = data,
+		.retval = -ENOENT,
+	};
+
+	if (dwarf_diecu(or_die, &cu_die, NULL, NULL) == NULL)
+		return -ENOENT;
+
+	die_find_child(&cu_die, __die_walk_instances_cb, &iwp, &die_mem);
+
+	return iwp.retval;
+}
+
 /* Line walker internal parameters */
 struct __line_walk_param {
 	bool recursive;
diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
index 6f46106..6ce1717 100644
--- a/tools/perf/util/dwarf-aux.h
+++ b/tools/perf/util/dwarf-aux.h
@@ -80,6 +80,10 @@ extern Dwarf_Die *die_find_realfunc(Dwarf_Die *cu_die, Dwarf_Addr addr,
 extern Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
 				      Dwarf_Die *die_mem);
 
+/* Walk on the instances of given DIE */
+extern int die_walk_instances(Dwarf_Die *in_die,
+			      int (*callback)(Dwarf_Die *, void *), void *data);
+
 /* Walker on lines (Note: line number will not be sorted) */
 typedef int (* line_walk_callback_t) (const char *fname, int lineno,
 				      Dwarf_Addr addr, void *data);
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 114542a..555fc38 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -924,42 +924,39 @@ static int find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
 	return die_walk_lines(sp_die, probe_point_lazy_walker, pf);
 }
 
-/* Callback parameter with return value */
-struct dwarf_callback_param {
-	void *data;
-	int retval;
-};
-
 static int probe_point_inline_cb(Dwarf_Die *in_die, void *data)
 {
-	struct dwarf_callback_param *param = data;
-	struct probe_finder *pf = param->data;
+	struct probe_finder *pf = data;
 	struct perf_probe_point *pp = &pf->pev->point;
 	Dwarf_Addr addr;
+	int ret;
 
 	if (pp->lazy_line)
-		param->retval = find_probe_point_lazy(in_die, pf);
+		ret = find_probe_point_lazy(in_die, pf);
 	else {
 		/* Get probe address */
 		if (dwarf_entrypc(in_die, &addr) != 0) {
 			pr_warning("Failed to get entry address of %s.\n",
 				   dwarf_diename(in_die));
-			param->retval = -ENOENT;
-			return DWARF_CB_ABORT;
+			return -ENOENT;
 		}
 		pf->addr = addr;
 		pf->addr += pp->offset;
 		pr_debug("found inline addr: 0x%jx\n",
 			 (uintmax_t)pf->addr);
 
-		param->retval = call_probe_finder(in_die, pf);
-		if (param->retval < 0)
-			return DWARF_CB_ABORT;
+		ret = call_probe_finder(in_die, pf);
 	}
 
-	return DWARF_CB_OK;
+	return ret;
 }
 
+/* Callback parameter with return value for libdw */
+struct dwarf_callback_param {
+	void *data;
+	int retval;
+};
+
 /* Search function from function name */
 static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 {
@@ -996,14 +993,10 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 			/* TODO: Check the address in this function */
 			param->retval = call_probe_finder(sp_die, pf);
 		}
-	} else {
-		struct dwarf_callback_param _param = {.data = (void *)pf,
-						      .retval = 0};
+	} else
 		/* Inlined function: search instances */
-		dwarf_func_inline_instances(sp_die, probe_point_inline_cb,
-					    &_param);
-		param->retval = _param.retval;
-	}
+		param->retval = die_walk_instances(sp_die,
+					probe_point_inline_cb, (void *)pf);
 
 	return DWARF_CB_ABORT; /* Exit; no same symbol in this CU. */
 }
@@ -1452,16 +1445,14 @@ static int find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 
 static int line_range_inline_cb(Dwarf_Die *in_die, void *data)
 {
-	struct dwarf_callback_param *param = data;
-
-	param->retval = find_line_range_by_line(in_die, param->data);
+	find_line_range_by_line(in_die, data);
 
 	/*
 	 * We have to check all instances of inlined function, because
 	 * some execution paths can be optimized out depends on the
 	 * function argument of instances
 	 */
-	return DWARF_CB_OK;
+	return 0;
 }
 
 /* Search function from function name */
@@ -1489,15 +1480,10 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 		pr_debug("New line range: %d to %d\n", lf->lno_s, lf->lno_e);
 		lr->start = lf->lno_s;
 		lr->end = lf->lno_e;
-		if (dwarf_func_inline(sp_die)) {
-			struct dwarf_callback_param _param;
-			_param.data = (void *)lf;
-			_param.retval = 0;
-			dwarf_func_inline_instances(sp_die,
-						    line_range_inline_cb,
-						    &_param);
-			param->retval = _param.retval;
-		} else
+		if (dwarf_func_inline(sp_die))
+			param->retval = die_walk_instances(sp_die,
+						line_range_inline_cb, lf);
+		else
 			param->retval = find_line_range_by_line(sp_die, lf);
 		return DWARF_CB_ABORT;
 	}
-- 
1.6.2.5

