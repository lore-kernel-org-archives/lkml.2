Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab1FVMm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 08:42:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37516 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1FVMm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 08:42:27 -0400
Date: Wed, 22 Jun 2011 13:42:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: Add S5M8751 register definitions
Message-ID: <20110622124222.GC23666@sirena.org.uk>
References: <1308722037-6966-1-git-send-email-sbkim73@samsung.com> <1308722037-6966-2-git-send-email-sbkim73@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308722037-6966-2-git-send-email-sbkim73@samsung.com>
X-Cookie: Is it clean in other dimensions?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 02:53:55PM +0900, Sangbeom Kim wrote:
> This patch add S5M8751 PMIC register definitions.
> Separated as large code size

These don't look like register definitions:

> +struct s5m8751;
> +
> +struct s5m8751_irq {
> +	void (*handler) (struct s5m8751 *, int, void *);
> +	void *data;
> +};
> +
> +struct s5m8751 {
> +	struct device *dev;
> +
> +	/* device IO */
> +	struct i2c_client *i2c_client;
> +
> +	int (*read_dev)(struct s5m8751 *s5m8751, uint8_t reg, uint8_t *val);
> +	int (*write_dev)(struct s5m8751 *s5m8751, uint8_t reg, uint8_t val);
> +
> +	int (*read_block_dev)(struct s5m8751 *s5m8751, uint8_t reg, int len,
> +							uint8_t *val);
> +	int (*write_block_dev)(struct s5m8751 *s5m8751, uint8_t reg, int len,
> +							uint8_t *val);
> +	u8 *reg_cache;
> +
> +	/* Interrupt handling */
> +	struct work_struct irq_work;
> +	struct mutex irq_mutex; /* IRQ table mutex */
> +	struct s5m8751_irq irq[S5M8751_NUM_IRQ];
> +	int chip_irq;
> +
> +	/* Client devices */
> +};

> +/* S5M8751 Device IO */
> +int s5m8751_clear_bits(struct s5m8751 *s5m8751, uint8_t reg, uint8_t mask);
> +int s5m8751_set_bits(struct s5m8751 *s5m8751, uint8_t reg, uint8_t mask);
> +int s5m8751_reg_read(struct s5m8751 *s5m8751, uint8_t reg, uint8_t *val);
> +int s5m8751_reg_write(struct s5m8751 *s5m8751, uint8_t reg, uint8_t val);
> +int s5m8751_block_read(struct s5m8751 *s5m8751, uint8_t reg, int len,
> +							uint8_t *val);
> +int s5m8751_block_write(struct s5m8751 *s5m8751, uint8_t reg, int len,
> +							uint8_t *val);

I posted a series earlier this week which adds a generic API for
handling register maps on I2C/SPI devices - I'll post another version of
it shortly, it'd be nice if you could loook to see if this is usable for
you.

> +/* S5M8751 internal interrupts */
> +int s5m8751_register_irq(struct s5m8751 *s5m8751, int irq,
> +			void (*handler) (struct s5m8751 *, int, void *),
> +			void *data);
> +
> +int s5m8751_free_irq(struct s5m8751 *s5m8751, int irq);
> +int s5m8751_mask_irq(struct s5m8751 *s5m8751, int irq);
> +int s5m8751_unmask_irq(struct s5m8751 *s5m8751, int irq);
> +int s5m8751_clear_irq(struct s5m8751 *s5m8751);

You should use genirq for this, it's supported this for quite some time
now.  There's quite a few MFDs doing this which you can used for
examples.

> +/* S5M8751 sysfs functions */
> +int s5m8751_uvlo_get(struct s5m8751 *s5m8751);
> +int s5m8751_uvlo_set(struct s5m8751 *s5m8751, int voltage);
> +
> +int s5m8751_audio_dev_register(struct s5m8751 *s5m8751,
> +						const char *name,
> +						struct platform_device **pdev);

These shouldn't need to be in the header.
