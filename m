Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab0KRUAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:00:00 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46007 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab0KRT77 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:59:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pHiWtHbm/MFqKj5vh4Qey9zT7PXquer8yBfFqyzt9tm6QDHbiTrUHZkbTzFTXksQeZ
         ZbLlQSl4535AYpC1kErn35RWenAad//H9kzdyvPeE2Vn/cUkwHcXnOV1pBW3E1+UGaZP
         1MOYFdh4GHEIUWtuqIIzzATE7hpo5QEkaV0YQ=
MIME-Version: 1.0
In-Reply-To: <1290109970-26752-2-git-send-email-gbean@codeaurora.org>
References: <1290109970-26752-1-git-send-email-gbean@codeaurora.org>
	<1290109970-26752-2-git-send-email-gbean@codeaurora.org>
Date: Thu, 18 Nov 2010 11:59:56 -0800
Message-ID: <AANLkTimTsyhjHJZggFO31C-2RswpmKWn-V4pGEiQ3+_2@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] msm: gpio: Add irq support to v2 gpiolib.
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: Gregory Bean <gbean@codeaurora.org>
Cc: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:52 AM, Gregory Bean <gbean@codeaurora.org> wrote:
> Complete the MSM v2 gpio subsystem by adding irq_chip.
>
> Signed-off-by: Gregory Bean <gbean@codeaurora.org>
> ---
>  v4 - miscellaneous cleanup to patch 1/2, per pkondeti@codeaurora.org
>  v3 - miscellaneous cleanup to patch 1/2, per baruch@tkos.co.il
>  v2 - miscellaneous cleanup to patch 1/2, per baruch@tkos.co.il
>
>  arch/arm/mach-msm/gpio-v2.c |  344 ++++++++++++++++++++++++++++++++++++++++---
[Ram] Do you mean to MSM have v1 and v2 gpio hardware ??? can not we
have one file under mach-msm as gpio.c??
>  1 files changed, 326 insertions(+), 18 deletions(-)
>
> diff --git a/arch/arm/mach-msm/gpio-v2.c b/arch/arm/mach-msm/gpio-v2.c
> index d907af6..926e3d0 100644
> --- a/arch/arm/mach-msm/gpio-v2.c
> +++ b/arch/arm/mach-msm/gpio-v2.c
> @@ -15,7 +15,11 @@
>  * 02110-1301, USA.
>  *
>  */
> +#include <linux/bitmap.h>
> +#include <linux/bitops.h>
>  #include <linux/gpio.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/irq.h>
>  #include <linux/module.h>
> @@ -31,17 +35,97 @@ enum {
>        GPIO_OUT_BIT = 1
>  };
>
> +/* Bits of interest in the GPIO_INTR_STATUS register.
> + */
> +enum {
> +       INTR_STATUS_BIT = 0,
> +};
> +
>  /* Bits of interest in the GPIO_CFG register.
>  */
>  enum {
>        GPIO_OE_BIT = 9,
>  };
>
> +/* Bits of interest in the GPIO_INTR_CFG register.
> + */
> +enum {
> +       INTR_ENABLE_BIT        = 0,
> +       INTR_POL_CTL_BIT       = 1,
> +       INTR_DECT_CTL_BIT      = 2,
> +       INTR_RAW_STATUS_EN_BIT = 3,
> +};
> +
> +/* Codes of interest in GPIO_INTR_CFG_SU.
> + */
> +enum {
> +       TARGET_PROC_SCORPION = 4,
> +       TARGET_PROC_NONE     = 7,
> +};
> +
> +/*
> + * When a GPIO triggers, two separate decisions are made, controlled
> + * by two separate flags.
> + *
> + * - First, INTR_RAW_STATUS_EN controls whether or not the GPIO_INTR_STATUS
> + * register for that GPIO will be updated to reflect the triggering of that
> + * gpio.  If this bit is 0, this register will not be updated.
> + * - Second, INTR_ENABLE controls whether an interrupt is triggered.
> + *
> + * If INTR_ENABLE is set and INTR_RAW_STATUS_EN is NOT set, an interrupt
> + * can be triggered but the status register will not reflect it.
> + */
> +#define INTR_RAW_STATUS_EN BIT(INTR_RAW_STATUS_EN_BIT)
> +#define INTR_ENABLE        BIT(INTR_ENABLE_BIT)
> +#define INTR_DECT_CTL_EDGE BIT(INTR_DECT_CTL_BIT)
> +#define INTR_POL_CTL_HI    BIT(INTR_POL_CTL_BIT)
> +
> +#define GPIO_INTR_CFG_SU(gpio)    (MSM_TLMM_BASE + 0x0400 + (0x04 * (gpio)))
>  #define GPIO_CONFIG(gpio)         (MSM_TLMM_BASE + 0x1000 + (0x10 * (gpio)))
>  #define GPIO_IN_OUT(gpio)         (MSM_TLMM_BASE + 0x1004 + (0x10 * (gpio)))
> +#define GPIO_INTR_CFG(gpio)       (MSM_TLMM_BASE + 0x1008 + (0x10 * (gpio)))
> +#define GPIO_INTR_STATUS(gpio)    (MSM_TLMM_BASE + 0x100c + (0x10 * (gpio)))
> +
> +/**
> + * struct msm_gpio_dev: the MSM8660 SoC GPIO device structure
> + *
> + * @enabled_irqs: a bitmap used to optimize the summary-irq handler.  By
> + * keeping track of which gpios are unmasked as irq sources, we avoid
> + * having to do readl calls on hundreds of iomapped registers each time
> + * the summary interrupt fires in order to locate the active interrupts.
> + *
> + * @wake_irqs: a bitmap for tracking which interrupt lines are enabled
> + * as wakeup sources.  When the device is suspended, interrupts which are
> + * not wakeup sources are disabled.
> + *
> + * @dual_edge_irqs: a bitmap used to track which irqs are configured
> + * as dual-edge, as this is not supported by the hardware and requires
> + * some special handling in the driver.
> + */
> +struct msm_gpio_dev {
> +       struct gpio_chip gpio_chip;
> +       DECLARE_BITMAP(enabled_irqs, NR_GPIO_IRQS);
> +       DECLARE_BITMAP(wake_irqs, NR_GPIO_IRQS);
> +       DECLARE_BITMAP(dual_edge_irqs, NR_GPIO_IRQS);
> +};
>
>  static DEFINE_SPINLOCK(tlmm_lock);
>
> +static inline struct msm_gpio_dev *to_msm_gpio_dev(struct gpio_chip *chip)
> +{
> +       return container_of(chip, struct msm_gpio_dev, gpio_chip);
> +}
> +
> +static inline void set_gpio_bits(unsigned n, void __iomem *reg)
> +{
> +       writel(readl(reg) | n, reg);
> +}
> +
> +static inline void clr_gpio_bits(unsigned n, void __iomem *reg)
> +{
> +       writel(readl(reg) & ~n, reg);
> +}
> +
>  static int msm_gpio_get(struct gpio_chip *chip, unsigned offset)
>  {
>        return readl(GPIO_IN_OUT(offset)) & BIT(GPIO_IN_BIT);
> @@ -57,8 +141,7 @@ static int msm_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
>        unsigned long irq_flags;
>
>        spin_lock_irqsave(&tlmm_lock, irq_flags);
> -       writel(readl(GPIO_CONFIG(offset)) & ~BIT(GPIO_OE_BIT),
> -               GPIO_CONFIG(offset));
> +       clr_gpio_bits(BIT(GPIO_OE_BIT), GPIO_CONFIG(offset));
>        spin_unlock_irqrestore(&tlmm_lock, irq_flags);
>        return 0;
>  }
> @@ -71,8 +154,7 @@ static int msm_gpio_direction_output(struct gpio_chip *chip,
>
>        spin_lock_irqsave(&tlmm_lock, irq_flags);
>        msm_gpio_set(chip, offset, val);
> -       writel(readl(GPIO_CONFIG(offset)) | BIT(GPIO_OE_BIT),
> -               GPIO_CONFIG(offset));
> +       set_gpio_bits(BIT(GPIO_OE_BIT), GPIO_CONFIG(offset));
>        spin_unlock_irqrestore(&tlmm_lock, irq_flags);
>        return 0;
>  }
> @@ -87,30 +169,215 @@ static void msm_gpio_free(struct gpio_chip *chip, unsigned offset)
>        msm_gpiomux_put(chip->base + offset);
>  }
>
> -static struct gpio_chip msm_gpio = {
> -       .base             = 0,
> -       .ngpio            = NR_GPIO_IRQS,
> -       .direction_input  = msm_gpio_direction_input,
> -       .direction_output = msm_gpio_direction_output,
> -       .get              = msm_gpio_get,
> -       .set              = msm_gpio_set,
> -       .request          = msm_gpio_request,
> -       .free             = msm_gpio_free,
> +static int msm_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> +{
> +       return MSM_GPIO_TO_INT(offset - chip->base);
> +}
> +
> +static inline int msm_irq_to_gpio(struct gpio_chip *chip, unsigned irq)
> +{
> +       return irq - MSM_GPIO_TO_INT(chip->base);
> +}
> +
> +static struct msm_gpio_dev msm_gpio = {
> +       .gpio_chip = {
> +               .base             = 0,
> +               .ngpio            = NR_GPIO_IRQS,
> +               .direction_input  = msm_gpio_direction_input,
> +               .direction_output = msm_gpio_direction_output,
> +               .get              = msm_gpio_get,
> +               .set              = msm_gpio_set,
> +               .to_irq           = msm_gpio_to_irq,
> +               .request          = msm_gpio_request,
> +               .free             = msm_gpio_free,
> +       },
> +};
> +
> +/* For dual-edge interrupts in software, since the hardware has no
> + * such support:
> + *
> + * At appropriate moments, this function may be called to flip the polarity
> + * settings of both-edge irq lines to try and catch the next edge.
> + *
> + * The attempt is considered successful if:
> + * - the status bit goes high, indicating that an edge was caught, or
> + * - the input value of the gpio doesn't change during the attempt.
> + * If the value changes twice during the process, that would cause the first
> + * test to fail but would force the second, as two opposite
> + * transitions would cause a detection no matter the polarity setting.
> + *
> + * The do-loop tries to sledge-hammer closed the timing hole between
> + * the initial value-read and the polarity-write - if the line value changes
> + * during that window, an interrupt is lost, the new polarity setting is
> + * incorrect, and the first success test will fail, causing a retry.
> + *
> + * Algorithm comes from Google's msmgpio driver, see mach-msm/gpio.c.
> + */
> +static void msm_gpio_update_dual_edge_pos(unsigned gpio)
> +{
> +       int loop_limit = 100;
> +       unsigned val, val2, intstat;
> +
> +       do {
> +               val = readl(GPIO_IN_OUT(gpio)) & BIT(GPIO_IN_BIT);
> +               if (val)
> +                       clr_gpio_bits(INTR_POL_CTL_HI, GPIO_INTR_CFG(gpio));
> +               else
> +                       set_gpio_bits(INTR_POL_CTL_HI, GPIO_INTR_CFG(gpio));
> +               val2 = readl(GPIO_IN_OUT(gpio)) & BIT(GPIO_IN_BIT);
> +               intstat = readl(GPIO_INTR_STATUS(gpio)) & BIT(INTR_STATUS_BIT);
> +               if (intstat || val == val2)
> +                       return;
> +       } while (loop_limit-- > 0);
> +       pr_err("%s: dual-edge irq failed to stabilize, "
> +              "interrupts dropped. %#08x != %#08x\n",
> +              __func__, val, val2);
> +}
> +
> +static void msm_gpio_irq_ack(unsigned int irq)
> +{
> +       int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, irq);
> +
> +       writel(BIT(INTR_STATUS_BIT), GPIO_INTR_STATUS(gpio));
> +       if (test_bit(gpio, msm_gpio.dual_edge_irqs))
> +               msm_gpio_update_dual_edge_pos(gpio);
> +}
> +
> +static void msm_gpio_irq_mask(unsigned int irq)
> +{
> +       int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, irq);
> +       unsigned long irq_flags;
> +
> +       spin_lock_irqsave(&tlmm_lock, irq_flags);
> +       writel(TARGET_PROC_NONE, GPIO_INTR_CFG_SU(gpio));
> +       clr_gpio_bits(INTR_RAW_STATUS_EN | INTR_ENABLE, GPIO_INTR_CFG(gpio));
> +       __clear_bit(gpio, msm_gpio.enabled_irqs);
> +       spin_unlock_irqrestore(&tlmm_lock, irq_flags);
> +}
> +
> +static void msm_gpio_irq_unmask(unsigned int irq)
> +{
> +       int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, irq);
> +       unsigned long irq_flags;
> +
> +       spin_lock_irqsave(&tlmm_lock, irq_flags);
> +       __set_bit(gpio, msm_gpio.enabled_irqs);
> +       set_gpio_bits(INTR_RAW_STATUS_EN | INTR_ENABLE, GPIO_INTR_CFG(gpio));
> +       writel(TARGET_PROC_SCORPION, GPIO_INTR_CFG_SU(gpio));
> +       spin_unlock_irqrestore(&tlmm_lock, irq_flags);
> +}
> +
> +static int msm_gpio_irq_set_type(unsigned int irq, unsigned int flow_type)
> +{
> +       int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, irq);
> +       unsigned long irq_flags;
> +       uint32_t bits;
> +
> +       spin_lock_irqsave(&tlmm_lock, irq_flags);
> +
> +       bits = readl(GPIO_INTR_CFG(gpio));
> +
> +       if (flow_type & IRQ_TYPE_EDGE_BOTH) {
> +               bits |= INTR_DECT_CTL_EDGE;
> +               irq_desc[irq].handle_irq = handle_edge_irq;
> +               if ((flow_type & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH)
> +                       __set_bit(gpio, msm_gpio.dual_edge_irqs);
> +               else
> +                       __clear_bit(gpio, msm_gpio.dual_edge_irqs);
> +       } else {
> +               bits &= ~INTR_DECT_CTL_EDGE;
> +               irq_desc[irq].handle_irq = handle_level_irq;
> +               __clear_bit(gpio, msm_gpio.dual_edge_irqs);
> +       }
> +
> +       if (flow_type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_LEVEL_HIGH))
> +               bits |= INTR_POL_CTL_HI;
> +       else
> +               bits &= ~INTR_POL_CTL_HI;
> +
> +       writel(bits, GPIO_INTR_CFG(gpio));
> +
> +       if ((flow_type & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH)
> +               msm_gpio_update_dual_edge_pos(gpio);
> +
> +       spin_unlock_irqrestore(&tlmm_lock, irq_flags);
> +
> +       return 0;
> +}
> +
> +/*
> + * When the summary IRQ is raised, any number of GPIO lines may be high.
> + * It is the job of the summary handler to find all those GPIO lines
> + * which have been set as summary IRQ lines and which are triggered,
> + * and to call their interrupt handlers.
> + */
> +static void msm_summary_irq_handler(unsigned int irq, struct irq_desc *desc)
> +{
> +       unsigned long i;
> +
> +       for (i = find_first_bit(msm_gpio.enabled_irqs, NR_GPIO_IRQS);
> +            i < NR_GPIO_IRQS;
> +            i = find_next_bit(msm_gpio.enabled_irqs, NR_GPIO_IRQS, i + 1)) {
> +               if (readl(GPIO_INTR_STATUS(i)) & BIT(INTR_STATUS_BIT))
> +                       generic_handle_irq(msm_gpio_to_irq(&msm_gpio.gpio_chip,
> +                                                          i));
> +       }
> +       desc->chip->ack(irq);
> +}
> +
> +static int msm_gpio_irq_set_wake(unsigned int irq, unsigned int on)
> +{
> +       int gpio = msm_irq_to_gpio(&msm_gpio.gpio_chip, irq);
> +
> +       if (on) {
> +               if (bitmap_empty(msm_gpio.wake_irqs, NR_GPIO_IRQS))
> +                       set_irq_wake(TLMM_SCSS_SUMMARY_IRQ, 1);
> +               set_bit(gpio, msm_gpio.wake_irqs);
> +       } else {
> +               clear_bit(gpio, msm_gpio.wake_irqs);
> +               if (bitmap_empty(msm_gpio.wake_irqs, NR_GPIO_IRQS))
> +                       set_irq_wake(TLMM_SCSS_SUMMARY_IRQ, 0);
> +       }
> +
> +       return 0;
> +}
> +
> +static struct irq_chip msm_gpio_irq_chip = {
> +       .name           = "msmgpio",
> +       .mask           = msm_gpio_irq_mask,
> +       .unmask         = msm_gpio_irq_unmask,
> +       .ack            = msm_gpio_irq_ack,
> +       .set_type       = msm_gpio_irq_set_type,
> +       .set_wake       = msm_gpio_irq_set_wake,
>  };
>
>  static int __devinit msm_gpio_probe(struct platform_device *dev)
>  {
> -       int ret;
> +       int i, irq, ret;
>
> -       msm_gpio.label = dev->name;
> -       ret = gpiochip_add(&msm_gpio);
> +       bitmap_zero(msm_gpio.enabled_irqs, NR_GPIO_IRQS);
> +       bitmap_zero(msm_gpio.wake_irqs, NR_GPIO_IRQS);
> +       bitmap_zero(msm_gpio.dual_edge_irqs, NR_GPIO_IRQS);
> +       msm_gpio.gpio_chip.label = dev->name;
> +       ret = gpiochip_add(&msm_gpio.gpio_chip);
> +       if (ret < 0)
> +               return ret;
>
> -       return ret;
> +       for (i = 0; i < msm_gpio.gpio_chip.ngpio; ++i) {
> +               irq = msm_gpio_to_irq(&msm_gpio.gpio_chip, i);
> +               set_irq_chip(irq, &msm_gpio_irq_chip);
> +               set_irq_handler(irq, handle_level_irq);
> +               set_irq_flags(irq, IRQF_VALID);
> +       }
> +
> +       set_irq_chained_handler(TLMM_SCSS_SUMMARY_IRQ,
> +                               msm_summary_irq_handler);
> +       return 0;
>  }
>
>  static int __devexit msm_gpio_remove(struct platform_device *dev)
>  {
> -       int ret = gpiochip_remove(&msm_gpio);
> +       int ret = gpiochip_remove(&msm_gpio.gpio_chip);
>
>        if (ret < 0)
>                return ret;
> @@ -120,12 +387,53 @@ static int __devexit msm_gpio_remove(struct platform_device *dev)
>        return 0;
>  }
>
> +#ifdef CONFIG_PM
> +static int msm_gpio_suspend_noirq(struct device *dev)
> +{
> +       unsigned long irq_flags;
> +       unsigned long i;
> +
> +       spin_lock_irqsave(&tlmm_lock, irq_flags);
> +       for_each_set_bit(i, msm_gpio.enabled_irqs, NR_GPIO_IRQS) {
> +               if (!test_bit(i, msm_gpio.wake_irqs))
> +                       writel(TARGET_PROC_NONE, GPIO_INTR_CFG_SU(i));
> +       }
> +       spin_unlock_irqrestore(&tlmm_lock, irq_flags);
> +       return 0;
> +}
> +
> +static int msm_gpio_resume_noirq(struct device *dev)
> +{
> +       unsigned long irq_flags;
> +       unsigned long i;
> +
> +       spin_lock_irqsave(&tlmm_lock, irq_flags);
> +       for_each_set_bit(i, msm_gpio.enabled_irqs, NR_GPIO_IRQS)
> +               writel(TARGET_PROC_SCORPION, GPIO_INTR_CFG_SU(i));
> +       spin_unlock_irqrestore(&tlmm_lock, irq_flags);
> +       return 0;
> +}
> +#else
> +#define msm_gpio_suspend_noirq NULL
> +#define msm_gpio_resume_noirq NULL
> +#endif
> +
> +static const struct dev_pm_ops msm_gpio_dev_pm_ops = {
> +       .suspend_noirq  = msm_gpio_suspend_noirq,
> +       .resume_noirq   = msm_gpio_resume_noirq,
> +       .freeze_noirq   = msm_gpio_suspend_noirq,
> +       .thaw_noirq     = msm_gpio_resume_noirq,
> +       .poweroff_noirq = msm_gpio_suspend_noirq,
> +       .restore_noirq  = msm_gpio_resume_noirq,
> +};
> +
>  static struct platform_driver msm_gpio_driver = {
>        .probe = msm_gpio_probe,
>        .remove = __devexit_p(msm_gpio_remove),
>        .driver = {
>                .name = "msmgpio",
>                .owner = THIS_MODULE,
> +               .pm = &msm_gpio_dev_pm_ops,
>        },
>  };
>
> --
> 1.7.0.4
>
> --
> Employee of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
