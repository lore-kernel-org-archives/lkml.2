Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab2C1P4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 11:56:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758118Ab2C1P4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 11:56:22 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: =?UTF-8?q?=5BRFC=205/5=5D=20perf=2C=20tool=3A=20Add=20events=20specification=20doc?=
Date: Wed, 28 Mar 2012 17:55:53 +0200
Message-Id: <1332950153-8606-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1332950153-8606-1-git-send-email-jolsa@redhat.com>
References: <1332950153-8606-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf-events.txt with description of event specification.
Linked from perf-stat.txt and perf-record.txt.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Documentation/perf-events.txt |  182 ++++++++++++++++++++++++++++++
 tools/perf/Documentation/perf-record.txt |    2 +-
 tools/perf/Documentation/perf-stat.txt   |    2 +-
 3 files changed, 184 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-events.txt

diff --git a/tools/perf/Documentation/perf-events.txt b/tools/perf/Documentation/perf-events.txt
new file mode 100644
index 0000000..172947d
--- /dev/null
+++ b/tools/perf/Documentation/perf-events.txt
@@ -0,0 +1,182 @@
+perf-events(7)
+==============
+
+NAME
+----
+perf-events - Description of perf event specification
+
+SYNOPSIS
+--------
+[verse]
+'perf record' [-e <EVENTS> | --event=EVENTS]
+'perf stat'   [-e <EVENTS> | --event=EVENTS]
+
+EVENT SYNTAX
+------------
+.......................................................................................
+events:                         events ',' event | event
+
+event:                          event_def ':' [ukhp]{1,5}
+
+event_def:                      event_pmu |
+                                event_legacy_symbol |
+                                event_legacy_cache sep_dc |
+                                event_legacy_mem |
+                                event_legacy_tracepoint sep_dc |
+                                event_legacy_numeric sep_dc |
+                                event_legacy_raw sep_dc
+
+event_pmu:                      pmu_name '/' event_config '/'
+
+event_legacy_symbol:            symbol '/' event_config '/' |
+                                symbol
+
+symbol:                         cpu-cycles | cycles |
+                                stalled-cycles-frontend | idle-cycles-frontend |
+                                stalled-cycles-backend | idle-cycles-backend |
+                                instructions |
+                                cache-references |
+                                cache-misses |
+                                branch-instructions | branches |
+                                branch-misses |
+                                bus-cycles |
+                                cpu-clock |
+                                task-clock |
+                                page-faults | faults |
+                                minor-faults |
+                                major-faults |
+                                context-switches | cs |
+                                cpu-migrations | migrations |
+                                alignment-faults |
+                                emulation-faults
+
+event_legacy_cache:             cache_type '-' cache_op_result '-' cache_op_result |
+                                cache_type '-' cache_op_result |
+                                cache_type
+
+cache_type:                     L1-dcache | l1-d | l1d | L1-data |
+                                L1-icache | l1-i | l1i | L1-instruction |
+                                LLC | L2 |
+                                dTLB | d-tlb | Data-TLB |
+                                iTLB | i-tlb | Instruction-TLB |
+                                branch | branches | bpu | btb | bpc |
+                                node
+
+cache_op_result:                load | loads | read |
+                                store | stores | write |
+                                prefetch | prefetches |
+                                speculative-read | speculative-load |
+                                refs | Reference | ops | access |
+                                misses | miss
+
+event_legacy_mem:               'mem:' value ':' [rwx]
+
+event_legacy_tracepoint:        subsystem ':' tracepoint
+
+event_legacy_numeric:           value ':' value
+
+event_legacy_raw:               'r' value
+
+event_config:                   event_config ',' event_term |
+                                event_term
+
+event_term:                     name '=' str |
+                                name '=' value |
+                                event_term_list
+
+event_term_list:                event_term_list '|' event_term_elem |
+                                event_term_elem '|' event_term_elem
+
+event_term_elem:                name | value
+.......................................................................................
+
+
+PMU EVENT
+---------
+The kernel PMU exports its event format description via sysfs.
+It's located at following path:
+
+        ${sysfs_mount}/bus/event_source/devices/${pmu}/format
+
+The format directory contains files representing events terms.
+Each event term file contains information describing how to
+apply the term value into perf event config eg:
+
+        $ cat /sys/bus/event_source/devices/cpu/format/umask
+        config:8-15
+
+says term 'umask' defines bits 8 to 15 inside config value of
+the perf event.
+
+Example:
+        cpu/event=0xb7,umask=0x01,offcore_rsp=0x500b/
+
+
+SYMBOLIC EVENT
+--------------
+empty
+
+HW CACHE EVENT
+--------------
+empty
+
+BREAKPOINT EVENT
+----------------
+The breakpoint event allows to create a breakpoint inside traced
+application. An event is generated in case the the breakpoint is
+trigered.
+
+NUMERIC EVENT
+-------------
+empty
+
+RAW EVENT
+---------
+Even when an event is not available in a symbolic form within perf
+right now, it can be encoded in a per processor specific way.
+
+For instance For x86 CPUs NNN represents the raw register encoding with
+the layout of IA32_PERFEVTSELx MSRs (see [Intel® 64 and IA-32 Architectures Software Developer's Manual Volume 3B: System Programming Guide] Figure 30-1 Layout
+of IA32_PERFEVTSELx MSRs) or AMD's PerfEvtSeln (see [AMD64 Architecture Programmer’s Manual Volume 2: System Programming], Page 344,
+Figure 13-7 Performance Event-Select Register (PerfEvtSeln)).
+
+Example:
+
+If the Intel docs for a QM720 Core i7 describe an event as:
+
+  Event  Umask  Event Mask
+  Num.   Value  Mnemonic    Description                        Comment
+
+  A8H      01H  LSD.UOPS    Counts the number of micro-ops     Use cmask=1 and
+                            delivered by loop stream detector  invert to count
+                                                               cycles
+
+raw encoding of 0x1A8 can be used:
+
+ perf stat -e r1a8 -a sleep 1
+ perf record -e r1a8 ...
+
+You should refer to the processor specific documentation for getting these
+details. Some of them are referenced in the SEE ALSO section below.
+
+EVENT MODIFIERS
+---------------
+Events can optionally have a modifer by appending a colon and one or
+more modifiers.  Modifiers allow the user to restrict when events are
+counted with 'u' for user-space, 'k' for kernel, 'h' for hypervisor.
+Additional modifiers are 'G' for guest counting (in KVM guests) and 'H'
+for host counting (not in KVM guests).
+
+The 'p' modifier can be used for specifying how precise the instruction
+address should be. The 'p' modifier is currently only implemented for
+Intel PEBS and can be specified multiple times:
+  0 - SAMPLE_IP can have arbitrary skid
+  1 - SAMPLE_IP must have constant skid
+  2 - SAMPLE_IP requested to have 0 skid
+  3 - SAMPLE_IP must have 0 skid
+
+The PEBS implementation now supports up to 2.
+
+SEE ALSO
+--------
+linkperf:perf-stat[1], linkperf:perf-record[1]
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index a1386b2..5a96fba 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -184,4 +184,4 @@ Note that this feature may not be available on all processors.
 
 SEE ALSO
 --------
-linkperf:perf-stat[1], linkperf:perf-list[1]
+linkperf:perf-stat[1], linkperf:perf-list[1], linkperf:perf-events[7]
diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 2fa173b..5008992 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -130,4 +130,4 @@ $ perf stat -- make -j
 
 SEE ALSO
 --------
-linkperf:perf-top[1], linkperf:perf-list[1]
+linkperf:perf-top[1], linkperf:perf-list[1], linkperf:perf-events[7]
-- 
1.7.6.5

