Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab2JBPWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:22:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46310 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab2JBPWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:22:47 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] perf tools: Check existence of _get_comp_words_by_ref when bash completing
Date: Wed,  3 Oct 2012 00:21:32 +0900
Message-Id: <1349191294-6926-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1349191294-6926-1-git-send-email-namhyung@kernel.org>
References: <1349191294-6926-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The '_get_comp_words_by_ref' function is available from the bash
completion v1.2 so that earlier version emits following warning:

  $ perf re<TAB>_get_comp_words_by_ref: command not found

Use older '_get_cword' method when the above function doesn't exist.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/bash_completion |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 1958fa539d0f..3d48cee1b5e5 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -1,12 +1,23 @@
 # perf completion
 
+function_exists()
+{
+	declare -F $1 > /dev/null
+	return $?
+}
+
 have perf &&
 _perf()
 {
-	local cur cmd
+	local cur prev cmd
 
 	COMPREPLY=()
-	_get_comp_words_by_ref cur prev
+	if function_exists _get_comp_words_by_ref; then
+		_get_comp_words_by_ref cur prev
+	else
+		cur=$(_get_cword)
+		prev=${COMP_WORDS[COMP_CWORD-1]}
+	fi
 
 	cmd=${COMP_WORDS[0]}
 
-- 
1.7.9.2

