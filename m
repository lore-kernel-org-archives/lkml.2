Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab2JDSJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:09:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:39793 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2JDSJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 28/42] perf tools: Long option completion support for each subcommands
Date: Thu,  4 Oct 2012 15:08:28 -0300
Message-Id: <1349374122-27806-29-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Add internal --list-opts option to print all of long option names to
stdout so that it can be used for bash completion engine.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1349191294-6926-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bash_completion      |    9 +++++++--
 tools/perf/util/parse-options.c |    8 ++++++++
 tools/perf/util/parse-options.h |    1 +
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index bef06f0..5c355ab 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -33,8 +33,13 @@ _perf()
 		fi
 	# List possible events for -e option
 	elif [[ $prev == "-e" && "${COMP_WORDS[1]}" == @(record|stat|top) ]]; then
-		cmds=$($cmd list --raw-dump)
-		COMPREPLY=( $( compgen -W '$cmds' -- "$cur" ) )
+		evts=$($cmd list --raw-dump)
+		COMPREPLY=( $( compgen -W '$evts' -- "$cur" ) )
+	# List long option names
+	elif [[ $cur == --* ]];  then
+		subcmd=${COMP_WORDS[1]}
+		opts=$($cmd $subcmd --list-opts)
+		COMPREPLY=( $( compgen -W '$opts' -- "$cur" ) )
 	# Fall down to list regular files
 	else
 		_filedir
diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 443fc11..2bc9e70 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -384,6 +384,8 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 			return usage_with_options_internal(usagestr, options, 1);
 		if (internal_help && !strcmp(arg + 2, "help"))
 			return parse_options_usage(usagestr, options);
+		if (!strcmp(arg + 2, "list-opts"))
+			return PARSE_OPT_LIST;
 		switch (parse_long_opt(ctx, arg + 2, options)) {
 		case -1:
 			return parse_options_usage(usagestr, options);
@@ -422,6 +424,12 @@ int parse_options(int argc, const char **argv, const struct option *options,
 		exit(129);
 	case PARSE_OPT_DONE:
 		break;
+	case PARSE_OPT_LIST:
+		while (options->type != OPTION_END) {
+			printf("--%s ", options->long_name);
+			options++;
+		}
+		exit(130);
 	default: /* PARSE_OPT_UNKNOWN */
 		if (ctx.argv[0][1] == '-') {
 			error("unknown option `%s'", ctx.argv[0] + 2);
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index abc31a1..7bb5999 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -140,6 +140,7 @@ extern NORETURN void usage_with_options(const char * const *usagestr,
 enum {
 	PARSE_OPT_HELP = -1,
 	PARSE_OPT_DONE,
+	PARSE_OPT_LIST,
 	PARSE_OPT_UNKNOWN,
 };
 
-- 
1.7.1

