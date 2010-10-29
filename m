Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687Ab0J2LOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 07:14:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40488 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334Ab0J2LOO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 07:14:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ocS3gxZTAZU65OwgD2XZpeAWMza5Ah2h9Hn50JM3bbM2ehYcJJBeoX/nLqRGHO0ZdC
         4lDQ+Hvd8TtxvPNpcG2vA5+xeIZSIxNL/spKS7CS7h6CALLzpAzoGSr0ai8QFw7vHo3v
         bhj/skOCnlFnV8XI5afJCpww3UfkjZaf59QIk=
MIME-Version: 1.0
In-Reply-To: <cover.1288321597.git.mirq-linux@rere.qmqm.pl>
References: <cover.1288321597.git.mirq-linux@rere.qmqm.pl>
Date: Fri, 29 Oct 2010 14:14:12 +0300
Message-ID: <AANLkTinTDZSC93fUsVzx2pbhZE9_39t-m=XNh3h3tkqs@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] SL351x (Gemini) ethernet driver
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Janos Laube <janos.dev@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/29 Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>:
> This is a driver for SL351x (Gemini) SoC ethernet peripheral.
> Based on work by Paulius Zaleckas and GPLd code from Raidsonic
> and other NAS vendors.
>
> This is work in progress. Please comment and test if you can.
> Patches are against 2.6.37-rc (current Linus' tree) but should
> apply to 2.6.36. You probably also need patches for PATA from
>        git://git.berlios.de/gemini-board ib4220

Nice to hear!

> Known bugs:
>  - repeatable bad HW calculated TCP csum
>    happens for only some packets in a TCP stream
>    looks like it doesn't like some data pattern or timing
>    (difference between correct and generated csum is the same
>    when the packet is retransmitted with changed header/TCP tstamp)
>  - TX DMA hangs sometimes (needs module reload when that happens)
>    with debugging printks disabled and HW TX csum enabled

AFAIK DMA hangs are associated with HW checksum errors. So generally
disabling HW csum is the best solution so far. If I am not wrong, OpenWRT
does just this in their patches.

DMA hangs happen for other reasons as well and main cause seems to be MII
interface. If timing is wrong or some noise gets onto PCB tracks it is
very likely
that DMA will hang. Also using both ports at one time increases posibility of
hang.

>  - unsynced counters
>
> I started to work on Paulius' code to find out why the TX DMA hangs
> happen, but then I realized that complete rewrite was a better way
> to understand how the hardware works and why it doesn't. As a "bonus"
> this got some additional features:
>  - ethtool support
>  - 64-bit counters
>  - proper cleanup on ifdown/module unload
>  - better DMA API usage
>  - cleaned up code
>  - a lot of tx/rx debugging printks
>  - based on 2.6.36 DMA and netdev interfaces
>
> TODO:
>  - NAPI
>  - MTU changing

Super cool! NAPI shouldn't be very hard...

> For normal use tx-csum and tso have to be disabled:
>   ethtool -K eth0 tso off tx off
>
> Tested on Raidsonic IcyBox 4220-B (dual SATA NAS).
>
> I'm also interested in getting copies of various GPL packages for
> StorLink SL3516. I already have following packages (md5sum):
>
> 89991e543eb2e473e3d380ac9a4cd8b4  GPL_source_code(Raidsonic).zip
> 6ba8b833c429794315f0a73ce2961bd8  Gemini_v2_6_0-n.tgz
> fe87e97a33554bcab8284d25ff86e383  n299_n199_1.00.24_GPL.tar.bz2
> eca8994354368304ca3b5bd1429c20bb  sl-boot_1.0.9.tgz
> eafd6497074fe0651459bf38c39d66bd  vt4kern-1.5.tar.bz2.tar

I will see what I can provide you when I get home.

>
> Best Regards,
> Micha³ Miros³aw
>
> ---
>
> Micha³ Miros³aw (2):
>  Gemini: create platform device for ethernet in Raidsonic IB-4220B
>  Gemini: SL351x Ethernet driver
>
>  arch/arm/mach-gemini/board-nas4220b.c    |   53 +
>  arch/arm/mach-gemini/common.h            |    2 +
>  arch/arm/mach-gemini/devices.c           |   52 +
>  arch/arm/mach-gemini/include/mach/gmac.h |   21 +
>  drivers/net/Kconfig                      |    7 +
>  drivers/net/Makefile                     |    1 +
>  drivers/net/sl351x.c                     | 1706 ++++++++++++++++++++++++++++++
>  drivers/net/sl351x_hw.h                  | 1423 +++++++++++++++++++++++++
>  8 files changed, 3265 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-gemini/include/mach/gmac.h
>  create mode 100644 drivers/net/sl351x.c
>  create mode 100644 drivers/net/sl351x_hw.h
>
>
