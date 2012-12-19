Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab2LSU25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:28:57 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:43105 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2LSU2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:28:48 -0500
Message-ID: <50D22379.9090909@gmail.com>
Date: Wed, 19 Dec 2012 21:28:41 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: linux-usb@vger.kernel.org, dianders@chromium.org, l.majewski@samsung.com,
        linux-samsung-soc@vger.kernel.org, p.paneri@samsung.com,
        gregkh@linuxfoundation.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, kyungmin.park@samsung.com,
        kgene.kim@samsung.com, ben-linux@fluff.org,
        broonie@opensource.wolfsonmicro.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: Re: [PATCH v2] usb: phy: samsung: Add support to set pmu isolation
References: <1355810167-18425-2-git-send-email-gautam.vivek@samsung.com> <1355838966-11269-1-git-send-email-gautam.vivek@samsung.com> <50D0F9EA.9090002@gmail.com> <CAFp+6iGTRpDRcES862hcXL59DcG=GPEZ6B6r2jtw575P-8kCPw@mail.gmail.com> <CAFp+6iFHzARtKD6Off7h7_0fcxx52rFoT2V8ucy_a2kTd4bf1w@mail.gmail.com>
In-Reply-To: <CAFp+6iFHzARtKD6Off7h7_0fcxx52rFoT2V8ucy_a2kTd4bf1w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/19/2012 02:44 PM, Vivek Gautam wrote:
>>>> --- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
>>>> +++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
>>>> @@ -9,3 +9,15 @@ Required properties:
>>>>    - compatible : should be "samsung,exynos4210-usbphy"
>>>>    - reg : base physical address of the phy registers and length of memory
>>>> mapped
>>>>          region.
>>>> +
>>>> +Optional properties:
>>>> +- samsung,usb-phyhandle : should point to usb-phyhandle sub-node which
>>>> provides
>>>> +                       binding data to enable/disable device PHY handled
>>>> by
>>>> +                       PMU register.
>>>> +
>>>> +                       Required properties:
>>>> +                       - compatible : should be "samsung,usbdev-phyctrl"
>>>> for
>>>> +                                       DEVICE type phy.
>>>> +                       - samsung,phyhandle-reg: base physical address of
>>>> +                                               PHY_CONTROL register in
>>>> PMU.
>>>> +- samsung,enable-mask : should be '1'
>>>
>>>
>>> This should only be 1 for Exynos4210+ SoCs, right ?
>
> Yes that's true Exynso4210+ SoCs have only single PHY for both host and device
> which gets enabled by single bit.
>
>>> S5PV210 uses bit 0 for OTG and bit1 for USB host, doesn't it ? And for
>>> s3c64xx
>>> it seems to be bit 16.
>>>
> True, S5PV210 uses two bits separately for OTG and HOST, so in that
> case we would
> require to set both these bits. Thanks for pointing out !!
>
> I couldn't see device tree support for S5PV210 and S3C64xx so thought
> of going for
> 4210+ SoCs. Better we make this more generic so that once these SoCs
> are moved to
> device tree we don't face any issue. Right ??

Fair enough. Yes, let's not make any future addition of the device tree
support for the older Samsung platforms unnecessarily difficult. It doesn't
take much effort, and there is many drivers that are shared by multiple 
SoCs
already, starting from s3c64xx to exynos4 series.

>>> How about deriving this information from 'compatible' property instead ?
>
> It will definitely be good to use the compatible property to derive
> such information,
> Need to amend the current approach.
>
>>> Maybe you could just encode the USB PMU registers (I assume those aren't
>>> touched by anything but the usb drivers) in a regular 'reg' property in
>>> an usbphy subnode. Then the driver could interpret it also with help
>>> of 'compatible' property. And you could just use of_iomap(). E.g.
>>>
>>>   usbphy@12130000 {
>>>          compatible = "samsung,exynos5250-usbphy";
>>>          reg =<0x12130000 0x100>,<0x12100000 0x100>;
>>>          usbphy-pmu {
>>>                  /* USB device and host PHY_CONTROL registers */
>>>                  reg =<0x10040704 8>;
>>>          };
>>>   };
>>>
>
> This approach seems nice.
>
>>> Your "samsung,usb-phyhandle" approach seems over-engineered to me.
>>> I might be missing something though.
>>>
>
> The idea behind using phandles for usb-phy was to get the multiple
> registers (2 in PMU
> and 1 in SYSREG) and program them separately as required.

You could still specify multiple <address, size> pairs in 'reg' property
or perhaps use separate node for SYSREG. And if on some SoCs PHY_CONTROL
registers do not immediately follow each other in memory it might make
sense to define the bindings so that each register is specified separately,
e.g.

reg = <0x10040704 4>, <0x10040708 4>, <0x10050230 4>;

However AFAICS single region for the PHY_CONTROL registers should be
sufficient for all existing SoCs.

--

Thanks,
Sylwester
