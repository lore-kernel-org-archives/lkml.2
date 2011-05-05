Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab1EEPIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 11:08:04 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:42317 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042Ab1EEPIB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 11:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dn7KQb3XRRM2PMvNdXJnXqtLg5Gq3WuJfoeXus315tdHD0JztSh8nODTz1O70Aa0jZ
         q7Pp9tOiI22P3zIMjHVvUQaqoZoP+j9L6cd6dY6myoWy8vbGGiAIZT7+hlgPs42Yos86
         ioW5wiQQJ7fUUq/CPoQsn88EVu5LwMkjiBw2Q=
MIME-Version: 1.0
In-Reply-To: <4DC0E30A.1060308@gmail.com>
References: <1303928054-14662-3-git-send-email-jamesnuss@nanometrics.ca>
	<20110428152222.0271163f@apollo.gnet>
	<BANLkTimG0vL3Ky=ARa+7XyW4PSFdg064YQ@mail.gmail.com>
	<20110429005524.67600139@apollo.gnet>
	<20110429012748.704a39a6@apollo.gnet>
	<4DBA3EC3.2020209@gmail.com>
	<20110429082623.GN11227@gundam.enneenne.com>
	<BANLkTimtK=5rJAYaV5Aa9y8CTnUU3TfKiA@mail.gmail.com>
	<4DC0E30A.1060308@gmail.com>
Date: Thu, 5 May 2011 11:07:59 -0400
Message-ID: <BANLkTik9AsZaxp7UX43LruHZUQNy2NB7Lg@mail.gmail.com>
Subject: Re: [LinuxPPS] [PATCH 2/2] pps: new client driver using IRQs
From: James Nuss <jamesnuss@nanometrics.ca>
To: plyatov@gmail.com
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Rodolfo Giometti <rodolfo.giometti@enneenne.com>,
        linuxpps@ml.enneenne.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Igor,

I agree, platform_data is a good candidate for this type of parameter.
Where is the appropriate place to keep the header file containing the
struct declaration(s)? e.g in your case "struct
pps_client_gpio_platform_data" and "struct pps_client_gpio" Presumably
it needs to be in a readily accessible header file so the board setup
code can use it.

cheers,
James

>
> This way can lead to problems when developer tries to debug PPS subsystem
> with some specific signal parameters.
> In my opinion it much safer to explicitly declare ".active_low = 0" or
> ".active_low = 1" in the platform initialization code.
> See example:
>
> /*
>  * pps client gpio
>  */
> static struct pps_client_gpio pps_client_gpios[] = {
>    {
>        .gpio            = GPI_PPS0_IN,
>        .active_low        = 0, /* ASSERT is a _/ */
>        .desc            = "pps0 source",
>        .decoder_type        = PPS_DECODER_GEOSIG_T1PPS,
>    },
>    {
>        .gpio            = GPI_PPS1_IN,
>        .active_low        = 1, /* ASSERT is a \_ */
>        .desc            = "pps1 source",
>    }
> };
>
> static struct pps_client_gpio_platform_data pps_client_gpios_data = {
>    .pclient    = pps_client_gpios,
>    .num_gpios    = ARRAY_SIZE(pps_client_gpios),
> };
>
> static struct platform_device pps_client_gpio_device = {
>    .name        = "pps-client-gpio",
>    .id        = 0,
>    .dev        = {
>        .platform_data    = &pps_client_gpios_data,
>    }
> };
>
>
>> If I was to implement the driver this way then you would have exactly
>> 3 ways to register a device to use this driver:
>>
>> 1) Register an IRQ with only IORESOURCE_IRQ_HIGHEDGE set:
>> This will generate an ASSERT event on rising edges (no CLEAR events)
>>
>> 2) Register an IRQ with only IORESOURCE_IRQ_LOWEDGE set:
>> This will generate an ASSERT event on falling edges (no CLEAR events)
>>
>> 3) Register an IRQ with both IORESOURCE_IRQ_LOWEDGE and
>> IORESOURCE_IRQ_HIGHEDGE set:
>> This will generate ASSERT and CLEAR events with the driver dynamically
>> determining which edge is the ASSERT based on the logic above.
>>
>> I hope this covers all the potential use cases.
>>
>> cheers,
>> James
>>
>>
>> On Fri, Apr 29, 2011 at 4:26 AM, Rodolfo Giometti<giometti@enneenne.com>
>>  wrote:
>>>
>>> On Fri, Apr 29, 2011 at 08:29:55AM +0400, Igor Plyatov wrote:
>>>
>>>>>> The latter will definitely mess things up, right?
>>>>>
>>>>> I mean, one surely can register an IRQ resource with both flags set.
>>>>> And
>>>>> if the underlying hardware works as it is described (i.e. raises an irq
>>>>> on both edges) then it will be a problem.
>>>>
>>>> Please don't try to abandon one of ASSERT or CLEAR events!
>>>> It is very useful to register both of them, because in this case its
>>>> possible to measure pulse width and decode PPS signals like DCF77.
>>>
>>> At this point I suppose we should add both ASSERT and CLEAR events...
>>>
>>> Ciao,
>>>
>>> Rodolfo
>>>
>>> --
>>>
>>> GNU/Linux Solutions                  e-mail: giometti@enneenne.com
>>> Linux Device Driver                          giometti@linux.it
>>> Embedded Systems                     phone:  +39 349 2432127
>>> UNIX programming                     skype:  rodolfo.giometti
>>> Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>
> Best regards!
>
> --
> Igor Plyatov
>
>
