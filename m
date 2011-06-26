Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab1FZBMM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 21:12:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60769 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1FZBMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 21:12:10 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.33.137]
In-Reply-To: <4E04F0B0.4030408@codeaurora.org>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com> <4E04F0B0.4030408@codeaurora.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 26 Jun 2011 04:11:47 +0300
Message-ID: <BANLkTi=sFtwam29i4TZdi=RO7BoytTTdrw@mail.gmail.com>
Subject: Re: [RFC 0/8] Introducing a generic AMP/IPC framework
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Jun 24, 2011 at 11:16 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> This sounds a lot like SMD (shared memory driver) on MSM. The main
> difference I see is that SMD uses the platform bus instead of the virtio
> bus and it has its own protocol for channel allocation.

Yeah, virtio is a key factor in this work; it was suggested to us by
Arnd at the AMP plumbers discussions last year, where it was apparent
that many vendors have their own IPC drivers/buses/channels over
shared memory with some vendor-ish binary protocol. I must say we
really liked virtio: it considerably simplified the code (we're not
adding any new binary protocol), it's very nicely optimized and
flexible, and it comes with a set of virtio drivers (e.g. network,
console, block) so we don't have to write our own.

We also cared about adding this functionality as an IPC bus, so the
driver core will help matching drivers to channels - it simplified the
code (in both setup and tear down of channels) and kept it flexible.
It will also facilitate error recovery (on remote crash, we just
remove the virtio device, and then the driver core will in turn start
->remove()ing the rpmsg drivers) and power management (via runtime
PM).

About SMD: I'm not familiar with it too much, but Brian naturally is
(just for the sake of everyone who are not reading headers - Brian
Swetland wrote the Linux SMD driver, and is also an author of this
Google+TI joint work).

Btw, I'm sure SMD is conceptually not MSM-specific, and have wondered
whether you guys would like to use rpmsg/virtio (I know you have
several drivers like network/tty/etc over SMD, somewhat similarly to
virtio). Probably the biggest reason why not to is the pain in
changing the binary protocol with the modem/dsp side. If you ever do
think about it, I'd be happy to work with you to make it happen.

> This remote proc code is eerily similar to PIL (peripheral image loader,
> yes we love our acronyms) which I posted a few months back[1]. Was it
> inspiration for this patch series?

No, we weren't (or at least I wasn't) aware of PIL.

> In terms of API, s/pil/rproc/ and it would be 95% identical. There are
> some low-level differences though (see below).

Indeed, eerily similar :O

I just guess the API is so simple that probably most kernel hackers
would use refcounting get/put semantics here.

> This is an important difference between remote proc and PIL. In PIL, we
> do image authentication in addition to processor boot.

Yes, we have this too (secure code will need to authenticate the image
in some use cases) - but that's not ready yet for submission and we
decided to start off with the basics first and then evolve.

> Instead of devising a new firmware format, we decided
> to just stick with elf and parse the headers in the kernel because we
> needed them for authentication anyway. Is this reason enough to move to
> an ELF format instead?

I think that consolidation of code is enough reason to make an effort.
I know that our firmware format was chosen for simplicity, but I'm not
sure if we have the tools yet to build standard ELF files for the
remote processors (IIRC it's in the works though). I'll let Mark
comment this one.

> Another difference is inter-processor dependencies. For example, on
> msm8660 the modem can't boot until the dsp has been booted. I suppose we
> could hide this detail in the platform specific get() implementation by
> calling rproc_get() on the dependent processor (hopefully no locking
> issues arise). I'd rather have it built into the core though as it isn't
> really specific to the hardware.

No problems, I'm sure we can solve this one easily.

> If we can resolve these differences I think we can easily support remote
> processor boot on MSM via remoteproc.

That'd be very cool, I sure do hope we can work together.

Thanks for your comments !
Ohad.
