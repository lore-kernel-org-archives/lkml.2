Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab2DTDEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 23:04:49 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4127 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab2DTDEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 23:04:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 19 Apr 2012 20:04:45 -0700
Message-ID: <4F90D229.9030401@nvidia.com>
Date: Fri, 20 Apr 2012 08:34:09 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Grant Grundler <grundler@chromium.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "max@stro.at" <max@stro.at>,
        "jbrenner@taosinc.com" <jbrenner@taosinc.com>,
        "bfreed@chromium.org" <bfreed@chromium.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] staging: iio: light: isl29018: use regmap for
 register access
References: <1334834109-30183-1-git-send-email-ldewangan@nvidia.com>	<1334834109-30183-3-git-send-email-ldewangan@nvidia.com> <CANEJEGtvfwUmtXjsu_PTWP2zCRAbYMJh_jJp-c6Ex2ca=Sietg@mail.gmail.com> <4F906729.9030700@nvidia.com> <4F906DF6.4090906@metafoo.de>
In-Reply-To: <4F906DF6.4090906@metafoo.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2012 01:26 AM, Lars-Peter Clausen wrote:
> On 04/19/2012 09:27 PM, Laxman Dewangan wrote:
>> On Thursday 19 April 2012 11:22 PM, Grant Grundler wrote:
>>> On Thu, Apr 19, 2012 at 4:15 AM, Laxman
>>> Dewangan<ldewangan@nvidia.com>   wrote:
>>>> +static bool is_volatile_reg(struct device *dev, unsigned int reg)
>>>> +{
>>>> +       switch (reg) {
>>>> +       case ISL29018_REG_ADD_DATA_LSB:
>>>> +       case ISL29018_REG_ADD_DATA_MSB:
>>>> +       case ISL29018_REG_ADD_COMMAND1:
>>>> +       case ISL29018_REG_TEST:
>>> Of these four, I think only ADD_COMMAND1 wasn't treated as volatile in
>>> the old code. Am I overlooking something?
>>>
>>> My concern is only about the additional I2C read traffic this patch
>>> might generate. It's possible *some* bits in that register are
>>> volatile and we could previously ignore them.
>>>
>> Register ADD_COMMAND1, bit 2 is interrupt flag bit which shows the
>> interrupt status and hence we can not cache it.
>> The ISL29018 datasheet says:
>> Interrupt flag; Bit 2. This is the status bit of the interrupt.
>> The bit is set to logic high when the interrupt thresholds
>> have been triggered, and logic low when not yet triggered.
>> Once triggered, INT pin stays low and the status bit stays
>> high. Both interrupt pin and the status bit are automatically
>> cleared at the end of Command Register I transfer.
> If the bit is cleared when reading the register I suppose it is not being worth
> much to mark the register as volatile since the bit will be cleared whenever
> you update the register. If there is only opmode and the irq bit in that
> register I'd keep the register volatile, but use regmap_write instead of
> regmap_update_bits.

There is 2-bits in ADD_COMMAND1  for interrupt persistence.
The interrupt pin and the interrupt flag is triggered/set when the data 
sensor
reading is out of the interrupt threshold window after m
consecutive number of integration cycles.


The driver is not supporting interrupt now. I think we can use 
regmap_write() in place of regmap_update_bits() keeping this volatile as 
you suggested.
When we add interrupt support on this driver, we will write the register 
after ORing with persistence bits. For that also it will not require to 
do caching of register.

