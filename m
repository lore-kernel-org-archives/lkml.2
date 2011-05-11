Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab1EKQEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:04:45 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:54594 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114Ab1EKQEn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:04:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110510205320.GE8726@opensource.wolfsonmicro.com>
References: <BANLkTimXbG5TkzV-MthUtkQ8k26AOPsqHw@mail.gmail.com>
	<20110510205320.GE8726@opensource.wolfsonmicro.com>
Date: Wed, 11 May 2011 10:09:20 -0500
Message-ID: <BANLkTinHZrQiq=E8W1YFpG=Mvre_0DXEoA@mail.gmail.com>
Subject: Re: [PATCH 4/4] tps65912: add regulator driver
From: Margarita Olaya <magi@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, May 10, 2011 at 3:53 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, May 10, 2011 at 03:25:59PM -0500, Margarita Olaya wrote:
>
> A lot of this driver looks awfully similar to a bunch of the other TI
> PMIC drivers posted recently - is it possible to reuse some of driver
> code here?
>

911/10 and 912 are separate IC families, and there will be future
patches that differentiate the code much further.

Regards,
Margarita

>> +/* Supported voltage values for regulators */
>> +static const u16 VDCDCx_VSEL0_table[] = {
>> +     5000, 5125, 5250, 5375, 5500,
>> +     5625, 5750, 5875, 6000, 6125,
>
> All these tables look like they're nice regular voltage steps and could
> be replaced with simple calculations in the code.  That's better as it
> means we don't have to iterate through the table every time we want to
> do anything.
>
>> +static inline int tps65912_read(struct tps65912_reg *pmic, u8 reg)
>> +{
>> +     u8 val;
>> +     int err;
>> +
>> +     err = pmic->mfd->read(pmic->mfd, reg, 1, &val);
>> +     if (err < 0)
>> +             return err;
>> +
>> +     return val;
>> +}
>
> Shouldn't the MFD driver just export this function?  Both the IRQ and
> GPIO drivers also need it.  Similarly for write() and the reg_ versions
> of them.
>
>> +             reg1_val |= DCDCCTRL_DCDC_MODE_MASK;
>> +             tps65912_reg_write(pmic, reg1, reg1_val);
>> +             reg2_val &= ~DCDC_AVS_ECO_MASK;
>> +             tps65912_reg_write(pmic, reg2, reg2_val);
>
> There's set_bits() and clear_bits() ops in the core...
>
>> +     switch (range) {
>> +     case 0:
>> +             /* 0.5 - 1.2875V in 12.5mV steps */
>> +             voltage = tps65912_vsel_to_uv_range0(vsel);
>> +             break;
>
> Just implement get_voltage_sel() and let the core do the lookup.
>
>> +static int tps65912_set_voltage_dcdc(struct regulator_dev *dev,
>> +                                             unsigned selector)
>> +{
>> +     struct tps65912_reg *pmic = rdev_get_drvdata(dev);
>> +     int id = rdev_get_id(dev);
>> +     int value;
>> +     const u16 *table;
>> +     u8 table_len, reg;
>> +
>> +     table = pmic->info[id]->table;
>> +     table_len = pmic->info[id]->table_len;
>> +
>> +     reg = tps65912_get_dcdc_sel_register(pmic, id);
>> +     value = tps65912_reg_read(pmic, reg);
>> +     value &= 0xC0;
>> +     return tps65912_reg_write(pmic, reg, selector | value);
>
> You're not actually doing anything with table here...
>
>> +static int tps65912_get_voltage_ldo(struct regulator_dev *dev)
>> +{
>> +     struct tps65912_reg *pmic = rdev_get_drvdata(dev);
>> +     int id = rdev_get_id(dev), voltage = 0;
>> +     int vsel = 0;
>> +     u8 reg;
>> +
>> +     reg = tps65912_get_ldo_sel_register(pmic, id);
>> +     vsel = tps65912_reg_read(pmic, reg);
>> +     vsel &= 0x3F;
>> +
>> +     /* 0.5 - 1.2875V in 12.5mV steps */
>> +     voltage = LDO_VSEL_table[vsel];
>> +
>> +     return voltage * 100;
>
> Just make this into a get_voltage_sel().
>
>> +static int tps65912_list_voltage_dcdc(struct regulator_dev *dev,
>> +                                     unsigned selector)
>> +{
>> +     struct tps65912_reg *pmic = rdev_get_drvdata(dev);
>> +     int id = rdev_get_id(dev);
>> +     const u16 *table;
>> +     u8 table_len;
>> +
>> +     table = pmic->info[id]->table;
>> +     table_len = pmic->info[id]->table_len;
>> +     if (selector >= table_len)
>> +             return -EINVAL;
>> +     else
>> +             return table[selector] * 100;
>> +}
>
> There were a bunch of vsel_to_uV functions further up the driver which
> do the same thing - one of the two implementations should go.
>
