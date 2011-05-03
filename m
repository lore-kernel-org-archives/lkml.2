Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1ECRZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:25:25 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:43422 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753739Ab1ECRZY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:25:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IfaXF4rhx5dzJHcHJABZT+aZCqQ0SZ9pAWFd9AmQNQkNRPLkXm1yum9tZZvGHP4phL
         wMn5DrlShYlGFZ2Jxp2kVyQK8gIsQwruAcEs9sHT7M6Pu4Uq2jGA3FGhB4LIVH4FTCHz
         ek7wmR4HeEeKAU9IKucENWO+v5n9awNsIo6vg=
MIME-Version: 1.0
In-Reply-To: <20110429082623.GN11227@gundam.enneenne.com>
References: <1303928054-14662-3-git-send-email-jamesnuss@nanometrics.ca>
	<20110428152222.0271163f@apollo.gnet>
	<BANLkTimG0vL3Ky=ARa+7XyW4PSFdg064YQ@mail.gmail.com>
	<20110429005524.67600139@apollo.gnet>
	<20110429012748.704a39a6@apollo.gnet>
	<4DBA3EC3.2020209@gmail.com>
	<20110429082623.GN11227@gundam.enneenne.com>
Date: Tue, 3 May 2011 13:25:22 -0400
Message-ID: <BANLkTimtK=5rJAYaV5Aa9y8CTnUU3TfKiA@mail.gmail.com>
Subject: Re: [LinuxPPS] [PATCH 2/2] pps: new client driver using IRQs
From: James Nuss <jamesnuss@nanometrics.ca>
To: Igor Plyatov <plyatov@gmail.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Rodolfo Giometti <rodolfo.giometti@enneenne.com>
Cc: linuxpps@ml.enneenne.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for you comments Igor, Alexander and Rodolfo.

You all make a good point that it would be useful to also register a
CLEAR event. Before I go ahead and implement any changes I would like
clarify a couple of things.

My original patch which only included the ASSERT event was simple
because all you needed to do was register an IRQ resource with a
particular edge trigger and you would get an ASSERT event on that
edge. It becomes a little more complicated when you want to capture
both ASSERT and CLEAR events because you also have to indicate to the
driver which edge is the ASSERT and which is the CLEAR. This is
because I presume you could have systems that generate a pulse which
transitions from low->high->low OR a pulse which transitions from
high->low->high, and we would want a driver which is generic enough to
handle both cases. Is my understanding correct that an ASSERT event is
simply the first edge of a single pulse, regardless of "polarity"?

I suppose the driver could be intelligent enough to figure out which
is the first edge on the assumption that the pulse width is always
very small - at least less than 0.5 second, more likely less than a
few hundred milliseconds. Obviously it would need at least 2 pulses
before it decides to register either an ASSERT or CLEAR event. Is it
safe enough to say that an ASSERT event will only be generated if the
previous edge was greater than 0.5 second ago, otherwise a CLEAR event
will be generated?

If I was to implement the driver this way then you would have exactly
3 ways to register a device to use this driver:

1) Register an IRQ with only IORESOURCE_IRQ_HIGHEDGE set:
This will generate an ASSERT event on rising edges (no CLEAR events)

2) Register an IRQ with only IORESOURCE_IRQ_LOWEDGE set:
This will generate an ASSERT event on falling edges (no CLEAR events)

3) Register an IRQ with both IORESOURCE_IRQ_LOWEDGE and
IORESOURCE_IRQ_HIGHEDGE set:
This will generate ASSERT and CLEAR events with the driver dynamically
determining which edge is the ASSERT based on the logic above.

I hope this covers all the potential use cases.

cheers,
James


On Fri, Apr 29, 2011 at 4:26 AM, Rodolfo Giometti <giometti@enneenne.com> wrote:
> On Fri, Apr 29, 2011 at 08:29:55AM +0400, Igor Plyatov wrote:
>
>>>> The latter will definitely mess things up, right?
>>> I mean, one surely can register an IRQ resource with both flags set. And
>>> if the underlying hardware works as it is described (i.e. raises an irq
>>> on both edges) then it will be a problem.
>>
>> Please don't try to abandon one of ASSERT or CLEAR events!
>> It is very useful to register both of them, because in this case its
>> possible to measure pulse width and decode PPS signals like DCF77.
>
> At this point I suppose we should add both ASSERT and CLEAR events...
>
> Ciao,
>
> Rodolfo
>
> --
>
> GNU/Linux Solutions                  e-mail: giometti@enneenne.com
> Linux Device Driver                          giometti@linux.it
> Embedded Systems                     phone:  +39 349 2432127
> UNIX programming                     skype:  rodolfo.giometti
> Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
