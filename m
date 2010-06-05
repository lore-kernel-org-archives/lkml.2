Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487Ab0FEPIt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 11:08:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34954 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933319Ab0FEPIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 11:08:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RQSeolYu5EP0TsMHjAETMXIUJbRq8bH920i1PlYYB91Rl0uE+BQ1Y81ROKC991DPT5
         8fMBgIaoCzno/9gagmpCcdYdbfT111t75tlSKI1mK/8T7aDUaIjieRACbnHS5Pjw8hmd
         DMzOp97dj10H0Jk1DEnQKnoUOnYBCDS+uy9n4=
MIME-Version: 1.0
In-Reply-To: <0173f18c60cb4d1f8a0d123da6cd3cfca0224788.1275456869.git.baruch@tkos.co.il>
References: <0173f18c60cb4d1f8a0d123da6cd3cfca0224788.1275456869.git.baruch@tkos.co.il>
Date: Sat, 5 Jun 2010 23:08:46 +0800
Message-ID: <AANLkTimzq5zBEqrxzkm_D7trn7ikJX8yqny_6SogdIO6@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH] rtc: driver for the DryIce block found in 
	i.MX25 chips
From: Wan ZongShun <mcuos.com@gmail.com>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
       Alessandro Zummo <a.zummo@towertech.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Baruch ,

Some minor comments below:

2010/6/2 Baruch Siach <baruch@tkos.co.il>:
> This driver is based on code from Freescale which accompanies their i.MX25 PDK
> board, with some cleanup.
>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> ---
>
> I'm sending this to LKML also, since the RTC maintainer has been silent since I
> sent v3 of this driver three months ago. If you know any better way to push
> this driver upstream, please let me know.
>
> Changes v3 -> v4:
>
>        Merge in a patch fixing an "irq: nobody cared" race.
>
> Changes v2 -> v3:
>
> Add spaces around the '+' operator as suggested by Alessandro Zummo and Lothar
> Waßmann.
>
> Address other comments of Alessandro Zummo:
>
>        * add implementation of the alarm_irq_enable rtc op
>        * use devres in .probe
>        * remove unneeded initializations
>
> Changes v1 -> v2:
>
> Address the comments of Alessandro Zummo:
>
>        * remove the .ioctl implementation
>        * implement .set_mmss instead of .set_time
>        * reorder the .probe implementation
>        * make sure not to have enabled interrupts when registering or
>          unregistering the rtc device
>        * add MODULE_AUTHOR() with my email
>
> Address the comment of Lothar Waßmann:
>
>        * return PTR_ERR on clk_get failure
>
> Slightly change MODULE_DESCRIPTION().
> Use timeout which is independent of HZ for wait_event_interruptible_timeout().
>
>  drivers/rtc/Kconfig     |   10 +
>  drivers/rtc/Makefile    |    1 +
>  drivers/rtc/rtc-imxdi.c |  520 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 531 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-imxdi.c
>
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index 10ba12c..f7dab3b 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -537,6 +537,16 @@ config RTC_DRV_MSM6242
>          This driver can also be built as a module. If so, the module
>          will be called rtc-msm6242.
>
> +config RTC_DRV_IMXDI
> +       tristate "Freescale IMX DryIce Real Time Clock"
> +       depends on ARCH_MX25
> +       depends on RTC_CLASS
> +       help
> +          Support for Freescale IMX DryIce RTC
> +
> +          This driver can also be built as a module, if so, the module
> +          will be called "rtc-imxdi".
> +
>  config RTC_MXC
>        tristate "Freescale MXC Real Time Clock"
>        depends on ARCH_MXC
> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
> index 5adbba7..e0f6fd5 100644
> --- a/drivers/rtc/Makefile
> +++ b/drivers/rtc/Makefile
> @@ -46,6 +46,7 @@ obj-$(CONFIG_RTC_DRV_EFI)     += rtc-efi.o
>  obj-$(CONFIG_RTC_DRV_EP93XX)   += rtc-ep93xx.o
>  obj-$(CONFIG_RTC_DRV_FM3130)   += rtc-fm3130.o
>  obj-$(CONFIG_RTC_DRV_GENERIC)  += rtc-generic.o
> +obj-$(CONFIG_RTC_DRV_IMXDI)    += rtc-imxdi.o
>  obj-$(CONFIG_RTC_DRV_ISL1208)  += rtc-isl1208.o
>  obj-$(CONFIG_RTC_DRV_M41T80)   += rtc-m41t80.o
>  obj-$(CONFIG_RTC_DRV_M41T94)   += rtc-m41t94.o
> diff --git a/drivers/rtc/rtc-imxdi.c b/drivers/rtc/rtc-imxdi.c
> new file mode 100644
> index 0000000..7f207cd
> --- /dev/null
> +++ b/drivers/rtc/rtc-imxdi.c
> @@ -0,0 +1,520 @@
> +/*
> + * Copyright 2008-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> + * Copyright 2010 Orex Computed Radiography
> + */
> +
> +/*
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +/* based on rtc-mc13892.c */
> +
> +/*
> + * This driver uses the 47-bit 32 kHz counter in the Freescale DryIce block
> + * to implement a Linux RTC. Times and alarms are truncated to seconds.
> + * Since the RTC framework performs API locking via rtc->ops_lock the
> + * only simultaneous accesses we need to deal with is updating DryIce
> + * registers while servicing an alarm.
> + *
> + * Note that reading the DSR (DryIce Status Register) automatically clears
> + * the WCF (Write Complete Flag). All DryIce writes are synchronized to the
> + * LP (Low Power) domain and set the WCF upon completion. Writes to the
> + * DIER (DryIce Interrupt Enable Register) are the only exception. These
> + * occur at normal bus speeds and do not set WCF.  Periodic interrupts are
> + * not supported by the hardware.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/rtc.h>
> +#include <linux/workqueue.h>
> +
> +/* DryIce Register Definitions */
> +
> +#define DTCMR     0x00           /* Time Counter MSB Reg */
> +#define DTCLR     0x04           /* Time Counter LSB Reg */
> +
> +#define DCAMR     0x08           /* Clock Alarm MSB Reg */
> +#define DCALR     0x0c           /* Clock Alarm LSB Reg */
> +#define DCAMR_UNSET  0xFFFFFFFF  /* doomsday - 1 sec */
> +
> +#define DCR       0x10           /* Control Reg */
> +#define DCR_TCE   (1 << 3)       /* Time Counter Enable */
> +
> +#define DSR       0x14           /* Status Reg */
> +#define DSR_WBF   (1 << 10)      /* Write Busy Flag */
> +#define DSR_WNF   (1 << 9)       /* Write Next Flag */
> +#define DSR_WCF   (1 << 8)       /* Write Complete Flag */
> +#define DSR_WEF   (1 << 7)       /* Write Error Flag */
> +#define DSR_CAF   (1 << 4)       /* Clock Alarm Flag */
> +#define DSR_NVF   (1 << 1)       /* Non-Valid Flag */
> +#define DSR_SVF   (1 << 0)       /* Security Violation Flag */
> +
> +#define DIER      0x18           /* Interrupt Enable Reg */
> +#define DIER_WNIE (1 << 9)       /* Write Next Interrupt Enable */
> +#define DIER_WCIE (1 << 8)       /* Write Complete Interrupt Enable */
> +#define DIER_WEIE (1 << 7)       /* Write Error Interrupt Enable */
> +#define DIER_CAIE (1 << 4)       /* Clock Alarm Interrupt Enable */
> +
> +/**
> + * struct imxdi_dev - private imxdi rtc data
> + * @pdev: pionter to platform dev
> + * @rtc: pointer to rtc struct
> + * @ioaddr: IO registers pointer
> + * @irq: dryice normal interrupt
> + * @clk: input reference clock
> + * @dsr: copy of the DSR register
> + * @irq_lock: interrupt enable register (DIER) lock
> + * @write_wait: registers write complete queue
> + * @write_mutex: serialize registers write
> + * @work: schedule alarm work
> + */
> +struct imxdi_dev {
> +       struct platform_device *pdev;
> +       struct rtc_device *rtc;
> +       void __iomem *ioaddr;
> +       int irq;
> +       struct clk *clk;
> +       u32 dsr;
> +       spinlock_t irq_lock;
> +       wait_queue_head_t write_wait;
> +       struct mutex write_mutex;
> +       struct work_struct work;
> +};
> +
> +/*
> + * enable a dryice interrupt
> + */
> +static inline void di_int_enable(struct imxdi_dev *imxdi, u32 intr)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&imxdi->irq_lock, flags);
> +       __raw_writel(__raw_readl(imxdi->ioaddr + DIER) | intr,
> +                       imxdi->ioaddr + DIER);
> +       spin_unlock_irqrestore(&imxdi->irq_lock, flags);
> +}
> +
> +/*
> + * disable a dryice interrupt
> + */
> +static inline void di_int_disable(struct imxdi_dev *imxdi, u32 intr)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&imxdi->irq_lock, flags);
> +       __raw_writel(__raw_readl(imxdi->ioaddr + DIER) & ~intr,
> +                       imxdi->ioaddr + DIER);
> +       spin_unlock_irqrestore(&imxdi->irq_lock, flags);
> +}
> +
> +/*
> + * This function attempts to clear the dryice write-error flag.
> + *
> + * A dryice write error is similar to a bus fault and should not occur in
> + * normal operation.  Clearing the flag requires another write, so the root
> + * cause of the problem may need to be fixed before the flag can be cleared.
> + */
> +static void clear_write_error(struct imxdi_dev *imxdi)
> +{
> +       int cnt;
> +
> +       dev_warn(&imxdi->pdev->dev, "WARNING: Register write error!\n");
> +
> +       for (;;) {
> +               /* clear the write error flag */
> +               __raw_writel(DSR_WEF, imxdi->ioaddr + DSR);
> +
> +               /* wait for it to take effect */
> +               for (cnt = 0; cnt < 100; cnt++) {
> +                       if ((__raw_readl(imxdi->ioaddr + DSR) & DSR_WEF) == 0)
> +                               return;
> +                       udelay(10);
> +               }
> +               dev_err(&imxdi->pdev->dev,
> +                       "ERROR: Cannot clear write-error flag!\n");
> +       }
> +}
> +
> +/*
> + * Write a dryice register and wait until it completes.
> + *
> + * This function uses interrupts to determine when the
> + * write has completed.
> + */
> +static int di_write_wait(struct imxdi_dev *imxdi, u32 val, int reg)
> +{
> +       int ret;
> +       int rc = 0;
> +
> +       /* serialize register writes */
> +       mutex_lock(&imxdi->write_mutex);
> +
> +       /* enable the write-complete interrupt */
> +       di_int_enable(imxdi, DIER_WCIE);
> +
> +       imxdi->dsr = 0;
> +
> +       /* do the register write */
> +       __raw_writel(val, imxdi->ioaddr + reg);
> +
> +       /* wait for the write to finish */
> +       ret = wait_event_interruptible_timeout(imxdi->write_wait,
> +                       imxdi->dsr & (DSR_WCF | DSR_WEF), msecs_to_jiffies(1));
> +       if (ret == 0)
> +               dev_warn(&imxdi->pdev->dev,
> +                               "Write-wait timeout "
> +                               "val = 0x%08x reg = 0x%08x\n", val, reg);
> +
> +       /* check for write error */
> +       if (imxdi->dsr & DSR_WEF) {
> +               clear_write_error(imxdi);
> +               rc = -EIO;
> +       }
> +       mutex_unlock(&imxdi->write_mutex);
> +       return rc;
> +}
> +
> +/*
> + * read the seconds portion of the current time from the dryice time counter
> + */
> +static int dryice_rtc_read_time(struct device *dev, struct rtc_time *tm)
> +{
> +       struct imxdi_dev *imxdi = dev_get_drvdata(dev);
> +       unsigned long now;
> +
> +       now = __raw_readl(imxdi->ioaddr + DTCMR);
> +       rtc_time_to_tm(now, tm);
> +

When we want to return a tm value, call rtc_valid_tm() to check the tm
that is a good habit.

> +       return 0;
> +}
> +
> +/*
> + * set the seconds portion of dryice time counter and clear the
> + * fractional part.
> + */
> +static int dryice_rtc_set_mmss(struct device *dev, unsigned long secs)
> +{
> +       struct imxdi_dev *imxdi = dev_get_drvdata(dev);
> +       int rc;
> +
> +       /* zero the fractional part first */
> +       rc = di_write_wait(imxdi, 0, DTCLR);
> +       if (rc == 0)
> +               rc = di_write_wait(imxdi, secs, DTCMR);
> +
> +       return rc;
> +}
> +
> +static int dryice_rtc_alarm_irq_enable(struct device *dev,
> +               unsigned int enabled)
> +{
> +       struct imxdi_dev *imxdi = dev_get_drvdata(dev);
> +
> +       if (enabled)
> +               di_int_enable(imxdi, DIER_CAIE);
> +       else
> +               di_int_disable(imxdi, DIER_CAIE);
> +
> +       return 0;
> +}
> +
> +/*
> + * read the seconds portion of the alarm register.
> + * the fractional part of the alarm register is always zero.
> + */
> +static int dryice_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
> +{
> +       struct imxdi_dev *imxdi = dev_get_drvdata(dev);
> +       u32 dcamr;
> +
> +       dcamr = __raw_readl(imxdi->ioaddr + DCAMR);
> +       rtc_time_to_tm(dcamr, &alarm->time);
> +
> +       /* alarm is enabled if the interrupt is enabled */
> +       alarm->enabled = (__raw_readl(imxdi->ioaddr + DIER) & DIER_CAIE) != 0;
> +
> +       /* don't allow the DSR read to mess up DSR_WCF */
> +       mutex_lock(&imxdi->write_mutex);
> +
> +       /* alarm is pending if the alarm flag is set */
> +       alarm->pending = (__raw_readl(imxdi->ioaddr + DSR) & DSR_CAF) != 0;
> +
> +       mutex_unlock(&imxdi->write_mutex);
> +
> +       return 0;
> +}
> +
> +/*
> + * set the seconds portion of dryice alarm register
> + */
> +static int dryice_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
> +{
> +       struct imxdi_dev *imxdi = dev_get_drvdata(dev);
> +       unsigned long now;
> +       unsigned long alarm_time;
> +       int rc;
> +
> +       rc = rtc_tm_to_time(&alarm->time, &alarm_time);
> +       if (rc)
> +               return rc;
> +
> +       /* don't allow setting alarm in the past */
> +       now = __raw_readl(imxdi->ioaddr + DTCMR);
> +       if (alarm_time < now)
> +               return -EINVAL;
> +
> +       /* write the new alarm time */
> +       rc = di_write_wait(imxdi, (u32)alarm_time, DCAMR);
> +       if (rc)
> +               return rc;
> +
> +       if (alarm->enabled)
> +               di_int_enable(imxdi, DIER_CAIE);  /* enable alarm intr */
> +       else
> +               di_int_disable(imxdi, DIER_CAIE); /* disable alarm intr */
> +
> +       return 0;
> +}
> +
> +static struct rtc_class_ops dryice_rtc_ops = {
> +       .read_time              = dryice_rtc_read_time,
> +       .set_mmss               = dryice_rtc_set_mmss,
> +       .alarm_irq_enable       = dryice_rtc_alarm_irq_enable,
> +       .read_alarm             = dryice_rtc_read_alarm,
> +       .set_alarm              = dryice_rtc_set_alarm,
> +};
> +
> +/*
> + * dryice "normal" interrupt handler
> + */
> +static irqreturn_t dryice_norm_irq(int irq, void *dev_id)
> +{
> +       struct imxdi_dev *imxdi = dev_id;
> +       u32 dsr, dier;
> +       irqreturn_t rc = IRQ_NONE;
> +
> +       dier = __raw_readl(imxdi->ioaddr + DIER);
> +
> +       /* handle write complete and write error cases */
> +       if ((dier & DIER_WCIE)) {
> +               /*If the write wait queue is empty then there is no pending
> +                 operations. It means the interrupt is for DryIce -Security.
> +                 IRQ must be returned as none.*/
> +               if (list_empty_careful(&imxdi->write_wait.task_list))
> +                       return rc;
> +
> +               /* DSR_WCF clears itself on DSR read */
> +               dsr = __raw_readl(imxdi->ioaddr + DSR);
> +               if ((dsr & (DSR_WCF | DSR_WEF))) {
> +                       /* mask the interrupt */
> +                       di_int_disable(imxdi, DIER_WCIE);
> +
> +                       /* save the dsr value for the wait queue */
> +                       imxdi->dsr |= dsr;
> +
> +                       wake_up_interruptible(&imxdi->write_wait);
> +                       rc = IRQ_HANDLED;
> +               }
> +       }
> +
> +       /* handle the alarm case */
> +       if ((dier & DIER_CAIE)) {
> +               /* DSR_WCF clears itself on DSR read */
> +               dsr = __raw_readl(imxdi->ioaddr + DSR);
> +               if (dsr & DSR_CAF) {
> +                       /* mask the interrupt */
> +                       di_int_disable(imxdi, DIER_CAIE);
> +
> +                       /* finish alarm in user context */
> +                       schedule_work(&imxdi->work);
> +                       rc = IRQ_HANDLED;
> +               }
> +       }
> +       return rc;
> +}
> +
> +/*
> + * post the alarm event from user context so it can sleep
> + * on the write completion.
> + */
> +static void dryice_work(struct work_struct *work)
> +{
> +       struct imxdi_dev *imxdi = container_of(work,
> +                       struct imxdi_dev, work);
> +
> +       /* dismiss the interrupt (ignore error) */
> +       di_write_wait(imxdi, DSR_CAF, DSR);
> +
> +       /*
> +        * pass the alarm event to the rtc framework. note that
> +        * rtc_update_irq expects to be called with interrupts off.
> +        */
> +       local_irq_disable();
> +       rtc_update_irq(imxdi->rtc, 1, RTC_AF | RTC_IRQF);
> +       local_irq_enable();

Are local_irq_disable() and al_irq_enable() necessary?

RTC ‘rtc_update_irq’ seem to have called 'spin_lock_irqsave' , where
local irq will be disable.

> +}
> +
> +/*
> + * probe for dryice rtc device
> + */
> +static int dryice_rtc_probe(struct platform_device *pdev)
> +{
> +       struct resource *res;
> +       struct imxdi_dev *imxdi;
> +       int rc;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res)
> +               return -ENODEV;
> +
> +       imxdi = devm_kzalloc(&pdev->dev, sizeof(*imxdi), GFP_KERNEL);
> +       if (!imxdi)
> +               return -ENOMEM;
> +
> +       imxdi->pdev = pdev;
> +
> +       if (!devm_request_mem_region(&pdev->dev, res->start, resource_size(res),
> +                               pdev->name))
> +               return -EBUSY;
> +
> +       imxdi->ioaddr = devm_ioremap(&pdev->dev, res->start,
> +                       resource_size(res));
> +       if (imxdi->ioaddr == NULL)
> +               return -ENOMEM;
> +
> +       imxdi->irq = platform_get_irq(pdev, 0);
> +       if (imxdi->irq < 0)
> +               return imxdi->irq;
> +
> +       init_waitqueue_head(&imxdi->write_wait);
> +
> +       INIT_WORK(&imxdi->work, dryice_work);
> +
> +       mutex_init(&imxdi->write_mutex);
> +
> +       imxdi->clk = clk_get(&pdev->dev, NULL);
> +       if (IS_ERR(imxdi->clk))
> +               return PTR_ERR(imxdi->clk);
> +       clk_enable(imxdi->clk);
> +
> +       /*
> +        * Initialize dryice hardware
> +        */
> +
> +       /* mask all interrupts */
> +       __raw_writel(0, imxdi->ioaddr + DIER);
> +
> +       rc = devm_request_irq(&pdev->dev, imxdi->irq, dryice_norm_irq,
> +                       IRQF_SHARED, pdev->name, imxdi);
> +       if (rc) {
> +               dev_warn(&pdev->dev, "interrupt not available.\n");
> +               goto err;
> +       }
> +
> +       /* put dryice into valid state */
> +       if (__raw_readl(imxdi->ioaddr + DSR) & DSR_NVF) {
> +               rc = di_write_wait(imxdi, DSR_NVF | DSR_SVF, DSR);
> +               if (rc)
> +                       goto err;
> +       }
> +
> +       /* initialize alarm */
> +       rc = di_write_wait(imxdi, DCAMR_UNSET, DCAMR);
> +       if (rc)
> +               goto err;
> +       rc = di_write_wait(imxdi, 0, DCALR);
> +       if (rc)
> +               goto err;
> +
> +       /* clear alarm flag */
> +       if (__raw_readl(imxdi->ioaddr + DSR) & DSR_CAF) {
> +               rc = di_write_wait(imxdi, DSR_CAF, DSR);
> +               if (rc)
> +                       goto err;
> +       }
> +
> +       /* the timer won't count if it has never been written to */
> +       if (__raw_readl(imxdi->ioaddr + DTCMR) == 0) {
> +               rc = di_write_wait(imxdi, 0, DTCMR);
> +               if (rc)
> +                       goto err;
> +       }
> +
> +       /* start keeping time */
> +       if (!(__raw_readl(imxdi->ioaddr + DCR) & DCR_TCE)) {
> +               rc = di_write_wait(imxdi,
> +                               __raw_readl(imxdi->ioaddr + DCR) | DCR_TCE,
> +                               DCR);
> +               if (rc)
> +                       goto err;
> +       }
> +
> +       imxdi->rtc = rtc_device_register(pdev->name, &pdev->dev,
> +                                 &dryice_rtc_ops, THIS_MODULE);
> +       if (IS_ERR(imxdi->rtc)) {
> +               rc = PTR_ERR(imxdi->rtc);
> +               goto err;
> +       }
> +       platform_set_drvdata(pdev, imxdi);
> +
> +       return 0;
> +
> +err:
> +       clk_disable(imxdi->clk);
> +       clk_put(imxdi->clk);
> +
> +       return rc;
> +}
> +
> +static int __devexit dryice_rtc_remove(struct platform_device *pdev)
> +{
> +       struct imxdi_dev *imxdi = platform_get_drvdata(pdev);
> +
> +       flush_scheduled_work();
> +
> +       /* mask all interrupts */
> +       __raw_writel(0, imxdi->ioaddr + DIER);
> +
> +       rtc_device_unregister(imxdi->rtc);
> +
> +       clk_disable(imxdi->clk);
> +       clk_put(imxdi->clk);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver dryice_rtc_driver = {
> +       .driver = {
> +                  .name = "imxdi_rtc",
> +                  .owner = THIS_MODULE,
> +                  },
> +       .probe = dryice_rtc_probe,
> +       .remove = __devexit_p(dryice_rtc_remove),
> +};
> +
> +static int __init dryice_rtc_init(void)
> +{
> +       return platform_driver_register(&dryice_rtc_driver);

platform_driver_probe will be much better here.

> +}
> +
> +static void __exit dryice_rtc_exit(void)
> +{
> +       platform_driver_unregister(&dryice_rtc_driver);
> +}
> +
> +module_init(dryice_rtc_init);
> +module_exit(dryice_rtc_exit);
> +
> +MODULE_AUTHOR("Freescale Semiconductor, Inc.");
> +MODULE_AUTHOR("Baruch Siach <baruch@tkos.co.il>");
> +MODULE_DESCRIPTION("IMX DryIce Realtime Clock Driver (RTC)");
> +MODULE_LICENSE("GPL");
> --
> 1.7.1
>
> --
> You received this message because you are subscribed to "rtc-linux".
> Membership options at http://groups.google.com/group/rtc-linux .
> Please read http://groups.google.com/group/rtc-linux/web/checklist
> before submitting a driver.



-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com
