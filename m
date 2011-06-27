Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab1F0Uik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 16:38:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab1F0UiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 16:38:23 -0400
Message-ID: <4E08EA1E.9040508@redhat.com>
Date: Mon, 27 Jun 2011 17:37:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sakari Ailus <sakari.ailus@iki.fi>, Arnd Bergmann <arnd@arndb.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl  doesn't
 exist
References: <4E0519B7.3000304@redhat.com> <201106271656.04612.hverkuil@xs4all.nl> <4E08A2E6.6020902@redhat.com> <201106271907.59067.hverkuil@xs4all.nl>
In-Reply-To: <201106271907.59067.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-06-2011 14:07, Hans Verkuil escreveu:
> On Monday, June 27, 2011 17:33:58 Mauro Carvalho Chehab wrote:
>> Em 27-06-2011 11:56, Hans Verkuil escreveu:
>>> On Monday, June 27, 2011 15:54:11 Mauro Carvalho Chehab wrote:
>>>> Em 27-06-2011 09:17, Hans Verkuil escreveu:
>>>>> While we don't have an enum capability, in many cases you can deduce
>>>>> whether a particular ioctl should be supported or not. Usually based on
>>>>> capabilities, sometimes because certain ioctls allow 'NOP' operations that
>>>>> allow you to test for their presence.
>>>>>
>>>>> Of course, drivers are not always consistent here, but that's a separate
>>>>> problem.
>>>>
>>>> Any "hint" code that would try to do some NOP operations may fail. One of the
>>>> reasons is that such hint is not documented. Yet, I don't officially support
>>>> such "hint" methods at the API.
>>>
>>> The point is that the spec can easily be improved to make such 'NOP' operations
>>> explicit, or to require that if a capability is present, then the corresponding
>>> ioctl(s) must also be present. Things like that are easy to verify as well with
>>> v4l2-compliance.
>>
>> We currently have more than 64 ioctl's. Adding a capability bit for each doesn't
>> seem the right thing to do. Ok, some could be grouped, but, even so, there are
>> drivers that implement the VIDIOC_G, but doesn't implement the corresponding VIDIO_S.
>> So, I think we don't have enough available bits for doing that.
> 
> No, that's not what I meant.
> 
> Whether or not ioctls are implemented can in many cases be deduced from the
> QUERYCAP capabilities: e.g. if V4L2_CAP_STREAMING is set, then the buffer I/O
> ioctls have to be there.

No. only the MMAP-based and OVERLAY-based ioctls could be deduced from the flags
there, plus hw freq seek. Anything else will be just a guess.

> For other ioctls the test whether they are implemented
> is also often straightforward: e.g. if VIDIOC_G_INPUT returns -EINVAL, then
> that can only mean that it isn't implemented, and neither are ENUM_INPUT and
> S_INPUT.

At the best, it is a hint coding.

> In cases where only the G variant is implemented, there we need to tighten
> the spec and require that these ioctls are properly implemented: you either
> implement all of the ENUM/G/TRY/S ioctls or none.

The V4L1 compat layer required that some VIDIOC_G variants to be implemented for
some things to work. This code were moved to userspace, but the requirement is
probably still there.

In other words, drivers had/have no option but implementing some VIDIOC_G even
when VIDIOC_S is not supported.

So, changing the V4L2 spec to require that all 3 to be implemented will also 
cause compatibility issues that will be harder to map than the check for a proper
check of the EINVAL return code.

> Currently ENUM_FRAMESIZES/INTERVALS is one set of ioctls where this is very
> ambiguous. For most of the others it is pretty straightforward.

>>>> Btw, there are two drivers returning -ENOTTY, when the device got disconnected
>>>> (or firmware were not uploaded).
>>>>
>>>> The truth is that the current API specs for return code is bogus.
>>>
>>> Bogus in what way? It's been documented very clearly for years. We may not like
>>> that design decision (I certainly don't like it), but someone clearly thought
>>> about it at the time.
>>
>> Bogus in the sense that drivers don't follow them, as they're returning undocumented
>> values. Any application strictly following it will have troubles.
> 
> I suspect that in most cases the drivers are fairly reasonable, but the spec
> wasn't updated with the new error codes.

If driver foo returns ENOTTY because the device got removed and driver bar returns another
error, they're not consistent. Developers tried to get the errors that they considered to
be the more applicable to that situation, but, as different developers took different
decisions, the end result is that several error codes will need to be fixed^Wchanged, in
order to allow userspace to properly deal/report with such error conditions.

>>>> The right thing to do is to create a separate chapter for error codes, based on errno(3)
>>>> man page, where we document all error codes that should be used by the drivers. Then,
>>>> at the ioctl pages, link to the common chapter and, only when needed, document special
>>>> cases where an error code for that specific ioctl has some special meaning.
>>>
>>> Great, I've no problem with that. But this particular error code you want to change
>>> is actually implemented *consistently* in all drivers. There is no confusion, no
>>> ambiguity, and it is according to the spec.
>>
>> As I said, from userspace perspective, it is not consistent to assume that EINVAL means
>> not implemented. For sure at VIDIOC_S_foo, this is not consistent. Even on some GET types
>> of ioctl, like for example [1][2], there are other reasons for an EINVAL return.
>>
>> [1] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-cropcap.html
>> [2] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-audio.html
>>
>> The only way to make it consistent is to use different return codes for "invalid parameters" 
>> and for "unsupported ioctl".
> 
> No, what we do is perfectly consistent: i.e. we always return EINVAL when an
> ioctl is not supported. That's what 'consistent' means. Whether that is the
> *right* error code is something else.
> 
> But right now our API and our documentation is perfectly consistent and has been
> for years.
> 
> <snip>
> 
>>> The fact that many drivers use error codes creatively doesn't give us an excuse
>>> to just change the one error code that is actually used everywhere according to
>>> the spec! That's faulty logic.
>>
>> The fix that it is needed is to provide a consistent way for an userspace application
>> to know for sure when an ioctl is not supported. It can be done on a simple way of
>> just returning a different error code for it, or with complex mechanisms like adding
>> a per-ioctl flag and some hint logics based on NOP.
> 
> It's a 'fix' that I fear may break applications because drivers suddenly change
> their behavior. You can't just ignore that. You also can't analyze applications,
> since closed source apps may also use it, and we obviously have no control over
> those.

That's the price that a closed source app pays: we can't do much to detect or prevent 
breaking a closed source application. A simple driver patch may hurt those applications, 
and only the app developer can fix. On the other hand, closed-source applications have
a team of developers paid to keep their application working. So, if properly announced,
they can change their code in advance in order to check for the QUERYCAP version and
handle the new behaviour accordingly.

I think that we should take a look at the existing open source applications and see how
they handle -EINVAL, sending patches to them fixing the behaviour, if they're broken
by such change.

>> The V4L2 is complex enough for us to add more complexity with hints and cap flags.
> 
> Actually, all it needs for the most part is that current implicit rules are made
> explicit: if a certain querycap flag is set, then a corresponding set of ioctls
> must be implemented. If I can call the GET ioctl, then the ENUM and SET (and
> TRY) must also be implemented. Sensible rules at any time, they just need to be
> made explicit.
> 
> If you want to change it to ENOTTY, then go right ahead. But you can explain
> it to our customers when their app suddenly breaks for some hardware.
> 
> I don't get it. This is really not a problem. We rarely, if ever, get complaints
> about it, and there is a ton of other much more important stuff that needs to
> be done.
> 
> Regards,
> 
> 	Hans

