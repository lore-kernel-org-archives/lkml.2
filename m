Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2FJRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 13:09:26 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53721 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab2FJRJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 13:09:24 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.19.137]
In-Reply-To: <1338989907-25360-7-git-send-email-sjur.brandeland@stericsson.com>
References: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com> <1338989907-25360-7-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 10 Jun 2012 20:09:03 +0300
Message-ID: <CAK=Wgbbtins7WD8nPrn_psWyWiOdm7zysmJBz6kYFew6TM0dAQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] remoteproc: Support custom firmware handlers
To: sjur.brandeland@stericsson.com
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Wed, Jun 6, 2012 at 4:38 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Firmware handling is made customizable.
> This is done by creating a separate ops structure for the
> firmware functions that depends on a particular firmware
> format (such as ELF). The ELF specific functions are exported
> by the structure rproc_elf_fw_ops.
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> ---
> @@ -171,6 +171,7 @@ static struct rproc_ops omap_rproc_ops = {
>        .start          = omap_rproc_start,
>        .stop           = omap_rproc_stop,
>        .kick           = omap_rproc_kick,
> +       .fw             = &rproc_elf_fw_ops

It might be more appropriate to provide the binary format handlers as
a separate argument to rproc_alloc, instead of adding it to the
rproc_ops struct (rproc_ops is dedicated to platform-specific handlers
that are implemented by the low-level driver).

>
>        rproc = kzalloc(sizeof(struct rproc) + len, GFP_KERNEL);
> diff --git a/drivers/remoteproc/remoteproc_elf_loader.c b/drivers/remoteproc/remoteproc_elf_loader.c
> index 2017ae3..9a53871 100644
> --- a/drivers/remoteproc/remoteproc_elf_loader.c
> +++ b/drivers/remoteproc/remoteproc_elf_loader.c
> @@ -33,8 +33,8 @@
>  #include "remoteproc_internal.h"
>
>  /* make sure this fw image is sane */
> -int
> -rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
> +static int
> +elf_sanity_check(struct rproc *rproc, const struct firmware *fw)

Do we want to keep the "rproc" prefix for the function names (e.g.
rproc_elf_sanity_check) ? we'll be better namespace citizens that way.

> -int
> -rproc_load_segments(struct rproc *rproc, const struct firmware *fw);
> -struct resource_table *
> -rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
> -                                                               int *tablesz);
> -int
> -rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw);
> -void rproc_set_boot_addr(struct rproc *rproc, const struct firmware *fw);

Oh, great, you removed those. In that case we don't really care they'd
stay in remoteproc.h for the transition.. (but that probably doesn't
apply to rproc_da_to_va).

> +static inline int
> +rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
> +{
> +       if (rproc->ops->fw_ops->sanity_check)
> +               return rproc->ops->fw_ops->sanity_check(rproc, fw);
> +       return 0;
> +}
> +
> +static inline
> +void rproc_set_boot_addr(struct rproc *rproc, const struct firmware *fw)
> +{
> +       if (rproc->ops->fw_ops->set_boot_addr)
> +               rproc->ops->fw_ops->set_boot_addr(rproc, fw);
> +}
> +
> +static inline int
> +rproc_load_segments(struct rproc *rproc, const struct firmware *fw)
> +{
> +       if (rproc->ops->fw_ops->load)
> +               return rproc->ops->fw_ops->load(rproc, fw);
> +       return -EINVAL;
> +}
> +static inline struct resource_table *
> +rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
> +                                                       int *tablesz)
> +{
> +       if (rproc->ops->fw_ops->find_rsc_table)
> +               return rproc->ops->fw_ops->find_rsc_table(rproc, fw, tablesz);
> +       return NULL;
> +}
> +
> +extern struct rproc_fw_ops rproc_elf_fw_ops;

I'd keep those too in remoteproc_internal.h, so they won't be
accessible to code outside of drivers/remoteproc.

Thanks!
Ohad.
