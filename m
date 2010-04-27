Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab0D0WCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 18:02:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757162Ab0D0WCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 18:02:44 -0400
Date: Tue, 27 Apr 2010 15:02:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yusuke Goda <yusuke.goda.sx@renesas.com>
Cc: ben@decadent.org.uk, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/2] MMC: Add support MMCIF for SuperH
Message-Id: <20100427150227.24a1ba25.akpm@linux-foundation.org>
In-Reply-To: <4BD6B926.3020704@renesas.com>
References: <4BD6B926.3020704@renesas.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 19:15:02 +0900
Yusuke Goda <yusuke.goda.sx@renesas.com> wrote:

> 
>  MMCIF is MMC Host Interface in SuperH.
>
> ...
>
> +static void sh_mmcif_clock_control(struct sh_mmcif_host *host, unsigned int clk)
> +{
> +	int i;
> +	struct sh_mmcif_plat_data *p = host->pd->dev.platform_data;
> +
> +	sh_mmcif_bitclr(host, MMCIF_CE_CLK_CTRL, CLK_ENABLE);
> +	sh_mmcif_bitclr(host, MMCIF_CE_CLK_CTRL, CLK_CLEAR);
> +
> +	if (!clk)
> +		return;
> +	if (p->sup_pclk && clk == host->clk) {
> +			sh_mmcif_bitset(host, MMCIF_CE_CLK_CTRL, CLK_SUP_PCLK);
> +	} else {
> +		for (i = 1; (unsigned int)host->clk / (1 << i) >= clk; i++)
> +			;

I suspect this could be clarified.  Perhaps

	i = ilog2(__roundup_pow_of_two(host->clk));

If that's wrong then include/linux/log2.h has various tools which can
surely be used.  If they're not appropriate then please feel free to
propose additions.

> +		sh_mmcif_bitset(host, MMCIF_CE_CLK_CTRL, (i - 1) << 16);
> +	}
> +	sh_mmcif_bitset(host, MMCIF_CE_CLK_CTRL, CLK_ENABLE);
> +}
> +
>
> ...
>
> +static int sh_mmcif_error_manage(struct sh_mmcif_host *host)
> +{
> +	u32 state1, state2;
> +	int ret, timeout = 10000000;
> +
> +	host->sd_error = 0;
> +	host->wait_int = 0;
> +
> +	state1 = sh_mmcif_readl(host, MMCIF_CE_HOST_STS1);
> +	state2 = sh_mmcif_readl(host, MMCIF_CE_HOST_STS2);
> +	pr_debug("%s: ERR HOST_STS1 = %08x\n", \
> +			DRIVER_NAME, sh_mmcif_readl(host, MMCIF_CE_HOST_STS1));
> +	pr_debug("%s: ERR HOST_STS2 = %08x\n", \
> +			DRIVER_NAME, sh_mmcif_readl(host, MMCIF_CE_HOST_STS2));
> +
> +	if (state1 & STS1_CMDSEQ) {
> +		pr_debug("%s: Forced end of command sequence\n", DRIVER_NAME);
> +		sh_mmcif_bitset(host, MMCIF_CE_CMD_CTRL, CMD_CTRL_BREAK);
> +		sh_mmcif_bitset(host, MMCIF_CE_CMD_CTRL, ~CMD_CTRL_BREAK);
> +		while (1) {
> +			timeout--;
> +			if (timeout < 0) {
> +				pr_err(DRIVER_NAME": Forceed end of " \
> +					"command sequence timeout err\n");
> +				return -EILSEQ;
> +			}
> +			if (!(sh_mmcif_readl(host, MMCIF_CE_HOST_STS1)
> +								& STS1_CMDSEQ))
> +				break;
> +			mdelay(1);
> +		}
> +		sh_mmcif_sync_reset(host);
> +		return -EILSEQ;

Good heavens, what is EILSEQ?

<googles a bit>

    "An illegal multibyte sequence was found in the input.  This
     usually means that you have the wrong charactor encoding, for
     instance the MicrosoftCorporation version of latin-1 (aka
     iso_8859_1(7)) (which has it's own stuff like "smart quotes" in
     the reserved bytes) instead of the real latin (or perhaps
     utf8(7))."

Why on earth are driver writers using this in the kernel???  Imagine
the confusion which ensues when this error code propagates all the way
back to some poor user's console.  They'll be scrabbling around with
language encodings not even suspecting that their hardware is busted.

People do this *a lot*.  They go grubbing through errno.h and grab
something which looks vaguely appropriate.  But it's wrong.

If your hardware is busted then return -EIO and emit a printk to tell
the operator what broke.

> +	}
> +
> +	if (state2 & STS2_CRC_ERR)
> +		ret = -EILSEQ;
> +	else if (state2 & STS2_TIMEOUT_ERR)
> +		ret = -ETIMEDOUT;
> +	else
> +		ret = -EILSEQ;
> +	return ret;
> +}
>
> ...
>
