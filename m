Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933519Ab2GCWB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 18:01:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757344Ab2GCWBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:01:39 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 03/10] perf, tool: Properly free format data
Date: Wed,  4 Jul 2012 00:00:41 +0200
Message-Id: <1341352848-11833-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Release format data in case there's failure during PMU load.

Format data are allocated during PMU lookup. If the lookup
fails in next steps, we dont release the format data.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/pmu.c |   58 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 22 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index f1f83e6..9429ba7 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -15,6 +15,14 @@ extern FILE *perf_pmu_in;
 
 static LIST_HEAD(pmus);
 
+static void pmu_format_release(struct list_head *head)
+{
+	struct perf_pmu__format *format, *h;
+
+	list_for_each_entry_safe(format, h, head, list)
+		free(format);
+}
+
 /*
  * Parse & process all the sysfs attributes located under
  * the directory specified in 'dir' parameter.
@@ -229,32 +237,38 @@ static struct perf_pmu *pmu_lookup(char *name)
 	LIST_HEAD(aliases);
 	__u32 type;
 
-	/*
-	 * The pmu data we store & need consists of the pmu
-	 * type value and format definitions. Load both right
-	 * now.
-	 */
-	if (pmu_format(name, &format))
-		return NULL;
+	do {
+		/*
+		* The pmu data we store & need consists of the pmu
+		* type value, format and events definitions. Load
+		* all of them right now.
+		*/
+		if (pmu_format(name, &format))
+			break;
 
-	if (pmu_aliases(name, &aliases))
-		return NULL;
+		if (pmu_aliases(name, &aliases))
+			break;
 
-	if (pmu_type(name, &type))
-		return NULL;
+		if (pmu_type(name, &type))
+			break;
 
-	pmu = zalloc(sizeof(*pmu));
-	if (!pmu)
-		return NULL;
+		pmu = zalloc(sizeof(*pmu));
+		if (!pmu)
+			break;
 
-	INIT_LIST_HEAD(&pmu->format);
-	INIT_LIST_HEAD(&pmu->aliases);
-	list_splice(&format, &pmu->format);
-	list_splice(&aliases, &pmu->aliases);
-	pmu->name = strdup(name);
-	pmu->type = type;
-	list_add_tail(&pmu->list, &pmus);
-	return pmu;
+		INIT_LIST_HEAD(&pmu->format);
+		INIT_LIST_HEAD(&pmu->aliases);
+		list_splice(&format, &pmu->format);
+		list_splice(&aliases, &pmu->aliases);
+		pmu->name = strdup(name);
+		pmu->type = type;
+		list_add_tail(&pmu->list, &pmus);
+		return pmu;
+
+	} while (0);
+
+	pmu_format_release(&format);
+	return NULL;
 }
 
 static struct perf_pmu *pmu_find(char *name)
-- 
1.7.10.4

