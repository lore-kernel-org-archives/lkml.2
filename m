Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965307Ab2EOCRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:44 -0400
Received: from mail1.windriver.com ([147.11.146.13]:52758 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822Ab2EOCQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 003/179] CPU hotplug, re-create sysfs directory and symlinks
Date: Mon, 14 May 2012 22:11:39 -0400
Message-ID: <1337048075-6132-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Shin <jacob.shin@amd.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 27ecddc2a9f99ce4ac9a59a0acd77f7100b6d034 upstream.

When we discover CPUs that are affected by each other's
frequency/voltage transitions, the first CPU gets a sysfs directory
created, and rest of the siblings get symlinks. Currently, when we
hotplug off only the first CPU, all of the symlinks and the sysfs
directory gets removed. Even though rest of the siblings are still
online and functional, they are orphaned, and no longer governed by
cpufreq.

This patch, given the above scenario, creates a sysfs directory for
the first sibling and symlinks for the rest of the siblings.

Please note the recursive call, it was rather too ugly to roll it
out. And the removal of redundant NULL setting (it is already taken
care of near the top of the function).

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>
Reviewed-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/cpufreq/cpufreq.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 634757f..cb18598 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1216,12 +1216,28 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 		cpufreq_driver->exit(data);
 	unlock_policy_rwsem_write(cpu);
 
+	cpufreq_debug_enable_ratelimit();
+
+#ifdef CONFIG_HOTPLUG_CPU
+	/* when the CPU which is the parent of the kobj is hotplugged
+	 * offline, check for siblings, and create cpufreq sysfs interface
+	 * and symlinks
+	 */
+	if (unlikely(cpumask_weight(data->cpus) > 1)) {
+		/* first sibling now owns the new sysfs dir */
+		cpumask_clear_cpu(cpu, data->cpus);
+		cpufreq_add_dev(get_cpu_sysdev(cpumask_first(data->cpus)));
+
+		/* finally remove our own symlink */
+		lock_policy_rwsem_write(cpu);
+		__cpufreq_remove_dev(sys_dev);
+	}
+#endif
+
 	free_cpumask_var(data->related_cpus);
 	free_cpumask_var(data->cpus);
 	kfree(data);
-	per_cpu(cpufreq_cpu_data, cpu) = NULL;
 
-	cpufreq_debug_enable_ratelimit();
 	return 0;
 }
 
-- 
1.7.9.6

