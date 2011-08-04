Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab1HDLyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 07:54:20 -0400
Received: from gw1.transmode.se ([195.58.98.146]:38444 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab1HDLyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 07:54:17 -0400
In-Reply-To: <01dc01cc5159$317879a0$94696ce0$@systemfabricworks.com>
References: <OF4AE0115F.3AA5397E-ONC12578DF.002EC6DF-C12578DF.003348E5@transmode.se> <01dc01cc5159$317879a0$94696ce0$@systemfabricworks.com>
Subject: RE: [PATCH] add slice by 8 algorithm to crc32.c
X-KeepSent: 83CC7C9C:07EC5D4A-C12578E2:0024F5AE;
 type=4; name=$KeepSent
To: "Bob Pearson" <rpearson@systemfabricworks.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'frank zago'" <fzago@systemfabricworks.com>,
        linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF83CC7C9C.07EC5D4A-ONC12578E2.0024F5AE-C12578E2.004163C1@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Thu, 4 Aug 2011 13:54:13 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 08/04/2011 13:54:14
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Bob Pearson" <rpearson@systemfabricworks.com> wrote on 2011/08/02 23:14:39:
>
> Hi Joakim,
>
> Sorry to take so long to respond.

No problem but please insert you answers in correct context(like I did). This
makes it much easier to read and comment on.

>
> Here are some performance data collected from the original and modified
> crc32 algorithms.
> The following is a simple test loop that computes the time to compute 1000
> crc's over 4096 bytes of data aligned on an 8 byte boundary after warming
> the cache. You could make other measurements but this is sort of a best
> case.
>
> These measurements were made on a dual socket Nehalem 2.267 GHz system.

Measurements on your SPARC would be good too.

>
> #ifdef CONFIG_CRC32_PERFTEST
> #include <linux/time.h>
>
> static u8 __attribute__((__aligned__(8))) test_buf[4096];
>
> /* need to convince gcc to not optimize out all the crc calls as dead code
> */
> u32 crc;
>
> static int __init crc32_init(void)
> {
>         int i;
>         struct timespec start, stop;
>         u64 nsec_le;
>         u64 nsec_be;
>
>         for (i = 0; i  < 4096; i++)
>                 test_buf[i] = i;
>
>         crc = crc32_le(0, test_buf, 4096);
>         crc = crc32_le(crc, test_buf, 4096);
>
>         getnstimeofday(&start);
>         for (i = 0; i < 1000; i++)
>                 crc = crc32_le(crc, test_buf, 4096);
>         getnstimeofday(&stop);
>
>         nsec_le = stop.tv_nsec - start.tv_nsec +
>                 1000000000 * (stop.tv_sec - start.tv_sec);
>
>         crc = crc32_be(0, test_buf, 4096);
>         crc = crc32_be(crc, test_buf, 4096);
>
>         getnstimeofday(&start);
>         for (i = 0; i < 1000; i++)
>                 crc = crc32_be(crc, test_buf, 4096);
>         getnstimeofday(&stop);
>
>         nsec_be = stop.tv_nsec - start.tv_nsec +
>                 1000000000 * (stop.tv_sec - start.tv_sec);
>
>         pr_info("crc32: nsec_le = %lld nsec_be = %lld\n", nsec_le, nsec_be);
>
>         return 0;
> }
>
> module_init(crc32_init);
> #endif /* CONFIG_CRC32_PERFTEST */
>
> Here are the timings.
>
>          CRC_?E_BITS     crc_le(nsec)       crc_be(nsec)
>                 orig crc32.c                      8                 5842712
> 5829793
>
>                 new crc32.c                     64              2877530
> 2862515
>                 new crc32.c                     32              5174400
> 5105816         (Equiv. to orig. BITS = 8)

I really can't wrap my head around why your 32 bits version is faster than the
current one. Especially as you say that 2D array is a little faster that 1D array.
The current impl. already uses a 2D array. Can you identify what makes you version
faster?

>
> Modify all 'i' loops from for (i = 0; i < foo; i++) { ... } to for (i = foo
> - 1; i >= 0; i--) { ... }

That should be (i = foo; i ; --i) { ... }

>                 + count down                 64              2837860
> 3230438
>
> 2865727              3264033 (repeat)
>                 + count down                 32              5177334
> 5070337
>                    Results seem ambiguous on Nehalem. Slight improvement in
> some cases. 12% worse in one case.
>
> Modify main loop to use pre-increment instead of post-increment.
>                 + pre-increment           64              2872502
> 2767601
>                 + pre-increment           32              5100579
> 5090453
>                     Small scale improvements for each case. Will add to next
> drop.
>
> Do both count down and pre increment
>                 + ct down + pre-inc     64              3329125
> 3367815
>                 + ct down + pre-inc     32              5065308
> 5089825
>                    Got significantly worse for 64 bit slightly better for
> 32.
>
> Separately I looked at the difference between 1D and 2D arrays and 1D arrays
> are a few % faster. The difference is that the loader computes the base
> address at compile time. In the 2D case you have to add an offset to a
> parameter that was passed in to the body routine which is a runtime
> addition.

I image the difference is even bigger on RISC archs like PowerPC and SPARC as
these may need 2 insns to load an address. A relocatable kernel would be even
worse I think.

>
> The first comment below relates to the behavior of gen_crc32table.c which
> always printed out 256x4 byte table entries at a time. The CRC32_?E_BITS = 2
> and 4 cases only read the first 4 and 16 table entries respectively so if
> you are trying to make a really small image you can save most of 1KB by
> shortening the table.

Surely this could be fixed without moving to 1D arrays?

>
> I think I just caused more confusion below. The point is that the two
> routines crc32_le and crc32_be take a byte string as argument which is
> invariant under big/little endian byte order and produce a u32 which is just
> an integer. All the byte swapping in the code is implementation detail and
> has no effect on the result. The caller should just do what you normally do
> with an integer when you use it in a network message e.g. call htonl or
> equivalent before putting it in a packet.
>
> Last point below. The existing code fails sparse with __CHECK_ENDIAN__.
> (There are several other sparse fails in lib as well BTW.) I cleaned up
> these warnings by forcing everything to u32.

What about unrolling the 32 bit variant instead of doing 64 bit? The 64 bit
variant looks like an unrolled 32 bit variant:
+		 		 q = *++p32 ^ crc;
+		 		 i3 = q;
+		 		 i2 = q >> 8;
+		 		 i1 = q >> 16;
+		 		 i0 = q >> 24;
+		 		 crc = t3_be[i3] ^ t2_be[i2] ^ t1_be[i1] ^ t0_be[i0];

+		 		 q = *++p32 ^ crc;
+		 		 i3 = q;
+		 		 i2 = q >> 8;
+		 		 i1 = q >> 16;
+		 		 i0 = q >> 24;
+		 		 crc = t3_be[i3] ^ t2_be[i2] ^ t1_be[i1] ^ t0_be[i0];

I have a really hard time accepting the code duplication your patch introduces.
Can you not find a way to add whatever changes you want into the current impl. ?

Finally, your last patch does to much. Changing the unit test code should
be a separate patch. Restructuring the code is another one and 64 bit support
should be a separate patch too.

 Jocke

>
> I will include Andrew's comments with the above and send out another patch
> soon.
>
> Regards,
>
> Bob Pearson
>
> > -----Original Message-----
> > From: Joakim Tjernlund [mailto:joakim.tjernlund@transmode.se]
> > Sent: Monday, August 01, 2011 4:20 AM
> > To: frank zago; Andrew Morton; Bob Pearson
> > Subject: Re: [PATCH] add slice by 8 algorithm to crc32.c
> >
> >
> > Hi Bob, Frank and Andrew
> >
> > I just got back from vacation and noticed this patch in the kernel mail
> archive.
> > I have pasted some
> > bits from there and commented too.
> >
> > > Hello,
> > >
> > > Added support for slice by 8 to existing crc32 algorithm. Also
> > > modified gen_crc32table.c to only produce table entries that are
> > > actually used.
> >
> > Hmm, I don't get this. What entries are unused?
> >
> > > The parameters CRC_LE_BITS and CRC_BE_BITS determine
> > > the number of bits in the input array that are processed during each
> > > step. Generally the more bits the faster the algorithm is but the
> > > more table data required.
> > >
> > > Using an x86_64 Opteron machine running at 2100MHz the following table
> > > was collected with a pre-warmed cache by computing the crc 1000 times
> > > on a buffer of 4096 bytes.
> > >
> > >        BITS       Size       LE Cycles/byte       BE
> > Cycles/byte
> > >        ----------------------------------------------
> > >        1       873       41.65
> >     34.60
> > >        2       1097       25.43
> >     29.61
> > >        4       1057       13.29
> >     15.28
> > >        8       2913       7.13
> >     8.19
> > >        32       9684       2.80
> >     2.82
> > >        64       18178       1.53
> >     1.53
> > >
> > >        BITS is the value of CRC_LE_BITS or CRC_BE_BITS. The old
> > >        default was 8 which actually selected the 32 bit algorithm.
> In
> > >        this version the value 8 is used to select the standard
> > >        8 bit algorithm and two new values: 32 and 64 are
> introduced
> > >        to select the slice by 4 and slice by 8 algorithms
> respectively.
> > >
> > >        Where Size is the size of crc32.o's text segment which
> > includes
> > >        code and table data when both LE and BE versions are set to
> > BITS.
> >
> > I miss the numbers from the current 32 bits impl. How does this new impl.
> > for 32 bits compare to the current impl?
> >
> > >
> > > The current version of crc32.c by default uses the slice by 4 algorithm
> > > which requires about 2.8 cycles per byte. The slice by 8 algorithm is
> > > roughly 2X faster and enables packet processing at over 1GB/sec on a
> > typical
> > > 2-3GHz system.
> > > --- lib/crc32.c
> > > +++ lib/crc32.c
> > >
> > > ...
> > >
> > > @@ -28,14 +31,17 @@
> > >  #include <linux/init.h>
> > >  #include <asm/atomic.h>
> > >  #include "crc32defs.h"
> > > -#if CRC_LE_BITS == 8
> > > -# define tole(x) __constant_cpu_to_le32(x)
> > > +
> > > +#include <asm/msr.h>
> > > +#if CRC_LE_BITS > 8
> > > +# define tole(x) (__force u32) __constant_cpu_to_le32(x)
> > >  #else
> > >  # define tole(x) (x)
> > >  #endif
> > >
> > > -#if CRC_BE_BITS == 8
> > > -# define tobe(x) __constant_cpu_to_be32(x)
> > > +#if CRC_BE_BITS > 8
> > > +# define tobe(x) (__force u32) __constant_cpu_to_be32(x)
> > >  #else
> > >  # define tobe(x) (x)
> > >  #endif
> > > @@ -45,54 +51,228 @@ MODULE_AUTHOR("Matt Domsch
> > <Matt_Domsch@
> > >  MODULE_DESCRIPTION("Ethernet CRC32 calculations");
> > >  MODULE_LICENSE("GPL");
> > >
> > > -#if CRC_LE_BITS == 8 || CRC_BE_BITS == 8
> > > +#if CRC_LE_BITS > 8
> > > +static inline u32 crc32_le_body(u32 crc, u8 const *buf, size_t len)
> > > +{
> > > +       const u8 *p8;
> > > +       const u32 *p32;
> > > +       int init_bytes, end_bytes;
> > > +       size_t words;
> > > +       int i;
> > > +       u32 q;
> > > +       u8 i0, i1, i2, i3;
> > > +
> > > +       crc = (__force u32) __cpu_to_le32(crc);
> > > +
> > > +#if CRC_LE_BITS == 64
> > > +       p8 = buf;
> > > +       p32 = (u32 *)(((uintptr_t)p8 + 7) & ~7);
> > > +
> > > +       init_bytes = (uintptr_t)p32 - (uintptr_t)p8;
> > > +       if (init_bytes > len)
> > > +              init_bytes = len;
> > > +       words = (len - init_bytes) >> 3;
> > > +       end_bytes = (len - init_bytes) & 7;
> > > +#else
> > > +       p8 = buf;
> > > +       p32 = (u32 *)(((uintptr_t)p8 + 3) & ~3);
> > > +       init_bytes = (uintptr_t)p32 - (uintptr_t)p8;
> > > +       if (init_bytes > len)
> > > +              init_bytes = len;
> > > +       words = (len - init_bytes) >> 2;
> > > +       end_bytes = (len - init_bytes) & 3;
> > > +#endif
> >
> > The difference in the above code is just two constants. Should be possible
> > to avoid code duplication.
> >
> > > +
> > > +       for (i = 0; i < init_bytes; i++) {
> >
> > All for(..) loops should be changed to:
> >   for (i = init_bytes; i ; --i)
> > This is easier for gcc to optimize. Always compare to zero when possible.
> >
> > > +#ifdef __LITTLE_ENDIAN
> > > +              i0 = *p8++ ^ crc;
> > > +              crc = t0_le[i0] ^ (crc >> 8);
> > > +#else
> > > +              i0 = *p8++ ^ (crc >> 24);
> > > +              crc = t0_le[i0] ^ (crc << 8);
> > > +#endif
> > > +       }
> > >
> > Better to hide in macro as current code do.
> > ...
> >
> > > +       for (i = 0; i < words; i++) {
> > > +#ifdef __LITTLE_ENDIAN
> > > +#  if CRC_LE_BITS == 64
> > > +              /* slice by 8 algorithm */
> > > +              q = *p32++ ^ crc;
> > > +              i3 = q;
> > > +              i2 = q >> 8;
> > > +              i1 = q >> 16;
> > > +              i0 = q >> 24;
> > > +              crc = t7_le[i3] ^ t6_le[i2] ^ t5_le[i1] ^
> > t4_le[i0];
> > > +
> > > +              q = *p32++;
> > > +              i3 = q;
> > > +              i2 = q >> 8;
> > > +              i1 = q >> 16;
> > > +              i0 = q >> 24;
> > > +              crc ^= t3_le[i3] ^ t2_le[i2] ^ t1_le[i1] ^
> > t0_le[i0];
> >
> > I am not convinced that converting the table matrix to several arrays is
> faster.
> > Now you have to load 8 addressed and then index them instead of just one
> > address.
> >
> > Also, this looks more like unrolling the 32 bit variant. Are you sure that
> you
> > wont get just as good results by just unrolling the 32 bit variant?
> >
> > You also lost the pre increment which was faster on RISC archs like
> ppc(sparc
> > too?)
> > last time I tested crc32 speed.
> >
> > > +#  else
> > > +              /* slice by 4 algorithm */
> > > +              q = *p32++ ^ crc;
> > > +              i3 = q;
> > > +              i2 = q >> 8;
> > > +              i1 = q >> 16;
> > > +              i0 = q >> 24;
> > > +              crc = t3_le[i3] ^ t2_le[i2] ^ t1_le[i1] ^
> > t0_le[i0];
> > > +#  endif
> >
> > ...
> > > General comment. The use of le/be in this and the previous version of
> > > crc32.c is confusing because it does not refer to little/big endian cpu
> > > architecture but rather to the arbitrary choice made by different
> protocols
> > > as to whether the bits in a byte are presented to the CRC in little/big
> > > *BIT* order. Some protocols (e.g. Ethernet, InfiniBand) process the bits
> > > starting from the LSB and some (e.g. atm) process the bits in MSB order.
> > > These routines (crc32_le and crc32_be) compute the CRC as a u32 in cpu
> > byte
> > > order. The caller has to then get the CRC into the correct order for
> > > inclusion into the message. As a result there are four versions of the
> >
> > No, the caller does not have get the CRC into correct order, this is done
> by
> > crc32 code.
> >
> > > calculation:
> > > BE bit order on BE byte order cpu, BE bit order on LE byte order cpu,
> etc.
> >
> > What would be better? I don't see what to do. Linux requires both LE and
> BE
> > bit
> > ordering. When we optimize heavily, CPU byte order becomes an issue that
> > needs
> > to be dealt with.
> >
> > > Some calculations are simplified by arranging the bits sequentially in
> > WORDS
> > > when we are going to process them in a certain order within each byte.
> This
> > > means that the tables used to compute crc32_be are easier to use in BE
> > byte
> > > order and that tables used to compute crc32_le are easier to use in LE
> byte
> > > order. That is the logic behind the following weird looking macros which
> are
> > > kept the same as the previous version except for the inclusion of
> __force
> > to
> > > pass sparse with -D__CHECK_ENDIAN__.
> >
> > Don't understand, how is you code any different from what we have today?
> >
> >  Jocke
>
>

