Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab1E3Cwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 22:52:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60545 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab1E3Cwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 22:52:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xZZa7aR57pqJqvYc+DU+JyOW79uVlimPXUzQJ5f/XYF0LG317KOJgsrP8dkfWsS4LZ
         VVKO13Odip8P4YfMIy7JF3eI6rWBihoCCjUhdZofu6WoNNW3WRQokPcVy82E53VUIR1a
         qZUizeyYM49faVmp7PMRrQiWtFlJux4DIkB8s=
Message-ID: <4DE305FD.4040503@samsung.com>
Date: Sun, 29 May 2011 19:50:37 -0700
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Kyungmin Park <kmpark@infradead.org>
CC: Randy Dunlap <rdunlap@xenotime.net>, lkml <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: gpio: gpio-exynos4 build fails in mainline
References: <20110529083032.d3d16059.randy.dunlap@oracle.com> <20110529083520.41730250.randy.dunlap@oracle.com> <20110529084000.68a6351a.randy.dunlap@oracle.com> <20110529084440.a4803072.rdunlap@xenotime.net> <BANLkTinhXj51dzCnnXhxrCLeW1qQES6CvA@mail.gmail.com>
In-Reply-To: <BANLkTinhXj51dzCnnXhxrCLeW1qQES6CvA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/11 18:24, Kyungmin Park wrote:
> On Mon, May 30, 2011 at 12:44 AM, Randy Dunlap<rdunlap@xenotime.net>  wrote:
>> On Sun, 29 May 2011 08:40:00 -0700 Randy Dunlap wrote:

(snip)

>>
>> drivers/gpio/gpio-s5pv210.c:17:11: error: unable to open 'plat/gpio-core.h'
>
Hi all,

Grrr, :(

> Hi,
>
> Right, now it's just moved from mach directories to drivers/gpio
> So it requires the proper depends on each ARCH_CPU.
>
Please add me in Cc on this.

> ---
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 5923976..655babf 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -88,24 +88,28 @@ config GPIO_IT8761E
>
>   config GPIO_EXYNOS4
>          bool "Samsung Exynos4 GPIO library support"
> +       depends on CPU_EXYNOS4210
>          default y if CPU_EXYNOS4210
>          help
>            Say yes here to support Samsung Exynos4 series SoCs GPIO library

Basically, GPIO_EXYNOS4 is used only for EXYNOS4(EXYNOS4210) and was 
selected as a default on EXYNOS4 before moving into drivers/. I mean, do 
we really need to select this manually in kernel configuration(like make 
menuconfig)?

And I think, it's more reasonable that depends on ARCH_XXX not CPU_XXX.

Grant, how about following?

+config GPIO_EXYNOS4
+ 	bool
+	depends on ARCH_EXYNOS4
+	default y if CPU_EXYNOS4210

>
>   config GPIO_PLAT_SAMSUNG
>          bool "Samsung SoCs GPIO library support"
> +       depends on SAMSUNG_GPIOLIB_4BIT
>          default y if SAMSUNG_GPIOLIB_4BIT
>          help
>            Say yes here to support Samsung SoCs GPIO library
>
Same as above.

+config GPIO_PLAT_SAMSUNG
+	bool
+	depends on PLAT_SAMSUNG
+	default y if SAMSUNG_GPIOLIB_4BIT

>   config GPIO_S5PC100
>          bool "Samsung S5PC100 GPIO library support"
> +       depends on CPU_S5PC100
>          default y if CPU_S5PC100
>          help
>            Say yes here to support Samsung S5PC100 SoCs GPIO library
>
Same...

+config GPIO_S5PC100
+	bool
+	depends on ARCH_S5PC100
+	default y if CPU_S5PC100

>   config GPIO_S5PV210
>          bool "Samsung S5PV210/S5PC110 GPIO library support"
> +       depends on CPU_S5PV210
>          default y if CPU_S5PV210
>          help
>            Say yes here to support Samsung S5PV210/S5PC110 SoCs GPIO library
>
Same.

+config GPIO_S5PV210
+	bool
+	depends on ARCH_S5PV210
+	default y if CPU_S5PV210

One more, IMHO, would be better if they could not split like following.
As you know, 'PLAT_SAMSUNG' includes common GPIOlib for other Samsung SoCs.

config GPIO_PLAT_SAMSUNG
...
config GPIO_S5PC100
...
config GPIO_S5PV210
...
config GPIO_EXYNOS4
...


Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
