Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab1I2WtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:49:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60159 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065Ab1I2WsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:48:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/16] perf script: Add drop monitor script
Date: Thu, 29 Sep 2011 19:47:56 -0300
Message-Id: <1317336490-19437-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317336490-19437-1-git-send-email-acme@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>

A while back I created the dropmonitor protocol, which allowed users to get
reports of dropped frames communicated to them via a netlink socket.

While useful, several people have now asked that I integrate the ability
to do drop monitoring with perf, so they don't have to run additional
tools.

This patch adds a drop monitor script to the perf suite, and provides
the same output that the netlink socket does.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1309801217-22450-1-git-send-email-nhorman@tuxdriver.com
Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../perf/scripts/python/bin/net_dropmonitor-record |    2 +
 .../perf/scripts/python/bin/net_dropmonitor-report |    4 +
 tools/perf/scripts/python/net_dropmonitor.py       |   72 ++++++++++++++++++++
 3 files changed, 78 insertions(+), 0 deletions(-)
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
index 0000000..a4ffc95
--- /dev/null
+++ b/tools/perf/scripts/python/net_dropmonitor.py
@@ -0,0 +1,72 @@
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
-- 
1.6.2.5

