Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab1LIOmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:42:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab1LIOmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:42:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Subject: Re: [PATCH 0/9] XSHM: Shared Memory Driver for ST-E Thor M7400 LTE modem
Date: Fri, 9 Dec 2011 14:42:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>
References: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com> <201112071230.08019.arnd@arndb.de> <81C3A93C17462B4BBD7E272753C105791FB0D15949@EXDCVYMBSTM005.EQ1STM.local>
In-Reply-To: <81C3A93C17462B4BBD7E272753C105791FB0D15949@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112091442.04294.arnd@arndb.de>
X-Provags-ID: V02:K0:nreK3iacLv9swjPAW/TzTDM2dUwa1wIvo4vilyMFOTF
 ctA4MLAlFgVyRqT5rcqfV5ncKw/oOdOz5bDS2YxlLnkO82Erro
 XHuhGd83nO+TGzbW7fyOvTBs49fc11PVXfDrbU0YOdKrgp1qvL
 ajLuX2nMsLRD9MKD4YeCim6J76YPScRLTbJy6yBSyz8eUgpbFa
 GmUahcL6bwjNQpVVEiGQozfo5qsjAA0q2lg+UV0Oa4GIYs8uQg
 0aOQOOCOuW0d3M65G+7XrajMzwsfjVx7eJ7qFGmoriUj1vEMgQ
 XF+jwogZBWjN2kcc9bv5gd2Bb/GPsg8hqFyfdRHPaus9QzYQtA
 AWWYyvcOgoko1ugredj8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 December 2011, Sjur BRENDELAND wrote:

> > > Introduction:
> > > ~~~~~~~~~~~~~
> > > This patch-set introduces the Shared Memory Driver for ST-Ericsson's
> > > Thor M7400 LTE modem.
> > > The shared memory model is implemented for Chip-to-chip and
> > > uses a reserved memory area and a number of bi-directional
> > > channels. Each channel has it's own designated data area where
> > payload
> > > data is copied into.
> > 
> > Can you explain what the scope of this framework is? What I don't
> > understand from the code is whether this is meant to be very
> > broadly applicable to a lot of devices and competing with e.g.
> > rpmsg from Ohad Ben-Cohen, or whether this is really speciific
> > to one hardware implementation for caif.
> 
> This is primarily designed for supporting the ST-Ericsson's M7400 product
> and future modem platforms supporting shared memory.
> There are some parts with a rather tight coupling to the modem such as
> synchronization of the startup phases "ipc_ready" and "caif_ready" and
> how we store the 1st stage boot images in shared memory.
> However there are other concepts and parts of the implementation 
> that probably is possible to reuse.

Ok.

> > Also, to what degree is the protocol design flexible? Is the modem
> > side fixed, so you have to live with any shortcomings of the interface,
> > or are you at this point able to improve both sides when something
> > is found to be lacking?
> 
> As I see it, this interface to the modem is pretty much set, and isn't
> going to change a lot for the M7400 product.
> 
> However for the long term perspective: we expect this interface to evolve
> for future products, so suggestions and input for improvements is welcome.
> rpmsg or at least the use of virtio-ring combined with a true end-to-end
> zero copy is something we definitely are interested to look into for the
> future.

Is the rpmsg support something that can be done with the current low-level
protocol? It would be really nice if you could at least share some code
for the general infrastructure, even if both the underlying transport
and the high-level protocols are different.

> > > Two different channel types are defined, one stream channel which is
> > > implemented as a traditional ring-buffer, and a packet channel which
> > > is a ring-buffer of fix sized buffers where each buffer contains
> > > an array of CAIF frames.
> > >
> > > The notification of read and write index updates are handled in a
> > > separate driver called c2c_genio. This driver will be contributed
> > separately,
> > > but the API is included in this patch-set.
> > >
> > > The channel configuration is stored in shared memory, each channel
> > > has a designated area in shared memory for configuration data,
> > > read and write indexes and a data area.
> > 
> > How many channels will there be on of each type in a typical system,
> > and respectively in the maximum you can realistically expect over
> > the next 10 years?
> 
> Currently we have defined the following channels:
> 
> Ch#	Type		Used for				RX size	TX size
> ------------------------------------------------------------------
> 1	Stream	Modem Crash dump			64 kB		4 kB
> 2	Stream	Flash-less Boot Protocol	4 kB		256 kB
> 3	Stream	Boot Logging			8 kB		4kB
> 4	Packet	CAIF high speed 			8*16 kB	8*16kB
> 5	Packet	CAIF low latency			4*1kB		4*1kB
> 
> The modem is doing a multi stage boot, where it initially reads
> boot images stored in shared memory. This will boot-strap the
> 2nd boot stage where the Flash-less Boot Protocol is used.
> In this phase channel #2 and #3 is used. At this stage only a
> very basic OS-less runtime system is available, so CAIF protocol
> cannot be running on the modem.
> 
> When the 2nd boot stage is complete, channel #4 and #5 will be used.
> CAIF is a multiplexing protocol allowing multiple connections,
> so the reason for two channels is to be able to separate high
> throughput traffic such as IP + Logging from traffic with low-latency
> requirements such as control (e.g. AT commands) and audio.
> 
> In case of modem crash-dump the modem is running in OS-less mode, and 
> transfers dump over channel #1.
> 
> Initially I have implemented separate memory areas for
> the different channels and the initial boot images, however
> the channel specification and netlink interface supports
> overlapping channels. This is a possible future improvement.

ok

> > > Stream data
> > > ~~~~~~~~~~~
> > > The driver for the stream channel is implemented as a character device
> > > interface to user space. The character device implements non-blocking open
> > > and non-blocking IO in general. The character device is implementing
> > > a traditional circular buffer directly in the shared memory region for
> > > the channel.
> > 
> > It seems unusual to have both a socket interface and a character device
> > interface. What is the motivation behind this? Why can't you use the
> > socket for non-blocking I/O?
> 
> As mentioned above, the modem is in different run modes, stream device
> is only used when modem runs in OS-less mode, during boot or crash-dump.
> Except for boot and crash-dump the CAIF stack is used.
> A similar approach is used for HSI, where we use a bare
> HSI channel in OS-less mode, and CAIF over HSI otherwise.

My feeling is that a character device is not the ideal implementation here,
but I'm not sure what is. One option I can see is to declare the stream
interface part of the configuration logic and do everything through netlink,
packetizing the stream data in netlink frames. Alternatively, a tty port
device might be more appropriate than a plain chardev. Both of these
are likely a bit slower than what you have today, but my impression is that
performance is not the main design goal for the stream interface. If it is,
the best option would probably be to allow user space to mmap the buffer and
do the implementation in an application outside of the kernel.

	Arnd
