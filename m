Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab1H3FZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 01:25:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:48918 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab1H3FZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 01:25:23 -0400
Date: Tue, 30 Aug 2011 05:24:54 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Message-ID: <tip-8b8bc2f7311c3223213dbe346d9cc2e299fdb5eb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <4E5BCC40.3030501@goop.org>
References: <4E5BCC40.3030501@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86: Use xadd helper more widely
Git-Commit-ID: 8b8bc2f7311c3223213dbe346d9cc2e299fdb5eb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Tue, 30 Aug 2011 05:25:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b8bc2f7311c3223213dbe346d9cc2e299fdb5eb
Gitweb:     http://git.kernel.org/tip/8b8bc2f7311c3223213dbe346d9cc2e299fdb5eb
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Tue, 23 Aug 2011 16:59:58 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 29 Aug 2011 13:44:12 -0700

x86: Use xadd helper more widely

This covers the trivial cases from open-coded xadd to the xadd macros.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Link: http://lkml.kernel.org/r/4E5BCC40.3030501@goop.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/atomic.h      |    8 ++------
 arch/x86/include/asm/atomic64_64.h |    6 +-----
 arch/x86/include/asm/rwsem.h       |    8 +-------
 arch/x86/include/asm/uv/uv_bau.h   |    6 +-----
 4 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 10572e3..58cb6d4 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -172,18 +172,14 @@ static inline int atomic_add_negative(int i, atomic_t *v)
  */
 static inline int atomic_add_return(int i, atomic_t *v)
 {
-	int __i;
 #ifdef CONFIG_M386
+	int __i;
 	unsigned long flags;
 	if (unlikely(boot_cpu_data.x86 <= 3))
 		goto no_xadd;
 #endif
 	/* Modern 486+ processor */
-	__i = i;
-	asm volatile(LOCK_PREFIX "xaddl %0, %1"
-		     : "+r" (i), "+m" (v->counter)
-		     : : "memory");
-	return i + __i;
+	return i + xadd(&v->counter, i);
 
 #ifdef CONFIG_M386
 no_xadd: /* Legacy 386 processor */
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index 017594d..0e1cbfc 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -170,11 +170,7 @@ static inline int atomic64_add_negative(long i, atomic64_t *v)
  */
 static inline long atomic64_add_return(long i, atomic64_t *v)
 {
-	long __i = i;
-	asm volatile(LOCK_PREFIX "xaddq %0, %1;"
-		     : "+r" (i), "+m" (v->counter)
-		     : : "memory");
-	return i + __i;
+	return i + xadd(&v->counter, i);
 }
 
 static inline long atomic64_sub_return(long i, atomic64_t *v)
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index df4cd32..2dbe4a7 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -204,13 +204,7 @@ static inline void rwsem_atomic_add(long delta, struct rw_semaphore *sem)
  */
 static inline long rwsem_atomic_update(long delta, struct rw_semaphore *sem)
 {
-	long tmp = delta;
-
-	asm volatile(LOCK_PREFIX "xadd %0,%1"
-		     : "+r" (tmp), "+m" (sem->count)
-		     : : "memory");
-
-	return tmp + delta;
+	return delta + xadd(&sem->count, delta);
 }
 
 #endif /* __KERNEL__ */
diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 37d3698..c568ccc 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -656,11 +656,7 @@ static inline int atomic_read_short(const struct atomic_short *v)
  */
 static inline int atom_asr(short i, struct atomic_short *v)
 {
-	short __i = i;
-	asm volatile(LOCK_PREFIX "xaddw %0, %1"
-			: "+r" (i), "+m" (v->counter)
-			: : "memory");
-	return i + __i;
+	return i + xadd(&v->counter, i);
 }
 
 /*
