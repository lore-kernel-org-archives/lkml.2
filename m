Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab2FGMGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 08:06:07 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:32966
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411Ab2FGMGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 08:06:05 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944hd25hf0ah)
Date: Thu, 7 Jun 2012 20:05:33 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Devendra Naga <devendra.aaru@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] pinctrl: free allocated pinctrl_map structure only
 once and use kernel facilities for IMX_PMX_DUMP
Message-ID: <20120607120532.GD8354@shlinux2.ap.freescale.net>
References: <1338656634-3870-1-git-send-email-devendra.aaru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1338656634-3870-1-git-send-email-devendra.aaru@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2012 at 10:33:53PM +0530, Devendra Naga wrote:
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
> ---
>  drivers/pinctrl/pinctrl-imx.c |   23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
>
Sorry for late reply.
I missed this patch series.
You can CC me next time. :)

> diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
> index f6e7c67..553ed95 100644
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
I can't remember clearly but i encountered a strange issue before
that the format was not what i want with KERN_DEBUG...
But i just tried your patch and it did not appear.
So i'm ok with this change.

>  }
>  
>  /* The bits in CONFIG cell defined in binding doc*/
> @@ -203,8 +203,7 @@ static void imx_dt_free_map(struct pinctrl_dev *pctldev,
>  {
>  	int i;
Also need removed?

>  
> -	for (i = 0; i < num_maps; i++)
> -		kfree(map);
> +	kfree(map);

BTW, it would be better if the change the patch title to:
"pinctrl: pinctrl-imx: ...."

Otherwise,
Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng

