Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1KHKsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 05:48:41 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40885 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab1KHKsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 05:48:39 -0500
Message-ID: <4EB90902.4030200@evidence.eu.com>
Date: Tue, 08 Nov 2011 11:48:34 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: alan@linux.intel.com, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jesper Nilsson <Jesper.Nilsson@axis.com>,
        Mikael Starvik <mikael.starvik@axis.com>,
        Darron Black <darron@griffin.net>
Subject: Re: [PATCH] RS485: fix inconsistencies in the meaning of some variables
References: <4E492CFF.7040905@pwrnet.de> <20110822211832.GA8023@kroah.com> <4EB3A009.10502@evidence.eu.com> <4EB8F6B9.6010008@atmel.com>
In-Reply-To: <4EB8F6B9.6010008@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/11/2011 10:30, Nicolas Ferre ha scritto:
> On 11/04/2011 09:19 AM, Claudio Scordino :
>> Hi Alan, Hi Greg,
>>
>> 	it seems that the crisv10.c and the atmel_serial.c serial
>> drivers interpret the fields of the serial_rs485 structure in a different
>> way.
>>
>> In particular, it seems that crisv10.c uses SER_RS485_RTS_AFTER_SEND and
>> SER_RS485_RTS_ON_SEND for the _logic value_ of the RTS pin;
>> atmel_serial.c, instead, uses these values to know if a _delay_ must be
>> set before and after sending.
>
> It seems sensible, but, on the other hand, I fear that this is a big
> change in the user interface: If people are already relying on this for
> their application, this can be difficult to understand the change. Can't
> we imagine an smoother migration path?
>
> It seems from de6f86ce5 that 16C950 may also use rs485 mode (with
> another signal that RTS BTW)...
>
> See comments online...
>
>> This patch makes the usage of these variables consistent across all
>> drivers and fixes the Documentation as well.
>> In particular, SER_RS485_RTS_AFTER_SEND and SER_RS485_RTS_ON_SEND will
>> be used to set the logic value of the RTS pin (as in the crisv10.c
>> driver); the delay is understood by looking only at the value of
>> delay_rts_before_send and delay_rts_after_send.
>>
>> Best regards,
>>
>> 	Claudio
>>
>>
>> Subject: RS485: fix inconsistencies in the meaning of some variables
>> From: Claudio Scordino<claudio@evidence.eu.com>
>>
>> The crisv10.c and the atmel_serial.c serial drivers interpret the fields
>> of the serial_rs485 structure in a different way.
>> In particular, crisv10.c uses SER_RS485_RTS_AFTER_SEND and
>> SER_RS485_RTS_ON_SEND for the voltage of the RTS pin; atmel_serial.c, instead,
>> uses these values to know if a delay must be set before and after sending.
>> This patch makes the usage of these variables consistent across all drivers and
>> fixes the Documentation as well.
>> > From now on, SER_RS485_RTS_AFTER_SEND and SER_RS485_RTS_ON_SEND will be used to
>> set the voltage of the RTS pin (as in the crisv10.c driver); the delay will be
>> understood by looking only at the value of delay_rts_before_send and
>> delay_rts_after_send.
>
> Ok, but don't you think that the flags names are not so much
> self-explanatory for this new meaning?
>
> What about:
> SER_RS485_RTS_LEVEL_DURING_SEND
> SER_RS485_RTS_VALUE_DURING_SEND (maybe too vague?)
> SER_RS485_RTS_LOGICAL_VALUE_DURING_SEND (maybe too long?)
>
> Moreover, can't we just use one property for this? I mean, if RTS
> logical value is high during the sending of data, can it mean that RTS
> will be low before and after? And the other way around: if the signal is
> low during data send, will it be high before and after?
>
> Here again, changing the user interface is not a good idea, so I fear
> that it can be a show stopper.

Hi Nicolas,

	I understand, but honestly I do not agree.

The current state is inconsistent, and leaving the status quo can only 
bring to more issues in the future (because it is not clear if the 
interface should be used either as in the Cris or in the Atmel driver). 
That's why I think it should be fixed ASAP (before further drivers start 
using it).

The modifications that I have proposed are very minimal, and most 
user-space code should continue to work without any difference. Any Cris 
user-space code will continue to work, because we didn't change the 
behavior of the driver. For Atmel user-space code, instead, the behavior 
of the driver changes only if flags are not set and delay variables 
contain a value different than 0 (which, hopefully, is not a very common 
situation). That's the reason why I preferred to not change the names of 
the variables, even if better names would be desirable.

If you want, I can re-format the patch according to you suggestions, 
remove formatted lines and changing the names of the variables. But 
unfortunately, I cannot undertake the device tree bindings at the moment.

Best regards,

	Claudio
