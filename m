Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab1GTWC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 18:02:26 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:46171 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab1GTWCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 18:02:22 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-doc@vger.kernel.org,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sourav Poddar <sourav.poddar@ti.com>,
        Chris Ball <cjb@laptop.org>, Akinobu Mita <akinobu.mita@gmail.com>,
        J Freyensee <james_p_freyensee@linux.intel.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v3 2/3] mmc: core: add random fault injection
Date: Thu, 21 Jul 2011 00:02:00 +0200
Message-Id: <1311199321-4618-3-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311199321-4618-1-git-send-email-per.forlin@linaro.org>
References: <1311199321-4618-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support to inject data errors after a completed host transfer.
The mmc core will return error even though the host transfer is successful.
This simple fault injection proved to be very useful to test the
non-blocking error handling in the mmc_blk_issue_rw_rq().
Random faults can also test how the host driver handles pre_req()
and post_req() in case of errors.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/core/core.c    |   69 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/core/debugfs.c |    5 +++
 include/linux/mmc/host.h   |    3 ++
 lib/Kconfig.debug          |   11 +++++++
 4 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index ab36c7b..dac2673 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -24,6 +24,11 @@
 #include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
 
+#ifdef CONFIG_FAIL_MMC_REQUEST
+#include <linux/fault-inject.h>
+#include <linux/random.h>
+#endif
+
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/mmc.h>
@@ -82,6 +87,66 @@ static void mmc_flush_scheduled_work(void)
 	flush_workqueue(workqueue);
 }
 
+#ifdef CONFIG_FAIL_MMC_REQUEST
+
+static DECLARE_FAULT_ATTR(fail_mmc_request);
+
+/*
+ * Internal function. Pass the boot param fail_mmc_request to
+ * the setup fault injection attributes routine.
+ */
+static int __init setup_fail_mmc_request(char *str)
+{
+	return setup_fault_attr(&fail_mmc_request, str);
+}
+__setup("fail_mmc_request=", setup_fail_mmc_request);
+
+/*
+ * Internal function. Inject random data errors.
+ * If mmc_data is NULL no errors are injected.
+ */
+static void mmc_should_fail_request(struct mmc_host *host,
+				    struct mmc_request *mrq)
+{
+	struct mmc_command *cmd = mrq->cmd;
+	struct mmc_data *data = mrq->data;
+	static const int data_errors[] = {
+		-ETIMEDOUT,
+		-EILSEQ,
+		-EIO,
+	};
+
+	if (!data)
+		return;
+
+	if (cmd->error || data->error || !host->make_it_fail ||
+	    !should_fail(&fail_mmc_request, data->blksz * data->blocks))
+		return;
+
+	data->error = data_errors[random32() % ARRAY_SIZE(data_errors)];
+	data->bytes_xfered = (random32() % (data->bytes_xfered >> 9)) << 9;
+}
+
+static int __init fail_mmc_request_debugfs(void)
+{
+	return init_fault_attr_dentries(&fail_mmc_request,
+					"fail_mmc_request");
+}
+
+#else /* CONFIG_FAIL_MMC_REQUEST */
+
+static void mmc_should_fail_request(struct mmc_host *host,
+				    struct mmc_request *mrq)
+{
+}
+
+static int __init fail_mmc_request_debugfs(void)
+{
+	return 0;
+}
+#endif /* CONFIG_FAIL_MMC_REQUEST */
+
+
 /**
  *	mmc_request_done - finish processing an MMC request
  *	@host: MMC host which completed request
@@ -108,6 +173,8 @@ void mmc_request_done(struct mmc_host *host, struct mmc_request *mrq)
 		cmd->error = 0;
 		host->ops->request(host, mrq);
 	} else {
+		mmc_should_fail_request(host, mrq);
+
 		led_trigger_event(host->led, LED_OFF);
 
 		pr_debug("%s: req done (CMD%u): %d: %08x %08x %08x %08x\n",
@@ -2064,6 +2131,8 @@ static int __init mmc_init(void)
 	if (ret)
 		goto unregister_host_class;
 
+	fail_mmc_request_debugfs();
+
 	return 0;
 
 unregister_host_class:
diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
index 998797e..588e76f 100644
--- a/drivers/mmc/core/debugfs.c
+++ b/drivers/mmc/core/debugfs.c
@@ -188,6 +188,11 @@ void mmc_add_host_debugfs(struct mmc_host *host)
 				root, &host->clk_delay))
 		goto err_node;
 #endif
+#ifdef CONFIG_FAIL_MMC_REQUEST
+	if (!debugfs_create_u8("make-it-fail", S_IRUSR | S_IWUSR,
+			       root, &host->make_it_fail))
+		goto err_node;
+#endif
 	return;
 
 err_node:
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 771455f..250b46d 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -303,6 +303,9 @@ struct mmc_host {
 
 	struct mmc_async_req	*areq;		/* active async req */
 
+#ifdef CONFIG_FAIL_MMC_REQUEST
+	u8			make_it_fail;
+#endif
 	unsigned long		private[0] ____cacheline_aligned;
 };
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c768bcd..c2d1423 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1057,6 +1057,17 @@ config FAIL_IO_TIMEOUT
 	  Only works with drivers that use the generic timeout handling,
 	  for others it wont do anything.
 
+config FAIL_MMC_REQUEST
+	bool "Fault-injection capability for MMC IO"
+	select DEBUG_FS
+	depends on FAULT_INJECTION && MMC
+	help
+	  Provide fault-injection capability for MMC IO.
+	  This will make the mmc core return data errors. This is
+	  useful to test the error handling in the mmc block device
+	  and to test how the mmc host driver handles retries from
+	  the block device.
+
 config FAULT_INJECTION_DEBUG_FS
 	bool "Debugfs entries for fault-injection capabilities"
 	depends on FAULT_INJECTION && SYSFS && DEBUG_FS
-- 
1.7.4.1

