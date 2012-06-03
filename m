Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2FCNhJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 09:37:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63354 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2FCNhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 09:37:07 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.83.253]
In-Reply-To: <1337693217-15466-6-git-send-email-sjur.brandeland@stericsson.com>
References: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com> <1337693217-15466-6-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 3 Jun 2012 16:36:46 +0300
Message-ID: <CAK=WgbaOZn8K4FberD8gt5+eB1=EwjPhngArwif8u3L5Qqw=3A@mail.gmail.com>
Subject: Re: [RFC 5/6] remoteproc: Support custom firmware handlers
To: sjur.brandeland@stericsson.com
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 4:26 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Make the firmware handling customizable by creating
> a rproc_fw_ops structure. Expose the existing
> Elf firmware handling in rproc_elf_fw_ops.
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
..
> @@ -171,6 +171,7 @@ static struct rproc_ops omap_rproc_ops = {
>        .start          = omap_rproc_start,
>        .stop           = omap_rproc_stop,
>        .kick           = omap_rproc_kick,
> +       .fw             = &rproc_elf_fw_ops
>  };

Can we instead make these ops dynamically assigned, without mandating
them in the low level driver ?

E.g. with ELF it's easy (first four bytes of the binary), but I'm not
sure how feasible it is with proprietary binary formats (such as
yours).

> @@ -781,12 +780,13 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
>  {
>        struct device *dev = rproc->dev;
>        const char *name = rproc->firmware;
> -       struct elf32_hdr *ehdr;
>        struct resource_table *table;
>        int ret, tablesz;
>
> -       ehdr = (struct elf32_hdr *)fw->data;
> -
> +       if (!rproc->ops->fw_ops || !try_module_get(rproc->ops->fw_ops->owner)) {

I'm not sure we need loaders' ops to be full-fledged modules of their
own. For simplicity, we might just have them statically linked with
the remoteproc module.

>        /* look for the resource table */
> -       table = rproc_find_rsc_table(rproc, fw, &tablesz);
> +       table = rproc->ops->fw_ops->find_rsc_table(rproc, fw, &tablesz);

Might be easier on the eyes if we turn rproc_find_rsc_table() (and
friends) into static inline "macros" which does all this
de-referencing.

Thanks,
Ohad.
