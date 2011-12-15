Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab1LOR0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:26:14 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:49185 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227Ab1LOR0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:26:13 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LW99NY-02-0QT-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/4] perf script: Add script to collect and display IBS samples
Date: Thu, 15 Dec 2011 18:23:44 +0100
Message-ID: <1323969824-9711-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
References: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a script to collect and display IBS samples.
There are the following options:

 perf script ibs [ibs_op|ibs_fetch] [-c period] <command>

Examples for usage:

 perf script ibs ibs_op <command>
 perf script ibs ibs_fetch <command>
 perf script record ibs ibs_op -c 500000 <command>
 perf script report ibs
 perf script record ibs ibs_op -c 500000 <command> | perf script report ibs

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/scripts/perl/bin/ibs-record |   23 +++++++++++++++
 tools/perf/scripts/perl/bin/ibs-report |    6 ++++
 tools/perf/scripts/perl/ibs.pl         |   47 ++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/scripts/perl/bin/ibs-record
 create mode 100644 tools/perf/scripts/perl/bin/ibs-report
 create mode 100644 tools/perf/scripts/perl/ibs.pl

diff --git a/tools/perf/scripts/perl/bin/ibs-record b/tools/perf/scripts/perl/bin/ibs-record
new file mode 100644
index 0000000..dc5f4d2
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/ibs-record
@@ -0,0 +1,23 @@
+#! /bin/bash
+
+while [ "${1+defined}" ]; do
+    case $1 in
+	ibs_op|ibs_fetch)
+	    EVENT=$1
+	    shift
+	    break
+	    ;;
+	-*)
+	    REC_OPT+=($1)
+	    shift
+	    ;;
+	*)
+	    echo $0 "$@" >&2
+	    echo "Invalid option: $1" >&2
+	    echo "perf script ibs [ibs_op|ibs_fetch] [-c <period>]" >&2
+	    exit 1
+	    ;;
+    esac
+done
+
+perf record -e ${EVENT:-ibs_op}:r0 -c 100000 -R -a "${REC_OPT[@]}" "$@"
diff --git a/tools/perf/scripts/perl/bin/ibs-report b/tools/perf/scripts/perl/bin/ibs-report
new file mode 100644
index 0000000..f44e69d
--- /dev/null
+++ b/tools/perf/scripts/perl/bin/ibs-report
@@ -0,0 +1,6 @@
+#! /bin/bash
+
+# description: collect and display AMD IBS samples
+# args: [ibs_op|ibs_fetch] [-c period]
+
+perf script -s "$PERF_EXEC_PATH"/scripts/perl/ibs.pl "$@"
diff --git a/tools/perf/scripts/perl/ibs.pl b/tools/perf/scripts/perl/ibs.pl
new file mode 100644
index 0000000..caee32f
--- /dev/null
+++ b/tools/perf/scripts/perl/ibs.pl
@@ -0,0 +1,47 @@
+#
+# ibs.pl - perf script for AMD Instruction Based Sampling
+#
+# Copyright (C) 2011 Advanced Micro Devices, Inc., Robert Richter
+#
+# For licencing details see kernel-base/COPYING
+#
+# description: collect and display AMD IBS samples
+# args: [ibs_op|ibs_fetch] [-c period]
+#
+# examples:
+#
+#  perf script ibs ibs_op <command>
+#  perf script ibs ibs_fetch <command>
+#  perf script record ibs ibs_op -c 500000 <command>
+#  perf script report ibs
+#  perf script record ibs ibs_op -c 500000 <command> | perf script report ibs
+#
+
+# Packed byte string args of process_event():
+#
+# $event:	union perf_event	util/event.h
+# $attr:	struct perf_event_attr	linux/perf_event.h
+# $sample:	struct perf_sample	util/event.h
+# $raw_data:	perf_sample->raw_data	util/event.h
+
+sub process_event
+{
+	my ($event, $attr, $sample, $raw_data) = @_;
+
+	my ($type)		= (unpack("LSS", $event))[0];
+	my ($sample_type)	= (unpack("LLQQQQQLLQQ", $attr))[4];
+	my ($cpu, $raw_size)	= (unpack("QLLQQQQQLL", $sample))[8, 9];
+	my ($caps, @ibs_data)	= unpack("LQ*", $raw_data);
+
+	return if (!$raw_size);		# no raw data
+
+	if (scalar(@ibs_data) ==  3) {
+	        printf("IBS_FETCH sample on cpu%d\tIBS0: 0x%016x IBS1: 0x%016x IBS2:0x%016x\n",
+		       $cpu, @ibs_data);
+	} else {
+	        printf("IBS_OP sample on cpu%d\t" .
+		       "\t IBS0: 0x%016x IBS1: 0x%016x IBS2: 0x%016x\n" .
+		       "\tIBS3: 0x%016x IBS4: 0x%016x IBS5: 0x%016x IBS6: 0x%016x\n",
+		       cpu, @ibs_data);
+	}
+}
-- 
1.7.7


