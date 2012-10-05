Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab2JEIwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:52:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32805 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab2JEIwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:52:53 -0400
Date: Fri, 5 Oct 2012 01:52:38 -0700
From: tip-bot for Namhyung Kim <namhyung@kernel.org>
Message-ID: <tip-a1d668c3ffd38d611f8446615e8f797dcfdfc397@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1349191294-6926-2-git-send-email-namhyung@kernel.org>
References: <1349191294-6926-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Check existence of _get_comp_words_by_ref when bash completing
Git-Commit-ID: a1d668c3ffd38d611f8446615e8f797dcfdfc397
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:52:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1d668c3ffd38d611f8446615e8f797dcfdfc397
Gitweb:     http://git.kernel.org/tip/a1d668c3ffd38d611f8446615e8f797dcfdfc397
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 3 Oct 2012 00:21:32 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:42 -0300

perf tools: Check existence of _get_comp_words_by_ref when bash completing

The '_get_comp_words_by_ref' function is available from the bash
completion v1.2 so that earlier version emits following warning:

  $ perf re<TAB>_get_comp_words_by_ref: command not found

Use older '_get_cword' method when the above function doesn't exist.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1349191294-6926-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bash_completion |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 1958fa5..3d48cee 100644
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
 
