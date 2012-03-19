Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab2CSJF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 05:05:27 -0400
Received: from smtp-out-236.synserver.de ([212.40.185.236]:1095 "EHLO
	smtp-out-236.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab2CSJF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 05:05:26 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9856
Message-ID: <4F66F75E.6040906@metafoo.de>
Date: Mon, 19 Mar 2012 10:07:42 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: axel.lin@gmail.com
CC: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2 1/2] regulator: pcf50633: Don't write to reserved bits
 of AUTO output voltage select register
References: <1331942824.6622.1.camel@phoenix> <4F65C1AA.40102@metafoo.de> <CAF+7xWk8Arz+XW+4_+LNFfrMp_nszOxHVoe+qwnbppRvzHwJ2Q@mail.gmail.com>
In-Reply-To: <CAF+7xWk8Arz+XW+4_+LNFfrMp_nszOxHVoe+qwnbppRvzHwJ2Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 03:53 AM, Axel Lin wrote:
> 2012/3/18 Lars-Peter Clausen <lars@metafoo.de>:
>> On 03/17/2012 01:07 AM, Axel Lin wrote:
>>> The datasheet says 00000000 to 00101110 are reserved, and the min value of the
>>> voltage setting is 1.8 V.
>>> Thus don't write 0 to AUTO output voltage select register (address 1Ah).
>>>
>>> Table 50. AUTOOUT - AUTO output voltage select register (address 1Ah) bit description[1]
>>> Bit Symbol Access Description
>>> 7:0 auto_out R/W VO(prog) = 0.625 + auto_out × 0.025 V
>>> eg. 00000000 to 00101110: reserved
>>> 00101111: 1.8 V (min)
>>> 01010011: 2.7 V
>>> 01101010: 3.275 V
>>> 01101011: 3.300 V
>>> 01101100: 3.325 V
>>> 01111111 : 3.800 V (max)
>>> ..... .....
>>> 11111110 : 3.800 V
>>> 11111111 : 3.800 V
>>>
>>> This patch also fixes a bug in pcf50633_regulator_list_voltage.
>>> It is wrong to do "index += 0x2f" for PCF50633_REGULATOR_AUTO in
>>> pcf50633_regulator_list_voltage. The purpose of adding 0x2f to index is because
>>> current code return 0 in auto_voltage_bits when millivolts < 1800.
>>> For millivolts > 1800, adding 0x2f to index is wrong.
>>>
>>
>> I think you misunderstood what the current code does. The first usable voltage
>> is 1.8V which is equal to a index of of 0x2f. So the driver adds 0x2f to the
>> index so that there is not a headroom of 0x2f unusable voltages. So a selector
>> of 0 translates to 1.8V, a selector of 1 translates to 1.825V and so on.
> I think what I wry to explain is:
> In regulator core _regulator_do_set_voltage function:
> 
>         if (rdev->desc->ops->set_voltage) {
>                 ret = rdev->desc->ops->set_voltage(rdev, min_uV, max_uV,
>                                                    &selector);
> 
>                 if (rdev->desc->ops->list_voltage)
>                         selector = rdev->desc->ops->list_voltage(rdev,
>                                                                  selector);
>                 else
>                         selector = -1;
> 
> The list_voltage call here takes the selector got from set_voltage callback.
> Thus adding 0x2f to the index in pcf50633_regulator_list_voltage looks
> wrong to me.
> 

Ah ok, now I understand what you mean. When the selector parameter to
set_voltage was introduced we already had list_voltage adding the 0x2f, so
from my point of view list_voltage is correct and the bug is in the commit
which introduced the selector parameter to select voltage, that's why I was
confused as to why you think there was a bug in list_voltage. But it all
makes sense now, thanks.

Luckily the bug is not so critical, since selector is not really used in
_regulator_do_set_voltage in this case except for the trace message.

- Lars
