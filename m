Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab2F2Pjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:39:37 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:2039 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932118Ab2F2Pjg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:39:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I1521I1432Izz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3hf0ahbe9i)
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Zhao Chenhui-B35336 <B35336@freescale.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: Re: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
Thread-Topic: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
Thread-Index: AQHNVg1bO1oE4PLi102wbWFBHcWl+w==
Date: Fri, 29 Jun 2012 15:39:24 +0000
Message-ID: <CAOZdJXWiGOCtP1iJYR2S48XwR2Wpry8+VswctctdVfY9Z+QTiQ@mail.gmail.com>
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
In-Reply-To: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [107.22.165.113]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <8B5CC84EC6BB224B93CCC18F3D123B9D@mgd.freescale.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 5:25 AM, Zhao Chenhui
<chenhui.zhao@freescale.com> wrote:
> Do hardware timebase sync. Firstly, stop all timebases, and transfer
> the timebase value of the boot core to the other core. Finally,
> start all timebases.
>
> Only apply to dual-core chips, such as MPC8572, P2020, etc.
>
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> ---
> Changes for v6:
>  * added 85xx_TB_SYNC
>  * added isync() after set_tb()
>  * removed extra entries from mpc85xx_smp_guts_ids
>
>  arch/powerpc/include/asm/fsl_guts.h |    2 +
>  arch/powerpc/platforms/85xx/Kconfig |    5 ++
>  arch/powerpc/platforms/85xx/smp.c   |   84 +++++++++++++++++++++++++++++++++++
>  3 files changed, 91 insertions(+), 0 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/fsl_guts.h b/arch/powerpc/include/asm/fsl_guts.h
> index aa4c488..dd5ba2c 100644
> --- a/arch/powerpc/include/asm/fsl_guts.h
> +++ b/arch/powerpc/include/asm/fsl_guts.h
> @@ -48,6 +48,8 @@ struct ccsr_guts {
>         __be32  dmuxcr;                /* 0x.0068 - DMA Mux Control Register */
>         u8     res06c[0x70 - 0x6c];
>        __be32  devdisr;        /* 0x.0070 - Device Disable Control */
> +#define CCSR_GUTS_DEVDISR_TB1  0x00001000
> +#define CCSR_GUTS_DEVDISR_TB0  0x00004000
>        __be32  devdisr2;       /* 0x.0074 - Device Disable Control 2 */
>        u8      res078[0x7c - 0x78];
>        __be32  pmjcr;          /* 0x.007c - 4 Power Management Jog Control Register */
> diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
> index f000d81..8dd7147 100644
> --- a/arch/powerpc/platforms/85xx/Kconfig
> +++ b/arch/powerpc/platforms/85xx/Kconfig
> @@ -8,6 +8,7 @@ menuconfig FSL_SOC_BOOKE
>        select FSL_PCI if PCI
>        select SERIAL_8250_EXTENDED if SERIAL_8250
>        select SERIAL_8250_SHARE_IRQ if SERIAL_8250
> +       select 85xx_TB_SYNC if KEXEC
>        default y
>
>  if FSL_SOC_BOOKE
> @@ -267,3 +268,7 @@ endif # FSL_SOC_BOOKE
>
>  config TQM85xx
>        bool
> +
> +config 85xx_TB_SYNC
> +       bool
> +       default n
> diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
> index ff42490..edb0cad 100644
> --- a/arch/powerpc/platforms/85xx/smp.c
> +++ b/arch/powerpc/platforms/85xx/smp.c
> @@ -24,6 +24,7 @@
>  #include <asm/mpic.h>
>  #include <asm/cacheflush.h>
>  #include <asm/dbell.h>
> +#include <asm/fsl_guts.h>
>
>  #include <sysdev/fsl_soc.h>
>  #include <sysdev/mpic.h>
> @@ -42,6 +43,69 @@ extern void __early_start(void);
>  #define NUM_BOOT_ENTRY         8
>  #define SIZE_BOOT_ENTRY                (NUM_BOOT_ENTRY * sizeof(u32))
>
> +#ifdef CONFIG_85xx_TB_SYNC
> +static struct ccsr_guts __iomem *guts;
> +static u64 timebase;
> +static int tb_req;
> +static int tb_valid;
> +
> +static void mpc85xx_timebase_freeze(int freeze)
> +{
> +       unsigned int mask;

'mask' should be uint32_t

> +
> +       if (!guts)
> +               return;

This function should never be called if guts is NULL, so this check
should be unnecessary.

> +
> +       mask = CCSR_GUTS_DEVDISR_TB0 | CCSR_GUTS_DEVDISR_TB1;
> +       if (freeze)
> +               setbits32(&guts->devdisr, mask);
> +       else
> +               clrbits32(&guts->devdisr, mask);
> +
> +       in_be32(&guts->devdisr);
> +}
> +
> +static void mpc85xx_give_timebase(void)
> +{
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +
> +       while (!tb_req)
> +               barrier();

I think tb_req and tb_valid need to be 'volatile'.

> +       tb_req = 0;
> +
> +       mpc85xx_timebase_freeze(1);
> +       timebase = get_tb();
> +       mb();
> +       tb_valid = 1;
> +
> +       while (tb_valid)
> +               barrier();
> +
> +       mpc85xx_timebase_freeze(0);
> +
> +       local_irq_restore(flags);
> +}
> +
> +static void mpc85xx_take_timebase(void)
> +{
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +
> +       tb_req = 1;
> +       while (!tb_valid)
> +               barrier();
> +
> +       set_tb(timebase >> 32, timebase & 0xffffffff);
> +       isync();
> +       tb_valid = 0;
> +
> +       local_irq_restore(flags);
> +}
> +#endif
> +
>  static int __init
>  smp_85xx_kick_cpu(int nr)
>  {
> @@ -228,6 +292,16 @@ smp_85xx_setup_cpu(int cpu_nr)
>                doorbell_setup_this_cpu();
>  }
>
> +static const struct of_device_id mpc85xx_smp_guts_ids[] = {
> +       { .compatible = "fsl,mpc8572-guts", },
> +       { .compatible = "fsl,p1020-guts", },
> +       { .compatible = "fsl,p1021-guts", },
> +       { .compatible = "fsl,p1022-guts", },
> +       { .compatible = "fsl,p1023-guts", },
> +       { .compatible = "fsl,p2020-guts", },
> +       {},
> +};

I wonder if it's possible to dynamically generate the compatible
string by using the SOC name?

> +
>  void __init mpc85xx_smp_init(void)
>  {
>        struct device_node *np;
> @@ -249,6 +323,16 @@ void __init mpc85xx_smp_init(void)
>                smp_85xx_ops.cause_ipi = doorbell_cause_ipi;
>        }
>
> +       np = of_find_matching_node(NULL, mpc85xx_smp_guts_ids);
> +       if (np) {
> +#ifdef CONFIG_85xx_TB_SYNC
> +               guts = of_iomap(np, 0);

You need to test the return value of of_iomap().  smp_85xx_ops should
be set only if guts is not NULL.

> +               smp_85xx_ops.give_timebase = mpc85xx_give_timebase;
> +               smp_85xx_ops.take_timebase = mpc85xx_take_timebase;
> +#endif
> +               of_node_put(np);
> +       }
> +
>        smp_ops = &smp_85xx_ops;
>
>  #ifdef CONFIG_KEXEC
> --
> 1.6.4.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Timur Tabi
Linux kernel developer at Freescale
