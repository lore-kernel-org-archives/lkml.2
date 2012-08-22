Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab2HVXju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:39:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47473 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab2HVXjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:39:46 -0400
Date: Wed, 22 Aug 2012 16:39:31 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-09c3f0d883300c8fc2bb62e9a70cf89a2ada9a80@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
In-Reply-To: <1344361461-10076-5-git-send-email-bp@amd64.org>
References: <1344361461-10076-5-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode:
  Cleanup cpu hotplug notifier callback
Git-Commit-ID: 09c3f0d883300c8fc2bb62e9a70cf89a2ada9a80
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 16:39:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  09c3f0d883300c8fc2bb62e9a70cf89a2ada9a80
Gitweb:     http://git.kernel.org/tip/09c3f0d883300c8fc2bb62e9a70cf89a2ada9a80
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Mon, 23 Jul 2012 20:15:10 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 22 Aug 2012 16:14:52 -0700

x86, microcode: Cleanup cpu hotplug notifier callback

Mask out CPU_TASKS_FROZEN bit so that all _FROZEN cases can be dropped.
Also, add some more comments as to why CPU_ONLINE falls through to
CPU_DOWN_FAILED (no break), and for the CPU_DEAD case. Realign debug
printks better.

Idea blatantly stolen from a tglx patch:
http://marc.info/?l=linux-kernel&m=134267779513862

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1344361461-10076-5-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/microcode_core.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 706a5c9..dcde544 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -470,34 +470,41 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 	struct device *dev;
 
 	dev = get_cpu_device(cpu);
-	switch (action) {
+
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		microcode_update_cpu(cpu);
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
 		pr_debug("CPU%d added\n", cpu);
+		/*
+		 * "break" is missing on purpose here because we want to fall
+		 * through in order to create the sysfs group.
+		 */
+
+	case CPU_DOWN_FAILED:
 		if (sysfs_create_group(&dev->kobj, &mc_attr_group))
 			pr_err("Failed to create group for CPU%d\n", cpu);
 		break;
+
 	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
 		/* Suspend is in progress, only remove the interface */
 		sysfs_remove_group(&dev->kobj, &mc_attr_group);
 		pr_debug("CPU%d removed\n", cpu);
 		break;
 
 	/*
+	 * case CPU_DEAD:
+	 *
 	 * When a CPU goes offline, don't free up or invalidate the copy of
 	 * the microcode in kernel memory, so that we can reuse it when the
 	 * CPU comes back online without unnecessarily requesting the userspace
 	 * for it again.
 	 */
-	case CPU_UP_CANCELED_FROZEN:
-		/* The CPU refused to come up during a system resume */
-		microcode_fini_cpu(cpu);
-		break;
 	}
+
+	/* The CPU refused to come up during a system resume */
+	if (action == CPU_UP_CANCELED_FROZEN)
+		microcode_fini_cpu(cpu);
+
 	return NOTIFY_OK;
 }
 
