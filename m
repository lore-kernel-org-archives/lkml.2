Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2A1Ain (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 19:38:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab2A1Ail (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 19:38:41 -0500
Date: Fri, 27 Jan 2012 16:38:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: twl: optimize IRQ bit access
Message-Id: <20120127163840.ff030c49.akpm@linux-foundation.org>
In-Reply-To: <1326973942-11576-1-git-send-email-vbyravarasu@nvidia.com>
References: <1326973942-11576-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jan 2012 17:22:22 +0530
Venu Byravarasu <vbyravarasu@nvidia.com> wrote:

> From: Venu Byravarasu <vbyravarasu@nvidia.com>
> 
> As TWL RTC driver is having a cached copy of enabled RTC interrupt bits
> in variable rtc_irq_bits, that can be checked before really setting
> or masking any of the interrupt bits.
> 
> ...
>
> --- a/drivers/rtc/rtc-twl.c
> +++ b/drivers/rtc/rtc-twl.c
> @@ -176,6 +176,10 @@ static int set_rtc_irq_bit(unsigned char bit)
>  	unsigned char val;
>  	int ret;
>  
> +	/* if the bit is set, return from here */
> +	if (rtc_irq_bits & bit)
> +		return 0;
> +
>  	val = rtc_irq_bits | bit;
>  	val &= ~BIT_RTC_INTERRUPTS_REG_EVERY_M;
>  	ret = twl_rtc_write_u8(val, REG_RTC_INTERRUPTS_REG);
> @@ -193,6 +197,10 @@ static int mask_rtc_irq_bit(unsigned char bit)
>  	unsigned char val;
>  	int ret;
>  
> +	/* if the bit is clear, return from here */
> +	if (!(rtc_irq_bits & bit))
> +		return 0;
> +
>  	val = rtc_irq_bits & ~bit;
>  	ret = twl_rtc_write_u8(val, REG_RTC_INTERRUPTS_REG);
>  	if (ret == 0)

Are these functions called frequently enough to make this optimisation
significant?

I can see no locking protecting rtc_irq_bits from concurrent updaters. 
Is this code as racy as it appears?


