Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1EDFYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 01:24:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58146 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1EDFYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 01:24:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=t6d70k7BHNfCfzwGmHYS9xMigOU9arMOavqua944wvdYFjQugNQXPMszvzSYd8qWSy
         L3ZlT5mNjSRE24zgU1x0CRr59fPeciJyUr0fa0YWIVrDZq4W4kDUNOKCwBV9RK98caZy
         Biipw0g3wDwCM7idrGFFYqh8Ngm0/bG3j9Z+Q=
Message-ID: <4DC0E30A.1060308@gmail.com>
Date: Wed, 04 May 2011 09:24:26 +0400
From: Igor Plyatov <plyatov@gmail.com>
Reply-To: plyatov@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: James Nuss <jamesnuss@nanometrics.ca>
CC: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Rodolfo Giometti <rodolfo.giometti@enneenne.com>,
        linuxpps@ml.enneenne.com, linux-kernel@vger.kernel.org
Subject: Re: [LinuxPPS] [PATCH 2/2] pps: new client driver using IRQs
References: <1303928054-14662-3-git-send-email-jamesnuss@nanometrics.ca>	<20110428152222.0271163f@apollo.gnet>	<BANLkTimG0vL3Ky=ARa+7XyW4PSFdg064YQ@mail.gmail.com>	<20110429005524.67600139@apollo.gnet>	<20110429012748.704a39a6@apollo.gnet>	<4DBA3EC3.2020209@gmail.com>	<20110429082623.GN11227@gundam.enneenne.com> <BANLkTimtK=5rJAYaV5Aa9y8CTnUU3TfKiA@mail.gmail.com>
In-Reply-To: <BANLkTimtK=5rJAYaV5Aa9y8CTnUU3TfKiA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James!

> Thanks for you comments Igor, Alexander and Rodolfo.
>
> You all make a good point that it would be useful to also register a
> CLEAR event. Before I go ahead and implement any changes I would like
> clarify a couple of things.
>
> My original patch which only included the ASSERT event was simple
> because all you needed to do was register an IRQ resource with a
> particular edge trigger and you would get an ASSERT event on that
> edge. It becomes a little more complicated when you want to capture
> both ASSERT and CLEAR events because you also have to indicate to the
> driver which edge is the ASSERT and which is the CLEAR. This is
> because I presume you could have systems that generate a pulse which
> transitions from low->high->low OR a pulse which transitions from
> high->low->high, and we would want a driver which is generic enough to
> handle both cases. Is my understanding correct that an ASSERT event is
> simply the first edge of a single pulse, regardless of "polarity"?
>
> I suppose the driver could be intelligent enough to figure out which
> is the first edge on the assumption that the pulse width is always
> very small - at least less than 0.5 second, more likely less than a
> few hundred milliseconds. Obviously it would need at least 2 pulses
> before it decides to register either an ASSERT or CLEAR event. Is it
> safe enough to say that an ASSERT event will only be generated if the
> previous edge was greater than 0.5 second ago, otherwise a CLEAR event
> will be generated?

This way can lead to problems when developer tries to debug PPS 
subsystem with some specific signal parameters.
In my opinion it much safer to explicitly declare ".active_low = 0" or 
".active_low = 1" in the platform initialization code.
See example:

/*
  * pps client gpio
  */
static struct pps_client_gpio pps_client_gpios[] = {
     {
         .gpio            = GPI_PPS0_IN,
         .active_low        = 0, /* ASSERT is a _/ */
         .desc            = "pps0 source",
         .decoder_type        = PPS_DECODER_GEOSIG_T1PPS,
     },
     {
         .gpio            = GPI_PPS1_IN,
         .active_low        = 1, /* ASSERT is a \_ */
         .desc            = "pps1 source",
     }
};

static struct pps_client_gpio_platform_data pps_client_gpios_data = {
     .pclient    = pps_client_gpios,
     .num_gpios    = ARRAY_SIZE(pps_client_gpios),
};

static struct platform_device pps_client_gpio_device = {
     .name        = "pps-client-gpio",
     .id        = 0,
     .dev        = {
         .platform_data    = &pps_client_gpios_data,
     }
};


> If I was to implement the driver this way then you would have exactly
> 3 ways to register a device to use this driver:
>
> 1) Register an IRQ with only IORESOURCE_IRQ_HIGHEDGE set:
> This will generate an ASSERT event on rising edges (no CLEAR events)
>
> 2) Register an IRQ with only IORESOURCE_IRQ_LOWEDGE set:
> This will generate an ASSERT event on falling edges (no CLEAR events)
>
> 3) Register an IRQ with both IORESOURCE_IRQ_LOWEDGE and
> IORESOURCE_IRQ_HIGHEDGE set:
> This will generate ASSERT and CLEAR events with the driver dynamically
> determining which edge is the ASSERT based on the logic above.
>
> I hope this covers all the potential use cases.
>
> cheers,
> James
>
>
> On Fri, Apr 29, 2011 at 4:26 AM, Rodolfo Giometti<giometti@enneenne.com>  wrote:
>> On Fri, Apr 29, 2011 at 08:29:55AM +0400, Igor Plyatov wrote:
>>
>>>>> The latter will definitely mess things up, right?
>>>> I mean, one surely can register an IRQ resource with both flags set. And
>>>> if the underlying hardware works as it is described (i.e. raises an irq
>>>> on both edges) then it will be a problem.
>>> Please don't try to abandon one of ASSERT or CLEAR events!
>>> It is very useful to register both of them, because in this case its
>>> possible to measure pulse width and decode PPS signals like DCF77.
>> At this point I suppose we should add both ASSERT and CLEAR events...
>>
>> Ciao,
>>
>> Rodolfo
>>
>> --
>>
>> GNU/Linux Solutions                  e-mail: giometti@enneenne.com
>> Linux Device Driver                          giometti@linux.it
>> Embedded Systems                     phone:  +39 349 2432127
>> UNIX programming                     skype:  rodolfo.giometti
>> Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>

Best regards!

-- 
Igor Plyatov

