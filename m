Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1INIrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 04:47:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32799 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab1INIrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 04:47:21 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Akinobu Mita <akinobu.mita@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v2 2/3] mmc: add module param to set fault injection attributes
Date: Wed, 14 Sep 2011 10:46:56 +0200
Message-Id: <1315990017-16912-3-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315990017-16912-1-git-send-email-per.forlin@linaro.org>
References: <1315990017-16912-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace setup("fail_mmc_request") and faulty "ifdef KERNEL" with
a module_param_cb(). The module param mmc_core.fail_request
may be used to set the fault injection attributes during boot time
or module load time.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/core/debugfs.c |   38 ++++++++++++++++++++------------------
 1 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
index 5acd707..d80e234 100644
--- a/drivers/mmc/core/debugfs.c
+++ b/drivers/mmc/core/debugfs.c
@@ -20,6 +20,25 @@
 #include "core.h"
 #include "mmc_ops.h"
 
+#ifdef CONFIG_FAIL_MMC_REQUEST
+
+static DECLARE_FAULT_ATTR(fail_default_attr);
+static char *fail_request;
+static int fail_mmc_request_param_set(const char *val,
+				      const struct kernel_param *kp)
+{
+	setup_fault_attr(&fail_default_attr, (char *) val);
+	return 0;
+}
+
+static const struct kernel_param_ops fail_mmc_request_param_ops = {
+	.set = fail_mmc_request_param_set
+};
+module_param_cb(fail_request, &fail_mmc_request_param_ops,
+		&fail_request, 0);
+
+#endif /* CONFIG_FAIL_MMC_REQUEST */
+
 /* The debugfs functions are optimized away when CONFIG_DEBUG_FS isn't set. */
 static int mmc_ios_show(struct seq_file *s, void *data)
 {
@@ -159,23 +178,6 @@ static int mmc_clock_opt_set(void *data, u64 val)
 	return 0;
 }
 
-#ifdef CONFIG_FAIL_MMC_REQUEST
-
-static DECLARE_FAULT_ATTR(fail_mmc_request);
-
-#ifdef KERNEL
-/*
- * Internal function. Pass the boot param fail_mmc_request to
- * the setup fault injection attributes routine.
- */
-static int __init setup_fail_mmc_request(char *str)
-{
-	return setup_fault_attr(&fail_mmc_request, str);
-}
-__setup("fail_mmc_request=", setup_fail_mmc_request);
-#endif /* KERNEL */
-#endif /* CONFIG_FAIL_MMC_REQUEST */
-
 DEFINE_SIMPLE_ATTRIBUTE(mmc_clock_fops, mmc_clock_opt_get, mmc_clock_opt_set,
 	"%llu\n");
 
@@ -207,7 +209,7 @@ void mmc_add_host_debugfs(struct mmc_host *host)
 		goto err_node;
 #endif
 #ifdef CONFIG_FAIL_MMC_REQUEST
-	host->fail_mmc_request = fail_mmc_request;
+	host->fail_mmc_request = fail_default_attr;
 	if (IS_ERR(fault_create_debugfs_attr("fail_mmc_request",
 					     root,
 					     &host->fail_mmc_request)))
-- 
1.7.4.1

