Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab2LSCF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 21:05:56 -0500
Received: from mga14.intel.com ([143.182.124.37]:12316 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab2LSCFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 21:05:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,313,1355126400"; 
   d="scan'208";a="233632176"
Subject: [PATCH] spi-dw: delete cur_msg when pump message and transfer has
 finished
From: Xiao Jin <jin.xiao@intel.com>
To: grant.likely@secretlab.ca, akpm@linux-foundation.org, mingo@elte.hu,
        a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
        william.douglas@intel.com, linux-kernel@vger.kernel.org,
        sboyd@codeaurora.org
Cc: alek.du@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Dec 2012 10:09:21 +0800
Message-ID: <1355882961.9600.19.camel@xiaojin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiao jin <jin.xiao@intel.com>
Date: Tue, 20 Nov 2012 13:45:47 +0800
Subject: [PATCH] spi-dw: delete cur_msg when pump message and transfer
has finished

We see DPM device timeout happened in spi_max3111 when system suspend.

The root cause is related to the time we delete msg from dw_spi queue.

Below is the scenario how timeout happened.
step1, max3110_main_thread pump the dw_spi msg and transfer it. And
the msg is deleted from dw_spi queue right now.
step2, runtime suspend happened, there is no msg in the dw_spi queue,
it's permitted to enter into D0i3.
step3, After resume from D0i3, irq will not come for ever,
max3110_main_thread still wait for the completion of last pump message
transfer.
step4, system suspend, serial_m3110_shutdown call max3110_out and
try to lock the mutex, but it has been hold and cannot be released
by max3110_main_thread for ever.
step5, DPM device timer timeout.

This patch is to delete the cur msg when msg complete.

Signed-off-by: xiao jin <jin.xiao@intel.com>
---
 drivers/spi/spi-dw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index d1a495f..f6bf693 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -268,6 +268,7 @@ static void giveback(struct dw_spi *dws)
 
 	spin_lock_irqsave(&dws->lock, flags);
 	msg = dws->cur_msg;
+	list_del_init(&dws->cur_msg->queue);
 	dws->cur_msg = NULL;
 	dws->cur_transfer = NULL;
 	dws->prev_chip = dws->cur_chip;
@@ -571,7 +572,6 @@ static void pump_messages(struct work_struct *work)
 
 	/* Extract head of queue */
 	dws->cur_msg = list_entry(dws->queue.next, struct spi_message, queue);
-	list_del_init(&dws->cur_msg->queue);
 
 	/* Initial message state*/
 	dws->cur_msg->state = START_STATE;
-- 
1.7.1



