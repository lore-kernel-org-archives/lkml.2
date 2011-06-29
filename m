Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1F2M1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:27:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57234 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab1F2M1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:27:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: ashish.jangam@kpitcummins.com
Subject: Re: [PATCH 1/11] MFD: DA9052 MFD core module v1
Date: Wed, 29 Jun 2011 14:27:11 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, sameo@openedhand.com,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        linaro-dev@lists.linaro.org
References: <1309270609.376.226.camel@L-0532.kpit.com>
In-Reply-To: <1309270609.376.226.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291427.11534.arnd@arndb.de>
X-Provags-ID: V02:K0:aEZxYMhZEUl5OrMmnH8nvo+INREKEqgWuIQQiZ7gKCO
 120Rvf14Yx1ukvbP2RJ8Hn9BQBHweIS24DvtXHCtuRbLp3UyYL
 3N840EomLpzQ5VQAB2gdIZ3BbJi/pvzQBIbTIvvbnd/AwO4iea
 9pjJlrNMt48KNRpS8RlPSHBWY1L/tI6t3LFxKzz1R+eKkEDnqd
 riN6BRPsqw4txCJ7wvLGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 June 2011, ashishj3 wrote:
> The DA9052 is a highly integrated PMIC subsystem with supply domain flexibility
> to support wide range of high performance application.
> 
> It provides voltage regulators, GPIO controller, Touch Screen, RTC, Battery
> control and other functionality.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>

Hi Ashish and Dajun,

As we discussed last time, I think it would be important to lay out the
drivers in a way that also works with the da9053 chip that has recently
been submitted in another thread.

This does not mean that you have to support both from the start, but
I would expect you to look at the differences and for each file decide
whether they are completely different (e.g. one of them has backlight,
the other one doesn't) or similar enough to be handled by one driver
with a few conditional functions. My guess is that the da9052-core.c
file would be different for each chip, while both the front-end
(spi, i2c) and the back-end drivers (hwmon, backlight, regulator, ...)
can be shared.

Please rename the files and the identifiers accordingly, and document
in the changelog which hardware they can eventually support.
I would expect a lot of the identfiers to become da905x or even
da90xx.

The submission format looks a lot better than last time, I saw that
you now have a proper changelog text for each patch. Please always
also send a [PATCH 0/11] introductory email that lists broadly what
you have changed since the previous submission, and make all the
patches a reply to the introductory email to allow grouping them
in email clients. The easiest way to do that is using 'git send-email
--thread --no-chain-reply'.

> +struct da9052_irq_data {
> +	int mask;
> +	int offset;
> +};
> +
> +static struct da9052_irq_data da9052_irqs[] = {
> +	[DA9052_IRQ_DCIN]	= {0x01, 0},
> +	[DA9052_IRQ_VBUS]	= {0x02, 0},
> +	[DA9052_IRQ_DCINREM]	= {0x04, 0},
> +	[DA9052_IRQ_VBUSREM]	= {0x08, 0},
> +	[DA9052_IRQ_VDDLOW]	= {0x10, 0},

Sorry for being unclear the last time we discussed this. After I went
back and forth on this table with Mark, IIRC the outcome was that
the entire table should be dropped and you just replace the
table lookup with a computation in the user

> +int da9052_commit_mask(struct da9052 *da9052, int offset)
> +{
> +	uint8_t v;
> +
> +	v = (da9052->events_mask >> (offset * 8)) & 0xff;
> +
> +	return da9052_reg_write(da9052, DA9052_IRQ_MASK_A_REG + offset, v);
> +}
> +
> +static inline struct da9052_irq_data *irq_to_da9052_irq(struct da9052 *da9052,
> +							 int irq)
> +{
> +	return &da9052_irqs[irq - da9052->irq_base];
> +}
> +
> ...
> +static void da9052_irq_sync_unlock(struct irq_data *data)
> +{
> +	struct da9052 *da9052 = irq_data_get_irq_chip_data(data);
> +	struct da9052_irq_data *irq_data = irq_to_da9052_irq(da9052, data->irq);
> +
> +	da9052_commit_mask(da9052, irq_data->offset);
> +	mutex_unlock(&da9052->irq_lock);
> +}

This would be combined into 

static void da9052_irq_sync_unlock(struct irq_data *data)
{
	struct da9052 *da9052 = irq_data_get_irq_chip_data(data);
	unsigned int offset, v;

	offset = (data->irq - da9052->irq_base) / 8;
	v = (da9052->events_mask >> (offset * 8)) & 0xff;
	da9052_reg_write(da9052, DA9052_IRQ_MASK_A_REG + offset, v);

	mutex_unlock(&da9052->irq_lock);
}

> +static void da9052_irq_unmask(struct irq_data *data)
> +{
> +	struct da9052 *da9052 = irq_data_get_irq_chip_data(data);
> +	struct da9052_irq_data *irq_data = irq_to_da9052_irq(da9052, data->irq);
> +
> +	da9052->events_mask &= ~irq_data->mask;
> +}
> +
> +static void da9052_irq_mask(struct irq_data *data)
> +{
> +	struct da9052 *da9052 = irq_data_get_irq_chip_data(data);
> +	struct da9052_irq_data *irq_data = irq_to_da9052_irq(da9052, data->irq);
> +
> +	da9052->events_mask |= irq_data->mask;
> +}

And these into
	da9052->events_mask |= ((data->irq - da9052->irq_base) & 0xff);
> +/*
> + * TBAT look-up table is computed from the R90 reg (8 bit register)
> + * reading as below. The temperature is in milliCentigrade
> + * TBAT = (1/(t1+1/298) - 273) * 1000 mC
> + * where t1 = (1/B)* ln(( ADCval * 2.5)/(R25*ITBAT*255))
> + * Default values are R25 = 10e3, B = 3380, ITBAT = 50e-6
> + * Example:
> + * R25=10E3, B=3380, ITBAT=50e-6, ADCVAL=62d calculates
> + * TBAT = 20015 milidegree Centrigrade
> +*/
> +static const int32_t tbat_lookup[255] = {
> +	183258, 144221, 124334, 111336, 101826, 94397, 88343, 83257,
> +	78889, 75071, 71688, 68656, 65914, 63414, 61120, 59001,
> +	570366, 55204, 53490, 51881, 50364, 48931, 47574, 46285,
> +	45059, 43889, 42772, 41703, 40678, 39694, 38748, 37838,

Please move this table into drivers/mfd/da9052-core.c, you should
never have statically defined symbols in a header, because that will
duplicate them into every file that includes the header.

	Arnd
