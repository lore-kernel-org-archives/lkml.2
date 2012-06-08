Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488Ab2FHC77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 22:59:59 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:6070 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652Ab2FHC76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 22:59:58 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202hzz8275bh8275dhz2dh2a8h668h839h944hd25hf0ah)
Date: Fri, 8 Jun 2012 10:59:17 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Devendra Naga <devendra.aaru@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] pinctrl: pinctrl-imx: free allocated
 pinctrl_map structure only once and use kernel facilities for IMX_PMX_DUMP
Message-ID: <20120608025916.GF8354@shlinux2.ap.freescale.net>
References: <1339087715-14683-1-git-send-email-devendra.aaru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1339087715-14683-1-git-send-email-devendra.aaru@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 10:18:35PM +0530, Devendra Naga wrote:
> a) as we allocate the pinctrl_map structure at imx_dt_node_to_map at  line 167, anyway
> if its an element, or a num_elements * (sizeof(type)) elements allocated to one single
> pointer must be freed only once.
> 
> CASE. A)
> 
> as new_map is not moved and allocated like,
> 
> for (i = 0; i < MAX_ELEMS; i++) {
> 	new_map[i] = kmalloc(numelems * size, GFP_KERNEL);
> }
> 
> its freed as
> 
> for (i = 0; i < MAX_ELEMS; i++) {
> 	kfree(new_map[i]);
> }
> 
> CASE. B)
> and its allocated like
> 	new_map = kmalloc(numelems * size, GFP_KERNEL);
> 
> it just needs kfree not as case A's.
> 
> b) use KERN_DEBUG facility for the IMX_PMX_DUMP macro.
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
>  drivers/pinctrl/pinctrl-imx.c |   25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
> index f6e7c67..7a59a59 100644
> --- a/drivers/pinctrl/pinctrl-imx.c
> +++ b/drivers/pinctrl/pinctrl-imx.c
> @@ -27,16 +27,16 @@
>  #include "core.h"
>  #include "pinctrl-imx.h"
>  
> -#define IMX_PMX_DUMP(info, p, m, c, n)		\
> -{						\
> -	int i, j;				\
> -	printk("Format: Pin Mux Config\n");	\
> -	for (i = 0; i < n; i++) {		\
> -		j = p[i];			\
> -		printk("%s %d 0x%lx\n",		\
> -			info->pins[j].name,	\
> -			m[i], c[i]);		\
> -	}					\
> +#define IMX_PMX_DUMP(info, p, m, c, n)			\
> +{							\
> +	int i, j;					\
> +	printk(KERN_DEBUG "Format: Pin Mux Config\n");	\
> +	for (i = 0; i < n; i++) {			\
> +		j = p[i];				\
> +		printk(KERN_DEBUG "%s %d 0x%lx\n",	\
> +			info->pins[j].name,		\
> +			m[i], c[i]);			\
> +	}						\
>  }
>  
Sorry i missed one more comment.
I think you may also need add below changes since the #ifdef DEBUG
is not needed anymore after using KERN_DEBUG.

diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
index d8fe1d8..4d073ef 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -475,9 +475,8 @@ static int __devinit imx_pinctrl_parse_groups(struct device_node *np,
                grp->configs[j] = config & ~IMX_PAD_SION;
        }

-#ifdef DEBUG
        IMX_PMX_DUMP(info, grp->pins, grp->mux_mode, grp->configs, grp->npins);
-#endif
+
        return 0;
 }

Regards
Dong Aisheng

