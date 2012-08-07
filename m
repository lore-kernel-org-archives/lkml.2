Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab2HGRsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:48:14 -0400
Received: from mail.x86-64.org ([217.9.48.20]:35583 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab2HGRo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:44:27 -0400
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v0 04/12] x86, microcode: Cleanup cpu hotplug notifier callback
Date: Tue,  7 Aug 2012 19:44:13 +0200
Message-Id: <1344361461-10076-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1344361461-10076-1-git-send-email-bp@amd64.org>
References: <1344361461-10076-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Mask out CPU_TASKS_FROZEN bit so that all _FROZEN cases can be dropped.
Also, add some more comments as to why CPU_ONLINE falls through to
CPU_DOWN_FAILED (no break), and for the CPU_DEAD case. Realign debug
printks better.

Idea blatantly stolen from a tglx patch:
http://marc.info/?l=linux-kernel&m=134267779513862

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_core.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 706a5c9b8eb2..dcde544e012c 100644
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
 
-- 
1.7.11.rc1

