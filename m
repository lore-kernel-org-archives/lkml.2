Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab2ACWEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:04:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957Ab2ACWE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:04:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:02:43 2012
Message-Id: <20120103220243.148061097@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:01:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Per Forlin <per.forlin@stericsson.com>,
        Ulf Hansson <ulf.hansson@stericsson.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [6/7] ARM: 7220/1: mmc: mmci: Fixup error handling for dma
In-Reply-To: <20120103220302.GA28338@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@stericsson.com>

commit 3b6e3c73851a9a4b0e6ed9d378206341dd65e8a5 upstream.

When getting a cmd irq during an ongoing data transfer
with dma, the dma job were never terminated. This is now
corrected.

Tested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Per Forlin <per.forlin@stericsson.com>
Signed-off-by: Ulf Hansson <ulf.hansson@stericsson.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/mmci.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -232,8 +232,12 @@ mmci_cmd_irq(struct mmci_host *host, str
 	}
 
 	if (!cmd->data || cmd->error) {
-		if (host->data)
+		if (host->data) {
+			/* Terminate the DMA transfer */
+			if (dma_inprogress(host))
+				mmci_dma_data_error(host);
 			mmci_stop_data(host);
+		}
 		mmci_request_end(host, cmd->mrq);
 	} else if (!(cmd->data->flags & MMC_DATA_READ)) {
 		mmci_start_data(host, cmd->data);


