Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab0EKNtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 09:49:12 -0400
Received: from mail168c2.megamailservers.com ([69.49.111.68]:46260 "EHLO
	mail168c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757218Ab0EKNtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 09:49:11 -0400
X-Authenticated-User: kristoffer.gaisler.com
Message-ID: <4BE95EC4.9040007@gaisler.com>
Date: Tue, 11 May 2010 15:42:28 +0200
From: Kristoffer Glembo <kristoffer@gaisler.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070601 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] [OOPS] apbuart.c: Two problems related to grlib_apbuart_configure()
References: <1273355935.13191.6.camel@carter> <1273585084.8948.12.camel@carter>
In-Reply-To: <1273585084.8948.12.camel@carter>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CHA: v=1.1 cv=xtCnJSom9T2N2UelX0toS8pAVgrNlnn4sCvERQ3pbX4= c=1 sm=1
		a=BiUTNxJIdrUA:10 a=IkcTkHD0fZMA:10 a=jXKJviUpWSOlMmIvGrHOfw==:17
		a=ebG-ZW-8AAAA:8 a=pGLkceISAAAA:8 a=t-zvxfE_yFA8KV9oKpoA:9
		a=lzMLTxmbwYwclHfjIqoA:7 a=9UdasKBbNJ6dCqVdXwY1_WJCU24A:4 a=QEXdDO2ut3YA:10
		a=cCYF7-FHeg4A:10 a=MSl-tDqOz04A:10 a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looks finer :-)

Acked-by: Kristoffer Glembo <kristoffer@gaisler.com>


Miguel Ojeda wrote:
> Hi,
> 
> Kristoffer, please check this one instead.
> 
> Changes:
> 1. Added the grlib_apbuart_port_nr = 0 line.
> 2. Returned -ENODEV instead of 0 in the "no ports found branch" in
> init(), because if compiled as a module, exit() will try to unregister
> things that were not registered. In addition, this will alert the users
> that modprobe'd.
> 3. Deleted the unused __FILE__ argument of the previous patch (oops
> sorry :).
> 
> Andrew, if Kristoffer agrees, please drop the older patch from -mm and
> merge this one instead.
> 
> Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> ---
> --- drivers/serial/apbuart.c.orig	2010-04-26 16:48:30.000000000 +0200
> +++ drivers/serial/apbuart.c	2010-05-11 15:21:28.984666230 +0200
> @@ -525,6 +525,9 @@ static void grlib_apbuart_configure(void
>  static int __init apbuart_console_init(void)
>  {
>  	grlib_apbuart_configure();
> +	if (grlib_apbuart_port_nr == 0)
> +		return 0;
> +
>  	register_console(&grlib_apbuart_console);
>  	return 0;
>  }
> @@ -612,6 +615,10 @@ static void grlib_apbuart_configure(void
>  	rp = of_find_node_by_path("/");
>  	rp = of_get_next_child(rp, NULL);
>  	prop = of_get_property(rp, "clock-frequency", NULL);
> +	if (prop == NULL) {
> +		grlib_apbuart_port_nr = 0;
> +		return;
> +	}
>  	freq_khz = *prop;
>  
>  	line = 0;
> @@ -666,6 +673,10 @@ static int __init grlib_apbuart_init(voi
>  
>  	/* Find all APBUARTS in device the tree and initialize their ports */
>  	grlib_apbuart_configure();
> +	if (grlib_apbuart_port_nr == 0) {
> +		printk(KERN_INFO "Serial: GRLIB APBUART: No ports found.\n");
> +		return -ENODEV;
> +	}
>  
>  	printk(KERN_INFO "Serial: GRLIB APBUART driver\n");
>  
> 
> 

