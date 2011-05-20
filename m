Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab1EUD1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 23:27:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54012 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab1EUD1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 23:27:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VqXbX2Hr+TtTR68U/Y6oapy55AjQe7ptF7tiA48xlxPTa8quwHUL4RlyIUmA8+Gi/a
         EovRCe5XsRQkF9Jy60nDz5l4Gl6XWQtK3tQdmUYOn0WrOgyeVe2jO3pmGSPtl2hcSJjG
         Q2WlVmx0Y9yROT36iRUBs0ZVIdFpdf3Rye3ng=
Message-ID: <4DD6E90C.9030109@gmail.com>
Date: Fri, 20 May 2011 17:19:56 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jeremy Kerr <jeremy.kerr@canonical.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/4] clk: Add simple gated clock
References: <1305876469.327589.409938867568.4.gpush@pororo>
In-Reply-To: <1305876469.327589.409938867568.4.gpush@pororo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2011 02:27 AM, Jeremy Kerr wrote:
> Signed-off-by: Jeremy Kerr<jeremy.kerr@canonical.com>
>
> ---
>   drivers/clk/Kconfig    |    4 ++++
>   drivers/clk/Makefile   |    1 +
>   drivers/clk/clk-gate.c |   41 +++++++++++++++++++++++++++++++++++++++++
>   include/linux/clk.h    |   13 +++++++++++++
>   4 files changed, 59 insertions(+)
>
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 0a27963..75d2902 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -9,3 +9,7 @@ config GENERIC_CLK
>   config GENERIC_CLK_FIXED
>   	bool
>   	depends on GENERIC_CLK
> +
> +config GENERIC_CLK_GATE
> +	bool
> +	depends on GENERIC_CLK
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 9a3325a..d186446 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -2,3 +2,4 @@
>   obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
>   obj-$(CONFIG_GENERIC_CLK)	+= clk.o
>   obj-$(CONFIG_GENERIC_CLK_FIXED)	+= clk-fixed.o
> +obj-$(CONFIG_GENERIC_CLK_GATE)	+= clk-gate.o
> diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
> new file mode 100644
> index 0000000..833e0da
> --- /dev/null
> +++ b/drivers/clk/clk-gate.c
> @@ -0,0 +1,41 @@
> +
> +#include<linux/clk.h>
> +#include<linux/module.h>
> +#include<asm/io.h>
> +
> +#define to_clk_gate(clk) container_of(clk, struct clk_gate, hw)
> +
> +static unsigned long clk_gate_get_rate(struct clk_hw *clk)
> +{
> +	return clk_get_rate(clk_get_parent(clk->clk));
> +}
> +
> +static int clk_gate_enable(struct clk_hw *clk)
> +{
> +	struct clk_gate *gate = to_clk_gate(clk);
> +	u32 reg;
> +
> +	reg = __raw_readl(gate->reg);
> +	reg |= 1<<  gate->bit_idx;
> +	__raw_writel(reg, gate->reg);

This should be protected with a spinlock for h/w access. You could have 
a mixture of enable bits with divider fields in one register, so the 
enable lock won't help here. However, you would have to find a way to 
have a common spinlock for all accesses to the h/w.

Rob
