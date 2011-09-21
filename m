Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1IUK6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 06:58:39 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:26017 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab1IUK6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 06:58:37 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRVD2B-01-0V3-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
Date: Wed, 21 Sep 2011 11:30:16 +0200
Message-ID: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.6.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for AMD IBS to perf. It is a new
implementation and unrelated to my previous postings last year. The
main differences are:

* separate and independent from x86 perfctrs, IBS could be used
  without the x86 pmu,
* using dynamic pmu allocation, userspace uses sysfs to select the pmu,
* support for 64 bit counters,
* libperf based example code,
* shared IBS initialziation code for perf and oprofile.

The approach is still to collect raw sample data which should be the
most important use case for application developers. The data format is
the same as described in the IBS register specification.

Future work could be:

* better integration into the perf tool, use IBS for generic events
  where possible,
* support of the precise event sampling perf i/f,
* implementation of extended IBS features (e.g. ext. counter width),
* support of counting (perf stat),
* in-kernel IBS event parsing,
* IBS tracepoint support.

Changes for V2:

    * Remove printks in pmu function stubs.
    * Modify perf_event_ibs_init() to use ibs_caps directly.
    * Added bit mask for msr offsets.
    * Added caps field to raw sample format.
    * Added caps check for IBS_OP_CUR_CNT emulation.
    * Updated include header files to fix build errors on some distros.
    * Note: I kept example code for reference, the patch must not be
      applied. I will come up with a sulution that integrates IBS into
      perf-report.

Changes for V3 (only patch #3 modified):

    * rebased on Don's NMI V5 patch set
    * disable per-task monitoring (mark pmu with perf_invalid_context),
      per-task monitoring can be added in a separate patch

-Robert


Robert Richter (7):
      perf, x86: share IBS macros between perf and oprofile
      perf, x86: Implement IBS initialization
      perf, x86: Implement IBS event configuration
      perf, x86: Implement IBS interrupt handler
      perf, x86: Implement IBS pmu control ops
      perf, x86: Implement 64 bit counter support for IBS
      perf, x86: Example code for AMD IBS

 arch/x86/include/asm/msr-index.h           |    5 +
 arch/x86/include/asm/perf_event.h          |   42 ++-
 arch/x86/kernel/cpu/Makefile               |    2 +-
 arch/x86/kernel/cpu/perf_event_amd.c       |    4 +-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c   |  716 ++++++++++++++++++++++++++++
 arch/x86/oprofile/nmi_int.c                |    2 -
 arch/x86/oprofile/op_model_amd.c           |  234 +---------
 arch/x86/oprofile/op_x86_model.h           |    1 -
 tools/perf/Documentation/examples/Makefile |   44 ++
 tools/perf/Documentation/examples/ibs.c    |  445 +++++++++++++++++
 10 files changed, 1255 insertions(+), 240 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_ibs.c
 create mode 100644 tools/perf/Documentation/examples/Makefile
 create mode 100644 tools/perf/Documentation/examples/ibs.c




