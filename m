Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab2ECO33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:29:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45704 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab2ECOYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:24:40 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-mmc@vger.kernel.org>, <cjb@laptop.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <arnd.bergmann@linaro.org>,
        <alex.lemberg@sandisk.com>, <ilan.smith@sandisk.com>,
        <lporzio@micron.com>, <rmk+kernel@arm.linux.org.uk>,
        Venkatraman S <svenkatr@ti.com>
Subject: [PATCH v2 11/16] mmc: core: Implement foreground request preemption procedure
Date: Thu, 3 May 2012 19:53:10 +0530
Message-ID: <1336054995-22988-12-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.10.rc2
In-Reply-To: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When invoked, ongoing command at the host controller should abort
and completion should be invoked.

It's quite possible that the interruption will race with the
successful completion of the command. If so, HPI is invoked
only when the low level driver sets an error flag for the
aborted request.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
---
 drivers/mmc/core/core.c  |   32 ++++++++++++++++++++++++++++++++
 include/linux/mmc/core.h |    2 ++
 2 files changed, 34 insertions(+)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 3f0e927..e6430f8 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -466,6 +466,38 @@ out:
 }
 EXPORT_SYMBOL(mmc_interrupt_hpi);
 
+int mmc_preempt_foreground_request(struct mmc_card *card,
+	struct mmc_request *req)
+{
+	int ret;
+
+	ret = mmc_abort_req(card->host, req);
+	if (ret == -ENOSYS)
+		return ret;
+	/*
+	 * Whether or not abort was successful, the command is
+	 * still under the host controller's context.
+	 * Should wait for the completion to be returned.
+	 */
+	wait_for_completion(&req->completion);
+	/*
+	 * Checkpoint the aborted request.
+	 * If error is set, the request completed partially,
+	 * and the ext_csd field "CORRECTLY_PRG_SECTORS_NUM"
+	 * contains the number of blocks written to the device.
+	 * If error is not set, the request was completed
+	 * successfully and there is no need to try it again.
+	 */
+	if (req->data && req->data->error) {
+		mmc_interrupt_hpi(card);
+		/* TODO : Take out the CORRECTLY_PRG_SECTORS_NUM
+		 * from ext_csd and add it to the request */
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(mmc_preempt_foreground_request);
+
 /**
  *	mmc_wait_for_cmd - start a command and wait for completion
  *	@host: MMC host to start command
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index d86144e..e2d55c6 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -144,6 +144,8 @@ extern struct mmc_async_req *mmc_start_req(struct mmc_host *,
 extern int mmc_interrupt_hpi(struct mmc_card *);
 extern void mmc_wait_for_req(struct mmc_host *, struct mmc_request *);
 extern int mmc_wait_for_cmd(struct mmc_host *, struct mmc_command *, int);
+extern int mmc_preempt_foreground_request(struct mmc_card *card,
+	struct mmc_request *req);
 extern int mmc_app_cmd(struct mmc_host *, struct mmc_card *);
 extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
 	struct mmc_command *, int);
-- 
1.7.10.rc2

