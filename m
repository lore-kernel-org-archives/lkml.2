Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab1DNWum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:50:42 -0400
Received: from imr4.ericy.com ([198.24.6.8]:60508 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab1DNWui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:50:38 -0400
Subject: Re: [PATCH v6 1/2] Use "request_muxed_region" in it87 watchdog
 drivers
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Nat Gurumoorthy <natg@google.com>
CC: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
In-Reply-To: <1302817069-6389-1-git-send-email-natg@google.com>
References: <1302816996-6345-1-git-send-email-natg@google.com>
	 <1302817069-6389-1-git-send-email-natg@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Thu, 14 Apr 2011 15:49:30 -0700
Message-ID: <1302821370.26780.585.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 17:37 -0400, Nat Gurumoorthy wrote:
> 01 - Changes to it87 watchdog driver to use "request_muxed_region"
> Serialize access to the hardware by using "request_muxed_region" macro defined
> by Alan Cox. Call to this macro will hold off the requestor if the resource is
> currently busy. The first call to request_muxed_region will attempt 10 times 
> to reserve the region before it gives up. This will typically get called from
> the driver init routines. If this succeeds then subsequent calls wait forever
> for the resource to be available.
> 
> The use of the above macro makes it possible to get rid of
> spinlocks in it8712f_wdt.c and it87_wdt.c watchdog drivers.
> This also greatly simplifies the implementation of it87_wdt.c driver.
> 
> Signed-off-by: Nat Gurumoorthy <natg@google.com>
> ---
> 
> diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
> index 6143f52..8bf2524 100644
> --- a/drivers/watchdog/it8712f_wdt.c
> +++ b/drivers/watchdog/it8712f_wdt.c
> @@ -51,7 +51,6 @@ MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
>  
>  static unsigned long wdt_open;
>  static unsigned expect_close;
> -static spinlock_t io_lock;
>  static unsigned char revision;
>  
>  /* Dog Food address - We use the game port address */
> @@ -121,9 +120,46 @@ static inline void superio_select(int ldn)
>  	outb(ldn, VAL);
>  }
>  
> -static inline void superio_enter(void)
> +static inline int
> +try_superio_enter(void)
>  {
> -	spin_lock(&io_lock);
> +	int num_tries = 10;
> +	/*
> +	 * Try to reserve REG and REG + 1 for exclusive access.
> +	 * Give up after 10 attempts.
> +	 */
> +	while (num_tries--) {
> +		if (!request_muxed_region(REG, 2, NAME)) {
> +			if (num_tries)
> +				continue;
> +
> +			/*
> +			 * Someone is holding the region. Give up.
> +			 */
> +			pr_err("I/O address 0x%04x already in use\n", REG);
> +			return -EBUSY;
> +		}
> +
> +		break;
> +	}
> +
This is way too complicated. Just return an error if
request_muxed_region fails, like all other callers of
request_muxed_region do.

Guenter


