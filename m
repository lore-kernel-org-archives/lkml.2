Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab2IAD6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 23:58:05 -0400
Received: from bosmailout14.eigbox.net ([66.96.186.14]:41748 "EHLO
	bosmailout14.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab2IAD5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 23:57:47 -0400
X-Greylist: delayed 2389 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Aug 2012 23:57:46 EDT
X-Authority-Analysis: v=2.0 cv=Ha6juF48 c=1 sm=1
 a=Z/nPm8Wi6vkzxh11zJE/RA==:17 a=bc2JKO6qiGsA:10 a=tW0haWE2Y5YA:10
 a=5dyqpnoOPUoA:10 a=8nJEP1OIZ-IA:10 a=aVJx4HrAOpwA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=D19gQVrFAAAA:8 a=ujnD75z6dN5Qym19t2gA:9
 a=wPNLvfGTeEIA:10 a=wx0GOVZTcu8EuaXTIXj3VQ==:117
X-EN-OrigOutIP: 10.20.18.12
X-EN-IMPSID: tfJC1j0030FdZ9W01fJCih
Message-ID: <50417BB6.3020300@yahoo.es>
Date: Sat, 01 Sep 2012 11:06:30 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        viresh kumar <viresh.kumar@linaro.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: Arnd Bergmann <arnd.bergmann@linaro.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        spear-devel <spear-devel@list.st.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 3/3] avr32: at32ap700x: set DMA slave properties for MCI
 dw_dmac
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.63.40
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MCI makes use of the dw_dmac driver when DMA is being used.
Due to recent changes to dw_dmac the MCI+DMA driver was broken because:
- a patch in dw_dmac allowed for 64-bit transfers on the memory side, giving
an illegal value of 3 in the SRC/DST_TR_WIDTH register
(http://lkml.org/lkml/2012/1/18/52)
- the SMS field in the CTLL register received the wrong value 0

This patch sets the SMS (Source Master Select) to 1 and limits
the maximum transfer width to 32 bits.

Note: this can only be applied after the previous:
[PATCH v3 2/3] dw_dmac: max_mem_width limits value for SRC/DST_TR_WID register

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
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
