Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0EQPwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:52:12 -0400
Received: from www.sr71.net ([198.145.64.142]:59762 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab0EQPwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:52:11 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 May 2010 11:52:10 EDT
Subject: Re: [PATCH] leds-ss4200: fix led_classdev_unregister twice in
 error handling
From: Dave Hansen <dave@sr71.net>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Rodney Girod <rgirod@confocus.com>,
       Richard Purdie <rpurdie@linux.intel.com>
In-Reply-To: <1274074963.25630.2.camel@mola>
References: <1274074963.25630.2.camel@mola>
Content-Type: text/plain
Date: Mon, 17 May 2010 08:45:34 -0700
Message-Id: <1274111134.21875.4909.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 13:42 +0800, Axel Lin wrote:
> In current implementation, if device_create_file failed in
> register_nasgpio_led,
> led_classdev_unregister will be executed twice.
> ( in register_nasgpio_led it calls led_classdev_unregister before
> return and in nas_gpio_init out_err )
> 
> This patch fixes it by only unregistering those that were successfully
> registered in out_err.
> ( not including last failed register_nasgpio_led call )

Did you actually run into this, or did you find this just auditing code?

> diff --git a/drivers/leds/leds-ss4200.c b/drivers/leds/leds-ss4200.c
> index 51477ec..a688293 100644
> --- a/drivers/leds/leds-ss4200.c
> +++ b/drivers/leds/leds-ss4200.c
> @@ -534,7 +534,7 @@ static int __init nas_gpio_init(void)
>  	set_power_light_amber_noblink();
>  	return 0;
>  out_err:
> -	for (; i >= 0; i--)
> +	for (i--; i >= 0; i--)
>  		unregister_nasgpio_led(i);
>  	pci_unregister_driver(&nas_gpio_pci_driver);
>  	return ret;

That i-- took me a minute to grok, but there isn't something immensely
better here.  If you have to resubmit these somehow, please add a
comment there.  But, otherwise, 

Acked-by: Dave Hansen <dave@sr71.net>

-- Dave

