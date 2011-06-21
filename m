Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab1FUXlC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:41:02 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65291 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471Ab1FUXkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:40:11 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, Venkatraman S <svenkatr@ti.com>
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v7 10/11] mmc: test: add random fault injection in core.c
Date: Wed, 22 Jun 2011 01:38:40 +0200
Message-Id: <1308699521-20556-11-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308699521-20556-1-git-send-email-per.forlin@linaro.org>
References: <1308699521-20556-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simple fault injection proved to be very useful to
test the error handling in the block.c rw_rq(). It may
still be useful to test if the host driver handle
pre_req() and post_req() correctly in case of errors.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/core/core.c    |   54 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/core/debugfs.c |    5 ++++
 include/linux/mmc/host.h   |    3 ++
 lib/Kconfig.debug          |   11 +++++++++
 4 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index c82fa3b..481c557 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -23,6 +23,8 @@
 #include <linux/log2.h>
 #include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
+#include <linux/fault-inject.h>
+#include <linux/random.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -82,6 +84,56 @@ static void mmc_flush_scheduled_work(void)
 	flush_workqueue(workqueue);
 }
 
+#ifdef CONFIG_FAIL_MMC_REQUEST
+
+static DECLARE_FAULT_ATTR(fail_mmc_request);
+
+static int __init setup_fail_mmc_request(char *str)
+{
+	return setup_fault_attr(&fail_mmc_request, str);
+}
+__setup("fail_mmc_request=", setup_fail_mmc_request);
+
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
+late_initcall(fail_mmc_request_debugfs);
+
+#else /* CONFIG_FAIL_MMC_REQUEST */
+
+static void mmc_should_fail_request(struct mmc_host *host,
+				    struct mmc_request *mrq)
+{
+}
+
+#endif /* CONFIG_FAIL_MMC_REQUEST */
+
+
 /**
  *	mmc_request_done - finish processing an MMC request
  *	@host: MMC host which completed request
@@ -108,6 +160,8 @@ void mmc_request_done(struct mmc_host *host, struct mmc_request *mrq)
 		cmd->error = 0;
 		host->ops->request(host, mrq);
 	} else {
+		mmc_should_fail_request(host, mrq);
+
 		led_trigger_event(host->led, LED_OFF);
 
 		pr_debug("%s: req done (CMD%u): %d: %08x %08x %08x %08x\n",
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
index 8ae44d8..981cbe8 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -302,6 +302,9 @@ struct mmc_host {
 
 	struct mmc_async_req	*areq;		/* active async req */
 
+#ifdef CONFIG_FAIL_MMC_REQUEST
+	u8			make_it_fail;
+#endif
 	unsigned long		private[0] ____cacheline_aligned;
 };
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c768bcd..330fc70 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1057,6 +1057,17 @@ config FAIL_IO_TIMEOUT
 	  Only works with drivers that use the generic timeout handling,
 	  for others it wont do anything.
 
+config FAIL_MMC_REQUEST
+	bool "Fault-injection capability for MMC IO"
+	select DEBUG_FS
+	depends on FAULT_INJECTION
+	help
+	  Provide fault-injection capability for MMC IO.
+	  This will make the mmc core return data errors. This is
+	  useful for testing the error handling in the mmc block device
+	  and how the mmc host driver handle retries from
+	  the block device.
+
 config FAULT_INJECTION_DEBUG_FS
 	bool "Debugfs entries for fault-injection capabilities"
 	depends on FAULT_INJECTION && SYSFS && DEBUG_FS
-- 
1.7.4.1

