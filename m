Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab2GYLQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:16:28 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43238 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756567Ab2GYLQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:16:24 -0400
Message-ID: <500FD551.9070002@mvista.com>
Date: Wed, 25 Jul 2012 15:15:29 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Afzal Mohammed <afzal@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, nsekhar@ti.com, khilman@ti.com,
        a.zummo@towertech.it, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH v2 1/6] rtc: omap: kicker mechanism support
References: <cover.1343191280.git.afzal@ti.com> <ecf6520fc9d5da53b670675a71ebece3d006cbb8.1343191280.git.afzal@ti.com>
In-Reply-To: <ecf6520fc9d5da53b670675a71ebece3d006cbb8.1343191280.git.afzal@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 25-07-2012 10:12, Afzal Mohammed wrote:

> OMAP RTC IP can have kicker feature. This prevents spurious
> writes to register. To write to registers kicker lock has to
> be released. Procedure to do it as follows,

> 1. write to kick0 register, 0x83e70b13
> 2. write to kick1 register, 0x95a4f1e0

> Writing value other than 0x83e70b13 to kick0 enables write
> locking, more details about kicker mechanism can be found in
> section 20.3.3.5.3 of AM335X TRM @www.ti.com/am335x

> Here id table information is added and is used to distinguish
> those that require kicker handling and the ones that doesn't
> need it. There are more features in the newer IP's compared
> to legacy ones other than kicker, which driver currently
> doesn't handle, supporting additional features would be
> easier with the addition of id table.

> Older IP (of OMAP1) doesn't have revision register as per
> TRM, so revision register can't be relied always to find
> features, hence id table is being used.

> Signed-off-by: Afzal Mohammed <afzal@ti.com>
> ---

> v2:
>   Use device name da830-rtc instead of am1808-rtc
>   Newly added register name made similar to that existing in the driver
>   Better commit message description

>   drivers/rtc/rtc-omap.c |   39 ++++++++++++++++++++++++++++++++++++++-
>   1 files changed, 38 insertions(+), 1 deletions(-)

> diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> index 0b614e3..8afbc2e 100644
> --- a/drivers/rtc/rtc-omap.c
> +++ b/drivers/rtc/rtc-omap.c
> @@ -38,6 +38,8 @@
>    * the SoC). See the BOARD-SPECIFIC CUSTOMIZATION comment.
>    */
>
> +#define	DRIVER_NAME			"omap_rtc"
> +
>   #define OMAP_RTC_BASE			0xfffb4800
>
>   /* RTC registers */
> @@ -64,6 +66,9 @@
>   #define OMAP_RTC_COMP_MSB_REG		0x50
>   #define OMAP_RTC_OSC_REG		0x54
>
> +#define OMAP_RTC_KICK0_REG		0x6c
> +#define OMAP_RTC_KICK1_REG		0x70
> +
>   /* OMAP_RTC_CTRL_REG bit fields: */
>   #define OMAP_RTC_CTRL_SPLIT		(1<<7)
>   #define OMAP_RTC_CTRL_DISABLE		(1<<6)
> @@ -88,11 +93,19 @@
>   #define OMAP_RTC_INTERRUPTS_IT_ALARM    (1<<3)
>   #define OMAP_RTC_INTERRUPTS_IT_TIMER    (1<<2)
>
> +/* OMAP_RTC_KICKER values */
> +#define	KICK0_VALUE			(0x83e70b13)
> +#define	KICK1_VALUE			(0x95a4f1e0)

    Parens not needed around simple literals.

>   static void __iomem	*rtc_base;
>
>   #define rtc_read(addr)		__raw_readb(rtc_base + (addr))
>   #define rtc_write(val, addr)	__raw_writeb(val, rtc_base + (addr))
>
> +#define rtc_writel(val, addr)	writel(val, rtc_base + (addr))
> +

    Why not __raw_writel() like the above functions?

WBR, Sergei

