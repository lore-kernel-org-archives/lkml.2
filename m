Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab2CaTFE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 15:05:04 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62617 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab2CaTFC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 15:05:02 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.20.112]
In-Reply-To: <81C3A93C17462B4BBD7E272753C105792060C0A318@EXDCVYMBSTM005.EQ1STM.local>
References: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
 <201112091442.04294.arnd@arndb.de> <81C3A93C17462B4BBD7E272753C105792060B42C9C@EXDCVYMBSTM005.EQ1STM.local>
 <201203221657.09820.arnd@arndb.de> <81C3A93C17462B4BBD7E272753C105792060C098E4@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbY+n_CESWCSiC5tAXTm+8CJVEd2TOa4H0-iVeeb1=3C9Q@mail.gmail.com>
 <81C3A93C17462B4BBD7E272753C105792060C09F1D@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbaCysxO32y9zz0QuAdPysK2kU5p6SaQ4nFdcRyeWSyqhA@mail.gmail.com> <81C3A93C17462B4BBD7E272753C105792060C0A318@EXDCVYMBSTM005.EQ1STM.local>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 31 Mar 2012 22:04:41 +0300
Message-ID: <CAK=WgbYz7_syim+LoTM-6MLJ=_8tsEuDQ+=fwOTfzOriPrMAEw@mail.gmail.com>
Subject: Re: Using remoteproc with ST-Ericsson modem.
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Wed, Mar 28, 2012 at 7:31 PM, Sjur BRENDELAND
<sjur.brandeland@stericsson.com> wrote:
> Hm, my impression was that Virtio only supported single bits for
> configuration information.

You probably refer to virtio's features bitmap, which is how virtio
peers synchronize the features they both support.

Virtio also supports device-specific variable-length configuration
fields - take a look at struct virtio_config_ops (get/set in
particular).

> I'm afraid not. I cannot change the layout for the modem boot loader.
> The boot image start with a "table of contents" defining the content
> of the image.

What binary format is the boot image itself ? ELF ? something else ?

> The startup sequence run something like this (simplified).
> a) configuration data related to channels are sent from user-space
>   to the kernel module modem_shm via gen-netlink
>   (see https://lkml.org/lkml/2012/1/11/162)
> b) The firmware image (containing TOC and the executable) is sent to
>   kernel via firmware framework.
> c) when all channels have been sent to modem_shm, configuration data
>   for each channel is processed and location of each channel in
>   shared memory is calculated. The "kick" bits are also assigned
>   to each channel.
> d) The modem-image starts with a table (TOC). A new pointer to a
>   IPC-TOC containing channel configuration is added to the TOC.
>   The executable and channel configuration needed by the modem
>   is stored in shared memory.
>   (See https://lkml.org/lkml/2012/1/11/167)
> e) devices for the different channels are instantiated. Each device
>   is given similar configuration information to what is store in
>   shared memory. (See https://lkml.org/lkml/2012/1/11/163)
> f) User space turns the modem ON, and boots using the initial
>   firmware from shared-memory.
> g) modem's boot stage-2 starts, additional modem binaries are loaded
>   using stream channels.
> h) when boot stage-2 is complete, the CAIF device is enabled.

Cool, thanks for the details!

> The current memory layout is something like this:
> +------------+
> |       TOC      |----+
> |            |--+ |
> +------------+  | |
> | Boot IMG       |<-+ |
> +------------+    |
> | RX Data        |    |
> +------------+    |
> | IPC TOC        |<---+
> +------------+
> | RX Ch Decr |
> +------------+
> | TX Ch Decr |
> +------------+
> | TX Data        |
> +------------+

Which parts of this are set in stone ? only the TOC or additional
regions as well ?

> This is the same thing CAIF does, so multiplexing is not something I'm
> looking for.

I saw you created an SHM bus, which matches SHM drivers to SHM devices
(i.e. channels). I guess you did that because you have some code in
common which all SHM drivers/devices use ? maybe some low level
transport layer ?

This sounds similar to rpmsg in hindsight, but I couldn't find yet the
relevant code to really tell: Most of shm_bus.c looks like very
minimal boilerplate bus code. Maybe the genio_* API is the shared code
(though I could only find a dummy version of that API in linux next) ?

> I like the attitude :-), what new features have you planned for rpmsg?

Anything you need :)

Some of the obvious stuff might be zero copy I/O, user space API,
static channel configuration, runtime PM, recovery, etc.. (there's
more). Sometimes it's a pure rpmsg feature, and sometimes it's
involved with remoteproc.

But we really just evolve according to requirements - we don't have a
rigid roadmap.

> Yes, I tend to think I should use virtio directly, but I have not made up
> mind. I'll probably come back to this later.

What's the vrings layout you will be using (off the top of your head)
? Separate vrings per driver/device or shared vrings ?

Thanks,
Ohad.
