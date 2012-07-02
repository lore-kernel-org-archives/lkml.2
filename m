Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013Ab2GBUT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:19:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48111 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932955Ab2GBUTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:19:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/13] perf tools: Fix generation of pmu list
Date: Mon,  2 Jul 2012 17:18:48 -0300
Message-Id: <1341260331-10204-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341260331-10204-1-git-send-email-acme@infradead.org>
References: <1341260331-10204-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
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
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1339706321-8802-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/pmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 74d0948e..67715a4 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -72,7 +72,7 @@ static int pmu_format(char *name, struct list_head *format)
 		 "%s/bus/event_source/devices/%s/format", sysfs, name);
 
 	if (stat(path, &st) < 0)
-		return -1;
+		return 0;	/* no error if format does not exist */
 
 	if (pmu_format_parse(path, format))
 		return -1;
@@ -252,6 +252,7 @@ static struct perf_pmu *pmu_lookup(char *name)
 	list_splice(&aliases, &pmu->aliases);
 	pmu->name = strdup(name);
 	pmu->type = type;
+	list_add_tail(&pmu->list, &pmus);
 	return pmu;
 }
 
-- 
1.7.9.2.358.g22243

