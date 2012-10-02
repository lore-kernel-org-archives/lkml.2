Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab2JBPW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:22:57 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46310 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab2JBPWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:22:52 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] perf tools: Long option completion support for each subcommands
Date: Wed,  3 Oct 2012 00:21:34 +0900
Message-Id: <1349191294-6926-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1349191294-6926-1-git-send-email-namhyung@kernel.org>
References: <1349191294-6926-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add internal --list-opts option to print all of long option names to
stdout so that it can be used for bash completion engine.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/bash_completion      |    9 +++++++--
 tools/perf/util/parse-options.c |    8 ++++++++
 tools/perf/util/parse-options.h |    1 +
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index bef06f0deeb5..5c355ababf80 100644
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
index 443fc116512b..2bc9e70df7e2 100644
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
index abc31a1dac1a..7bb5999940ca 100644
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
1.7.9.2

