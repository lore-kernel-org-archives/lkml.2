Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab2JEIyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:54:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32832 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2JEIyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:54:53 -0400
Date: Fri, 5 Oct 2012 01:54:30 -0700
From: tip-bot for Namhyung Kim <namhyung@kernel.org>
Message-ID: <tip-4d8061faca7a50010f037374410f0c3647c3ecf8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1349191294-6926-4-git-send-email-namhyung@kernel.org>
References: <1349191294-6926-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Long option completion support for each subcommands
Git-Commit-ID: 4d8061faca7a50010f037374410f0c3647c3ecf8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:54:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d8061faca7a50010f037374410f0c3647c3ecf8
Gitweb:     http://git.kernel.org/tip/4d8061faca7a50010f037374410f0c3647c3ecf8
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 3 Oct 2012 00:21:34 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:44 -0300

perf tools: Long option completion support for each subcommands

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
 
