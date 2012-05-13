Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab2EMRsf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 13:48:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45669 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2EMRsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 13:48:33 -0400
Message-ID: <4FAFF3EB.4090904@linaro.org>
Date: Mon, 14 May 2012 01:48:27 +0800
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Richard Zhao <richard.zhao@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        shawn.guo@linaro.org, Richard Zhao <richard.zhao@freescale.com>
Subject: Re: [PATCH V2] mfd: anatop: make register accessor more flexible
 and rename meaningfully
References: <1336870794-6351-1-git-send-email-richard.zhao@freescale.com> <1336871882-6796-1-git-send-email-richard.zhao@freescale.com>
In-Reply-To: <1336871882-6796-1-git-send-email-richard.zhao@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012年05月13日 09:18), Richard Zhao wrote:
>  - rename to anatop_read_reg and anatop_write_reg
>  - anatop_read_reg directly return reg value
>  - anatop_write_reg write reg with mask
> 
> Signed-off-by: Richard Zhao <richard.zhao@freescale.com>
> ---
> Changes since V1:
> correct bit operation in anatop_write_reg
> 
>  drivers/mfd/anatop-mfd.c             |   35 +++++++++++-----------------------
>  drivers/regulator/anatop-regulator.c |   18 ++++++++---------
>  include/linux/mfd/anatop.h           |    4 ++--
>  3 files changed, 21 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/mfd/anatop-mfd.c b/drivers/mfd/anatop-mfd.c
> index 2af4248..6da0634 100644
> --- a/drivers/mfd/anatop-mfd.c
> +++ b/drivers/mfd/anatop-mfd.c
> @@ -41,39 +41,26 @@
>  #include <linux/of_address.h>
>  #include <linux/mfd/anatop.h>
>  
> -u32 anatop_get_bits(struct anatop *adata, u32 addr, int bit_shift,
> -		    int bit_width)
> +u32 anatop_read_reg(struct anatop *adata, u32 addr)
>  {
> -	u32 val, mask;
> -
> -	if (bit_width == 32)
> -		mask = ~0;
> -	else
> -		mask = (1 << bit_width) - 1;
> -
> -	val = readl(adata->ioreg + addr);
> -	val = (val >> bit_shift) & mask;
> -
> -	return val;
> +	return readl(adata->ioreg + addr);
>  }
> -EXPORT_SYMBOL_GPL(anatop_get_bits);
> +EXPORT_SYMBOL_GPL(anatop_read_reg);
>  
> -void anatop_set_bits(struct anatop *adata, u32 addr, int bit_shift,
> -		     int bit_width, u32 data)
> +void anatop_write_reg(struct anatop *adata, u32 addr, u32 data, u32 mask)
>  {
> -	u32 val, mask;
> +	u32 val;
>  
> -	if (bit_width == 32)
> -		mask = ~0;
> -	else
> -		mask = (1 << bit_width) - 1;
> +	data &= mask;
>  
>  	spin_lock(&adata->reglock);
> -	val = readl(adata->ioreg + addr) & ~(mask << bit_shift);
> -	writel((data << bit_shift) | val, adata->ioreg + addr);
> +	val = readl(adata->ioreg + addr);
> +	val &= ~mask;
> +	val |= data;
> +	writel(val, adata->ioreg + addr);
>  	spin_unlock(&adata->reglock);
>  }
> -EXPORT_SYMBOL_GPL(anatop_set_bits);
> +EXPORT_SYMBOL_GPL(anatop_write_reg);
>  
>  static const struct of_device_id of_anatop_match[] = {
>  	{ .compatible = "fsl,imx6q-anatop", },
> diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
> index 81fd606..0a34085 100644
> --- a/drivers/regulator/anatop-regulator.c
> +++ b/drivers/regulator/anatop-regulator.c
> @@ -47,7 +47,7 @@ static int anatop_set_voltage(struct regulator_dev *reg, int min_uV,
>  				  int max_uV, unsigned *selector)
>  {
>  	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
> -	u32 val, sel;
> +	u32 val, sel, mask;
>  	int uv;
>  
>  	uv = min_uV;
> @@ -71,11 +71,10 @@ static int anatop_set_voltage(struct regulator_dev *reg, int min_uV,
>  	val = anatop_reg->min_bit_val + sel;
>  	*selector = sel;
>  	dev_dbg(&reg->dev, "%s: calculated val %d\n", __func__, val);
> -	anatop_set_bits(anatop_reg->mfd,
> -			anatop_reg->control_reg,
> -			anatop_reg->vol_bit_shift,
> -			anatop_reg->vol_bit_width,
> -			val);
> +	mask = ((1 << anatop_reg->vol_bit_width) - 1) <<
> +		anatop_reg->vol_bit_shift;
> +	val <<= anatop_reg->vol_bit_shift;
> +	anatop_write_reg(anatop_reg->mfd, anatop_reg->control_reg, val, mask);
>  
>  	return 0;
>  }
> @@ -88,10 +87,9 @@ static int anatop_get_voltage_sel(struct regulator_dev *reg)
>  	if (!anatop_reg->control_reg)
>  		return -ENOTSUPP;
>  
> -	val = anatop_get_bits(anatop_reg->mfd,
> -			      anatop_reg->control_reg,
> -			      anatop_reg->vol_bit_shift,
> -			      anatop_reg->vol_bit_width);
> +	val = anatop_read_reg(anatop_reg->mfd, anatop_reg->control_reg);
> +	val = (val & ((1 << anatop_reg->vol_bit_width) - 1)) >>
> +		anatop_reg->vol_bit_shift;
>  
>  	return val - anatop_reg->min_bit_val;
>  }
> diff --git a/include/linux/mfd/anatop.h b/include/linux/mfd/anatop.h
> index 22c1007..7f92acf 100644
> --- a/include/linux/mfd/anatop.h
> +++ b/include/linux/mfd/anatop.h
> @@ -34,7 +34,7 @@ struct anatop {
>  	spinlock_t reglock;
>  };
>  
> -extern u32 anatop_get_bits(struct anatop *, u32, int, int);
> -extern void anatop_set_bits(struct anatop *, u32, int, int, u32);
> +extern u32 anatop_read_reg(struct anatop *, u32);
> +extern void anatop_write_reg(struct anatop *, u32, u32, u32);
>  
>  #endif /*  __LINUX_MFD_ANATOP_H */

Reviewed-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>

Thanks...
