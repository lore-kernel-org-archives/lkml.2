Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab2BXPDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:03:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60674 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab2BXPDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:03:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] USB: Support for LPC32xx SoC
Date: Fri, 24 Feb 2012 15:03:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Wolfram Sang <w.sang@pengutronix.de>, Roland Stigge <stigge@antcom.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, Alan Stern <stern@rowland.harvard.edu>
References: <1330030639-3796-1-git-send-email-stigge@antcom.de> <4F46AA06.30502@antcom.de> <20120224063521.GA16412@pengutronix.de>
In-Reply-To: <20120224063521.GA16412@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202241503.27406.arnd@arndb.de>
X-Provags-ID: V02:K0:YYnmuGcib/Wa8sHpHDTkT2MZEBhR+ezzxN6dk+OlejR
 zt0+4IOsA81W/ah/Qt7ZgRjN0GqiYgRqmFIIFFGsvzhvMmaHwj
 mJBymPQHRYTnekRKS2Raz6ZhzqRGjivC2CvXdd2h5IEbz4PvZB
 rjx8BsMj3kegosQgNeeXxtZPB/BM78ohuJQOGveGNbI0rr1j4A
 tyJzgXz5xd1oxNEx1ExwppiTxPt7uTp7zs432/Ng6A8jYeWLYA
 w/HsQyDW56bL0muL4O8zuOq0cc3eOk6aHKRL/7FTwJz1SCWAFb
 tuWaw96bwa7vPyBY5Fvxkw6mfKu0JKgiT4qLYXWNP1vT3rxPPB
 uVTrkyW++LELpjik4kYc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 February 2012, Wolfram Sang wrote:
>   > To get rid of the remaining #ifdefs, I could as well create a new
> > ohci-lpc32xx.c instead of abusing ohci-pnx4008.c. Would this be the way
> > to go or are there any other suggestions?
> 
> If you could tell the difference between pnx4008 and lpc32xx, then you could
> simply do something like:
> 
>         if (machine_is_pnx4008)
>                 pnx4008_configure();
>         else
>                 lpc32xx_configure();
> 
> or
> 
>         if (machine_is_pnx4008)
>                 pnx4008_(un)set_usb_bits

I would recomment telling this from the device itself rather than from the
platform. You can add a platform_device_id list and put information like this
into the driver_data, then do

	switch (pdev->id.driver_data) {
	case OHCI_PNX4008:
                pnx4008_configure();
		break;
	case 
		lpc32xx_configure();
		break;
	};

	if (pdev->id.driver_data == OHCI_PNX4008)
		pnx4008_(un)set_usb_bits()

Alternatively, you can put the common code into one file, and use separate
files for the parts that are different between pnx4008 and lpc32xx.

Unfortunately, the way that ohci handles the abstraction between the
various implementations is backwards, it would be much easier if the
main driver was following that model to start with.

	Arnd
