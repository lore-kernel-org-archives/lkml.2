Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1GUPjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 11:39:39 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:52492
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355Ab1GUPji convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 11:39:38 -0400
X-SpamScore: -9
X-BigFish: VS-9(zzc89bh1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 21 Jul 2011 23:46:32 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
CC: <arnd@arndb.de>, Dajun <dajun.chen@diasemi.com>, <sameo@openedhand.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linaro-dev@lists.linaro.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/11] MFD: DA9052 MFD core module v2
Message-ID: <20110721154631.GA26837@S2100-06.ap.freescale.net>
References: <1309876620.960.169.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1309876620.960.169.camel@L-0532.kpit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 08:07:00PM +0530, ashishj3 wrote:
> The DA9052 is a highly integrated PMIC subsystem with supply domain flexibility
> to support wide range of high performance application.
> 
> It provides voltage regulators, GPIO controller, Touch Screen, RTC, Battery
> control and other functionality.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
> Changes since v2:
> - Drop da9052_irqs[] table.
> - Move struct da9052_subdev_info[].
> - Remove initialization of static member.
> - Care for NULL pdata init().
> - Check removal of subdevices on errors.
> - Remove open source spi code.
> - Remove '_spi' from the driver name.
> - Move tbat_lookup table from header file.
> - Remove irq.h 
> - Remove num_gpio variable from pdata
> ---
>  drivers/mfd/Kconfig               |   25 ++
>  drivers/mfd/Makefile              |    7 +
>  drivers/mfd/da9052-core.c         |  539 +++++++++++++++++++++++++
>  drivers/mfd/da9052-i2c.c          |  168 ++++++++
>  drivers/mfd/da9052-irq.c          |  168 ++++++++
>  drivers/mfd/da9052-spi.c          |  132 +++++++
>  include/linux/mfd/da9052/da9052.h |   91 +++++
>  include/linux/mfd/da9052/pdata.h  |   43 ++
>  include/linux/mfd/da9052/reg.h    |  777 +++++++++++++++++++++++++++++++++++++
>  9 files changed, 1950 insertions(+), 0 deletions(-)
>  create mode 100755 drivers/mfd/da9052-core.c
>  create mode 100755 drivers/mfd/da9052-i2c.c
>  create mode 100755 drivers/mfd/da9052-irq.c
>  create mode 100755 drivers/mfd/da9052-spi.c
>  create mode 100755 include/linux/mfd/da9052/da9052.h
>  create mode 100755 include/linux/mfd/da9052/pdata.h
>  create mode 100755 include/linux/mfd/da9052/reg.h

[...]

> +int da9052_reg_update(struct da9052 *da9052, unsigned char reg,
> +		       unsigned char bit_mask, unsigned char reg_val)
> +{
> +	int ret;
> +	unsigned char val;
> +
> +	if (reg > DA9052_MAX_REG_CNT) {
> +		dev_err(da9052->dev, "invalid reg %x\n", reg);
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock_interruptible(&da9052->io_lock);

Compile warning as below.

"warning: ignoring return value of ‘mutex_lock_interruptible’,
declared with attribute warn_unused_result"

> +
> +	if (da9052->read_dev == NULL || da9052->write_dev == NULL) {
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +
> +	ret = da9052->read_dev(da9052, reg, 1, &val);
> +	if (ret < 0)
> +		goto err;
> +
> +	val &= ~bit_mask;
> +	val |= reg_val;
> +
> +	ret = da9052->write_dev(da9052, reg, 1, &val);
> +	if (ret < 0)
> +		goto err;
> +
> +	mutex_unlock(&da9052->io_lock);
> +
> +	return 0;
> +
> +err:
> +	mutex_unlock(&da9052->io_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(da9052_reg_update);
> +
> +int da9052_set_bits(struct da9052 *da9052, unsigned char reg,
> +		     unsigned char bit_mask)
> +{
> +	unsigned char val;
> +	int ret;
> +
> +	if (reg > DA9052_MAX_REG_CNT) {
> +		dev_err(da9052->dev, "invalid reg %x\n", reg);
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock_interruptible(&da9052->io_lock);

ditto

> +
> +	if (da9052->read_dev == NULL || da9052->write_dev == NULL) {
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +
> +	ret = da9052->read_dev(da9052, reg, 1, &val);
> +	if (ret < 0)
> +		goto err;
> +
> +	val |= bit_mask;
> +
> +	ret = da9052->write_dev(da9052, reg, 1, &val);
> +	if (ret < 0)
> +		goto err;
> +
> +	mutex_unlock(&da9052->io_lock);
> +
> +	return 0;
> +
> +err:
> +	mutex_unlock(&da9052->io_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(da9052_set_bits);
> +
> +int da9052_clear_bits(struct da9052 *da9052, unsigned char reg,
> +		       unsigned char bit_mask)
> +{
> +	unsigned char val;
> +	int ret;
> +
> +	if (reg > DA9052_MAX_REG_CNT) {
> +		dev_err(da9052->dev, "invalid reg %x\n", reg);
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock_interruptible(&da9052->io_lock);

ditto

> +
> +	if (da9052->read_dev == NULL || da9052->write_dev == NULL) {
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +
> +	ret = da9052->read_dev(da9052, reg, 1, &val);
> +	if (ret < 0)
> +		goto err;
> +
> +	val &= ~bit_mask;
> +
> +	ret = da9052->write_dev(da9052, reg, 1, &val);
> +	if (ret < 0)
> +		goto err;
> +
> +	mutex_unlock(&da9052->io_lock);
> +
> +	return 0;
> +
> +err:
> +	mutex_unlock(&da9052->io_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(da9052_clear_bits);

[...]

> +static int __devinit da9052_i2c_probe(struct i2c_client *client,
> +				       const struct i2c_device_id *id)
> +{
> +	struct i2c_adapter *adapter;
> +	struct da9052 *da9052_i2c;
> +	int ret;
> +
> +	da9052_i2c = kzalloc(sizeof(struct da9052), GFP_KERNEL);
> +	if (!da9052_i2c)
> +		return -ENOMEM;
> +
> +	adapter = to_i2c_adapter(client->dev.parent);
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
> +		dev_info(&client->dev, "Error in %s:i2c_check_functionality\n",
> +			 __func__);
> +		return -ENODEV;
> +	}
> +
> +	da9052_i2c->i2c_client = client;
> +	da9052_i2c->dev = &client->dev;
> +
> +	i2c_set_clientdata(client, da9052_i2c);
> +
> +	da9052_i2c->write_dev = da9052_i2c_write_device;
> +	da9052_i2c->read_dev = da9052_i2c_read_device;
> +
> +	ret = da9052_i2c_enable_multiwrite(da9052_i2c);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret = da9052_device_init(da9052_i2c)

The semicolon was missed there.

> +	if (ret != 0)
> +		goto err;
> +
> +	return 0;
> +
> +err:
> +	kfree(da9052_i2c);
> +	return ret;
> +}

[...]

> +int da9052_spi_read_device(struct da9052 *da9052, unsigned char reg,
> +			    unsigned bytes, unsigned char *val)
> +{
> +	int ret, raddr;
> +
> +	for (raddr = reg; raddr < reg + bytes; raddr++) {
> +		reg = ((raddr << 1) | da9052->rw_pol);
> +		ret = spi_write_then_read(da9052->spi_dev, (u8 *)&reg, 2,
> +					  val, 2);
> +		if (ret != 0)
> +			return ret;
> +	}
> +
> +	return ret;

warning: ‘ret’ may be used uninitialized in this function

> +}
> +
> +static int da9052_spi_probe(struct spi_device *spi)
> +{
> +	int ret;
> +	struct da9052 *da9052_spi = kzalloc(sizeof(struct da9052), GFP_KERNEL);
> +
> +	if (!da9052_spi)
> +		return -ENOMEM;
> +
> +	spi->mode = SPI_MODE_0 | SPI_CPOL;
> +	spi->bits_per_word = 8;
> +	spi_setup(spi);
> +
> +	da9052_spi->dev = &spi->dev;
> +	da9052_spi->spi_dev = spi;
> +
> +	da9052_spi->rw_pol = 1;
> +	dev_set_drvdata(&spi->dev, da9052_spi);
> +
> +	da9052_spi->write_dev = da9052_spi_write_device;
> +	da9052_spi->read_dev = da9052_spi_read_device;
> +
> +	ret = da9052_device_init(da9052_i2c)

s/da9052_i2c/da9052_spi?  Also, semicolon was missed there.

-- 
Regards,
Shawn

