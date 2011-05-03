Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab1ECWrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:47:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:39653 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab1ECWra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:47:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,312,1301900400"; 
   d="scan'208";a="741871656"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>, "Tony Luck" <tony.luck@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 2/2] x86/kernel/cpu/mcheck/mce.c: Interfaces for mce inject driver exit
Date: Tue,  3 May 2011 15:34:40 -0700
Message-Id: <1304462080-3358-3-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1304462080-3358-1-git-send-email-fenghua.yu@intel.com>
References: <1304462080-3358-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Provide mce_write register and unregister interfaces for mce inject driver to
call. The interfaces take care of race condition for mce write.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/mce.h       |    3 ++-
 arch/x86/kernel/cpu/mcheck/mce.c |   35 +++++++++++++++++++++++++++++++++--
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index eb16e94..0b777c4 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -198,7 +198,6 @@ int mce_notify_irq(void);
 void mce_notify_process(void);
 
 DECLARE_PER_CPU(struct mce, injectm);
-extern struct file_operations mce_chrdev_ops;
 
 /*
  * Exception handler
@@ -240,5 +239,7 @@ struct cper_sec_mem_err;
 extern void apei_mce_report_mem_error(int corrected,
 				      struct cper_sec_mem_err *mem_err);
 
+extern void mce_write_register(void *mce_write_inject);
+extern void mce_write_unregister(void);
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_MCE_H */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 3385ea2..9f0bbcc 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -50,6 +50,7 @@
 #include "mce-internal.h"
 
 static DEFINE_MUTEX(mce_read_mutex);
+static DEFINE_MUTEX(mce_write_mutex);
 
 #define rcu_dereference_check_mce(p) \
 	rcu_dereference_index_check((p), \
@@ -1539,6 +1540,36 @@ static int __mce_read_apei(char __user **ubuf, size_t usize)
 	return 0;
 }
 
+static ssize_t (*_mce_write)(struct file *filp, const char __user *ubuf,
+			 size_t usize, loff_t *off);
+void mce_write_register(void *mce_write_inject)
+{
+	mutex_lock(&mce_write_mutex);
+	_mce_write = mce_write_inject;
+	mutex_unlock(&mce_write_mutex);
+}
+EXPORT_SYMBOL(mce_write_register);
+
+void mce_write_unregister(void)
+{
+	mutex_lock(&mce_write_mutex);
+	_mce_write = 0;
+	mutex_unlock(&mce_write_mutex);
+}
+EXPORT_SYMBOL(mce_write_unregister);
+
+static ssize_t mce_write(struct file *filp, const char __user *ubuf,
+			 size_t usize, loff_t *off)
+{
+	ssize_t ret = 0;
+
+	mutex_lock(&mce_write_mutex);
+	if (_mce_write)
+		ret = _mce_write(filp, ubuf, usize, off);
+	mutex_unlock(&mce_write_mutex);
+	return ret;
+}
+
 static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 			loff_t *off)
 {
@@ -1659,11 +1690,11 @@ static long mce_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 	}
 }
 
-/* Modified in mce-inject.c, so not static or const */
-struct file_operations mce_chrdev_ops = {
+static const struct file_operations mce_chrdev_ops = {
 	.open			= mce_open,
 	.release		= mce_release,
 	.read			= mce_read,
+	.write			= mce_write,
 	.poll			= mce_poll,
 	.unlocked_ioctl		= mce_ioctl,
 	.llseek		= no_llseek,
-- 
1.7.2

