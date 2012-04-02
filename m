Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab2DBSVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:21:51 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:32546 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754204Ab2DBSUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:20:02 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz936eKzz1202hzz8275dhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1V6X2-02-33H-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 00/12] perf/x86-ibs: Precise event sampling with IBS for AMD CPUs
Date: Mon, 2 Apr 2012 20:19:06 +0200
Message-ID: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for precise event sampling with IBS. It
also contains IBS fixes and updates not directly related to precise
event sampling, but found during testing. There are no changes of perf
tools required, thus this set only contains kernel patches. There will
be also updated perf tools patches available that basically base on my
previous postings to this list and additionally implement IBS pseudo
events.

With IBS there are two counting modes available to count either cycles
or micro-ops. If the corresponding performance counter events (hw
events) are setup with the precise flag set, the request is redirected
to the ibs pmu:

 perf record -a -e cpu-cycles:p ...    # use ibs op counting cycle count
 perf record -a -e r076:p ...          # same as -e cpu-cycles:p
 perf record -a -e r0C1:p ...          # use ibs op counting micro-ops

Each IBS sample contains a linear address that points to the
instruction that was causing the sample to trigger. With ibs we have
skid 0.

Though the skid is 0, we map IBS sampling to following precise levels:

 1: RIP taken from IBS sample or (if invalid) from stack.
 2: RIP always taken from IBS sample, samples with an invalid rip
    are dropped. Thus samples of an event containing two precise
    modifiers (e.g. r076:pp) only contain (precise) addresses
    detected with IBS.

Precise level 3 is reserved for other purposes in the future.

The patches base on a trivial merge of tip/perf/core into
tip/perf/x86-ibs. The merge and also the patches are available here:

The following changes since commit 820b3e44dc22ac8072cd5ecf82d62193392fcca3:

  Merge remote-tracking branch 'tip/perf/core' into HEAD (2012-03-21 19:15:20 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git perf-ibs

-Robert


Robert Richter (12):
  perf/x86-ibs: Fix update of period
  perf: Pass last sampling period to perf_sample_data_init()
  perf/x86-ibs: Enable ibs op micro-ops counting mode
  perf/x86-ibs: Fix frequency profiling
  perf/x86-ibs: Take instruction pointer from ibs sample
  perf/x86-ibs: Precise event sampling with IBS for AMD CPUs
  perf/x86-ibs: Rename some variables
  perf/x86-ibs: Trigger overflow if remaining period is too small
  perf/x86-ibs: Extend hw period that triggers overflow
  perf/x86-ibs: Implement workaround for IBS erratum #420
  perf/x86-ibs: Catch spurious interrupts after stopping ibs
  perf/x86-ibs: Fix usage of IBS op current count

 arch/alpha/kernel/perf_event.c            |    3 +-
 arch/arm/kernel/perf_event_v6.c           |    4 +-
 arch/arm/kernel/perf_event_v7.c           |    4 +-
 arch/arm/kernel/perf_event_xscale.c       |    8 +-
 arch/mips/kernel/perf_event_mipsxx.c      |    2 +-
 arch/powerpc/kernel/perf_event.c          |    3 +-
 arch/powerpc/kernel/perf_event_fsl_emb.c  |    3 +-
 arch/sparc/kernel/perf_event.c            |    4 +-
 arch/x86/include/asm/perf_event.h         |    6 +-
 arch/x86/kernel/cpu/perf_event.c          |    4 +-
 arch/x86/kernel/cpu/perf_event_amd.c      |    7 +-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c  |  274 +++++++++++++++++++++--------
 arch/x86/kernel/cpu/perf_event_intel.c    |    4 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    6 +-
 arch/x86/kernel/cpu/perf_event_p4.c       |    6 +-
 include/linux/perf_event.h                |    5 +-
 kernel/events/core.c                      |    9 +-
 17 files changed, 237 insertions(+), 115 deletions(-)

-- 
1.7.8.4


