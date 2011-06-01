Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab1FAJLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:11:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:43823 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161892Ab1FAIPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:15:38 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:10:51 2011
Message-Id: <20110601081050.969989948@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:09:36 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jacob Shin <jacob.shin@amd.com>,
        Mark Langsdorf <mark.langsdorf@amd.com>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [006/165] [CPUFREQ] CPU hotplug, re-create sysfs directory and symlinks
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 2081
Lines: 63

From: Jacob Shin <jacob.shin@amd.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/cpufreq/cpufreq.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1208,12 +1208,28 @@ static int __cpufreq_remove_dev(struct s
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
 


