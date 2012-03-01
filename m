Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab2CAR0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:26:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:60908 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab2CARZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:25:59 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/4] perf probe: Ensure offset provided is not greater than function length
Date: Thu,  1 Mar 2012 14:25:26 -0300
Message-Id: <1330622728-12759-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1330622728-12759-1-git-send-email-acme@infradead.org>
References: <1330622728-12759-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>

The perf probe command allows kprobe to be inserted at any offset from a
function start, which results in adding kprobes to unintended location.

Example: perf probe do_fork+10000 is allowed even though size of do_fork
is ~904.

This patch will ensure probe addition fails when the offset specified is
greater than size of the function.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/4F473F33.4060409@linux.vnet.ibm.com
Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 5d73262..74bd2e6 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -672,7 +672,7 @@ static int find_variable(Dwarf_Die *sc_die, struct probe_finder *pf)
 static int convert_to_trace_point(Dwarf_Die *sp_die, Dwarf_Addr paddr,
 				  bool retprobe, struct probe_trace_point *tp)
 {
-	Dwarf_Addr eaddr;
+	Dwarf_Addr eaddr, highaddr;
 	const char *name;
 
 	/* Copy the name of probe point */
@@ -683,6 +683,16 @@ static int convert_to_trace_point(Dwarf_Die *sp_die, Dwarf_Addr paddr,
 				   dwarf_diename(sp_die));
 			return -ENOENT;
 		}
+		if (dwarf_highpc(sp_die, &highaddr) != 0) {
+			pr_warning("Failed to get end address of %s\n",
+				   dwarf_diename(sp_die));
+			return -ENOENT;
+		}
+		if (paddr > highaddr) {
+			pr_warning("Offset specified is greater than size of %s\n",
+				   dwarf_diename(sp_die));
+			return -EINVAL;
+		}
 		tp->symbol = strdup(name);
 		if (tp->symbol == NULL)
 			return -ENOMEM;
-- 
1.7.9.123.g65da0

