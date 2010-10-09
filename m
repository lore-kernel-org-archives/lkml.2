Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0JIKAm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 06:00:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54814 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab0JIKAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 06:00:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HF+iRR0ICGsqc5ffwD9CtWIXWN9dP83Muwrg30puF2ZwFevV0nQ2FwQkW0lUydzQRX
         7wv/dCpx1hZPFAJenZvOZGnI28gL/d5tfL7VlbCZacoCKBp4/TjhzaonrGdIeUAlLiLB
         FVhotRo8ZpLTYL4Wo8JMktxFWyXYnpTLz0LfE=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1010082242390.3107@xanadu.home>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101007192245.GC26435@n2100.arm.linux.org.uk>
	<AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
	<20101008175308.GA10975@n2100.arm.linux.org.uk>
	<20101008231926.GA28235@kroah.com>
	<alpine.LFD.2.00.1010082242390.3107@xanadu.home>
Date: Sat, 9 Oct 2010 13:00:38 +0300
Message-ID: <AANLkTi=BvXROFEnzYykoUQNbU05Q=mWoV3t7qKDk7+vL@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Greg KH <greg@kroah.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 9, 2010 at 6:36 AM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Fri, 8 Oct 2010, Greg KH wrote:
>> Wait, let me get this straight:
>>   - drivers used to work on 2.6.35
>
> Possibly on pre ARMv6 only.  On ARMv6 and above, the discussed behavior
> _never_ worked.  It is fundamental to the CPU design.

That's not true, drivers on ARMv6 and above do work. I still wonder
how exactly to trigger the issue, and how often does this happen,
because I've never seen it.

I trust the experts that it is an issue, but I don't agree that
drivers that are currently working on ARMv6+ should be broken on
purpose right away.

>>   - some ARM core code changed in .36-rc to fix this iomem problem that
>>     you found
>
> Nothing was fixed.  There is nothing to fix.  Simply that a wrong driver
> assumption about the hardware capability was prohibited by the API.

Not exactly. There is supposedly a problem on ARMv6+, there must be a
mechanism to avoid this problem, all drivers should migrate to that,
or a different on, so that we have a sane API.

>>   - no drivers are notified of the api change as it's a run-time change,
>>     so the build doesn't break.
>
> There is no API change.  Simply an API misuse.  Granted, on pre ARMv6
> this usage used to work, but on ARMv6 and above this never was supported
> at all by the hardware.  The fact that the software has let it through
> was a gross mistake, period.

No. It worked just fine, now it's doesn't, that's a change in API
behavior, which is also part of the API. It might not be ideal, or
proper, but it does work.

>>   - drivers break when run as the api stops returning valid addresses
>
> Such drivers on ARMv6 should *never* have worked in the first place.
> When they did "work", they corrupted memory.

They corrupted their own memory, right? And on _very_ rare occasions I
presume, since I've never seen it. If so, there's no damage in letting
them work at least one more release (2.6.36).

>>   - no known way is around to fix the broken drivers
>
> That's B/s.  As Russell said, there are known solutions that were
> proposed at least six months ago.

You seriously think most people out there know how to "set aside some
RAM at boot time"? I don't, otherwise the drivers would be fixed by
now.

>> Um, this doesn't sound like a valid thing to be doing,
>
> Excuse me, but preventing data corruption is a damn valid thing to do.
> The real problem is that people kept on abusing the API for something
> that the hardware simply can't support, and the mere fact that things
> _appears_ to just work by accident in 98% of the cases encourage people
> to simply put their head in the sand and ignore the issue.  Sorry folks,
> but that's not how computing works.  We're not amateurs for damn sake,
> and when the ARM bible says this operation is UNSUPPORTED, it is
> UNSUPPORTED.  Seeing people trying to fsck around the issue because of
> laziness is revolting!

Have you ever seen this corruption? How often does this happen? So, a
driver would generate corruption in it's own data and your solution is
to make the driver stop working? That's going from 98% to 0% in one
release.

There's many people out there that have realized these issues, and the
only thing they would see is their driver broken on .36. How about
instead we just warn for now? What's wrong with that? There have been
many releases with the "wrong" ioremap(), one more would not hurt
anybody.

>> how do you expect
>> people to fix their code if they:
>>       - don't realize it as the api change doesn't break the build
>
> The API should have complained the very first time they attempted the
> operation in question.  It should never have worked.  I'm sorry but the
> mere fact that the broken driver didn't receive an error before is no
> excuse to *knowingly* let memory corruption go on.

Yes, it should have, but it didn't. Now people are relying on that
behavior, so, first you deprecate that usage with WARN_ON, and later
you remove that functionality.

>>       - there is no way to fix their code
>
> Wrong.  See above.
>
>> This sounds like a huge regression that should be reverted, or am I
>> missing something here?
>
> I'm afraid you are totally missing the point.
>
> The patch Russell introduced simply prevented an abuse of the API for
> which there are documented evidences that such abuse is a source of
> memory corruption.  This must not be allowed any longer, not even for a
> warning period.  There is no regression what so ever as those driver
> were always broken.  And I much prefer to have brokenness in the form of
> driver initialization error rather than silent and random memory
> corruptions.

People have different definitions of "broken"; working 99% of the time
is good enough for many people, specially compared to 0%.

So you found an issue on ARMv6+, great, let's warn the users so that
they know the issue exists, hopefully a generic mechanism to fix this
will come about for .37 so that some drivers can migrate to that, and
then truly disable the functionality.

-- 
Felipe Contreras
