Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab2GFK7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:59:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51492 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab2GFK7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:59:35 -0400
Date: Fri, 6 Jul 2012 03:58:57 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-9bc8f9fe2c6e3778202c76ef85ef291567c00cb8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, robert.richter@amd.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, robert.richter@amd.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1339706321-8802-3-git-send-email-jolsa@redhat.com>
References: <1339706321-8802-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix generation of pmu list
Git-Commit-ID: 9bc8f9fe2c6e3778202c76ef85ef291567c00cb8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 03:59:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9bc8f9fe2c6e3778202c76ef85ef291567c00cb8
Gitweb:     http://git.kernel.org/tip/9bc8f9fe2c6e3778202c76ef85ef291567c00cb8
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 14 Jun 2012 22:38:37 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 29 Jun 2012 13:31:27 -0300

perf tools: Fix generation of pmu list

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
 1 files changed, 2 insertions(+), 1 deletions(-)

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
 
