Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2IKRi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:38:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48639 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab2IKRi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:38:26 -0400
MIME-Version: 1.0
In-Reply-To: <504DF63A020000780009A30B@nat28.tlf.novell.com>
References: <504DF63A020000780009A30B@nat28.tlf.novell.com>
Date: Tue, 11 Sep 2012 19:38:24 +0200
Message-ID: <CACRpkdbCmou3wTXJjPhSaCH0kH1VrU5n-9t7NTJOjFQs1xH+cA@mail.gmail.com>
Subject: Re: [PATCH] allow gpiolib to be a module
From: Linus Walleij <linus.walleij@linaro.org>
To: Jan Beulich <JBeulich@suse.com>, Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 2:16 PM, Jan Beulich <JBeulich@suse.com> wrote:

> Without ARCH_REQUIRE_GPIOLIB there's no reason to force this code, when
> enabled, to always be built into the kernel, which requires only minor
> Makefile and source code adjustments.
>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

I *really* want Grant's opinion on this patch before merging
it...

> +++ 3.6-rc5-gpiolib-module/drivers/gpio/gpiolib.c
> @@ -1003,7 +1003,9 @@ static int __init gpiolib_sysfs_init(voi
>
>         return status;
>  }
> +#ifndef MODULE
>  postcore_initcall(gpiolib_sysfs_init);
> +#endif

#ifdefs are ugly but allright I don't know if there are any better
ways to do this.

(...)

> +#ifndef MODULE
>  subsys_initcall(gpiolib_debugfs_init);
> +#endif
>
>  #endif /* DEBUG_FS */
> +
> +#ifdef MODULE
> +int __init gpiolib_init(void)
> +{
> +       return gpiolib_sysfs_init() ?: gpiolib_debugfs_init();

I can't parse this, sorry the gpio subsystem maintainer is too bad coder.
What about something more readable?

int ret;

ret = gpiolib_sysfs_init();
if (ret)
   return ret;
return gpiolib_debugfs_init();

I know it doesn't look as cool but it's easier for me to understand.

There is a bug too: I don't think this compiles if you compile as
a module but disable debugfs. Try it out.

> +}
> +module_init(gpiolib_init);
> +
> +MODULE_DESCRIPTION("GPIO library");
> +MODULE_LICENSE("GPL");

These two things don't really need to be inside an #ifdef
right?

> +#endif

Yours,
Linus Walleij
