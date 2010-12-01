Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab0LAMxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 07:53:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:50167 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab0LAMxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 07:53:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,283,1288594800"; 
   d="scan'208,223";a="631973319"
Date: Wed, 1 Dec 2010 20:49:52 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, arjan@linux.intel.com,
        alan@linux.intel.com, akpm@linux-foundation.org
Subject: [PATCH v4 4/4]do HW reset after each reading/writing/erasing
Message-ID: <20101201124952.GE5421@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0d704091ba1797eaba34230ac920866e68d1b21d Mon Sep 17 00:00:00 2001
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
Date: Wed, 1 Dec 2010 20:24:00 +0800
Subject: [PATCH 4/4] add HW reset after each read/write/erase

Driver can do a HW reset for eMMC card if read/write/erase
occures timeout error.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/card/block.c |   10 ++++++++++
 drivers/mmc/core/core.c  |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 217f820..c50f94b 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -424,6 +424,16 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 
 		mmc_wait_for_req(card->host, &brq.mrq);
 
+		/*
+		 * Check if need to do HW reset.
+		 */
+		if (brq.cmd.error)
+			mmc_handle_timeout_error(card->host, brq.cmd.error);
+		else if (brq.data.error)
+			mmc_handle_timeout_error(card->host, brq.data.error);
+		else if (brq.stop.error)
+			mmc_handle_timeout_error(card->host, brq.stop.error);
+
 		mmc_queue_bounce_post(mq);
 
 		/*
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 530fc35..559ff1c 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1382,6 +1382,8 @@ static int mmc_do_erase(struct mmc_card *card, unsigned int from,
 	cmd.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
 	mmc_set_erase_timeout(card, &cmd, arg, qty);
 	err = mmc_wait_for_cmd(card->host, &cmd, 0);
+	/* Before return, check whether can do a HW reset */
+	mmc_handle_timeout_error(card->host, cmd.error);
 	if (err) {
 		printk(KERN_ERR "mmc_erase: erase error %d, status %#x\n",
 		       err, cmd.resp[0]);
-- 
1.6.6.1

