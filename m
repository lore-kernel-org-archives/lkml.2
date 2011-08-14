Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1HNQzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:55:43 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:45340 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab1HNQzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:55:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAH+eYFD61keboBWfcnxEAwW-4PmoLpofZh08k606OkALg_VFuQ@mail.gmail.com>
References: <CAH+eYFD61keboBWfcnxEAwW-4PmoLpofZh08k606OkALg_VFuQ@mail.gmail.com>
Date: Sun, 14 Aug 2011 12:55:41 -0400
Message-ID: <CACqU3MU2pjcqgYDjn=S2asdLamU0mity+kLizH_mbTtJU5Fh2A@mail.gmail.com>
Subject: Re: IS_ENABLED() and non-available symbols
From: Arnaud Lacombe <lacombar@gmail.com>
To: Rabin Vincent <rabin@rab.in>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Aug 14, 2011 at 6:56 AM, Rabin Vincent <rabin@rab.in> wrote:
> I'm trying to use the new IS_ENABLED() stuff, but it appears that it
> only works if the symbol being tested has its dependencies met, and
> results in compiler errors if that is not the case.
>
> For example, I've added code using IS_ENABLED(CONFIG_THUMB2_KERNEL) as
> in the below patch.  My config is arch/arm/configs/omap2plus_defconfig
> which doesn't satisfy the dependencies for CONFIG_THUMB2_KERNEL (defined
> in arch/arm/Kconfig).
>
> Compiling results in the following errors (and indeed the macro hasn't
> been generated in include/generated/autoconfg.h).  If I modify my config
> to satisfy the dependencies for CONFIG_THUMB2_KERNEL so that it is
> selectable, the __enabled_CONFIG_THUMB2_KERNEL macro gets generated.
>
> arch/arm/kernel/setup.c: In function 'c_show':
> arch/arm/kernel/setup.c:1056: error: '__enabled_CONFIG_THUMB2_KERNEL'
> undeclared (first use in this function)
> arch/arm/kernel/setup.c:1056: error: (Each undeclared identifier is
> reported only once
> arch/arm/kernel/setup.c:1056: error: for each function it appears in.)
> arch/arm/kernel/setup.c:1056: error:
> '__enabled_CONFIG_THUMB2_KERNEL_MODULE' undeclared (first use in this
> function)
>
> Kernel is latest linus (v3.1-rc1-272-g73e0881).
>
Ahhh! That is why we have been stuck with #ifdef all these years!

What you point out is quite interesting. I guess that we did not
carefully understood the context in which this was printed. That is,
we will only ends up printing something if the symbol is visible, or
has been selected, or has a default. That said
__enabled_CONFIG_THUMB2_KERNEL will get generated whenever it appears
in the menuconfig (ie. it's dependency are met).

The solution is trivial, but I am not sure we want to go that way: we
need to generated a __enabled_ entry for symbols for _all_ symbols in
the configuration, even internal one, as I am sure someone will at
some point do:

if (IS_ENABLED(CONFIG_WIRELESS_EXT)) {
    ....
}

but this will continue to be broken until we have a global symbol
namespace for all architecture, ie:

if (IS_ENABLED(CONFIG_ARM)) {
    ....
}

will not be expected to work for an ARCH=mips build.

 - Arnaud

> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 70bca64..59aa480 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -1053,6 +1053,9 @@ static int c_show(struct seq_file *m, void *v)
>        seq_printf(m, "Serial\t\t: %08x%08x\n",
>                   system_serial_high, system_serial_low);
>
> +       if (IS_ENABLED(CONFIG_THUMB2_KERNEL))
> +               printk("Thumb-2\n");
> +
>        return 0;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
