Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab2HGWgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:36:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab2HGWgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:36:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Aaron Lu <aaron.lu@amd.com>, Philip Rakity <prakity@marvell.com>,
        Chris Ball <cjb@laptop.org>
Subject: [ 004/109] mmc: sdhci: fix incorrect command used in tuning
Date: Tue,  7 Aug 2012 15:34:23 -0700
Message-Id: <20120807222043.465831072@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@amd.com>

commit 473b095a72a95ba719905b1f2e82cd18d099a427 upstream.

For SD hosts using retuning mode 1, when retuning timer expired, it will
need to do retuning in sdhci_request before processing the actual
request. But the retuning command is fixed: cmd19 for SD card and cmd21
for eMMC card, so we can't use the original request's command to do the
tuning.

And since the tuning command depends on the card type attached to the
host, we will need to know the card type to use the correct tuning
command.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
Reviewed-by: Philip Rakity <prakity@marvell.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -27,6 +27,7 @@
 
 #include <linux/mmc/mmc.h>
 #include <linux/mmc/host.h>
+#include <linux/mmc/card.h>
 
 #include "sdhci.h"
 
@@ -1245,6 +1246,7 @@ static void sdhci_request(struct mmc_hos
 	struct sdhci_host *host;
 	bool present;
 	unsigned long flags;
+	u32 tuning_opcode;
 
 	host = mmc_priv(mmc);
 
@@ -1292,8 +1294,12 @@ static void sdhci_request(struct mmc_hos
 		 */
 		if ((host->flags & SDHCI_NEEDS_RETUNING) &&
 		    !(present_state & (SDHCI_DOING_WRITE | SDHCI_DOING_READ))) {
+			/* eMMC uses cmd21 while sd and sdio use cmd19 */
+			tuning_opcode = mmc->card->type == MMC_TYPE_MMC ?
+				MMC_SEND_TUNING_BLOCK_HS200 :
+				MMC_SEND_TUNING_BLOCK;
 			spin_unlock_irqrestore(&host->lock, flags);
-			sdhci_execute_tuning(mmc, mrq->cmd->opcode);
+			sdhci_execute_tuning(mmc, tuning_opcode);
 			spin_lock_irqsave(&host->lock, flags);
 
 			/* Restore original mmc_request structure */


