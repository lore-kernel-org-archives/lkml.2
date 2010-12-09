Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0LIM2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 07:28:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:21287 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366Ab0LIM2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 07:28:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,319,1288594800"; 
   d="scan'208";a="582092569"
Date: Thu, 9 Dec 2010 20:25:03 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, cjb@laptop.org,
        kmpark@infradead.org, leonard.mai@intel.com
Subject: [PATCH v5 4/4]do HW reset after each read/write/erase if need
Message-ID: <20101209122503.GE13236@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver can do a HW reset for eMMC card if read/write/erase
occurs timeout error.

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
index 530fc35..731399e 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1385,6 +1385,8 @@ static int mmc_do_erase(struct mmc_card *card, unsigned int from,
 	if (err) {
 		printk(KERN_ERR "mmc_erase: erase error %d, status %#x\n",
 		       err, cmd.resp[0]);
+		/* Before return, check whether can do a HW reset */
+		mmc_handle_timeout_error(card->host, cmd.error);
 		err = -EIO;
 		goto out;
 	}
-- 
1.6.6.1

