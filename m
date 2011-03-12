Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1CLVWn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 16:22:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53696 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037Ab1CLVWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 16:22:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/8] KVM: Use syscore_ops instead of sysdev class and sysdev
Date: Sat, 12 Mar 2011 22:18:51 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>
References: <201103100131.58206.rjw@sisk.pl> <201103122212.40828.rjw@sisk.pl>
In-Reply-To: <201103122212.40828.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103122218.52327.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

KVM uses a sysdev class and a sysdev for executing kvm_suspend()
after interrupts have been turned off on the boot CPU (during system
suspend) and for executing kvm_resume() before turning on interrupts
on the boot CPU (during system resume).  However, since both of these
functions ignore their arguments, the entire mechanism may be
replaced with a struct syscore_ops object which is simpler.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 virt/kvm/kvm_main.c |   34 ++++++++--------------------------
 1 file changed, 8 insertions(+), 26 deletions(-)

Index: linux-2.6/virt/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/virt/kvm/kvm_main.c
+++ linux-2.6/virt/kvm/kvm_main.c
@@ -30,7 +30,7 @@
 #include <linux/debugfs.h>
 #include <linux/highmem.h>
 #include <linux/file.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/cpu.h>
 #include <linux/sched.h>
 #include <linux/cpumask.h>
@@ -2392,33 +2392,26 @@ static void kvm_exit_debug(void)
 	debugfs_remove(kvm_debugfs_dir);
 }
 
-static int kvm_suspend(struct sys_device *dev, pm_message_t state)
+static int kvm_suspend(void)
 {
 	if (kvm_usage_count)
 		hardware_disable_nolock(NULL);
 	return 0;
 }
 
-static int kvm_resume(struct sys_device *dev)
+static void kvm_resume(void)
 {
 	if (kvm_usage_count) {
 		WARN_ON(spin_is_locked(&kvm_lock));
 		hardware_enable_nolock(NULL);
 	}
-	return 0;
 }
 
-static struct sysdev_class kvm_sysdev_class = {
-	.name = "kvm",
+static struct syscore_ops kvm_syscore_ops = {
 	.suspend = kvm_suspend,
 	.resume = kvm_resume,
 };
 
-static struct sys_device kvm_sysdev = {
-	.id = 0,
-	.cls = &kvm_sysdev_class,
-};
-
 struct page *bad_page;
 pfn_t bad_pfn;
 
@@ -2502,14 +2495,6 @@ int kvm_init(void *opaque, unsigned vcpu
 		goto out_free_2;
 	register_reboot_notifier(&kvm_reboot_notifier);
 
-	r = sysdev_class_register(&kvm_sysdev_class);
-	if (r)
-		goto out_free_3;
-
-	r = sysdev_register(&kvm_sysdev);
-	if (r)
-		goto out_free_4;
-
 	/* A kmem cache lets us meet the alignment requirements of fx_save. */
 	if (!vcpu_align)
 		vcpu_align = __alignof__(struct kvm_vcpu);
@@ -2517,7 +2502,7 @@ int kvm_init(void *opaque, unsigned vcpu
 					   0, NULL);
 	if (!kvm_vcpu_cache) {
 		r = -ENOMEM;
-		goto out_free_5;
+		goto out_free_3;
 	}
 
 	r = kvm_async_pf_init();
@@ -2534,6 +2519,8 @@ int kvm_init(void *opaque, unsigned vcpu
 		goto out_unreg;
 	}
 
+	register_syscore_ops(&kvm_syscore_ops);
+
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
 
@@ -2545,10 +2532,6 @@ out_unreg:
 	kvm_async_pf_deinit();
 out_free:
 	kmem_cache_destroy(kvm_vcpu_cache);
-out_free_5:
-	sysdev_unregister(&kvm_sysdev);
-out_free_4:
-	sysdev_class_unregister(&kvm_sysdev_class);
 out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
@@ -2576,8 +2559,7 @@ void kvm_exit(void)
 	misc_deregister(&kvm_dev);
 	kmem_cache_destroy(kvm_vcpu_cache);
 	kvm_async_pf_deinit();
-	sysdev_unregister(&kvm_sysdev);
-	sysdev_class_unregister(&kvm_sysdev_class);
+	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 	on_each_cpu(hardware_disable_nolock, NULL, 1);

