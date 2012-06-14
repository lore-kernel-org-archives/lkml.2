Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab2FNUjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:39:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486Ab2FNUjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:39:12 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] perf tools: Fix generation of pmu list
Date: Thu, 14 Jun 2012 22:38:37 +0200
Message-Id: <1339706321-8802-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1339706321-8802-1-git-send-email-jolsa@redhat.com>
References: <1339706321-8802-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

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
index a119a53..bda0563 100644
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
1.7.7.6

