Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797Ab2JXKI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:08:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55250 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162Ab2JXKIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:08:52 -0400
Date: Wed, 24 Oct 2012 03:07:34 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-3fded963cdae12ff891a55efc866437506c3f912@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, jolsa@redhat.com
In-Reply-To: <1349873598-12583-7-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-7-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix PMU object alias initialization
Git-Commit-ID: 3fded963cdae12ff891a55efc866437506c3f912
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 03:07:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3fded963cdae12ff891a55efc866437506c3f912
Gitweb:     http://git.kernel.org/tip/3fded963cdae12ff891a55efc866437506c3f912
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 10 Oct 2012 14:53:16 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:41:26 +0200

perf tools: Fix PMU object alias initialization

The pmu_lookup should return pmus that do not expose the 'events'
group attribute in sysfs. Also it should fail when any other error
during 'events' lookup is hit (pmu_aliases fails).

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349873598-12583-7-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/util/pmu.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

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
