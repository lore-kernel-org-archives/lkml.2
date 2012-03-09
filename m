Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030587Ab2CIUYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:24:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030537Ab2CITq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:46:58 -0500
Message-Id: <20120309190204.608575633@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Chris Ball <cjb@laptop.org>
Subject: [ 28/95] mmc: sdhci-esdhc-imx: fix for mmc cards on i.MX5
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 5b6b0ad6e572b32a641116aaa5f897ffebe31e44 upstream.

On i.MX53 we have to write a special SDHCI_CMD_ABORTCMD to the
SDHCI_TRANSFER_MODE register during a MMC_STOP_TRANSMISSION
command. This works for SD cards. However, with MMC cards
the MMC_SET_BLOCK_COUNT command is used instead, but this
needs the same handling. Fix MMC cards by testing for the
MMC_SET_BLOCK_COUNT command aswell. Tested on a custom i.MX53
board with a Transcend MMC+ card and eMMC.

The kernel started used MMC_SET_BLOCK_COUNT in 3.0, so this
is a regression for these boards introduced in 3.0; it should
go to 3.0/3.1/3.2-stable.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-esdhc-imx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -269,8 +269,9 @@ static void esdhc_writew_le(struct sdhci
 		imx_data->scratchpad = val;
 		return;
 	case SDHCI_COMMAND:
-		if ((host->cmd->opcode == MMC_STOP_TRANSMISSION)
-			&& (imx_data->flags & ESDHC_FLAG_MULTIBLK_NO_INT))
+		if ((host->cmd->opcode == MMC_STOP_TRANSMISSION ||
+		     host->cmd->opcode == MMC_SET_BLOCK_COUNT) &&
+	            (imx_data->flags & ESDHC_FLAG_MULTIBLK_NO_INT))
 			val |= SDHCI_CMD_ABORTCMD;
 
 		if (is_imx6q_usdhc(imx_data)) {


