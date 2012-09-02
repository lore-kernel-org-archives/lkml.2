Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab2IBSth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 14:49:37 -0400
Received: from bosmailout15.eigbox.net ([66.96.190.15]:37907 "EHLO
	bosmailout15.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab2IBStR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 14:49:17 -0400
X-Greylist: delayed 2375 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Sep 2012 14:49:17 EDT
X-Authority-Analysis: v=2.0 cv=KtT6LxqN c=1 sm=1
 a=buXPRa+6dbOeiNUh9yipmw==:17 a=bc2JKO6qiGsA:10 a=tW0haWE2Y5YA:10
 a=AnsHGya2kYsA:10 a=8nJEP1OIZ-IA:10 a=jg9qgr1QB04A:10 a=otR8-BZDKFQA:10
 a=1nEf5Trd2TMA:10 a=7E8NXZI3oggA:10 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19
 a=D19gQVrFAAAA:8 a=ujnD75z6dN5Qym19t2gA:9 a=wPNLvfGTeEIA:10
 a=9UqFsMnAB6EOkiq4MrOclQ==:117
X-EN-OrigOutIP: 10.20.18.19
X-EN-IMPSID: uJ9c1j0040QhFXN01J9cp3
Message-ID: <50439D65.4010708@yahoo.es>
Date: Mon, 03 Sep 2012 01:54:45 +0800
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
Subject: [PATCH v4 3/3] avr32: at32ap700x: set DMA slave properties for MCI
 dw_dmac
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.57.6
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hein Tibosch <hein_tibosch@yahoo.es>

v4: now based and tested on 3.6-rc4

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
 arch/avr32/mach-at32ap/at32ap700x.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 0445c4f..33c56e7 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1355,6 +1355,10 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 				| DWC_CFGH_DST_PER(1));
 	slave->sdata.cfg_lo &= ~(DWC_CFGL_HS_DST_POL
 				| DWC_CFGL_HS_SRC_POL);
+	/* Setup DMA controller: let source be master */
+	slave->sdata.src_master = 1;
+	/* Limit maximum transfer width to 32-bit */
+	slave->sdata.max_mem_width = DW_MEM_WIDTH_32;

 	data->dma_slave = slave;

-- 
1.7.8.0
