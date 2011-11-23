Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab1KWOK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:10:56 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36503 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab1KWOKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:10:54 -0500
MIME-Version: 1.0
In-Reply-To: <1322041464-20605-1-git-send-email-tinamdar@apm.com>
References: <1322041464-20605-1-git-send-email-tinamdar@apm.com>
Date: Wed, 23 Nov 2011 09:10:53 -0500
Message-ID: <CA+5PVA4wpGfSXbX9oTdtDaGiWFkwZfiL9Md6SGJpXtOK6rG2ww@mail.gmail.com>
Subject: Re: [PATCH] powerpc/40x: Add APM8018X SOC support
From: Josh Boyer <jwboyer@gmail.com>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 4:44 AM, Tanmay Inamdar <tinamdar@apm.com> wrote:
>
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index b177caa..3f2cc36 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -978,3 +978,9 @@ config PPC_LIB_RHEAP
>        bool
>
>  source "arch/powerpc/kvm/Kconfig"
> +
> +config UART_16550_WORD_ADDRESSABLE
> +       bool
> +       default n
> +       help
> +          Enable this if your UART 16550 is word addressable.

Ugh.  What is this for?  More specifically, if the UART requires word
reads and writes, shouldn't it be using reg-shift/reg-offset in the
device tree?  I'm confused why UDBG would need this sort of code, but
the runtime serial driver doesn't?

> diff --git a/arch/powerpc/boot/dts/klondike.dts b/arch/powerpc/boot/dts/klondike.dts


> +       OCM: ocm@20000000 {
> +               compatible = "ibm,ocm";
> +               status = "enabled";
> +               cell-index = <1>;
> +               reg = < 0x20000000 0x1f000   /* 128K - 4K NAND */
> +                       0xfffe0000 0x1f000>; /* 128K - 4K I2C  */
> +               bootmode = "nand";
> +       };

What is this?  There's nothing in the kernel or in this patch that
binds with "ibm,ocm".  Also, that 'bootmode' property doesn't seem
like a hardware value, but a human descriptor of something that
switches it to boot from NAND.


> +               crypto: crypto@40000000 {
> +                       device_type = "crypto";
> +                       compatible = "405ex-crypto", "amcc,ppc405ex-crypto", "amcc,ppc4xx-crypto";

Why is the "405ex-crypto" string there?

> +               EDMA: edma@40080000 {
> +                       #address-cells = <1>;
> +                       #size-cells = <1>;
> +                       compatible = "amcc,edma";
> +                       device_type = "dma";
> +                       /*complQ-fifo-memory = "ocm";*/
> +                       cell-index = <0>;
> +                       reg = <0x40080000 0x00010000>;
> +                       dcr-reg = <0x060 0x09f>;
> +
> +                       interrupt-parent = <&UIC0>;
> +                       interrupts = </*complQ A */  0x4 4
> +                                       /*EDMA Err */  0x6 4 >;
> +
> +                       dma-channel@0 {
> +                               compatible = "amcc,edma-channel";
> +                               /*descriptor-memory = "ocm";*/
> +                               cell-index = <0>;
> +                               dcr-reg = <0x0000006a 0x0000006b>;
> +                       };
> +               };

What's this?  Again, nothing binds to "amcc,edma" in the kernel or
patch.  At the very least this (and OCM above) need some binding
descriptions added to Documentation/devicetree/bindings/powerpc/4xx/

> +
> +               MSI: dwc_pcie-msi@40090000 {
> +                       compatible = "amcc,dwc_pcie-msi", "dwc_pcie-msi";
> +                       status = "ok";

Is the status property something that is set by U-Boot, or will it
always be "ok"?  If the latter, I don't think you need to specify it
at all.

> +                       reg = <0x40090000 0x100>;
> +                       interrupts =<0x0 0x1 0x2 0x3>;
> +                       interrupt-parent = <&MSI>;
> +                       #interrupt-cells = <1>;
> +                       #address-cells = <0>;
> +                       #size-cells = <0>;
> +                       interrupt-map = <0x0 &UIC0 0x0C 0x1
> +                                        0x1 &UIC0 0x0D 0x1
> +                                        0x2 &UIC0 0x0E 0x1
> +                                        0x3 &UIC0 0x0F 0x1>;
> +               };

Same binding comment here.

> +
> +               AHB: ahb {
> +                       device_type = "ahb";

I doubt the device_type is needed.

> +                       compatible = "amcc,405ex-ahb", "ibm,ahb";
> +                       #address-cells = <1>;
> +                       #size-cells = <1>;
> +                       ranges;
> +                       clock-frequency = <0>; /* Filled in by U-Boot */

Same binding comment for ahb.

> +
> +                       lcd: lcd@58060000 {
> +                               device_type = "lcd";

Drop device_type.

> +                               compatible = "apm,apm-lcd","apm,db9000";
> +                               version = "apm-1.1";

Why is 'version' there?  Version of what?  The hardware itself, the
driver?  I doubt this is needed.

> +                               reg = <0x58060000 0x00001000>;
> +                               interrupt-parent = <&UIC0>;
> +                               /*
> +                                * interrupt index 0 for chip 1.0
> +                                * interrupt index 1 for chip 1.1
> +                                */
> +                               interrupts = <0x1c 2 0x1c 4>;
> +                       };

Same binding comment for apm,apm-lcd.  I'm just going to assert again
that anything that doesn't have a defined binding and/or driver needs
to be documented when it's introduced.  Repeat that for the rest of
the patch :).

> +
> +                       sdhc0: sdhc@58050000 {
> +                               device_type = "sdhc";

Drop device_type.

> +                               compatible = "amcc,ahb-sdhc";
> +                               #interrupt-cells = <1>;
> +                               reg = <0x58050000 0x100>;
> +                               interrupt-parent = <&UIC0>;
> +                               interrupts = <0x18 0x4>;
> +                               bootmode = "i2c";
> +                       };
> +
> +                       tdm0: tdm@58010000 {
> +                               device_type = "tdm";

Drop device_type.

> +                               status = "disabled";

Is that set by U-Boot?

> +                               compatible = "apm,ahb-tdm";
> +                               #interrupt-cells = <1>;
> +                               reg = <0x58010000 0x100>;
> +                               interrupt-parent = <&UIC1>;
> +                               interrupts = <0x15 0x1>;
> +                       };
> +
> +                       usbotg0: usbotg@58080000 {
> +                               device_type = "usb";

Drop device_type.

> +                               compatible = "apm,usb-otg";
> +                               reg = <0x58080000 0x10000>;
> +                               interrupt-parent = <&UIC0>;
> +                               interrupts = <0x1B 4>;
> +                               mode = "host";
> +                       };
> +                       spi0: spi@50000000 {
> +                               #address-cells = <1>;
> +                               #size-cells = <0>;
> +                               device_type = "spi";

Drop device_type.  I think you're starting to get the trend, so repeat
for the rest of the devices.

> +                               compatible = "apm,apm-spi";
> +                               reg = <0x50000000 0x100>;
> +                               interrupt-parent = <&UIC0>;
> +                               interrupts = <0x7 1>;  /* interrupt number->0x7 Polarity->HIGH Sensitivity->LEVEL */
> +                               half_duplex = <0x1>;   /*0 = rx/tx mode, 1 = eprom read mode */
> +                               sysclk = <100000000>;   /* input clock */
> +                               bus_num = <0x0>;       /* SPI = 0 */

> +
> +                       PCIE0: pciex@58020000 {
> +                               device_type = "pci";
> +                               compatible = "ibm,plb-pciex", "dwc-pciex", "amcc,dwc-pciex";

Why the unprefixed dwc-pciex compatible property?

> +                               #interrupt-cells = <1>;
> +                               #size-cells = <2>;
> +                               #address-cells = <3>;
> +                               primary;
> +                               port = <0>; /* port number */
> +                               status = "ok";


> +                       PCIE1: pciex@58030000 {
> +                               device_type = "pci";
> +                               compatible = "ibm,plb-pciex", "dwc-pciex", "amcc,dwc-pciex";
> +                               #interrupt-cells = <1>;
> +                               #size-cells = <2>;
> +                               #address-cells = <3>;
> +                               primary;
> +                               port = <1>; /* port number */
> +                               status = "disabled";

Is this set by U-Boot?


> +                       sata@58040000 {
> +                               compatible = "sata-ahci";

Uh.. what?

> +                               reg =  <0x58040000 0x2000>;
> +                               interrupt-parent = <&UIC0>;
> +                               interrupts = <0x1a 1>;


> +                               ufc@0xFE000000 {
> +                                       compatible = "ibm,ufc";
> +                                       reg = <0xFE000000 0x00010000>;
> +                                       #address-cells = <1>;
> +                                       #size-cells = <1>;
> +                                       bootmode = "nand";

Is UFC some kind of new flash controller that isn't NDFC?  Also,
bootmode seems to be a human and/or driver variable, not a description
of the hardware.

> +                       UART0: serial@50001000 {
> +                               device_type = "serial";
> +                               compatible = "ns16550";
> +                               reg = <0x50001000 0x00000100>;
> +                               virtual-reg = <0x50001000>;
> +                               clock-frequency = <300000000>; /* Filled in by U-Boot */
> +                               current-speed = <115200>;
> +                               interrupt-parent = <&UIC0>;
> +                               interrupts = <0x0 0x4>;
> +                               /*reg-shift = <2>;*/

This is commented out, but seems to be needed when you take the
word-addressed UDBG thing into account?


> +                       IEEE1588_0: ieee1588ts0@400a5000 {
> +                               status = "ok";
> +                               compatible = "ieee1588-ts";

What is that?

> diff --git a/arch/powerpc/configs/40x/klondike_defconfig b/arch/powerpc/configs/40x/klondike_defconfig
> new file mode 100644
> index 0000000..840f438
> --- /dev/null
> +++ b/arch/powerpc/configs/40x/klondike_defconfig
> @@ -0,0 +1,1353 @@
> +#
> +# Automatically generated file; DO NOT EDIT.
> +# Linux/powerpc 3.2.0-rc2 Kernel Configuration
> +#
> +# CONFIG_PPC64 is not set

This is a full defconfig.  We don't need a full config file.  You can
generate one with 'make savedefconfig' that contains only the options
you need to set.




> diff --git a/arch/powerpc/kernel/udbg_16550.c b/arch/powerpc/kernel/udbg_16550.c
> index 6837f83..dd3bce9 100644
> --- a/arch/powerpc/kernel/udbg_16550.c
> +++ b/arch/powerpc/kernel/udbg_16550.c
> @@ -18,6 +18,19 @@ extern void real_writeb(u8 data, volatile u8 __iomem *addr);
>  extern u8 real_205_readb(volatile u8 __iomem  *addr);
>  extern void real_205_writeb(u8 data, volatile u8 __iomem *addr);
>
> +#ifdef CONFIG_UART_16550_WORD_ADDRESSABLE
> +struct NS16550 {
> +       /* this struct must be packed */
> +       unsigned char rbr;  /* 0 */ u8 s0[3];

An array of length 3 for something "word-addressable"?  When did words
change to 3 bytes?  Now, I still haven't finished my coffee yet, but
that is really confusing.

> +       unsigned char ier;  /* 1 */ u8 s1[3];
> +       unsigned char fcr;  /* 2 */ u8 s2[3];
> +       unsigned char lcr;  /* 3 */ u8 s3[3];
> +       unsigned char mcr;  /* 4 */ u8 s4[3];
> +       unsigned char lsr;  /* 5 */ u8 s5[3];
> +       unsigned char msr;  /* 6 */ u8 s6[3];
> +       unsigned char scr;  /* 7 */ u8 s7[3];
> +};
> +#else
>  struct NS16550 {
>        /* this struct must be packed */
>        unsigned char rbr;  /* 0 */
> @@ -29,6 +42,7 @@ struct NS16550 {
>        unsigned char msr;  /* 6 */
>        unsigned char scr;  /* 7 */
>  };
> +#endif /* CONFIG_UART_16550_WORD_ADDRESSABLE */
>
>  #define thr rbr
>  #define iir fcr
> @@ -52,8 +66,16 @@ static struct NS16550 __iomem *udbg_comport;
>  static void udbg_550_flush(void)
>  {
>        if (udbg_comport) {
> +#if defined(CONFIG_APM8018X)
> +               int index;
> +               for (index = 0; index < 3500; index++) {
> +                       if ((in_8(&udbg_comport->lsr) & LSR_THRE) == LSR_THRE)
> +                               break;
> +               }
> +#else

What is index, and why do you read the same register 3500 times?  That
doesn't sound like an index, it sounds like some kind of poor-mans
timeout.

>                while ((in_8(&udbg_comport->lsr) & LSR_THRE) == 0)
>                        /* wait for idle */;
> +#endif /* CONFIG_APM8018X */
>        }
>  }
>
> diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
> index 1530229..3d0d1d9 100644
> --- a/arch/powerpc/platforms/40x/Kconfig
> +++ b/arch/powerpc/platforms/40x/Kconfig
> @@ -186,3 +186,14 @@ config IBM405_ERR51
>  #      bool
>  #      depends on !STB03xxx && PPC4xx_DMA
>  #      default y
> +#
> +
> +config APM8018X
> +       bool "APM8018X"
> +       depends on 40x
> +       default y

default n please.

> +       select PPC40x_SIMPLE
> +       select UART_16550_WORD_ADDRESSABLE
> +       help
> +         This option enables support for the AppliedMicro Klondike board.
> +
> diff --git a/arch/powerpc/platforms/40x/ppc40x_simple.c b/arch/powerpc/platforms/40x/ppc40x_simple.c
> index e8dd5c5..c8576af 100644
> --- a/arch/powerpc/platforms/40x/ppc40x_simple.c
> +++ b/arch/powerpc/platforms/40x/ppc40x_simple.c
> @@ -17,7 +17,7 @@
>  #include <asm/pci-bridge.h>
>  #include <asm/ppc4xx.h>
>  #include <asm/prom.h>
> -#include <asm/time.h>
> +#include <linux/time.h>

Is this needed for a reason?  If so, it should be submitted as a separate patch.

>  #include <asm/udbg.h>
>  #include <asm/uic.h>
>
> @@ -29,6 +29,7 @@ static __initdata struct of_device_id ppc40x_of_bus[] = {
>        { .compatible = "ibm,plb4", },
>        { .compatible = "ibm,opb", },
>        { .compatible = "ibm,ebc", },
> +       { .compatible = "ibm,ahb", },
>        { .compatible = "simple-bus", },
>        {},
>  };
> @@ -55,6 +56,7 @@ static const char *board[] __initdata = {
>        "amcc,haleakala",
>        "amcc,kilauea",
>        "amcc,makalu",
> +       "amcc,klondike",
>        "est,hotfoot"
>  };
>
> --
> 1.6.1.rc3
>
>
