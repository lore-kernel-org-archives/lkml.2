Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886Ab3AIUkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:40:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:43382 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933806Ab3AIUk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tony Lindgren <tony@atomide.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [ 74/80] lib: atomic64: Initialize locks statically to fix early users
Date: Wed,  9 Jan 2013 12:36:06 -0800
Message-Id: <20130109201509.894193738@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit fcc16882ac4532aaa644bff444f0c5d6228ba71e upstream.

The atomic64 library uses a handful of static spin locks to implement
atomic 64-bit operations on architectures without support for atomic
64-bit instructions.

Unfortunately, the spinlocks are initialized in a pure initcall and that
is too late for the vfs namespace code which wants to use atomic64
operations before the initcall is run.

This became a problem as of commit 8823c079ba71: "vfs: Add setns support
for the mount namespace".

This leads to BUG messages such as:

  BUG: spinlock bad magic on CPU#0, swapper/0/0
   lock: atomic64_lock+0x240/0x400, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    do_raw_spin_lock+0x158/0x198
    _raw_spin_lock_irqsave+0x4c/0x58
    atomic64_add_return+0x30/0x5c
    alloc_mnt_ns.clone.14+0x44/0xac
    create_mnt_ns+0xc/0x54
    mnt_init+0x120/0x1d4
    vfs_caches_init+0xe0/0x10c
    start_kernel+0x29c/0x300

coming out early on during boot when spinlock debugging is enabled.

Fix this by initializing the spinlocks statically at compile time.

Reported-and-tested-by: Vaibhav Bedia <vaibhav.bedia@ti.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/atomic64.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

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
@@ -173,14 +177,3 @@ int atomic64_add_unless(atomic64_t *v, l
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


