Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab0KZVKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:10:33 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:40922 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751540Ab0KZVJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:09:57 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: T43iokwVM1nFs43aDerdJZJVQ3_vd2xK08a5T5J7qVW8xOW
 uDRvRNWPVTv_3dxNZTYZKT53G5mlTiGLQdA.lLi78kibU8ftCtSHQ8YdXJYm
 bpNvM6VS7ZJHFi.zKSpsTfoWY576IazVHnAlQgur8EITzLNdXN9YeypojP6Y
 a634GU83KhZBU0klwzMxiB1cQkMMJPVs8hgep67LVxFPI1tX9RTDYW.eQkUb
 otMX8OG7OtqNc8B7hNfcchQBrWAU.pgtgwoHHAEUcs8zraIjS1S5o
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101126210954.745512583@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 26 Nov 2010 15:09:47 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [thisops uV2 10/10] slub: Lockless fastpaths 
References: <20101126210937.383047168@linux.com>
Content-Disposition: inline; filename=slub_generation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the this_cpu_cmpxchg_double functionality to implement a lockless
allocation algorithm.

Each of the per cpu pointers is paired with a transaction id that ensures
that updates of the per cpu information can only occur in sequence on
a certain cpu.

A transaction id is a "long" integer that is comprised of an event number
and the cpu number. The event number is incremented for every change to the
per cpu state. This means that the cmpxchg instruction can verify for an
update that nothing interfered and that we are updating the percpu structure
for the processor where we picked up the information and that we are also
currently on that processor when we update the information.

This results in a significant decrease of the overhead in the fastpaths. It
also makes it easy to adopt the fast path for realtime kernels since this
is lockless and does not require that the use of the current per cpu area
over the critical section. It is only important that the per cpu area is
current at the beginning of the critical section and at that end.

So there is no need even to disable preemption which will make the allocations
scale well in a RT environment.

V1->V2:
	- Round cpu number to the next power of two.
	- Deal with debug hooks that expect irqs to be disabled.
	- Performance test

Test results show that the fastpath cycle count is reduced by up to ~ 40%
(alloc/free test goes from ~140 cycles down to ~80). The slowpath for kfree
adds a few cycles.

Sadly this does nothing for the slowpath which is where the issues with
performance in slub are but the best case performance rises significantly.

Before:

Single thread testing
=====================
1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) -> 102 cycles kfree -> 111 cycles
10000 times kmalloc(16) -> 101 cycles kfree -> 111 cycles
10000 times kmalloc(32) -> 120 cycles kfree -> 114 cycles
10000 times kmalloc(64) -> 161 cycles kfree -> 130 cycles
10000 times kmalloc(128) -> 284 cycles kfree -> 129 cycles
10000 times kmalloc(256) -> 410 cycles kfree -> 134 cycles
10000 times kmalloc(512) -> 312 cycles kfree -> 197 cycles
10000 times kmalloc(1024) -> 377 cycles kfree -> 494 cycles
10000 times kmalloc(2048) -> 571 cycles kfree -> 522 cycles
10000 times kmalloc(4096) -> 674 cycles kfree -> 565 cycles
10000 times kmalloc(8192) -> 836 cycles kfree -> 648 cycles
10000 times kmalloc(16384) -> 1201 cycles kfree -> 775 cycles
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree -> 142 cycles
10000 times kmalloc(16)/kfree -> 142 cycles
10000 times kmalloc(32)/kfree -> 142 cycles
10000 times kmalloc(64)/kfree -> 142 cycles
10000 times kmalloc(128)/kfree -> 142 cycles
10000 times kmalloc(256)/kfree -> 140 cycles
10000 times kmalloc(512)/kfree -> 140 cycles
10000 times kmalloc(1024)/kfree -> 144 cycles
10000 times kmalloc(2048)/kfree -> 144 cycles
10000 times kmalloc(4096)/kfree -> 144 cycles
10000 times kmalloc(8192)/kfree -> 144 cycles
10000 times kmalloc(16384)/kfree -> 913 cycles

After:

1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) -> 69 cycles kfree -> 115 cycles
10000 times kmalloc(16) -> 73 cycles kfree -> 115 cycles
10000 times kmalloc(32) -> 86 cycles kfree -> 119 cycles
10000 times kmalloc(64) -> 122 cycles kfree -> 125 cycles
10000 times kmalloc(128) -> 247 cycles kfree -> 132 cycles
10000 times kmalloc(256) -> 375 cycles kfree -> 137 cycles
10000 times kmalloc(512) -> 283 cycles kfree -> 183 cycles
10000 times kmalloc(1024) -> 316 cycles kfree -> 504 cycles
10000 times kmalloc(2048) -> 516 cycles kfree -> 531 cycles
10000 times kmalloc(4096) -> 610 cycles kfree -> 570 cycles
10000 times kmalloc(8192) -> 759 cycles kfree -> 651 cycles
10000 times kmalloc(16384) -> 1169 cycles kfree -> 778 cycles
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree -> 81 cycles
10000 times kmalloc(16)/kfree -> 81 cycles
10000 times kmalloc(32)/kfree -> 81 cycles
10000 times kmalloc(64)/kfree -> 81 cycles
10000 times kmalloc(128)/kfree -> 81 cycles
10000 times kmalloc(256)/kfree -> 87 cycles
10000 times kmalloc(512)/kfree -> 87 cycles
10000 times kmalloc(1024)/kfree -> 87 cycles
10000 times kmalloc(2048)/kfree -> 84 cycles
10000 times kmalloc(4096)/kfree -> 81 cycles
10000 times kmalloc(8192)/kfree -> 81 cycles
10000 times kmalloc(16384)/kfree -> 927 cycles


Concurrent allocs
=================
Before:

Kmalloc N*alloc N*free(8): 0=118/128 1=125/131 2=118/147 3=123/133 4=115/128 5=122/149 6=118/130 7=120/133 Average=120/135
Kmalloc N*alloc N*free(16): 0=137/147 1=154/141 2=128/145 3=130/143 4=122/143 5=144/142 6=128/141 7=145/142 Average=136/143
Kmalloc N*alloc N*free(32): 0=170/269 1=175/269 2=159/273 3=193/266 4=156/268 5=160/273 6=163/267 7=185/268 Average=170/269
Kmalloc N*alloc N*free(64): 0=284/1090 1=257/1088 2=258/1086 3=259/1086 4=242/1077 5=264/1091 6=279/1086 7=255/1089 Average=262/1087
Kmalloc N*alloc N*free(128): 0=445/2320 1=444/2323 2=437/2318 3=443/2321 4=416/2309 5=435/2323 6=428/2310 7=434/2321 Average=435/2318
Kmalloc N*alloc N*free(256): 0=1138/1171 1=1153/1271 2=1144/1262 3=1155/1281 4=1147/1246 5=1154/1229 6=1147/1252 7=1149/1192 Average=1148/1238
Kmalloc N*alloc N*free(512): 0=1684/1741 1=1700/1781 2=1709/1751 3=1708/1723 4=1696/1650 5=1707/1808 6=1697/1775 7=1706/1814 Average=1701/1755
Kmalloc N*alloc N*free(1024): 0=3116/3334 1=3224/3338 2=3215/3337 3=3159/3335 4=3118/3289 5=3090/3354 6=3119/3272 7=3091/3352 Average=3142/3326
Kmalloc N*alloc N*free(2048): 0=3342/3408 1=3371/3388 2=3357/3436 3=3356/3465 4=3367/3445 5=3372/3460 6=3357/3438 7=3369/3433 Average=3361/3434
Kmalloc N*alloc N*free(4096): 0=3641/8467 1=3659/8496 2=3651/8454 3=3660/8488 4=3659/8446 5=3656/8488 6=3646/8406 7=3664/8478 Average=3654/8465
Kmalloc N*(alloc free)(8): 0=154 1=156 2=153 3=156 4=154 5=156 6=155 7=156 Average=155
Kmalloc N*(alloc free)(16): 0=154 1=156 2=154 3=156 4=154 5=156 6=154 7=156 Average=155
Kmalloc N*(alloc free)(32): 0=154 1=156 2=153 3=156 4=154 5=156 6=154 7=156 Average=155
Kmalloc N*(alloc free)(64): 0=154 1=156 2=153 3=156 4=155 5=157 6=155 7=157 Average=156
Kmalloc N*(alloc free)(128): 0=154 1=156 2=153 3=156 4=154 5=158 6=154 7=156 Average=155
Kmalloc N*(alloc free)(256): 0=156 1=153 2=150 3=157 4=151 5=153 6=155 7=157 Average=154
Kmalloc N*(alloc free)(512): 0=157 1=168 2=154 3=157 4=155 5=157 6=155 7=157 Average=157
Kmalloc N*(alloc free)(1024): 0=157 1=157 2=155 3=159 4=157 5=158 6=157 7=160 Average=158
Kmalloc N*(alloc free)(2048): 0=155 1=157 2=155 3=172 4=156 5=157 6=152 7=157 Average=158
Kmalloc N*(alloc free)(4096): 0=155 1=157 2=155 3=157 4=155 5=157 6=156 7=157 Average=156

After:

Kmalloc N*alloc N*free(8): 0=90/168 1=86/139 2=82/137 3=88/147 4=81/142 5=89/164 6=87/141 7=100/140 Average=88/147
Kmalloc N*alloc N*free(16): 0=93/158 1=116/161 2=94/149 3=103/161 4=87/149 5=113/168 6=90/149 7=119/153 Average=102/156
Kmalloc N*alloc N*free(32): 0=137/191 1=154/192 2=129/187 3=139/188 4=122/186 5=134/195 6=125/186 7=147/185 Average=136/189
Kmalloc N*alloc N*free(64): 0=227/1054 1=269/1062 2=226/1059 3=235/1059 4=198/1063 5=220/1061 6=248/1052 7=211/1062 Average=229/1059
Kmalloc N*alloc N*free(128): 0=406/2217 1=383/2247 2=395/2218 3=389/2240 4=386/2208 5=405/2224 6=381/2207 7=398/2224 Average=393/2223
Kmalloc N*alloc N*free(256): 0=1120/1038 1=1125/1168 2=1123/1153 3=1118/1156 4=1107/1134 5=1121/1190 6=1111/1087 7=1124/1026 Average=1119/1119
Kmalloc N*alloc N*free(512): 0=1691/1812 1=1728/1806 2=1710/1781 3=1718/1810 4=1719/1723 5=1727/1826 6=1710/1757 7=1712/1815 Average=1714/1791
Kmalloc N*alloc N*free(1024): 0=3169/3344 1=3162/3306 2=3134/3347 3=3162/3320 4=3166/3328 5=3179/3242 6=3147/3344 7=3160/3265 Average=3160/3312
Kmalloc N*alloc N*free(2048): 0=3366/3448 1=3382/3463 2=3371/3464 3=3386/3431 4=3375/3428 5=3371/3445 6=3379/3426 7=3385/3378 Average=3377/3435
Kmalloc N*alloc N*free(4096): 0=3761/8883 1=3780/8924 2=3768/8880 3=3779/8921 4=3775/8871 5=3781/8915 6=3770/8860 7=3780/8911 Average=3774/8896
Kmalloc N*(alloc free)(8): 0=94 1=97 2=94 3=96 4=95 5=97 6=94 7=97 Average=96
Kmalloc N*(alloc free)(16): 0=95 1=97 2=94 3=97 4=95 5=97 6=95 7=97 Average=96
Kmalloc N*(alloc free)(32): 0=101 1=98 2=94 3=98 4=95 5=98 6=95 7=98 Average=97
Kmalloc N*(alloc free)(64): 0=95 1=97 2=95 3=98 4=95 5=97 6=94 7=97 Average=96
Kmalloc N*(alloc free)(128): 0=100 1=97 2=94 3=97 4=95 5=97 6=95 7=96 Average=96
Kmalloc N*(alloc free)(256): 0=86 1=102 2=87 3=96 4=91 5=99 6=91 7=101 Average=94
Kmalloc N*(alloc free)(512): 0=103 1=98 2=95 3=98 4=101 5=99 6=101 7=104 Average=100
Kmalloc N*(alloc free)(1024): 0=102 1=102 2=99 3=96 4=100 5=100 6=101 7=96 Average=100
Kmalloc N*(alloc free)(2048): 0=99 1=102 2=98 3=103 4=100 5=102 6=100 7=95 Average=100
Kmalloc N*(alloc free)(4096): 0=98 1=103 2=98 3=104 4=101 5=102 6=97 7=102 Average=101

Remote free test
================

Before:

N*remote free(8): 0=6/987 1=120/0 2=117/0 3=117/0 4=115/0 5=119/0 6=115/0 7=119/0 Average=104/123
N*remote free(16): 0=6/1170 1=129/0 2=132/0 3=129/0 4=134/0 5=128/0 6=136/0 7=130/0 Average=115/146
N*remote free(32): 0=6/1447 1=177/0 2=164/0 3=174/0 4=177/0 5=175/0 6=178/0 7=175/0 Average=153/180
N*remote free(64): 0=6/2021 1=377/0 2=274/0 3=341/0 4=295/0 5=334/0 6=311/0 7=311/0 Average=281/252
N*remote free(128): 0=6/2415 1=588/0 2=454/0 3=588/0 4=469/0 5=600/0 6=526/0 7=582/0 Average=477/302
N*remote free(256): 0=6/2708 1=857/0 2=803/0 3=856/0 4=817/0 5=851/0 6=816/0 7=848/0 Average=732/338
N*remote free(512): 0=6/3110 1=1285/0 2=1265/0 3=1280/0 4=1268/0 5=1288/0 6=1262/0 7=1281/0 Average=1117/388
N*remote free(1024): 0=6/3756 1=2566/0 2=2554/0 3=2566/0 4=2552/0 5=2547/0 6=2542/0 7=2564/0 Average=2237/469
N*remote free(2048): 0=6/4253 1=2813/0 2=2816/0 3=2817/0 4=2786/0 5=2816/0 6=2789/0 7=2818/0 Average=2458/531
N*remote free(4096): 0=6/5138 1=3056/0 2=3048/0 3=3055/0 4=3030/0 5=3060/0 6=3032/0 7=3055/0 Average=2668/642

After:

N*remote free(8): 0=6/1008 1=82/0 2=81/0 3=84/0 4=84/0 5=84/0 6=84/0 7=83/0 Average=74/126
N*remote free(16): 0=6/1165 1=102/0 2=93/0 3=101/0 4=96/0 5=99/0 6=94/0 7=100/0 Average=86/145
N*remote free(32): 0=6/1462 1=150/0 2=135/0 3=150/0 4=143/0 5=153/0 6=145/0 7=148/0 Average=129/182
N*remote free(64): 0=6/2068 1=346/0 2=246/0 3=287/0 4=268/0 5=309/0 6=271/0 7=346/0 Average=260/258
N*remote free(128): 0=6/2425 1=577/0 2=468/0 3=555/0 4=531/0 5=552/0 6=464/0 7=560/0 Average=464/303
N*remote free(256): 0=6/2788 1=838/0 2=778/0 3=836/0 4=806/0 5=836/0 6=813/0 7=833/0 Average=718/348
N*remote free(512): 0=6/3147 1=1306/0 2=1269/0 3=1301/0 4=1273/0 5=1296/0 6=1289/0 7=1300/0 Average=1130/393
N*remote free(1024): 0=6/3785 1=2565/0 2=2535/0 3=2564/0 4=2524/0 5=2568/0 6=2545/0 7=2565/0 Average=2234/473
N*remote free(2048): 0=6/4284 1=2822/0 2=2819/0 3=2818/0 4=2797/0 5=2827/0 6=2810/0 7=2828/0 Average=2466/535
N*remote free(4096): 0=6/5177 1=3097/0 2=3086/0 3=3091/0 4=3064/0 5=3101/0 6=3072/0 7=3099/0 Average=2702/647

1 alloc N free test
===================

Before:

1 alloc N free(8): 0=1227 1=568 2=307 3=523 4=330 5=567 6=349 7=516 Average=548
1 alloc N free(16): 0=1444 1=625 2=588 3=627 4=587 5=627 6=600 7=616 Average=714
1 alloc N free(32): 0=1796 1=814 2=796 3=817 4=795 5=820 6=798 7=819 Average=932
1 alloc N free(64): 0=2906 1=1598 2=1595 3=1597 4=1596 5=1596 6=1595 7=1595 Average=1760
1 alloc N free(128): 0=4686 1=1815 2=1813 3=1813 4=1812 5=1813 6=1812 7=1813 Average=2172
1 alloc N free(256): 0=4884 1=1793 2=1788 3=1790 4=1788 5=1792 6=1788 7=1792 Average=2177
1 alloc N free(512): 0=4956 1=1780 2=1778 3=1780 4=1778 5=1778 6=1778 7=1778 Average=2176
1 alloc N free(1024): 0=5225 1=1696 2=1692 3=1699 4=1693 5=1698 6=1694 7=1698 Average=2137
1 alloc N free(2048): 0=5683 1=1822 2=1821 3=1822 4=1822 5=1821 6=1822 7=1821 Average=2304
1 alloc N free(4096): 0=6049 1=1477 2=1478 3=1478 4=1477 5=1478 6=1478 7=1478 Average=2049

After:
1 alloc N free(8): 0=932 1=381 2=259 3=407 4=301 5=414 6=304 7=414 Average=427
1 alloc N free(16): 0=1020 1=372 2=328 3=372 4=337 5=362 6=338 7=362 Average=436
1 alloc N free(32): 0=1628 1=847 2=826 3=846 4=825 5=840 6=825 7=844 Average=935
1 alloc N free(64): 0=2043 1=944 2=938 3=939 4=937 5=943 6=937 7=942 Average=1078
1 alloc N free(128): 0=4249 1=1597 2=1584 3=1592 4=1590 5=1595 6=1588 7=1593 Average=1923
1 alloc N free(256): 0=4529 1=1620 2=1614 3=1620 4=1614 5=1620 6=1615 7=1620 Average=1982
1 alloc N free(512): 0=4530 1=1548 2=1545 3=1547 4=1544 5=1545 6=1545 7=1545 Average=1919
1 alloc N free(1024): 0=5187 1=1822 2=1821 3=1823 4=1821 5=1823 6=1822 7=1822 Average=2243
1 alloc N free(2048): 0=5441 1=1803 2=1803 3=1799 4=1800 5=1802 6=1800 7=1801 Average=2256
1 alloc N free(4096): 0=5949 1=1580 2=1579 3=1579 4=1578 5=1579 6=1578 7=1578 Average=2125

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/slub_def.h |    3 
 mm/slub.c                |  171 ++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 149 insertions(+), 25 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2010-11-26 10:45:54.000000000 -0600
+++ linux-2.6/include/linux/slub_def.h	2010-11-26 11:18:07.000000000 -0600
@@ -36,7 +36,8 @@ enum stat_item {
 	NR_SLUB_STAT_ITEMS };
 
 struct kmem_cache_cpu {
-	void **freelist;	/* Pointer to first free per cpu object */
+	void **freelist;		/* Pointer to next available object */
+	unsigned long tid;	/* Globally unique transaction id */
 	struct page *page;	/* The slab from which we are allocating */
 	int node;		/* The node of the page (or -1 for debug) */
 #ifdef CONFIG_SLUB_STATS
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-11-26 10:45:54.000000000 -0600
+++ linux-2.6/mm/slub.c	2010-11-26 11:49:56.000000000 -0600
@@ -805,14 +805,20 @@ static inline void slab_post_alloc_hook(
 static inline void slab_free_hook(struct kmem_cache *s, void *x)
 {
 	kmemleak_free_recursive(x, s->flags);
-}
 
-static inline void slab_free_hook_irq(struct kmem_cache *s, void *object)
-{
+	/*
+	 * Trouble is that we no longer disable interupts in the fast path
+	 * So in order to make the debug calls that expect irqs to be
+	 * disabled we need to disable interrupts temporarily.
+	 */
+#if defined(CONFIG_KMEMCHECK) || defined(CONFIG_LOCKDEP)
+	local_irq_save(flags);
 	kmemcheck_slab_free(s, object, s->objsize);
 	debug_check_no_locks_freed(object, s->objsize);
 	if (!(s->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(object, s->objsize);
+	local_irq_restore(flags);
+#endif
 }
 
 /*
@@ -1099,9 +1105,6 @@ static inline void slab_post_alloc_hook(
 
 static inline void slab_free_hook(struct kmem_cache *s, void *x) {}
 
-static inline void slab_free_hook_irq(struct kmem_cache *s,
-		void *object) {}
-
 #endif /* CONFIG_SLUB_DEBUG */
 
 /*
@@ -1486,6 +1489,53 @@ static void unfreeze_slab(struct kmem_ca
 }
 
 /*
+ * Calculate the next globally unique transaction for disambiguiation
+ * during cmpxchg. The transactions start with the cpu number and are then
+ * incremented by CONFIG_NR_CPUS.
+ */
+#define TID_STEP  roundup_pow_of_two(CONFIG_NR_CPUS)
+
+static inline unsigned long next_tid(unsigned long tid)
+{
+	return tid + TID_STEP;
+}
+
+static inline unsigned int tid_to_cpu(unsigned long tid)
+{
+	return tid % TID_STEP;
+}
+
+static inline unsigned long tid_to_event(unsigned long tid)
+{
+	return tid / TID_STEP;
+}
+
+static inline unsigned int init_tid(int cpu)
+{
+	return cpu;
+}
+
+static void note_cmpxchg_failure(const char *n,
+		const struct kmem_cache *s, unsigned long tid)
+{
+#ifdef CONFIG_DEBUG_VM
+	unsigned long actual_tid = __this_cpu_read(s->cpu_slab->tid);
+
+	printk(KERN_INFO "%s %s: cmpxchg redo ", n, s->name);
+
+	if (tid_to_cpu(tid) != tid_to_cpu(actual_tid))
+		printk("due to cpu change %d -> %d\n",
+			tid_to_cpu(tid), tid_to_cpu(actual_tid));
+	else if (tid_to_event(tid) != tid_to_event(actual_tid))
+		printk("due to cpu running other code. Event %ld->%ld\n",
+			tid_to_event(tid), tid_to_event(actual_tid));
+	else
+		printk("for unknown reason: actual=%lx was=%lx target=%lx\n",
+			actual_tid, tid, next_tid(tid));
+#endif
+}
+
+/*
  * Remove the cpu slab
  */
 static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
@@ -1509,6 +1559,7 @@ static void deactivate_slab(struct kmem_
 		/* Retrieve object from cpu_freelist */
 		object = c->freelist;
 		c->freelist = get_freepointer(s, c->freelist);
+		c->tid = next_tid(c->tid);
 
 		/* And put onto the regular freelist */
 		set_freepointer(s, object, page->freelist);
@@ -1646,10 +1697,19 @@ slab_out_of_memory(struct kmem_cache *s,
  * a call to the page allocator and the setup of a new slab.
  */
 static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
-			  unsigned long addr, struct kmem_cache_cpu *c)
+			  unsigned long addr)
 {
 	void **object;
 	struct page *new;
+	unsigned long flags;
+	struct kmem_cache_cpu *c;
+
+	local_irq_save(flags);
+	/*
+	 * Interrupts are disabled. We will continue to run on this cpu
+	 * an no other code may interrupt.
+	 */
+	c = this_cpu_ptr(s->cpu_slab);
 
 	/* We handle __GFP_ZERO in the caller */
 	gfpflags &= ~__GFP_ZERO;
@@ -1675,7 +1735,9 @@ load_freelist:
 	c->page->freelist = NULL;
 	c->node = page_to_nid(c->page);
 unlock_out:
+	c->tid = next_tid(c->tid);
 	slab_unlock(c->page);
+	local_irq_restore(flags);
 	stat(s, ALLOC_SLOWPATH);
 	return object;
 
@@ -1737,25 +1799,57 @@ static __always_inline void *slab_alloc(
 {
 	void **object;
 	struct kmem_cache_cpu *c;
-	unsigned long flags;
+	unsigned long tid;
 
 	if (slab_pre_alloc_hook(s, gfpflags))
 		return NULL;
 
-	local_irq_save(flags);
+redo:
+	/*
+	 * Must read kmem_cache cpu data via this cpu ptr. Preemption is
+	 * enabled. We may switch back and forth between cpus while
+	 * reading from one cpu area. That does not matter as long
+	 * as we end up on the original cpu again when doing the cmpxchg.
+	 */
 	c = __this_cpu_ptr(s->cpu_slab);
+
+	/*
+	 * The transaction ids are globally unique per cpu and per operation on
+	 * a per cpu queue. Thus they can be guarantee that the cmpxchg_double
+	 * occurs on the right processor and that there was no operation on the
+	 * linked list in between.
+	 */
+	tid = c->tid;
+	barrier();
+
 	object = c->freelist;
-	if (unlikely(!object || !node_match(c, node)))
+	if (unlikely(!object || !node_match(c, c->node)))
 
-		object = __slab_alloc(s, gfpflags, node, addr, c);
+		object = __slab_alloc(s, gfpflags, c->node, addr);
 
 	else {
-		c->freelist = get_freepointer(s, object);
+		/*
+		 * The cmpxchg will only match if there was not additonal
+		 * operation and if we are on the right processor.
+		 *
+		 * The cmpxchg does the following atomically (without lock semantics!)
+		 * 1. Relocate first pointer to the current per cpu area.
+		 * 2. Verify that tid and freelist have not been changed
+		 * 3. If they were not changed replace tid and freelist
+		 *
+		 * Since this is without lock semantics the protection is only against
+		 * code executing on this cpu *not* from access by other cpus.
+		 */
+		if (unlikely(!irqsafe_cmpxchg_double(&s->cpu_slab->freelist, object, tid,
+				get_freepointer(s, object), next_tid(tid)))) {
+
+			note_cmpxchg_failure("slab_alloc", s, tid);
+			goto redo;
+		}
 		stat(s, ALLOC_FASTPATH);
 	}
-	local_irq_restore(flags);
 
-	if (unlikely(gfpflags & __GFP_ZERO) && object)
+	if ((gfpflags & __GFP_ZERO) && object)
 		memset(object, 0, s->objsize);
 
 	slab_post_alloc_hook(s, gfpflags, object);
@@ -1817,8 +1911,10 @@ static void __slab_free(struct kmem_cach
 {
 	void *prior;
 	void **object = (void *)x;
+	unsigned long flags;
 
 	stat(s, FREE_SLOWPATH);
+	local_irq_save(flags);
 	slab_lock(page);
 
 	if (kmem_cache_debug(s))
@@ -1849,6 +1945,7 @@ checks_ok:
 
 out_unlock:
 	slab_unlock(page);
+	local_irq_restore(flags);
 	return;
 
 slab_empty:
@@ -1860,6 +1957,7 @@ slab_empty:
 		stat(s, FREE_REMOVE_PARTIAL);
 	}
 	slab_unlock(page);
+	local_irq_restore(flags);
 	stat(s, FREE_SLAB);
 	discard_slab(s, page);
 	return;
@@ -1886,23 +1984,36 @@ static __always_inline void slab_free(st
 {
 	void **object = (void *)x;
 	struct kmem_cache_cpu *c;
-	unsigned long flags;
+	unsigned long tid;
 
 	slab_free_hook(s, x);
 
-	local_irq_save(flags);
-	c = __this_cpu_ptr(s->cpu_slab);
+redo:
+	/*
+	 * Determine the currently cpus per cpu slab.
+	 * The cpu may change afterward. However that does not matter since
+	 * data is retrieved via this pointer. If we are on the same cpu
+	 * during the cmpxchg then the free will succedd.
+	 */
+	c = this_cpu_ptr(s->cpu_slab);
+	tid = c->tid;
+	barrier();
 
-	slab_free_hook_irq(s, x);
+	if (likely(page == c->page) &&
+			c->node != NUMA_NO_NODE) {
 
-	if (likely(page == c->page && c->node != NUMA_NO_NODE)) {
 		set_freepointer(s, object, c->freelist);
-		c->freelist = object;
+
+		if (unlikely(!irqsafe_cmpxchg_double(&s->cpu_slab->freelist,
+				c->freelist, tid,
+				object, next_tid(tid)))) {
+
+			note_cmpxchg_failure("slab_free", s, tid);
+			goto redo;
+		}
 		stat(s, FREE_FASTPATH);
 	} else
 		__slab_free(s, page, x, addr);
-
-	local_irq_restore(flags);
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
@@ -2102,12 +2213,24 @@ init_kmem_cache_node(struct kmem_cache_n
 
 static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
 {
+	int cpu;
+
 	BUILD_BUG_ON(PERCPU_DYNAMIC_EARLY_SIZE <
 			SLUB_PAGE_SHIFT * sizeof(struct kmem_cache_cpu));
 
-	s->cpu_slab = alloc_percpu(struct kmem_cache_cpu);
+	/*
+	 * Must align to double word boundary for the long cmpxchg instructions
+	 * to work.
+	 */
+	s->cpu_slab = __alloc_percpu(sizeof(struct kmem_cache_cpu), 2 * sizeof(void *));
 
-	return s->cpu_slab != NULL;
+	if (!s->cpu_slab)
+		return 0;
+
+	for_each_possible_cpu(cpu)
+		per_cpu_ptr(s->cpu_slab, cpu)->tid = init_tid(cpu);
+
+	return 1;
 }
 
 static struct kmem_cache *kmem_cache_node;

