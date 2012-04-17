Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab2DQVEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 17:04:01 -0400
Received: from antcom.de ([188.40.178.216]:59149 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab2DQVD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 17:03:59 -0400
Message-ID: <4F8DDABA.2070208@antcom.de>
Date: Tue, 17 Apr 2012 23:03:54 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        thierry.reding@avionic-design.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH v2 1/8] ohci-nxp: Driver cleanup
References: <1334682507-15055-1-git-send-email-stigge@antcom.de> <1334682507-15055-2-git-send-email-stigge@antcom.de> <201204172036.15663.arnd@arndb.de>
In-Reply-To: <201204172036.15663.arnd@arndb.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 17/04/12 22:36, Arnd Bergmann wrote:
>> +       hcd->regs = devm_request_and_ioremap(&pdev->dev, res);
>> +       if (!hcd->regs) {
>> +               err("Failed to devm_request_and_ioremap");
>>                 ret =  -ENOMEM;
>>                 goto out4;
>>         }
>> -       hcd->regs = (void __iomem *)pdev->resource[0].start;
>> +       hcd->rsrc_start = (u64)(u32)hcd->regs;
>> +       hcd->rsrc_len = resource_size(res);
> 
> This is wrong in multiple ways:
> 
> * rsrc_start is a physical address, not an __iomem token.
> * you cannot cast a pointer to u32 in general, only to unsigned long.
> 
> The fact that you need an ugly type cast like above could have told
> you that you are doing something wrong here. I guess it should
> be
> 
> 	hcd->rsrc_start = res->start;

Right. Thanks for the hint!

Technically, I ported the bug, didn't introduce it ;-)
(pdev->resource[0].start was previously provided via resource already in
IO_ADDRESS (mapped) format). Nevertheless, it's a bug, of course, and it
didn't show up since the driver seems to not use hcd->rsrc_start anyway
(but hcd->regs).

Will post an update after making sure it's tested well.

Roland
