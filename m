Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab1LOGXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:23:39 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35942 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab1LOGXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:23:38 -0500
MIME-Version: 1.0
From: Hamo <hamo.by@gmail.com>
Date: Thu, 15 Dec 2011 14:23:16 +0800
Message-ID: <CAO_0yfMXeTz0B2YZHGUHGUFr=SE+-oT=VU5y5agn5N954pPpLw@mail.gmail.com>
Subject: [PATCH] kvm: ensure that debugfs entries have been created
To: avi@redhat.com, mtosatti@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

by checking the return value from kvm_init_debug, we
can ensure that the entries under debugfs for KVM have
been created correctly.

Signed-off-by: Yang Bai <hamo.by@gmail.com>
---
 virt/kvm/kvm_main.c |   26 +++++++++++++++++++++++---
 1 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d9cfb78..a338273 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2612,15 +2612,29 @@ static const struct file_operations *stat_fops[] = {
 	[KVM_STAT_VM]   = &vm_stat_fops,
 };

-static void kvm_init_debug(void)
+static int kvm_init_debug(void)
 {
+	int r = -EFAULT;
 	struct kvm_stats_debugfs_item *p;

 	kvm_debugfs_dir = debugfs_create_dir("kvm", NULL);
-	for (p = debugfs_entries; p->name; ++p)
+	if (kvm_debugfs_dir == NULL)
+		goto out;
+
+	for (p = debugfs_entries; p->name; ++p) {
 		p->dentry = debugfs_create_file(p->name, 0444, kvm_debugfs_dir,
 						(void *)(long)p->offset,
 						stat_fops[p->kind]);
+		if (p->dentry == NULL)
+			goto out_dir;
+	}
+
+	return 0;
+
+out_dir:
+	debugfs_remove_recursive(kvm_debugfs_dir);
+out:
+	return r;
 }

 static void kvm_exit_debug(void)
@@ -2764,10 +2778,16 @@ int kvm_init(void *opaque, unsigned vcpu_size,
unsigned vcpu_align,
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;

-	kvm_init_debug();
+	r = kvm_init_debug();
+	if (r) {
+		printk(KERN_ERR "kvm: create debugfs files failed\n");
+		goto out_undebugfs;
+	}

 	return 0;

+out_undebugfs:
+	unregister_syscore_ops(&kvm_syscore_ops);
 out_unreg:
 	kvm_async_pf_deinit();
 out_free:
-- 
1.7.1
