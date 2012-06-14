Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab2FNRr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:47:29 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34097 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab2FNRr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:47:27 -0400
MIME-Version: 1.0
In-Reply-To: <1336362768-31326-1-git-send-email-vhtnguyen@apm.com>
References: <1336362768-31326-1-git-send-email-vhtnguyen@apm.com>
Date: Thu, 14 Jun 2012 13:47:26 -0400
Message-ID: <CA+5PVA7vnLvqwsDAboR4s-QCLWSDm34N2tE+sFiBMsE2f=qYEg@mail.gmail.com>
Subject: Re: [PATCH] powerpc/44x: Support OCM(On Chip Memory) for APM821xx SoC
 and Bluestone board
From: Josh Boyer <jwboyer@gmail.com>
To: Vinh Nguyen Huu Tuong <vhtnguyen@apm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Duc Dang <dhdang@apm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kumar Gala <galak@kernel.crashing.org>, Li Yang <leoli@freescale.com>,
        Ashish Kalra <ashish.kalra@freescale.com>,
        Anatolij Gustschin <agust@denx.de>, Liu Gang <Gang.Liu@freescale.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 6, 2012 at 11:52 PM, Vinh Nguyen Huu Tuong
<vhtnguyen@apm.com> wrote:
> This patch consists of:
> - Add driver for OCM component
> - Export OCM Information at /sys/class/ocm/ocminfo

Again, apologies for the delay.  Aside from the incorrect sysfs usage
I pointed out in my other reply, I have just a few comments/questions
below.

> diff --git a/arch/powerpc/boot/dts/bluestone.dts b/arch/powerpc/boot/dts/bluestone.dts
> index 7bda373..2687c11 100644
> --- a/arch/powerpc/boot/dts/bluestone.dts
> +++ b/arch/powerpc/boot/dts/bluestone.dts
> @@ -107,6 +107,14 @@
>                interrupt-parent = <&UIC0>;
>        };
>
> +       OCM1: ocm@400040000 {
> +               compatible = "ibm,ocm";
> +               status = "ok";
> +               cell-index = <1>;
> +               /* configured in U-Boot */
> +               reg = <4 0x00040000 0x8000>; /* 32K */
> +       };
> +
>        SDR0: sdr {
>                compatible = "ibm,sdr-apm821xx";
>                dcr-reg = <0x00e 0x002>;
> diff --git a/arch/powerpc/include/asm/ppc4xx_ocm.h b/arch/powerpc/include/asm/ppc4xx_ocm.h
> new file mode 100644
> index 0000000..ff7f386
> --- /dev/null
> +++ b/arch/powerpc/include/asm/ppc4xx_ocm.h
> @@ -0,0 +1,47 @@
> +/*
> + * PowerPC 4xx OCM memory allocation support
> + *
> + * (C) Copyright 2009, Applied Micro Circuits Corporation
> + * Victor Gallardo (vgallardo@amcc.com)
> + *
> + * See file CREDITS for list of people who contributed to this
> + * project.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
> + * MA 02111-1307 USA
> + */
> +
> +#ifndef __ASM_POWERPC_PPC4xx_OCM_H__
> +#define __ASM_POWERPC_PPC4xx_OCM_H__
> +
> +#include <linux/types.h>
> +
> +#define OCM_NON_CACHED 0
> +#define OCM_CACHED     1
> +
> +#if defined(CONFIG_PPC4xx_OCM)
> +
> +void *ocm_alloc(phys_addr_t *phys, int size, int align,
> +                 int flags, const char *owner);
> +void ocm_free(const void *virt);
> +
> +#else
> +
> +#define ocm_alloc(phys, size, align, flags, owner)     NULL
> +#define ocm_free(addr) ((void)0)
> +
> +#endif /* CONFIG_PPC4xx_OCM */
> +
> +#endif  /* __ASM_POWERPC_PPC4xx_OCM_H__ */

I don't see any users of this header included in the patch.  I'm going
to guess that follow-on drivers/users are queued once this is in the
tree?  Also, you might want to name these 'ppc4xx_ocm_alloc' or
similar.  The concept of OCM isn't limited to ppc4xx or even SoCs, so
just using 'ocm' in the global kernel namespace might not be great.

> diff --git a/arch/powerpc/sysdev/ppc4xx_ocm.c b/arch/powerpc/sysdev/ppc4xx_ocm.c
> new file mode 100644
> index 0000000..ba3e450
> --- /dev/null
> +++ b/arch/powerpc/sysdev/ppc4xx_ocm.c
> @@ -0,0 +1,420 @@
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/proc_fs.h>

Why do you need proc_fs.h?

> +#include <linux/seq_file.h>
> +#include <linux/spinlock.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/list.h>
> +#include <asm/uaccess.h>
> +#include <asm/prom.h>
> +#include <asm/dcr.h>
> +#include <asm/rheap.h>
> +#include <asm/mmu.h>
> +#include <asm/ppc4xx_ocm.h>
> +#include <linux/export.h>
> +
> +#define OCM_DISABLED   0
> +#define OCM_ENABLED            1
> +
> +struct ocm_block {
> +       struct list_head        list;
> +       void __iomem            *addr;
> +       int                                     size;
> +       const char                      *owner;
> +};
> +
> +/* non-cached or cached region */
> +struct ocm_region {
> +       phys_addr_t                     phys;
> +       void __iomem            *virt;
> +
> +       int                                     memtotal;
> +       int                                     memfree;
> +
> +       rh_info_t                       *rh;
> +       struct list_head        list;
> +};

There's some interesting whitespace usage in these struct definitions.

josh
