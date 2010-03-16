Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab0CPV6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:58:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab0CPV61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:58:27 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 10/10] perf probe: Accessing members in data structures
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 16 Mar 2010 18:06:26 -0400
Message-ID: <20100316220626.32050.57552.stgit@localhost6.localdomain6>
In-Reply-To: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
References: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support accessing members in the data structures. With this,
perf-probe accepts data-structure members(IOW, it now accepts
dot '.' and arrow '->' operators) as probe arguemnts.

e.g.

 ./perf probe --add 'schedule:44 rq->curr'

 ./perf probe --add 'vfs_read file->f_op->read file->f_path.dentry'

Note that '>' can be interpreted as redirection in command-line.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

 tools/perf/util/probe-event.c  |   90 +++++++++++++++++++++++++++++++++-
 tools/perf/util/probe-event.h  |   12 ++++-
 tools/perf/util/probe-finder.c |  105 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 201 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 4e3c1ae..64dea6c 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -262,6 +262,49 @@ static void parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 		 pp->lazy_line);
 }
 
+/* Parse perf-probe event argument */
+static void parse_perf_probe_arg(const char *str, struct perf_probe_arg *arg)
+{
+	const char *tmp;
+	struct perf_probe_arg_field **fieldp;
+
+	pr_debug("parsing arg: %s into ", str);
+
+	tmp = strpbrk(str, "-.");
+	if (!is_c_varname(str) || !tmp) {
+		/* A variable, register, symbol or special value */
+		arg->name = xstrdup(str);
+		pr_debug("%s\n", arg->name);
+		return;
+	}
+
+	/* Structure fields */
+	arg->name = xstrndup(str, tmp - str);
+	pr_debug("%s, ", arg->name);
+	fieldp = &arg->field;
+
+	do {
+		*fieldp = xzalloc(sizeof(struct perf_probe_arg_field));
+		if (*tmp == '.') {
+			str = tmp + 1;
+			(*fieldp)->ref = false;
+		} else if (tmp[1] == '>') {
+			str = tmp + 2;
+			(*fieldp)->ref = true;
+		} else
+			semantic_error("Argument parse error: %s", str);
+
+		tmp = strpbrk(str, "-.");
+		if (tmp) {
+			(*fieldp)->name = xstrndup(str, tmp - str);
+			pr_debug("%s(%d), ", (*fieldp)->name, (*fieldp)->ref);
+			fieldp = &(*fieldp)->next;
+		}
+	} while (tmp);
+	(*fieldp)->name = xstrdup(str);
+	pr_debug("%s(%d)\n", (*fieldp)->name, (*fieldp)->ref);
+}
+
 /* Parse perf-probe event command */
 void parse_perf_probe_command(const char *cmd, struct perf_probe_event *pev)
 {
@@ -281,7 +324,7 @@ void parse_perf_probe_command(const char *cmd, struct perf_probe_event *pev)
 	pev->nargs = argc - 1;
 	pev->args = xzalloc(sizeof(struct perf_probe_arg) * pev->nargs);
 	for (i = 0; i < pev->nargs; i++) {
-		pev->args[i].name = xstrdup(argv[i + 1]);
+		parse_perf_probe_arg(argv[i + 1], &pev->args[i]);
 		if (is_c_varname(pev->args[i].name) && pev->point.retprobe)
 			semantic_error("You can't specify local variable for"
 				       " kretprobe");
@@ -353,6 +396,33 @@ void parse_kprobe_trace_command(const char *cmd, struct kprobe_trace_event *tev)
 	argv_free(argv);
 }
 
+/* Compose only probe arg */
+int synthesize_perf_probe_arg(struct perf_probe_arg *pa, char *buf, size_t len)
+{
+	struct perf_probe_arg_field *field = pa->field;
+	int ret;
+	char *tmp = buf;
+
+	ret = e_snprintf(tmp, len, "%s", pa->name);
+	if (ret <= 0)
+		goto error;
+	tmp += ret;
+	len -= ret;
+
+	while (field) {
+		ret = e_snprintf(tmp, len, "%s%s", field->ref ? "->" : ".",
+				 field->name);
+		if (ret <= 0)
+			goto error;
+		tmp += ret;
+		len -= ret;
+		field = field->next;
+	}
+	return tmp - buf;
+error:
+	die("Failed to synthesize perf probe argument: %s", strerror(-ret));
+}
+
 /* Compose only probe point (not argument) */
 static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
 {
@@ -563,6 +633,7 @@ void convert_to_perf_probe_event(struct kprobe_trace_event *tev,
 void clear_perf_probe_event(struct perf_probe_event *pev)
 {
 	struct perf_probe_point *pp = &pev->point;
+	struct perf_probe_arg_field *field, *next;
 	int i;
 
 	if (pev->event)
@@ -575,9 +646,18 @@ void clear_perf_probe_event(struct perf_probe_event *pev)
 		free(pp->function);
 	if (pp->lazy_line)
 		free(pp->lazy_line);
-	for (i = 0; i < pev->nargs; i++)
+	for (i = 0; i < pev->nargs; i++) {
 		if (pev->args[i].name)
 			free(pev->args[i].name);
+		field = pev->args[i].field;
+		while (field) {
+			next = field->next;
+			if (field->name)
+				free(field->name);
+			free(field);
+			field = next;
+		}
+	}
 	if (pev->args)
 		free(pev->args);
 	memset(pev, 0, sizeof(*pev));
@@ -682,8 +762,10 @@ static void show_perf_probe_event(struct perf_probe_event *pev)
 
 	if (pev->nargs > 0) {
 		printf(" with");
-		for (i = 0; i < pev->nargs; i++)
-			printf(" %s", pev->args[i].name);
+		for (i = 0; i < pev->nargs; i++) {
+			synthesize_perf_probe_arg(&pev->args[i], buf, 128);
+			printf(" %s", buf);
+		}
 	}
 	printf(")\n");
 	free(place);
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 2a2f0a2..cd308b0 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -45,9 +45,17 @@ struct perf_probe_point {
 	bool		retprobe;	/* Return probe flag */
 };
 
+/* Perf probe probing argument field chain */
+struct perf_probe_arg_field {
+	struct perf_probe_arg_field	*next;	/* Next field */
+	char				*name;	/* Name of the field */
+	bool				ref;	/* Referencing flag */
+};
+
 /* Perf probe probing argument */
 struct perf_probe_arg {
-	char		*name;		/* Argument name */
+	char				*name;	/* Argument name */
+	struct perf_probe_arg_field	*field;	/* Structure fields */
 };
 
 /* Perf probe probing event (point + arg) */
@@ -86,6 +94,8 @@ extern void parse_kprobe_trace_command(const char *cmd,
 /* Events to command string */
 extern char *synthesize_perf_probe_command(struct perf_probe_event *pev);
 extern char *synthesize_kprobe_trace_command(struct kprobe_trace_event *tev);
+extern int synthesize_perf_probe_arg(struct perf_probe_arg *pa, char *buf,
+				     size_t len);
 
 /* Check the perf_probe_event needs debuginfo */
 extern bool perf_probe_event_need_dwarf(struct perf_probe_event *pev);
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index e02b607..db52ec2 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -206,6 +206,28 @@ static Dwarf_Addr die_get_entrypc(Dwarf_Die *dw_die)
 	return epc;
 }
 
+/* Get type die, but skip qualifiers and typedef */
+static Dwarf_Die *die_get_real_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem)
+{
+	Dwarf_Attribute attr;
+	int tag;
+
+	do {
+		if (dwarf_attr(vr_die, DW_AT_type, &attr) == NULL ||
+		    dwarf_formref_die(&attr, die_mem) == NULL)
+			return NULL;
+
+		tag = dwarf_tag(die_mem);
+		vr_die = die_mem;
+	} while (tag == DW_TAG_const_type ||
+		 tag == DW_TAG_restrict_type ||
+		 tag == DW_TAG_volatile_type ||
+		 tag == DW_TAG_shared_type ||
+		 tag == DW_TAG_typedef);
+
+	return die_mem;
+}
+
 /* Return values for die_find callbacks */
 enum {
 	DIE_FIND_CB_FOUND = 0,		/* End of Search */
@@ -314,6 +336,25 @@ static Dwarf_Die *die_find_variable(Dwarf_Die *sp_die, const char *name,
 			      die_mem);
 }
 
+static int __die_find_member_cb(Dwarf_Die *die_mem, void *data)
+{
+	const char *name = data;
+
+	if ((dwarf_tag(die_mem) == DW_TAG_member) &&
+	    (die_compare_name(die_mem, name) == 0))
+		return DIE_FIND_CB_FOUND;
+
+	return DIE_FIND_CB_SIBLING;
+}
+
+/* Find a member called 'name' */
+static Dwarf_Die *die_find_member(Dwarf_Die *st_die, const char *name,
+				  Dwarf_Die *die_mem)
+{
+	return die_find_child(st_die, __die_find_member_cb, (void *)name,
+			      die_mem);
+}
+
 /*
  * Probe finder related functions
  */
@@ -363,6 +404,62 @@ static void convert_location(Dwarf_Op *op, struct probe_finder *pf)
 	}
 }
 
+static void convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
+				    struct perf_probe_arg_field *field,
+				    struct kprobe_trace_arg_ref **ref_ptr)
+{
+	struct kprobe_trace_arg_ref *ref = *ref_ptr;
+	Dwarf_Attribute attr;
+	Dwarf_Die member;
+	Dwarf_Die type;
+	Dwarf_Word offs;
+
+	pr_debug("converting %s in %s\n", field->name, varname);
+	if (die_get_real_type(vr_die, &type) == NULL)
+		die("Failed to get a type information of %s.", varname);
+
+	/* Check the pointer and dereference */
+	if (dwarf_tag(&type) == DW_TAG_pointer_type) {
+		if (!field->ref)
+			die("Semantic error: %s must be referred by '->'",
+			    field->name);
+		/* Get the type pointed by this pointer */
+		if (die_get_real_type(&type, &type) == NULL)
+			die("Failed to get a type information of %s.", varname);
+
+		ref = xzalloc(sizeof(struct kprobe_trace_arg_ref));
+		if (*ref_ptr)
+			(*ref_ptr)->next = ref;
+		else
+			*ref_ptr = ref;
+	} else {
+		if (field->ref)
+			die("Semantic error: %s must be referred by '.'",
+			    field->name);
+		if (!ref)
+			die("Structure on a register is not supported yet.");
+	}
+
+	/* Verify it is a data structure  */
+	if (dwarf_tag(&type) != DW_TAG_structure_type)
+		die("%s is not a data structure.", varname);
+
+	if (die_find_member(&type, field->name, &member) == NULL)
+		die("%s(tyep:%s) has no member %s.", varname,
+		    dwarf_diename(&type), field->name);
+
+	/* Get the offset of the field */
+	if (dwarf_attr(&member, DW_AT_data_member_location, &attr) == NULL ||
+	    dwarf_formudata(&attr, &offs) != 0)
+		die("Failed to get the offset of %s.", field->name);
+	ref->offset += (long)offs;
+
+	/* Converting next field */
+	if (field->next)
+		convert_variable_fields(&member, field->name, field->next,
+					&ref);
+}
+
 /* Show a variables in kprobe event format */
 static void convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 {
@@ -379,6 +476,10 @@ static void convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 		goto error;
 
 	convert_location(expr, pf);
+
+	if (pf->pvar->field)
+		convert_variable_fields(vr_die, pf->pvar->name,
+					pf->pvar->field, &pf->tvar->ref);
 	/* *expr will be cached in libdw. Don't free it. */
 	return ;
 error:
@@ -391,13 +492,15 @@ error:
 static void find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
 	Dwarf_Die vr_die;
+	char buf[128];
 
 	/* TODO: Support struct members and arrays */
 	if (!is_c_varname(pf->pvar->name)) {
 		/* Copy raw parameters */
 		pf->tvar->value = xstrdup(pf->pvar->name);
 	} else {
-		pf->tvar->name = xstrdup(pf->pvar->name);
+		synthesize_perf_probe_arg(pf->pvar, buf, 128);
+		pf->tvar->name = xstrdup(buf);
 		pr_debug("Searching '%s' variable in context.\n",
 			 pf->pvar->name);
 		/* Search child die for local variables and parameters. */


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
