Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab1CXJTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:19:54 -0400
Received: from router.aksignal.cz ([188.175.113.102]:48265 "EHLO
	router.aksignal.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1CXJTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:19:53 -0400
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Mar 2011 05:19:52 EDT
Message-ID: <4D8B0A8B.6030002@aksignal.cz>
Date: Thu, 24 Mar 2011 10:10:35 +0100
From: =?ISO-8859-2?Q?Prchal_Ji=F8=ED?= <jiri.prchal@aksignal.cz>
Organization: AK signal Brno
User-Agent: Mozilla/5.0 (X11; U; Linux i686; cs-CZ; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Lightning/1.0b1 Thunderbird/3.0.11
MIME-Version: 1.0
To: linux-mmc@vger.kernel.org, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] mmc, AT91: fix init fequency problem
References: <1300949648-15078-1-git-send-email-horms@verge.net.au> <1300949648-15078-2-git-send-email-horms@verge.net.au>
In-Reply-To: <1300949648-15078-2-git-send-email-horms@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
this patch fixes problem with some SD cards during initialization. Not all SD(HC) card can run at even 375kHz. Sets
minimal frequency to 200kHz.
And in function "at91_mci_set_ios" is limit to maximum division, it's only 8 bit value.

Kernel version: 2.6.38
Signed-off-by: Jiri Prchal <jiri.prchal@aksignal.cz>
---

diff -uprN -X linux-2.6.38-vanilla/Documentation/dontdiff linux-2.6.38-vanilla/drivers/mmc/host/at91_mci.c
/home/prchal/arm/fw-cdu/linux/linux-2.6.38/drivers/mmc/host/at91_mci.c
--- linux-2.6.38-vanilla/drivers/mmc/host/at91_mci.c	2011-03-15 02:20:32.000000000 +0100
+++ /home/prchal/arm/fw-cdu/linux/linux-2.6.38/drivers/mmc/host/at91_mci.c	2011-03-24 09:20:22.869370179 +0100
@@ -724,6 +724,10 @@ static void at91_mci_set_ios(struct mmc_
 		else
 			clkdiv = (at91_master_clock / ios->clock) / 2;

+		/* set maximum divider */
+		if (clkdiv > 255)
+			clkdiv = 255;
+
 		pr_debug("clkdiv = %d. mcck = %ld\n", clkdiv,
 			at91_master_clock / (2 * (clkdiv + 1)));
 	}
@@ -944,7 +948,7 @@ static int __init at91_mci_probe(struct
 	}

 	mmc->ops = &at91_mci_ops;
-	mmc->f_min = 375000;
+	mmc->f_min = 200000; /* not all cards can run at 375kHz */
 	mmc->f_max = 25000000;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 	mmc->caps = 0;
