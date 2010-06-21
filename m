Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab0FUVxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:53:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:55795 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522Ab0FUVxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:53:47 -0400
Message-ID: <4C1FDF5B.1040301@kernel.org>
Date: Mon, 21 Jun 2010 23:53:31 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>
Subject: [PATCH sched/core] sched,cpuset: drop __cpuexit from cpu hotplug
 callbacks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 21 Jun 2010 21:53:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3a101d05 (sched: adjust when cpu_active and cpuset
configurations are updated during cpu on/offlining) added hotplug
notifiers marked with __cpuexit; however, ia64 drops text in __cpuexit
during link unlike x86.  This means that functions which are
referenced during init but used only for cpu hot unplugging afterwards
shouldn't be marked with __cpuexit.  Drop __cpuexit from those
functions.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Tony Luck <tony.luck@intel.com>
---
This seems to work fine here but it would be nice if you can confirm
this.  Thanks.

 kernel/cpuset.c |    2 +-
 kernel/sched.c  |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 05727dc..7146793 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2118,7 +2118,7 @@ static void scan_for_empty_cpusets(struct cpuset *root)
  * Called within get_online_cpus().  Needs to call cgroup_lock()
  * before calling generate_sched_domains().
  */
-void __cpuexit cpuset_update_active_cpus(void)
+void cpuset_update_active_cpus(void)
 {
 	struct sched_domain_attr *attr;
 	cpumask_var_t *doms;
diff --git a/kernel/sched.c b/kernel/sched.c
index b4427cc..9064e7d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7477,8 +7477,8 @@ int __init sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
  * disabled, cpuset_update_active_cpus() becomes a simple wrapper
  * around partition_sched_domains().
  */
-static int __cpuexit cpuset_cpu_active(struct notifier_block *nfb,
-				       unsigned long action, void *hcpu)
+static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
+			     void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
@@ -7490,8 +7490,8 @@ static int __cpuexit cpuset_cpu_active(struct notifier_block *nfb,
 	}
 }

-static int __cpuexit cpuset_cpu_inactive(struct notifier_block *nfb,
-					 unsigned long action, void *hcpu)
+static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
+			       void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
