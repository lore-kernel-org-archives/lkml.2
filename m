Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab2BCO53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:57:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62613 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab2BCO51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:57:27 -0500
MIME-Version: 1.0
In-Reply-To: <201202021533.14650.arnd@arndb.de>
References: <1328130290-17607-1-git-send-email-swarren@nvidia.com>
	<CACRpkda+KCutSFgPwH2Xvd14h0OCrArFGXAidp3n_ZgG28KB5g@mail.gmail.com>
	<201202021533.14650.arnd@arndb.de>
Date: Fri, 3 Feb 2012 15:57:27 +0100
Message-ID: <CACRpkdbMPrvN80cLyVLUNvTjx4ZV4iLeHcJaJyM_qvTHHAfWww@mail.gmail.com>
Subject: Re: [PATCH V2 1/4] pinctrl: add a driver for NVIDIA Tegra
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Dong Aisheng <dong.aisheng@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        ext Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 4:33 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> [Me]
>> Olof, Arnd: please verify that this is a direction you accept for the Tegra.
>> (Olof has already ACK:ed it, mainly thinking about Arnd.)
>
> I would have liked to see a smaller pinctrl driver and one with fewer macros,
> but I'm not going to complain about it -- drivers/pinctrl is definitely your
> turf not mine and I assume that Olof's Ack was meant in his position as Tegra
> maintainer instead of his position as arm-soc maintainer.

Which means I have no ACK from any of the ARM SoC maintainers
on this which is touching the ARM tree substantially and affecting
more or less all recent ARM SoCs,

Which is actually bad enough for me to have second thoughts on
this.

So I'm taking this branch off from -next until we resolve this.

> It's unfortunate that the number of lines in the board specific pinmux
> files is actually growing, even though the contents seem to be smaller
> and it seems to be done in a way that all the data will move into the
> device tree eventually. What is holding up that move right now?

This is being held up by the discussion in the thread:
"Pinmux bindings proposal V2" and its precursor.

Evidently it is hard to reach consensus on DT bindings, my
analysis is that this is because these tend to turn into full-blown
hardware-description committe work rather than Linux kernel
issues. (This is both good and bad.)

There will be no pinmux DT bindings until there is a patch for
it that gets an ACK from the majority of interested parties,
preferably all.

Myself I stay out of that discussion in order not to rock
the boat.

> I guess if we could move the per-board pinmux data into dts files,
> that would mean we could actually get rid of the per-board source
> files in tegra, right?

If you mean these:

 arch/arm/mach-tegra/board-harmony-pinmux.c        |  362 ++-
 arch/arm/mach-tegra/board-paz00-pinmux.c          |  362 ++-
 arch/arm/mach-tegra/board-pinmux.c                |   62 +-
 arch/arm/mach-tegra/board-pinmux.h                |   39 +-
 arch/arm/mach-tegra/board-seaboard-pinmux.c       |  442 ++-
 arch/arm/mach-tegra/board-trimslice-pinmux.c      |  366 ++-

Then the answer is yes.

But not if you mean these:

 drivers/pinctrl/pinctrl-tegra20.c                 | 2860 ++++++++++++++++
 drivers/pinctrl/pinctrl-tegra30.c                 | 3726 +++++++++++++++++++++

Because the large number of lines come from SoC
properties rather than board properties.

The big issue here is whether SoC hardware block
properties (such as the pins and their names, and their
groups) should be:

(A) open-coded in the driver or
(B) provided as data in the device tree

nVidia Tegra have opted for the former, Texas OMAP for the latter.
The in-kernel drivers also do like Tegra. However they
are smaller due to less combinatorics.

This means that the Tegra driver gets (quite a bit) bigger and
the OMAP driver (quite a bit) smaller.

Then we've had some arguments about this, you
can make a lot of points for and against one or
the other, but we have no consensus on the individual
rank of these arguments.

I have resorted to the solution found in
Documentation/ManagementStyle, chapter 1, which
helpfully talks about handling situations of the type
(A) vs (B) ... which means no decision on my part until
we sort it out! People will have to discuss it and start
ACKing each others patches after finding some
rough consensus.

> One thing that worries me a bit is the object size of the tegra
> pinctrl driver: There are now about 70kb pinmux driver binary in
> each kernel that wants to run on tegra (about the same as the
> remaining tegra platform code), which can become a bottleneck
> in future multi-platform kernels that also want to run on a lot of
> other things.

This sounds like a correct observation and I think I have said
the same previously.

> Will it be possible to eventually put the pinmux driver into a loadable
> module?

Tony had made it possible to have pinctrl drivers as modules,
but some systems may need their pin control up before
they even bring up the filesystem :-(

Booting from initramfs and switchroot can solve the above
but will slow down boot I believe, and ARM systems
usually don't like that.

Yours,
Linus Walleij
