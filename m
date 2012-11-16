Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab2KPPb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:31:58 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:49722 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab2KPPb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:31:56 -0500
From: Trey Ramsay <tramsay@linux.vnet.ibm.com>
To: Chris Ball <cjb@laptop.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        Rich Rattanni <rattanni@gmail.com>,
        Radovan Lekanovic <lekanovic@gmail.com>,
        Trey Ramsay <tramsay@linux.vnet.ibm.com>
Subject: [PATCH 1/1] mmc: Bad device can cause mmc driver to hang
Date: Fri, 16 Nov 2012 09:31:41 -0600
Message-Id: <1353079901-8773-1-git-send-email-tramsay@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <87k3tpkz53.fsf@octavius.laptop.org> (Chris Ball's message of "Tue, 13 Nov 2012 15:48:24 -0500")>
References: <87k3tpkz53.fsf@octavius.laptop.org> (Chris Ball's message of "Tue, 13 Nov 2012 15:48:24 -0500")>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111615-2876-0000-0000-000002155367
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are infinite loops in the mmc code that can be caused by bad hardware.
The code will loop forever if the device never comes back from program mode,
R1_STATE_PRG, and it is not ready for data, R1_READY_FOR_DATA.

A long timeout will be added to prevent the code from looping forever.
The timeout will occur if the device never comes back from program
state or the device never becomes ready for data.

Signed-off-by: Trey Ramsay <tramsay@linux.vnet.ibm.com>
---
 drivers/mmc/card/block.c   |   15 +++++++++++++++
 drivers/mmc/core/core.c    |   18 +++++++++++++++++-
 drivers/mmc/core/mmc_ops.c |   11 +++++++++++
 3 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 172a768..8e60508 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -57,6 +57,7 @@ MODULE_ALIAS("mmc:block");
 #define INAND_CMD38_ARG_SECERASE 0x80
 #define INAND_CMD38_ARG_SECTRIM1 0x81
 #define INAND_CMD38_ARG_SECTRIM2 0x88
+#define MMC_BLK_TIMEOUT_MS  (10 * 60 * 1000)        /* 10 minute timeout */
 
 static DEFINE_MUTEX(block_mutex);
 
@@ -1034,6 +1035,9 @@ static int mmc_blk_err_check(struct mmc_card *card,
 	 */
 	if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
 		u32 status;
+		unsigned long timeout;
+
+		timeout = jiffies + msecs_to_jiffies(MMC_BLK_TIMEOUT_MS);
 		do {
 			int err = get_card_status(card, &status, 5);
 			if (err) {
@@ -1041,6 +1045,17 @@ static int mmc_blk_err_check(struct mmc_card *card,
 				       req->rq_disk->disk_name, err);
 				return MMC_BLK_CMD_ERR;
 			}
+
+			/* Timeout if the device never becomes ready for data
+			 * and never leaves the program state.
+			 */
+			if (time_after(jiffies, timeout)) {
+				pr_err("%s: Card stuck in programming state!"\
+					" %s %s\n", mmc_hostname(card->host),
+					req->rq_disk->disk_name, __func__);
+
+				return MMC_BLK_CMD_ERR;
+			}
 			/*
 			 * Some cards mishandle the status bits,
 			 * so make sure to check both the busy
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 06c42cf..bccfd18 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -42,6 +42,9 @@
 #include "sd_ops.h"
 #include "sdio_ops.h"
 
+/* If the device is not responding */
+#define MMC_CORE_TIMEOUT_MS	(10 * 60 * 1000) /* 10 minute timeout */
+
 /*
  * Background operations can take a long time, depending on the housekeeping
  * operations the card has to perform.
@@ -1631,6 +1634,7 @@ static int mmc_do_erase(struct mmc_card *card, unsigned int from,
 {
 	struct mmc_command cmd = {0};
 	unsigned int qty = 0;
+	unsigned long timeout;
 	int err;
 
 	/*
@@ -1708,6 +1712,7 @@ static int mmc_do_erase(struct mmc_card *card, unsigned int from,
 	if (mmc_host_is_spi(card->host))
 		goto out;
 
+	timeout = jiffies + msecs_to_jiffies(MMC_CORE_TIMEOUT_MS);
 	do {
 		memset(&cmd, 0, sizeof(struct mmc_command));
 		cmd.opcode = MMC_SEND_STATUS;
@@ -1721,8 +1726,19 @@ static int mmc_do_erase(struct mmc_card *card, unsigned int from,
 			err = -EIO;
 			goto out;
 		}
+
+		/* Timeout if the device never becomes ready for data and
+		 * never leaves the program state.
+		 */
+		if (time_after(jiffies, timeout)) {
+			pr_err("%s: Card stuck in programming state! %s\n",
+				mmc_hostname(card->host), __func__);
+			err =  -EIO;
+			goto out;
+		}
+
 	} while (!(cmd.resp[0] & R1_READY_FOR_DATA) ||
-		 R1_CURRENT_STATE(cmd.resp[0]) == R1_STATE_PRG);
+		 (R1_CURRENT_STATE(cmd.resp[0]) == R1_STATE_PRG));
 out:
 	return err;
 }
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index a0e1720..6d8f701 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -21,6 +21,8 @@
 #include "core.h"
 #include "mmc_ops.h"
 
+#define MMC_OPS_TIMEOUT_MS	(10 * 60 * 1000) /* 10 minute timeout */
+
 static int _mmc_select_card(struct mmc_host *host, struct mmc_card *card)
 {
 	int err;
@@ -409,6 +411,7 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 {
 	int err;
 	struct mmc_command cmd = {0};
+	unsigned long timeout;
 	u32 status;
 
 	BUG_ON(!card);
@@ -437,6 +440,7 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 		return 0;
 
 	/* Must check status to be sure of no errors */
+	timeout = jiffies + msecs_to_jiffies(MMC_OPS_TIMEOUT_MS);
 	do {
 		err = mmc_send_status(card, &status);
 		if (err)
@@ -445,6 +449,13 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 			break;
 		if (mmc_host_is_spi(card->host))
 			break;
+
+		/* Timeout if the device never leaves the program state. */
+		if (time_after(jiffies, timeout)) {
+			pr_err("%s: Card stuck in programming state! %s\n",
+				mmc_hostname(card->host), __func__);
+			return -ETIMEDOUT;
+		}
 	} while (R1_CURRENT_STATE(status) == R1_STATE_PRG);
 
 	if (mmc_host_is_spi(card->host)) {
-- 
1.7.1

