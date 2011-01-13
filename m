Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1AMMvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 07:51:53 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39151 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab1AMMvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 07:51:47 -0500
X-AuditID: b753bd60-a1557ba00000044b-7c-4d2ef55f484c
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -perf/perf/core 4/6] perf: Add strfilter for general purpose
	string filter
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Jan 2011 21:46:17 +0900
Message-ID: <20110113124617.22426.25293.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add strfilter for general purpose string filter.
Every filter rules are descrived by glob matching pattern
and '!' prefix which means Logical NOT.
A strfilter consists of those filter rules connected
with '&' and '|'. A set of rules can be folded by using
'(' and ')'. It also accepts spaces around rules and those
operators.

Format:
<rule> ::= <glob-exp> | "!" <rule> | <rule> <op> <rule> | "(" <rule> ")"
<op> ::= "&" | "|"

e.g.
 "(add* | del*) & *timer" filter rules pass strings which
 start with add or del and end with timer.

This will be used by perf probe --filter.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
---

 tools/perf/Makefile         |    2 
 tools/perf/util/strfilter.c |  185 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/strfilter.h |   36 ++++++++
 3 files changed, 223 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/util/strfilter.c
 create mode 100644 tools/perf/util/strfilter.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2b5387d..50dcfb1 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -411,6 +411,7 @@ LIB_H += util/help.h
 LIB_H += util/session.h
 LIB_H += util/strbuf.h
 LIB_H += util/strlist.h
+LIB_H += util/strfilter.h
 LIB_H += util/svghelper.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
@@ -450,6 +451,7 @@ LIB_OBJS += $(OUTPUT)util/quote.o
 LIB_OBJS += $(OUTPUT)util/strbuf.o
 LIB_OBJS += $(OUTPUT)util/string.o
 LIB_OBJS += $(OUTPUT)util/strlist.o
+LIB_OBJS += $(OUTPUT)util/strfilter.o
 LIB_OBJS += $(OUTPUT)util/usage.o
 LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
diff --git a/tools/perf/util/strfilter.c b/tools/perf/util/strfilter.c
new file mode 100644
index 0000000..877146b
--- /dev/null
+++ b/tools/perf/util/strfilter.c
@@ -0,0 +1,185 @@
+#include <ctype.h>
+#include "util.h"
+#include "string.h"
+#include "strfilter.h"
+
+/* Operators */
+static const char *OP_and	= "&";	/* Logical AND */
+static const char *OP_or	= "|";	/* Logical OR */
+static const char *OP_not	= "!";	/* Logical NOT */
+
+#define is_operator(c)	((c) == '|' || (c) == '&' || (c) == '!')
+#define is_separator(c)	(is_operator(c) || (c) == '(' || (c) == ')')
+
+void strfilter__delete(struct strfilter *self)
+{
+	if (self) {
+		if (self->p && !is_operator(*self->p))
+			free((char *)self->p);
+		strfilter__delete(self->l);
+		strfilter__delete(self->r);
+		free(self);
+	}
+}
+
+static const char *get_token(const char *s, const char **e)
+{
+	const char *p;
+
+	while (isspace(*s))	/* Skip spaces */
+		s++;
+
+	if (*s == '\0') {
+		p = s;
+		goto end;
+	}
+
+	p = s + 1;
+	if (!is_separator(*s)) {
+		/* End search */
+retry:
+		while (*p && !is_separator(*p) && !isspace(*p))
+			p++;
+		/* Escape and special case: '!' is also used in glob pattern */
+		if (*(p - 1) == '\\' || (*p == '!' && *(p - 1) == '[')) {
+			p++;
+			goto retry;
+		}
+	}
+end:
+	*e = p;
+	return s;
+}
+
+static struct strfilter *strfilter__alloc(const char *op,
+					  struct strfilter *l,
+					  struct strfilter *r)
+{
+	struct strfilter *ret = zalloc(sizeof(struct strfilter));
+
+	if (ret) {
+		ret->p = op;
+		ret->l = l;
+		ret->r = r;
+	}
+
+	return ret;
+}
+
+static struct strfilter *__strfilter__new(const char *s, const char **ep)
+{
+	struct strfilter root, *cur, *last_op;
+	const char *e;
+
+	memset(&root, 0, sizeof(root));
+	last_op = cur = &root;
+
+	s = get_token(s, &e);
+	while (*s != '\0' && *s != ')') {
+		switch (*s) {
+		case '&':	/* Exchg last OP->r with AND */
+			if (!cur->r || !last_op->r)
+				goto error;
+			cur = strfilter__alloc(OP_and, last_op->r, NULL);
+			last_op->r = cur;
+			last_op = cur;
+			break;
+		case '|':	/* Exchg the root with OR */
+			if (!cur->r || !root.r)
+				goto error;
+			cur = strfilter__alloc(OP_or, root.r, NULL);
+			root.r = cur;
+			last_op = cur;
+			break;
+		case '!':	/* Add NOT as a leaf node */
+			if (cur->r)
+				goto error;
+			cur->r = strfilter__alloc(OP_not, NULL, NULL);
+			cur = cur->r;
+			break;
+		case '(':	/* Recursively parses inside the parenthesis */
+			if (cur->r)
+				goto error;
+			cur->r = __strfilter__new(s + 1, &s);
+			if (!s)
+				goto nomem;
+			if (!cur->r || *s != ')')
+				goto error;
+			e = s + 1;
+			break;
+		default:
+			if (cur->r)
+				goto error;
+			cur->r = strfilter__alloc(strndup(s, e - s),
+						  NULL, NULL);
+			if (!cur->r || !cur->r->p)
+				goto nomem;
+		}
+		if (!cur)
+			goto nomem;
+		s = get_token(e, &e);
+	}
+	if (!cur->r)
+		goto error;
+	*ep = s;
+	return root.r;
+nomem:
+	s = NULL;
+error:
+	*ep = s;
+	strfilter__delete(root.r);
+	return NULL;
+}
+
+/*
+ * Parse filter rule and return new strfilter.
+ * Return NULL if fail, and *ep == NULL if memory allocation failed.
+ */
+struct strfilter *strfilter__new(const char *rules, const char **err)
+{
+	struct strfilter *ret;
+	const char *ep;
+
+	ret = __strfilter__new(rules, &ep);
+	if (!ret || *ep != '\0') {
+		if (err)
+			*err = ep;
+		strfilter__delete(ret);
+		ret = NULL;
+	}
+
+	return ret;
+}
+
+struct strfilter *strfilter__new_and(struct strfilter *f1,
+				     struct strfilter *f2)
+{
+	return strfilter__alloc(OP_and, f1, f2);
+}
+
+struct strfilter *strfilter__new_or(struct strfilter *f1,
+				    struct strfilter *f2)
+{
+	return strfilter__alloc(OP_or, f1, f2);
+}
+
+/* Return true if STR matches the filter */
+bool strfilter__match(struct strfilter *self, const char *str)
+{
+	if (!self || !self->p)
+		return false;
+
+	switch (*self->p) {
+	case '|':	/* OR */
+		return strfilter__match(self->l, str) ||
+			strfilter__match(self->r, str);
+	case '&':	/* AND */
+		return strfilter__match(self->l, str) &&
+			strfilter__match(self->r, str);
+	case '!':	/* NOT */
+		return !strfilter__match(self->r, str);
+	default:
+		return strglobmatch(str, self->p);
+	}
+}
+
diff --git a/tools/perf/util/strfilter.h b/tools/perf/util/strfilter.h
new file mode 100644
index 0000000..52ca0bd
--- /dev/null
+++ b/tools/perf/util/strfilter.h
@@ -0,0 +1,36 @@
+#ifndef __PERF_STRFILTER_H
+#define __PERF_STRFILTER_H
+/* General purpose glob matching filter */
+
+#include <linux/list.h>
+#include <stdbool.h>
+
+/* String filter */
+struct strfilter {
+	struct strfilter *l;	/* Tree left branche (for &,|) */
+	struct strfilter *r;	/* Tree right branche (for !,&,|) */
+	const char *p;		/* Operator or rule */
+};
+
+/*
+ * Parse RULES and return new strfilter. If ERR is not NULL, *ERR will
+*  indicate where the parse error occured.
+ */
+struct strfilter *strfilter__new(const char *rules, const char **err);
+
+/* Make a new filter which F1 & F2 (and it holds F1 and F2) */
+struct strfilter *strfilter__new_and(struct strfilter *f1,
+				     struct strfilter *f2);
+
+/* Make a new filter which F1 | F2 (and it holds F1 and F2) */
+struct strfilter *strfilter__new_or(struct strfilter *f1,
+				    struct strfilter *f2);
+
+/* Match the STR and filter rule. Return true if the str match the rule */
+bool strfilter__match(struct strfilter *self, const char *str);
+
+/* Delete the filter */
+void strfilter__delete(struct strfilter *self);
+
+#endif
+

