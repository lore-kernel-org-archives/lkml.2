Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0FBI3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:29:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54378 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab0FBI3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:29:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w7Y+qLC2n3f40yLeI5RPjE9rpPHc0dhGYvcYA+9YxdXe//LFHvBMgQ3EprfQQZQzDa
         dW2rYHYSho/kkTTfNUhVVBC1JEY09eSaAAz/CNcehOVy9UGSNFeTvBBW94sf/Ap8IRwA
         lddnjiJjspQxlGtWmkhPsCtypxRJoRHuv1O/Q=
MIME-Version: 1.0
In-Reply-To: <20100601143749.GE863@rakim.wolfsonmicro.main>
References: <1275399239-6788-1-git-send-email-vapier@gentoo.org>
	<20100601143749.GE863@rakim.wolfsonmicro.main>
Date: Wed, 2 Jun 2010 16:29:01 +0800
Message-ID: <AANLkTilsdDIKc0b4YnvfTBvs9aB6W5RZLhrpi1YBGc9m@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulator: new driver for the AD5398 and AD5821
From: Sonic Zhang <sonic.adi@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 10:37 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Jun 01, 2010 at 09:33:58AM -0400, Mike Frysinger wrote:
>> From: Sonic Zhang <sonic.zhang@analog.com>
>
>> This driver supports both the AD5398 and the AD5821.  It adapts into the
>> voltage and current framework.  The generic userspace-consumer and virtual
>
> Might be useful to put something here saying what these chips do...
>

OK.

>> consumer should be selected to access devices via this driver.
>
> Please remove the comment about the userspace and virtual consumers from
> the driver, the driver should support all consumer drivers and the use
> of userspace consumers will normally be very unusual.
>

OK.

>> +static int ad5398_get(struct regulator_dev *rdev)
>> +{
>> +     struct ad5398_chip_info *chip = rdev_get_drvdata(rdev);
>> +     struct i2c_client *client = chip->client;
>> +     unsigned short data;
>> +     int ret;
>> +
>> +     ret = i2c_master_recv(client, (char *)&data, 2);
>> +     if (ret < 0) {
>> +             dev_err(&client->dev, "I2C read error\n");
>> +             return ret;
>> +     }
>
> I strongly suggest implementing register I/O functions rather than open
> coding with the I2C API each time.
>

No problem.

>> +
>> +     ret = (be16_to_cpu(data) & chip->current_mask) >> chip->current_offset;
>> +
>> +     return ad5398_calc_current(chip, ret);
>
> This function should really have a much clearer name than just plain
> _get() - it looks like it's intended to read the current limit.
>
>> +static int ad5398_set(struct regulator_dev *rdev, int min_uA, int max_uA)
>> +{
>
> Same here - this should have a much clearer name saying what's being
> set.
>

OK.

>> +     /* prepare register data */
>> +     selector = (selector << chip->current_offset) & chip->current_mask;
>> +     selector |= (data & CURRENT_EN_MASK);
>
> This CURRENT_EN_MASK configuration looks fishy, what does that setting
> do and why is it being unconditionally set?
>

CURRENT_EN_MASK is the power on control bit of these current regulator chip.
It is part of the current value register. It is not touched when
setting the current value.


>> +static struct regulator_ops ad5398_ops = {
>> +     .get_current_limit = ad5398_get,
>> +     .set_current_limit = ad5398_set,
>> +     .enable = ad5398_enable,
>> +     .disable = ad5398_disable,
>> +     .is_enabled = ad5398_is_enabled,
>> +     .set_suspend_enable = ad5398_enable,
>> +     .set_suspend_disable = ad5398_disable,
>
> If the chip does not have suspend mode configuration it should not
> supply any suspend mode configuration functions.
>

OK. I will remove them.

>> +     i2c_set_clientdata(client, chip);
>> +     dev_info(&client->dev, "%s regulator driver loaded\n", id->name);
>
> Remove this or tone it down to a debug level print.
>
>> +static int ad5398_remove(struct i2c_client *client)
>> +{
>> +     struct ad5398_chip_info *chip = i2c_get_clientdata(client);
>> +
>> +     if (chip) {
>> +             regulator_unregister(&chip->rdev);
>> +             kfree(chip);
>> +     }
>
> If you failed to register the regulator you should've failed the probe
> and therefore this check for chip should not be required.
>

OK.

>> +#define CURRENT_EN_MASK              0x8000
>> +#define CURRENT_BITS_MAX     16
>
> These defines should be namespaced.
>

No problem.

>> +/**
>> + * ad5398_platform_data - platform data for ad5398
>> + * @current_bits: effective bits in register
>> + * @current_offset: offset of effective bits in register
>> + * @ad5398_init_data: regulator init data
>> + */
>> +struct ad5398_platform_data {
>> +     unsigned short current_bits;
>> +     unsigned short current_offset;
>> +     struct regulator_init_data *regulator_data;
>> +};
>
> Why are the current bits and offset being suppied as platform data?  I
> would *very* strongly expect that the location of the control in the
> register will be fixed by the device type and should therefore be
> figured out by the driver.  Having the machine specifying this seems
> redundant and error prone.

Yes, define these data format information in driver for each supported
chip is a better way.

I will send out the new patch soon.

Sonic

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
