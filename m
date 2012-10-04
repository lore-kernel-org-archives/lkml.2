Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab2JDSMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:12:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:39821 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab2JDSJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:35 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 33/42] perf tools: Complete tracepoint event names
Date: Thu,  4 Oct 2012 15:08:33 -0300
Message-Id: <1349374122-27806-34-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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
-- 
1.7.1

