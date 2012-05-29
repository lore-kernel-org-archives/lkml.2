Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab2E2Hav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:30:51 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37528 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2E2Hau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:30:50 -0400
MIME-Version: 1.0
In-Reply-To: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com>
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com>
Date: Tue, 29 May 2012 15:30:49 +0800
X-Google-Sender-Auth: 05qyNfWSwjpDuR8UEO8pxXwmESY
Message-ID: <CADRPPNRL7s6adxJyotCRJ6_KmXnxrqKdcj-Hrg8MXoAAYR7Txg@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] powerpc/85xx: implement hardware timebase sync
From: Li Yang <leoli@freescale.com>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        scottwood@freescale.com, galak@kernel.crashing.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott,

Thanks for the valuable comment raised before and we have updated the
patches accordingly.  Please review the updated patch set and ACK if
they are good to you.  We hope it can be applied in this window.

Leo

On Fri, May 11, 2012 at 7:53 PM, Zhao Chenhui
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
>  arch/powerpc/include/asm/fsl_guts.h |    2 +
>  arch/powerpc/platforms/85xx/smp.c   |   93 +++++++++++++++++++++++++++++++++--
>  2 files changed, 91 insertions(+), 4 deletions(-)
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
> diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
> index ff42490..6862dda 100644
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
> @@ -115,13 +116,70 @@ smp_85xx_kick_cpu(int nr)
>
>  struct smp_ops_t smp_85xx_ops = {
>        .kick_cpu = smp_85xx_kick_cpu,
> -#ifdef CONFIG_KEXEC
> -       .give_timebase  = smp_generic_give_timebase,
> -       .take_timebase  = smp_generic_take_timebase,
> -#endif
>  };
>
>  #ifdef CONFIG_KEXEC
> +static struct ccsr_guts __iomem *guts;
> +static u64 timebase;
> +static int tb_req;
> +static int tb_valid;
> +
> +static void mpc85xx_timebase_freeze(int freeze)
> +{
> +       unsigned int mask;
> +
> +       if (!guts)
> +               return;
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
> +       mb();
> +       tb_valid = 0;
> +
> +       local_irq_restore(flags);
> +}
> +
>  atomic_t kexec_down_cpus = ATOMIC_INIT(0);
>
>  void mpc85xx_smp_kexec_cpu_down(int crash_shutdown, int secondary)
> @@ -228,6 +286,20 @@ smp_85xx_setup_cpu(int cpu_nr)
>                doorbell_setup_this_cpu();
>  }
>
> +#ifdef CONFIG_KEXEC
> +static const struct of_device_id guts_ids[] = {
> +       { .compatible = "fsl,mpc8572-guts", },
> +       { .compatible = "fsl,mpc8560-guts", },
> +       { .compatible = "fsl,mpc8536-guts", },
> +       { .compatible = "fsl,p1020-guts", },
> +       { .compatible = "fsl,p1021-guts", },
> +       { .compatible = "fsl,p1022-guts", },
> +       { .compatible = "fsl,p1023-guts", },
> +       { .compatible = "fsl,p2020-guts", },
> +       {},
> +};
> +#endif
> +
>  void __init mpc85xx_smp_init(void)
>  {
>        struct device_node *np;
> @@ -249,6 +321,19 @@ void __init mpc85xx_smp_init(void)
>                smp_85xx_ops.cause_ipi = doorbell_cause_ipi;
>        }
>
> +#ifdef CONFIG_KEXEC
> +       np = of_find_matching_node(NULL, guts_ids);
> +       if (np) {
> +               guts = of_iomap(np, 0);
> +               smp_85xx_ops.give_timebase = mpc85xx_give_timebase;
> +               smp_85xx_ops.take_timebase = mpc85xx_take_timebase;
> +               of_node_put(np);
> +       } else {
> +               smp_85xx_ops.give_timebase = smp_generic_give_timebase;
> +               smp_85xx_ops.take_timebase = smp_generic_take_timebase;
> +       }
> +#endif
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
- Leo
