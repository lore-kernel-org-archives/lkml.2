Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab2LJJpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:45:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab2LJJpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:45:18 -0500
Date: Mon, 10 Dec 2012 10:45:15 +0100
From: Michal Marek <mmarek@suse.cz>
To: Noam Camus <noamc@ezchip.com>
Cc: "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: Makefile race between jobs
Message-ID: <20121210094515.GA31121@sepie.suse.cz>
References: <264C179F799EF24AB26D5319053335E80CC3049A10@ezexch.ezchip.com>
 <50C4B8F3.6030704@suse.cz>
 <264C179F799EF24AB26D5319053335E80CC31B9D41@ezexch.ezchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <264C179F799EF24AB26D5319053335E80CC31B9D41@ezexch.ezchip.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 11:02:25AM +0200, Noam Camus wrote:
> Target "scripts_basic" by itself is indeed not creating the dependency issue.
> The relevant target is "scripts".
> Sorry for the confusion, thanks for the example.
> So I call target "defconfig" and then I call target "vmlinux" which by dependency calls target "scripts", e.g.:
> $ make ARCH=arc O=/dev/shm/_build/ defconfig scripts
>   HOSTCC  scripts/basic/fixdep
>   GEN     /dev/shm/_build/Makefile
>   HOSTCC  scripts/kconfig/conf.o
>   SHIPPED scripts/kconfig/zconf.tab.c
>   SHIPPED scripts/kconfig/zconf.lex.c
>   SHIPPED scripts/kconfig/zconf.hash.c
>   HOSTCC  scripts/kconfig/zconf.tab.o
>   HOSTLD  scripts/kconfig/conf
> #
> # configuration written to .config
> #
>   GEN     /dev/shm/_build/Makefile
> scripts/kconfig/conf --silentoldconfig Kconfig
>   CC      scripts/mod/empty.o
> In file included from /tmp/linux/include/linux/thread_info.h:10,
>                  from /tmp/linux/arch/arc/include/asm/current.h:24,
>                  from <command-line>:0:
> /tmp/linux/include/linux/types.h:4:23: error: asm/types.h: No such file or directory
> 
> The inclusion of asm/current.h comes from use of LINUXINCLUDE in my
> architecture Makefile.
> And asm/types.h is missing since it suppose to be created by target
> "asm-generic".

OK, so there is a new architecture 'arc' that adds '-include asm/current.h'
to global cflags in arch/arc/Makefile. Added Arnd to CC.


> I think the point here that I try to emphasize is that target
> "asm-generic" should be completed before any non-host source is
> compiled.
> In our case scripts/mod/empty.c is the first non-host source to be
> compiled and by bad coincidence it depends upon auto generated
> headers.

I see the problem now. However, so far, no other architecture has been
doing this. 'grep -e -include arch/*/Makefile' shows only one instance
in arch/arm, but that include is a static file with no dependencies. Is
it really necessary to include asm/current.h when compiling _every_
file? Sure, you get it via many common headers, but then you don't need
to add it explicitly :). But if Arnd thinks this is OK, I will merge a
patch that serializes scripts/mod/empty.o and asm-generic.

Michal
