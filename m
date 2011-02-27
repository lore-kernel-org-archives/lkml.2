Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1B0Vg6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 16:36:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab1B0Vgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 16:36:50 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: trenn@suse.de, lenb@kernel.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] perf: timechart -> fix max number of cpus
Date: Sun, 27 Feb 2011 22:36:46 +0100
Message-Id: <1298842606-55712-6-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298842606-55712-1-git-send-email-trenn@suse.de>
References: <1298842606-55712-1-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently numcpus is determined in pid_put_sample which is only
called on sched_switch/sched_wakeup sample processing.

On a machine with a lot cpus I often saw the last cpu missing.

Check for (max) numcpus on every event happening and in the beginning.
-> fixes the issue for me.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: mingo@elte.hu
---
 tools/perf/builtin-timechart.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 746cf03..0ace786 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -264,9 +264,6 @@ pid_put_sample(int pid, int type, unsigned int cpu, u64 start, u64 end)
 		c->start_time = start;
 	if (p->start_time == 0 || p->start_time > start)
 		p->start_time = start;
-
-	if (cpu > numcpus)
-		numcpus = cpu;
 }
 
 #define MAX_CPUS 4096
@@ -511,6 +508,9 @@ static int process_sample_event(event_t *event __used,
 		if (!event_str)
 			return 0;
 
+		if (sample->cpu > numcpus)
+			numcpus = sample->cpu;
+
 		if (strcmp(event_str, "power:cpu_idle") == 0) {
 			struct power_processor_entry *ppe = (void *)te;
 			if (ppe->state == (u32)PWR_EVENT_EXIT)
-- 
1.7.3.4

