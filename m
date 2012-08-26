Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab2HZW1V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 18:27:21 -0400
Received: from bosmailout02.eigbox.net ([66.96.185.2]:37539 "EHLO
	bosmailout02.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab2HZW1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 18:27:18 -0400
X-Authority-Analysis: v=2.0 cv=AakG6QrG c=1 sm=1
 a=OWwsRfqG41DA94+gJvZMBg==:17 a=bc2JKO6qiGsA:10 a=kfTud4QeKxsA:10
 a=S9VbPovBP24A:10 a=8nJEP1OIZ-IA:10 a=MeY2Dx25YawA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=VwQbUJbxAAAA:8 a=WNol80Cz26UCktakiSkA:9
 a=wPNLvfGTeEIA:10 a=U62fhAwekXMA:10 a=BF10AaGwQl41phDg7WSPyA==:117
X-EN-OrigOutIP: 10.20.18.8
X-EN-IMPSID: rZmt1j0060ASroS01ZmtbL
Message-ID: <503A8D97.4070403@yahoo.es>
Date: Mon, 27 Aug 2012 04:56:55 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: egtvedt@samfundet.no, Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>
Subject: [PATCH] avr32-linux: at32ap700x: set DMA slave properties for MCI
 dw_dmac
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.63.241
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@Andrew: could you please push the patch below? Hans-Christian
doesn't have a GIT tree on kernel.org

Thanks, Hein

The MCI makes use of the dw_dmac driver when DMA is being used.
Due to recent changes the driver was broken because:
- the SMS field in the CTLL register received the wrong value 0
- a patch in dw_dmac allowed for 64-bit transfers on the
memory side, giving an illegal value of 3 in the SRC/DST_TR_WIDTH
register.
This patch sets the SMS to 1 and limits the maximum transfer
width to 2 (32 bits)

Note: this can only be applied after my patch:
[PATCH 2/2] dw_dmac: max_mem_width limits value for
SRC/DST_TR_WID register

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
---
 arch/avr32/mach-at32ap/at32ap700x.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)
 diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 0445c4f..e7202af 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1355,6 +1355,10 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 				| DWC_CFGH_DST_PER(1));
 	slave->sdata.cfg_lo &= ~(DWC_CFGL_HS_DST_POL
 				| DWC_CFGL_HS_SRC_POL);
+	/* Give CTLL SMS value 1 */
+	slave->sdata.src_master = 1;
+	/* SRC/DST_TR_WIDTH register only accepts 0,1,2 */
+	slave->sdata.max_mem_width = 2;
 
 	data->dma_slave = slave;
 
-- 
1.7.8.0

