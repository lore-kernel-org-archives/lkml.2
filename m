Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab1INHth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 03:49:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55966 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1INHtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 03:49:35 -0400
Date: Wed, 14 Sep 2011 15:49:24 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shan Hai <haishan.bai@gmail.com>
Subject: Re: linux-next: build warning after merge of the tip tree
Message-ID: <20110914074924.GA16096@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110914163455.fcc47a7aba8604c690988473@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110914163455.fcc47a7aba8604c690988473@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 04:34:55PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the tip tree, today's linux-next build (powerpc allnoconfig)
> produced this warning:
> 
> lib/atomic64.c: In function 'lock_addr':
> lib/atomic64.c:42:2: warning: return from incompatible pointer type
> 
> Introduced by commit f59ca05871a0 ("locking, lib/atomic64: Annotate
> atomic64_lock::lock as raw").  This function (which is declared to return
> "spinlock_t *") is now returning "raw_spinlock_t *".

Oh, we still have something left to clean.

Does below patch help?

---
From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH] lib: atomic64: change the type of local lock to raw_spinlock_t

There are still some leftovers of commit f59ca058
[locking, lib/atomic64: Annotate atomic64_lock::lock as raw]

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Shan Hai <haishan.bai@gmail.com>
---
 lib/atomic64.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/lib/atomic64.c b/lib/atomic64.c
index 9db8dea..f9c5b29 100644
--- a/lib/atomic64.c
+++ b/lib/atomic64.c
@@ -33,7 +33,7 @@ static union {
 	char pad[L1_CACHE_BYTES];
 } atomic64_lock[NR_LOCKS] __cacheline_aligned_in_smp;
 
-static inline spinlock_t *lock_addr(const atomic64_t *v)
+static inline raw_spinlock_t *lock_addr(const atomic64_t *v)
 {
 	unsigned long addr = (unsigned long) v;
 
@@ -45,7 +45,7 @@ static inline spinlock_t *lock_addr(const atomic64_t *v)
 long long atomic64_read(const atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
 	raw_spin_lock_irqsave(lock, flags);
@@ -58,7 +58,7 @@ EXPORT_SYMBOL(atomic64_read);
 void atomic64_set(atomic64_t *v, long long i)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 
 	raw_spin_lock_irqsave(lock, flags);
 	v->counter = i;
@@ -69,7 +69,7 @@ EXPORT_SYMBOL(atomic64_set);
 void atomic64_add(long long a, atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 
 	raw_spin_lock_irqsave(lock, flags);
 	v->counter += a;
@@ -80,7 +80,7 @@ EXPORT_SYMBOL(atomic64_add);
 long long atomic64_add_return(long long a, atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
 	raw_spin_lock_irqsave(lock, flags);
@@ -93,7 +93,7 @@ EXPORT_SYMBOL(atomic64_add_return);
 void atomic64_sub(long long a, atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 
 	raw_spin_lock_irqsave(lock, flags);
 	v->counter -= a;
@@ -104,7 +104,7 @@ EXPORT_SYMBOL(atomic64_sub);
 long long atomic64_sub_return(long long a, atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
 	raw_spin_lock_irqsave(lock, flags);
@@ -117,7 +117,7 @@ EXPORT_SYMBOL(atomic64_sub_return);
 long long atomic64_dec_if_positive(atomic64_t *v)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
 	raw_spin_lock_irqsave(lock, flags);
@@ -132,7 +132,7 @@ EXPORT_SYMBOL(atomic64_dec_if_positive);
 long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
 	raw_spin_lock_irqsave(lock, flags);
@@ -147,7 +147,7 @@ EXPORT_SYMBOL(atomic64_cmpxchg);
 long long atomic64_xchg(atomic64_t *v, long long new)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	long long val;
 
 	raw_spin_lock_irqsave(lock, flags);
@@ -161,7 +161,7 @@ EXPORT_SYMBOL(atomic64_xchg);
 int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 {
 	unsigned long flags;
-	spinlock_t *lock = lock_addr(v);
+	raw_spinlock_t *lock = lock_addr(v);
 	int ret = 0;
 
 	raw_spin_lock_irqsave(lock, flags);
-- 
1.7.4.1

