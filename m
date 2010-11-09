Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab0KIFjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 00:39:49 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:9021 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448Ab0KIFjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 00:39:45 -0500
Message-ID: <4CD8DE9C.4040505@dsn.okisemi.com>
Date: Tue, 09 Nov 2010 14:39:40 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
CC: "Andrew\"" <andrew.chih.howe.khor@intel.com>, kok.howg.ewe@intel.com
Subject: A MMC card transfer issue
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am facing the issue about some MMC cards on Intel EG20T PCH (Platform Controller Hub).
The linux version is 2.6.36.
I can not transfer data the MMC cards (e.g. Transcned MMC card).
The card is 1 bit bus width. And the card is according to MMC specification V3.x.
And the EG20T has a 4 bit bus width capability 
Linux MMC standard driver decides the card bus width as 4 bit,
if the MMC specification version is larger than or equal to V4.0 like below.

linux/drivers/mmc/core/mmc.c

 505        /*
 506         * Activate wide bus (if supported).
 507         */
 508        if ((card->csd.mmca_vsn >= CSD_SPEC_VER_4) &&
 509            (host->caps & (MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA))) {
 510                unsigned ext_csd_bit, bus_width;
 511
 512                if (host->caps & MMC_CAP_8_BIT_DATA) {
 513                        ext_csd_bit = EXT_CSD_BUS_WIDTH_8;
 514                        bus_width = MMC_BUS_WIDTH_8;
 515                } else {
 516                        ext_csd_bit = EXT_CSD_BUS_WIDTH_4;
 517                        bus_width = MMC_BUS_WIDTH_4;
 518                }
 519
 520                err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
 521                                 EXT_CSD_BUS_WIDTH, ext_csd_bit);
 522
 523                if (err && err != -EBADMSG)
 524                        goto free_card;
 525
 526                if (err) {
 527                        printk(KERN_WARNING "%s: switch to bus width %d "
 528                               "failed\n", mmc_hostname(card->host),
 529                               1 << bus_width);
 530                        err = 0;
 531                } else {
 532                        mmc_set_bus_width(card->host, bus_width);
 533                }
 534        }
 535

However the MMC specification version id is the same as V3.x and V4.0.
Therefore the driver uses the 4 bit bus width for the MMC card 
even if the card has only 1 bit bus width.
I modified the driver to use 1 bit bus width only tentatively and confirmed that
we can mount the card and R/W correctly.

I think we can not support MMC_CAP_4_BIT_DATA or MMC_CAP_8_BIT_DATA in MMC V4.0.

How do you think ?

-- 
Thanks,
Tomoya MORINAGA(OKI SEMICONDUCTOR CO., LTD.)
