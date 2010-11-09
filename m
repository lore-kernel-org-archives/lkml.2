Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab0KIFxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 00:53:04 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:48130 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab0KIFxC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 00:53:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UyRiLPEklqNmrlaTtwKwdDImradSeu21Kl4cl/K8e8uBpDBW1I/Q9ppGgwkAdaQXH1
         RlBvcnwrDZEPUfa6acWKZyMXRpBQsaZVMeyNE0/MpYFVWTe5a1BJqnopoFQ7q2jLSKmy
         L1bLsJGg6baDCHUkMkwQS/abjGY1dhaiJbWHI=
MIME-Version: 1.0
In-Reply-To: <4CD8DE9C.4040505@dsn.okisemi.com>
References: <4CD8DE9C.4040505@dsn.okisemi.com>
Date: Tue, 9 Nov 2010 14:53:01 +0900
X-Google-Sender-Auth: Kv_giyzGuF-KmpHCGiHP5raBQsw
Message-ID: <AANLkTimfnj8GcSwmALjaZUBsiq6ssaVuzVZZsZHRYmiX@mail.gmail.com>
Subject: Re: A MMC card transfer issue
From: Kyungmin Park <kmpark@infradead.org>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Andrew\"" <andrew.chih.howe.khor@intel.com>, kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/9 Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>:
> I am facing the issue about some MMC cards on Intel EG20T PCH (Platform Controller Hub).
> The linux version is 2.6.36.
> I can not transfer data the MMC cards (e.g. Transcned MMC card).
> The card is 1 bit bus width. And the card is according to MMC specification V3.x.
> And the EG20T has a 4 bit bus width capability
> Linux MMC standard driver decides the card bus width as 4 bit,
> if the MMC specification version is larger than or equal to V4.0 like below.
>
> linux/drivers/mmc/core/mmc.c
>
>  505        /*
>  506         * Activate wide bus (if supported).
>  507         */
>  508        if ((card->csd.mmca_vsn >= CSD_SPEC_VER_4) &&
>  509            (host->caps & (MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA))) {
>  510                unsigned ext_csd_bit, bus_width;
>  511
>  512                if (host->caps & MMC_CAP_8_BIT_DATA) {
>  513                        ext_csd_bit = EXT_CSD_BUS_WIDTH_8;
>  514                        bus_width = MMC_BUS_WIDTH_8;
>  515                } else {
>  516                        ext_csd_bit = EXT_CSD_BUS_WIDTH_4;
>  517                        bus_width = MMC_BUS_WIDTH_4;
>  518                }
>  519
>  520                err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>  521                                 EXT_CSD_BUS_WIDTH, ext_csd_bit);
>  522
>  523                if (err && err != -EBADMSG)
>  524                        goto free_card;
>  525
>  526                if (err) {
>  527                        printk(KERN_WARNING "%s: switch to bus width %d "
>  528                               "failed\n", mmc_hostname(card->host),
>  529                               1 << bus_width);
>  530                        err = 0;
>  531                } else {
>  532                        mmc_set_bus_width(card->host, bus_width);
>  533                }
>  534        }
>  535
>
> However the MMC specification version id is the same as V3.x and V4.0.
> Therefore the driver uses the 4 bit bus width for the MMC card
> even if the card has only 1 bit bus width.
> I modified the driver to use 1 bit bus width only tentatively and confirmed that
> we can mount the card and R/W correctly.
>
> I think we can not support MMC_CAP_4_BIT_DATA or MMC_CAP_8_BIT_DATA in MMC V4.0.
>
> How do you think ?

You can find a patch for 4-bit support. the problem is there's some
bug related so it set the 4 & 8 bit support both.
So line 512 is always true. you can just remove the one line like this.

It's quirk-and-dirty patch. now we try to find a generic solution to
solve this issue.
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1849,7 +1849,7 @@ int sdhci_add_host(struct sdhci_host *host)
        mmc->caps |= MMC_CAP_SDIO_IRQ;

        if (!(host->quirks & SDHCI_QUIRK_FORCE_1_BIT_DATA))
-               mmc->caps |= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA;
+               mmc->caps |= MMC_CAP_4_BIT_DATA;

        if (caps & SDHCI_CAN_DO_HISPD)
                mmc->caps |= MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED;

Thank you,
Kyungmin Park
>
> --
> Thanks,
> Tomoya MORINAGA(OKI SEMICONDUCTOR CO., LTD.)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
