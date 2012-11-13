Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2KMTB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:01:28 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58420 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab2KMTB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:01:27 -0500
Date: Tue, 13 Nov 2012 11:01:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Constantine Shulyupin <const@MakeLinux.com>
Cc: linux-kernel@vger.kernel.org, celinux-dev@lists.celinuxforum.org,
        Tim Bird <tim.bird@am.sony.com>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Selim TEMUR <selimtemur@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] LDT - Linux Driver Template
Message-ID: <20121113190123.GA32271@kroah.com>
References: <1352832397-1349-1-git-send-email-const@MakeLinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352832397-1349-1-git-send-email-const@MakeLinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 08:46:37PM +0200, Constantine Shulyupin wrote:
> +++ b/samples/ltd/ldt.c
> @@ -0,0 +1,764 @@
> +/*
> + *	LDT - Linux Driver Template
> + *
> + *	Copyright (C) 2012 Constantine Shulyupin http://www.makelinux.net/
> + *
> + *	Dual BSD/GPL License

That makes no sense for Linux-specific kernel code, why would you want
it to be dual licensed?  Please fix this.

> + *	Device Model (class, device)

Don't use class code in an example, it is slowly going away from the
whole kernel.

> +#define ctracer_cut_path(fn) (fn[0] != '/' ? fn : (strrchr(fn, '/') + 1))
> +#define __file__	ctracer_cut_path(__FILE__)

Why is this needed?

> +/*
> + *	print_context prints execution context:
> + *	hard interrupt, soft interrupt or scheduled task
> + */
> +
> +#define print_context()	\
> +	pr_debug("%s:%d %s %s 0x%x\n", __file__, __LINE__, __func__, \
> +			(in_irq() ? "harirq" : current->comm), preempt_count());

Ick, no, never do that.

> +#define once(exp) do { \
> +	static int _passed; if (!_passed) { exp; }; _passed = 1; } while (0)

We have macros for this already.

> +#define check(a) \
> +	(ret = a, ((ret < 0) ? pr_warning("%s:%i %s FAIL\n\t%i=%s\n", \
> +	__file__, __LINE__, __func__, ret, #a) : 0), ret)

Why?

> +#define pr_debug_hex(h)	pr_debug("%s:%d %s %s = 0x%lX\n", \
> +	__file__, __LINE__, __func__, #h, (long int)h)

This is not needed at all, just use the proper printk() attribute.

> +#define pr_debug_dec(d)	pr_debug("%s:%d %s %s = %ld\n", \
> +	__file__, __LINE__, __func__, #d, (long int)d)

Why?

> +#define pr_err_msg(m)	pr_err("%s:%d %s %s\n", __file__, __LINE__, __func__, m)

Again, why?

Please don't create your own debugging macros, otherwise people will
copy them.  Use the in-kernel ones, as they are the ones everyone should
use.  And never use the __file__ things, that looks horrible when
building a kernel and makes no sense.

> +static char ldt_name[] = KBUILD_MODNAME;

Why not just use the macro itself?

> +static int bufsize = PFN_ALIGN(16 * 1024);

Why align?

> +static void *in_buf;
> +static void *out_buf;
> +static int uart_detected;
> +void *port_ptr;

Not static?  I'm guessing you didn't run this through sparse?

> +static int port;
> +module_param(port, int, 0);
> +static int port_size;
> +module_param(port_size, int, 0);
> +
> +static int irq;
> +module_param(irq, int, 0);
> +
> +static int loopback;
> +module_param(loopback, int, 0);

No descriptions?  Not good.

I've stopped here, I think this has a bunch more work in order to be a
"correct" example in the kernel source tree.

> +MODULE_LICENSE("Dual BSD/GPL");

Note that modules that touch driver core functions, like this one, can't
really be BSD licensed, sorry.

greg k-h
