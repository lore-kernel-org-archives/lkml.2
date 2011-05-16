Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1EPTIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:08:32 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:49484 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753798Ab1EPTIb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:08:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FXXpymQEfjhluesb09pXq3dZZxhzx37wm3PvwUjPfCXHfNNa53fxujQoMpRMOP6JDW
         QYSIYMOuuZuC6jjYr2xQVHLYFFBWusHpgcj02xqogkADvrzMk2mA6Mf1UWRw/E5NdTm7
         Rfo5dJLNnH5hFb/SWxE3uIh2dH2ALOM90Pa+I=
MIME-Version: 1.0
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024C0082E3@dbde02.ent.ti.com>
References: <1297434088-27995-1-git-send-email-subhasish@mistralsolutions.com>
	<B85A65D85D7EB246BE421B3FB0FBB593024BE49175@dbde02.ent.ti.com>
	<886E26C48DE446C3937D89ECF86030B2@subhasishg>
	<B85A65D85D7EB246BE421B3FB0FBB593024BE49711@dbde02.ent.ti.com>
	<25DBF349769A4CF7B883D6D7FF01AD70@subhasishg>
	<B85A65D85D7EB246BE421B3FB0FBB593024C0082E3@dbde02.ent.ti.com>
Date: Mon, 16 May 2011 15:08:21 -0400
Message-ID: <BANLkTimDw3T2CFAw6te-smj2q07F=+_wbA@mail.gmail.com>
Subject: Re: [PATCH 1/1] davinci: changed SRAM allocator to shared ram.
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: "Nori, Sekhar" <nsekhar@ti.com>,
        Subhasish Ghosh <subhasish@mistralsolutions.com>
Cc: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "sachi@mistralsolutions.com" <sachi@mistralsolutions.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        open list <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Subhasish and Sekhar,

Subhashish, I was testing your patch here while investigating
davinci-pcm ping-pong buffers on da850.

On Fri, Feb 11, 2011 at 9:21 AM, Subhasish Ghosh
<subhasish@mistralsolutions.com> wrote:
> This patch modifies the sram allocator to allocate memory
> from the DA8XX shared RAM.
>
> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
> ---
>  arch/arm/mach-davinci/da850.c              |    6 +++---
>  arch/arm/mach-davinci/include/mach/da8xx.h |    1 +

Since this changes only the da850 behaviour, a subject prefix of da850
might be more appropriate than 'davinci'.

>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
> index 3443d97..8a4de97 100644
> --- a/arch/arm/mach-davinci/da850.c
> +++ b/arch/arm/mach-davinci/da850.c
> @@ -711,7 +711,7 @@ static struct map_desc da850_io_desc[] = {
>        },
>        {
>                .virtual        = SRAM_VIRT,
> -               .pfn            = __phys_to_pfn(DA8XX_ARM_RAM_BASE),
> +               .pfn            = __phys_to_pfn(DA8XX_SHARED_RAM_BASE),
>                .length         = SZ_8K,

Assigning only 8K to this iomap will result in a fault for the first
victim to access SRAM_VIRT+0x2000. This will happen for example with
mcasp ping-pong buffers totalling more than 8K on the da850.

Unfortunately SZ_128K cannot be used here since it will cause a panic
on boot. SZ_64K works though.

>                .type           = MT_DEVICE
>        },
> @@ -1083,8 +1083,8 @@ static struct davinci_soc_info davinci_soc_info_da850 = {
>        .gpio_irq               = IRQ_DA8XX_GPIO0,
>        .serial_dev             = &da8xx_serial_device,
>        .emac_pdata             = &da8xx_emac_pdata,
> -       .sram_dma               = DA8XX_ARM_RAM_BASE,
> -       .sram_len               = SZ_8K,
> +       .sram_dma               = DA8XX_SHARED_RAM_BASE,
> +       .sram_len               = SZ_128K,

This should probably be set to match whatever is reported in the map
entry above -- or an ioremap could be issued later but before the sram
init?

On Wed, Mar 2, 2011 at 12:12 PM, Nori, Sekhar <nsekhar@ti.com> wrote:
> [...]
>> root@arago:~# rtcwake -d /dev/rtc0 -s 20 -m mem
>> wakeup from "mem" at Tue Apr 21 14:31:13 2009
>> PM: Syncing filesystems ... done.
>> Freezing user space processes ... (elapsed 0.01 seconds) done.
>> Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
>> Suspending console(s) (use no_console_suspend to debug)
>>
>> From the Kconfig I had enabled RTC_DRV_OMAP, CONFIG_PM, CONFIG_SUSPEND.
>
> Nothing stands out from these logs. One thing to
> verify is if the RTC Alarm interrupt is really
> working by using the test program present in the
> Documentation/ folder.
>
> Anyway, the easiest way for you to move quickly is
> to use ramdisk so you can bypass all driver specific
> issues.

I tested suspend here with the patch applied on top of 2.6.39-rc7
using "rtcwake -d /dev/rtc0 -s 20 -m mem" and it works.

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
