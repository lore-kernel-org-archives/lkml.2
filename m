Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0DUTuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 15:50:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab0DUTuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 15:50:22 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/4] perf probe: Fix to use symtab only if no debuginfo
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Wed, 21 Apr 2010 15:56:24 -0400
Message-ID: <20100421195624.24664.46214.stgit@localhost6.localdomain6>
In-Reply-To: <20100421195616.24664.89980.stgit@localhost6.localdomain6>
References: <20100421195616.24664.89980.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix perf probe to use symtab only if there is no debuginfo,
because debuginfo has more precise information than symtab.
If we can't find a function in debuginfo, we never find it
in symtab.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
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


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
