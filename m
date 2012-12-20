Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab2LTHkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 02:40:00 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56970 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2LTHjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 02:39:52 -0500
X-IronPort-AV: E=Sophos;i="4.84,322,1355126400"; 
   d="scan'208";a="15495799"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        paul@pwsan.com, vaibhav.bedia@ti.com,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] lib: atomic64: Initialize locks statically to fix early users
Date: Wed, 19 Dec 2012 23:39:48 -0800
Message-Id: <1355989188-17665-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.1.rc2
In-Reply-To: <50D2B94D.10309@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atomic64 library uses a handful of static spin locks to
implement atomic 64-bit operations on architectures without
support for atomic 64-bit instructions. Unfortunately, the
spinlocks are initialized in a pure initcall and that is too late
for the vfs namespace code which wants to use atomic64 operations
before the initcall is run (introduced by 8823c07 "vfs: Add setns
support for the mount namespace").

This leads to BUG messages such as:

BUG: spinlock bad magic on CPU#0, swapper/0/0
 lock: atomic64_lock+0x240/0x400, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
[<c001af64>] (unwind_backtrace+0x0/0xf0) from [<c02c2010>] (do_raw_spin_lock+0x158/0x198)
[<c02c2010>] (do_raw_spin_lock+0x158/0x198) from [<c04d89ec>] (_raw_spin_lock_irqsave+0x4c/0x58)
[<c04d89ec>] (_raw_spin_lock_irqsave+0x4c/0x58) from [<c02cabf0>] (atomic64_add_return+0x30/0x5c)
[<c02cabf0>] (atomic64_add_return+0x30/0x5c) from [<c0124564>] (alloc_mnt_ns.clone.14+0x44/0xac)
[<c0124564>] (alloc_mnt_ns.clone.14+0x44/0xac) from [<c0124f4c>] (create_mnt_ns+0xc/0x54)
[<c0124f4c>] (create_mnt_ns+0xc/0x54) from [<c06f31a4>] (mnt_init+0x120/0x1d4)
[<c06f31a4>] (mnt_init+0x120/0x1d4) from [<c06f2d50>] (vfs_caches_init+0xe0/0x10c)
[<c06f2d50>] (vfs_caches_init+0xe0/0x10c) from [<c06d4798>] (start_kernel+0x29c/0x300)
[<c06d4798>] (start_kernel+0x29c/0x300) from [<80008078>] (0x80008078)

coming out early on during boot when spinlock debugging is enabled.

Fix this problem by initializing the spinlocks statically at
compile time.

Reported-by: Vaibhav Bedia <vaibhav.bedia@ti.com>
Tested-by: Vaibhav Bedia <vaibhav.bedia@ti.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Sorry Andrew, I couldn't find a maintainer of this file so I
am picking on you.

 lib/atomic64.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

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
+	[0 ... (NR_LOCKS - 1)] = {
+		.lock =  __RAW_SPIN_LOCK_UNLOCKED(atomic64_lock.lock),
+	},
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
-	int i;
-
-	for (i = 0; i < NR_LOCKS; ++i)
-		raw_spin_lock_init(&atomic64_lock[i].lock);
-	return 0;
-}
-
-pure_initcall(init_atomic64_lock);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

