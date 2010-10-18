Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab0JRN43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 09:56:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54543 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab0JRN41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 09:56:27 -0400
Date: Mon, 18 Oct 2010 14:56:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/22] arm: introduce little endian bitops
Message-ID: <20101018135616.GB12449@n2100.arm.linux.org.uk>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com> <1287135981-17604-5-git-send-email-akinobu.mita@gmail.com> <20101018092650.GC26183@n2100.arm.linux.org.uk> <AANLkTi=1w9uV81CagrE53xEYkMaFh_3cM_+ybctT2ng4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=1w9uV81CagrE53xEYkMaFh_3cM_+ybctT2ng4@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 10:22:59PM +0900, Akinobu Mita wrote:
> 2010/10/18 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> > On Fri, Oct 15, 2010 at 06:46:03PM +0900, Akinobu Mita wrote:
> >> Introduce little endian bit operations by renaming native ext2 bit
> >> operations. The ext2 bit operations are kept by using little endian
> >> bit operations until the conversions are finished.
> >
> > Can you explain why we need another level of indirection rather than
> > using asm-generic/bitops/le.h, asm-generic/bitops/minix.h and
> > asm-generic/bitops/ext2-non-atomic.h ?
> 
> Sorry for not CCing the cover letter of this patch series.
> 
> Currently there are no common little-endian bit operations for all
> architectures, although some architectures implicitly include
> asm-generic/bitops/le.h through asm-generic/bitops/minix-le.h or
> asm-generic/bitops/ext2-non-atomic.h.
> 
> So some drivers (net/rds/cong.c and virt/kvm/kvm_main.c) need to
> include asm/bitops/le.h directly. When I tried to remove the
> direct inclusion of asm-generic/bitops/le.h by using ext2_*(),
> several people prefer another solution like this patch series does.
> 
> This patch series introduces little-endian bit operations for
> all architectures and convert all ext2 non-atomic bit operations
> and minix bit operations to use little-endian bit operations.
> it enables to remove ext2 non-atomic and minix bit operations
> from asm/bitops.h. The reason they should be removed from
> asm/bitops.h is as follows:
> 
> For ext2 non-atomic bit operations, they are used for little-endian
> byte order bitmap access by some filesystems and modules.
> But using ext2_*() functions on a module other than ext2 filesystem
> makes someone feel strange.
> 
> For minix bit operations, they are only used by minix filesystem
> and useless by other modules. Because byte order of inode and block
> bitmap is defferent on each architectures.
> 
> There are several issues including arm part. So I'm now fixing them.

le.h provides:

	generic___set_le_bit
	generic___test_and_set_le_bit
	...

Your new patches provide:

	__set_le_bit
	__test_and_set_le_bit

Would it not be better to have le.h provide one set of these LE bitops
(called either generic___set_le_bit or __set_le_bit - which ever you
prefer), and then have everyone using those common names (including
minix-le.h and ext2-non-atomic.h) rather than adding a whole series of
new bitop macros to the current mess?

To put it another way, if we're providing a set of guaranteed-little-endian
bitops, I'd like to see ARM doing this:

#define __test_and_set_le_bit(nr,p) ...

#include <asm-generic/bitops/minix-le.h>
#include <asm-generic/bitops/ext2-non-atomic.h>

where ext2-non-atomic.h could just be:

#define ext2_set_bit(nr,addr) __test_and_set_le_bit((nr),(unsigned long *)(addr))

instead of defining its own minix and ext2 bitops as we do now:

#ifndef __ARMEB__
#define WORD_BITOFF_TO_LE(x)            ((x))
#else
#define WORD_BITOFF_TO_LE(x)            ((x) ^ 0x18)
#endif
#define ext2_set_bit(nr,p)                      \
                __test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))

vs the current 'generic' stuff:

ARM byteorder.h (roughly):
#ifdef __ARMEB__
#define __BIG_ENDIAN 4321
#else
#define __LITTLE_ENDIAN 1234
#endif

le.h:
#define BITOP_LE_SWIZZLE        ((BITS_PER_LONG-1) & ~0x7)
#if defined(__LITTLE_ENDIAN)
#define generic___test_and_set_le_bit(nr, addr) __test_and_set_bit(nr, addr)
#elif defined(__BIG_ENDIAN)
#define generic___test_and_set_le_bit(nr, addr) \
        __test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
#endif

ext2-non-atomic.h:
#define ext2_set_bit(nr,addr)   \
        generic___test_and_set_le_bit((nr),(unsigned long *)(addr))

What I'm trying to say is please don't make the existing mess of bitops
any worse than it currently is.
