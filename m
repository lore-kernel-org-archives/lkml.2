Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab2LSUX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:23:57 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3349 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2LSUXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:23:43 -0500
X-IronPort-AV: E=Sophos;i="4.84,318,1355126400"; 
   d="scan'208";a="15251370"
Message-ID: <50D2224E.4060300@codeaurora.org>
Date: Wed, 19 Dec 2012 12:23:42 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG: spinlock bad magic on CPU#0 on BeagleBone
References: <B5906170F1614E41A8A28DE3B8D121433EC9A69C@DBDE01.ent.ti.com> <alpine.DEB.2.00.1212191650430.16873@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1212191650430.16873@utopia.booyaka.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/12 08:53, Paul Walmsley wrote:
> On Wed, 19 Dec 2012, Bedia, Vaibhav wrote:
>
>> Current mainline on Beaglebone using the omap2plus_defconfig + 3 build fixes
>> is triggering a BUG()
> ...
>
>> [    0.109688] Security Framework initialized
>> [    0.109889] Mount-cache hash table entries: 512
>> [    0.112674] BUG: spinlock bad magic on CPU#0, swapper/0/0
>> [    0.112724]  lock: atomic64_lock+0x240/0x400, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
>> [    0.112782] [<c001af64>] (unwind_backtrace+0x0/0xf0) from [<c02c2010>] (do_raw_spin_lock+0x158/0x198)
>> [    0.112813] [<c02c2010>] (do_raw_spin_lock+0x158/0x198) from [<c04d89ec>] (_raw_spin_lock_irqsave+0x4c/0x58)
>> [    0.112844] [<c04d89ec>] (_raw_spin_lock_irqsave+0x4c/0x58) from [<c02cabf0>] (atomic64_add_return+0x30/0x5c)
>> [    0.112886] [<c02cabf0>] (atomic64_add_return+0x30/0x5c) from [<c0124564>] (alloc_mnt_ns.clone.14+0x44/0xac)
>> [    0.112914] [<c0124564>] (alloc_mnt_ns.clone.14+0x44/0xac) from [<c0124f4c>] (create_mnt_ns+0xc/0x54)
>> [    0.112951] [<c0124f4c>] (create_mnt_ns+0xc/0x54) from [<c06f31a4>] (mnt_init+0x120/0x1d4)
>> [    0.112978] [<c06f31a4>] (mnt_init+0x120/0x1d4) from [<c06f2d50>] (vfs_caches_init+0xe0/0x10c)
>> [    0.113005] [<c06f2d50>] (vfs_caches_init+0xe0/0x10c) from [<c06d4798>] (start_kernel+0x29c/0x300)
>> [    0.113029] [<c06d4798>] (start_kernel+0x29c/0x300) from [<80008078>] (0x80008078)
>> [    0.118290] CPU: Testing write buffer coherency: ok
>> [    0.118968] CPU0: thread -1, cpu 0, socket -1, mpidr 0
>> [    0.119053] Setting up static identity map for 0x804de2c8 - 0x804de338
>> [    0.120698] Brought up 1 CPUs
> This is probably a memory corruption bug, there's probably some code 
> executing early that's writing outside its own data and trashing some 
> previously-allocated memory.

I'm not so sure. It looks like atomic64s use spinlocks on processors
that don't have 64-bit atomic instructions (see lib/atomic64.c). And
those spinlocks are not initialized until a pure initcall runs,
init_atomic64_lock(). Pure initcalls don't run until after
vfs_caches_init() and so you get this BUG() warning that the spinlock is
not initialized.

How about we initialize the locks statically? Does that fix your problem?

---->8-----

diff --git a/lib/atomic64.c b/lib/atomic64.c
index 9785378..08a4f06 100644
--- a/lib/atomic64.c
+++ b/lib/atomic64.c
@@ -31,7 +31,11 @@
 static union {
        raw_spinlock_t lock;
        char pad[L1_CACHE_BYTES];
-} atomic64_lock[NR_LOCKS] __cacheline_aligned_in_smp;
+} atomic64_lock[NR_LOCKS] __cacheline_aligned_in_smp = {
+       [0 ... (NR_LOCKS - 1)] = {
+               .lock =  __RAW_SPIN_LOCK_UNLOCKED(atomic64_lock.lock),
+       },
+};
 
 static inline raw_spinlock_t *lock_addr(const atomic64_t *v)
 {
@@ -173,14 +177,3 @@ int atomic64_add_unless(atomic64_t *v, long long a, long long u)
        return ret;
 }
 EXPORT_SYMBOL(atomic64_add_unless);
-
-static int init_atomic64_lock(void)
-{
-       int i;
-
-       for (i = 0; i < NR_LOCKS; ++i)
-               raw_spin_lock_init(&atomic64_lock[i].lock);
-       return 0;
-}
-
-pure_initcall(init_atomic64_lock);

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

