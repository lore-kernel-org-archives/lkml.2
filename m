Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab1F0PeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:34:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab1F0PeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:34:14 -0400
Message-ID: <4E08A2E6.6020902@redhat.com>
Date: Mon, 27 Jun 2011 12:33:58 -0300
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
References: <4E0519B7.3000304@redhat.com> <86e5c1f0a0222d3b2cf371f3c9d3b067.squirrel@webmail.xs4all.nl> <4E088B83.2050001@redhat.com> <201106271656.04612.hverkuil@xs4all.nl>
In-Reply-To: <201106271656.04612.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-06-2011 11:56, Hans Verkuil escreveu:
> On Monday, June 27, 2011 15:54:11 Mauro Carvalho Chehab wrote:
>> Em 27-06-2011 09:17, Hans Verkuil escreveu:
>>> While we don't have an enum capability, in many cases you can deduce
>>> whether a particular ioctl should be supported or not. Usually based on
>>> capabilities, sometimes because certain ioctls allow 'NOP' operations that
>>> allow you to test for their presence.
>>>
>>> Of course, drivers are not always consistent here, but that's a separate
>>> problem.
>>
>> Any "hint" code that would try to do some NOP operations may fail. One of the
>> reasons is that such hint is not documented. Yet, I don't officially support
>> such "hint" methods at the API.
> 
> The point is that the spec can easily be improved to make such 'NOP' operations
> explicit, or to require that if a capability is present, then the corresponding
> ioctl(s) must also be present. Things like that are easy to verify as well with
> v4l2-compliance.

We currently have more than 64 ioctl's. Adding a capability bit for each doesn't
seem the right thing to do. Ok, some could be grouped, but, even so, there are
drivers that implement the VIDIOC_G, but doesn't implement the corresponding VIDIO_S.
So, I think we don't have enough available bits for doing that.

>> Btw, there are two drivers returning -ENOTTY, when the device got disconnected
>> (or firmware were not uploaded).
>>
>> The truth is that the current API specs for return code is bogus.
> 
> Bogus in what way? It's been documented very clearly for years. We may not like
> that design decision (I certainly don't like it), but someone clearly thought
> about it at the time.

Bogus in the sense that drivers don't follow them, as they're returning undocumented
values. Any application strictly following it will have troubles.

>> The right thing to do is to create a separate chapter for error codes, based on errno(3)
>> man page, where we document all error codes that should be used by the drivers. Then,
>> at the ioctl pages, link to the common chapter and, only when needed, document special
>> cases where an error code for that specific ioctl has some special meaning.
> 
> Great, I've no problem with that. But this particular error code you want to change
> is actually implemented *consistently* in all drivers. There is no confusion, no
> ambiguity, and it is according to the spec.

As I said, from userspace perspective, it is not consistent to assume that EINVAL means
not implemented. For sure at VIDIOC_S_foo, this is not consistent. Even on some GET types
of ioctl, like for example [1][2], there are other reasons for an EINVAL return.

[1] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-cropcap.html
[2] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-audio.html

The only way to make it consistent is to use different return codes for "invalid parameters" 
and for "unsupported ioctl".

>> I ran a script here to check how many different error codes are used inside drivers/media:
>>
>> $ find drivers/media -type f -name '*.[ch]'  >files
>> $ grep define `find . -name errno*.h`|perl -ne 'print "$1\n" if (/\#define\s+(E[^\s]+)/)'|sort|uniq >errors
>> $ for i in `cat errors`; do COUNT=$(git grep -c $i `cat files`|wc -l); if [ "$COUNT" != "0" ]; then echo $i $COUNT; fi; done
>>
>> The result is that we're using 53 different types of errors, but the API specs documents
>> only 17 of them. Those are the currently used errors at drivers/media:
>>
>> ERROR CODE     |NUMBER OF *.c/*.h FILES USING IT
>> ---------------|--------------------------------
>> E2BIG           1
>> EACCES          8
>> EAGAIN          66
>> EBADF           1
>> EBADFD          1
>> EBADR           2
>> EBADRQC         2
>> EBUSY           149
>> ECHILD          1
>> ECONNRESET      25
>> EDEADLK         1
>> EDOM            1
>> EEXIST          3
>> EFAULT          230
>> EFBIG           1
>> EILSEQ          8
>> EINIT           2
>> EINPROGRESS     6
>> EINTR           21
>> EINVAL          501
>> EIO             305
>> EMFILE          1
>> ENFILE          7
>> ENOBUFS         7
>> ENODATA         4
>> ENODEV          270
>> ENOENT          46
>> ENOIOCTLCMD     31
>> ENOMEM          359
>> ENOSPC          13
>> ENOSR           7
>> ENOSYS          15
>> ENOTSUP         3
>> ENOTSUPP        3
>> ENOTTY          5
>> ENXIO           26
>> EOPNOTSUPP      19
>> EOVERFLOW       14
>> EPERM           47
>> EPIPE           12
>> EPROTO          11
>> ERANGE          25
>> EREMOTE         80
>> EREMOTEIO       80
>> ERESTART        32
>> ERESTARTSYS     32
>> ESHUTDOWN       27
>> ESPIPE          3
>> ETIME           53
>> ETIMEDOUT       37
>> EUSERS          2
>> EWOULDBLOCK     14
>> EXDEV           1
>>
>> I suspect that we'll need to both fix some drivers, and the API, as I bet that
>> the same error conditions are reported differently on different drivers.
>>
>>> I don't think changing such an important return value is acceptable.
>>
>> As I said, the current API is bogus with respect to error codes. Of course,
>> we need to do take care to avoid userspace applications breakage, but we can't
>> use the excuse that it is there for a long time as a reason for not fixing it.
> 
> The fact that many drivers use error codes creatively doesn't give us an excuse
> to just change the one error code that is actually used everywhere according to
> the spec! That's faulty logic.

The fix that it is needed is to provide a consistent way for an userspace application
to know for sure when an ioctl is not supported. It can be done on a simple way of
just returning a different error code for it, or with complex mechanisms like adding
a per-ioctl flag and some hint logics based on NOP.

The V4L2 is complex enough for us to add more complexity with hints and cap flags.

Thanks,
Mauro
