Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2H3S3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:29:14 -0400
Received: from bosmailout09.eigbox.net ([66.96.187.9]:44417 "EHLO
	bosmailout09.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2H3S3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:29:11 -0400
X-Greylist: delayed 2430 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2012 14:29:10 EDT
X-Authority-Analysis: v=2.0 cv=aPZHX8Bm c=1 sm=1
 a=EVDLJLhrg0sUKeqAW2r0xw==:17 a=bc2JKO6qiGsA:10 a=tW0haWE2Y5YA:10
 a=B98EAKQBHz0A:10 a=8nJEP1OIZ-IA:10 a=3TByoDlHVNAA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=D19gQVrFAAAA:8 a=WNol80Cz26UCktakiSkA:9
 a=wPNLvfGTeEIA:10 a=jcMFiYeD4Gz02xRQ37rMPA==:117
X-EN-OrigOutIP: 10.20.18.4
X-EN-IMPSID: t5pX1j00C05GATN015pXsL
Message-ID: <503F9DC1.9030601@yahoo.es>
Date: Fri, 31 Aug 2012 01:07:13 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>
Subject: [PATCH v2] avr32: at32ap700x: set DMA slave properties for MCI dw_dmac
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.60.254
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MCI makes use of the dw_dmac driver when DMA is being used.
Due to recent changes the driver was broken because:
- the SMS field in the CTLL register received the wrong value 0
- a patch in dw_dmac (http://lkml.org/lkml/2012/1/18/52)
allowed for 64-bit transfers on the memory side, giving an illegal
value of 3 in the SRC/DST_TR_WIDTH register.

This patch sets the SMS (Source Master Select) to 1 and limits
the maximum transfer width to 32 bits.

Note: this can only be applied after my patch:
[PATCH v2 2/2] dw_dmac: max_mem_width limits value for
SRC/DST_TR_WID register

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>

---
 arch/avr32/mach-at32ap/at32ap700x.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 0445c4f..7250c70 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1356,6 +1356,11 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 	slave->sdata.cfg_lo &= ~(DWC_CFGL_HS_DST_POL
 				| DWC_CFGL_HS_SRC_POL);
 
+	/* Setup DMA controller: let source be master */
+	slave->sdata.src_master = 1;
+	/* Limit maximum transfer width to 32-bit */
+	slave->sdata.max_mem_width = DW_MEM_WIDTH_32;
+
 	data->dma_slave = slave;
 
 	if (platform_device_add_data(pdev, data,
-- 
1.7.8.0

