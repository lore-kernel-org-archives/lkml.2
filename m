Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504Ab2JaKPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:15:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51423 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932992Ab2JaKPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:15:30 -0400
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] dynamic_debug: Fix vpr_<foo> logging styles
Date: Wed, 31 Oct 2012 03:15:24 -0700
Message-Id: <0d8dbdf2ae7d44c2581ee1e8ff1e87f00ac52496.1351678468.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vpr_info_dq should be a function and vpr_info should have
a do {} while (0)

Add missing newlines to pr_<level>s.

Miscellaneous neatening too.
braces, coalescing formats, alignments, etc...

Signed-off-by: Joe Perches <joe@perches.com>
---
 lib/dynamic_debug.c |  118 +++++++++++++++++++++++++++------------------------
 1 files changed, 62 insertions(+), 56 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 1db1fc6..ac7d277 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -59,7 +59,7 @@ struct ddebug_iter {
 
 static DEFINE_MUTEX(ddebug_lock);
 static LIST_HEAD(ddebug_tables);
-static int verbose = 0;
+static int verbose;
 module_param(verbose, int, 0644);
 
 /* Return the path relative to source root */
@@ -100,24 +100,32 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
 	return buf;
 }
 
-#define vpr_info(fmt, ...) \
-	if (verbose) do { pr_info(fmt, ##__VA_ARGS__); } while (0)
-
-#define vpr_info_dq(q, msg)					\
+#define vpr_info(fmt, ...)					\
 do {								\
-	/* trim last char off format print */			\
-	vpr_info("%s: func=\"%s\" file=\"%s\" "			\
-		"module=\"%s\" format=\"%.*s\" "		\
-		"lineno=%u-%u",					\
-		msg,						\
-		q->function ? q->function : "",			\
-		q->filename ? q->filename : "",			\
-		q->module ? q->module : "",			\
-		(int)(q->format ? strlen(q->format) - 1 : 0),	\
-		q->format ? q->format : "",			\
-		q->first_lineno, q->last_lineno);		\
+	if (verbose)						\
+		pr_info(fmt, ##__VA_ARGS__);			\
 } while (0)
 
+static void vpr_info_dq(const struct ddebug_query *query, const char *msg)
+{
+	/* trim any trailing newlines */
+	int fmtlen = 0;
+
+	if (query->format) {
+		fmtlen = strlen(query->format);
+		while (fmtlen && query->format[fmtlen - 1] == '\n')
+			fmtlen--;
+	}
+
+	vpr_info("%s: func=\"%s\" file=\"%s\" module=\"%s\" format=\"%.*s\" lineno=%u-%u\n",
+		 msg,
+		 query->function ? query->function : "",
+		 query->filename ? query->filename : "",
+		 query->module ? query->module : "",
+		 fmtlen, query->format ? query->format : "",
+		 query->first_lineno, query->last_lineno);
+}
+
 /*
  * Search the tables for _ddebug's which match the given `query' and
  * apply the `flags' and `mask' to them.  Returns number of matching
@@ -141,7 +149,7 @@ static int ddebug_change(const struct ddebug_query *query,
 		if (query->module && strcmp(query->module, dt->mod_name))
 			continue;
 
-		for (i = 0 ; i < dt->num_ddebugs ; i++) {
+		for (i = 0; i < dt->num_ddebugs; i++) {
 			struct _ddebug *dp = &dt->ddebugs[i];
 
 			/* match against the source filename */
@@ -176,10 +184,10 @@ static int ddebug_change(const struct ddebug_query *query,
 				continue;
 			dp->flags = newflags;
 			vpr_info("changed %s:%d [%s]%s =%s\n",
-				trim_prefix(dp->filename), dp->lineno,
-				dt->mod_name, dp->function,
-				ddebug_describe_flags(dp, flagbuf,
-						sizeof(flagbuf)));
+				 trim_prefix(dp->filename), dp->lineno,
+				 dt->mod_name, dp->function,
+				 ddebug_describe_flags(dp, flagbuf,
+						       sizeof(flagbuf)));
 		}
 	}
 	mutex_unlock(&ddebug_lock);
@@ -213,12 +221,12 @@ static int ddebug_tokenize(char *buf, char *words[], int maxwords)
 		/* find `end' of word, whitespace separated or quoted */
 		if (*buf == '"' || *buf == '\'') {
 			int quote = *buf++;
-			for (end = buf ; *end && *end != quote ; end++)
+			for (end = buf; *end && *end != quote; end++)
 				;
 			if (!*end)
 				return -EINVAL;	/* unclosed quote */
 		} else {
-			for (end = buf ; *end && !isspace(*end) ; end++)
+			for (end = buf; *end && !isspace(*end); end++)
 				;
 			BUG_ON(end == buf);
 		}
@@ -235,7 +243,7 @@ static int ddebug_tokenize(char *buf, char *words[], int maxwords)
 	if (verbose) {
 		int i;
 		pr_info("split into words:");
-		for (i = 0 ; i < nwords ; i++)
+		for (i = 0; i < nwords; i++)
 			pr_cont(" \"%s\"", words[i]);
 		pr_cont("\n");
 	}
@@ -286,11 +294,11 @@ static char *unescape(char *str)
 				in += 2;
 				continue;
 			} else if (isodigit(in[1]) &&
-			         isodigit(in[2]) &&
-			         isodigit(in[3])) {
-				*out++ = ((in[1] - '0')<<6) |
-				          ((in[2] - '0')<<3) |
-				          (in[3] - '0');
+				   isodigit(in[2]) &&
+				   isodigit(in[3])) {
+				*out++ = (((in[1] - '0') << 6) |
+					  ((in[2] - '0') << 3) |
+					  (in[3] - '0'));
 				in += 4;
 				continue;
 			}
@@ -308,8 +316,8 @@ static int check_set(const char **dest, char *src, char *name)
 
 	if (*dest) {
 		rc = -EINVAL;
-		pr_err("match-spec:%s val:%s overridden by %s",
-			name, *dest, src);
+		pr_err("match-spec:%s val:%s overridden by %s\n",
+		       name, *dest, src);
 	}
 	*dest = src;
 	return rc;
@@ -345,17 +353,17 @@ static int ddebug_parse_query(char *words[], int nwords,
 		/* support $modname.dyndbg=<multiple queries> */
 		query->module = modname;
 
-	for (i = 0 ; i < nwords ; i += 2) {
-		if (!strcmp(words[i], "func"))
+	for (i = 0; i < nwords; i += 2) {
+		if (!strcmp(words[i], "func")) {
 			rc = check_set(&query->function, words[i+1], "func");
-		else if (!strcmp(words[i], "file"))
+		} else if (!strcmp(words[i], "file")) {
 			rc = check_set(&query->filename, words[i+1], "file");
-		else if (!strcmp(words[i], "module"))
+		} else if (!strcmp(words[i], "module")) {
 			rc = check_set(&query->module, words[i+1], "module");
-		else if (!strcmp(words[i], "format"))
+		} else if (!strcmp(words[i], "format")) {
 			rc = check_set(&query->format, unescape(words[i+1]),
-				"format");
-		else if (!strcmp(words[i], "line")) {
+				       "format");
+		} else if (!strcmp(words[i], "line")) {
 			char *first = words[i+1];
 			char *last = strchr(first, '-');
 			if (query->first_lineno || query->last_lineno) {
@@ -410,7 +418,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	}
 	vpr_info("op='%c'\n", op);
 
-	for ( ; *str ; ++str) {
+	for (; *str ; ++str) {
 		for (i = ARRAY_SIZE(opt_array) - 1; i >= 0; i--) {
 			if (*str == opt_array[i].opt_char) {
 				flags |= opt_array[i].flag;
@@ -459,7 +467,7 @@ static int ddebug_exec_query(char *query_string, const char *modname)
 
 	/* actually go and implement the change */
 	nfound = ddebug_change(&query, flags, mask);
-	vpr_info_dq((&query), (nfound) ? "applied" : "no-match");
+	vpr_info_dq(&query, nfound ? "applied" : "no-match");
 
 	return nfound;
 }
@@ -488,8 +496,9 @@ static int ddebug_exec_queries(char *query, const char *modname)
 		if (rc < 0) {
 			errs++;
 			exitcode = rc;
-		} else
+		} else {
 			nfound += rc;
+		}
 		i++;
 	}
 	vpr_info("processed %d queries, with %d matches, %d errs\n",
@@ -765,7 +774,7 @@ static void *ddebug_proc_next(struct seq_file *m, void *p, loff_t *pos)
 	struct _ddebug *dp;
 
 	vpr_info("called m=%p p=%p *pos=%lld\n",
-		m, p, (unsigned long long)*pos);
+		 m, p, (unsigned long long)*pos);
 
 	if (p == SEQ_START_TOKEN)
 		dp = ddebug_iter_first(iter);
@@ -791,14 +800,14 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 
 	if (p == SEQ_START_TOKEN) {
 		seq_puts(m,
-			"# filename:lineno [module]function flags format\n");
+			 "# filename:lineno [module]function flags format\n");
 		return 0;
 	}
 
 	seq_printf(m, "%s:%u [%s]%s =%s \"",
-		trim_prefix(dp->filename), dp->lineno,
-		iter->table->mod_name, dp->function,
-		ddebug_describe_flags(dp, flagsbuf, sizeof(flagsbuf)));
+		   trim_prefix(dp->filename), dp->lineno,
+		   iter->table->mod_name, dp->function,
+		   ddebug_describe_flags(dp, flagsbuf, sizeof(flagsbuf)));
 	seq_escape(m, dp->format, "\t\r\n\"");
 	seq_puts(m, "\"\n");
 
@@ -845,7 +854,7 @@ static int ddebug_proc_open(struct inode *inode, struct file *file)
 		kfree(iter);
 		return err;
 	}
-	((struct seq_file *) file->private_data)->private = iter;
+	((struct seq_file *)file->private_data)->private = iter;
 	return 0;
 }
 
@@ -1002,8 +1011,7 @@ static int __init dynamic_debug_init(void)
 	int verbose_bytes = 0;
 
 	if (__start___verbose == __stop___verbose) {
-		pr_warn("_ddebug table is empty in a "
-			"CONFIG_DYNAMIC_DEBUG build");
+		pr_warn("_ddebug table is empty in a CONFIG_DYNAMIC_DEBUG build\n");
 		return 1;
 	}
 	iter = __start___verbose;
@@ -1030,18 +1038,16 @@ static int __init dynamic_debug_init(void)
 		goto out_err;
 
 	ddebug_init_success = 1;
-	vpr_info("%d modules, %d entries and %d bytes in ddebug tables,"
-		" %d bytes in (readonly) verbose section\n",
-		modct, entries, (int)( modct * sizeof(struct ddebug_table)),
-		verbose_bytes + (int)(__stop___verbose - __start___verbose));
+	vpr_info("%d modules, %d entries and %d bytes in ddebug tables, %d bytes in (readonly) verbose section\n",
+		 modct, entries, (int)(modct * sizeof(struct ddebug_table)),
+		 verbose_bytes + (int)(__stop___verbose - __start___verbose));
 
 	/* apply ddebug_query boot param, dont unload tables on err */
 	if (ddebug_setup_string[0] != '\0') {
-		pr_warn("ddebug_query param name is deprecated,"
-			" change it to dyndbg\n");
+		pr_warn("ddebug_query param name is deprecated, change it to dyndbg\n");
 		ret = ddebug_exec_queries(ddebug_setup_string, NULL);
 		if (ret < 0)
-			pr_warn("Invalid ddebug boot param %s",
+			pr_warn("Invalid ddebug boot param %s\n",
 				ddebug_setup_string);
 		else
 			pr_info("%d changes by ddebug_query\n", ret);
-- 
1.7.8.112.g3fd21

