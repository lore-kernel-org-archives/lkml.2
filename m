Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab1GDRkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:40:33 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45204 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab1GDRkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:40:32 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf:  Add drop monitor script
Date: Mon,  4 Jul 2011 13:40:17 -0400
Message-Id: <1309801217-22450-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.7.6
X-Spam-Score: -1.7 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A while back I created the dropmonitor protocol, which allowed users to get
reports of dropped frames communicated to them via a netlink socket.  While
useful, several people have now asked that I integrate the ability to do drop
monitoring with perf, so they don't have to run additional tools.  This patch
adds a drop monitor script to the perf suite, and provides the same output that
the netlink socket does.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 .../perf/scripts/python/bin/net_dropmonitor-record |    2 +
 .../perf/scripts/python/bin/net_dropmonitor-report |    4 +
 tools/perf/scripts/python/net_dropmonitor.py       |   73 ++++++++++++++++++++
 3 files changed, 79 insertions(+), 0 deletions(-)
 create mode 100755 tools/perf/scripts/python/bin/net_dropmonitor-record
 create mode 100755 tools/perf/scripts/python/bin/net_dropmonitor-report
 create mode 100755 tools/perf/scripts/python/net_dropmonitor.py

diff --git a/tools/perf/scripts/python/bin/net_dropmonitor-record b/tools/perf/scripts/python/bin/net_dropmonitor-record
new file mode 100755
index 0000000..423fb81
--- /dev/null
+++ b/tools/perf/scripts/python/bin/net_dropmonitor-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -e skb:kfree_skb $@
diff --git a/tools/perf/scripts/python/bin/net_dropmonitor-report b/tools/perf/scripts/python/bin/net_dropmonitor-report
new file mode 100755
index 0000000..8d698f5
--- /dev/null
+++ b/tools/perf/scripts/python/bin/net_dropmonitor-report
@@ -0,0 +1,4 @@
+#!/bin/bash
+# description: display a table of dropped frames
+
+perf script -s "$PERF_EXEC_PATH"/scripts/python/net_dropmonitor.py $@
diff --git a/tools/perf/scripts/python/net_dropmonitor.py b/tools/perf/scripts/python/net_dropmonitor.py
new file mode 100755
index 0000000..67cd26b
--- /dev/null
+++ b/tools/perf/scripts/python/net_dropmonitor.py
@@ -0,0 +1,73 @@
+# Monitor the system for dropped packets and proudce a report of drop locations and counts
+
+import os
+import sys
+
+sys.path.append(os.environ['PERF_EXEC_PATH'] + \
+		'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
+
+from perf_trace_context import *
+from Core import *
+from Util import *
+
+drop_log = {}
+kallsyms = []
+
+def get_kallsyms_table():
+	global kallsyms
+	try:
+		f = open("/proc/kallsyms", "r")
+		linecount = 0
+		for line in f:
+			linecount = linecount+1
+		f.seek(0)
+	except:
+		return
+
+
+	j = 0
+	for line in f:
+		loc = int(line.split()[0], 16)
+		name = line.split()[2]
+		j = j +1
+		if ((j % 100) == 0):
+			print "\r" + str(j) + "/" + str(linecount),
+		kallsyms.append({ 'loc': loc, 'name' : name})
+
+	print "\r" + str(j) + "/" + str(linecount)
+	kallsyms.sort()
+	return
+
+def get_sym(sloc):
+	loc = int(sloc)
+	for i in kallsyms:
+		if (i['loc'] >= loc):
+			return (i['name'], i['loc']-loc)
+	return (None, 0)
+
+def print_drop_table():
+	print "%25s %25s %25s" % ("LOCATION", "OFFSET", "COUNT")
+	for i in drop_log.keys():
+		(sym, off) = get_sym(i)
+		if sym == None:
+			sym = i
+		print "%25s %25s %25s" % (sym, off, drop_log[i])
+
+
+def trace_begin():
+	print "Starting trace (Ctrl-C to dump results)"
+
+def trace_end():
+	print "Gathering kallsyms data"
+	get_kallsyms_table()
+	print_drop_table()
+
+# called from perf, when it finds a correspoinding event
+def skb__kfree_skb(name, context, cpu, sec, nsec, pid, comm,
+			skbaddr, protocol, location):
+	slocation = str(location)
+	try:
+		drop_log[slocation] = drop_log[slocation] + 1
+	except:
+		drop_log[slocation] = 1
+
-- 
1.7.6

