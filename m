Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab2C1Rbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 13:31:34 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:49838 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758582Ab2C1Rbc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 13:31:32 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>
Date: Wed, 28 Mar 2012 19:31:17 +0200
Subject: RE: Using remoteproc with ST-Ericsson modem.
Thread-Topic: Using remoteproc with ST-Ericsson modem.
Thread-Index: Ac0M+z6hZp6ueBX/TNmoyA93MZ0aYQAAc6Dw
Message-ID: <81C3A93C17462B4BBD7E272753C105792060C0A318@EXDCVYMBSTM005.EQ1STM.local>
References: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
 <201112091442.04294.arnd@arndb.de>
 <81C3A93C17462B4BBD7E272753C105792060B42C9C@EXDCVYMBSTM005.EQ1STM.local>
 <201203221657.09820.arnd@arndb.de>
 <81C3A93C17462B4BBD7E272753C105792060C098E4@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbY+n_CESWCSiC5tAXTm+8CJVEd2TOa4H0-iVeeb1=3C9Q@mail.gmail.com>
 <81C3A93C17462B4BBD7E272753C105792060C09F1D@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbaCysxO32y9zz0QuAdPysK2kU5p6SaQ4nFdcRyeWSyqhA@mail.gmail.com>
In-Reply-To: <CAK=WgbaCysxO32y9zz0QuAdPysK2kU5p6SaQ4nFdcRyeWSyqhA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

> We have that already today - the firmware controls these kind of
> parameters (and more).
> 
> > as well as proprietary (CAIF specific) parameters
> 
> Not sure what exactly do you mean here - can you pls elaborate ?

Yes, we store MTU and alignment information. We also use a special
register for generating interrupts/kicks in each rx/tx direction.
The modem needs to know what bit is assigned to each channel.
See struct shm_ipctoc_channel below.

> Virtio configuration is done via the virtio config space, which we
> should already be supporting (untested though, because we didn't need
> this yet).

Hm, my impression was that Virtio only supported single bits for
configuration information.

> > (CAIF interface),
> > and to the modem. The resource/parameter configuration has to be
> > stored in shared memory before booting the modem.
> 
> Yeah, this is what we do today with the resource table.
>
> > 2a) The resource descriptors and configuration parameters are pre-
> > formatted in the proprietary binary format.
> 
> What does mandate this proprietary binary format ? Can you just
> directly use remoteproc's resource table format instead (i.e. an
> extensible collection of type-value pairs) ?

I'm afraid not. I cannot change the layout for the modem boot loader.
The boot image start with a "table of contents" defining the content
of the image. At the start of the shared memory are there needs to
be structure like this: (see https://lkml.org/lkml/2012/1/11/165)
[snip]
/**
 * struct toc_entry - Points out the boot images
 *
 * @start: Offset counting from start of memory area to the image data.
 * @size:  Size of the images in bytes.
 * @flags: Use 0 if no flags are in use.
 * @entry: Where to jump to start exeuting. Only applicable
 *		when using SDRAM. Set to 0xffffffff if unused.
 * @load_addr: Location in SDRAM to move image. Set to 0xffffffff if
 *		not applicable.
 * @name: Name of image.
 */
struct toc_entry {
	__le32 start;
	__le32 size;
	__le32 flags;
	__le32 entry_point;
	__le32 load_addr;
	char name[12];
};

Currently this will be a table with two entries, one entry pointing at the
binary image, and one entry pointing at the IPC-TOC.

[snip]
/**
 * struct shm_ipctoc_channel - Channel descriptors.
 *
 * @offset: Relative address to channel data area.
 * @size: Total size of a SHM channel area partition.
 * @mode: Mode of channel: Packet mode=1, Stream mode (mode = 2).
 * @buffers: Number of buffers for the channel.
 * @ipc: Offset to IPC message location (of type struct shm_bufidx).
 * @read_bit: GENI/O bit used to indicate update of the read pointer for
 *	this channel (at offset ipc).
 * @write_bit: GENI/O bit used to indicate update of the write pointer for
 *	this channel (at offset ipc).
 * @alignment: Protocol specific options for the protocol,
 *	e.g. packet alignment.
 * @packets: Maximum Number of packets in a buffer (packet mode).
 * @mtu: Maximum Transfer Unit for packets in a buffer (packet mode).
 *
 * This struct defines the channel configuration for a single direction.
 *
 * This structure is pointed out by the &shm_toc and is written by
 * host during start-up and read by modem at firmware boot.
 */
struct shm_ipctoc_channel {
	__le32 offset;
	__le32 size;
	__u8 mode;
	__le32 buffers;
	__le32 ipc;
	__le16 read_bit;
	__le16 write_bit;
	__u8 alignment;
	__u8 packets;
	__u16 mtu;
};

Part of this shm_ipctoc_shannel will have to change when we move from using
ring-buffers to virtio-ring for communication. So this part is not set in
stone. If needed we could do some layout changes here.

> You have suggested several possible solutions, but I'd really prefer
> to understand the problem first please :)
> 
> Can you please explain how do things work for you today ? binary
> formats, image/configuration, how things boot/load/get-configured,
> etc..
> If I'll understand your requirements (hardware, relevant firmware code
> which can't be changed and may impose the design, etc..) it will help
> me find with you a suitable solution.

Sure, I'll try to explain the current solution 
(see https://lkml.org/lkml/2012/1/11/161):

We have a user-space component controlling most of the modem boot sequence.
This component keeps track of the firmware and corresponding
configuration. It also manages life-cycle start/stop/restart, and
different run-modes etc.

The startup sequence run something like this (simplified).
a) configuration data related to channels are sent from user-space
   to the kernel module modem_shm via gen-netlink 
   (see https://lkml.org/lkml/2012/1/11/162)
b) The firmware image (containing TOC and the executable) is sent to
   kernel via firmware framework.
c) when all channels have been sent to modem_shm, configuration data
   for each channel is processed and location of each channel in
   shared memory is calculated. The "kick" bits are also assigned
   to each channel.
d) The modem-image starts with a table (TOC). A new pointer to a 
   IPC-TOC containing channel configuration is added to the TOC.
   The executable and channel configuration needed by the modem
   is stored in shared memory.
   (See https://lkml.org/lkml/2012/1/11/167)
e) devices for the different channels are instantiated. Each device
   is given similar configuration information to what is store in
   shared memory. (See https://lkml.org/lkml/2012/1/11/163)
f) User space turns the modem ON, and boots using the initial 
   firmware from shared-memory.
g) modem's boot stage-2 starts, additional modem binaries are loaded
   using stream channels.
h) when boot stage-2 is complete, the CAIF device is enabled.


The current memory layout is something like this:
+------------+
|	TOC	 |----+
|            |--+ |
+------------+  | |
| Boot IMG	 |<-+ |
+------------+    |
| RX Data	 |    |
+------------+    |
| IPC TOC	 |<---+
+------------+
| RX Ch Decr |
+------------+
| TX Ch Decr |
+------------+
| TX Data	 |
+------------+

(sorry for this figure, my MSFT mail usually mess up things badly...)

 
> > However there might be new requirements we have in common such as:
> > buffer pools with different fixed sized buffers, zero-copy handling
> of
> > SKBs (TX), and DMA for (RX). Even if I end up not using rpmsg we
> should
> > definitely look for opportunities for common code. I think we will be
> > trying to solve the same type of problems.
> 
> The main thing that rpmsg provides over virtio is the multiplexing of
> several channels/drivers over the same set of vrings and a simple API
> for doing TX/RX.

This is the same thing CAIF does, so multiplexing is not something I'm
looking for.

> If you think you will have to implement similar plumbing, then please
> consider using rpmsg - it will save you time and effort (any other gap
> that rpmsg does not yet provide can be easily solved - I wouldn't
> worry about it).

I like the attitude :-), what new features have you planned for rpmsg?

> OTOH, if you don't need that aforementioned plumbing, then directly
> using virtio does have its merit of course.

Yes, I tend to think I should use virtio directly, but I have not made up
mind. I'll probably come back to this later.

Regards,
Sjur
