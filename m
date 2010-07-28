Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab0G1QkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:40:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39164 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab0G1QkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:40:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uSp7xDP1MVdMDy48+kjP42Dldp/gLxNiR9FXGltEErpFvWc75MnbB5kOJUTtH7GuW0
         Vwyhd4ZmcjdvAO+muf1iAP0PjUNV0EfRrfHEhOLKCYv9ZmEriLcmvCvGKoRg2cZo0/WH
         rPiy08yojQgMbFRQZPCbPH8kqWHQZQDUgbcfY=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] x86: mce: fix error handling
Date: Wed, 28 Jul 2010 20:39:44 +0400
Message-Id: <1280335185-23265-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mcheck_init_device() poorly handles errors. If any request fails
unregister and free everything.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index ed41562..a1119f1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2124,22 +2124,38 @@ static __init int mcheck_init_device(void)
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
-	zalloc_cpumask_var(&mce_dev_initialized, GFP_KERNEL);
+	if (!zalloc_cpumask_var(&mce_dev_initialized, GFP_KERNEL))
+		return -ENOMEM;
 
 	mce_init_banks();
 
 	err = sysdev_class_register(&mce_sysclass);
 	if (err)
-		return err;
+		goto err_free_cpumask_var;
 
 	for_each_online_cpu(i) {
 		err = mce_create_device(i);
 		if (err)
-			return err;
+			goto mce_remove_devices;
 	}
 
 	register_hotcpu_notifier(&mce_cpu_notifier);
-	misc_register(&mce_log_device);
+	err = misc_register(&mce_log_device);
+	if (err)
+		goto err_unreg_notifier;
+	return 0;
+
+err_unreg_notifier:
+	unregister_hotcpu_notifier(&mce_cpu_notifier);
+
+mce_remove_devices:
+	for_each_online_cpu(i)
+		mce_remove_device(i);
+
+	sysdev_class_unregister(&mce_sysclass);
+
+err_free_cpumask_var:
+	free_cpumask_var(mce_dev_initialized);
 
 	return err;
 }
-- 
1.7.0.4

