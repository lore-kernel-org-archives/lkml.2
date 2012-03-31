Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab2CaVZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 17:25:21 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48417 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753203Ab2CaVZE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 17:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAK=WgbYz7_syim+LoTM-6MLJ=_8tsEuDQ+=fwOTfzOriPrMAEw@mail.gmail.com>
References: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
	<201112091442.04294.arnd@arndb.de>
	<81C3A93C17462B4BBD7E272753C105792060B42C9C@EXDCVYMBSTM005.EQ1STM.local>
	<201203221657.09820.arnd@arndb.de>
	<81C3A93C17462B4BBD7E272753C105792060C098E4@EXDCVYMBSTM005.EQ1STM.local>
	<CAK=WgbY+n_CESWCSiC5tAXTm+8CJVEd2TOa4H0-iVeeb1=3C9Q@mail.gmail.com>
	<81C3A93C17462B4BBD7E272753C105792060C09F1D@EXDCVYMBSTM005.EQ1STM.local>
	<CAK=WgbaCysxO32y9zz0QuAdPysK2kU5p6SaQ4nFdcRyeWSyqhA@mail.gmail.com>
	<81C3A93C17462B4BBD7E272753C105792060C0A318@EXDCVYMBSTM005.EQ1STM.local>
	<CAK=WgbYz7_syim+LoTM-6MLJ=_8tsEuDQ+=fwOTfzOriPrMAEw@mail.gmail.com>
Date: Sat, 31 Mar 2012 23:25:03 +0200
Message-ID: <CAJK669ZN8F6DCeHG_UEJNiCb=1ADCUGdy3EsMA=JC-Nj-Kb5Tg@mail.gmail.com>
Subject: Re: Using remoteproc with ST-Ericsson modem.
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

> You probably refer to virtio's features bitmap, which is how virtio
> peers synchronize the features they both support.
>
> Virtio also supports device-specific variable-length configuration
> fields - take a look at struct virtio_config_ops (get/set in
> particular).

Ok, that's good.

>> I'm afraid not. I cannot change the layout for the modem boot loader.
>> The boot image start with a "table of contents" defining the content
>> of the image.
>
> What binary format is the boot image itself ? ELF ? something else ?

Not sure, I have to check and come back to you on that...

>> The current memory layout is something like this:
>> +------------+
>> |       TOC      |----+
>> |            |--+ |
>> +------------+  | |
>> | Boot IMG       |<-+ |
>> +------------+    |
>> | RX Data        |    |
>> +------------+    |
>> | IPC TOC        |<---+
>> +------------+
>> | RX Ch Decr |
>> +------------+
>> | TX Ch Decr |
>> +------------+
>> | TX Data        |
>> +------------+
>
> Which parts of this are set in stone ? only the TOC or additional
> regions as well ?

The TOC and executable Boot image is set in stone.
The rest of this could be changed. Some of this must be
changed due to new zero-copy features and use of virtio-rings
for CAIF anyway.

>> This is the same thing CAIF does, so multiplexing is not something I'm
>> looking for.
>
> I saw you created an SHM bus, which matches SHM drivers to SHM devices
> (i.e. channels). I guess you did that because you have some code in
> common which all SHM drivers/devices use ? maybe some low level
> transport layer ?

Yes, On the "device" level, the code in shm_dev.c and genio_* is common
This code deals with startup synchronisation, generating kicks for RX/TX,
and also the PM related inactivity timer in order to power down interfaces
when not in use. If/When I start using the remoteproc framework, I will
probably move some of the functionality from shm_dev.c in on the
remoteproc device level (e.g. new file: modem_shm_remoteproc.c)

The code in shm_boot.c is mainly dealing with configuration, it terminates
the gen-netlink socket and calculates and writes configuration data in memory,
and creates the devices (to some extent similar functionality to remoteproc).
It would be nice to find the best way to use remoteproc framework for some
of this functionality currently implemented in shm_boot.c.

> This sounds similar to rpmsg in hindsight, but I couldn't find yet the
> relevant code to really tell: Most of shm_bus.c looks like very
> minimal boilerplate bus code. Maybe the genio_* API is the shared code
> (though I could only find a dummy version of that API in linux next) ?

genio_* is the interface towards the underlying C2C HW driver. We have
unfortunately not yet started contribution of this component.

>> I like the attitude :-), what new features have you planned for rpmsg?
>
> Anything you need :)
>
> Some of the obvious stuff might be zero copy I/O, user space API,
> static channel configuration, runtime PM, recovery, etc.. (there's
> more). Sometimes it's a pure rpmsg feature, and sometimes it's
> involved with remoteproc.
>
> But we really just evolve according to requirements - we don't have a
> rigid roadmap.

Good stuff. One question from top of my mind: Have you considered
option of using rpmsg without the protocol, eg something like
RPMSG_RAW, where I can take advantage of rpmsg transport features
without needing the muxing feature. Then I could use CAIF muxing layer
without the rpmsg protocol and naming services....?

>> Yes, I tend to think I should use virtio directly, but I have not made up
>> mind. I'll probably come back to this later.
>
> What's the vrings layout you will be using (off the top of your head)
> ? Separate vrings per driver/device or shared vrings ?

In normal operation after boot, we will only use CAIF link layer device.
CAIF will handle the multiplexing. I was thinking of using one vring in
each direction RX/TX and reversing the vring for RX direction.

For the stream channels we use three pairs of ring-buffers at the
moment. I really haven't made up my mind on how to do this. But doing
the transport with plain ringbuffers is really quite straight forward, so one
option is to keep this as is, but use tty instead of the misc device framework.
Another option is using virtio_console, but I realise virtio_console is doing
normal kmalloc so memory handling in virtio_console would have to change
then. (I have a memory addressing issue, so modem cannot access all
kernel memory).

Or I could look into feeding data from the existing ringbuffers into the
vrings of virtio_console. Then I could reuse both modem implementation of
ringbuffers and virtion_console without changes.

Yet another option is using rpmsg. In that case I think one pair of
virings would be sufficient for the three streams.


The current channel allocation is like this:
Ch# Type Used for RX size TX size
------------------------------------------------------------------
1 Stream Modem Crash dump 64 kB 4 kB
2 Stream Flash-less Boot Protocol 4 kB 256 kB
3 Stream Boot Logging 8 kB 4kB
4 Packet CAIF high speed 8*16 kB 8*16kB
[5 Packet CAIF low latency 4*1kB 4*1kB]

#5 is probably going to be removed.

Regards,
Sjur
