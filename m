Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699Ab0FCC5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 22:57:07 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52060 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933577Ab0FCC5D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 22:57:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eeU4nuZ/duPK5o0ANDVbSV1MI8RpXiP6KM/yx6Q8NUtpHiq5QhqSWZFN9q/bHQCJyO
         AR8LaeVnmfaXoM+37VuN3qdgZUeN2nsnIyiDrPzp4qFjyGIRsesWnufeuyJfcUMqikVT
         kC7GI4SAisrPBfCsj51okE7cOcEWR6MSy4dRs=
MIME-Version: 1.0
In-Reply-To: <20100602103329.GA2457@opensource.wolfsonmicro.com>
References: <1275468694.2545.1.camel@eight.analog.com>
	<20100602103329.GA2457@opensource.wolfsonmicro.com>
Date: Thu, 3 Jun 2010 10:57:02 +0800
Message-ID: <AANLkTilUfrxL5TQcqV8Bta2tuKWQI5YXSew6Jo8YOljk@mail.gmail.com>
Subject: Re: [PATCH v2] regulator: new drivers for AD5398 and AD5821
From: Sonic Zhang <sonic.adi@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 6:33 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Jun 02, 2010 at 04:51:34PM +0800, sonic zhang wrote:
>
>> +static int ad5398_read_reg(struct i2c_client *client, unsigned short *data)
>> +{
>> +     unsigned short val;
>> +     int ret;
>> +
>> +     ret = i2c_master_recv(client, (char *)&val, 2);
>> +     if (ret < 0) {
>> +             dev_err(&client->dev, "I2C read error\n");
>> +             return ret;
>> +     }
>> +     *data = swab16(val);
>
> Should this not be a be16_to_cpu() or similar rather than an
> unconditional byte swap?  Presumably the byte swap is not going to be
> needed if the CPU has the same endianness as the CPU that the system is
> using.

I made a mistake to mix simple i2c transfer and smbus i2c transfer
here. For smbus i2c transfer, byte swap is unconditional.

>
>> +     /* read chip enable bit */
>> +     ret = ad5398_read_reg(client, &data);
>> +     if (ret < 0)
>> +             return ret;
>
>> +     /* prepare register data */
>> +     selector = (selector << chip->current_offset) & chip->current_mask;
>> +     selector |= (data & AD5398_CURRENT_EN_MASK);
>
> The reason I was querying this code on the original submission is that
> it is more normal to write this as something like
>
>    data = selector | (data & ~chip->current_mask);
>
> ie, to write the code as "set these bits" rather than "preserve these
> bits".  This is more clearly robust to the reader since it's clear that
> there aren't other register bits which should be set.

OK.

>
>> +       chip->min_uA = init_data->constraints.min_uA;
>> +       chip->max_uA = init_data->constraints.max_uA;
>
> This looks very wrong, especially given that you use the min_uA and
> max_uA settings to scale the register values being written in to the
> chip.  I would expect that either the limits would be fixed in the
> silicon or (if they depend on things like the associated passives which
> can be configured per-board) that there would be some other setting in
> the platform data which specifies what's actually being changed.
>
> The constraints being specified by the platform should not influence the
> physical properties of the chip, they control which values are allowed
> in a particular design (for example, saying that values over a given
> limit are not allowed due to the limits of the hardware connected to the
> regulator) and are separate to what the chip is capable of.
>

I will predefine the chip physical min max values in the driver and add user
defined limitation based on both initial constraints and chip spec.


Sonic
