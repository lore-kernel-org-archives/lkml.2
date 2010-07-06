Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0GFBEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 21:04:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41803 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0GFBEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 21:04:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/5] perf probe: Support tracing an entry of array
Date: Mon,  5 Jul 2010 22:04:35 -0300
Message-Id: <1278378276-25872-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1278378276-25872-1-git-send-email-acme@infradead.org>
References: <1278378276-25872-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Add array-entry tracing support to perf probe. This enables to trace an entry
of array which is indexed by constant value, e.g. array[0].

For example:

  $ perf probe -a 'bio_split bi->bi_io_vec[0]'

Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100519195742.2885.5344.stgit@localhost6.localdomain6>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-probe.txt |    2 +-
 tools/perf/util/probe-event.c           |   56 +++++++++++++++++++++---------
 tools/perf/util/probe-event.h           |    1 +
 tools/perf/util/probe-finder.c          |   48 +++++++++++++++++++++++---
 4 files changed, 83 insertions(+), 24 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 394016d..27d52da 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -94,7 +94,7 @@ Each probe argument follows below syntax.
 
  [NAME=]LOCALVAR|$retval|%REG|@SYMBOL[:TYPE]
 
-'NAME' specifies the name of this argument (optional). You can use the name of local variable, local data structure member (e.g. var->field, var.field2), or kprobe-tracer argument format (e.g. $retval, %ax, etc). Note that the name of this argument will be set as the last member name if you specify a local data structure member (e.g. field2 for 'var->field1.field2'.)
+'NAME' specifies the name of this argument (optional). You can use the name of local variable, local data structure member (e.g. var->field, var.field2), local array with fixed index (e.g. array[1], var->array[0], var->pointer[2]), or kprobe-tracer argument format (e.g. $retval, %ax, etc). Note that the name of this argument will be set as the last member name if you specify a local data structure member (e.g. field2 for 'var->field1.field2'.)
 'TYPE' casts the type of this argument (optional). If omitted, perf probe automatically set the type based on debuginfo. You can specify 'string' type only for the local variable or structure member which is an array of or a pointer to 'char' or 'unsigned char' type.
 
 LINE SYNTAX
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 914c670..351baa9 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -557,7 +557,7 @@ static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 /* Parse perf-probe event argument */
 static int parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
 {
-	char *tmp;
+	char *tmp, *goodname;
 	struct perf_probe_arg_field **fieldp;
 
 	pr_debug("parsing arg: %s into ", str);
@@ -580,7 +580,7 @@ static int parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
 		pr_debug("type:%s ", arg->type);
 	}
 
-	tmp = strpbrk(str, "-.");
+	tmp = strpbrk(str, "-.[");
 	if (!is_c_varname(str) || !tmp) {
 		/* A variable, register, symbol or special value */
 		arg->var = strdup(str);
@@ -590,10 +590,11 @@ static int parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
 		return 0;
 	}
 
-	/* Structure fields */
+	/* Structure fields or array element */
 	arg->var = strndup(str, tmp - str);
 	if (arg->var == NULL)
 		return -ENOMEM;
+	goodname = arg->var;
 	pr_debug("%s, ", arg->var);
 	fieldp = &arg->field;
 
@@ -601,22 +602,38 @@ static int parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
 		*fieldp = zalloc(sizeof(struct perf_probe_arg_field));
 		if (*fieldp == NULL)
 			return -ENOMEM;
-		if (*tmp == '.') {
-			str = tmp + 1;
-			(*fieldp)->ref = false;
-		} else if (tmp[1] == '>') {
-			str = tmp + 2;
+		if (*tmp == '[') {	/* Array */
+			str = tmp;
+			(*fieldp)->index = strtol(str + 1, &tmp, 0);
 			(*fieldp)->ref = true;
-		} else {
-			semantic_error("Argument parse error: %s\n", str);
-			return -EINVAL;
+			if (*tmp != ']' || tmp == str + 1) {
+				semantic_error("Array index must be a"
+						" number.\n");
+				return -EINVAL;
+			}
+			tmp++;
+			if (*tmp == '\0')
+				tmp = NULL;
+		} else {		/* Structure */
+			if (*tmp == '.') {
+				str = tmp + 1;
+				(*fieldp)->ref = false;
+			} else if (tmp[1] == '>') {
+				str = tmp + 2;
+				(*fieldp)->ref = true;
+			} else {
+				semantic_error("Argument parse error: %s\n",
+					       str);
+				return -EINVAL;
+			}
+			tmp = strpbrk(str, "-.[");
 		}
-
-		tmp = strpbrk(str, "-.");
 		if (tmp) {
 			(*fieldp)->name = strndup(str, tmp - str);
 			if ((*fieldp)->name == NULL)
 				return -ENOMEM;
+			if (*str != '[')
+				goodname = (*fieldp)->name;
 			pr_debug("%s(%d), ", (*fieldp)->name, (*fieldp)->ref);
 			fieldp = &(*fieldp)->next;
 		}
@@ -624,11 +641,13 @@ static int parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
 	(*fieldp)->name = strdup(str);
 	if ((*fieldp)->name == NULL)
 		return -ENOMEM;
+	if (*str != '[')
+		goodname = (*fieldp)->name;
 	pr_debug("%s(%d)\n", (*fieldp)->name, (*fieldp)->ref);
 
-	/* If no name is specified, set the last field name */
+	/* If no name is specified, set the last field name (not array index)*/
 	if (!arg->name) {
-		arg->name = strdup((*fieldp)->name);
+		arg->name = strdup(goodname);
 		if (arg->name == NULL)
 			return -ENOMEM;
 	}
@@ -776,8 +795,11 @@ int synthesize_perf_probe_arg(struct perf_probe_arg *pa, char *buf, size_t len)
 	len -= ret;
 
 	while (field) {
-		ret = e_snprintf(tmp, len, "%s%s", field->ref ? "->" : ".",
-				 field->name);
+		if (field->name[0] == '[')
+			ret = e_snprintf(tmp, len, "%s", field->name);
+		else
+			ret = e_snprintf(tmp, len, "%s%s",
+					 field->ref ? "->" : ".", field->name);
 		if (ret <= 0)
 			goto error;
 		tmp += ret;
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index e9db1a2..bc06d3e 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -50,6 +50,7 @@ struct perf_probe_point {
 struct perf_probe_arg_field {
 	struct perf_probe_arg_field	*next;	/* Next field */
 	char				*name;	/* Name of the field */
+	long				index;	/* Array index number */
 	bool				ref;	/* Referencing flag */
 };
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index aaea16b..308664d 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -485,6 +485,9 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 		return -ENOENT;
 	}
 
+	pr_debug("%s type is %s.\n",
+		 dwarf_diename(vr_die), dwarf_diename(&type));
+
 	if (cast && strcmp(cast, "string") == 0) {	/* String type */
 		ret = dwarf_tag(&type);
 		if (ret != DW_TAG_pointer_type &&
@@ -553,16 +556,44 @@ static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 	struct kprobe_trace_arg_ref *ref = *ref_ptr;
 	Dwarf_Die type;
 	Dwarf_Word offs;
-	int ret;
+	int ret, tag;
 
 	pr_debug("converting %s in %s\n", field->name, varname);
 	if (die_get_real_type(vr_die, &type) == NULL) {
 		pr_warning("Failed to get the type of %s.\n", varname);
 		return -ENOENT;
 	}
-
-	/* Check the pointer and dereference */
-	if (dwarf_tag(&type) == DW_TAG_pointer_type) {
+	pr_debug2("Var real type: (%x)\n", (unsigned)dwarf_dieoffset(&type));
+	tag = dwarf_tag(&type);
+
+	if (field->name[0] == '[' &&
+	    (tag == DW_TAG_array_type || tag == DW_TAG_pointer_type)) {
+		if (field->next)
+			/* Save original type for next field */
+			memcpy(die_mem, &type, sizeof(*die_mem));
+		/* Get the type of this array */
+		if (die_get_real_type(&type, &type) == NULL) {
+			pr_warning("Failed to get the type of %s.\n", varname);
+			return -ENOENT;
+		}
+		pr_debug2("Array real type: (%x)\n",
+			 (unsigned)dwarf_dieoffset(&type));
+		if (tag == DW_TAG_pointer_type) {
+			ref = zalloc(sizeof(struct kprobe_trace_arg_ref));
+			if (ref == NULL)
+				return -ENOMEM;
+			if (*ref_ptr)
+				(*ref_ptr)->next = ref;
+			else
+				*ref_ptr = ref;
+		}
+		ref->offset += die_get_byte_size(&type) * field->index;
+		if (!field->next)
+			/* Save vr_die for converting types */
+			memcpy(die_mem, vr_die, sizeof(*die_mem));
+		goto next;
+	} else if (tag == DW_TAG_pointer_type) {
+		/* Check the pointer and dereference */
 		if (!field->ref) {
 			pr_err("Semantic error: %s must be referred by '->'\n",
 			       field->name);
@@ -588,10 +619,15 @@ static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 			*ref_ptr = ref;
 	} else {
 		/* Verify it is a data structure  */
-		if (dwarf_tag(&type) != DW_TAG_structure_type) {
+		if (tag != DW_TAG_structure_type) {
 			pr_warning("%s is not a data structure.\n", varname);
 			return -EINVAL;
 		}
+		if (field->name[0] == '[') {
+			pr_err("Semantic error: %s is not a pointor nor array.",
+			       varname);
+			return -EINVAL;
+		}
 		if (field->ref) {
 			pr_err("Semantic error: %s must be referred by '.'\n",
 			       field->name);
@@ -618,6 +654,7 @@ static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 	}
 	ref->offset += (long)offs;
 
+next:
 	/* Converting next field */
 	if (field->next)
 		return convert_variable_fields(die_mem, field->name,
@@ -667,7 +704,6 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 	char buf[32], *ptr;
 	int ret;
 
-	/* TODO: Support arrays */
 	if (pf->pvar->name)
 		pf->tvar->name = strdup(pf->pvar->name);
 	else {
-- 
1.6.2.5

