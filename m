Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2JEI7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:59:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32916 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab2JEI7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:59:33 -0400
Date: Fri, 5 Oct 2012 01:59:12 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-ae0c1f993411d88bf54c9e20a4249ebcc7a041f9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1349328234-16995-1-git-send-email-namhyung@kernel.org>
References: <1349328234-16995-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Complete tracepoint event names
Git-Commit-ID: ae0c1f993411d88bf54c9e20a4249ebcc7a041f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:59:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae0c1f993411d88bf54c9e20a4249ebcc7a041f9
Gitweb:     http://git.kernel.org/tip/ae0c1f993411d88bf54c9e20a4249ebcc7a041f9
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 4 Oct 2012 14:23:54 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 4 Oct 2012 12:44:52 -0300

perf tools: Complete tracepoint event names

Currently tracepoint events cannot be completed because they contain a
colon (:) character.  The colon is considered as a word separator when
bash completion is done - variable COMP_WORDBREAKS contains colon - so
if a word being completed contains a colon it can be a problem.

Recent versions of bash completion provide -n switch to
_get_comp_words_by_ref and __ltrim_colon_completions functions in order
to resolve this issue.  Copy the latter in case not exists.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349328234-16995-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bash_completion |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 5c355ab..56e6a12 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -6,6 +6,19 @@ function_exists()
 	return $?
 }
 
+function_exists __ltrim_colon_completions ||
+__ltrim_colon_completions()
+{
+	if [[ "$1" == *:* && "$COMP_WORDBREAKS" == *:* ]]; then
+		# Remove colon-word prefix from COMPREPLY items
+		local colon_word=${1%${1##*:}}
+		local i=${#COMPREPLY[*]}
+		while [[ $((--i)) -ge 0 ]]; do
+			COMPREPLY[$i]=${COMPREPLY[$i]#"$colon_word"}
+		done
+	fi
+}
+
 have perf &&
 _perf()
 {
@@ -13,9 +26,9 @@ _perf()
 
 	COMPREPLY=()
 	if function_exists _get_comp_words_by_ref; then
-		_get_comp_words_by_ref cur prev
+		_get_comp_words_by_ref -n : cur prev
 	else
-		cur=$(_get_cword)
+		cur=$(_get_cword :)
 		prev=${COMP_WORDS[COMP_CWORD-1]}
 	fi
 
@@ -35,6 +48,7 @@ _perf()
 	elif [[ $prev == "-e" && "${COMP_WORDS[1]}" == @(record|stat|top) ]]; then
 		evts=$($cmd list --raw-dump)
 		COMPREPLY=( $( compgen -W '$evts' -- "$cur" ) )
+		__ltrim_colon_completions $cur
 	# List long option names
 	elif [[ $cur == --* ]];  then
 		subcmd=${COMP_WORDS[1]}
