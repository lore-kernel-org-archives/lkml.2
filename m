Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400Ab1LFONW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:13:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933255Ab1LFONT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:13:19 -0500
Message-ID: <4EDE22F0.30909@redhat.com>
Date: Tue, 06 Dec 2011 12:13:04 -0200
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
References: <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com> <4EDC9B17.2080701@gmail.com> <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com> <4EDD01BA.40208@redhat.com> <4EDD2C82.7040804@linuxtv.org> <20111205205554.2caeb496@lxorguk.ukuu.org.uk> <4EDD3583.30405@linuxtv.org> <20111206111829.GB17194@sirena.org.uk> <4EDE0400.1070304@linuxtv.org> <4EDE1457.7070408@redhat.com> <4EDE1A06.1060108@linuxtv.org>
In-Reply-To: <4EDE1A06.1060108@linuxtv.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-12-2011 11:35, Andreas Oberritter wrote:
> On 06.12.2011 14:10, Mauro Carvalho Chehab wrote:
>> On 06-12-2011 10:01, Andreas Oberritter wrote:
>>> On 06.12.2011 12:18, Mark Brown wrote:
>>>> On Mon, Dec 05, 2011 at 10:20:03PM +0100, Andreas Oberritter wrote:
>>>>> On 05.12.2011 21:55, Alan Cox wrote:
>>>>>> The USB case is quite different because your latency is very tightly
>>>>>> bounded, your dead device state is rigidly defined, and your loss of
>>>>>> device is accurately and immediately signalled.
>>>>
>>>>>> Quite different.
>>>>
>>>>> How can usbip work if networking and usb are so different and what's so
>>>>> different between vtunerc and usbip, that made it possible to put usbip
>>>>> into drivers/staging?
>>>>
>>>> USB-IP is a hack that will only work well on a tightly bounded set of
>>>> networks - if you run it over a lightly loaded local network it can
>>>> work adequately.  This starts to break down as you vary the network
>>>> configuration.
>>>
>>> I see. So it has problems that vtunerc doesn't have.
>>
>> The vtunerc has the same issues. High latency (due to high loads,  high
>> latency links or whatever) affects it badly, and may cause application
>> breakages if if the device is opened are using O_NONBLOCK mode [1].
>
> O_NONBLOCK doesn't mean that an ioctl must consume zero time. It just
> means that it should return instead of waiting for (more) data to become
> available or writeable.

O_NONBLOCK means (http://pubs.opengroup.org/onlinepubs/9699919799/functions/open.html#tag_16_412):


O_NONBLOCK
     When opening a FIFO with O_RDONLY or O_WRONLY set:

         If O_NONBLOCK is set, an open() for reading-only shall return without delay. An open() for writing-only shall return an error if no process currently has the file open for reading.

         If O_NONBLOCK is clear, an open() for reading-only shall block the calling thread until a thread opens the file for writing. An open() for writing-only shall block the calling thread until a thread opens the file for reading.

     When opening a block special or character special file that supports non-blocking opens:

         If O_NONBLOCK is set, the open() function shall return without blocking for the device to be ready or available. Subsequent behavior of the device is device-specific.

         If O_NONBLOCK is clear, the open() function shall block the calling thread until the device is ready or available before returning.

     Otherwise, the behavior of O_NONBLOCK is unspecified.

Basically, syscall should not block waiting for some data to be read (or written).
The ioctl definition defines [EAGAIN] error code, if, for any reason, an
ioctl would block.

Btw, the vtunerc doesn't handle O_NONBLOCK flag. For each DVB ioctl, for example
read_snr[1], it calls wait_event_interruptible()[2], even if the application opens
it with O_NONBLOCK flag. So, it is likely that non-blocking-mode applications
will break.

[1] http://code.google.com/p/vtuner/source/browse/vtunerc_proxyfe.c?repo=linux-driver#75
[2] http://code.google.com/p/vtuner/source/browse/vtunerc_ctrldev.c?repo=linux-driver#420

> Mauro, if the network is broken, any application using the network will
> break. No specially designed protocol will fix that.

A high delay network (even a congested one) is not broken, if it can
still provide the throughput required by the application, and a latency/QoS
that would fit.

> If you want to enforce strict maximum latencies, you can do that in the
> userspace daemon using the vtunerc interface. It has all imaginable
> possibilities to control data flow over the network and to return errors
> to vtunerc.

Yes, you can do anything you want at the userspace daemon, but the
non-userspace daemon aware applications will know nothing about it, and
this is the flaw on this design: Applications can't negotiate what network
parameters are ok or not for its usecase.

> For a DVB API application it doesn't matter whether a tuning
> request fails with EIO because a USB device has been removed, a PCI
> device encountered an I2C error or because the vtuner userspace daemon
> returned an error.

When you go to network, there are several errors that are transitory. For example,
a dropped link may cause the routing protocol (RIP, BGP or whatever) to re-direct
several routes (or, on a LAN, a spanning-tree re-negotiation), causing a temporary
failure to deliver a few packets. All network-based application are written
to consider temporary failures.

This is fundamentally different than an application designed to talk directly with
the hardware, where an error is generally fatal.

>> [1] Btw, if some DVB ioctl currently waits in O_NONBLOCK, this is a POSIX
>> violation that needs to be fixed.
>
> To the best of my knowledge, this doesn't happen.
>
> I think we all realized some days ago that the code is not going to be
> merged upstream anytime in the foreseeable future. You can stop using
> such pointless arguments.

Agreed.

Regards,
Mauro
