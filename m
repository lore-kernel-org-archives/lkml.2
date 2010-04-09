Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab0DIDHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 23:07:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:47471 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751974Ab0DIDHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 23:07:39 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19u7Hwq7OBu3ME1eWFeAmgJlWhI6XG6CqNt4Ibzjn
	2izOxdP/q4yVoa
Message-ID: <4BBE99F6.9060300@gmx.de>
Date: Fri, 09 Apr 2010 05:07:34 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 04/16] viafb: Retain GEMODE reserved bits
References: <1270746946-12467-1-git-send-email-corbet@lwn.net> <1270746946-12467-5-git-send-email-corbet@lwn.net>
In-Reply-To: <1270746946-12467-5-git-send-email-corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

Jonathan Corbet schrieb:
> Commit c3e25673843153ea75fda79a47cf12f10a25ca37 (viafb: 2D engine rewrite)
> changed the setting of the GEMODE register so that the reserved bits are no
> longer preserved.  Fix that; at the same time, move this code to its own
> function and restore the use of symbolic constants.

in your later patch "[PATCH 06/16] viafb: complete support for 
VX800/VX855 accelerated framebuffer" you reintroduce initializing those 
bits to 0. That's fine but I can't see a reason for preserving this bits 
here as it adds useless overhead unless the hardware itself changed some 
of those bits and behaves differently according to those bits. 
Additionally the first 2 bits are not reserved but provide a rotation 
where 00 is what we want (no rotation).
And if you rip code off hw_bitblt_2 it would be better to do the same 
with hw_bitblt_1. A quick look reveals that the same function can be 
used there (the error message would need to be adjusted but that's minor).
So nack@preserving (unless it would cause problems otherwise) but 
ack@ripping code off and sharing between hw_bitblt_1 & hw_bitblt_2.


Thanks,

Florian Tobias Schandinat

> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  drivers/video/via/accel.c |   48 ++++++++++++++++++++++++++++++---------------
>  1 files changed, 32 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/video/via/accel.c b/drivers/video/via/accel.c
> index d5077df..78c0a2b 100644
> --- a/drivers/video/via/accel.c
> +++ b/drivers/video/via/accel.c
> @@ -165,12 +165,41 @@ static int hw_bitblt_1(void __iomem *engine, u8 op, u32 width, u32 height,
>  	return 0;
>  }
>  
> +/*
> + * Figure out an appropriate bytes-per-pixel setting.
> + */
> +static int viafb_set_bpp(void __iomem *engine, u8 bpp)
> +{
> +	u32 gemode;
> +
> +	/* Preserve the reserved bits */
> +	gemode = readl(engine + VIA_REG_GEMODE) & 0xfffffcff;
> +	switch (bpp) {
> +	case 8:
> +		gemode |= VIA_GEM_8bpp;
> +		break;
> +	case 16:
> +		gemode |= VIA_GEM_16bpp;
> +		break;
> +	case 32:
> +		gemode |= VIA_GEM_32bpp;
> +		break;
> +	default:
> +		printk(KERN_WARNING "hw_bitblt_2: Unsupported bpp %d\n", bpp);
> +		return -EINVAL;
> +	}
> +	writel(gemode, engine + VIA_REG_GEMODE);
> +	return 0;
> +}
> +
> +
>  static int hw_bitblt_2(void __iomem *engine, u8 op, u32 width, u32 height,
>  	u8 dst_bpp, u32 dst_addr, u32 dst_pitch, u32 dst_x, u32 dst_y,
>  	u32 *src_mem, u32 src_addr, u32 src_pitch, u32 src_x, u32 src_y,
>  	u32 fg_color, u32 bg_color, u8 fill_rop)
>  {
>  	u32 ge_cmd = 0, tmp, i;
> +	int ret;
>  
>  	if (!op || op > 3) {
>  		printk(KERN_WARNING "hw_bitblt_2: Invalid operation: %d\n", op);
> @@ -204,22 +233,9 @@ static int hw_bitblt_2(void __iomem *engine, u8 op, u32 width, u32 height,
>  		}
>  	}
>  
> -	switch (dst_bpp) {
> -	case 8:
> -		tmp = 0x00000000;
> -		break;
> -	case 16:
> -		tmp = 0x00000100;
> -		break;
> -	case 32:
> -		tmp = 0x00000300;
> -		break;
> -	default:
> -		printk(KERN_WARNING "hw_bitblt_2: Unsupported bpp %d\n",
> -			dst_bpp);
> -		return -EINVAL;
> -	}
> -	writel(tmp, engine + 0x04);
> +	ret = viafb_set_bpp(engine, dst_bpp);
> +	if (ret)
> +		return ret;
>  
>  	if (op == VIA_BITBLT_FILL)
>  		tmp = 0;

