Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab2KENxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:53:07 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55103 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417Ab2KENxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:53:03 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v2 00/16] perf: add memory access sampling support
Date: Mon,  5 Nov 2012 14:50:47 +0100
Message-Id: <1352123463-7346-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series had a new feature to the kernel perf_events
interface and corresponding user level tool, perf.

With this patch, it is possible to sample (not trace) memory
accesses (load, store). For loads, the instruction and data
addresses are captured along with the latency and data source.
For stores, the instruction and data addresses are capture
along with limited cache and TLB information.

For load data source, the memory hierarchy level, the tlb, snoop
and lock information is captured.

Although the perf_event interface is extended in a generic manner,
sampling memory accesses requires HW support. The current patches
implement the feature on Intel processors starting with Nehalem.
The patches leverage the PEBS Load Latency and Precise Store
mechanisms. Precise Store is present only on Sandy Bridge and
Ivy Bridge based processors.

The perf tool is extended to make capturing and analyzing the
data easier with a new command: perf mem.

$ perf mem -t load rec triad
$ perf mem -t load rep --stdio
# Samples: 19K of event 'cpu/mem-loads/pp'
# Total cost : 1013994
# Sort order : cost,mem,sym,dso,symbol_daddr,dso_daddr,snoop,tlb,locked
#
# Overhead      Samples     Cost  Memory access Symbol      Shared Obj  Data Symbol             Data Object Snoop  TLB access   Locked
# ........  ...........  .......  ............. ..........  ........... ......................  ........... ...... ............ ......
#
     0.10%            1      986  LFB hit       [.] triad   triad       [.] 0x00007f67dffe8038  [unknown]    None  L1 or L2 hit  No    
     0.09%            1      890  LFB hit       [.] triad   triad       [.] 0x00007f67df91a750  [unknown]    None  L1 or L2 hit  No    
     0.08%            1      826  LFB hit       [.] triad   triad       [.] 0x00007f67e288fba8  [unknown]    None  L1 or L2 hit  No    
     0.08%            1      825  LFB hit       [.] triad   triad       [.] 0x00007f67dea28c80  [unknown]    None  L1 or L2 hit  No    
     0.08%            1      787  LFB hit       [.] triad   triad       [.] 0x00007f67df055a60  [unknown]    None  L1 or L2 hit  No    

The perf mem command is a wrapper around perf record/report. It passes the
right options to the report and record commands. Note that the TUI mode is
supported.

One powerful feature of perf is that users can toy with sort order to display
the information in different format or from a different angle. This is particularly
useful with memory sampling:

$ perf mem -t load rep --sort=mem
# Samples: 19K of event 'cpu/mem-loads/pp'
# Total cost : 1013994
# Sort order : mem
#
# Overhead      Samples             Memory access
# ........  ...........  ........................
#
    85.26%        10633  LFB hit                 
     7.35%         8151  L1 hit                  
     3.13%          383  L3 hit                  
     3.09%          195  Local RAM hit           
     1.16%          259  L2 hit                  
     0.00%            4  Uncached hit            

Or if one is interested in the data view:
$ perf mem -t load rep --sort=symbol_daddr,cost
# Samples: 19K of event 'cpu/mem-loads/pp'
# Total cost : 1013994
# Sort order : symbol_daddr,cost
#
# Overhead      Samples             Data Symbol     Cost
# ........  ...........  ......................  .......
#
     0.10%            1  [.] 0x00007f67dffe8038      986
     0.09%            1  [.] 0x00007f67df91a750      890
     0.08%            1  [.] 0x00007f67e288fba8      826


One note on the cost displayed: On Intel processors with PEBS Load Latency, as described
in the SDM, the cost encompasses the number of cycles from dispatch to Globally Observable
(GO) state. That means, that it includes OOO execution. It is not usual to see L1D Hits
with a cost of > 100 cycles. Always look at the memory level for an approximation of the
access penalty, then interpret the cost value accordingly.

There is no cost associated with stores.

CAVEAT: Note that the data addresses are not resolved correctly currently due to a
problem in perf data symbol resolution code which I have not been able to
uncover so far.

In v2, we leverage some of Andi Kleen's Haswell patches, namely the weighted
samples and perf tool event parser fixes. We  also introduce PERF_RECORD_MISC_DATA_MMAP
to tag mmaps for data vs. code. This helps the perf tool distinguish data. vs. code
mmaps (and therefore symbols). We have also integrated the feedback from v1. Note that in
v2 data symbol resolution is not yet fully operational, but there is a slight improvement.


Enjoy,

Signed-off-by: Stephane Eranian <eranian@google.com>


Andi Kleen (2):
  perf, core: Add a concept of a weightened sample
  perf, tools: Add arbitary aliases and support names with -

Stephane Eranian (14):
  perf/x86: improve sysfs event mapping with event string
  perf/x86: add flags to event constraints
  perf: add minimal support for PERF_SAMPLE_WEIGHT
  perf: add support for PERF_SAMPLE_ADDR in dump_sampple()
  perf: add generic memory sampling interface
  perf/x86: add memory profiling via PEBS Load Latency
  perf/x86: export PEBS load latency threshold register to sysfs
  perf/x86: add support for PEBS Precise Store
  perf tools: add mem access sampling core support
  perf report: add support for mem access profiling
  perf record: add support for mem access profiling
  perf tools: add new mem command for memory access profiling
  perf: add PERF_RECORD_MISC_MMAP_DATA to RECORD_MMAP
  perf tools: detect data vs. text mappings

 arch/x86/include/asm/msr-index.h              |    1 +
 arch/x86/kernel/cpu/perf_event.c              |   33 +--
 arch/x86/kernel/cpu/perf_event.h              |   61 ++++-
 arch/x86/kernel/cpu/perf_event_intel.c        |   66 ++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c     |  182 +++++++++++++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    2 +-
 include/linux/perf_event.h                    |    5 +
 include/uapi/linux/perf_event.h               |   74 +++++-
 kernel/events/core.c                          |   15 ++
 tools/perf/Documentation/perf-mem.txt         |   48 ++++
 tools/perf/Makefile                           |    1 +
 tools/perf/builtin-mem.c                      |  238 ++++++++++++++++++
 tools/perf/builtin-record.c                   |    2 +
 tools/perf/builtin-report.c                   |  131 +++++++++-
 tools/perf/builtin.h                          |    1 +
 tools/perf/command-list.txt                   |    1 +
 tools/perf/perf.c                             |    1 +
 tools/perf/perf.h                             |    1 +
 tools/perf/util/event.h                       |    2 +
 tools/perf/util/evsel.c                       |   15 ++
 tools/perf/util/hist.c                        |   66 ++++-
 tools/perf/util/hist.h                        |   13 +
 tools/perf/util/machine.c                     |   10 +-
 tools/perf/util/parse-events.l                |    2 +
 tools/perf/util/session.c                     |   44 ++++
 tools/perf/util/session.h                     |    4 +
 tools/perf/util/sort.c                        |  324 ++++++++++++++++++++++++-
 tools/perf/util/sort.h                        |   10 +-
 tools/perf/util/symbol.h                      |    7 +
 29 files changed, 1312 insertions(+), 48 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-mem.txt
 create mode 100644 tools/perf/builtin-mem.c

-- 
1.7.9.5

