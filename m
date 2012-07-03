Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab2GCIUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 04:20:23 -0400
Received: from smtp-out-141.synserver.de ([212.40.185.141]:1081 "EHLO
	smtp-out-141.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2GCIUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 04:20:20 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 32362
Message-ID: <4FF2AC24.7090906@metafoo.de>
Date: Tue, 03 Jul 2012 10:24:04 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>
CC: Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v2] regulator: ad5398: Fix min/max current limit boundary
 checking
References: <1341301353.12050.1.camel@phoenix> <DB904C5425BA6F4E8424B3B51A1414D17140805D85@NWD2CMBX1.ad.analog.com> <4FF2A7F9.3090307@metafoo.de> <DB904C5425BA6F4E8424B3B51A1414D17140805DAB@NWD2CMBX1.ad.analog.com>
In-Reply-To: <DB904C5425BA6F4E8424B3B51A1414D17140805DAB@NWD2CMBX1.ad.analog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 10:13 AM, Zhang, Sonic wrote:
> 
> 
>> -----Original Message-----
>> From: Lars-Peter Clausen [mailto:lars@metafoo.de]
>> Sent: Tuesday, July 03, 2012 4:06 PM
>> To: Zhang, Sonic
>> Cc: Axel Lin; Mark Brown; linux-kernel@vger.kernel.org; Liam Girdwood
>> Subject: Re: [PATCH v2] regulator: ad5398: Fix min/max current limit boundary
>> checking
>>
>> On 07/03/2012 09:54 AM, Zhang, Sonic wrote:
>>>
>>>
>>>> -----Original Message-----
>>>> From: Axel Lin [mailto:axel.lin@gmail.com]
>>>> Sent: Tuesday, July 03, 2012 3:43 PM
>>>> To: Mark Brown
>>>> Cc: linux-kernel@vger.kernel.org; Zhang, Sonic; Lars-Peter Clausen; Liam
>>>> Girdwood
>>>> Subject: [PATCH v2] regulator: ad5398: Fix min/max current limit boundary
>>>> checking
>>>>
>>>> It is ok to request current limit with min_uA < chip->min_uA and
>>>> max_uA > chip->max_uA.
>>>>
>>>> We need to set min_uA = chip->min_uA if (min_uA < chip->min_uA),
>>>> this ensures the equation to calcuate selator does not return negative number.
>>>>
>>>
>>> You should not do it in driver. Set a correct min_uA value in your application.
>>
>> I think the patch makes sense. If a application request a current range
>> which overlaps with the range support by the chip, but either the requested
>> min is smaller than the supported min or the requested max is larger than
>> the supported max the driver will fail with an error. E.g.
>>
>> req-min     req-max
>>   |-----------|
>>        |------------|
>>     chip-min  chip-max
>>
>> or even
>>
>> req-min                req-max
>>   |----------------------|
>>        |------------|
>>     chip-min  chip-max
>>
>>
>> While it is obviously possible for the chip to fulfill this request.
>> Axel's patch takes care of this situation and ensures that the request is
>> satisfied and the output current is set to a current within the requested
>> range and the supported range.
> 
> If the requested minimum current is smaller than the capability of the hardware, does a bigger min value fulfill this request?

As long as it is smaller than the maximum requested current, yes. You
request a current range with the regulator API and any value within this
range is fine as the actual output current.

> 
> If this logic is correct, I am fine to ACK.
> 
> 
> Regards,
> 
> Sonic
> 
> 
>>
>> - Lars
>>
>>>
>>> Regards,
>>>
>>> Sonic
>>>
>>>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>>>> ~
>>>> ---
>>>> drivers/regulator/ad5398.c |    7 ++++---
>>>> 1 file changed, 4 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
>>>> index 46d05f3..84fdcda 100644
>>>> --- a/drivers/regulator/ad5398.c
>>>> +++ b/drivers/regulator/ad5398.c
>>>> @@ -89,9 +89,10 @@ static int ad5398_set_current_limit(struct regulator_dev
>>>> *rdev, int min_uA, int
>>>>       unsigned short data;
>>>>       int ret;
>>>>
>>>> -      if (min_uA > chip->max_uA || min_uA < chip->min_uA)
>>>> -              return -EINVAL;
>>>> -      if (max_uA > chip->max_uA || max_uA < chip->min_uA)
>>>> +      if (min_uA < chip->min_uA)
>>>> +              min_uA = chip->min_uA;
>>>> +
>>>> +      if (min_uA > chip->max_uA || max_uA < chip->min_uA)
>>>>               return -EINVAL;
>>>>
>>>>       selector = DIV_ROUND_UP((min_uA - chip->min_uA) * chip->current_level,
>>>> --
>>>> 1.7.9.5
>>>>
>>>>
>>>>
>>>
>>
> 

