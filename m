Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab1LFPGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 10:06:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933430Ab1LFPGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 10:06:24 -0500
Message-ID: <4EDE2F61.301@redhat.com>
Date: Tue, 06 Dec 2011 13:06:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, HoP <jpetrous@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com> <4EDC9B17.2080701@gmail.com> <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com> <4EDD01BA.40208@redhat.com> <4EDD2C82.7040804@linuxtv.org> <20111205205554.2caeb496@lxorguk.ukuu.org.uk> <4EDD3583.30405@linuxtv.org> <20111206111829.GB17194@sirena.org.uk> <4EDE0400.1070304@linuxtv.org> <4EDE1457.7070408@redhat.com> <4EDE1A06.1060108@linuxtv.org> <4EDE22F0.30909@redhat.com> <4EDE28EB.7050407@linuxtv.org>
In-Reply-To: <4EDE28EB.7050407@linuxtv.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-12-2011 12:38, Andreas Oberritter wrote:
> On 06.12.2011 15:13, Mauro Carvalho Chehab wrote:
>> O_NONBLOCK
>>      When opening a FIFO with O_RDONLY or O_WRONLY set:
>                       ^^^^ This does not apply.
>
> [...]
>
>>      When opening a block special or character special file that supports
>> non-blocking opens:
>>
>>          If O_NONBLOCK is set, the open() function shall return without
>> blocking for the device to be ready or available. Subsequent behavior of
>> the device is device-specific.
>
> This is the important part:
> - It specifies the behaviour of open(), not ioctl(). I don't see a
> reason why open should block with vtunerc.
> - Read again: "Subsequent behavior of the device is device-specific."
>
>>          If O_NONBLOCK is clear, the open() function shall block the
>> calling thread until the device is ready or available before returning.
>>
>>      Otherwise, the behavior of O_NONBLOCK is unspecified.
>>
>> Basically, syscall should not block waiting for some data to be read (or
>> written).
>
> That's because open() does not read or write.
>
>> The ioctl definition defines [EAGAIN] error code, if, for any reason, an
>> ioctl would block.
>
> Fine.
>
>> Btw, the vtunerc doesn't handle O_NONBLOCK flag. For each DVB ioctl, for
>> example
>> read_snr[1], it calls wait_event_interruptible()[2], even if the
>> application opens
>> it with O_NONBLOCK flag. So, it is likely that non-blocking-mode
>> applications
>> will break.
>
> Of course, read operations must wait until the value read is available
> or an error (e.g. timeout, i/o error) occurs. Whether it's an i2c
> transfer, an usb transfer or a network transfer doesn't make a
> difference. Every transfer takes a nonzero amount of time.

Yes, posix is not 100% clear about what "non block" means for ioctl's, but
waiting for an event is clearly a block condition. This is different than
doing something like mdelay() (or even mleep()) in order to wait for an
specific amount of time for an operation to complete.

A vtunerc => daemon => network transfer =>daemon => vtunerc is a block condition,
as the network may return in a few ms or may not return and a long
timeout at the daemon would give an error. Also, as the daemon may be swapped
to disk (as the daemon runs on userspace), this may even involve other
blocking operations at the block layer.

> As Honza already demonstrated, in a typical LAN setup, this takes only
> few milliseconds, which with fast devices may even be faster than some
> slow local devices using many delays in their driver code.
>
> If an application breaks because of that, then it's a bug in the
> application which may as well be triggered by a local driver and thus
> needs to be fixed anyway.

It is not a bug in the application. It requested a non-block mode. The driver
is working in block mode instead. It is a driver's bug.

>>> Mauro, if the network is broken, any application using the network will
>>> break. No specially designed protocol will fix that.
>>
>> A high delay network (even a congested one) is not broken, if it can
>> still provide the throughput required by the application, and a latency/QoS
>> that would fit.
>
> Then neither vtunerc nor any other application will break. Fine.
>
>>> If you want to enforce strict maximum latencies, you can do that in the
>>> userspace daemon using the vtunerc interface. It has all imaginable
>>> possibilities to control data flow over the network and to return errors
>>> to vtunerc.
>>
>> Yes, you can do anything you want at the userspace daemon, but the
>> non-userspace daemon aware applications will know nothing about it, and
>> this is the flaw on this design: Applications can't negotiate what network
>> parameters are ok or not for its usecase.
>
> How do you negotiate network parameters with your ISP and all involved
> parties on the internet on the way from your DSL line to some other
> peer? Let me answer it: You don't.

TCP flow control mechanisms, RSVP, MPLS, IP QoS flags, ICMP messages, etc.

>>> For a DVB API application it doesn't matter whether a tuning
>>> request fails with EIO because a USB device has been removed, a PCI
>>> device encountered an I2C error or because the vtuner userspace daemon
>>> returned an error.
>>
>> When you go to network, there are several errors that are transitory.
>> For example,
>> a dropped link may cause the routing protocol (RIP, BGP or whatever) to
>> re-direct
>> several routes (or, on a LAN, a spanning-tree re-negotiation), causing a
>> temporary
>> failure to deliver a few packets. All network-based application are written
>> to consider temporary failures.
>
> I seriously doubt that, unless "consider" means "print an error and
> exit" or "all" means "some".
> Anyway, such temporary failures can be handled by the userspace daemon.
>
>> This is fundamentally different than an application designed to talk
>> directly with
>> the hardware, where an error is generally fatal.
>
> Fatal or not, if you return a temporary error code like EAGAIN, for
> example, that's not the case.
>
> Do you recommend applications to just die if an ioctl fails?

Network applications (Youtube, Skype, mplayer, you name it) have
mechanisms to handle high delays, congestion, etc. Cheating with a non-network
application to work via the network is not the same as a network-based application.
You'll never achieve the same result. Only if the network is close to a
"pure wire" (e. g., no congestion, no packet loss, etc), such solution
works.

> Btw.: How do you handle firmware uploads via I2C in non-blocking mode?
> Should applications always fail if a firmware upload that takes longer
> than some ms, e.g. when tuning to a different delivery system or when
> the firmware is yet to be loaded before the first ioctl may run?

The right thing to do is to return -EAGAIN for all syscalls while the firmware
is not loaded. Unfortunately, several driversdon't do the right thing.

Regards,
Mauro.
