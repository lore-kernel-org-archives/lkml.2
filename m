Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1FNNMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 09:12:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33437 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1FNNMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 09:12:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jwEDVe0v7euBB3lepqJij3MNZX8FlZ9SuJRZO2rBNDs0F4z9X8uqzzalWepFoxhZ16
         OqNOzN88tPCC245RGIXS16WwZ0XIYISdsh4ItPxLCmtWRyuYvg51TbZ8sqCYy5oHsDgP
         pTb/qU+fw/5YCRCaGIBNcL2QMxVOJs7SCrnJk=
MIME-Version: 1.0
In-Reply-To: <201106112240.11621.rjw@sisk.pl>
References: <201106112223.04972.rjw@sisk.pl>
	<201106112240.11621.rjw@sisk.pl>
Date: Tue, 14 Jun 2011 22:12:40 +0900
Message-ID: <BANLkTi=-1Fpp9L17T7CwxoO9JfSes4FeKg@mail.gmail.com>
Subject: Re: [PATCH 8/8] ARM / shmobile: Support for I/O PM domains for SH7372 (v5)
From: Magnus Damm <magnus.damm@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Sun, Jun 12, 2011 at 5:40 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Use the generic power domains support introduced by the previous
> patch to implement support for power domains on SH7372.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---

Thanks for your work on this. I just tried this on my Mackerel board,
but I can't seem to get the pd_power_up() and pd_power_down()
callbacks to be executed. It is probably a misconfiguration from my
side.

Here's some feedback on the sh7372-specific code:

> --- linux-2.6.orig/arch/arm/mach-shmobile/Kconfig
> +++ linux-2.6/arch/arm/mach-shmobile/Kconfig
> @@ -19,6 +19,7 @@ config ARCH_SH7372
>        select CPU_V7
>        select SH_CLK_CPG
>        select ARCH_WANT_OPTIONAL_GPIOLIB
> +       select PM_GENERIC_DOMAINS

We want to support a single ARM binary for multiple boards, so this
should be enabled for all SoCs in mach-shmobile as a whole.

> --- linux-2.6.orig/arch/arm/mach-shmobile/pm-sh7372.c
> +++ linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
> @@ -15,16 +15,97 @@
>  #include <linux/list.h>
>  #include <linux/err.h>
>  #include <linux/slab.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/platform_device.h>
>  #include <asm/system.h>
>  #include <asm/io.h>
>  #include <asm/tlbflush.h>
>  #include <mach/common.h>
> +#include <mach/sh7372.h>
>
>  #define SMFRAM 0xe6a70000
>  #define SYSTBCR 0xe6150024
>  #define SBAR 0xe6180020
>  #define APARMBAREA 0xe6f10020
>
> +#define SPDCR 0xe6180008
> +#define SWUCR 0xe6180014
> +#define PSTR 0xe6180080
> +
> +struct sh7372_domain_data {
> +       unsigned int bit_shift;
> +};

Is it possible to make struct sh7372_domain_data include struct
generic_pm_domain? I suspect so since these two data types seem to be
linked together. I guess container_of() can be used for conversion
between the types?

> +
> +static int pd_power_down(struct dev_pm_domain *domain)
> +{
> +       struct sh7372_domain_data *dd = domain->platform_data;
> +       unsigned int mask = 1 << dd->bit_shift;
> +
> +       if (__raw_readl(PSTR) & mask) {
> +               __raw_writel(mask, SPDCR);
> +
> +               while (__raw_readl(SPDCR) & mask) {}

This probably wants a cpu_relax() in the polling loop. I realize that
my prototype hack lacked that...

> +               pr_debug("sh7372 power domain down 0x%08x -> PSTR = 0x%08x\n",
> +                        mask, __raw_readl(PSTR));
> +       }
> +
> +       return 0;
> +}
> +
> +static int pd_power_up(struct dev_pm_domain *domain)
> +{
> +       struct sh7372_domain_data *dd = domain->platform_data;
> +       unsigned int mask = 1 << dd->bit_shift;
> +
> +       if (!(__raw_readl(PSTR) & mask)) {
> +               __raw_writel(mask, SWUCR);
> +
> +               while (__raw_readl(SWUCR) & mask) {}

Same cpu_relax() here.

> +static int __init sh7372_power_domains_init(void)
> +{
> +       sh7372_init_domain(&sh7372_a4lc_domain, &sh7372_a4lc_domain_data);
> +       return 0;
> +}
> +core_initcall(sh7372_power_domains_init);

This initcall is going to be executed regardless which SoC we're
running on. We only want it called for sh7372 though.

If you look at other SoC-specific code then you will notice that
initcalls are only used for functions in mach-shmobile/ that are
common for all SoCs implemented under mach-shmobile.

You most likely want to initialize from sh7372_pm_init(), but for that
to work you probably have to reorder your code inside mackerel_init().

Thanks,

/ magnus
