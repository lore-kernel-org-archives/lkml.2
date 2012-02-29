Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031015Ab2B2OTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:19:08 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34054 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030957Ab2B2OTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:19:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jwboyer@gmail.com designates 10.216.131.6 as permitted sender) smtp.mail=jwboyer@gmail.com; dkim=pass header.i=jwboyer@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330505221-3678-1-git-send-email-mla@apm.com>
References: <1330505221-3678-1-git-send-email-mla@apm.com>
Date: Wed, 29 Feb 2012 09:18:16 -0500
Message-ID: <CA+5PVA4UAztYrJPqCqC9=T9brojOg2g=T--+BbMP8Br=xBrxfw@mail.gmail.com>
Subject: Re: [PATCH 1/2] powerpc/44x: Fix PCI MSI support for APM821xx SoC and
 Bluestone board
From: Josh Boyer <jwboyer@gmail.com>
To: Mai La <mla@apm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Tirumala R Marri <tmarri@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        open-source-review@apm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 3:47 AM, Mai La <mla@apm.com> wrote:
> This patch consists of:
> - Enable PCI MSI as default for Bluestone board
> - Define number of MSI interrupt for Maui APM821xx

What is Maui?  Is that the same thing as Bluestone?

> - Fix returning ENODEV as finding MSI node
> - Fix MSI physical high and low address
> - Keep MSI data logically
>
> Signed-off-by: Mai La <mla@apm.com>

Wow.  So there are a lot of bugfixes here.  I'm surprised this ever worked at
all with some of the things you're fixing.  Nice to see.

> ---
>  arch/powerpc/platforms/44x/Kconfig |    2 ++
>  arch/powerpc/sysdev/ppc4xx_msi.c   |   28 ++++++++++++++++++----------
>  2 files changed, 20 insertions(+), 10 deletions(-)
>
> diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
> index fcf6bf2..9f04ce3 100644
> --- a/arch/powerpc/platforms/44x/Kconfig
> +++ b/arch/powerpc/platforms/44x/Kconfig
> @@ -23,6 +23,8 @@ config BLUESTONE
>        default n
>        select PPC44x_SIMPLE
>        select APM821xx
> +       select PCI_MSI
> +       select PPC4xx_MSI
>        select IBM_EMAC_RGMII
>        help
>          This option enables support for the APM APM821xx Evaluation board.
> diff --git a/arch/powerpc/sysdev/ppc4xx_msi.c b/arch/powerpc/sysdev/ppc4xx_msi.c
> index 1c2d7af..6103908 100644
> --- a/arch/powerpc/sysdev/ppc4xx_msi.c
> +++ b/arch/powerpc/sysdev/ppc4xx_msi.c
> @@ -31,7 +31,7 @@
>  #include <asm/prom.h>
>  #include <asm/hw_irq.h>
>  #include <asm/ppc-pci.h>
> -#include <boot/dcr.h>
> +#include <asm/dcr.h>
>  #include <asm/dcr-regs.h>
>  #include <asm/msi_bitmap.h>
>
> @@ -43,7 +43,12 @@
>  #define PEIH_FLUSH0    0x30
>  #define PEIH_FLUSH1    0x38
>  #define PEIH_CNTRST    0x48
> +
> +#ifdef CONFIG_APM821xx
> +#define NR_MSI_IRQS    8
> +#else
>  #define NR_MSI_IRQS    4
> +#endif

Hm.  Do you think this is going to change quite a bit depending on which SoC
is being used?  If so, it might be better to introduce a Kconfig variable
that just defines this instead.  Something like:

	config 4xx_MSI_IRQS
	   int "Number of MSI IRQs"
	   depends on 4xx
	   default "8" if APM821xx
	   default "4" if !APM821xx

If there aren't going to be a wide variety of numbers, then the simple ifdef
you have is probably sufficient.

>  struct ppc4xx_msi {
>        u32 msi_addr_lo;
> @@ -150,12 +155,11 @@ static int ppc4xx_setup_pcieh_hw(struct platform_device *dev,
>        if (!sdr_addr)
>                return -1;
>
> -       SDR0_WRITE(sdr_addr, (u64)res.start >> 32);      /*HIGH addr */
> -       SDR0_WRITE(sdr_addr + 1, res.start & 0xFFFFFFFF); /* Low addr */
> -
> +       mtdcri(SDR0, *sdr_addr, res.start >> 32);       /*HIGH addr */
> +       mtdcri(SDR0, *sdr_addr + 1, res.start & 0xFFFFFFFF);/* Low addr */

Don't you still want the (u64) cast on res.start?

> CONFIDENTIALITY NOTICE: This e-mail message, including any attachments,
> is for the sole use of the intended recipient(s) and contains information
> that is confidential and proprietary to AppliedMicro Corporation or its subsidiaries.
> It is to be used solely for the purpose of furthering the parties' business relationship.
> All unauthorized review, use, disclosure or distribution is prohibited.
> If you are not the intended recipient, please contact the sender by reply e-mail
> and destroy all copies of the original message.

Is there a way you can drop this?  Others from APM seem to have figured out
how to do that, so hopefully it won't be a big problem.

josh
