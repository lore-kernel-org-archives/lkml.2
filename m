Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab2DST4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 15:56:18 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:48077 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799Ab2DST4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 15:56:17 -0400
Message-ID: <4F906DF6.4090906@metafoo.de>
Date: Thu, 19 Apr 2012 21:56:38 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
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
References: <1334834109-30183-1-git-send-email-ldewangan@nvidia.com>	<1334834109-30183-3-git-send-email-ldewangan@nvidia.com> <CANEJEGtvfwUmtXjsu_PTWP2zCRAbYMJh_jJp-c6Ex2ca=Sietg@mail.gmail.com> <4F906729.9030700@nvidia.com>
In-Reply-To: <4F906729.9030700@nvidia.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 09:27 PM, Laxman Dewangan wrote:
> On Thursday 19 April 2012 11:22 PM, Grant Grundler wrote:
>> On Thu, Apr 19, 2012 at 4:15 AM, Laxman
>> Dewangan<ldewangan@nvidia.com>  wrote:
>>> Using regmap for accessing register through i2c bus. This will
>>> remove the code for caching registers, read-modify-write logics.
>>> Also it will provide the debugfs feature to dump register
>>> through regmap debugfs.
>>>
>>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
>> Reviewed-by: Grant Grundler<grundler@chromium.org>
>>
>> Laxman,
>> Thanks for reposting this patch. I was talking with Bryan Freed and it
>> looks like the caching of registers will change the usage of
>> ADD_COMMAND1. More details below.
>>
> Thanks for review.  ADD_COMMAND1 have the intrrupt flag bit. More
> details below.
> 
>>> +static bool is_volatile_reg(struct device *dev, unsigned int reg)
>>> +{
>>> +       switch (reg) {
>>> +       case ISL29018_REG_ADD_DATA_LSB:
>>> +       case ISL29018_REG_ADD_DATA_MSB:
>>> +       case ISL29018_REG_ADD_COMMAND1:
>>> +       case ISL29018_REG_TEST:
>> Of these four, I think only ADD_COMMAND1 wasn't treated as volatile in
>> the old code. Am I overlooking something?
>>
>> My concern is only about the additional I2C read traffic this patch
>> might generate. It's possible *some* bits in that register are
>> volatile and we could previously ignore them.
>>
> 
> Register ADD_COMMAND1, bit 2 is interrupt flag bit which shows the
> interrupt status and hence we can not cache it.
> The ISL29018 datasheet says:
> Interrupt flag; Bit 2. This is the status bit of the interrupt.
> The bit is set to logic high when the interrupt thresholds
> have been triggered, and logic low when not yet triggered.
> Once triggered, INT pin stays low and the status bit stays
> high. Both interrupt pin and the status bit are automatically
> cleared at the end of Command Register I transfer.

If the bit is cleared when reading the register I suppose it is not being worth
much to mark the register as volatile since the bit will be cleared whenever
you update the register. If there is only opmode and the irq bit in that
register I'd keep the register volatile, but use regmap_write instead of
regmap_update_bits.
