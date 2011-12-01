Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab1LAUi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 15:38:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab1LAUi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 15:38:56 -0500
Message-ID: <4ED7E5D7.8070909@redhat.com>
Date: Thu, 01 Dec 2011 18:38:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: HoP <jpetrous@gmail.com>
CC: Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <4ED7BBA3.5020002@redhat.com> <CAJbz7-1_Nb8d427bOMzCDbRcvwQ3QjD=2KhdPQS_h_jaYY5J3w@mail.gmail.com>
In-Reply-To: <CAJbz7-1_Nb8d427bOMzCDbRcvwQ3QjD=2KhdPQS_h_jaYY5J3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01-12-2011 17:59, HoP wrote:
> 2011/12/1 Mauro Carvalho Chehab<mchehab@redhat.com>:
>> On 01-12-2011 12:58, HoP wrote:
>>>
>>> Hi,
>>>
>>> let me ask you some details of your interesting idea (how to
>>> achieve the same functionality as with vtunerc driver):
>>>
>>> [...]
>>>
>>>> The driver, as proposed, is not really a driver, as it doesn't support
>>>> any
>>>> hardware. The kernel driver would be used to just copy data from one
>>>> userspace
>>>
>>> Please stop learning me what can be called driver and what nope.
>>> Your definition is nonsense and I don't want to follow you on it.
>>>
>>>> application to the other. The same result could be obtained in userspace,
>>>> by implementing a library. Such library could even use LD_PRELOAD to
>>>> support
>>>> binary only applications, like what libv4l does. In terms of performance,
>>>> such library would probably perform better than a kernel driver, as
>>>> there's
>>>> no need to do context switching for each call, and no need to talk with a
>>>> device (where kernel outperforms userspace). Also, depending on how such
>>>> library
>>>> is implemented, double buffering might be avoided.
>>>>
>>>> So, from architectural POV, this code should be written as an userspace
>>>> library.
>>>> BTW, alsa also came with the same results, years ago, as audio remote
>>>> streaming is supported via userspace tools, like pulseaudio.
>>>
>>> Can you show me, how then can be reused most important part
>>> of dvb-core subsystem like tuning and demuxing?
>>
>> Why do you need to implement it? Just forward the requests to the machine
>> with the real driver.
>>
>>> Or do you want me
>>> to invent wheels and to recode everything in the library?
>>
>> Kernel code is GPLv2. You can use its code on a GPLv2 licensed library.
>
> I see. So if you think it is nice to get dvb-core, make a wrapper around
> to get it usable in userspace and maintain totally same functionality
> by myself then I say it is no go. If it looks for you like good idea
> I must disagree. Code duplication? Two maintaners? That is crazy idea man.

I fail to see where do you need to duplicate dvb-core. An userspace
LD_PRELOAD handler that would do:

int socket;

int dvb_ioctl(int fd, unsigned long int request, ...)
{
         void *arg;
         va_list ap;
  
         va_start(ap, request);
         arg = va_arg(ap, void *);
         va_end(ap);

	send_net_ioctl_packet(socket, request, arg);
}

Is probably all you need to send _any_ ioctl's to a remote machine
(plus client's machine that would decode the ioctl packet and send
the ioctl to the actual driver).

Of course, you'll need hooks for all syscalls used (likely open, close,
ioctl, read, poll).

So, there's not much duplication, even if, for whatever reason, you
might need to hook some specific ioctls in order to optimize the
network performance.

>>> Of course
>>> I can be wrong, I'm no big kernel hacker. So please show me the
>>> way for it. BTW, even if you can find the way, then data copying
>>> from userspace to the kernel and back is also necessery.
>>
>> See libv4l, at v4l2-utils.git (at linuxtv.org).
>>
>>> I really
>>> don't see any advantage of you solution.
>>
>> And I can't see any advantage on yours ;) Putting something that belongs
>> to userspace into kernelspace just because it is easier to re-use the
>> existing code inside the kernel is not a good argument.
>
> It is only your POV that it should be in userspace.
>
> Creating additional code which not only enlarge code size by 2
> but I think by 10 is really not good idea.  And it get no advantage
> only disadvantages.
>
>>
>> Don't get me wrong but if you want to submit a code to be merged
>> on any existing software (being open source or not), you should be
>> prepared to defend your code and justify the need for it to the
>> other developers.
>
> Sure. I was prepared for technical disscussion, but was fully suprised
> that it was not happend (ok, to be correct, few guys are exception, like
> Andreas and few others. I really appreciate it).
>
> So, my question was still not answered: "Can be driver NACKed only
> because of worrying about possible misuse?"

To answer your question: your driver were nacked because of several reasons:
it is not a driver for an unsupported hardware, you failed to convince people
why this can't be implemented on userspace, the driver adds hooks at kernelspace
that would open internal API's that several developers don't agree on exposing
at userspace, as would allow non GPL license compatible drivers to re-use
their work in a way they are against.

You're free to politely argue with regards to your solution at the ML.

 From my side, due to already explained technical reasons, I nack the
current approach. I'm free to not comment it further, while there's
no new fact that would convince me otherwise.

Regards,
Mauro


