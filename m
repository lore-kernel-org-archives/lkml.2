Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab2GOTnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 15:43:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51926 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2GOTnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 15:43:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Date: Sun, 15 Jul 2012 19:43:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <20120714093032.GA23316@elf.ucw.cz> <20120715121644.GB10597@arm.com>
In-Reply-To: <20120715121644.GB10597@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207151943.08183.arnd@arndb.de>
X-Provags-ID: V02:K0:2ePOmKjzWe4+p2Xvo4Da0CwSE+rXH8yrxjikEWnPeFu
 d5Ig1rUEpg1DI9IZJXJNr+DlAsP0X/HQq/SrrrosBRbDNj6Nxf
 23FrfPfDxIg7IE+eVP/OlS4d8kYqT5BbNcKk8B96A8hDRFOUED
 qXvFUgKGJmYM0DjV+M5e+ipCmh3aAVV+wDMgpLUS877uZ2WoFh
 GuobKlrJzpCP9INoYHTgWorZJy7nkv0V8j8lRkhko5heeLpG9x
 aT1ewBBy8bZvZ5Xxif8s10gUijnbT2y1RiQvoDYQ6vPJ0+uKcm
 AMxdVhit4QY2ljt5qBMWwbo0ioMfaBzNl+ddxKWoVVwg29eUSw
 o+hPwXQm8W8MVNA2jG4w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 July 2012, Catalin Marinas wrote:
> The AArch32 execution mode is optional, so it depends on the actual CPU
> implementation (while AArch64 is mandatory). If the implementation
> supports it, the most likely scenario for AArch32 at kernel level is in
> virtual machines or the secure OS. I'll explain below why.
> 
> The exception (or privilege) levels on an ARMv8 architecture look like
> this:
> 
> Secure World    Normal World
> +-----+
> | EL3 |                         - Secure monitor
> +-----+
>                 +-----+
>                 | EL2 |         - Hypervisor (normal world only)
>                 +-----+
> +-----+         +-----+
> | EL1 |         | EL1 |         - OS kernel (secure or normal)
> +-----+         +-----+
> +-----+         +-----+
> | EL0 |         | EL0 |         - User apps (secure or normal)
> +-----+         +-----+
> 
> In theory, each of these levels (implementation specific) can run both
> AArch32 and AArch64 modes. There is however a restriction on how the
> mode switching is done - this can only happen on a change of exception
> level. When going up the EL the register width (RW) can never go down. A
> lower EL can never have a higher RW than a higher EL.
> 
> Additionally, the RW (the AArch32/AArch64 mode) for an EL is controlled
> by the next higher level (with EL3 hard-wired). An EL cannot cause
> itself to switch between AArch32 and AArch64.

So is the highest level always hardwired to 64-bit on ARMv8?

On a related note: how does the endianess change between
exception levels on ARMv8? Can you switch endianess every time you
move from one level to another? Can any of the levels pick the
endianess for itself?

> So while it is possible, the primary target for 32-bit at the OS kernel
> level is virtualisation. We also don't plan to support a 32-bit SoC on
> ARMv8 systems, given that the compat layer is fully functional.

Yes, I agree that's the best way to handle this. Compared to other
architectures, I think x86 is the only that allows booting either a
32 or 64 bit kernel on the same system. We used to support 32 bit
kernels on 64 bit PowerMac, but nobody used it and we discontinued
it long ago. Tile 64 bit is actually incompatible with 32 bit kernels
at the architecture level and would require a third mode. On sparc,
parisc and mips, AFAIK we could support 32 bit kernels on 64 bit
machines, but never did.

	Arnd
