Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab1LGPpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 10:45:15 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:59489 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755803Ab1LGPpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 10:45:11 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>
Date: Wed, 7 Dec 2011 16:44:49 +0100
Subject: RE: [PATCH 0/9] XSHM: Shared Memory Driver for ST-E Thor M7400 LTE
 modem
Thread-Topic: [PATCH 0/9] XSHM: Shared Memory Driver for ST-E Thor M7400 LTE
 modem
Thread-Index: Acy02/fqjDz9clrGTzmPTt4Dbyo8PQAF2ZmQ
Message-ID: <81C3A93C17462B4BBD7E272753C105791FB0D15949@EXDCVYMBSTM005.EQ1STM.local>
References: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
 <201112071230.08019.arnd@arndb.de>
In-Reply-To: <201112071230.08019.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pB7FjNPj022260

Hi Arnd,

> I've tried to do a review of your code, but I really need to understand
> more of the background first, to be able to tell if it's using the
> right high-level approach. There are a lot of details I could
> comment on, but let's first look at the overall design.

Ok great, looking forward to hearing your feedback.
 
> > Introduction:
> > ~~~~~~~~~~~~~
> > This patch-set introduces the Shared Memory Driver for ST-Ericsson's
> > Thor M7400 LTE modem.
> > The shared memory model is implemented for Chip-to-chip and
> > uses a reserved memory area and a number of bi-directional
> > channels. Each channel has it's own designated data area where
> payload
> > data is copied into.
> 
> Can you explain what the scope of this framework is? What I don't
> understand from the code is whether this is meant to be very
> broadly applicable to a lot of devices and competing with e.g.
> rpmsg from Ohad Ben-Cohen, or whether this is really speciific
> to one hardware implementation for caif.

This is primarily designed for supporting the ST-Ericsson's M7400 product
and future modem platforms supporting shared memory.
There are some parts with a rather tight coupling to the modem such as
synchronization of the startup phases "ipc_ready" and "caif_ready" and
how we store the 1st stage boot images in shared memory.
However there are other concepts and parts of the implementation 
that probably is possible to reuse.

> Also, to what degree is the protocol design flexible? Is the modem
> side fixed, so you have to live with any shortcomings of the interface,
> or are you at this point able to improve both sides when something
> is found to be lacking?

As I see it, this interface to the modem is pretty much set, and isn't
going to change a lot for the M7400 product.

However for the long term perspective: we expect this interface to evolve
for future products, so suggestions and input for improvements is welcome.
rpmsg or at least the use of virtio-ring combined with a true end-to-end
zero copy is something we definitely are interested to look into for the
future.

> > Two different channel types are defined, one stream channel which is
> > implemented as a traditional ring-buffer, and a packet channel which
> > is a ring-buffer of fix sized buffers where each buffer contains
> > an array of CAIF frames.
> >
> > The notification of read and write index updates are handled in a
> > separate driver called c2c_genio. This driver will be contributed
> separately,
> > but the API is included in this patch-set.
> >
> > The channel configuration is stored in shared memory, each channel
> > has a designated area in shared memory for configuration data,
> > read and write indexes and a data area.
> 
> How many channels will there be on of each type in a typical system,
> and respectively in the maximum you can realistically expect over
> the next 10 years?

Currently we have defined the following channels:

Ch#	Type		Used for				RX size	TX size
------------------------------------------------------------------
1	Stream	Modem Crash dump			64 kB		4 kB
2	Stream	Flash-less Boot Protocol	4 kB		256 kB
3	Stream	Boot Logging			8 kB		4kB
4	Packet	CAIF high speed 			8*16 kB	8*16kB
5	Packet	CAIF low latency			4*1kB		4*1kB

The modem is doing a multi stage boot, where it initially reads
boot images stored in shared memory. This will boot-strap the
2nd boot stage where the Flash-less Boot Protocol is used.
In this phase channel #2 and #3 is used. At this stage only a
very basic OS-less runtime system is available, so CAIF protocol
cannot be running on the modem.

When the 2nd boot stage is complete, channel #4 and #5 will be used.
CAIF is a multiplexing protocol allowing multiple connections,
so the reason for two channels is to be able to separate high
throughput traffic such as IP + Logging from traffic with low-latency
requirements such as control (e.g. AT commands) and audio.

In case of modem crash-dump the modem is running in OS-less mode, and 
transfers dump over channel #1.

Initially I have implemented separate memory areas for
the different channels and the initial boot images, however
the channel specification and netlink interface supports
overlapping channels. This is a possible future improvement.

> > Stream data
> > ~~~~~~~~~~~
> > The driver for the stream channel is implemented as a character device
> > interface to user space. The character device implements non-blocking open
> > and non-blocking IO in general. The character device is implementing
> > a traditional circular buffer directly in the shared memory region for
> > the channel.
> 
> It seems unusual to have both a socket interface and a character device
> interface. What is the motivation behind this? Why can't you use the
> socket for non-blocking I/O?

As mentioned above, the modem is in different run modes, stream device
is only used when modem runs in OS-less mode, during boot or crash-dump.
Except for boot and crash-dump the CAIF stack is used.
A similar approach is used for HSI, where we use a bare
HSI channel in OS-less mode, and CAIF over HSI otherwise.

> > Driver model
> > ~~~~~~~~~~~~~~
> > Current implementation is using the platform bus for XSHM devices.
> > The packet channels are named "xshmp", and stream channel "xshms".
> >
> > /sys/devices:
> > |-- platform
> > |   |-- uevent
> > |   `-- xshm
> > |       |-- bootimg
> > |       |-- caif_ready
> > |       |-- ipc_ready
> > |       |-- subsystem -> ../../../bus/platform
> > |       |-- xshmp.1
> > |       |   |-- driver -> ../../../../bus/platform/drivers/xshmp
> > |       |   |-- subsystem -> ../../../../bus/platform
> > |       `-- xshms.0
> > |           |-- driver -> ../../../../bus/platform/drivers/xshms
> > |           |-- misc
> > |           |   `-- xshm0
> > |           |       |-- device -> ../../../xshms.0
> > |           |       |-- subsystem -> ../../../../../../class/misc
> > `-- virtual
> >     |-- net
> >     |   |-- cfshm0
> 
> Why are the channels /platform/ devices? With all the infrastructure
> you have in the xshm driver, I would think that you should be
> able to probe the available channels yourself instead of relying the
> board to define them.

OK point taken. Using the platform bus, was just share laziness as it
provides a simple way of creating device and drivers. I will look into
creating a separate bus.

Regards,
Sjur

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
