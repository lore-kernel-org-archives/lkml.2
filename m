Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab0LLOsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 09:48:09 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36420 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab0LLOsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 09:48:06 -0500
Date: Sun, 12 Dec 2010 14:47:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Newton <will.newton@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, Matt Fleming <matt@console-pimps.org>,
        linux-mmc@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dw_mmc: Add Synopsys DesignWare mmc host driver.
Message-ID: <20101212144750.GH8665@n2100.arm.linux.org.uk>
References: <20101209064751.GA21128@void.printf.net> <AANLkTimMgrawcndvUTYYjq9BGFqs-sbRsZkwVQ0Uvhvb@mail.gmail.com> <20101209160157.GA28586@void.printf.net> <AANLkTim3Rj2tTbqvT8nM4L=p=Wx8bdOnGq=EDv+cs02g@mail.gmail.com> <20101211192320.GA24430@void.printf.net> <AANLkTin5aVPz5Y=jS89V00XS=rje3gqeUb2VTYt2A_9=@mail.gmail.com> <20101212135224.GA31812@void.printf.net> <AANLkTinMYeWNLu8e7xyBTvjmeFMsJ5sDGtsCesu04d4K@mail.gmail.com> <20101212141112.GF8665@n2100.arm.linux.org.uk> <AANLkTin++a_juBQDssFDd881R449so7Um2AvHFLXqiT_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin++a_juBQDssFDd881R449so7Um2AvHFLXqiT_@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 02:31:40PM +0000, Will Newton wrote:
> On Sun, Dec 12, 2010 at 2:11 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > Maybe invent CONFIG_HAVE_MMIO_64BIT which architectures can select as
> > appropriate?
> 
> Wouldn't it be simpler to have a fallback readq/writeq implementation
> like the below?
> 
> static inline u64 __raw_readq(const volatile void __iomem *addr)
> {
>         return *(const volatile u64 __force *) addr;
> }
> 
> It won't break any existing hardware (if your SoC bus does not support
> 64bit accesses you are unlikely to have peripherals that require it)
> and would avoid a number of #ifdefs and/or Kconfig dependencies.

Firstly, why, then, are we discussing fixing dw_mmc.c so it builds on ARM?
Just make its configuration option conditional on !ARM and that specific
problem is solved.

Secondly, providing such a fallback implementation is asking people to
use it, and they'll expect it to work.  Their driver will build and
apparantly work, but because the compiler will use ldrd/strd for it, a
perfectly timed interrupt could cause data corruption.

It's unsafe to provide 64-bit MMIO operations on hardware which is unable
to perform 64-bit MMIO atomically - it will lead to really subtle driver
bugs.
