Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab0FOHen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:34:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045Ab0FOHek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:34:40 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 07/17] Perform hardware_enable in CPU_STARTING callback
Date: Mon, 14 Jun 2010 21:34:09 -1000
Message-Id: <1276587259-32319-8-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU_STARTING callback was added upstream with the intention
of being used for KVM, specifically for the hardware enablement
that must be done before we can run in hardware virt.  It had
bugs on the x86_64 architecture at the time, where it was called
after CPU_ONLINE.  The arches have since merged and the bug is
gone.

It might be noted other features should probably start making
use of this callback; microcode updates in particular which
might be fixing important erratums would be best applied before
beginning to run user tasks.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 virt/kvm/kvm_main.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 84a0906..01a8876 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1957,10 +1957,10 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 		       cpu);
 		hardware_disable(NULL);
 		break;
-	case CPU_ONLINE:
+	case CPU_STARTING:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);
-		smp_call_function_single(cpu, hardware_enable, NULL, 1);
+		hardware_enable(NULL);
 		break;
 	}
 	return NOTIFY_OK;
@@ -2095,7 +2095,6 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 
 static struct notifier_block kvm_cpu_notifier = {
 	.notifier_call = kvm_cpu_hotplug,
-	.priority = 20, /* must be > scheduler priority */
 };
 
 static int vm_stat_get(void *_offset, u64 *val)
-- 
1.7.1

