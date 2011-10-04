Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab1JDQHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:07:37 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33315 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab1JDQHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:07:36 -0400
Date: Tue, 4 Oct 2011 10:07:31 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH 3/3] gpio-ml-ioh: Fix suspend/resume issue
Message-ID: <20111004160731.GA9084@ponder.secretlab.ca>
References: <1312517062-5582-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1312517062-5582-3-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312517062-5582-3-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 01:04:22PM +0900, Tomoya MORINAGA wrote:
> Currently, some registers are not saved in case changing to suspend state.
> This patch fixes the issue.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Can this one be merged without 1/3 and 2/3?  Patch 2 looks like a
feature instead of a bug fix.

g.

> ---
>  drivers/gpio/gpio-ml-ioh.c |   60 +++++++++++++++++++++++++++++++++++---------
>  1 files changed, 48 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
> index 4fab37b..274fd4d 100644
> --- a/drivers/gpio/gpio-ml-ioh.c
> +++ b/drivers/gpio/gpio-ml-ioh.c
> @@ -63,6 +63,7 @@ struct ioh_regs {
>   * @pm_reg:	To store contents of PM register.
>   * @im0_reg:	To store contents of interrupt mode regist0
>   * @im1_reg:	To store contents of interrupt mode regist1
> + * @use_sel_reg: To store contents of GPIO_USE_SEL0~3
>   */
>  struct ioh_gpio_reg_data {
>  	u32 ien_reg;
> @@ -71,6 +72,7 @@ struct ioh_gpio_reg_data {
>  	u32 pm_reg;
>  	u32 im0_reg;
>  	u32 im1_reg;
> +	u32 use_sel_reg;
>  };
>  
>  /**
> @@ -81,6 +83,7 @@ struct ioh_gpio_reg_data {
>   * @gpio:			Data for GPIO infrastructure.
>   * @ioh_gpio_reg:		Memory mapped Register data is saved here
>   *				when suspend.
> + * @gpio_use_sel:		Save GPIO_USE_SEL1~4 register for PM
>   * @ch:				Indicate GPIO channel
>   * @irq_base:		Save base of IRQ number for interrupt
>   * @spinlock:		Used for register access protection in
> @@ -92,6 +95,7 @@ struct ioh_gpio {
>  	struct device *dev;
>  	struct gpio_chip gpio;
>  	struct ioh_gpio_reg_data ioh_gpio_reg;
> +	u32 gpio_use_sel;
>  	struct mutex lock;
>  	int ch;
>  	int irq_base;
> @@ -169,12 +173,25 @@ static int ioh_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
>   */
>  static void ioh_gpio_save_reg_conf(struct ioh_gpio *chip)
>  {
> -	chip->ioh_gpio_reg.po_reg = ioread32(&chip->reg->regs[chip->ch].po);
> -	chip->ioh_gpio_reg.pm_reg = ioread32(&chip->reg->regs[chip->ch].pm);
> -	chip->ioh_gpio_reg.ien_reg = ioread32(&chip->reg->regs[chip->ch].ien);
> -	chip->ioh_gpio_reg.imask_reg = ioread32(&chip->reg->regs[chip->ch].imask);
> -	chip->ioh_gpio_reg.im0_reg = ioread32(&chip->reg->regs[chip->ch].im_0);
> -	chip->ioh_gpio_reg.im1_reg = ioread32(&chip->reg->regs[chip->ch].im_1);
> +	int i;
> +
> +	for (i = 0; i < 8; i ++, chip++) {
> +		chip->ioh_gpio_reg.po_reg =
> +					ioread32(&chip->reg->regs[chip->ch].po);
> +		chip->ioh_gpio_reg.pm_reg =
> +					ioread32(&chip->reg->regs[chip->ch].pm);
> +		chip->ioh_gpio_reg.ien_reg =
> +				       ioread32(&chip->reg->regs[chip->ch].ien);
> +		chip->ioh_gpio_reg.imask_reg =
> +				     ioread32(&chip->reg->regs[chip->ch].imask);
> +		chip->ioh_gpio_reg.im0_reg =
> +				      ioread32(&chip->reg->regs[chip->ch].im_0);
> +		chip->ioh_gpio_reg.im1_reg =
> +				      ioread32(&chip->reg->regs[chip->ch].im_1);
> +		if (i < 4)
> +			chip->ioh_gpio_reg.use_sel_reg =
> +					   ioread32(&chip->reg->ioh_sel_reg[i]);
> +	}
>  }
>  
>  /*
> @@ -182,12 +199,25 @@ static void ioh_gpio_save_reg_conf(struct ioh_gpio *chip)
>   */
>  static void ioh_gpio_restore_reg_conf(struct ioh_gpio *chip)
>  {
> -	iowrite32(chip->ioh_gpio_reg.po_reg, &chip->reg->regs[chip->ch].po);
> -	iowrite32(chip->ioh_gpio_reg.pm_reg, &chip->reg->regs[chip->ch].pm);
> -	iowrite32(chip->ioh_gpio_reg.ien_reg, &chip->reg->regs[chip->ch].ien);
> -	iowrite32(chip->ioh_gpio_reg.imask_reg, &chip->reg->regs[chip->ch].imask);
> -	iowrite32(chip->ioh_gpio_reg.im0_reg, &chip->reg->regs[chip->ch].im_0);
> -	iowrite32(chip->ioh_gpio_reg.im1_reg, &chip->reg->regs[chip->ch].im_1);
> +	int i;
> +
> +	for (i = 0; i < 8; i ++, chip++) {
> +		iowrite32(chip->ioh_gpio_reg.po_reg,
> +			  &chip->reg->regs[chip->ch].po);
> +		iowrite32(chip->ioh_gpio_reg.pm_reg,
> +			  &chip->reg->regs[chip->ch].pm);
> +		iowrite32(chip->ioh_gpio_reg.ien_reg,
> +			  &chip->reg->regs[chip->ch].ien);
> +		iowrite32(chip->ioh_gpio_reg.imask_reg,
> +			  &chip->reg->regs[chip->ch].imask);
> +		iowrite32(chip->ioh_gpio_reg.im0_reg,
> +			  &chip->reg->regs[chip->ch].im_0);
> +		iowrite32(chip->ioh_gpio_reg.im1_reg,
> +			  &chip->reg->regs[chip->ch].im_1);
> +		if (i < 4)
> +			iowrite32(chip->ioh_gpio_reg.use_sel_reg,
> +				  &chip->reg->ioh_sel_reg[i]);
> +	}
>  }
>  #endif
>  
> @@ -485,8 +515,11 @@ static int ioh_gpio_suspend(struct pci_dev *pdev, pm_message_t state)
>  {
>  	s32 ret;
>  	struct ioh_gpio *chip = pci_get_drvdata(pdev);
> +	unsigned long flags;
>  
> +	spin_lock_irqsave(&chip->spinlock, flags);
>  	ioh_gpio_save_reg_conf(chip);
> +	spin_unlock_irqrestore(&chip->spinlock, flags);
>  
>  	ret = pci_save_state(pdev);
>  	if (ret) {
> @@ -506,6 +539,7 @@ static int ioh_gpio_resume(struct pci_dev *pdev)
>  {
>  	s32 ret;
>  	struct ioh_gpio *chip = pci_get_drvdata(pdev);
> +	unsigned long flags;
>  
>  	ret = pci_enable_wake(pdev, PCI_D0, 0);
>  
> @@ -517,9 +551,11 @@ static int ioh_gpio_resume(struct pci_dev *pdev)
>  	}
>  	pci_restore_state(pdev);
>  
> +	spin_lock_irqsave(&chip->spinlock, flags);
>  	iowrite32(0x01, &chip->reg->srst);
>  	iowrite32(0x00, &chip->reg->srst);
>  	ioh_gpio_restore_reg_conf(chip);
> +	spin_unlock_irqrestore(&chip->spinlock, flags);
>  
>  	return 0;
>  }
> -- 
> 1.7.4.4
> 
