Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab2BVWSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 17:18:08 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34836 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab2BVWSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 17:18:05 -0500
Message-ID: <4F456997.50500@gmail.com>
Date: Thu, 23 Feb 2012 09:17:59 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Lightning/1.0b2 Thunderbird/3.1.18
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 03/19] ARM: at91: make matrix register base soc independent
References: <1329903585-30738-1-git-send-email-nicolas.ferre@atmel.com> <4b71fdf7ee746a09b7ee468aa3bc60d6c34d4c20.1329903206.git.nicolas.ferre@atmel.com>
In-Reply-To: <4b71fdf7ee746a09b7ee468aa3bc60d6c34d4c20.1329903206.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/02/12 20:39, Nicolas Ferre wrote:

> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: linux-usb@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


Looks okay, one comment (for future) below, but otherwise:

Reviewed-by: Ryan Mallon <rmallon@gmail.com>

<snip>

> diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
> index 8bdba2a..5fd6fe8 100644
> --- a/arch/arm/mach-at91/at91sam9263.c
> +++ b/arch/arm/mach-at91/at91sam9263.c
> @@ -306,6 +306,7 @@ static void __init at91sam9263_ioremap_registers(void)
>  	at91sam926x_ioremap_pit(AT91SAM9263_BASE_PIT);
>  	at91sam9_ioremap_smc(0, AT91SAM9263_BASE_SMC0);
>  	at91sam9_ioremap_smc(1, AT91SAM9263_BASE_SMC1);
> +	at91_ioremap_matrix(AT91SAM9263_BASE_MATRIX);


Not necessarily for this patch set, but this list of functions is
getting long enough that it could be abstracted away by a table.
Something like:

  struct at91_sys_device {
	const char *name;
	void __iomem **base;
	const unsigned long mem_start;
	const unsigned long mem_size;
  };

  ...

  static const struct
  at91_sys_device at91sam9263_sys_devices[] __initconst = {
	{"PIT",	&at91_pit_base,
	 AT91SAM9263_BASE_PIT, AT91_PIT_SIZE},
	...
	{"matrix", &at91_matrix_base,
	 AT91SAM9263_BASE_MATRIX, AT91_MATRIX_SIZE},
  }

  ...

  void __init
  at91_ioremap_sys_devices(const struct at91_sys_device *devices,
			   int nr_devices)
  {
	int i;

	for (i = 0; i < nr_devices; i++) {
		void __iomem *base = *(dev[i].base);

		base = ioremap(dev[i].mem_start, dev[i].mem_size);
		if (!base)
			panic("Impossible to ioremap AT91 %s\n",
			      dev[i].name);
  }

~Ryan
