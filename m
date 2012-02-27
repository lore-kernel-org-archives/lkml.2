Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab2B0MKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 07:10:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45467 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab2B0MKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 07:10:03 -0500
Date: Mon, 27 Feb 2012 04:09:11 -0800
From: "tip-bot for Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Message-ID: <tip-8f2f748b0656257153bcf0941df8d6060acc5ca6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        srivatsa.bhat@linux.vnet.ibm.com, prashanth@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        srivatsa.bhat@linux.vnet.ibm.com, prashanth@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4F460D7B.1020703@linux.vnet.ibm.com>
References: <4F460D7B.1020703@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] CPU hotplug, cpusets, suspend: Don'
 t touch cpusets during suspend/resume
Git-Commit-ID: 8f2f748b0656257153bcf0941df8d6060acc5ca6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Feb 2012 04:09:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f2f748b0656257153bcf0941df8d6060acc5ca6
Gitweb:     http://git.kernel.org/tip/8f2f748b0656257153bcf0941df8d6060acc5ca6
Author:     Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
AuthorDate: Thu, 23 Feb 2012 15:27:15 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 27 Feb 2012 11:38:13 +0100

CPU hotplug, cpusets, suspend: Don't touch cpusets during suspend/resume

Currently, during CPU hotplug, the cpuset callbacks modify the cpusets
to reflect the state of the system, and this handling is asymmetric.
That is, upon CPU offline, that CPU is removed from all cpusets. However
when it comes back online, it is put back only to the root cpuset.

This gives rise to a significant problem during suspend/resume. During
suspend, we offline all non-boot cpus and during resume we online them back.
Which means, after a resume, all cpusets (except the root cpuset) will be
restricted to just one single CPU (the boot cpu). But the whole point of
suspend/resume is to restore the system to a state which is as close as
possible to how it was before suspend.

So to fix this, don't touch cpusets during suspend/resume. That is, modify
the cpuset-related CPU hotplug callback to just ignore CPU hotplug when it
is initiated as part of the suspend/resume sequence.

Reported-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/4F460D7B.1020703@linux.vnet.ibm.com
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b342f57..33a0676 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6728,7 +6728,7 @@ int __init sched_create_sysfs_power_savings_entries(struct device *dev)
 static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
 			     void *hcpu)
 {
-	switch (action & ~CPU_TASKS_FROZEN) {
+	switch (action) {
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
 		cpuset_update_active_cpus();
@@ -6741,7 +6741,7 @@ static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
 static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
 			       void *hcpu)
 {
-	switch (action & ~CPU_TASKS_FROZEN) {
+	switch (action) {
 	case CPU_DOWN_PREPARE:
 		cpuset_update_active_cpus();
 		return NOTIFY_OK;
