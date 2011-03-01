Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab1CASh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 13:37:29 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59258 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1CASh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 13:37:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=JrCzPuXGJTX4ECRd+XFYwI1Qn7znVmuQjKHwcKPYSg+DUXv9jtXfhgApWrqnEglwmD
         /PGRBO4oHqaKbzZD/wGtQ6vu5c/4snB0oXaSpU7z11ca8q66gGOBPpMYFCFWI52xGYWO
         lfcdN/psSanX7Q1cEM/74SdJl0uKTHsszLve0=
Date: Tue, 1 Mar 2011 20:37:22 +0200
From: Jarkko Nikula <jhnikula@gmail.com>
To: Abhilash K V <abhilash.kv@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH] audio:am3517evm support for AIC23
Message-Id: <20110301203722.3ba044e5.jhnikula@gmail.com>
In-Reply-To: <1298994218-30610-1-git-send-email-abhilash.kv@ti.com>
References: <1298994218-30610-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue,  1 Mar 2011 21:13:38 +0530
Abhilash K V <abhilash.kv@ti.com> wrote:

> This patch aims to fix the registration of the AIC23-based audio
> module on the AM3517-EVM, with the following two changes:
> 
> 1. The i2c_board_info entry supporting aic23 codec was added into
>    the i2c2 bus.
> 2. The i2c client device name (".2-001a" in this case, including
>    the separator period) was appended to the codec_name member of
>    am3517evm_dai to resolve the names mismatch happening in
>    soc_bind_dai_link().
> 
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
> ---
>  arch/arm/mach-omap2/board-am3517evm.c |    3 +++
>  sound/soc/omap/am3517evm.c            |    2 +-
>  2 files changed, 4 insertions(+), 1 deletions(-)
> 
First, your patch does the correct things.

I investigated a bit and it looks like the sound/soc/omap/am3517evm.c
never worked in mainline since the patch below adding codec to
board-am3517evm.c wasn't applied by reason or another.

http://www.mail-archive.com/linux-omap@vger.kernel.org/msg18470.html

This means that you should split this patch into two and they can be
sent as independent patches. am3517evm.c change via alsa-devel
and board-am3517evm.c via linux-omap & linux-arm-kernel. Some comments
below.

> diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-omap2/board-am3517evm.c
> index ad71cbf..8da8d20 100644
> --- a/arch/arm/mach-omap2/board-am3517evm.c
> +++ b/arch/arm/mach-omap2/board-am3517evm.c
> @@ -358,6 +358,9 @@ static struct pca953x_platform_data am3517evm_gpio_expander_info_0 = {
>  };
>  static struct i2c_board_info __initdata am3517evm_i2c2_boardinfo[] = {
>  	{
> +		I2C_BOARD_INFO("tlv320aic23", 0x1A),
> +	},
> +	{

This is ok and don't need anything else as the rest pieces from
original missing patch are added by another patches.

> --- a/sound/soc/omap/am3517evm.c
> +++ b/sound/soc/omap/am3517evm.c
> @@ -139,7 +139,7 @@ static struct snd_soc_dai_link am3517evm_dai = {
>  	.cpu_dai_name ="omap-mcbsp-dai.0",
>  	.codec_dai_name = "tlv320aic23-hifi",
>  	.platform_name = "omap-pcm-audio",
> -	.codec_name = "tlv320aic23-codec",
> +	.codec_name = "tlv320aic23-codec.2-001a",
>  	.init = am3517evm_aic23_init,
>  	.ops = &am3517evm_ops,
>  };

Subject for this part could be something like
"ASoC: AM3517: Update codec name after multi-component update".

Remember to cc ASoC maintainers Mark Brown and Liam Girdwood.

You could add my acks to splitted patches.

Acked-by: Jarkko Nikula <jhnikula@gmail.com>
