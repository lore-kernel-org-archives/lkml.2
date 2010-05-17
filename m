Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab0EQPsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:48:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab0EQPsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:48:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/3] perf options: Introduce OPT_U64
Date: Mon, 17 May 2010 12:47:56 -0300
Message-Id: <1274111278-2838-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274111278-2838-1-git-send-email-acme@infradead.org>
References: <1274111278-2838-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We have things like user_interval (-c/--count) in 'perf record' that
needs this.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-options.c |   18 ++++++++++++++++++
 tools/perf/util/parse-options.h |    2 ++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index ed88764..b05d51d 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -60,6 +60,7 @@ static int get_value(struct parse_opt_ctx_t *p,
 		case OPTION_STRING:
 		case OPTION_INTEGER:
 		case OPTION_LONG:
+		case OPTION_U64:
 		default:
 			break;
 		}
@@ -141,6 +142,22 @@ static int get_value(struct parse_opt_ctx_t *p,
 			return opterror(opt, "expects a numerical value", flags);
 		return 0;
 
+	case OPTION_U64:
+		if (unset) {
+			*(u64 *)opt->value = 0;
+			return 0;
+		}
+		if (opt->flags & PARSE_OPT_OPTARG && !p->opt) {
+			*(u64 *)opt->value = opt->defval;
+			return 0;
+		}
+		if (get_arg(p, opt, flags, &arg))
+			return -1;
+		*(u64 *)opt->value = strtoull(arg, (char **)&s, 10);
+		if (*s)
+			return opterror(opt, "expects a numerical value", flags);
+		return 0;
+
 	case OPTION_END:
 	case OPTION_ARGUMENT:
 	case OPTION_GROUP:
@@ -487,6 +504,7 @@ int usage_with_options_internal(const char * const *usagestr,
 		case OPTION_SET_INT:
 		case OPTION_SET_PTR:
 		case OPTION_LONG:
+		case OPTION_U64:
 			break;
 		}
 
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index b2da725..e301e96 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -17,6 +17,7 @@ enum parse_opt_type {
 	OPTION_INTEGER,
 	OPTION_LONG,
 	OPTION_CALLBACK,
+	OPTION_U64,
 };
 
 enum parse_opt_flags {
@@ -101,6 +102,7 @@ struct option {
 #define OPT_SET_PTR(s, l, v, h, p)  { .type = OPTION_SET_PTR, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (p) }
 #define OPT_INTEGER(s, l, v, h)     { .type = OPTION_INTEGER, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
 #define OPT_LONG(s, l, v, h)        { .type = OPTION_LONG, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
+#define OPT_U64(s, l, v, h)         { .type = OPTION_U64, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
 #define OPT_STRING(s, l, v, a, h)   { .type = OPTION_STRING,  .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h) }
 #define OPT_DATE(s, l, v, h) \
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), .argh = "time", .help = (h), .callback = parse_opt_approxidate_cb }
-- 
1.6.2.5

