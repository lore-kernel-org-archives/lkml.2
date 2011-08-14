Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1HNJ7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 05:59:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52242 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585Ab1HNJ7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 05:59:18 -0400
Date: Sun, 14 Aug 2011 11:59:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: melwyn lobo <linux.melwyn@gmail.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
Subject: Re: x86 memcpy performance
Message-ID: <20110814095910.GA18809@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@elte.hu>, melwyn lobo <linux.melwyn@gmail.com>,
	linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
References: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com>
 <20110812195220.GA29051@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20110812195220.GA29051@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Fri, Aug 12, 2011 at 09:52:20PM +0200, Ingo Molnar wrote:
> Sounds very interesting - it would be nice to see 'perf record' +
> 'perf report' profiles done on that workload, before and after your
> patches.

FWIW, I've been playing with SSE memcpy version for the kernel recently
too, here's what I have so far:

First of all, I did a trace of all the memcpy buffer sizes used while
building a kernel, see attached kernel_build.sizes.

On the one hand, there is a large amount of small chunks copied (1.1M
of 1.2M calls total), and, on the other, a relatively small amount of
larger sized mem copies (256 - 2048 bytes) which are about 100K in total
but which account for the larger cumulative amount of data copied: 138MB
of 175MB total. So, if the buffer copied is big enough, the context
save/restore cost might be something we're willing to pay.

I've implemented the SSE memcpy first in userspace to measure the
speedup vs memcpy_64 we have right now:

Benchmarking with 10000 iterations, average results:
size    XM              MM              speedup
119     540.58          449.491         0.8314969419
189     296.318         263.507         0.8892692985
206     297.949         271.399         0.9108923485
224     255.565         235.38          0.9210161798
221     299.383         276.628         0.9239941159
245     299.806         279.432         0.9320430545
369     314.774         316.89          1.006721324
425     327.536         330.475         1.00897153
439     330.847         334.532         1.01113687
458     333.159         340.124         1.020904708
503     334.44          352.166         1.053003229
767     375.612         429.949         1.144661625
870     358.888         312.572         0.8709465025
882     394.297         454.977         1.153893229
925     403.82          472.56          1.170222413
1009    407.147         490.171         1.203915735
1525    512.059         660.133         1.289174911
1737    556.85          725.552         1.302958536
1778    533.839         711.59          1.332965994
1864    558.06          745.317         1.335549882
2039    585.915         813.806         1.388949687
3068    766.462         1105.56         1.442422252
3471    883.983         1239.99         1.40272883
3570    895.822         1266.74         1.414057295
3748    906.832         1302.4          1.436212771
4086    957.649         1486.93         1.552686041
6130    1238.45         1996.42         1.612023046
6961    1413.11         2201.55         1.557939181
7162    1385.5          2216.49         1.59977178
7499    1440.87         2330.12         1.617158856
8182    1610.74         2720.45         1.688950194
12273   2307.86         4042.88         1.751787902
13924   2431.8          4224.48         1.737184756
14335   2469.4          4218.82         1.708440514
15018   2675.67         1904.07         0.711622886
16374   2989.75         5296.26         1.771470902
24564   4262.15         7696.86         1.805863077
27852   4362.53         3347.72         0.7673805572
28672   5122.8          7113.14         1.388524413
30033   4874.62         8740.04         1.792967931
32768   6014.78         7564.2          1.257603505
49142   14464.2         21114.2         1.459757233
55702   16055           23496.8         1.463523623
57339   16725.7         24553.8         1.46803388
60073   17451.5         24407.3         1.398579162


Size is with randomly generated misalignment to test the implementation.

I've implemented the SSE memcpy similar to arch/x86/lib/mmx_32.c and did
some kernel build traces:

with SSE memcpy
===============

Performance counter stats for '/root/boris/bin/build-kernel.sh' (10 runs):

    3301761.517649 task-clock                #   24.001 CPUs utilized            ( +-  1.48% )
           520,658 context-switches          #    0.000 M/sec                    ( +-  0.25% )
            63,845 CPU-migrations            #    0.000 M/sec                    ( +-  0.58% )
        26,070,835 page-faults               #    0.008 M/sec                    ( +-  0.00% )
 1,812,482,599,021 cycles                    #    0.549 GHz                      ( +-  0.85% ) [64.55%]
   551,783,051,492 stalled-cycles-frontend   #   30.44% frontend cycles idle     ( +-  0.98% ) [65.64%]
   444,996,901,060 stalled-cycles-backend    #   24.55% backend  cycles idle     ( +-  1.15% ) [67.16%]
 1,488,917,931,766 instructions              #    0.82  insns per cycle
                                             #    0.37  stalled cycles per insn  ( +-  0.91% ) [69.25%]
   340,575,978,517 branches                  #  103.150 M/sec                    ( +-  0.99% ) [68.29%]
    21,519,667,206 branch-misses             #    6.32% of all branches          ( +-  1.09% ) [65.11%]

     137.567155255 seconds time elapsed                                          ( +-  1.48% )


plain 3.0
=========

 Performance counter stats for '/root/boris/bin/build-kernel.sh' (10 runs):

    3504754.425527 task-clock                #   24.001 CPUs utilized            ( +-  1.31% )
           518,139 context-switches          #    0.000 M/sec                    ( +-  0.32% )
            61,790 CPU-migrations            #    0.000 M/sec                    ( +-  0.73% )
        26,056,947 page-faults               #    0.007 M/sec                    ( +-  0.00% )
 1,826,757,751,616 cycles                    #    0.521 GHz                      ( +-  0.66% ) [63.86%]
   557,800,617,954 stalled-cycles-frontend   #   30.54% frontend cycles idle     ( +-  0.79% ) [64.65%]
   443,950,768,357 stalled-cycles-backend    #   24.30% backend  cycles idle     ( +-  0.60% ) [67.07%]
 1,469,707,613,500 instructions              #    0.80  insns per cycle
                                             #    0.38  stalled cycles per insn  ( +-  0.68% ) [69.98%]
   335,560,565,070 branches                  #   95.744 M/sec                    ( +-  0.67% ) [69.09%]
    21,365,279,176 branch-misses             #    6.37% of all branches          ( +-  0.65% ) [65.36%]

     146.025263276 seconds time elapsed                                          ( +-  1.31% )


So, although kernel build is probably not the proper workload for an
SSE memcpy routine, I'm seeing 9 secs build time improvement, i.e.
something around 6%. We're executing a bit more instructions but I'd say
the amount of data moved per instruction is higher due to the quadword
moves.

Here's the SSE memcpy version I got so far, I haven't wired in the
proper CPU feature detection yet because we want to run more benchmarks
like netperf and stuff to see whether we see any positive results there.

The SYSTEM_RUNNING check is to take care of early boot situations where
we can't handle FPU exceptions but we use memcpy. There's an aligned and
misaligned variant which should handle any buffers and sizes although
I've set the SSE memcpy threshold at 512 Bytes buffersize the least to
cover context save/restore somewhat.

Comments are much appreciated! :-)

--
>From 385519e844f3466f500774c2c37afe44691ef8d2 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 11 Aug 2011 18:43:08 +0200
Subject: [PATCH] SSE3 memcpy in C

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/string_64.h |   14 ++++-
 arch/x86/lib/Makefile            |    2 +-
 arch/x86/lib/sse_memcpy_64.c     |  133 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 146 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/lib/sse_memcpy_64.c

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 19e2c46..7bd51bb 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -28,10 +28,20 @@ static __always_inline void *__inline_memcpy(void *to, const void *from, size_t
 
 #define __HAVE_ARCH_MEMCPY 1
 #ifndef CONFIG_KMEMCHECK
+extern void *__memcpy(void *to, const void *from, size_t len);
+extern void *__sse_memcpy(void *to, const void *from, size_t len);
 #if (__GNUC__ == 4 && __GNUC_MINOR__ >= 3) || __GNUC__ > 4
-extern void *memcpy(void *to, const void *from, size_t len);
+#define memcpy(dst, src, len)					\
+({								\
+	size_t __len = (len);					\
+	void *__ret;						\
+	if (__len >= 512)					\
+		__ret = __sse_memcpy((dst), (src), __len);	\
+	else							\
+		__ret = __memcpy((dst), (src), __len);		\
+	__ret;							\
+})
 #else
-extern void *__memcpy(void *to, const void *from, size_t len);
 #define memcpy(dst, src, len)					\
 ({								\
 	size_t __len = (len);					\
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index f2479f1..5f90709 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -36,7 +36,7 @@ ifneq ($(CONFIG_X86_CMPXCHG64),y)
 endif
         lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
 else
-        obj-y += iomap_copy_64.o
+        obj-y += iomap_copy_64.o sse_memcpy_64.o
         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
         lib-y += thunk_64.o clear_page_64.o copy_page_64.o
         lib-y += memmove_64.o memset_64.o
diff --git a/arch/x86/lib/sse_memcpy_64.c b/arch/x86/lib/sse_memcpy_64.c
new file mode 100644
index 0000000..b53fc31
--- /dev/null
+++ b/arch/x86/lib/sse_memcpy_64.c
@@ -0,0 +1,133 @@
+#include <linux/module.h>
+
+#include <asm/i387.h>
+#include <asm/string_64.h>
+
+void *__sse_memcpy(void *to, const void *from, size_t len)
+{
+	unsigned long src = (unsigned long)from;
+	unsigned long dst = (unsigned long)to;
+	void *p = to;
+	int i;
+
+	if (in_interrupt())
+		return __memcpy(to, from, len);
+
+	if (system_state != SYSTEM_RUNNING)
+		return __memcpy(to, from, len);
+
+	kernel_fpu_begin();
+
+	/* check alignment */
+	if ((src ^ dst) & 0xf)
+		goto unaligned;
+
+	if (src & 0xf) {
+		u8 chunk = 0x10 - (src & 0xf);
+
+		/* copy chunk until next 16-byte  */
+		__memcpy(to, from, chunk);
+		len -= chunk;
+		to += chunk;
+		from += chunk;
+	}
+
+	/*
+	 * copy in 256 Byte portions
+	 */
+	for (i = 0; i < (len & ~0xff); i += 256) {
+		asm volatile(
+		"movaps 0x0(%0),  %%xmm0\n\t"
+		"movaps 0x10(%0), %%xmm1\n\t"
+		"movaps 0x20(%0), %%xmm2\n\t"
+		"movaps 0x30(%0), %%xmm3\n\t"
+		"movaps 0x40(%0), %%xmm4\n\t"
+		"movaps 0x50(%0), %%xmm5\n\t"
+		"movaps 0x60(%0), %%xmm6\n\t"
+		"movaps 0x70(%0), %%xmm7\n\t"
+		"movaps 0x80(%0), %%xmm8\n\t"
+		"movaps 0x90(%0), %%xmm9\n\t"
+		"movaps 0xa0(%0), %%xmm10\n\t"
+		"movaps 0xb0(%0), %%xmm11\n\t"
+		"movaps 0xc0(%0), %%xmm12\n\t"
+		"movaps 0xd0(%0), %%xmm13\n\t"
+		"movaps 0xe0(%0), %%xmm14\n\t"
+		"movaps 0xf0(%0), %%xmm15\n\t"
+
+		"movaps %%xmm0,  0x0(%1)\n\t"
+		"movaps %%xmm1,  0x10(%1)\n\t"
+		"movaps %%xmm2,  0x20(%1)\n\t"
+		"movaps %%xmm3,  0x30(%1)\n\t"
+		"movaps %%xmm4,  0x40(%1)\n\t"
+		"movaps %%xmm5,  0x50(%1)\n\t"
+		"movaps %%xmm6,  0x60(%1)\n\t"
+		"movaps %%xmm7,  0x70(%1)\n\t"
+		"movaps %%xmm8,  0x80(%1)\n\t"
+		"movaps %%xmm9,  0x90(%1)\n\t"
+		"movaps %%xmm10, 0xa0(%1)\n\t"
+		"movaps %%xmm11, 0xb0(%1)\n\t"
+		"movaps %%xmm12, 0xc0(%1)\n\t"
+		"movaps %%xmm13, 0xd0(%1)\n\t"
+		"movaps %%xmm14, 0xe0(%1)\n\t"
+		"movaps %%xmm15, 0xf0(%1)\n\t"
+		: : "r" (from), "r" (to) : "memory");
+
+		from += 256;
+		to += 256;
+	}
+
+	goto trailer;
+
+unaligned:
+	/*
+	 * copy in 256 Byte portions unaligned
+	 */
+	for (i = 0; i < (len & ~0xff); i += 256) {
+		asm volatile(
+		"movups 0x0(%0),  %%xmm0\n\t"
+		"movups 0x10(%0), %%xmm1\n\t"
+		"movups 0x20(%0), %%xmm2\n\t"
+		"movups 0x30(%0), %%xmm3\n\t"
+		"movups 0x40(%0), %%xmm4\n\t"
+		"movups 0x50(%0), %%xmm5\n\t"
+		"movups 0x60(%0), %%xmm6\n\t"
+		"movups 0x70(%0), %%xmm7\n\t"
+		"movups 0x80(%0), %%xmm8\n\t"
+		"movups 0x90(%0), %%xmm9\n\t"
+		"movups 0xa0(%0), %%xmm10\n\t"
+		"movups 0xb0(%0), %%xmm11\n\t"
+		"movups 0xc0(%0), %%xmm12\n\t"
+		"movups 0xd0(%0), %%xmm13\n\t"
+		"movups 0xe0(%0), %%xmm14\n\t"
+		"movups 0xf0(%0), %%xmm15\n\t"
+
+		"movups %%xmm0,  0x0(%1)\n\t"
+		"movups %%xmm1,  0x10(%1)\n\t"
+		"movups %%xmm2,  0x20(%1)\n\t"
+		"movups %%xmm3,  0x30(%1)\n\t"
+		"movups %%xmm4,  0x40(%1)\n\t"
+		"movups %%xmm5,  0x50(%1)\n\t"
+		"movups %%xmm6,  0x60(%1)\n\t"
+		"movups %%xmm7,  0x70(%1)\n\t"
+		"movups %%xmm8,  0x80(%1)\n\t"
+		"movups %%xmm9,  0x90(%1)\n\t"
+		"movups %%xmm10, 0xa0(%1)\n\t"
+		"movups %%xmm11, 0xb0(%1)\n\t"
+		"movups %%xmm12, 0xc0(%1)\n\t"
+		"movups %%xmm13, 0xd0(%1)\n\t"
+		"movups %%xmm14, 0xe0(%1)\n\t"
+		"movups %%xmm15, 0xf0(%1)\n\t"
+		: : "r" (from), "r" (to) : "memory");
+
+		from += 256;
+		to += 256;
+	}
+
+trailer:
+	__memcpy(to, from, len & 0xff);
+
+	kernel_fpu_end();
+
+	return p;
+}
+EXPORT_SYMBOL_GPL(__sse_memcpy);
-- 
1.7.6.134.gcf13f6


-- 
Regards/Gruss,
    Boris.

--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="kernel_build.sizes"

Bytes	Count
=====	=====
0	5447
1	3850
2	16255
3	11113
4	68870
5	4256
6	30433
7	19188
8	50490
9	5999
10	78275
11	5628
12	6870
13	7371
14	4742
15	4911
16	143835
17	14096
18	1573
19	13603
20	424321
21	741
22	584
23	450
24	472
25	685
26	367
27	365
28	333
29	301
30	300
31	269
32	489
33	272
34	266
35	220
36	239
37	209
38	249
39	235
40	207
41	181
42	150
43	98
44	194
45	66
46	62
47	52
48	67226
49	138
50	171
51	26
52	20
53	12
54	15
55	4
56	13
57	8
58	6
59	6
60	115
61	10
62	5
63	12
64	67353
65	6
66	2363
67	9
68	11
69	6
70	5
71	6
72	10
73	4
74	9
75	8
76	4
77	6
78	3
79	4
80	3
81	4
82	4
83	4
84	4
85	8
86	6
87	2
88	3
89	2
90	2
91	1
92	9
93	1
94	2
96	2
97	2
98	3
100	2
102	1
104	1
105	1
106	1
107	2
109	1
110	1
111	1
112	1
113	2
115	2
117	1
118	1
119	1
120	14
127	1
128	1
130	1
131	2
134	2
137	1
144	100092
149	1
151	1
153	1
158	1
185	1
217	4
224	3
225	3
227	3
244	1
254	5
255	13
256	21708
512	21746
848	12907
1920	36536
2048	21708

--fdj2RfSjLxBAspz7--
