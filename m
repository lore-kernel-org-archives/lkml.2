Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab1BBUes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:34:48 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:36595 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab1BBUeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:34:46 -0500
Subject: Re: [PATCH] RTC: Prevents a division by zero in kernel code.
From: John Stultz <john.stultz@linaro.org>
To: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1296669842-32611-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
References: <1296669842-32611-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 12:34:33 -0800
Message-ID: <1296678873.3336.248.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 16:04 -0200, Marcelo Roberto Jimenez wrote:
> This patch prevents a user space program from calling the RTC_IRQP_SET
> ioctl with a negative value of frequency. Also, if this call is make
> with a zero value of frequency, there would be a division by zero in the
> kernel code.
> 
> Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>

Probably need to also initialize irq_freq to 1 on rtc_device_register so
we don't trip over the divbyzero on rtc devices that don't initialize
that value.

I'll add that and fwd on your patch!

Great catch!

thanks
-john

> ---
>  drivers/rtc/interface.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
> index 925006d..a0c0196 100644
> --- a/drivers/rtc/interface.c
> +++ b/drivers/rtc/interface.c
> @@ -464,6 +464,9 @@ int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
>  	int err = 0;
>  	unsigned long flags;
> 
> +	if (freq <= 0)
> +		return -EINVAL;
> +
>  	spin_lock_irqsave(&rtc->irq_task_lock, flags);
>  	if (rtc->irq_task != NULL && task == NULL)
>  		err = -EBUSY;


