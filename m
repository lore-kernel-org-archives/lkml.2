Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2GIUiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:38:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab2GIUiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:38:12 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/6] perf, tool: Fix pmu object alias initialization
Date: Mon,  9 Jul 2012 22:37:47 +0200
Message-Id: <1341866270-4915-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1341866270-4915-1-git-send-email-jolsa@redhat.com>
References: <1341866270-4915-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pmu_lookup should return pmus that do not expose the 'events'
group attribute in sysfs. Also it should fail when any other error
during 'events' lookup is hit (pmu_aliases fails).

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/pmu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 67715a4..3c86022 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -161,7 +161,7 @@ static int pmu_aliases(char *name, struct list_head *head)
 		 "%s/bus/event_source/devices/%s/events", sysfs, name);
 
 	if (stat(path, &st) < 0)
-		return -1;
+		return 0;	 /* no error if 'events' does not exist */
 
 	if (pmu_aliases_parse(path, head))
 		return -1;
@@ -237,6 +237,9 @@ static struct perf_pmu *pmu_lookup(char *name)
 	if (pmu_format(name, &format))
 		return NULL;
 
+	if (pmu_aliases(name, &aliases))
+		return NULL;
+
 	if (pmu_type(name, &type))
 		return NULL;
 
@@ -244,8 +247,6 @@ static struct perf_pmu *pmu_lookup(char *name)
 	if (!pmu)
 		return NULL;
 
-	pmu_aliases(name, &aliases);
-
 	INIT_LIST_HEAD(&pmu->format);
 	INIT_LIST_HEAD(&pmu->aliases);
 	list_splice(&format, &pmu->format);
-- 
1.7.10.4

