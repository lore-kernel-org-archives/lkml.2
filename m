Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab2HUPfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:35:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59932 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab2HUPfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:35:44 -0400
Date: Tue, 21 Aug 2012 08:35:09 -0700
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-02f1c33f7d630183518ea42d45a6acf275541b08@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        peterz@infradead.org, robert.richter@amd.com, dsahern@gmail.com,
        tglx@linutronix.de, feng.tang@intel.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        peterz@infradead.org, robert.richter@amd.com, dsahern@gmail.com,
        tglx@linutronix.de, feng.tang@intel.com, mingo@elte.hu
In-Reply-To: <1344419875-21665-5-git-send-email-feng.tang@intel.com>
References: <1344419875-21665-5-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf scripts python:
  Add a python library EventClass.py
Git-Commit-ID: 02f1c33f7d630183518ea42d45a6acf275541b08
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:35:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02f1c33f7d630183518ea42d45a6acf275541b08
Gitweb:     http://git.kernel.org/tip/02f1c33f7d630183518ea42d45a6acf275541b08
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Wed, 8 Aug 2012 17:57:54 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 8 Aug 2012 12:53:08 -0300

perf scripts python: Add a python library EventClass.py

This library defines several class types for perf events which could
help to better analyze the event samples. Currently there are just a few
classes, PerfEvent is the base class for all perf events,  PebsEvent is
a HW base Intel x86 PEBS event, and user could add more SW/HW event
classes based on requriements.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1344419875-21665-5-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../Perf-Trace-Util/lib/Perf/Trace/EventClass.py   |   94 ++++++++++++++++++++
 1 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py
new file mode 100755
index 0000000..6372431
--- /dev/null
+++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py
@@ -0,0 +1,94 @@
+# EventClass.py
+#
+# This is a libray defining some events typs classes, which could
+# be used by other scripts to analyzing the perf samples.
+#
+# Currently there are just a few classes defined for examples,
+# PerfEvent is the base class for all perf event sample, PebsEvent
+# is a HW base Intel x86 PEBS event, and user could add more SW/HW
+# event classes based on requriements.
+
+import struct
+
+# Event types, user could add more here
+EVTYPE_GENERIC  = 0
+EVTYPE_PEBS     = 1     # Basic PEBS event
+EVTYPE_PEBS_LL  = 2     # PEBS event with load latency info
+EVTYPE_IBS      = 3
+
+#
+# Currently we don't have good way to tell the event type, but by
+# the size of raw buffer, raw PEBS event with load latency data's
+# size is 176 bytes, while the pure PEBS event's size is 144 bytes.
+#
+def create_event(name, comm, dso, symbol, raw_buf):
+        if (len(raw_buf) == 144):
+                event = PebsEvent(name, comm, dso, symbol, raw_buf)
+        elif (len(raw_buf) == 176):
+                event = PebsNHM(name, comm, dso, symbol, raw_buf)
+        else:
+                event = PerfEvent(name, comm, dso, symbol, raw_buf)
+
+        return event
+
+class PerfEvent(object):
+        event_num = 0
+        def __init__(self, name, comm, dso, symbol, raw_buf, ev_type=EVTYPE_GENERIC):
+                self.name       = name
+                self.comm       = comm
+                self.dso        = dso
+                self.symbol     = symbol
+                self.raw_buf    = raw_buf
+                self.ev_type    = ev_type
+                PerfEvent.event_num += 1
+
+        def show(self):
+                print "PMU event: name=%12s, symbol=%24s, comm=%8s, dso=%12s" % (self.name, self.symbol, self.comm, self.dso)
+
+#
+# Basic Intel PEBS (Precise Event-based Sampling) event, whose raw buffer
+# contains the context info when that event happened: the EFLAGS and
+# linear IP info, as well as all the registers.
+#
+class PebsEvent(PerfEvent):
+        pebs_num = 0
+        def __init__(self, name, comm, dso, symbol, raw_buf, ev_type=EVTYPE_PEBS):
+                tmp_buf=raw_buf[0:80]
+                flags, ip, ax, bx, cx, dx, si, di, bp, sp = struct.unpack('QQQQQQQQQQ', tmp_buf)
+                self.flags = flags
+                self.ip    = ip
+                self.ax    = ax
+                self.bx    = bx
+                self.cx    = cx
+                self.dx    = dx
+                self.si    = si
+                self.di    = di
+                self.bp    = bp
+                self.sp    = sp
+
+                PerfEvent.__init__(self, name, comm, dso, symbol, raw_buf, ev_type)
+                PebsEvent.pebs_num += 1
+                del tmp_buf
+
+#
+# Intel Nehalem and Westmere support PEBS plus Load Latency info which lie
+# in the four 64 bit words write after the PEBS data:
+#       Status: records the IA32_PERF_GLOBAL_STATUS register value
+#       DLA:    Data Linear Address (EIP)
+#       DSE:    Data Source Encoding, where the latency happens, hit or miss
+#               in L1/L2/L3 or IO operations
+#       LAT:    the actual latency in cycles
+#
+class PebsNHM(PebsEvent):
+        pebs_nhm_num = 0
+        def __init__(self, name, comm, dso, symbol, raw_buf, ev_type=EVTYPE_PEBS_LL):
+                tmp_buf=raw_buf[144:176]
+                status, dla, dse, lat = struct.unpack('QQQQ', tmp_buf)
+                self.status = status
+                self.dla = dla
+                self.dse = dse
+                self.lat = lat
+
+                PebsEvent.__init__(self, name, comm, dso, symbol, raw_buf, ev_type)
+                PebsNHM.pebs_nhm_num += 1
+                del tmp_buf
