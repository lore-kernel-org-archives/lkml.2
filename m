Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab2EBS04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 14:26:56 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:52027
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691Ab2EBS0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 14:26:53 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275dhz2dh668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3ER8K-02-FJC-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 0/7] perf/x86-ibs and tools: Add support for AMD IBS
Date: Wed, 2 May 2012 20:26:25 +0200
Message-ID: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds perf tool support for AMD IBS. Mostly perf tool
patches, but

 perf/x86-ibs: Add support for IBS pseudo events

includes kernel changes.

It basically implements:

 * General perf tool support for dynamically allocated pmus,
 * Support for IBS pseudo events,
 * perf-script support for IBS (updated version).

With this patches there is the possibility to add pmu handler code for
a specific pmu. If a pmu with handler code is listed in sysfs, it is
activated and can be used with perf tools. E.g. perf-list shows
available events of this pmu and the event parser of perf-record is
able to setup profiling for that particular pmu. This mechanism is
used to implement pmus for ibs (ibs_op/ibs_fetch).

IBS pseudo events are derived from an IBS sample and determined
through a combination of one or more IBS event flags or values.
E.g. one could profile mispredicted branches with ibs using such
pseudo events:

 # perf record -a -e ibs_op:MISPREDICTED_BRANCH ...

This is implemented with kernel side filtering of ibs samples by
passing filter settings to the kernel (attr.config1/config2).

I also attached an updated version of my previously posted patch that
implements perf-script support for ibs. This is usefull for a user to
dump raw ibs samples. The script can be used by the user as a basis
for a script that post-processes ibs samples.

Changes can be pulled from kernel.org and are available in the git
repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git perf-ibs

-Robert


Robert Richter (7):
  perf tools: Fix generation of pmu list
  perf tools: Add basic dynamic PMU support
  perf tools: Add parser for dynamic PMU events
  perf/x86-ibs: Add support for IBS pseudo events
  perf, tools: Add raw event support for dynamic allocated pmus
  perf tools: Add pmu mappings to header information
  perf script: Add script to collect and display IBS samples

 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   83 ++++++-
 tools/perf/Makefile                      |    1 +
 tools/perf/scripts/perl/bin/ibs-record   |   23 ++
 tools/perf/scripts/perl/bin/ibs-report   |    6 +
 tools/perf/scripts/perl/ibs.pl           |   47 ++++
 tools/perf/util/header.c                 |   78 ++++++
 tools/perf/util/header.h                 |    1 +
 tools/perf/util/parse-events.c           |   45 +++-
 tools/perf/util/parse-events.h           |    4 +-
 tools/perf/util/parse-events.y           |   11 +-
 tools/perf/util/pmu-ibs.c                |  419 ++++++++++++++++++++++++++++++
 tools/perf/util/pmu.c                    |  102 +++++++-
 tools/perf/util/pmu.h                    |   19 ++
 13 files changed, 828 insertions(+), 11 deletions(-)
 create mode 100644 tools/perf/scripts/perl/bin/ibs-record
 create mode 100644 tools/perf/scripts/perl/bin/ibs-report
 create mode 100644 tools/perf/scripts/perl/ibs.pl
 create mode 100644 tools/perf/util/pmu-ibs.c

-- 
1.7.8.4


