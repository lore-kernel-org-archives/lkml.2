Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab1IMVEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 17:04:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38055 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab1IMVEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 17:04:30 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Akinobu Mita <akinobu.mita@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH 2/3] mmc: add module param to set fault injection attributes
Date: Tue, 13 Sep 2011 23:03:29 +0200
Message-Id: <1315947810-22714-3-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315947810-22714-1-git-send-email-per.forlin@linaro.org>
References: <1315947810-22714-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace setup("fail_mmc_request") and faulty "ifdef KERNEL" with
a simple module_param(). The module param mmc_core.fail_request
may be used to set the fault injection attributes during boot time
or module load time.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/core/debugfs.c |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
index 5acd707..bb72ba2 100644
--- a/drivers/mmc/core/debugfs.c
+++ b/drivers/mmc/core/debugfs.c
@@ -20,6 +20,14 @@
 #include "core.h"
 #include "mmc_ops.h"
 
+#ifdef CONFIG_FAIL_MMC_REQUEST
+
+static DECLARE_FAULT_ATTR(fail_default_attr);
+static char *fail_request;
+module_param(fail_request, charp, 0);
+
+#endif /* CONFIG_FAIL_MMC_REQUEST */
+
 /* The debugfs functions are optimized away when CONFIG_DEBUG_FS isn't set. */
 static int mmc_ios_show(struct seq_file *s, void *data)
 {
@@ -159,23 +167,6 @@ static int mmc_clock_opt_set(void *data, u64 val)
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
 
@@ -207,7 +198,9 @@ void mmc_add_host_debugfs(struct mmc_host *host)
 		goto err_node;
 #endif
 #ifdef CONFIG_FAIL_MMC_REQUEST
-	host->fail_mmc_request = fail_mmc_request;
+	if (fail_request)
+		setup_fault_attr(&fail_default_attr, fail_request);
+	host->fail_mmc_request = fail_default_attr;
 	if (IS_ERR(fault_create_debugfs_attr("fail_mmc_request",
 					     root,
 					     &host->fail_mmc_request)))
-- 
1.7.4.1

