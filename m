Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab1G0AfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:35:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:18089 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab1G0AfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="32380394"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: ben-linux@fluff.org, broonie@opensource.wolfsonmicro.com, cjb@laptop.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] [22/98] mmc: sdhci: Check mrq->cmd in sdhci_tasklet_finish
Message-Id: <20110727003514.5C7782403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ben Dooks <ben-linux@fluff.org>

commit b7b4d3426d2b5ecab21578eb20d8e456a1aace8f upstream.

It seems that under certain circumstances that the sdhci_tasklet_finish()
call can be entered with mrq->cmd set to NULL, causing the system to crash
with a NULL pointer de-reference.

Unable to handle kernel NULL pointer dereference at virtual address 00000000
PC is at sdhci_tasklet_finish+0x34/0xe8
LR is at sdhci_tasklet_finish+0x24/0xe8

Seen on S3C6410 system.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/mmc/host/sdhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/mmc/host/sdhci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/mmc/host/sdhci.c
+++ linux-2.6.35.y/drivers/mmc/host/sdhci.c
@@ -1289,7 +1289,7 @@ static void sdhci_tasklet_finish(unsigne
 	 * upon error conditions.
 	 */
 	if (!(host->flags & SDHCI_DEVICE_DEAD) &&
-		(mrq->cmd->error ||
+	    ((mrq->cmd && mrq->cmd->error) ||
 		 (mrq->data && (mrq->data->error ||
 		  (mrq->data->stop && mrq->data->stop->error))) ||
 		   (host->quirks & SDHCI_QUIRK_RESET_AFTER_REQUEST))) {
