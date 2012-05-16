Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967127Ab2EPAYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 20:24:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57276 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966737Ab2EPAYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 20:24:04 -0400
Date: Tue, 15 May 2012 17:22:33 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Colin Cross <ccross@android.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 04/11] persistent_ram: Introduce persistent_ram_new()
Message-ID: <20120516002232.GA18883@lizard>
References: <20120512001506.GA8653@lizard>
 <20120512001734.GD14782@lizard>
 <CAMbhsRR3gsajDCyODgf0XrtEr5Jeeo7yPXxk_R6JfVkk-kGvyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMbhsRR3gsajDCyODgf0XrtEr5Jeeo7yPXxk_R6JfVkk-kGvyQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Colin,

On Mon, May 14, 2012 at 05:37:56PM -0700, Colin Cross wrote:
[...]
> even worse, mem= from the bootloader.  Mixing the two methods together
> would be confusing.

Yes, mixing is discouraged. The mem= hack is mostly useful for
developers, for hacking random kernels. Even on x86 it is
useful, when you want to grab an oops, but you don't have say
netconsole, or HW really screwed up and you don't have any
means to get the oops log, ramoops may become quite useful.

But in the Android phone scenario, if you want to have this
feature into production kernels, platforms should register
the ramoops platform driver, as they were doing before.

> Either persistent_ram_early_init should be
> removed completely (or replaced with something that is easier to
> register ramoops into), or ramoops should use
> persistent_ram_init_ringbuffer like ram_console does.

Yep, this was indeed my original idea: persistent_ram_early_init
should go.

Boards (or generic arch/ or arch/mach-* code that knows memory
layout) will have to just do two things:

1. Wisely and early call memblock_reserve().
2. Register a ramoops platform device pointing to the reserved
   memory.

This is actually exactly the same as you were doing with
ram_console:

1. Platform were adding an entry to the global list of persistent
   ram zones, and then were calling persistent_ram_early_init()
   somewhere in the arch/ code (at least that's how I understood
   the idea of the code, as there are currently no in-tree users).
2. Then platforms were registering a ram_console platform device,
   and the driver would find out the needed zone by matching on
   the device name.

Thinking about it, the whole thing was actually abusing
the device-driver model a little bit. So things are just easier
now.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
