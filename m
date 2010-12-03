Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab0LCMSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 07:18:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:3119 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419Ab0LCMSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 07:18:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,292,1288594800"; 
   d="scan'208,223";a="356596575"
Date: Fri, 3 Dec 2010 20:14:43 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, akpm@linux-foundation.org,
        arjan@linux.intel.com, alan@linux.intel.com, kmpark@infradead.org
Subject: [PATCH v2 4/4]use HPI to interrupt BKOPS
Message-ID: <20101203121443.GE18655@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d759e4606c498c63cbeae2ed00adf6c289acac6f Mon Sep 17 00:00:00 2001
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
Date: Fri, 3 Dec 2010 19:34:15 +0800
Subject: [PATCH 4/4] mmc: Add HPI operation to interrupt BKOPS

Before start a new user request, driver need to wait until the
BKOPS finished, or use HPI to interrupt the BKOPS since user request
has a higher priority than BKOPS.

This patch can let driver use HPI command to interrupt BKOPS.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/core/core.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 4190424..4ac6c56 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -202,6 +202,51 @@ static void mmc_wait_done(struct mmc_request *mrq)
 }
 
 /**
+ *	mmc_issue_hpi_cmd - start a hpi to interrupt background
+ *	operations
+ *	@card: MMC card need to interrupt
+ *
+ *  start MMC_SEND_STATUS/MMC_STOP_TRANSMISSION to stop the
+ *  background operations.
+ *
+ *  return value:
+ *  0: successfully interrupt BKOPS
+ *  -EINVAL: HPI command invalid
+ *  -EIO: failed when interrupt BKOPS
+ */
+static int mmc_issue_hpi_cmd(struct mmc_card *card)
+{
+	struct mmc_command cmd;
+	unsigned int opcode;
+	unsigned int flags;
+	int err;
+
+	opcode = card->ext_csd.hpi_cmd;
+	if (opcode == MMC_STOP_TRANSMISSION)
+		flags = MMC_RSP_R1B | MMC_CMD_AC;
+	else if (opcode == MMC_SEND_STATUS)
+		flags = MMC_RSP_R1 | MMC_CMD_AC;
+	else
+		return -EINVAL;
+
+	memset(&cmd, 0, sizeof(struct mmc_command));
+	cmd.opcode = opcode;
+	cmd.arg = card->rca << 16 | 1;
+	cmd.flags = flags;
+	err = mmc_wait_for_cmd(card->host, &cmd, 0);
+	if (err || (cmd.resp[0] & R1_ERROR_RESPONSE)) {
+		printk(KERN_ERR "error %d requesting status %#x\n",
+			err, cmd.resp[0]);
+		/*
+		 * abandon this BKOPS, let block layer handle
+		 * this
+		 */
+		return -EIO;
+	}
+	return 0;
+}
+
+/**
  *	mmc_wait_for_bkops- start a bkops check and wait for
  *	completion
  *	@card: MMC card need to check
@@ -224,9 +269,14 @@ retry:
 
 	if (card->ext_csd.hpi_en) {
 		/*
-		 * TODO
 		 * HPI to interrupt BKOPS if supported
 		 */
+		err = mmc_issue_hpi_cmd(card);
+		if (err == -EINVAL) {
+			/* disable HPI feature */
+			card->ext_csd.hpi_en = 0;
+			goto retry;
+		}
 	} else {
 		memset(&cmd, 0, sizeof(struct mmc_command));
 
-- 
1.6.6.1

