Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab1EFAaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:30:46 -0400
Received: from kroah.org ([198.145.64.141]:37621 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932685Ab1EFA1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:27:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:26:10 2011
Message-Id: <20110506002610.202790569@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:25:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Dooks <ben-linux@fluff.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chris Ball <cjb@laptop.org>
Subject: [30/43] mmc: sdhci: Check mrq->cmd in sdhci_tasklet_finish
In-Reply-To: <20110506002625.GA20426@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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

---
 drivers/mmc/host/sdhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1277,7 +1277,7 @@ static void sdhci_tasklet_finish(unsigne
 	 * upon error conditions.
 	 */
 	if (!(host->flags & SDHCI_DEVICE_DEAD) &&
-		(mrq->cmd->error ||
+	    ((mrq->cmd && mrq->cmd->error) ||
 		 (mrq->data && (mrq->data->error ||
 		  (mrq->data->stop && mrq->data->stop->error))) ||
 		   (host->quirks & SDHCI_QUIRK_RESET_AFTER_REQUEST))) {


