Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab1CNKLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:11:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:38173 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab1CNKLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:11:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,314,1297065600"; 
   d="scan'208";a="719852904"
Date: Mon, 14 Mar 2011 11:11:18 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: Re: [PATCH 1/2] MAX8997/8966 MFD: Add IRQ control feature
Message-ID: <20110314101117.GB31153@sortiz-mobl>
References: <1299221427-4726-1-git-send-email-myungjoo.ham@samsung.com>
 <1299224747-11081-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299224747-11081-1-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi MyungJoo,

On Fri, Mar 04, 2011 at 04:45:47PM +0900, MyungJoo Ham wrote:
> This patch enables IRQ handling for MAX8997/8966 chips.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Joe's comments make sense. Also, here are my comments:

> +static irqreturn_t max8997_irq_thread(int irq, void *data)
> +{
> +	struct max8997_dev *max8997 = data;
> +	u8 irq_reg[MAX8997_IRQ_GROUP_NR];
> +	u8 irq_src;
> +	int ret;
> +	int i;
> +
> +	ret = max8997_read_reg(max8997->i2c, MAX8997_REG_INTSRC, &irq_src);
> +	if (ret < 0) {
> +		dev_err(max8997->dev, "Failed to read interrupt source: %d\n",
> +				ret);
> +		return IRQ_NONE;
> +	}
> +
> +	for (i = 0; i < MAX8997_IRQ_GROUP_NR; i++)
> +		irq_reg[i] = 0;
> +
> +	if (irq_src & (1 << 1)) {
All the (1 << n) parts could be nicely replaced with relevant #define. That
would make your code more readable.



> +		/* PMIC INT1 ~ INT4 */
> +		max8997_bulk_read(max8997->i2c, MAX8997_REG_INT1, 4,
> +				&irq_reg[PMIC_INT1]);
> +	}
> +	if (irq_src & (1 << 2)) {
> +		/* FUEL GAUGE Interrupt */
> +		/* Ignored */
> +		irq_reg[FUEL_GAUGE] = 0;
> +	}
> +	if (irq_src & (1 << 3)) {
> +		/* MUIC INT1 ~ INT3 */
> +		max8997_bulk_read(max8997->muic, MAX8997_MUIC_REG_INT1, 3,
> +				&irq_reg[MUIC_INT1]);
> +	}
> +	if (irq_src & (1 << 4)) {
> +		/* GPIO Interrupt */
> +		u8 gpio_info[12];
> +		int gpio;
> +
> +		irq_reg[GPIO_LOW] = 0;
> +		irq_reg[GPIO_HI] = 0;
> +
> +		max8997_bulk_read(max8997->i2c, MAX8997_REG_GPIOCNTL1, 12,
> +				gpio_info);
> +		for (gpio = 0; gpio < 8; gpio++) {
> +			u8 val = gpio_info[gpio] & 0x34;
> +			if (((val & 0x30) == 0x30) ||
> +					(val == 0x10) ||
> +					(val == 0x24))
There are a lot of magic constants here, and I'd love to see that replaced as
well with some more descriptive macros.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
