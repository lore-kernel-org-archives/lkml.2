Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650Ab2CBJx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:53:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44122 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab2CBJxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:53:24 -0500
Date: Fri, 2 Mar 2012 01:50:37 -0800
From: tip-bot for Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Message-ID: <tip-26b7952494772f0e695271fbd6cf83a852f60f25@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, prashanth@linux.vnet.ibm.com, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, srikar@linux.vnet.ibm.com,
        jbaron@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, prashanth@linux.vnet.ibm.com, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, jbaron@redhat.com
In-Reply-To: <4F473F33.4060409@linux.vnet.ibm.com>
References: <4F473F33.4060409@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe:
  Ensure offset provided is not greater than function length
Git-Commit-ID: 26b7952494772f0e695271fbd6cf83a852f60f25
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 02 Mar 2012 01:51:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26b7952494772f0e695271fbd6cf83a852f60f25
Gitweb:     http://git.kernel.org/tip/26b7952494772f0e695271fbd6cf83a852f60f25
Author:     Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
AuthorDate: Fri, 24 Feb 2012 13:11:39 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Feb 2012 18:29:45 -0300

perf probe: Ensure offset provided is not greater than function length

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
