Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab2JWQnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:43:24 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:51921 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab2JWQnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:43:22 -0400
Date: Tue, 23 Oct 2012 14:42:53 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Gaignard <benjamin.gaignard@stericsson.com>
Subject: Re: [PATCH resend] genalloc: stop crashing the system when
 destroying a pool
Message-ID: <20121023164252.GA21376@oc0268524204.ibm.com>
References: <1350820392-25815-1-git-send-email-cascardo@linux.vnet.ibm.com>
 <20121022141854.33f5fcf4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022141854.33f5fcf4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102316-2194-0000-0000-00000371C54B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 02:18:54PM -0700, Andrew Morton wrote:
> On Sun, 21 Oct 2012 09:52:59 -0200
> Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com> wrote:
> 
> > A gen_pool_chunk uses a bitmap to find what addresses ranges it has
> > allocated and bugs when we destroy the pool and a chunk has some bits
> > set.
> > 
> > There is a problem when it allocates the bitmap. It allocates only the
> > number of bytes needed for the bits that represent the size it's
> > allocating. That is, if it needs 16 bits, it will allocate only 2 bytes,
> > if it needs 31 bits, it will allocate 4 bytes.
> > 
> > However, the bitops functions uses long types. And when the gen_pool_add
> > allocates a bitmap, it only clears the bytes it has allocated. So, it's
> > possible that we have a long word with the contents 0xffffffffffffffff,
> > and only the first (most significant) bytes are cleared by memset.
> > However, the destroy function is going to test for the least significant
> > bits, which will not be clear as expected.
> > 
> 
> When fixing a bug, please do fully describe that bug.  The oops trace
> would be nice, but can be avoided if a suitable description is included.
> 
> Does the BUG() happen in gen_pool_destroy(), or in gen_pool_free()?  In
> either case, from your description it sound like the function which is
> going BUG() is the site which needs fixing because it is checking for
> non-zero bits outside the correct range?
> 

Sorry if my description sounds like that. I also ignored the oops
because I thought the description was good enough. If my explanation
below is good enough, feel free to use it, or just tell me to resend.
Either way works for me.

The genalloc code uses the bitmap API from include/linux/bitmap.h and
lib/bitmap.c, which is based on long values. Both bitmap_set from
lib/bitmap.c and bitmap_set_ll, which is the lockless version from
genalloc.c, use BITMAP_LAST_WORD_MASK to set the first bits in a long in
the bitmap.

That one uses (1 << bits) - 1, 0b111, if you are setting the first three
bits. This means that the API counts from the least significant bits
(LSB from now on) to the MSB. The LSB in the first long is bit 0, then.
The same works for the lookup functions.

The genalloc code uses longs for the bitmap, as it should. In
include/linux/genalloc.h, struct gen_pool_chunk has unsigned long
bits[0] as its last member. When allocating the struct, genalloc should
reserve enough space for the bitmap. This should be a proper number of
longs that can fit the amount of bits in the bitmap.

However, genalloc allocates an integer number of bytes that fit the
amount of bits, but may not be an integer amount of longs. 9 bytes, for
example, could be allocated for 70 bits.

This is a problem in itself if the Least Significat Bit in a long is in
the byte with the largest address, which happens in Big Endian machines.
This means genalloc is not allocating the byte in which it will try to
set or check for a bit.

This may end up in memory corruption, where genalloc will try to set the
bits it has not allocated. In fact, genalloc may not set these bits
because it may find them already set, because they were not zeroed
since they were not allocated. And that's what causes a BUG when
gen_pool_destroy is called and check for any set bits.

What really happens is that genalloc uses kmalloc_node with __GFP_ZERO
on gen_pool_add_virt. With SLAB and SLUB, this means the whole slab will
be cleared, not only the requested bytes. Since struct gen_pool_chunk
has a size that is a multiple of 8, and slab sizes are multiples of 8,
we get lucky and allocate and clear the right amount of bytes.

Hower, this is not the case with SLOB or with older code that did memset
after allocating instead of using __GFP_ZERO.

So, a simple module as this (running 3.6.0), will cause a crash when
rmmod'ed.

[root@phantom-lp2 foo]# cat foo.c
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/genalloc.h>

MODULE_LICENSE("GPL");
MODULE_VERSION("0.1");

static struct gen_pool *foo_pool;

static __init int foo_init(void)
{
        int ret;
        foo_pool = gen_pool_create(10, -1);
        if (!foo_pool)
                return -ENOMEM;
        ret = gen_pool_add(foo_pool, 0xa0000000, 32 << 10, -1);
        if (ret) {
                gen_pool_destroy(foo_pool);
                return ret;
        }
        return 0;
}

static __exit void foo_exit(void)
{
        gen_pool_destroy(foo_pool);
}

module_init(foo_init);
module_exit(foo_exit);
[root@phantom-lp2 foo]# zcat /proc/config.gz | grep SLOB
CONFIG_SLOB=y
[root@phantom-lp2 foo]# insmod ./foo.ko
[root@phantom-lp2 foo]# rmmod foo
------------[ cut here ]------------
kernel BUG at lib/genalloc.c:243!
cpu 0x4: Vector: 700 (Program Check) at [c0000000bb0e7960]
    pc: c0000000003cb50c: .gen_pool_destroy+0xac/0x110
    lr: c0000000003cb4fc: .gen_pool_destroy+0x9c/0x110
    sp: c0000000bb0e7be0
   msr: 8000000000029032
  current = 0xc0000000bb0e0000
  paca    = 0xc000000006d30e00   softe: 0        irq_happened: 0x01
    pid   = 13044, comm = rmmod
kernel BUG at lib/genalloc.c:243!
enter ? for help
[c0000000bb0e7be0] 0000000000000000 (unreliable)
[c0000000bb0e7ca0] d000000004b00020 .foo_exit+0x20/0x38 [foo]
[c0000000bb0e7d20] c0000000000dff98 .SyS_delete_module+0x1a8/0x290
[c0000000bb0e7e30] c0000000000097d4 syscall_exit+0x0/0x94
--- Exception: c00 (System Call) at 000000800753d1a0
SP (fffd0b0e640) is in userspace
4:mon>


