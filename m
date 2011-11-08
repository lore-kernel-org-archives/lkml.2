Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab1KHPD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:03:26 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:56242 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab1KHPDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:03:24 -0500
Message-ID: <4EB9447C.4050109@atmel.com>
Date: Tue, 08 Nov 2011 16:02:20 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111031 Thunderbird/7.0.1
MIME-Version: 1.0
To: Claudio Scordino <claudio@evidence.eu.com>, alan@linux.intel.com,
        Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jesper Nilsson <Jesper.Nilsson@axis.com>,
        Mikael Starvik <mikael.starvik@axis.com>,
        Darron Black <darron@griffin.net>
Subject: Re: [PATCH] RS485: fix inconsistencies in the meaning of some variables
References: <4E492CFF.7040905@pwrnet.de> <20110822211832.GA8023@kroah.com> <4EB3A009.10502@evidence.eu.com> <4EB8F6B9.6010008@atmel.com> <4EB90902.4030200@evidence.eu.com>
In-Reply-To: <4EB90902.4030200@evidence.eu.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2011 11:48 AM, Claudio Scordino :
> Il 08/11/2011 10:30, Nicolas Ferre ha scritto:
>> On 11/04/2011 09:19 AM, Claudio Scordino :
>>> Hi Alan, Hi Greg,
>>>
>>>     it seems that the crisv10.c and the atmel_serial.c serial
>>> drivers interpret the fields of the serial_rs485 structure in a
>>> different
>>> way.
>>>
>>> In particular, it seems that crisv10.c uses SER_RS485_RTS_AFTER_SEND and
>>> SER_RS485_RTS_ON_SEND for the _logic value_ of the RTS pin;
>>> atmel_serial.c, instead, uses these values to know if a _delay_ must be
>>> set before and after sending.
>>
>> It seems sensible, but, on the other hand, I fear that this is a big
>> change in the user interface: If people are already relying on this for
>> their application, this can be difficult to understand the change. Can't
>> we imagine an smoother migration path?
>>
>> It seems from de6f86ce5 that 16C950 may also use rs485 mode (with
>> another signal that RTS BTW)...
>>
>> See comments online...
>>
>>> This patch makes the usage of these variables consistent across all
>>> drivers and fixes the Documentation as well.
>>> In particular, SER_RS485_RTS_AFTER_SEND and SER_RS485_RTS_ON_SEND will
>>> be used to set the logic value of the RTS pin (as in the crisv10.c
>>> driver); the delay is understood by looking only at the value of
>>> delay_rts_before_send and delay_rts_after_send.
>>>
>>> Best regards,
>>>
>>>     Claudio
>>>
>>>
>>> Subject: RS485: fix inconsistencies in the meaning of some variables
>>> From: Claudio Scordino<claudio@evidence.eu.com>
>>>
>>> The crisv10.c and the atmel_serial.c serial drivers interpret the fields
>>> of the serial_rs485 structure in a different way.
>>> In particular, crisv10.c uses SER_RS485_RTS_AFTER_SEND and
>>> SER_RS485_RTS_ON_SEND for the voltage of the RTS pin; atmel_serial.c,
>>> instead,
>>> uses these values to know if a delay must be set before and after
>>> sending.
>>> This patch makes the usage of these variables consistent across all
>>> drivers and
>>> fixes the Documentation as well.
>>> > From now on, SER_RS485_RTS_AFTER_SEND and SER_RS485_RTS_ON_SEND
>>> will be used to
>>> set the voltage of the RTS pin (as in the crisv10.c driver); the
>>> delay will be
>>> understood by looking only at the value of delay_rts_before_send and
>>> delay_rts_after_send.
>>
>> Ok, but don't you think that the flags names are not so much
>> self-explanatory for this new meaning?
>>
>> What about:
>> SER_RS485_RTS_LEVEL_DURING_SEND
>> SER_RS485_RTS_VALUE_DURING_SEND (maybe too vague?)
>> SER_RS485_RTS_LOGICAL_VALUE_DURING_SEND (maybe too long?)
>>
>> Moreover, can't we just use one property for this? I mean, if RTS
>> logical value is high during the sending of data, can it mean that RTS
>> will be low before and after? And the other way around: if the signal is
>> low during data send, will it be high before and after?
>>
>> Here again, changing the user interface is not a good idea, so I fear
>> that it can be a show stopper.
> 
> Hi Nicolas,
> 
>     I understand, but honestly I do not agree.
> 
> The current state is inconsistent, and leaving the status quo can only
> bring to more issues in the future (because it is not clear if the
> interface should be used either as in the Cris or in the Atmel driver).
> That's why I think it should be fixed ASAP (before further drivers start
> using it).
> 
> The modifications that I have proposed are very minimal, and most
> user-space code should continue to work without any difference. Any Cris
> user-space code will continue to work, because we didn't change the
> behavior of the driver. For Atmel user-space code, instead, the behavior
> of the driver changes only if flags are not set and delay variables
> contain a value different than 0 (which, hopefully, is not a very common
> situation).

Ok then. I was fearing that, with Atmel driver, someone can set
SER_RS485_RTS_AFTER_SEND to tell that the delay is needed but not
necessarily that the signal level is "high".

But you are right telling that this inconstancy should be addressed.

> That's the reason why I preferred to not change the names of
> the variables, even if better names would be desirable.

100% agree with this.

> If you want, I can re-format the patch according to you suggestions,

Yes

> remove formatted lines

Yes

> and changing the names of the variables.

Well, this is proved to be not a good option at this stage of RS485
support in kernel. So as you said: no need to mess with this.

> But unfortunately, I cannot undertake the device tree bindings at the
moment.

Ah, ok... well we will manage this after your submitting of this patch.
But can you tell me if the signal wave is always like this:
__|--|__ and --|__|--

or if it can also be like this:
__|--|--  or --|--|__

This way, we will see if the hardware property can be addressed with
only one device tree biding or if tree of them are needed.

Best regards,
-- 
Nicolas Ferre
