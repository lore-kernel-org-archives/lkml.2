Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab0ETUJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 16:09:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:5659 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab0ETUJc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 16:09:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sD8Nu63VYpC2FoUvuuDP5e/uKpKuFfIR0DYG0woEbFHv6TtMO5Pj95pLGaon1XdXcn
         yCldg3L4bPWa3uKGYUvb3nxaPVocd1bggn0VG9QMtNE0UNqE4MtkeRTdq26bbG4wo4wB
         K1XhX1EH3rzCgmG+7714T6h+HscEpBTrdWXIw=
MIME-Version: 1.0
In-Reply-To: <1274385156.9756.4.camel@carter>
References: <1273355935.13191.6.camel@carter> <1274385156.9756.4.camel@carter>
Date: Thu, 20 May 2010 22:09:30 +0200
Message-ID: <AANLkTimgvFTzAf-kHUnPsGKkRM2TDSAF1Bd51oiyHppI@mail.gmail.com>
Subject: Re: [alternative-merged] serial-apbuartc-fix-two-problems-related-to-grlib_apbuart_configure.patch 
	removed from -mm tree
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kristoffer@gaisler.com,
       Andrew Morton <akpm@linux-foundation.org>, davem@davemloft.net,
       Anton Vorontsov <avorontsov@ru.mvista.com>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 9:52 PM, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
> Hi,
>
> I found two problems using the Simics' sunfire target. It occurs as well on real machines.
>
> 1. At grlib_apbuart_configure() in apbuart.c, prop can be NULL if
> "clock-frequency" doesn't exist in the OF tree:
>
>       /* Get bus frequency */
>       rp = of_find_node_by_path("/");
>       rp = of_get_next_child(rp, NULL);
>       prop = of_get_property(rp, "clock-frequency", NULL);
>       freq_khz = *prop;
>
> 2. In addition, apbuart.c does not check if there aren't any ports
> configured after calls to grlib_apbuart_configure(), so other oops will
> occur if no port was configured (e.g. uart_set_options() because of
> port->ops).
>
> In order to solve that, I added a check after both of the calls to
> grlib_apbuart_configure().
>
> The patch that I provide below prevents both problems in the Simics'
> sunfire target. In addition, it warns the users if no ports were found.

CC stable@kernel.org, as .33 is "stable" now and also has apbuart.c.

>
> Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> Acked-by: Kristoffer Glembo <kristoffer@gaisler.com>
> ---
> --- drivers/serial/apbuart.c.orig       2010-04-26 16:48:30.000000000 +0200
> +++ drivers/serial/apbuart.c    2010-05-11 15:21:28.984666230 +0200
> @@ -525,6 +525,9 @@ static void grlib_apbuart_configure(void
>  static int __init apbuart_console_init(void)
>  {
>        grlib_apbuart_configure();
> +       if (grlib_apbuart_port_nr == 0)
> +               return 0;
> +
>        register_console(&grlib_apbuart_console);
>        return 0;
>  }
> @@ -612,6 +615,10 @@ static void grlib_apbuart_configure(void
>        rp = of_find_node_by_path("/");
>        rp = of_get_next_child(rp, NULL);
>        prop = of_get_property(rp, "clock-frequency", NULL);
> +       if (prop == NULL) {
> +               grlib_apbuart_port_nr = 0;
> +               return;
> +       }
>        freq_khz = *prop;
>
>        line = 0;
> @@ -666,6 +673,10 @@ static int __init grlib_apbuart_init(voi
>
>        /* Find all APBUARTS in device the tree and initialize their ports */
>        grlib_apbuart_configure();
> +       if (grlib_apbuart_port_nr == 0) {
> +               printk(KERN_INFO "Serial: GRLIB APBUART: No ports found.\n");
> +               return -ENODEV;
> +       }
>
>        printk(KERN_INFO "Serial: GRLIB APBUART driver\n");
>
>
>
>
