Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030996Ab2CVQ5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 12:57:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60049 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2CVQ5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 12:57:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Subject: Re: [PATCH 0/9] XSHM: Shared Memory Driver for ST-E Thor M7400 LTE modem
Date: Thu, 22 Mar 2012 16:57:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>,
        "Ohad Ben-Cohen" <ohad@wizery.com>
References: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com> <201112091442.04294.arnd@arndb.de> <81C3A93C17462B4BBD7E272753C105792060B42C9C@EXDCVYMBSTM005.EQ1STM.local>
In-Reply-To: <81C3A93C17462B4BBD7E272753C105792060B42C9C@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203221657.09820.arnd@arndb.de>
X-Provags-ID: V02:K0:1/TRBfEVRKcZec8Fa7IVqWF4iOeL4Q/JiWccdMVG+89
 ZGex1Mq3SemDni5gh2zsuNfoEfckS/sh/3IqqQTXDDm3lQ3GbK
 AQ0KUZiTCtmOLSk9ZQ4YizHhCVTdsaEoVYSZ1G3mDRTFj6B/0j
 5jq6XmRXyC5daJflBnD8Af4Q6jFbmqntv8JGu/eRTde1lyUUxy
 6pcLcR1hjsBpGpv3roRkMuYq8187Y8mXfNNiGMCmbiIZgt+f5i
 vzrlAspsFGbJ6BO8d0cqaoCcIccfOQOQ6y+kvv/c0e4kBd8q19
 SBgvAjPxZ2aZW7rzpnijTpxsvwKf8SrWJCR+ToHey1YprGbX//
 YmaFxftW7zJ4K+Doy5ok=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 March 2012, Sjur BRENDELAND wrote:
> Hi Arnd,
> 
> I've got some updates since my last reply from December...
> 
> [Arnd]
> >>> Also, to what degree is the protocol design flexible? Is the modem
> >>> side fixed, so you have to live with any shortcomings of the interface,
> >>> or are you at this point able to improve both sides when something
> >>> is found to be lacking?
> 
> I have started working on the next generation shared memory interface for
> ST-Ericsson modems. So the interface design is now flexible! This means that
> I can be open to input and new ideas, at least for the next month or two.
> I'm hoping (if time allows) to prototype and post some patches while working
> on the specification.

Ok, very good.

> [Sjur]
> >> However for the long term perspective: we expect this interface to evolve
> >> for future products, so suggestions and input for improvements is welcome.
> >> rpmsg or at least the use of virtio-ring combined with a true end-to-end
> >> zero copy is something we definitely are interested to look into for the
> >> future.
> 
> My current idea for the new interface design is to use Virtio channels for
> transporting CAIF frames. The CAIF interface could be implemented as a
> virtio-driver using separate RX and TX rings.
> 
> For uplink traffic (TX) we could (initially) copy SKB into a buffer located in
> the shared-memory area, and add the buffer to the Virtio-ring. We will need
> to manage a fixed size buffer pool of uplink data buffers. (I don't think we
> will be able to access the kernel memory from the modem, so I cannot put SKB
> content directly on the virtio-ring as virtio-net does)
> 
> For Downlink payload (RX) I'm planning on using a reversed virtio-ring.
> The modem has its own sophisticated memory allocator for payload and
> implements mechanisms for efficient buffer handling inside the modem.
> The modem could add the payload buffer on the virtual-ring without
> copying and kick the host.

Remoteproc and rpmsg are now in the arm-soc tree and will be merged
upstream for v3.4, I suggest you discuss with Ohad how to best hook in
there.

What is the limitation for the addressing here, i.e. why can't the
modem access all of the host memory?

> [Sjur:]
> >>>> The driver for the stream channel is implemented as a character device
> ...
> [Arnd:]
> > My feeling is that a character device is not the ideal implementation here,
> > but I'm not sure what is. One option I can see is to declare the stream
> > interface part of the configuration logic and do everything through netlink,
> > packetizing the stream data in netlink frames. Alternatively, a tty port
> > device might be more appropriate than a plain chardev. Both of these
> > are likely a bit slower than what you have today, but my impression is that
> > performance is not the main design goal for the stream interface. If it is,
> > the best option would probably be to allow user space to mmap the buffer and
> > do the implementation in an application outside of the kernel.
> 
> For the stream interface it's tempting to reuse the ring buffer interface
> to the modem from last time. But perhaps the Virtio-console could be as the
> user-space interface, with a slim virtual device underneath feeding data
> from the ring-buffer into a virtual-ring...?

sounds doable, but again Ohad may have better suggestions as well.

	Arnd
