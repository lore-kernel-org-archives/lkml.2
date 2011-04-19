Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1DSMrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 08:47:25 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34708 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab1DSMrX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 08:47:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DrOkhwp/4NeSvSxo7wDH0w/Q2okVXhpklwGRpmcVYy0aK1ywT3u0iH1bf0Y4yUz0Wp
         ZAMWql+zlazOCMRlvkgGbJgITlB7FlXWEjaLUJeu5qlxzIM9swjxwFc7dcBThHQDz2yz
         SeZsczIOBnPucGn1RoxM1Lgvc58d7z2e5U/50=
MIME-Version: 1.0
In-Reply-To: <20110419102031.GA4164@pengutronix.de>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
	<20110419102031.GA4164@pengutronix.de>
Date: Tue, 19 Apr 2011 21:47:22 +0900
X-Google-Sender-Auth: FQnBcvGCtUp184DDQJF32sPgW0Q
Message-ID: <BANLkTinfhb3vejJSM4y-C=3vk5RE76gPjQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] consolidate sdhci pltfm & OF drivers and get them
 self registered
From: Kyungmin Park <kmpark@infradead.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>, linaro-dev@lists.linaro.org,
        sameo@linux.intel.com, patches@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?7KCV7J6s7ZuI?= <jh80.chung@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

BTW, Are there reason to omit the sdhci-s3c.c? Maybe Mr. Jung will handle it.

Thank you,
Kyungmin Park

On Tue, Apr 19, 2011 at 7:20 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> Hi Shawn,
>
> On Fri, Mar 25, 2011 at 04:48:46PM +0800, Shawn Guo wrote:
>> Here are what the patch set does.
>>
>> * Remove .probe and .remove hooks from sdhci-pltfm.c and make it be
>>   a pure common helper function providers.
>> * Add .probe and .remove hooks for sdhci pltfm drivers sdhci-cns3xxx,
>>   sdhci-dove, sdhci-tegra, and sdhci-esdhc-imx to make them self
>>   registered with calling helper functions created above.
>> * Migrate the use of sdhci_of_host and sdhci_of_data to
>>   sdhci_pltfm_host and sdhci_pltfm_data, so that OF version host and
>>   data structure works can be saved, and pltfm version works for both
>>   cases.
>> * Add OF common helper stuff into sdhci-pltfm.c, and make OF version
>>   sdhci drivers sdhci-of-esdhc and sdhci-of-hlwd become self
>>   registered as well, so that sdhci-of-core.c and sdhci-of.h can be
>>   removed.
>> * Consolidate the OF and pltfm esdhc drivers into one with sharing
>>   the same pair of .probe and .remove hooks.  As a result,
>>   sdhci-esdhc-imx.c and sdhci-of-esdhc.c go away, while
>>   sdhci-esdhc.c comes in and works for both MPCxxx and i.MX.
>> * Eliminate include/linux/mmc/sdhci-pltfm.h with moving stuff into
>>   drivers/mmc/host/sdhci-pltfm.h.
>>
>> And the benefits we gain from the changes are:
>>
>> * Get the sdhci device driver follow the Linux trend that driver
>>   makes the registration by its own.
>> * sdhci-pltfm.c becomes simple and clean as it only has common helper
>>   stuff there now.
>> * All sdhci device specific things are going back its own driver.
>> * The dt and non-dt drivers are consolidated to use the same pair of
>>   .probe and .remove hooks.
>> * SDHCI driver for Freescale eSDHC controller found on both MPCxxx
>>   and i.MX platforms is consolidated to use the same one .probe
>>   function.
>>
>> The patch set works against the tree below, and was only tested on
>> i.mx51 babbage board, all other targets were build tested.
>>
>>   git://git.secretlab.ca/git/linux-2.6.git devicetree/test
>>
>> Comments are welcomed and appreciated.
>
> First of all, thanks _a lot_ for doing this! Many people have promised
> to do such an approach, but you finally made it!
>
> Sorry for the long delay in reviewing it, I didn't want to rush a review
> so I needed some time for it which I didn't have much in the last weeks.
> Let's hope my battery will have enough power on my flight back to
> Germany ;) So, this is for now a purely "visual" review. I hope I can
> check V2 on real hardware then.
>
> The approach seems sensible, so have a look at my (mostly minor)
> comments inside the patches. However, there is one bigger piece missing.
> You converted all the drivers which had a seperate source-file and
> hooked into sdhci-pltfm.c. However, those are only those users which
> need additional code to work around the quirks. There are also users
> which can take the plain pltfm-driver with a properly set
> platform_data (check the thread "[PATCH] mmc: add SDHCI driver for STM
> platforms (V2)" for an example). Those have to be converted, too.
> Now the discussion could be if every of those users gets its own
> pltfm-<something>.c or if we create something similat to
> sdhci-pltfm-generic, which can also be setup with platform_data like the
> old driver (/me likes the latter a bit more. If we don't change the name
> of the driver (not talking about the sourcefile) and keep it
> "sdhci-pltfm", then you wouldn't need to change all those users if you
> ensured it behaves the same.
>
> Also, I think the next version of this series should have all makers of
> a sdhci-pltfm user CCed so we give them a chance to report breakage. Or
> donate acks or tested-by.
>
> Regards,
>
>   Wolfram
>
> --
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iEYEARECAAYFAk2tYe8ACgkQD27XaX1/VRsCRgCgkp+BmJJsLsKllKL0OI/BnO9F
> PRkAn1BpnXBv1exnkJFlqFAPe5O2Yt8w
> =GSqA
> -----END PGP SIGNATURE-----
>
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
>
>
