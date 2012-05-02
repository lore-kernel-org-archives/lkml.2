Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab2EBS0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 14:26:52 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:8672 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691Ab2EBS0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 14:26:51 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3ER8L-01-6JT-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/7] perf tools: Fix generation of pmu list
Date: Wed, 2 May 2012 20:26:26 +0200
Message-ID: <1335983192-23731-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The internal pmu list was never used. With each perf_pmu__find() call
the pmu structure was created new by parsing sysfs. Beside this it
caused memory leaks. We now keep all pmus by adding them to the list.

Also, pmu_lookup() should return pmus that do not expose the format
specifier in sysfs.

We need a valid internal pmu list in a later patch to iterate over all
pmus that exist in the system.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/pmu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index cb08a11..480c448 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -72,7 +72,7 @@ static int pmu_format(char *name, struct list_head *format)
 		 "%s/bus/event_source/devices/%s/format", sysfs, name);
 
 	if (stat(path, &st) < 0)
-		return -1;
+		return 0;	/* no error if format does not exist */
 
 	if (pmu_format_parse(path, format))
 		return -1;
@@ -139,6 +139,7 @@ static struct perf_pmu *pmu_lookup(char *name)
 	list_splice(&format, &pmu->format);
 	pmu->name = strdup(name);
 	pmu->type = type;
+	list_add_tail(&pmu->list, &pmus);
 	return pmu;
 }
 
-- 
1.7.8.4


