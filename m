Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1B1IXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 03:23:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:40010 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab1B1IXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 03:23:34 -0500
Date: Mon, 28 Feb 2011 08:23:12 GMT
From: tip-bot for Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        arjan@linux.intel.com, acme@ghostprotocols.net, trenn@suse.de,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, acme@ghostprotocols.net, tglx@linutronix.de,
        trenn@suse.de, mingo@elte.hu
In-Reply-To: <1298842606-55712-6-git-send-email-trenn@suse.de>
References: <1298842606-55712-6-git-send-email-trenn@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf timechart: Fix max number of cpus
Message-ID: <tip-54b08f5f90feebc9756d96e0c7bf2fdffe4af7c3@git.kernel.org>
Git-Commit-ID: 54b08f5f90feebc9756d96e0c7bf2fdffe4af7c3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Feb 2011 08:23:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54b08f5f90feebc9756d96e0c7bf2fdffe4af7c3
Gitweb:     http://git.kernel.org/tip/54b08f5f90feebc9756d96e0c7bf2fdffe4af7c3
Author:     Thomas Renninger <trenn@suse.de>
AuthorDate: Sun, 27 Feb 2011 22:36:46 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Feb 2011 08:56:15 +0100

perf timechart: Fix max number of cpus

Currently numcpus is determined in pid_put_sample which is only
called on sched_switch/sched_wakeup sample processing.

On a machine with a lot cpus I often saw the last cpu missing.

Check for (max) numcpus on every event happening and in the
beginning. -> fixes the issue for me.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: lenb@kernel.org
LKML-Reference: <1298842606-55712-6-git-send-email-trenn@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
