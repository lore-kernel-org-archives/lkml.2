Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab0D0M67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:58:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:41171 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab0D0M6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:58:55 -0400
Date: Tue, 27 Apr 2010 12:58:27 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100421195624.24664.46214.stgit@localhost6.localdomain6>
References: <20100421195624.24664.46214.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix to use symtab only if no debuginfo
Message-ID: <tip-15eca306ec95e164d05457f9f27c722f69af6d18@git.kernel.org>
Git-Commit-ID: 15eca306ec95e164d05457f9f27c722f69af6d18
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Apr 2010 12:58:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15eca306ec95e164d05457f9f27c722f69af6d18
Gitweb:     http://git.kernel.org/tip/15eca306ec95e164d05457f9f27c722f69af6d18
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 21 Apr 2010 15:56:24 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 26 Apr 2010 15:32:37 -0300

perf probe: Fix to use symtab only if no debuginfo

Fix perf probe to use symtab only if there is no debuginfo, because debuginfo
has more information than symtab.

If we can't find a function in debuginfo, we never find it in symtab.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20100421195624.24664.46214.stgit@localhost6.localdomain6>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 4fb4803..5d3baec 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -180,15 +180,16 @@ static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
 		return -ENOENT;
 	}
 	/* Error path : ntevs < 0 */
-	if (need_dwarf) {
-		if (ntevs == -EBADF)
-			pr_warning("No dwarf info found in the vmlinux - "
-				"please rebuild with CONFIG_DEBUG_INFO=y.\n");
-		return ntevs;
+	pr_debug("An error occurred in debuginfo analysis (%d).\n", ntevs);
+	if (ntevs == -EBADF) {
+		pr_warning("Warning: No dwarf info found in the vmlinux - "
+			"please rebuild kernel with CONFIG_DEBUG_INFO=y.\n");
+		if (!need_dwarf) {
+			pr_debug("Trying to use symbols.\nn");
+			return 0;
+		}
 	}
-	pr_debug("An error occurred in debuginfo analysis."
-		 " Try to use symbols.\n");
-	return 0;
+	return ntevs;
 }
 
 #define LINEBUF_SIZE 256
