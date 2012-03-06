Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031081Ab2CFUpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 15:45:36 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46005 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030986Ab2CFUpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:45:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.204.154.20 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH bisected regression] sched: rebuild sched domains at
 suspend/resume
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Wed, 07 Mar 2012 00:45:29 +0400
Message-ID: <20120306204357.13169.90791.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is fix for suspend/resume regression introduced in commit 8f2f748b0656
("CPU hotplug, cpusets, suspend: Don't touch cpusets during suspend/resume")
Without this patch suspend always hangs on my thinkpad x220 (2 x CPU * HT).

cpuset_update_active_cpus() not only juggles with bits in cpusets,
it also calls sched-domains rebuilding after all.

This patch restores sched-domain rebuilds, as it was before that commit.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 kernel/sched/core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9995eb0..0fb7406 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6732,6 +6732,10 @@ static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
 	case CPU_DOWN_FAILED:
 		cpuset_update_active_cpus();
 		return NOTIFY_OK;
+	case CPU_ONLINE_FROZEN:
+	case CPU_DOWN_FAILED_FROZEN:
+		rebuild_sched_domains();
+		return NOTIFY_OK;
 	default:
 		return NOTIFY_DONE;
 	}
@@ -6744,6 +6748,9 @@ static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
 	case CPU_DOWN_PREPARE:
 		cpuset_update_active_cpus();
 		return NOTIFY_OK;
+	case CPU_DOWN_PREPARE_FROZEN:
+		rebuild_sched_domains();
+		return NOTIFY_OK;
 	default:
 		return NOTIFY_DONE;
 	}

