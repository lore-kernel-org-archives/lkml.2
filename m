Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab2C1Pzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 11:55:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51428 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab2C1Pzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 11:55:46 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.20.112]
In-Reply-To: <81C3A93C17462B4BBD7E272753C105792060C09F1D@EXDCVYMBSTM005.EQ1STM.local>
References: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
 <201112091442.04294.arnd@arndb.de> <81C3A93C17462B4BBD7E272753C105792060B42C9C@EXDCVYMBSTM005.EQ1STM.local>
 <201203221657.09820.arnd@arndb.de> <81C3A93C17462B4BBD7E272753C105792060C098E4@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbY+n_CESWCSiC5tAXTm+8CJVEd2TOa4H0-iVeeb1=3C9Q@mail.gmail.com> <81C3A93C17462B4BBD7E272753C105792060C09F1D@EXDCVYMBSTM005.EQ1STM.local>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 28 Mar 2012 17:55:25 +0200
Message-ID: <CAK=WgbaCysxO32y9zz0QuAdPysK2kU5p6SaQ4nFdcRyeWSyqhA@mail.gmail.com>
Subject: Re: Using remoteproc with ST-Ericsson modem.
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Wed, Mar 28, 2012 at 11:33 AM, Sjur BRENDELAND
<sjur.brandeland@stericsson.com> wrote:
> 1) Resource descriptors and parameters such as size of vring,
> size of the "carved-out" shared memory

We have that already today - the firmware controls these kind of
parameters (and more).

> as well as proprietary (CAIF specific) parameters

Not sure what exactly do you mean here - can you pls elaborate ?

> should be supported. These parameters
> must be available to the Virtio device-drivers

Virtio configuration is done via the virtio config space, which we
should already be supporting (untested though, because we didn't need
this yet).

> (CAIF interface),
> and to the modem. The resource/parameter configuration has to be
> stored in shared memory before booting the modem.

Yeah, this is what we do today with the resource table.

> 2a) The resource descriptors and configuration parameters are pre-
> formatted in the proprietary binary format.

What does mandate this proprietary binary format ? Can you just
directly use remoteproc's resource table format instead (i.e. an
extensible collection of type-value pairs) ?

> Remoteproc (or it's plugin)
> must then be able to parse this proprietary format, extract
> configuration parameters, and load the binary image into shared memory.
> OR
> 2b) Configuration parameters and firmware can be provided separately.
> The remoteproc (or it's plugin) must be able to format the provided
> configuration parameters in a proprietary format understood by the
> modem boot-loader and store the firmware and configuration in
> shared memory. A user-space API for configuration (e.g. netlink)
> must be supported.
> OR
> 2c) As in 2a, the image in proprietary format containing both firmware
> and parameters could be provided. In addition configuration parameters
> could be provided to remoteproc separately. The binary-image and
> configuration parameters will in this case hold identical configuration
> information. A user-space API for configuration (e.g. netlink)
> must be supported.
>
> In my case, the best solution seems to be 2a). I.e to parse parameters
> from the provided firmware, and avoid any extra configuration parameters
> provided from user-space. It seems to me we could do this by adding a
> callback function to remoteproc that parses the firmware and returns
> a resource table.

You have suggested several possible solutions, but I'd really prefer
to understand the problem first please :)

Can you please explain how do things work for you today ? binary
formats, image/configuration, how things boot/load/get-configured,
etc..

If I'll understand your requirements (hardware, relevant firmware code
which can't be changed and may impose the design, etc..) it will help
me find with you a suitable solution.

> However there might be new requirements we have in common such as:
> buffer pools with different fixed sized buffers, zero-copy handling of
> SKBs (TX), and DMA for (RX). Even if I end up not using rpmsg we should
> definitely look for opportunities for common code. I think we will be
> trying to solve the same type of problems.

The main thing that rpmsg provides over virtio is the multiplexing of
several channels/drivers over the same set of vrings and a simple API
for doing TX/RX.

If you think you will have to implement similar plumbing, then please
consider using rpmsg - it will save you time and effort (any other gap
that rpmsg does not yet provide can be easily solved - I wouldn't
worry about it).

OTOH, if you don't need that aforementioned plumbing, then directly
using virtio does have its merit of course.

Thanks,
Ohad.
