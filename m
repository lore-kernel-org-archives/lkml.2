Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab2CSCxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 22:53:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42219 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab2CSCx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 22:53:28 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <4F65C1AA.40102@metafoo.de>
References: <1331942824.6622.1.camel@phoenix> <4F65C1AA.40102@metafoo.de>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 19 Mar 2012 10:53:07 +0800
Message-ID: <CAF+7xWk8Arz+XW+4_+LNFfrMp_nszOxHVoe+qwnbppRvzHwJ2Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] regulator: pcf50633: Don't write to reserved bits
 of AUTO output voltage select register
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/18 Lars-Peter Clausen <lars@metafoo.de>:
> On 03/17/2012 01:07 AM, Axel Lin wrote:
>> The datasheet says 00000000 to 00101110 are reserved, and the min value of the
>> voltage setting is 1.8 V.
>> Thus don't write 0 to AUTO output voltage select register (address 1Ah).
>>
>> Table 50. AUTOOUT - AUTO output voltage select register (address 1Ah) bit description[1]
>> Bit Symbol Access Description
>> 7:0 auto_out R/W VO(prog) = 0.625 + auto_out × 0.025 V
>> eg. 00000000 to 00101110: reserved
>> 00101111: 1.8 V (min)
>> 01010011: 2.7 V
>> 01101010: 3.275 V
>> 01101011: 3.300 V
>> 01101100: 3.325 V
>> 01111111 : 3.800 V (max)
>> ..... .....
>> 11111110 : 3.800 V
>> 11111111 : 3.800 V
>>
>> This patch also fixes a bug in pcf50633_regulator_list_voltage.
>> It is wrong to do "index += 0x2f" for PCF50633_REGULATOR_AUTO in
>> pcf50633_regulator_list_voltage. The purpose of adding 0x2f to index is because
>> current code return 0 in auto_voltage_bits when millivolts < 1800.
>> For millivolts > 1800, adding 0x2f to index is wrong.
>>
>
> I think you misunderstood what the current code does. The first usable voltage
> is 1.8V which is equal to a index of of 0x2f. So the driver adds 0x2f to the
> index so that there is not a headroom of 0x2f unusable voltages. So a selector
> of 0 translates to 1.8V, a selector of 1 translates to 1.825V and so on.
I think what I wry to explain is:
In regulator core _regulator_do_set_voltage function:

        if (rdev->desc->ops->set_voltage) {
                ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV,
                                                   &selector);

                if (rdev->desc->ops->list_voltage)
                        selector = rdev->desc->ops->list_voltage(rdev,
                                                                 selector);
                else
                        selector = -1;

The list_voltage call here takes the selector got from set_voltage callback.
Thus adding 0x2f to the index in pcf50633_regulator_list_voltage looks
wrong to me.

e.g.
If min_uV < 1.8V, pcf50633_regulator_set_voltage sets 0 to selector.
For this case, adding 0x2f to the index in
pcf50633_regulator_list_voltage is exactly what you want.
However, if min_uV == 1.8V, pcf50633_regulator_set_voltage sets 0x2f
to selector.
Adding 0x2f to the index in pcf50633_regulator_list_voltage in this
case is wrong.

What this patch does is:
The minimal voltage setting for AUTOOUT is 0x2f.
Thus for the case min_uV < 1.8, set the voltage setting to 1.8V by writting
0x2f to AUTOOUT register and set selector = 0x2f.
So we don't write the rserved range to AUTOOUT register.
Which means the possible range of AUTOOUT register value is 0x2f ~ 0xff.

We have no problem in regulator_get_voltage.
Since we won't write 0~0x2e to AUTOOUT register, we have no problem converting
the bits we read to voltage. The equation in auto_voltage_value works fine.

For list_voltage, we need to take into account the case selector is 0 ~ 0x2e
because the regulator core assumes the selector is starting from 0.
This patch returns 0 for the cases selector is 0 ~ 0x2e, which means
"this selector code can't be used on this system".

>
> I can see why you'd want to change it to simplify the code, but you also have
> to change the number of voltages for the AUTO regulator to 128.
yes, I missed that.
The regulator core iterates from 0 to n_voltages to find the small voltage
in the specific range.
So yes, I think the n_voltages settings for AUTOOUT should be 128 now,
including the reserved range of AUTOOUT.

I'll send a V3 for review and update the commit log.
Thanks,
Axel
