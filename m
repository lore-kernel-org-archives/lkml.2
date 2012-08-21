Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab2HUPgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:36:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59955 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab2HUPgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:36:45 -0400
Date: Tue, 21 Aug 2012 08:36:11 -0700
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-0076d546b4f9b5c15121c6959d108a83fe43fa9a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        peterz@infradead.org, robert.richter@amd.com, dsahern@gmail.com,
        tglx@linutronix.de, feng.tang@intel.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        peterz@infradead.org, robert.richter@amd.com, dsahern@gmail.com,
        tglx@linutronix.de, feng.tang@intel.com, mingo@elte.hu
In-Reply-To: <1344419875-21665-6-git-send-email-feng.tang@intel.com>
References: <1344419875-21665-6-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf scripts python: Add event_analyzing_sample.
 py as a sample for general event handling
Git-Commit-ID: 0076d546b4f9b5c15121c6959d108a83fe43fa9a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:36:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0076d546b4f9b5c15121c6959d108a83fe43fa9a
Gitweb:     http://git.kernel.org/tip/0076d546b4f9b5c15121c6959d108a83fe43fa9a
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Wed, 8 Aug 2012 17:57:55 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 8 Aug 2012 12:55:38 -0300

perf scripts python: Add event_analyzing_sample.py as a sample for general event handling

Currently only trace point events are supported in perf/python script,
the first 3 patches of this serie add the support for all types of
events. This script is just a simple sample to show how to gather the
basic information of the events and analyze them.

This script will create one object for each event sample and insert them
into a table in a database, then leverage the simple SQL commands to
sort/group them. User can modify or write their brand new functions
according to their specific requirment.

Here is the sample of how to use the script:

 $ perf record -a tree
 $ perf script -s process_event.py

There is 100 records in gen_events table
Statistics about the general events grouped by thread/symbol/dso:

            comm   number         histgram
==========================================
         swapper       56     ######
            tree       20     #####
            perf       10     ####
            sshd        8     ####
     kworker/7:2        4     ###
     ksoftirqd/7        1     #
 plugin-containe        1     #

                          symbol   number         histgram
==========================================================
           native_write_msr_safe       40     ######
                  __lock_acquire        8     ####
             ftrace_graph_caller        4     ###
           prepare_ftrace_return        4     ###
                      intel_idle        3     ##
              native_sched_clock        3     ##
                  Unknown_symbol        2     ##
                      do_softirq        2     ##
                    lock_release        2     ##
           lock_release_holdtime        2     ##
               trace_graph_entry        2     ##
                        _IO_putc        1     #
                  __d_lookup_rcu        1     #
                      __do_fault        1     #
                      __schedule        1     #
                  _raw_spin_lock        1     #
                       delay_tsc        1     #
             generic_exec_single        1     #
                generic_fillattr        1     #

                                     dso   number         histgram
==================================================================
                       [kernel.kallsyms]       95     #######
                     /lib/libc-2.12.1.so        5     ###

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1344419875-21665-6-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../perf/scripts/python/event_analyzing_sample.py  |  193 ++++++++++++++++++++
 1 files changed, 193 insertions(+), 0 deletions(-)

diff --git a/tools/perf/scripts/python/event_analyzing_sample.py b/tools/perf/scripts/python/event_analyzing_sample.py
new file mode 100644
index 0000000..46f05aa
--- /dev/null
+++ b/tools/perf/scripts/python/event_analyzing_sample.py
@@ -0,0 +1,193 @@
+# process_event.py: general event handler in python
+#
+# Current perf report is alreay very powerful with the anotation integrated,
+# and this script is not trying to be as powerful as perf report, but
+# providing end user/developer a flexible way to analyze the events other
+# than trace points.
+#
+# The 2 database related functions in this script just show how to gather
+# the basic information, and users can modify and write their own functions
+# according to their specific requirment.
+#
+# The first sample "show_general_events" just does a baisc grouping for all
+# generic events with the help of sqlite, and the 2nd one "show_pebs_ll" is
+# for a x86 HW PMU event: PEBS with load latency data.
+#
+
+import os
+import sys
+import math
+import struct
+import sqlite3
+
+sys.path.append(os.environ['PERF_EXEC_PATH'] + \
+        '/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
+
+from perf_trace_context import *
+from EventClass import *
+
+#
+# If the perf.data has a big number of samples, then the insert operation
+# will be very time consuming (about 10+ minutes for 10000 samples) if the
+# .db database is on disk. Move the .db file to RAM based FS to speedup
+# the handling, which will cut the time down to several seconds.
+#
+con = sqlite3.connect("/dev/shm/perf.db")
+con.isolation_level = None
+
+def trace_begin():
+	print "In trace_begin:\n"
+
+        #
+        # Will create several tables at the start, pebs_ll is for PEBS data with
+        # load latency info, while gen_events is for general event.
+        #
+        con.execute("""
+                create table if not exists gen_events (
+                        name text,
+                        symbol text,
+                        comm text,
+                        dso text
+                );""")
+        con.execute("""
+                create table if not exists pebs_ll (
+                        name text,
+                        symbol text,
+                        comm text,
+                        dso text,
+                        flags integer,
+                        ip integer,
+                        status integer,
+                        dse integer,
+                        dla integer,
+                        lat integer
+                );""")
+
+#
+# Create and insert event object to a database so that user could
+# do more analysis with simple database commands.
+#
+def process_event(param_dict):
+        event_attr = param_dict["attr"]
+        sample     = param_dict["sample"]
+        raw_buf    = param_dict["raw_buf"]
+        comm       = param_dict["comm"]
+        name       = param_dict["ev_name"]
+
+        # Symbol and dso info are not always resolved
+        if (param_dict.has_key("dso")):
+                dso = param_dict["dso"]
+        else:
+                dso = "Unknown_dso"
+
+        if (param_dict.has_key("symbol")):
+                symbol = param_dict["symbol"]
+        else:
+                symbol = "Unknown_symbol"
+
+        # Creat the event object and insert it to the right table in database
+        event = create_event(name, comm, dso, symbol, raw_buf)
+        insert_db(event)
+
+def insert_db(event):
+        if event.ev_type == EVTYPE_GENERIC:
+                con.execute("insert into gen_events values(?, ?, ?, ?)",
+                                (event.name, event.symbol, event.comm, event.dso))
+        elif event.ev_type == EVTYPE_PEBS_LL:
+                event.ip &= 0x7fffffffffffffff
+                event.dla &= 0x7fffffffffffffff
+                con.execute("insert into pebs_ll values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
+                        (event.name, event.symbol, event.comm, event.dso, event.flags,
+                                event.ip, event.status, event.dse, event.dla, event.lat))
+
+def trace_end():
+	print "In trace_end:\n"
+        # We show the basic info for the 2 type of event classes
+        show_general_events()
+        show_pebs_ll()
+        con.close()
+
+#
+# As the event number may be very big, so we can't use linear way
+# to show the histgram in real number, but use a log2 algorithm.
+#
+
+def num2sym(num):
+        # Each number will have at least one '#'
+        snum = '#' * (int)(math.log(num, 2) + 1)
+        return snum
+
+def show_general_events():
+
+        # Check the total record number in the table
+        count = con.execute("select count(*) from gen_events")
+        for t in count:
+                print "There is %d records in gen_events table" % t[0]
+                if t[0] == 0:
+                        return
+
+        print "Statistics about the general events grouped by thread/symbol/dso: \n"
+
+         # Group by thread
+        commq = con.execute("select comm, count(comm) from gen_events group by comm order by -count(comm)")
+        print "\n%16s %8s %16s\n%s" % ("comm", "number", "histgram", "="*42)
+        for row in commq:
+             print "%16s %8d     %s" % (row[0], row[1], num2sym(row[1]))
+
+        # Group by symbol
+        print "\n%32s %8s %16s\n%s" % ("symbol", "number", "histgram", "="*58)
+        symbolq = con.execute("select symbol, count(symbol) from gen_events group by symbol order by -count(symbol)")
+        for row in symbolq:
+             print "%32s %8d     %s" % (row[0], row[1], num2sym(row[1]))
+
+        # Group by dso
+        print "\n%40s %8s %16s\n%s" % ("dso", "number", "histgram", "="*74)
+        dsoq = con.execute("select dso, count(dso) from gen_events group by dso order by -count(dso)")
+        for row in dsoq:
+             print "%40s %8d     %s" % (row[0], row[1], num2sym(row[1]))
+
+#
+# This function just shows the basic info, and we could do more with the
+# data in the tables, like checking the function parameters when some
+# big latency events happen.
+#
+def show_pebs_ll():
+
+        count = con.execute("select count(*) from pebs_ll")
+        for t in count:
+                print "There is %d records in pebs_ll table" % t[0]
+                if t[0] == 0:
+                        return
+
+        print "Statistics about the PEBS Load Latency events grouped by thread/symbol/dse/latency: \n"
+
+        # Group by thread
+        commq = con.execute("select comm, count(comm) from pebs_ll group by comm order by -count(comm)")
+        print "\n%16s %8s %16s\n%s" % ("comm", "number", "histgram", "="*42)
+        for row in commq:
+             print "%16s %8d     %s" % (row[0], row[1], num2sym(row[1]))
+
+        # Group by symbol
+        print "\n%32s %8s %16s\n%s" % ("symbol", "number", "histgram", "="*58)
+        symbolq = con.execute("select symbol, count(symbol) from pebs_ll group by symbol order by -count(symbol)")
+        for row in symbolq:
+             print "%32s %8d     %s" % (row[0], row[1], num2sym(row[1]))
+
+        # Group by dse
+        dseq = con.execute("select dse, count(dse) from pebs_ll group by dse order by -count(dse)")
+        print "\n%32s %8s %16s\n%s" % ("dse", "number", "histgram", "="*58)
+        for row in dseq:
+             print "%32s %8d     %s" % (row[0], row[1], num2sym(row[1]))
+
+        # Group by latency
+        latq = con.execute("select lat, count(lat) from pebs_ll group by lat order by lat")
+        print "\n%32s %8s %16s\n%s" % ("latency", "number", "histgram", "="*58)
+        for row in latq:
+             print "%32s %8d     %s" % (row[0], row[1], num2sym(row[1]))
+
+def trace_unhandled(event_name, context, event_fields_dict):
+		print ' '.join(['%s=%s'%(k,str(v))for k,v in sorted(event_fields_dict.items())])
+
+def print_header(event_name, cpu, secs, nsecs, pid, comm):
+	print "%-20s %5u %05u.%09u %8u %-20s " % \
+	(event_name, cpu, secs, nsecs, pid, comm),
