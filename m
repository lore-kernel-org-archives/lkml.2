Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab2HaQBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:01:39 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38708 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754203Ab2HaQBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:01:38 -0400
Message-ID: <1346428895.3512.23.camel@dabdike>
Subject: [GIT PULL] parisc fixes for 3.6-rc3
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 31 Aug 2012 09:01:35 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a set of two bug fixes.  One is the ATOMIC problem which is now
causing a compile failure in certain situations.  The other is
mishandling of PER_LINUX32 which may also cause user visible effects.

The patches are here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/parisc-2.6.git parisc-fixes

The short changelog is:

Jiri Kosina (1):
      fix personality flag check in copy_thread()

Mel Gorman (1):
      Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts

And the diffstat:

 arch/parisc/include/asm/atomic.h | 4 ++--
 arch/parisc/kernel/process.c     | 2 +-
 arch/parisc/kernel/sys_parisc.c  | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

Full diff below.

James

---

diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/atomic.h
index 6c6defc..af9cf30 100644
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -141,7 +141,7 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 
 #define atomic_sub_and_test(i,v)	(atomic_sub_return((i),(v)) == 0)
 
-#define ATOMIC_INIT(i)	((atomic_t) { (i) })
+#define ATOMIC_INIT(i)	{ (i) }
 
 #define smp_mb__before_atomic_dec()	smp_mb()
 #define smp_mb__after_atomic_dec()	smp_mb()
@@ -150,7 +150,7 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 
 #ifdef CONFIG_64BIT
 
-#define ATOMIC64_INIT(i) ((atomic64_t) { (i) })
+#define ATOMIC64_INIT(i) { (i) }
 
 static __inline__ s64
 __atomic64_add_return(s64 i, atomic64_t *v)
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index d4b94b3..2c05a92 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -309,7 +309,7 @@ copy_thread(unsigned long clone_flags, unsigned long usp,
 		cregs->ksp = (unsigned long)stack
 			+ (pregs->gr[21] & (THREAD_SIZE - 1));
 		cregs->gr[30] = usp;
-		if (p->personality == PER_HPUX) {
+		if (personality(p->personality) == PER_HPUX) {
 #ifdef CONFIG_HPUX
 			cregs->kpc = (unsigned long) &hpux_child_return;
 #else
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index c9b9322..7426e40 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -225,12 +225,12 @@ long parisc_personality(unsigned long personality)
 	long err;
 
 	if (personality(current->personality) == PER_LINUX32
-	    && personality == PER_LINUX)
-		personality = PER_LINUX32;
+	    && personality(personality) == PER_LINUX)
+		personality = (personality & ~PER_MASK) | PER_LINUX32;
 
 	err = sys_personality(personality);
-	if (err == PER_LINUX32)
-		err = PER_LINUX;
+	if (personality(err) == PER_LINUX32)
+		err = (err & ~PER_MASK) | PER_LINUX;
 
 	return err;
 }


