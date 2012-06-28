Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab2F1JUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 05:20:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:2529 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757976Ab2F1JTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 05:19:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="159147533"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>, Feng Tang <feng.tang@intel.com>
Subject: [PATCH v4 RFC 4/5] perf script: Add a python library EventClass.py
Date: Thu, 28 Jun 2012 17:15:33 +0800
Message-Id: <1340874934-25661-5-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1340874934-25661-1-git-send-email-feng.tang@intel.com>
References: <1340874934-25661-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This library defines several class types for perf events which could
help to better analyze the event samples. Currently there are just a
few classes, PerfEvent is the base class for all perf events,  PebsEvent
is a HW base Intel x86 PEBS event, and user could add more SW/HW event
classes based on requriements.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 .../Perf-Trace-Util/lib/Perf/Trace/EventClass.py   |   95 ++++++++++++++++++++
 1 files changed, 95 insertions(+), 0 deletions(-)
 create mode 100755 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py

diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py
new file mode 100755
index 0000000..12cd773
--- /dev/null
+++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py
@@ -0,0 +1,95 @@
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
+
-- 
1.7.1

