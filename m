Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab0EXUWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 16:22:09 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:54884 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab0EXUWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 16:22:06 -0400
Date: Mon, 24 May 2010 22:22:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
Message-ID: <20100524202204.GA9917@merkur.ravnborg.org>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris.

Kernle code looked good from a quick browsing.

Please explain the need for all the different directories within include/
{arch, hv, netio}

I tried not to repeat comments from Arnd in the below.

arch/tile/Kconfig:
The TILE specific symbols looks like they use several different
naming schemes. In some cases the company name (TILERA) is used
and in some cases TILE is used. And both as prefix and suffix.

Please stick to using TILE_ prefix. And maybe TILEGX_ in the
cases this is relevant.

Keep all the simple settings in the top of the file.
Stuff like:
config ZONE_DMA
	def_bool y

config SEMAPHORE_SLEEPERS
	def_bool y

Belongs in the top of Kconfig - before your first menu.


There is also several TILE specific options missing the TILE_ prefix.
Like:
config XGBE_MAIN
	tristate "Tilera GBE/XGBE character device support"

Drop this:
config XGBE_MAIN
	tristate "Tilera GBE/XGBE character device support"

It is better to test for the gcc version and disable the option
only in the cases where it is known to fail.


arch/tile/Makefile:

Do not mess with CC like this:
CC = $(CROSS_COMPILE)gcc

I guess you had to do this to support:
LIBGCC_PATH     := `$(CC) -print-libgcc-file-name`

If you follow other archs you could do like this:
LIBGCC_PATH     := `$(CC) -print-libgcc-file-name`

This is not needed:
CLEAN_FILES	+= arch/tile/vmlinux.lds

vmlinux.lds lives in kernel/

help is missing.

arch/tile/kernel/Makefile
I has expected that compiling vmlinux.lds required knowledge on $(BITS)
like this:
CPPFLAGS_vmlinux.lds := -m$(BITS)


arch/tile/kernel/vmlinux.lds.S
A lot of effort has been put into unifying the different
variants of vmlinux.lds.
Please see the skeleton outlined in include/asm-generic/vmlinux.lds.h

You include sections.lds - but it is empty.
Drop that file.

You include hvglue.ld.
We use *.lds for linker script file - please rename.
The file looks generated?? How and when?

Futhermore the definitions are not used by vmlinux.lds.S - so drop the include.

arch/tile/initramfs:
Does not look like it belongs in the kernel?


arch/tile/kernel/head_32.S
The file uses:
	.section .text.head, "ax"
etc.

Please use the section definitions from include/linux/init.h

arch/tile/include/asm/spinlock.h
Please make this a one-liner when you uses the asm-generic version only.
Same goes for byteorder (which includes linux/byteorder/little_endian.h)

In your mail you did not say anything about the checkpatch status.
It is better that you make your code reasonable checkpatch clean _before_
merging. Then you will not be hit by a lot of janitorial patches doing so.

Likewise please state sparse status. We do not expect it to be sparse clean.
But getting rid of the obvious issues is good too.


	Sam





