Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1GEOGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:06:07 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:47193 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab1GEOGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:06:05 -0400
Date: Tue, 5 Jul 2011 18:05:59 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Tommy Lin <tommy.lin.1101@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, mac.lin@caviumnetworks.com,
        Tommy Lin <tommy.lin@caviumnetworks.com>
Subject: Re: [PATCH 2/2] watchdog: mpcore_wdt Add reload value setting for
 CNS3xxx hardware
Message-ID: <20110705140559.GA15771@oksana.dev.rtsoft.ru>
References: <1309867548-7842-1-git-send-email-tommy.lin@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1309867548-7842-1-git-send-email-tommy.lin@caviumnetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

thanks for the patches.

On Tue, Jul 05, 2011 at 08:05:48PM +0800, Tommy Lin wrote:
> Original MPcore watchdog setting about load register (offset 0x20) is different
> from CNS3xxx data sheet. The CNS3xxx data sheet says watchdog has following
> features:
> 1. The Watchdog Counter Register (offset 0x24) is a down counter.
> 2. The timer interval is calculated using following equation:
>    (PRESCALER_value+1) X (Load_value+1) X 2 / CPU CLK_frequency
> Thus the watchdog load register control in CNS3xxx way is add to MPcore watchdog
> source. The original control method is also kept if the CPU architecture is not
> CNS3xxx.
> 
> Signed-off-by: Tommy Lin <tommy.lin@caviumnetworks.com>
> ---
>  drivers/watchdog/mpcore_wdt.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
> index 2b4af22..816e0c5 100644
> --- a/drivers/watchdog/mpcore_wdt.c
> +++ b/drivers/watchdog/mpcore_wdt.c
> @@ -42,6 +42,9 @@ struct mpcore_wdt {
>  	int		irq;
>  	unsigned int	perturb;
>  	char		expect_close;
> +#ifdef CONFIG_ARCH_CNS3XXX
> +	unsigned long	reload_unit; /* ticks per second */
> +#endif

Nope, these #ifdefs are not acceptible. Kernel should support multi-arch
images soon.

[...]
> +#ifdef CONFIG_ARCH_CNS3XXX
> +	/* Assume prescale is set to 256 */
> +	wdt->reload_unit = cns3xxx_cpu_clock() * 1000000 / 256 / 2;
> +#endif

You probably want to pass reload_unit via platform_data, and also
check (in runtime) that the watchdog is CNS3xxx. Or if reload_unit
!= 0.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
