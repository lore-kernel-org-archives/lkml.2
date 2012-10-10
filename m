Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab2JJMyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:54:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab2JJMyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:54:17 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 6/8] perf tools: Fix pmu object alias initialization
Date: Wed, 10 Oct 2012 14:53:16 +0200
Message-Id: <1349873598-12583-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pmu_lookup should return pmus that do not expose the 'events'
group attribute in sysfs. Also it should fail when any other error
during 'events' lookup is hit (pmu_aliases fails).

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/pmu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 8a2229d..18e8480 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -164,7 +164,7 @@ static int pmu_aliases(char *name, struct list_head *head)
 		 "%s/bus/event_source/devices/%s/events", sysfs, name);
 
 	if (stat(path, &st) < 0)
-		return -1;
+		return 0;	 /* no error if 'events' does not exist */
 
 	if (pmu_aliases_parse(path, head))
 		return -1;
@@ -296,6 +296,9 @@ static struct perf_pmu *pmu_lookup(char *name)
 	if (pmu_format(name, &format))
 		return NULL;
 
+	if (pmu_aliases(name, &aliases))
+		return NULL;
+
 	if (pmu_type(name, &type))
 		return NULL;
 
@@ -305,8 +308,6 @@ static struct perf_pmu *pmu_lookup(char *name)
 
 	pmu->cpus = pmu_cpumask(name);
 
-	pmu_aliases(name, &aliases);
-
 	INIT_LIST_HEAD(&pmu->format);
 	INIT_LIST_HEAD(&pmu->aliases);
 	list_splice(&format, &pmu->format);
-- 
1.7.11.4

