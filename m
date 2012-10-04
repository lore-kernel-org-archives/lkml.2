Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2JDFdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 01:33:42 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58181 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab2JDFdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 01:33:41 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-03-506d1fb3b31e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tools: Complete tracepoint event names
Date: Thu,  4 Oct 2012 14:23:54 +0900
Message-Id: <1349328234-16995-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Currently tracepoint events cannot be completed because they contain a
colon (:) character.  The colon is considered as a word separator when
bash completion is done - variable COMP_WORDBREAKS contains colon - so
if a word being completed contains a colon it can be a problem.

Recent versions of bash completion provide -n switch to
_get_comp_words_by_ref and __ltrim_colon_completions functions in
order to resolve this issue.  Copy the latter in case not exists.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
This patch is based on my previous completion updates set.

 tools/perf/bash_completion | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 5c355ababf80..56e6a12aab59 100644
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
-- 
1.7.11.4

