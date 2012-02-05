Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2BEWsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:48:10 -0500
Received: from 1wt.eu ([62.212.114.60]:61858 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab2BEW0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:17 -0500
Message-Id: <20120205220949.791917535@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:09:57 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chris Ball <cjb@laptop.org>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 08/91] mmc: sdhci: Check mrq->cmd in sdhci_tasklet_finish
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/drivers/mmc/host/sdhci.c
===================================================================
--- longterm-2.6.27.orig/drivers/mmc/host/sdhci.c	2012-02-05 22:34:34.798915250 +0100
+++ longterm-2.6.27/drivers/mmc/host/sdhci.c	2012-02-05 22:34:36.053916156 +0100
@@ -1176,7 +1176,7 @@
 	 * upon error conditions.
 	 */
 	if (!(host->flags & SDHCI_DEVICE_DEAD) &&
-		(mrq->cmd->error ||
+	    ((mrq->cmd && mrq->cmd->error) ||
 		 (mrq->data && (mrq->data->error ||
 		  (mrq->data->stop && mrq->data->stop->error))) ||
 		   (host->quirks & SDHCI_QUIRK_RESET_AFTER_REQUEST))) {


