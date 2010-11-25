Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab0KYHZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:25:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43955 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab0KYHZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:25:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J8pF30rAFyyJZxN86gSX+NVoLpRjV5JTAJtda2aYiwoPiGX7MhzjMCwrs7wGh0Zjif
         ItnTIHr0EXWpgE2Bc5N1pPHBPcFC/rfRSEdZkEocGkJnjmMIcrNK1eMaseG3UGXpwWZT
         FhYc0WhAYl5vpxMycZebt/u5Sxzb2By76cNZg=
MIME-Version: 1.0
In-Reply-To: <20101124161122.GA15902@oksana.dev.rtsoft.ru>
References: <1290443565-20766-1-git-send-email-mkl0301@gmail.com>
	<1290443565-20766-3-git-send-email-mkl0301@gmail.com>
	<20101124161122.GA15902@oksana.dev.rtsoft.ru>
Date: Thu, 25 Nov 2010 15:25:38 +0800
Message-ID: <AANLkTimMEALmH08RKQet_MGiyEFYpD2kVtPtmKJpmhtZ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ARM: cns3xxx: Add architecture definition for
 EHCI/OHCI controller
From: Lin Mac <mkl0301@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/25 Anton Vorontsov <cbouatmailru@gmail.com>:
> On Tue, Nov 23, 2010 at 12:32:44AM +0800, mkl0301@gmail.com wrote:
>> From: Mac Lin <mkl0301@gmail.com>
>>
>> This patch add plateform_device for EHCI and OHCI controller on CNS3XXX. Power
>> reference count (usb_pwr_ref) is used to control enabling and disabling the
>> single clock control for both EHCI and OHCI controller.
>>
>> It also remove EHCI/OHCI unused virtual address definitions.
>>
>> Signed-off-by: Mac Lin <mkl0301@gmail.com>
>> ---
> [...]
>
> I fixed a few small stylistic issues in this patch. Plus,
>
>> +     },
>> +     [1] = {
>> +             .start          = IRQ_CNS3XXX_USB_OHCI,
>> +             .flags          = IORESOURCE_IRQ,
>> +     },
>> +};
>> +
>> +static u64 cns3xxx_usb_ohci_dma_mask = 0xffffffffULL;
>
> Changed this to DMA_BIT_MASK(32).
>
>> +static struct platform_device cns3xxx_usb_ohci_device = {
>> +     .name = "cns3xxx-ohci",
>> +     .dev                = {
>> +             .dma_mask       = &cns3xxx_usb_ohci_dma_mask,
>> +             .coherent_dma_mask = 0xffffffffULL,
>
> Ditto.
>
> [...]
>> --- a/arch/arm/mach-cns3xxx/include/mach/pm.h
>> +++ b/arch/arm/mach-cns3xxx/include/mach/pm.h
>> @@ -16,4 +16,6 @@ void cns3xxx_pwr_clk_dis(unsigned int block);
>>  void cns3xxx_pwr_power_up(unsigned int block);
>>  void cns3xxx_pwr_power_down(unsigned int block);
>>
>> +extern atomic_t usb_pwr_ref;
>
> You needed #include <asm/atomic.h> in this file, I added this for you.
>
> ...and in the end, applied the following patch to CNS3xxx tree:
>
> commit bcea8081b6b6a298db016f33de8d52845deda9d6
> Author: Mac Lin <mkl0301@gmail.com>
> Date:   Tue Nov 23 00:32:44 2010 +0800
>
>    ARM: cns3xxx: Add architecture definition for EHCI/OHCI controller
>
>    This patch add plateform_device for EHCI and OHCI controller on CNS3XXX.
>    Power reference count (usb_pwr_ref) is used to control enabling and
>    disabling the single clock control for both EHCI and OHCI controller.
>
>    It also removes EHCI/OHCI unused virtual address definitions.
>
>    Signed-off-by: Mac Lin <mkl0301@gmail.com>
>    Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
>
> diff --git a/arch/arm/mach-cns3xxx/cns3420vb.c b/arch/arm/mach-cns3xxx/cns3420vb.c
> index 9df8391..795ad77 100644
> --- a/arch/arm/mach-cns3xxx/cns3420vb.c
> +++ b/arch/arm/mach-cns3xxx/cns3420vb.c
> @@ -17,6 +17,7 @@
>  #include <linux/kernel.h>
>  #include <linux/compiler.h>
>  #include <linux/io.h>
> +#include <linux/dma-mapping.h>
>  #include <linux/serial_core.h>
>  #include <linux/serial_8250.h>
>  #include <linux/platform_device.h>
> @@ -108,10 +109,63 @@ static void __init cns3420_early_serial_setup(void)
>  }
>
>  /*
> + * USB
> + */
> +static struct resource cns3xxx_usb_ehci_resources[] = {
> +       [0] = {
> +               .start = CNS3XXX_USB_BASE,
> +               .end   = CNS3XXX_USB_BASE + SZ_16M - 1,
> +               .flags = IORESOURCE_MEM,
> +       },
> +       [1] = {
> +               .start = IRQ_CNS3XXX_USB_EHCI,
> +               .flags = IORESOURCE_IRQ,
> +       },
> +};
> +
> +static u64 cns3xxx_usb_ehci_dma_mask = DMA_BIT_MASK(32);
> +
> +static struct platform_device cns3xxx_usb_ehci_device = {
> +       .name          = "cns3xxx-ehci",
> +       .num_resources = ARRAY_SIZE(cns3xxx_usb_ehci_resources),
> +       .resource      = cns3xxx_usb_ehci_resources,
> +       .dev           = {
> +               .dma_mask          = &cns3xxx_usb_ehci_dma_mask,
> +               .coherent_dma_mask = DMA_BIT_MASK(32),
> +       },
> +};
> +
> +static struct resource cns3xxx_usb_ohci_resources[] = {
> +       [0] = {
> +               .start = CNS3XXX_USB_OHCI_BASE,
> +               .end   = CNS3XXX_USB_OHCI_BASE + SZ_16M - 1,
> +               .flags = IORESOURCE_MEM,
> +       },
> +       [1] = {
> +               .start = IRQ_CNS3XXX_USB_OHCI,
> +               .flags = IORESOURCE_IRQ,
> +       },
> +};
> +
> +static u64 cns3xxx_usb_ohci_dma_mask = DMA_BIT_MASK(32);
> +
> +static struct platform_device cns3xxx_usb_ohci_device = {
> +       .name          = "cns3xxx-ohci",
> +       .num_resources = ARRAY_SIZE(cns3xxx_usb_ohci_resources),
> +       .resource      = cns3xxx_usb_ohci_resources,
> +       .dev           = {
> +               .dma_mask          = &cns3xxx_usb_ohci_dma_mask,
> +               .coherent_dma_mask = DMA_BIT_MASK(32),
> +       },
> +};
> +
> +/*
>  * Initialization
>  */
>  static struct platform_device *cns3420_pdevs[] __initdata = {
>        &cns3420_nor_pdev,
> +       &cns3xxx_usb_ehci_device,
> +       &cns3xxx_usb_ohci_device,
>  };
>
>  static void __init cns3420_init(void)
> diff --git a/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h b/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
> index 6dbce13..191c8e5 100644
> --- a/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
> +++ b/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
> @@ -165,7 +165,6 @@
>  #define CNS3XXX_USBOTG_BASE_VIRT               0xFFF15000
>
>  #define CNS3XXX_USB_BASE                       0x82000000      /* USB Host Control */
> -#define CNS3XXX_USB_BASE_VIRT                  0xFFF16000
>
>  #define CNS3XXX_SATA2_BASE                     0x83000000      /* SATA */
>  #define CNS3XXX_SATA2_SIZE                     SZ_16M
> @@ -184,7 +183,6 @@
>  #define CNS3XXX_2DG_BASE_VIRT                  0xFFF1B000
>
>  #define CNS3XXX_USB_OHCI_BASE                  0x88000000      /* USB OHCI */
> -#define CNS3XXX_USB_OHCI_BASE_VIRT             0xFFF1C000
>
>  #define CNS3XXX_L2C_BASE                       0x92000000      /* L2 Cache Control */
>  #define CNS3XXX_L2C_BASE_VIRT                  0xFFF27000
> diff --git a/arch/arm/mach-cns3xxx/include/mach/pm.h b/arch/arm/mach-cns3xxx/include/mach/pm.h
> index 102617b..6eae7f7 100644
> --- a/arch/arm/mach-cns3xxx/include/mach/pm.h
> +++ b/arch/arm/mach-cns3xxx/include/mach/pm.h
> @@ -11,9 +11,13 @@
>  #ifndef __CNS3XXX_PM_H
>  #define __CNS3XXX_PM_H
>
> +#include <asm/atomic.h>
> +
>  void cns3xxx_pwr_clk_en(unsigned int block);
>  void cns3xxx_pwr_clk_dis(unsigned int block);
>  void cns3xxx_pwr_power_up(unsigned int block);
>  void cns3xxx_pwr_power_down(unsigned int block);
>
> +extern atomic_t usb_pwr_ref;
> +
>  #endif /* __CNS3XXX_PM_H */
> diff --git a/arch/arm/mach-cns3xxx/pm.c b/arch/arm/mach-cns3xxx/pm.c
> index 7b672e5..78fbaba 100644
> --- a/arch/arm/mach-cns3xxx/pm.c
> +++ b/arch/arm/mach-cns3xxx/pm.c
> @@ -10,6 +10,7 @@
>  #include <linux/module.h>
>  #include <linux/io.h>
>  #include <linux/delay.h>
> +#include <asm/atomic.h>
It's not necessary for mach/pm.h already included it, right?

>  #include <mach/system.h>
>  #include <mach/cns3xxx.h>
>  #include <mach/pm.h>
> @@ -117,3 +118,6 @@ int cns3xxx_cpu_clock(void)
>        return cpu;
>  }
>  EXPORT_SYMBOL(cns3xxx_cpu_clock);
> +
> +atomic_t usb_pwr_ref = ATOMIC_INIT(0);
> +EXPORT_SYMBOL(usb_pwr_ref);
>
