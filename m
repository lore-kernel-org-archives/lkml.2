Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab0DIEV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 00:21:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:48912 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751127Ab0DIEVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 00:21:24 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/RaZ92ibXR2fc4VFmlVguBiFuArEPO9tqmIAT536
	BtF8jbGa8z7+II
Message-ID: <4BBEAB3E.5090709@gmx.de>
Date: Fri, 09 Apr 2010 06:21:18 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 06/16] viafb: complete support for VX800/VX855 accelerated
 framebuffer
References: <1270746946-12467-1-git-send-email-corbet@lwn.net> <1270746946-12467-7-git-send-email-corbet@lwn.net>
In-Reply-To: <1270746946-12467-7-git-send-email-corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.40000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet schrieb:
> This patch is a painful merge of change
> a90bab567ece3e915d0ccd55ab00c9bb333fa8c0 (viafb: Add support for 2D
> accelerated framebuffer on VX800/VX855) in the OLPC tree, originally by
> Harald Welte.  Harald's changelog read:
> 
> 	The VX800/VX820 and the VX855/VX875 chipsets have a different 2D
>     	acceleration engine called "M1".  The M1 engine has some subtle
>     	(and some not-so-subtle) differences to the previous engines, so
>     	support for accelerated framebuffer on those chipsets was disabled
>     	so far.
> 
> This merge tries to preserve Harald's changes in the framework of the
> much-changed 2.6.34 viafb code.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

The patch itself looks good. However I have a few minor issues below 
which could be addressed by follow-ups (or ignored for the moment).

> ---
>  drivers/video/via/accel.c |   39 +++++++++++++++++++++++++++++++++------
>  drivers/video/via/accel.h |   40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 73 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/video/via/accel.c b/drivers/video/via/accel.c
> index 78c0a2b..7fe1c1d 100644
> --- a/drivers/video/via/accel.c
> +++ b/drivers/video/via/accel.c
> @@ -328,6 +328,7 @@ int viafb_init_engine(struct fb_info *info)
>  {
>  	struct viafb_par *viapar = info->par;
>  	void __iomem *engine;
> +	int highest_reg, i;
>  	u32 vq_start_addr, vq_end_addr, vq_start_low, vq_end_low, vq_high,
>  		vq_len, chip_name = viapar->shared->chip_info.gfx_chip_name;
>  
> @@ -339,6 +340,18 @@ int viafb_init_engine(struct fb_info *info)
>  		return -ENOMEM;
>  	}
>  
> +	/* Initialize registers to reset the 2D engine */
> +	switch (viapar->shared->chip_info.twod_engine) {
> +	case VIA_2D_ENG_M1:
> +		highest_reg = 0x5c;
> +		break;
> +	default:
> +		highest_reg = 0x40;
> +		break;
> +	}
> +	for (i = 0; i <= highest_reg; i+= 4)
> +		writel(0x0, engine + i);
> +

this obsoletes
	/* Init 2D engine reg to reset 2D engine */
	writel(0x0, engine + VIA_REG_KEYCONTROL);
as VIA_REG_KEYCONTROL is 0x02C.

>  	switch (chip_name) {
>  	case UNICHROME_CLE266:
>  	case UNICHROME_K400:
> @@ -375,6 +388,8 @@ int viafb_init_engine(struct fb_info *info)
>  	switch (chip_name) {
>  	case UNICHROME_K8M890:
>  	case UNICHROME_P4M900:
> +	case UNICHROME_VX800:
> +	case UNICHROME_VX855:
>  		writel(0x00100000, engine + VIA_REG_CR_TRANSET);
>  		writel(0x680A0000, engine + VIA_REG_CR_TRANSPACE);
>  		writel(0x02000000, engine + VIA_REG_CR_TRANSPACE);
> @@ -409,6 +424,8 @@ int viafb_init_engine(struct fb_info *info)
>  	switch (chip_name) {
>  	case UNICHROME_K8M890:
>  	case UNICHROME_P4M900:
> +	case UNICHROME_VX800:
> +	case UNICHROME_VX855:
>  		vq_start_low |= 0x20000000;
>  		vq_end_low |= 0x20000000;
>  		vq_high |= 0x20000000;
> @@ -486,15 +503,25 @@ void viafb_wait_engine_idle(struct fb_info *info)
>  {
>  	struct viafb_par *viapar = info->par;
>  	int loop = 0;
> +	u32 mask;
>  
> -	while (!(readl(viapar->shared->engine_mmio + VIA_REG_STATUS) &
> -			VIA_VR_QUEUE_BUSY) && (loop < MAXLOOP)) {
> -		loop++;
> -		cpu_relax();
> +	switch (viapar->shared->chip_info.twod_engine) {
> +	case VIA_2D_ENG_H5:
> +	case VIA_2D_ENG_M1:
> +		mask = VIA_CMD_RGTR_BUSY_M1 | VIA_2D_ENG_BUSY_M1 |
> +			      VIA_3D_ENG_BUSY_M1;
> +		break;
> +	default:

As in the previous patch I'd appreciate a default of
	printk(KERN_ALERT "viafb_xy: FIXME");
I have to admit to be consistent a few switches that are already there 
would need to be changed but that's another issue.

> +		while (!(readl(viapar->shared->engine_mmio + VIA_REG_STATUS) &
> +				VIA_VR_QUEUE_BUSY) && (loop < MAXLOOP)) {
> +			loop++;
> +			cpu_relax();
> +		}
> +		mask = VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY | VIA_3D_ENG_BUSY;
> +		break;
>  	}
>  
> -	while ((readl(viapar->shared->engine_mmio + VIA_REG_STATUS) &
> -		    (VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY | VIA_3D_ENG_BUSY)) &&
> +	while ((readl(viapar->shared->engine_mmio + VIA_REG_STATUS) & mask) &&
>  		    (loop < MAXLOOP)) {
>  		loop++;
>  		cpu_relax();
> diff --git a/drivers/video/via/accel.h b/drivers/video/via/accel.h
> index 615c84a..2c122d2 100644
> --- a/drivers/video/via/accel.h
> +++ b/drivers/video/via/accel.h
> @@ -67,6 +67,34 @@
>  /* from 0x100 to 0x1ff */
>  #define VIA_REG_COLORPAT        0x100
>  
> +/* defines for VIA 2D registers for vt3353/3409 (M1 engine)*/
> +#define VIA_REG_GECMD_M1        0x000
> +#define VIA_REG_GEMODE_M1       0x004
> +#define VIA_REG_GESTATUS_M1     0x004       /* as same as VIA_REG_GEMODE */
> +#define VIA_REG_PITCH_M1        0x008       /* pitch of src and dst */
> +#define VIA_REG_DIMENSION_M1    0x00C       /* width and height */
> +#define VIA_REG_DSTPOS_M1       0x010
> +#define VIA_REG_LINE_XY_M1      0x010
> +#define VIA_REG_DSTBASE_M1      0x014
> +#define VIA_REG_SRCPOS_M1       0x018
> +#define VIA_REG_LINE_K1K2_M1    0x018
> +#define VIA_REG_SRCBASE_M1      0x01C
> +#define VIA_REG_PATADDR_M1      0x020
> +#define VIA_REG_MONOPAT0_M1     0x024
> +#define VIA_REG_MONOPAT1_M1     0x028
> +#define VIA_REG_OFFSET_M1       0x02C
> +#define VIA_REG_LINE_ERROR_M1   0x02C
> +#define VIA_REG_CLIPTL_M1       0x040       /* top and left of clipping */
> +#define VIA_REG_CLIPBR_M1       0x044       /* bottom and right of clipping */
> +#define VIA_REG_KEYCONTROL_M1   0x048       /* color key control */
> +#define VIA_REG_FGCOLOR_M1      0x04C
> +#define VIA_REG_DSTCOLORKEY_M1  0x04C       /* as same as VIA_REG_FG */
> +#define VIA_REG_BGCOLOR_M1      0x050
> +#define VIA_REG_SRCCOLORKEY_M1  0x050       /* as same as VIA_REG_BG */
> +#define VIA_REG_MONOPATFGC_M1   0x058       /* Add BG color of Pattern. */
> +#define VIA_REG_MONOPATBGC_M1   0x05C       /* Add FG color of Pattern. */
> +#define VIA_REG_COLORPAT_M1     0x100       /* from 0x100 to 0x1ff */
> +

All of these defines are unused. I admit that it is my fault. I've not 
yet found a way I like to use them as the meaning of the same hardware 
address changed. I think the most clean long term solution would be to 
put the engines in separate files and the definitions in private headers 
to at least avoid the need to decode the engine version in the name.
However as the old headers already contain a bunch of trash feel free to 
ignore this issue and add it for now.

>  /* VIA_REG_PITCH(0x38): Pitch Setting */
>  #define VIA_PITCH_ENABLE        0x80000000
>  
> @@ -157,6 +185,18 @@
>  /* Virtual Queue is busy */
>  #define VIA_VR_QUEUE_BUSY       0x00020000
>  
> +/* VIA_REG_STATUS(0x400): Engine Status for H5 */
> +#define VIA_CMD_RGTR_BUSY_H5   0x00000010  /* Command Regulator is busy */
> +#define VIA_2D_ENG_BUSY_H5     0x00000002  /* 2D Engine is busy */
> +#define VIA_3D_ENG_BUSY_H5     0x00001FE1  /* 3D Engine is busy */
> +#define VIA_VR_QUEUE_BUSY_H5   0x00000004  /* Virtual Queue is busy */
> +
> +/* VIA_REG_STATUS(0x400): Engine Status for VT3353/3409 */
> +#define VIA_CMD_RGTR_BUSY_M1   0x00000010  /* Command Regulator is busy */
> +#define VIA_2D_ENG_BUSY_M1     0x00000002  /* 2D Engine is busy */
> +#define VIA_3D_ENG_BUSY_M1     0x00001FE1  /* 3D Engine is busy */
> +#define VIA_VR_QUEUE_BUSY_M1   0x00000004  /* Virtual Queue is busy */
> +
>  #define MAXLOOP                 0xFFFFFF
>  
>  #define VIA_BITBLT_COLOR	1

Thanks,

Florian Tobias Schandinat
