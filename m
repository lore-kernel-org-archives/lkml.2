Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab2FHTY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 15:24:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57778 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab2FHTY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 15:24:27 -0400
MIME-Version: 1.0
In-Reply-To: <1339183331-4108-1-git-send-email-devendra.aaru@gmail.com>
References: <1339183331-4108-1-git-send-email-devendra.aaru@gmail.com>
Date: Sat, 9 Jun 2012 00:54:27 +0530
Message-ID: <CAHdPZaOKFfVfr+7Cn3VpmhcgsR9m6eoZn4NrhSoV4YONPt0Qag@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: pinctrl-imx: free allocated pinctrl_map
 structure only once and use kernel facilities for IMX_PMX_DUMP
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Dong Aisheng <aisheng.dong@freescale.com>,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dong, Linus,

i sent a second patch previously which applies actually on top this
patch , so not sending it.

You want me to send it again?

Thanks,
Devendra.

On Sat, Jun 9, 2012 at 12:52 AM, Devendra Naga <devendra.aaru@gmail.com> wrote:
> a) as we allocate the pinctrl_map structure at imx_dt_node_to_map at  line 167, anyway
>   if its an element, or a num_elements * (sizeof(type)) elements allocated to one single
>   pointer must be freed only once.
>
> CASE. A)
>
> as new_map is not moved and allocated like,
>
> for (i = 0; i < MAX_ELEMS; i++) {
>    new_map[i] = kmalloc(numelems * size, GFP_KERNEL);
> }
>
> its freed as
>
> for (i = 0; i < MAX_ELEMS; i++) {
>    kfree(new_map[i]);
> }
>
> CASE. B)
> and its allocated like
>        new_map = kmalloc(numelems * size, GFP_KERNEL);
>
> it just needs kfree not as case A's.
>
> b) use KERN_DEBUG facility for the IMX_PMX_DUMP macro.
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
>  drivers/pinctrl/pinctrl-imx.c |   28 ++++++++++++----------------
>  1 file changed, 12 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
> index f6e7c67..09f3a30 100644
> --- a/drivers/pinctrl/pinctrl-imx.c
> +++ b/drivers/pinctrl/pinctrl-imx.c
> @@ -27,16 +27,16 @@
>  #include "core.h"
>  #include "pinctrl-imx.h"
>
> -#define IMX_PMX_DUMP(info, p, m, c, n)         \
> -{                                              \
> -       int i, j;                               \
> -       printk("Format: Pin Mux Config\n");     \
> -       for (i = 0; i < n; i++) {               \
> -               j = p[i];                       \
> -               printk("%s %d 0x%lx\n",         \
> -                       info->pins[j].name,     \
> -                       m[i], c[i]);            \
> -       }                                       \
> +#define IMX_PMX_DUMP(info, p, m, c, n)                 \
> +{                                                      \
> +       int i, j;                                       \
> +       printk(KERN_DEBUG "Format: Pin Mux Config\n");  \
> +       for (i = 0; i < n; i++) {                       \
> +               j = p[i];                               \
> +               printk(KERN_DEBUG "%s %d 0x%lx\n",      \
> +                       info->pins[j].name,             \
> +                       m[i], c[i]);                    \
> +       }                                               \
>  }
>
>  /* The bits in CONFIG cell defined in binding doc*/
> @@ -201,10 +201,7 @@ static int imx_dt_node_to_map(struct pinctrl_dev *pctldev,
>  static void imx_dt_free_map(struct pinctrl_dev *pctldev,
>                                struct pinctrl_map *map, unsigned num_maps)
>  {
> -       int i;
> -
> -       for (i = 0; i < num_maps; i++)
> -               kfree(map);
> +       kfree(map);
>  }
>
>  static struct pinctrl_ops imx_pctrl_ops = {
> @@ -475,9 +472,8 @@ static int __devinit imx_pinctrl_parse_groups(struct device_node *np,
>                grp->configs[j] = config & ~IMX_PAD_SION;
>        }
>
> -#ifdef DEBUG
>        IMX_PMX_DUMP(info, grp->pins, grp->mux_mode, grp->configs, grp->npins);
> -#endif
> +
>        return 0;
>  }
>
> --
> 1.7.9.5
>
