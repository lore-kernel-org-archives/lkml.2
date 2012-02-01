Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab2BAV45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:56:57 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49496 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756933Ab2BAVHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:07:55 -0500
X-Sasl-enc: YvDAqMC5g9ZCYTNOH60xCaZb20xP3u5D5hGYDMmuizUx 1328130474
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:15:31 2012
Message-Id: <20120201201531.671576828@clark.kroah.org>
User-Agent: quilt/0.51-14.1
Date: Wed, 01 Feb 2012 12:14:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ulf Hansson <ulf.hansson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Per Forlin <per.forlin@stericsson.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, Greg KH <greg@kroah.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [07/20] Revert "ARM: 7220/1: mmc: mmci: Fixup error handling for dma"
In-Reply-To: <20120201210055.GA25374@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------


From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

This reverts commit c8cdf3f97d34d906e0519d5cbc2ab3f81269d0b4, applied on
linux 2.6.32.53 stable release, as it can introduce the following build
error while building 2.6.32.y on armel:

linux-2.6.32/drivers/mmc/host/mmci.c: In function 'mmci_cmd_irq':
linux-2.6.32/drivers/mmc/host/mmci.c:237: error: implicit declaration of function 'dma_inprogress'
linux-2.6.32/drivers/mmc/host/mmci.c:238: error: implicit declaration of function 'mmci_dma_data_error'

Aparently the commit was wrongly pushed into 2.6.32, since it depends on
commit c8ebae37 ("ARM: mmci: add dmaengine-based DMA support"), not
present on 2.6.32.

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/mmci.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -232,12 +232,8 @@ mmci_cmd_irq(struct mmci_host *host, str
 	}
 
 	if (!cmd->data || cmd->error) {
-		if (host->data) {
-			/* Terminate the DMA transfer */
-			if (dma_inprogress(host))
-				mmci_dma_data_error(host);
+		if (host->data)
 			mmci_stop_data(host);
-		}
 		mmci_request_end(host, cmd->mrq);
 	} else if (!(cmd->data->flags & MMC_DATA_READ)) {
 		mmci_start_data(host, cmd->data);


