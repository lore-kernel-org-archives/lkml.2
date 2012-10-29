Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646Ab2J2URo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:17:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:42549 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760594Ab2J2UIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:08:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Gaignard <benjamin.gaignard@stericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 04/34] genalloc: stop crashing the system when destroying a pool
Date: Mon, 29 Oct 2012 13:07:35 -0700
Message-Id: <20121029200421.066146599@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029200420.550338074@linuxfoundation.org>
References: <20121029200420.550338074@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

commit eedce141cd2dad8d0cefc5468ef41898949a7031 upstream.

The genalloc code uses the bitmap API from include/linux/bitmap.h and
lib/bitmap.c, which is based on long values.  Both bitmap_set from
lib/bitmap.c and bitmap_set_ll, which is the lockless version from
genalloc.c, use BITMAP_LAST_WORD_MASK to set the first bits in a long in
the bitmap.

That one uses (1 << bits) - 1, 0b111, if you are setting the first three
bits.  This means that the API counts from the least significant bits
(LSB from now on) to the MSB.  The LSB in the first long is bit 0, then.
The same works for the lookup functions.

The genalloc code uses longs for the bitmap, as it should.  In
include/linux/genalloc.h, struct gen_pool_chunk has unsigned long
bits[0] as its last member.  When allocating the struct, genalloc should
reserve enough space for the bitmap.  This should be a proper number of
longs that can fit the amount of bits in the bitmap.

However, genalloc allocates an integer number of bytes that fit the
amount of bits, but may not be an integer amount of longs.  9 bytes, for
example, could be allocated for 70 bits.

This is a problem in itself if the Least Significat Bit in a long is in
the byte with the largest address, which happens in Big Endian machines.
This means genalloc is not allocating the byte in which it will try to
set or check for a bit.

This may end up in memory corruption, where genalloc will try to set the
bits it has not allocated.  In fact, genalloc may not set these bits
because it may find them already set, because they were not zeroed since
they were not allocated.  And that's what causes a BUG when
gen_pool_destroy is called and check for any set bits.

What really happens is that genalloc uses kmalloc_node with __GFP_ZERO
on gen_pool_add_virt.  With SLAB and SLUB, this means the whole slab
will be cleared, not only the requested bytes.  Since struct
gen_pool_chunk has a size that is a multiple of 8, and slab sizes are
multiples of 8, we get lucky and allocate and clear the right amount of
bytes.

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
  [c0000000bb0e7ca0] d000000004b00020 .foo_exit+0x20/0x38 [foo]
  [c0000000bb0e7d20] c0000000000dff98 .SyS_delete_module+0x1a8/0x290
  [c0000000bb0e7e30] c0000000000097d4 syscall_exit+0x0/0x94
  --- Exception: c00 (System Call) at 000000800753d1a0
  SP (fffd0b0e640) is in userspace

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Benjamin Gaignard <benjamin.gaignard@stericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/genalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -57,7 +57,7 @@ int gen_pool_add_virt(struct gen_pool *p
 	struct gen_pool_chunk *chunk;
 	int nbits = size >> pool->min_alloc_order;
 	int nbytes = sizeof(struct gen_pool_chunk) +
-				(nbits + BITS_PER_BYTE - 1) / BITS_PER_BYTE;
+				BITS_TO_LONGS(nbits) * sizeof(long);
 
 	chunk = kmalloc_node(nbytes, GFP_KERNEL | __GFP_ZERO, nid);
 	if (unlikely(chunk == NULL))


