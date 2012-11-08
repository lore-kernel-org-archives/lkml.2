Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab2KHXG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 18:06:26 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38241 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab2KHXGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 18:06:24 -0500
Message-ID: <509C3AE7.7030703@gmail.com>
Date: Fri, 09 Nov 2012 10:06:15 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 04/11] ARM: set arch_gettimeoffset directly
References: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org> <1352408516-21988-6-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1352408516-21988-6-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/12 08:01, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> remove ARM's struct sys_timer .offset function pointer, and instead
> directly set the arch_gettimeoffset function pointer when the timer
> driver is initialized. This requires multiplying all function results
> by 1000, since the removed arm_gettimeoffset() did this. Also,
> s/unsigned long/u32/ just to make the function prototypes exactly
> match that of arch_gettimeoffset.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Andrew Victor <linux@maxim.org.za>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  arch/arm/include/asm/mach/time.h  |    3 ---
>  arch/arm/kernel/time.c            |   14 --------------
>  arch/arm/mach-at91/at91x40_time.c |    8 +++++---
>  arch/arm/mach-ebsa110/core.c      |    7 ++++---
>  arch/arm/mach-ep93xx/core.c       |   23 ++++++++++++-----------
>  arch/arm/mach-h720x/common.c      |    6 +++---
>  arch/arm/mach-h720x/common.h      |    2 +-
>  arch/arm/mach-h720x/cpu-h7201.c   |    3 ++-
>  arch/arm/mach-h720x/cpu-h7202.c   |    3 ++-
>  arch/arm/mach-rpc/time.c          |    6 +++---
>  arch/arm/plat-samsung/time.c      |    7 ++++---
>  11 files changed, 36 insertions(+), 46 deletions(-)

<snip>

> +static u32 ep93xx_gettimeoffset(void)
> +{
> +	int offset;
> +
> +	offset = __raw_readl(EP93XX_TIMER4_VALUE_LOW) - last_jiffy_time;
> +
> +	/* Calculate (1000000 / 983040) * offset.  */

This comment is now incorrect, it should say:

	/* Calculate (1000000000 / 983040) * offset */

or perhaps to better explain what is being done:

	/*
	 * Timer 4 is based on a 983.04 kHz reference clock,
	 * so dividing by 983040 gives a milli-second value.
	 * Refactor the calculation to avoid overflow.
	 */

> +	return (offset + (53 * offset / 3072)) * 1000;
> +}

~Ryan


