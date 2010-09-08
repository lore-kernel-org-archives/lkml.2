Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab0IHNjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:39:49 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:2174 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab0IHNjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:39:47 -0400
Date: Wed, 8 Sep 2010 15:39:32 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, Ben Dooks <ben-linux@fluff.org>,
        lm-sensors@lm-sensors.org
Subject: Re: [patch 29/30] hwmon: s3c-hwmon: Use a real mutex
Message-ID: <20100908153932.417111d0@hyperion.delvare>
In-Reply-To: <20100907125057.470704521@linutronix.de>
References: <20100907124636.880953480@linutronix.de>
	<20100907125057.470704521@linutronix.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Sep 2010 14:33:57 -0000, Thomas Gleixner wrote:
> The semaphore which protects the ADC is semantically a mutex. Use a
> real mutex.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: lm-sensors@lm-sensors.org
> ---
>  drivers/hwmon/s3c-hwmon.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/drivers/hwmon/s3c-hwmon.c
> ===================================================================
> --- linux-2.6.orig/drivers/hwmon/s3c-hwmon.c
> +++ linux-2.6/drivers/hwmon/s3c-hwmon.c
> @@ -51,7 +51,7 @@ struct s3c_hwmon_attr {
>   * @attr: The holders for the channel attributes.
>  */
>  struct s3c_hwmon {
> -	struct semaphore	lock;
> +	struct mutex		lock;
>  	struct s3c_adc_client	*client;
>  	struct device		*hwmon_dev;
>  
> @@ -73,14 +73,14 @@ static int s3c_hwmon_read_ch(struct devi
>  {
>  	int ret;
>  
> -	ret = down_interruptible(&hwmon->lock);
> +	ret = mutex_lock_interruptible(&hwmon->lock);
>  	if (ret < 0)
>  		return ret;
>  
>  	dev_dbg(dev, "reading channel %d\n", channel);
>  
>  	ret = s3c_adc_read(hwmon->client, channel);
> -	up(&hwmon->lock);
> +	mutex_unlock(&hwmon->lock);
>  
>  	return ret;
>  }
> @@ -296,7 +296,7 @@ static int __devinit s3c_hwmon_probe(str
>  
>  	platform_set_drvdata(dev, hwmon);
>  
> -	init_MUTEX(&hwmon->lock);
> +	mutex_init(&hwmon->lock);
>  
>  	/* Register with the core ADC driver. */
>  
> 
> 

Applied, thanks.

-- 
Jean Delvare
