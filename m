Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2HOAd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 20:33:58 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:65260 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab2HOAdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 20:33:55 -0400
Date: Tue, 14 Aug 2012 17:33:55 -0700
From: Olof Johansson <olof@lixom.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 13/31] arm64: Device specific operations
Message-ID: <20120815003355.GF19607@quad.lixom.net>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-14-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344966752-16102-14-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 06:52:14PM +0100, Catalin Marinas wrote:
> This patch adds several definitions for device communication, including
> I/O accessors and ioremap(). The __raw_* accessors are implemented as
> inline asm to avoid compiler generation of post-indexed accesses (less
> efficient to emulate in a virtualised environment).
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/include/asm/device.h |   26 ++++
>  arch/arm64/include/asm/fb.h     |   34 +++++
>  arch/arm64/include/asm/io.h     |  263 +++++++++++++++++++++++++++++++++++++++
>  arch/arm64/kernel/io.c          |   64 ++++++++++
>  arch/arm64/mm/ioremap.c         |   84 +++++++++++++
>  5 files changed, 471 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm64/include/asm/device.h
>  create mode 100644 arch/arm64/include/asm/fb.h
>  create mode 100644 arch/arm64/include/asm/io.h
>  create mode 100644 arch/arm64/kernel/io.c
>  create mode 100644 arch/arm64/mm/ioremap.c
> 
> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> new file mode 100644
> index 0000000..48fa83f
> --- /dev/null
> +++ b/arch/arm64/include/asm/io.h

[...]

> +/*
> + *  I/O port access primitives.
> + */
> +#define IO_SPACE_LIMIT		0xffff
> +
> +/*
> + * We currently don't have any platform with PCI support, so just leave this
> + * defined to 0 until needed.
> + */
> +#define PCI_IOBASE		((void __iomem *)0)

You could just leave out the PCI / I/O code alltogether instead.

> diff --git a/arch/arm64/kernel/io.c b/arch/arm64/kernel/io.c
> new file mode 100644
> index 0000000..7d37ead
> --- /dev/null
> +++ b/arch/arm64/kernel/io.c
> @@ -0,0 +1,64 @@
> +/*
> + * Based on arch/arm/kernel/io.c
> + *
> + * Copyright (C) 2012 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/export.h>
> +#include <linux/types.h>
> +#include <linux/io.h>
> +
> +/*
> + * Copy data from IO memory space to "real" memory space.
> + */
> +void __memcpy_fromio(void *to, const volatile void __iomem *from, size_t count)
> +{
> +	unsigned char *t = to;
> +	while (count) {
> +		count--;
> +		*t = readb(from);
> +		t++;
> +		from++;
> +	}
> +}
> +EXPORT_SYMBOL(__memcpy_fromio);
> +
> +/*
> + * Copy data from "real" memory space to IO memory space.
> + */
> +void __memcpy_toio(volatile void __iomem *to, const void *from, size_t count)
> +{
> +	const unsigned char *f = from;
> +	while (count) {
> +		count--;
> +		writeb(*f, to);
> +		f++;
> +		to++;
> +	}
> +}
> +EXPORT_SYMBOL(__memcpy_toio);
> +
> +/*
> + * "memset" on IO memory space.
> + */
> +void __memset_io(volatile void __iomem *dst, int c, size_t count)
> +{
> +	while (count) {
> +		count--;
> +		writeb(c, dst);
> +		dst++;
> +	}
> +}
> +EXPORT_SYMBOL(__memset_io);

Doing all of the above a byte at a time is horribly inefficient. Feel
free to borrow the implementations from arch/powerpc/kernel/io.c instead
of from ARM.


-Olof
