Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab0EQTbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:31:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32898 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab0EQTbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:31:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/4] perf options: Introduce OPT_UINTEGER
Date: Mon, 17 May 2010 16:31:15 -0300
Message-Id: <1274124678-24781-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274124678-24781-1-git-send-email-acme@infradead.org>
References: <1274124678-24781-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

For unsigned int options to be parsed, next patches will make use of it.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-options.c |   22 ++++++++++++++++++++--
 tools/perf/util/parse-options.h |    2 ++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index b05d51d..36d955e 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -59,6 +59,7 @@ static int get_value(struct parse_opt_ctx_t *p,
 		case OPTION_GROUP:
 		case OPTION_STRING:
 		case OPTION_INTEGER:
+		case OPTION_UINTEGER:
 		case OPTION_LONG:
 		case OPTION_U64:
 		default:
@@ -126,6 +127,22 @@ static int get_value(struct parse_opt_ctx_t *p,
 			return opterror(opt, "expects a numerical value", flags);
 		return 0;
 
+	case OPTION_UINTEGER:
+		if (unset) {
+			*(unsigned int *)opt->value = 0;
+			return 0;
+		}
+		if (opt->flags & PARSE_OPT_OPTARG && !p->opt) {
+			*(unsigned int *)opt->value = opt->defval;
+			return 0;
+		}
+		if (get_arg(p, opt, flags, &arg))
+			return -1;
+		*(unsigned int *)opt->value = strtol(arg, (char **)&s, 10);
+		if (*s)
+			return opterror(opt, "expects a numerical value", flags);
+		return 0;
+
 	case OPTION_LONG:
 		if (unset) {
 			*(long *)opt->value = 0;
@@ -463,7 +480,10 @@ int usage_with_options_internal(const char * const *usagestr,
 		switch (opts->type) {
 		case OPTION_ARGUMENT:
 			break;
+		case OPTION_LONG:
+		case OPTION_U64:
 		case OPTION_INTEGER:
+		case OPTION_UINTEGER:
 			if (opts->flags & PARSE_OPT_OPTARG)
 				if (opts->long_name)
 					pos += fprintf(stderr, "[=<n>]");
@@ -503,8 +523,6 @@ int usage_with_options_internal(const char * const *usagestr,
 		case OPTION_INCR:
 		case OPTION_SET_INT:
 		case OPTION_SET_PTR:
-		case OPTION_LONG:
-		case OPTION_U64:
 			break;
 		}
 
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index e301e96..c6aa4ee 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -18,6 +18,7 @@ enum parse_opt_type {
 	OPTION_LONG,
 	OPTION_CALLBACK,
 	OPTION_U64,
+	OPTION_UINTEGER,
 };
 
 enum parse_opt_flags {
@@ -101,6 +102,7 @@ struct option {
 #define OPT_SET_INT(s, l, v, h, i)  { .type = OPTION_SET_INT, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (i) }
 #define OPT_SET_PTR(s, l, v, h, p)  { .type = OPTION_SET_PTR, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (p) }
 #define OPT_INTEGER(s, l, v, h)     { .type = OPTION_INTEGER, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
+#define OPT_UINTEGER(s, l, v, h)    { .type = OPTION_UINTEGER, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
 #define OPT_LONG(s, l, v, h)        { .type = OPTION_LONG, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
 #define OPT_U64(s, l, v, h)         { .type = OPTION_U64, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
 #define OPT_STRING(s, l, v, a, h)   { .type = OPTION_STRING,  .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h) }
-- 
1.6.2.5

