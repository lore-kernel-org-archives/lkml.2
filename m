Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2EOGNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 02:13:05 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:60173 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab2EOGNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 02:13:02 -0400
Message-ID: <4FB1F3DD.3060005@slimlogic.co.uk>
Date: Tue, 15 May 2012 15:12:45 +0900
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lrg@ti.com,
        b-cousson@ti.com, linux-omap@vger.kernel.org
Subject: Re: [PATCH 3/4] REGULATOR: regulator driver for Palmas series chips
References: <1336960712-2812-1-git-send-email-gg@slimlogic.co.uk> <1336960712-2812-4-git-send-email-gg@slimlogic.co.uk> <20120514085223.GH31985@opensource.wolfsonmicro.com>
In-Reply-To: <20120514085223.GH31985@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/12 17:52, Mark Brown wrote:
> On Mon, May 14, 2012 at 10:58:31AM +0900, Graeme Gregory wrote:
>
> Looks good, quite a few of the things below are updates for very
> recently introduced APIs.
>
>> +static int palmas_smps_read(struct palmas *palmas, unsigned int reg,
>> +		unsigned int *dest)
>> +{
>> +	int slave;
>> +	unsigned int addr;
>> +
>> +	slave = PALMAS_BASE_TO_SLAVE(PALMAS_SMPS_BASE);
>> +	addr = PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE, reg);
>> +
>> +	return regmap_read(palmas->regmap[slave], addr, dest);
>> +}
> Looks like the LDO and SPMS regulators both use the same regmap?
Yes have tidied this up a little in latest version.
>> +	.get_voltage		= palmas_get_voltage_smps,
> Why not get_voltage_sel?
Mild amnesia is my excuse, is fixed now!

>> +	.set_voltage_sel	= palmas_set_voltage_smps_sel,
>> +	.list_voltage		= palmas_list_voltage_smps,
> Implementing map_voltage() too would be nice.
I have implemented it for smps.
>> +static int palmas_is_enabled_smps10(struct regulator_dev *dev)
>> +{
>> +	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
>> +	unsigned int reg;
>> +
>> +	palmas_smps_read(pmic->palmas, PALMAS_SMPS10_STATUS, &reg);
>> +
>> +	reg &= SMPS10_BOOST_EN;
>> +
> Should be able to use regulator_is_enabled_regmap() and friends.
Has been converted thanks!

>> +static int palmas_list_voltage_smps10(struct regulator_dev *dev,
>> +					unsigned selector)
>> +{
>> +	if (selector)
>> +		return 5000000;
>> +
>> +	return 3750000;
> This could be written a little more transparently!
Have re-written it hopefully clearer.

>> +static int palmas_get_voltage_smps10(struct regulator_dev *dev)
>> +{
>> +	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
>> +	int selector;
>> +	unsigned int reg;
>> +
>> +	palmas_smps_read(pmic->palmas, PALMAS_SMPS10_CTRL, &reg);
>> +
>> +	selector = (reg & SMPS10_VSEL) >> 3;
>> +
>> +	return palmas_list_voltage_smps10(dev, selector);
> Should be get_voltage_sel() really, or beter still should be using
> regulator_set_voltage_sel_regmap().  Similarly for the set (which is
> already using _sel()).
I have implemented it using the regmap functions thanks for tip!

>> +static int palmas_enable_ldo(struct regulator_dev *dev)
>> +{
>> +	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
>> +	int id = rdev_get_id(dev);
>> +	unsigned int reg;
>> +
>> +	palmas_ldo_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
>> +
>> +	reg |= LDO1_CTRL_MODE_ACTIVE;
>> +
>> +	palmas_ldo_write(pmic->palmas, palmas_regs_info[id].ctrl_addr, reg);
> Could use the core regmap stuff for the LDOs too.
Enable/Disable now use regmap but is_enabled cant as it reads from a
different bitmask.

>> +	/* Adjust selector to match list_voltage ranges */
>> +	if (selector > 49)
>> +		selector = 49;
>> +
>> +	return palmas_list_voltage_ldo(dev, selector);
> get_voltage_sel().
Has been fixed!

>> +	if (!pdata)
>> +		return -EINVAL;
>> +	if (!pdata->reg_data)
>> +		return -EINVAL;
> I'd expect the driver to be able to register the regulators with no
> platform data at all.
Ok, I misunderstood how the pdata was used, hopefully I have got it
correct in the new version.

>> +	pmic = kzalloc(sizeof(*pmic), GFP_KERNEL);
>> +	if (!pmic)
>> +		return -ENOMEM;
> devm_kzalloc()
Fixed!

>> +	pmic->desc = kcalloc(PALMAS_NUM_REGS,
>> +			sizeof(struct regulator_desc), GFP_KERNEL);
>> +	if (!pmic->desc) {
>> +		ret = -ENOMEM;
>> +		goto err_free_pmic;
>> +	}
> Just embed this in the pmic struct?  It's always the same size.
Have embedded, this was a left over from when I was originally planning
the muxing handling.

>> +	pmic->rdev = kcalloc(PALMAS_NUM_REGS,
>> +			sizeof(struct regulator_dev *), GFP_KERNEL);
> Similarly heere.
Same as above.

Thanks for taking time to review. Am sending v2 patches soon.

Graeme

