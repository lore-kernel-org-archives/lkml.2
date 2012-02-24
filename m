Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab2BXHly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 02:41:54 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:53052 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab2BXHlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 02:41:53 -0500
Message-ID: <4F473F33.4060409@linux.vnet.ibm.com>
Date: Fri, 24 Feb 2012 13:11:39 +0530
From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: masami.hiramatsu.pt@hitachi.com, ananth@in.ibm.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
CC: jbaron@redhat.com, rostedt@goodmis.org, srikar@linux.vnet.ibm.com
Subject: [PATCH] perf - ensure offset provided during probe addition is not
 greater than function length
References: <4F45FABE.90104@linux.vnet.ibm.com>
In-Reply-To: <4F45FABE.90104@linux.vnet.ibm.com>
X-Forwarded-Message-Id: <4F45FABE.90104@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022407-2398-0000-0000-0000047F5CDF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf probe allows kprobe to be inserted at any offset from a function
start, which results in adding kprobes to unintended location.
(example: perf probe do_fork+10000 is allowed even though size of
do_fork is ~904)

This patch will ensure probe addition fails when the offset specified
is greater than size of the function.


Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
---

 tools/perf/util/probe-finder.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 5d73262..d298f94 100644
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

