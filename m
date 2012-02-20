Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2BTAWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:22:39 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34258 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab2BTAWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:22:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rmallon@gmail.com designates 10.68.73.234 as permitted sender) smtp.mail=rmallon@gmail.com; dkim=pass header.i=rmallon@gmail.com
Message-ID: <4F419246.6080405@gmail.com>
Date: Mon, 20 Feb 2012 11:22:30 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Lightning/1.0b2 Thunderbird/3.1.18
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/18] ARM: at91: make ST (System Timer) soc independent
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com> <957702b1ff83afcc0a8e842f53f05ff3f40b78b3.1329500622.git.nicolas.ferre@atmel.com>
In-Reply-To: <957702b1ff83afcc0a8e842f53f05ff3f40b78b3.1329500622.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/02/12 04:49, Nicolas Ferre wrote:

> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/mach-at91/at91rm9200.c              |    4 +-
>  arch/arm/mach-at91/at91rm9200_time.c         |   37 ++++++++++++++++----------
>  arch/arm/mach-at91/generic.h                 |    1 +
>  arch/arm/mach-at91/include/mach/at91_st.h    |   32 +++++++++++++++-------
>  arch/arm/mach-at91/include/mach/at91rm9200.h |    2 +-
>  drivers/watchdog/at91rm9200_wdt.c            |    8 +++---
>  6 files changed, 53 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c

Hi Jean, Nicolas,

Patch looks mostly good, couple of points below.

~Ryan

<snip>

>  	/* Cancel any pending alarm; flush any pending IRQ */
> -	at91_sys_write(AT91_ST_RTAR, alm);
> -	(void) at91_sys_read(AT91_ST_SR);
> +	at91_st_write(AT91_ST_RTAR, alm);
> +	(void) at91_st_read(AT91_ST_SR);


Can we please remove the (void) casting of the return value when making
this change, especially since at91_st_read is now a macro which doesn't
even have a return value. Same in a few other places.

>  
>  	/* Schedule alarm by writing RTAR. */
>  	alm += delta;
> -	at91_sys_write(AT91_ST_RTAR, alm);
> +	at91_st_write(AT91_ST_RTAR, alm);
>  
>  	return status;
>  }
> @@ -175,15 +175,24 @@ static struct clock_event_device clkevt = {
>  	.set_mode	= clkevt32k_mode,
>  };
>  
> +void __iomem *at91_st_base;
> +
> +void __init at91rm9200_ioremap_st(u32 addr)
> +{
> +	at91_st_base = ioremap(AT91RM9200_BASE_ST, 256);
> +	if (!at91_st_base)
> +		panic("Impossible to ioremap ST\n");
> +}


I can't see anything in this patch which calls this function? Also, why
is it extern? Can't it just be moved to whichever file is going to call
it and make it static there?
