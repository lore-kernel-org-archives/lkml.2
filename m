Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934988Ab0HFRHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 13:07:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:42679 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932950Ab0HFRH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 13:07:27 -0400
Date: Fri, 6 Aug 2010 17:06:58 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        npiggin@suse.de, fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, efault@gmx.de, peterz@infradead.org,
        npiggin@suse.de, fweisbec@gmail.com, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Speed up exit path
Message-ID: <tip-71e7cf3a37ba6189fa7215555e8e760b400fc23b@git.kernel.org>
Git-Commit-ID: 71e7cf3a37ba6189fa7215555e8e760b400fc23b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 17:06:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71e7cf3a37ba6189fa7215555e8e760b400fc23b
Gitweb:     http://git.kernel.org/tip/71e7cf3a37ba6189fa7215555e8e760b400fc23b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 5 Aug 2010 19:41:44 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 5 Aug 2010 19:46:47 -0300

perf report: Speed up exit path

When cmd_record exits the whole perf binary will exit right after,
so no need to traverse lots of complex data structures freeing them.

Sticked a comment for leak detectives and for a experiment with obstacks
to be performed so that we can speed up freeing that memory.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 4a7a743..55fc1f4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -348,7 +348,18 @@ static int __cmd_report(void)
 		hists__tty_browse_tree(&session->hists_tree, help);
 
 out_delete:
-	perf_session__delete(session);
+	/*
+	 * Speed up the exit process, for large files this can
+	 * take quite a while.
+	 *
+	 * XXX Enable this when using valgrind or if we ever
+	 * librarize this command.
+	 *
+	 * Also experiment with obstacks to see how much speed
+	 * up we'll get here.
+	 *
+ 	 * perf_session__delete(session);
+ 	 */
 	return ret;
 }
 
