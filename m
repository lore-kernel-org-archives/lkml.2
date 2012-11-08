Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab2KHKpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 05:45:46 -0500
Received: from antcom.de ([188.40.178.216]:38163 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab2KHKpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 05:45:45 -0500
Message-ID: <509B8D20.6070208@antcom.de>
Date: Thu, 08 Nov 2012 11:44:48 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Alban Bedel <alban.bedel@avionic-design.de>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: Re: [PATCH] pwm: lpc32xx - Fix the PWM polarity
References: <20121106181939.61c50233@avionic-0020.adnet.avionic-design.de> <1352301955-15960-1-git-send-email-alban.bedel@avionic-design.de> <509B80A7.1060700@antcom.de> <20121108113353.4fdbb25c@avionic-0020.adnet.avionic-design.de>
In-Reply-To: <20121108113353.4fdbb25c@avionic-0020.adnet.avionic-design.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/12 11:33, Alban Bedel wrote:
> On Thu, 08 Nov 2012 10:51:35 +0100
> Roland Stigge <stigge@antcom.de> wrote:
> 
>> On 07/11/12 16:25, Alban Bedel wrote:
>>> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
>>> ---
>>>  drivers/pwm/pwm-lpc32xx.c |    6 +++++-
>>>  1 files changed, 5 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
>>> index adb87f0..0dc278d 100644
>>> --- a/drivers/pwm/pwm-lpc32xx.c
>>> +++ b/drivers/pwm/pwm-lpc32xx.c
>>> @@ -51,7 +51,11 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>>>  
>>>  	c = 256 * duty_ns;
>>>  	do_div(c, period_ns);
>>> -	duty_cycles = c;
>>> +	if (c == 0)
>>> +		c = 256;
>>> +	if (c > 255)
>>> +		c = 255;
>>> +	duty_cycles = 256 - c;
>>
>> Except for the range check (for the original c > 255), this results in:
>>
>> 	duty_cycles = 256 - c
>>
>> except for (c == 0) where
>>
>> 	duty_cycles = 1
> 
> No it lead to duty_cycles = 0

Let's do it step by step with the above code:

c == 0

>>> +	if (c == 0)
>>> +		c = 256;

c == 256

>>> +	if (c > 255)
>>> +		c = 255;

c == 255

>>> +	duty_cycles = 256 - c;

c == 1

See?

> 
>> which actually is
>>
>> 	duty_cycles = (256 - c) - 255
>>
>> (think with the original c)
>>
>> i.e. nearly a polarity inversion in the case of (c == 0).
>>
>> Why is the case (c == 0) so special here? Maybe you can document this,
>> if it is really intended?
> 
> It is intended, the formular for duty value in the register is:
> 
> duty = (256 - 256*duty_ns/period_ns) % 256

Where does this modulo defined? In the Manual, there is sth. like this
defined for RELOADV (tables 606+607), but not for DUTY.

Maybe I missed sth. in the manual. Link or hint appreciated!

Thanks,

Roland
