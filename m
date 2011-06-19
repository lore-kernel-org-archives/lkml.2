Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab1FSSf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 14:35:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52917 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab1FSSfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 14:35:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 03/19] OpenRISC: Memory management
Date: Sun, 19 Jun 2011 20:35:05 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1308483825-6023-1-git-send-email-jonas@southpole.se> <1308483825-6023-4-git-send-email-jonas@southpole.se>
In-Reply-To: <1308483825-6023-4-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106192035.06133.arnd@arndb.de>
X-Provags-ID: V02:K0:pmf9CeuYA5RC9g1rYLK3EuxrkVnmbO+JZ1vrmmFCf0k
 tN7/tqJ/IUYlBxuqrpc3qSeUlypuZ1kOJDlKc9iUOY1jlPzZ1q
 1hS8j2ilUnYiihnlaVLjg9Jees3VEYOIlzxJNGHOKbpjw2hIwG
 LLd87mcOmEbtz2rOb1xdjx/GPKy/fJJMDi+IOS5v2TNOYsHocO
 ZloOWwiRhq6kudHQ6vFdQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 June 2011 13:43:29 Jonas Bonn wrote:

> +#define FIXADDR_TOP	((unsigned long) (-2*PAGE_SIZE))
> +
> +#include <linux/kernel.h>
> +#include <linux/threads.h>
> +#include <asm/page.h>
> +
> +/*
> + * Here we define all the compile-time 'special' virtual
> + * addresses. The point is to have a constant address at
> + * compile time, but to set the physical address only
> + * in the boot process. We allocate these special addresses
> + * from the end of virtual memory (0xffffb000) backwards.
> + *
> + * Also this would let us do fail-safe vmalloc(), we
> + * can guarantee that these special addresses and
> + * vmalloc()-ed addresses never overlap.  We don't actually
> + * do this on OpenRISC though (nor do most other arch's).
> + *
> + * these 'compile-time allocated' memory buffers are
> + * fixed-size (PAGE_SIZE) pages. (or larger if used with an increment
> + * highger than 1) use fixmap_set(idx,phys) to associate
> + * physical memory with fixmap indices.
> + *
> + * TLB entries of such buffers will not be flushed across
> + * task switches.
> + */
> +enum fixed_addresses {
> +	/*
> +	 * FIX_IOREMAP entries are useful for mapping physical address
> +	 * space before ioremap() is useable, e.g. really early in boot
> +	 * before kmalloc() is working.
> +	 */
> +#define FIX_N_IOREMAPS  32
> +	FIX_IOREMAP_BEGIN,
> +	FIX_IOREMAP_END = FIX_IOREMAP_BEGIN + FIX_N_IOREMAPS - 1,
> +	__end_of_fixed_addresses
> +};


What is this actually needed for? I know that there are a few architectures
that have this, but I couldn't find any users of fixmap_set in your code.

If you don't use it, it's probably better to remove the code. Otherwise,
would it be possible to generalize it enough to merge the code with the
x86 and tile implementations and move it into mm/fixmap.c and/or
include/asm-generix/fixmap.h?

> +
> +extern int mem_init_done;

Move this to a header file, too.

> +/*
> + * OR1K has no port-mapped IO, only MMIO
> + */
> +void __iomem *ioport_map(unsigned long port, unsigned int len)
> +{
> +	BUG();
> +}
> +
> +void ioport_unmap(void __iomem *addr)
> +{
> +	BUG();
> +}

If you don't have port-mapped I/O, you cannot have PCI, so you should
remove the option to enable PCI from Kconfig.

If you actually support PCI, you should implement ioport_map to point
to the memory-mapped location of PCI I/O space window.

	Arnd
