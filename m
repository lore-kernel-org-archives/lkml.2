Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab2CMAXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:23:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:48196 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758922Ab2CMAX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chris Ball <cjb@laptop.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 108/196] mmc: sdhci: Check mrq->cmd in sdhci_tasklet_finish
Date: Mon, 12 Mar 2012 20:20:21 -0400
Message-Id: <1331598109-31424-63-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben-linux@fluff.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/mmc/host/sdhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 9d4fdfa..6441e22 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1279,7 +1279,7 @@ static void sdhci_tasklet_finish(unsigned long param)
 	 * upon error conditions.
 	 */
 	if (!(host->flags & SDHCI_DEVICE_DEAD) &&
-		(mrq->cmd->error ||
+	    ((mrq->cmd && mrq->cmd->error) ||
 		 (mrq->data && (mrq->data->error ||
 		  (mrq->data->stop && mrq->data->stop->error))) ||
 		   (host->quirks & SDHCI_QUIRK_RESET_AFTER_REQUEST))) {
-- 
1.7.9.3

