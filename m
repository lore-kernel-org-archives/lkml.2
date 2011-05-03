Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab1ECWrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:47:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:39653 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab1ECWra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:47:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,312,1301900400"; 
   d="scan'208";a="741871651"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>, "Tony Luck" <tony.luck@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 1/2] x86/kernel/cpu/mcheck/mce-inject.c: Add mce inject driver exit
Date: Tue,  3 May 2011 15:34:39 -0700
Message-Id: <1304462080-3358-2-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1304462080-3358-1-git-send-email-fenghua.yu@intel.com>
References: <1304462080-3358-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Gracefully remove mce_inject driver. This avoids rebooting machine if one wants
to release the driver. It makes the driver more useful for debugging mce issues
or debugging the driver itself. And the mce code is more clean and reasonable.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 0ed633c..9966a61 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -179,7 +179,7 @@ static void raise_mce(struct mce *m)
 }
 
 /* Error injection interface */
-static ssize_t mce_write(struct file *filp, const char __user *ubuf,
+static ssize_t mce_write_inject(struct file *filp, const char __user *ubuf,
 			 size_t usize, loff_t *off)
 {
 	struct mce m;
@@ -210,17 +210,25 @@ static ssize_t mce_write(struct file *filp, const char __user *ubuf,
 	return usize;
 }
 
-static int inject_init(void)
+static int __init inject_init(void)
 {
 	if (!alloc_cpumask_var(&mce_inject_cpumask, GFP_KERNEL))
 		return -ENOMEM;
 	printk(KERN_INFO "Machine check injector initialized\n");
-	mce_chrdev_ops.write = mce_write;
+	mce_write_register(mce_write_inject);
 	register_die_notifier(&mce_raise_nb);
 	return 0;
 }
 
+static void __exit inject_exit(void)
+{
+	mce_write_unregister();
+	unregister_die_notifier(&mce_raise_nb);
+	free_cpumask_var(mce_inject_cpumask);
+}
+
 module_init(inject_init);
+module_exit(inject_exit);
 /*
  * Cannot tolerate unloading currently because we cannot
  * guarantee all openers of mce_chrdev will get a reference to us.
-- 
1.7.2

