Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab2DWGxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 02:53:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab2DWGxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 02:53:37 -0400
Date: Sun, 22 Apr 2012 23:55:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>,
        Huang Shijie <b32955@freescale.com>
Subject: Re: [PATCH V2 1/3] lib: add support for stmp-style devices
Message-Id: <20120422235506.d3377f0e.akpm@linux-foundation.org>
In-Reply-To: <1332368519-22660-2-git-send-email-w.sang@pengutronix.de>
References: <1332368519-22660-1-git-send-email-w.sang@pengutronix.de>
	<1332368519-22660-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 23:21:57 +0100 Wolfram Sang <w.sang@pengutronix.de> wrote:

> MX23/28 use IP cores which follow a register layout I have first seen on
> STMP3xxx SoCs. In this layout, every register actually has four u32:
> 
>  1.) to store a value directly
>  2.) a SET register where every 1-bit sets the corresponding bit,
>      others are unaffected
>  3.) same with a CLR register
>  4.) same with a TOG (toggle) register
> 
> Also, the 2 MSBs in register 0 are always the same and can be used to reset
> the IP core.
> 
> All this is strictly speaking not mach-specific (but IP core specific) and,
> thus, doesn't need to be in mach-mxs/include. At least, mx6 and mx50 also
> utilize IP cores following this stmp-style. So:
> 
> Introduce a stmp-style device, put the code and defines for that in a public
> place (lib/), and let drivers for stmp-style devices select that code.
> To avoid regressions and ease reviewing, the actual code is simply copied from
> mach-mxs. It definately wants updates, but those need a seperate patch series.
> 
> Voila, mach dependency gone, reusable code introduced. Note that I didn't
> remove the duplicated code from mach-mxs yet, first the drivers have to be
> converted.
> 
> ...
>
>  include/linux/stmp_device.h |   20 +++++++++++
>  lib/Kconfig                 |    3 ++
>  lib/Makefile                |    2 +
>  lib/stmp_device.c           |   80 +++++++++++++++++++++++++++++++++++++++++++

It's good that this is being presented as library code, rather than
being buried in some device-specific directory then copied and pasted
ten times.

But ./lib/ does seem rather a strange place for it.  Perhaps we need a
drivers/lib/ or something.  We can use ./lib/ for now - it can always
be moved later on.

> --- /dev/null
> +++ b/lib/stmp_device.c

The functions in this file look terribly racy on SMP, or even with
preemption or interrupts.  What happens if two CPUs or threads run
stmp_reset_block() against the same device at the same time?

Perhaps the caller is supposed to prevent that, and the documentation
which isn't there forgot to mention it ;)

