Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab0F3Uzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 16:55:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753416Ab0F3Uzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:55:45 -0400
Date: Wed, 30 Jun 2010 13:55:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
       linux-mmc@vger.kernel.org
Subject: Re: [PATCH v3] MMC: Add JZ4740 mmc driver
Message-Id: <20100630135525.1f6a9704.akpm@linux-foundation.org>
In-Reply-To: <1277688041-23522-1-git-send-email-lars@metafoo.de>
References: <1276924111-11158-19-git-send-email-lars@metafoo.de>
	<1277688041-23522-1-git-send-email-lars@metafoo.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010 03:20:41 +0200
Lars-Peter Clausen <lars@metafoo.de> wrote:

> This patch adds support for the mmc controller on JZ4740 SoCs.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matt Fleming <matt@console-pimps.org>
> Cc: linux-mmc@vger.kernel.org
>
> ...
>
> +#define JZ4740_MMC_MAX_TIMEOUT 10000000

That was a really big timeout.  How long do 1e7 readw's take?  Oh well.

>
> ...
>
> +static void jz4740_mmc_clock_disable(struct jz4740_mmc_host *host)
> +{
> +	uint32_t status;
> +
> +	writew(JZ_MMC_STRPCL_CLOCK_STOP, host->base + JZ_REG_MMC_STRPCL);
> +	do {
> +		status = readl(host->base + JZ_REG_MMC_STATUS);
> +	} while (status & JZ_MMC_STATUS_CLK_EN);
> +}
> +
> +static void jz4740_mmc_reset(struct jz4740_mmc_host *host)
> +{
> +	uint32_t status;
> +
> +	writew(JZ_MMC_STRPCL_RESET, host->base + JZ_REG_MMC_STRPCL);
> +	udelay(10);
> +	do {
> +		status = readl(host->base + JZ_REG_MMC_STATUS);
> +	} while (status & JZ_MMC_STATUS_IS_RESETTING);
> +}

Maybe these should have a timeout too?

>
> ...
>
> +static inline unsigned int jz4740_mmc_wait_irq(struct jz4740_mmc_host *host,
> +	unsigned int irq)
> +{
> +	unsigned int timeout = JZ4740_MMC_MAX_TIMEOUT;
> +	uint16_t status;
> +
> +	do {
> +		status = readw(host->base + JZ_REG_MMC_IREG);
> +	} while (!(status & irq) && --timeout);
> +
> +	return timeout;
> +}

This guy's too big to inline.  Recent gcc's know that and they tend to
uninline such things behind your back anwyay.

>
> ...
>
> +struct jz4740_mmc_platform_data {
> +	int gpio_power;
> +	int gpio_card_detect;
> +	int gpio_read_only;
> +	unsigned card_detect_active_low:1;
> +	unsigned read_only_active_low:1;
> +	unsigned power_active_low:1;
> +
> +	unsigned data_1bit:1;
> +};

The bitfields will all share the same word, so modification of one
field can race against modification of another field.  Hence some form
of locking which covers *all* the bitfields is needed.

Is that a problem in this driver?

