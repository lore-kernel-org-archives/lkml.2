Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935833Ab2JaQGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:06:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50712 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935754Ab2JaQGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:06:30 -0400
Message-ID: <50914C82.5010704@wwwdotorg.org>
Date: Wed, 31 Oct 2012 10:06:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 0/4] ARM: tegra: Enable SLINK controller driver
References: <1351580726-17350-1-git-send-email-ldewangan@nvidia.com> <509038BA.30600@wwwdotorg.org> <5090E69C.4080108@nvidia.com>
In-Reply-To: <5090E69C.4080108@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 02:51 AM, Laxman Dewangan wrote:
> On Wednesday 31 October 2012 01:59 AM, Stephen Warren wrote:
>> On 10/30/2012 01:05 AM, Laxman Dewangan wrote:
>>> This series modify the dts file to add the slink addresses,
>>> make AUXDATA in board dt files, enable slink4 for tegra30-cardhu and
>>> enable slink controller defconfig.
>> This series only instantiates the SPI controller, and not any SPI
>> devices. I tried to solve this:
>>
>>> diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi
>>> b/arch/arm/boot/dts/tegra30-cardhu.dtsi
>>> index 700f0a3..3689853 100644
>>> --- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
>>> +++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
>>> @@ -278,6 +278,11 @@
>>>          spi@7000da00 {
>>>                  status = "okay";
>>>                  spi-max-frequency =<25000000>;
>>> +               flash@0 {
>>> +                       reg =<0>;
>>> +                       compatible = "atmel,at25df321a";
>>> +                       spi-max-frequency =<25000000>;
>>> +               };
>>>          };
>>>
>>>          ahub {
>> However, this didn't work. Has the driver been tested? I'm seeing the
>> exact same problems I saw with the old driver, namely that the SPI flash
>> chip can't be identified; I think the ID bytes are read back as 0, and
>> hence drivers/mtd/devices/m25p80.c falls back to identifying the device
>> as mr25h256. Attempting to hexdump -C /dev/mtd0 gives me 32K of zeros,
>> whereas the device is 4M and full of non-zero data according to U-Boot.
>>
>> Do you know what the problem is here? Can you please update the patch
>> series so that the SPI flash is instantiated and works correctly?
> 
> I will send the new patch series for taking care of the issue.
> 
> In Cardhu, there is 2 different type of flash, Winbond and Atmel.
> There is hw rework require in Cardhu A02 to enable the serial flash and
> it is already taken care in Cardhu A04. I will forward the hw rework
> details to you in internal mail communication.

U-Boot appears able to identify the flash chip on my board:

SF: Detected AT25DF321A with page size 256, total 4 MiB

So I guess I have the rework.

> Also Serial flash is in CS1, not in CS0. So even if you have hw rework,
> above change will not work.

Presumably that simply requires changing from:

              flash@0 {
                      reg = <0>;

to:

              flash@1 {
                      reg = <1>;

Aha, indeed that does appear to solve the issue; I can see the U-Boot
environment block when I run "hexdump -C /dev/mtd0" now.

I had forgotten about this from when I tested the older SPI driver that
we ripped out; I had at least compared the registers between U-Boot and
the kernel with that driver, so I'm pretty sure I didn't make that
mistake with the old driver.

So, I'll apply your patch series, and send one to add the flash device
to the Cardhu .dts.
