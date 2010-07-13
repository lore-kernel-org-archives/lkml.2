Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab0GMVCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 17:02:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34086 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755921Ab0GMVC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 17:02:28 -0400
Subject: Re: [PATCH] introduce a default off mode for kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100713203116.GA25784@redhat.com>
References: <20100713203116.GA25784@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Tue, 13 Jul 2010 22:02:12 +0100
Message-ID: <1279054932.16438.3.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2010 21:02:12.0857 (UTC) FILETIME=[AA74A690:01CB22CE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Tue, 2010-07-13 at 21:31 +0100, Jason Baron wrote:
> Introduce a new DEBUG_KMEMLEAK_DEFAULT_OFF config parameter that allows
> kmemleak to be disabled by default, but enabled on the command line via:
> kmemleak=on. Although a reboot is required to turn it on, its still
> useful to not require a re-compile.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>

The patch makes sense. I have a few comments below.

> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 2c0d032..1006267 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -211,6 +211,11 @@ static signed long jiffies_scan_wait;
>  static int kmemleak_stack_scan = 1;
>  /* protects the memory scanning, parameters and debug/kmemleak file access */
>  static DEFINE_MUTEX(scan_mutex);
> +#ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
> +/* setting kmemleak=on, will set this var, skipping the disable */
> +static int kmemleak_skip_disable;
> +#endif

Can we have kmemleak_skip_disable always and remove the #ifdef?

> @@ -1600,10 +1605,22 @@ static int kmemleak_boot_config(char *str)
>  {
>         if (!str)
>                 return -EINVAL;
> +
>         if (strcmp(str, "off") == 0)
> +#ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
> +               return -EINVAL;
> +#else
>                 kmemleak_disable();
> -       else if (strcmp(str, "on") != 0)
> +#endif
> +       else if (strcmp(str, "on") == 0)
> +#ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
> +               kmemleak_skip_disable = 1;
> +#else
> +               return -EINVAL;
> +#endif
> +       else
>                 return -EINVAL;
> +
>         return 0;
>  }

Here I would remove all these #ifdef's. It doesn't really matter if you
pass kmemleak=off/on on the command line and kmemleak was already
disable/enabled. If we remove the #ifdef for the kmemleak_skip_disable,
we can always set the variable here.

> @@ -1616,6 +1633,13 @@ void __init kmemleak_init(void)
>         int i;
>         unsigned long flags;
> 
> +#ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
> +       if (!kmemleak_skip_disable) {
> +               kmemleak_disable();
> +               return;
> +       }
> +#endif

That's the only place where we could keep the #ifdef.

Thanks.

-- 
Catalin

