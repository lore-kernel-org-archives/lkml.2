Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab0LUTiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 14:38:12 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:35034 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751863Ab0LUTiK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 14:38:10 -0500
From: Philip Rakity <prakity@marvell.com>
To: Zhangfei Gao <zhangfei.gao@gmail.com>, Zhangfei Gao <zgao6@marvell.com>
CC: Takashi Iwai <tiwai@suse.de>, Chris Ball <cjb@laptop.org>,
        Aries Lee <arieslee@jmicron.com>, Qiming Wu <wuqm@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 21 Dec 2010 11:35:09 -0800
Subject: Re: [PATCH] mmc: Test bus-width for old MMC devices (v2)
Thread-Topic: [PATCH] mmc: Test bus-width for old MMC devices (v2)
Thread-Index: AcuhRi0KqRbvKx9oRwSE5mN4DvHsnw==
Message-ID: <6E608F2B-DB48-43CC-BF08-1415041A8316@marvell.com>
References: <s5hfwtzbj8v.wl%tiwai@suse.de>
 <20101216234032.GA17239@void.printf.net>
 <50D31EC8-BD9E-4920-8CEB-2AD10DF9C5C5@marvell.com>
 <20101217034342.GA19673@void.printf.net>	<s5hy67o95to.wl%tiwai@suse.de>
 <AANLkTimSt5a998m1oqdppsWjGCVid0-Ub81pKgsPR36f@mail.gmail.com>
 <E81C83FE-E3AD-49DA-86BE-95631F1B81CD@marvell.com>
In-Reply-To: <E81C83FE-E3AD-49DA-86BE-95631F1B81CD@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Zhangfei,

Reproduced the problem on mmp2.  Fix enclosed.  Slight change from Zhangfei
original suggestion.

Please confirm by adding tested-by.

Philip



>From 8b35e007d67dd593ff5e8a07b564c438e8303aae Mon Sep 17 00:00:00 2001
From: Philip Rakity <prakity@marvell.com>
Date: Tue, 21 Dec 2010 11:29:33 -0800
Subject: [PATCH] mmc: fix regression testing bus width when CAP not defined

First reported by Zhangfei Gao.

set mmc bus width before checking for CAP for mmc bus width testing.
set bus width when card is not ddr

Signed-off-by: Philip Rakity <prakity@marvell.com>
Tested-by: Philip Rakity
---
 drivers/mmc/core/mmc.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 1d8409f..3a2905f 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -558,6 +558,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 					 EXT_CSD_BUS_WIDTH,
 					 ext_csd_bits[idx][0]);
 			if (!err) {
+				mmc_set_bus_width_ddr(card->host,
+						      bus_width, MMC_SDR_MODE);
 				/*
 				 * If controller can't handle bus width test,
 				 * use the highest bus width to maintain
@@ -565,8 +567,6 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 				 */
 				if (!(host->caps & MMC_CAP_BUS_WIDTH_TEST))
 					break;
-				mmc_set_bus_width_ddr(card->host,
-						      bus_width, MMC_SDR_MODE);
 				err = mmc_bus_test(card, bus_width);
 				if (!err)
 					break;
@@ -586,7 +586,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 		} else if (ddr) {
 			mmc_card_set_ddr_mode(card);
 			mmc_set_bus_width_ddr(card->host, bus_width, ddr);
-		}
+		} else
+			mmc_set_bus_width (card->host, bus_width);
 	}
 
 	if (!oldcard)
-- 
1.6.0.4

