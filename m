Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290Ab1LORaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:30:14 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:58992 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1LORaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:30:12 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dh668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LW99NX-02-0QQ-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 0/4] perf tools: Add support for IBS
Date: Thu, 15 Dec 2011 18:23:40 +0100
Message-ID: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds perf tool support for IBS. It is related to the
kernel patches I sent out recently.

IBS is implemented using dynamic pmu allocation. Thus, esp. event
selection and sample encoding requires handling of dynamically
generated pmu identifiers that can be queried in sysfs. For ibs there
exists 2 pmus:

 /sys/bus/event_source/devices/ibs_op/type
 /sys/bus/event_source/devices/ibs_fetch/type

Lin's patch implements a new syntax to specify events of dynamically
allocated pmus. This can be used to specify ibs events for perf
record, etc., for example:

 perf record -e ibs_op:r0 -c 100000 -R -a <command>
 perf record -e ibs_fetch:r0 -c 100000 -R -a <command>

With patch #2 dynamically generated pmu mappings are added to the
perf.data header. This information is required to decode samples and
to find the originating pmu it is comming from. Since the information
in sysfs may change we need to store it in the header.

A generic perl handler is added to process IBS events with perf
script. There was only support for tracepoints. The following perf
script commands can be used to collect and display IBS samples:

 perf script ibs ibs_op <command>
 perf script ibs ibs_fetch <command>
 perf script record ibs ibs_op -c 500000 <command>
 perf script report ibs
 perf script record ibs ibs_op -c 500000 <command> | perf script report ibs

-Robert


Lin Ming (1):
  perf tool: Parse general/raw events from sysfs

Robert Richter (3):
  perf tools: Add pmu mappings to header information
  perf script: Add generic perl handler to process events
  perf script: Add script to collect and display IBS samples

 tools/perf/scripts/perl/bin/ibs-record             |   23 +++++
 tools/perf/scripts/perl/bin/ibs-report             |    6 +
 tools/perf/scripts/perl/ibs.pl                     |   47 +++++++++
 tools/perf/util/header.c                           |   99 ++++++++++++++++++++
 tools/perf/util/header.h                           |    1 +
 tools/perf/util/parse-events.c                     |   84 ++++++++++++++++-
 .../perf/util/scripting-engines/trace-event-perl.c |   73 +++++++++++++-
 7 files changed, 325 insertions(+), 8 deletions(-)
 create mode 100644 tools/perf/scripts/perl/bin/ibs-record
 create mode 100644 tools/perf/scripts/perl/bin/ibs-report
 create mode 100644 tools/perf/scripts/perl/ibs.pl

-- 
1.7.7


