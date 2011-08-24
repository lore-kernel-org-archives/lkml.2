Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab1HXViR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:38:17 -0400
Received: from claw.goop.org ([74.207.240.146]:53499 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab1HXVhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:37:24 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 07/12] x86: use cmpxchg_flag() where applicable
Date: Wed, 24 Aug 2011 14:37:04 -0700
Message-Id: <3d7aea62fac48dd6e2da236d86234113fcd78178.1314221624.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <e1c8d3bcee83cc5ad00bdf8900a99add7abb1cb9.1314221624.git.jeremy.fitzhardinge@citrix.com>
References: <e1c8d3bcee83cc5ad00bdf8900a99add7abb1cb9.1314221624.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/cacheflush.h |    2 +-
 arch/x86/include/asm/rwsem.h      |    7 ++-----
 arch/x86/kernel/acpi/boot.c       |   10 ++++------
 arch/x86/kernel/cpu/mcheck/mce.c  |    2 +-
 arch/x86/xen/p2m.c                |   10 +++++-----
 5 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 4e12668..6ceae20 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -56,7 +56,7 @@ static inline void set_page_memtype(struct page *pg, unsigned long memtype)
 	do {
 		old_flags = pg->flags;
 		new_flags = (old_flags & _PGMT_CLEAR_MASK) | memtype_flags;
-	} while (cmpxchg(&pg->flags, old_flags, new_flags) != old_flags);
+	} while (!cmpxchg_flag(&pg->flags, old_flags, new_flags));
 }
 #else
 static inline unsigned long get_page_memtype(struct page *pg) { return -1; }
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index df4cd32..5a35263 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -126,11 +126,8 @@ static inline void __down_write(struct rw_semaphore *sem)
  */
 static inline int __down_write_trylock(struct rw_semaphore *sem)
 {
-	long ret = cmpxchg(&sem->count, RWSEM_UNLOCKED_VALUE,
-			   RWSEM_ACTIVE_WRITE_BIAS);
-	if (ret == RWSEM_UNLOCKED_VALUE)
-		return 1;
-	return 0;
+	return cmpxchg_flag(&sem->count, RWSEM_UNLOCKED_VALUE,
+			    RWSEM_ACTIVE_WRITE_BIAS);
 }
 
 /*
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 9a966c5..6bf0bf8 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1669,22 +1669,20 @@ early_param("acpi_sci", setup_acpi_sci);
 
 int __acpi_acquire_global_lock(unsigned int *lock)
 {
-	unsigned int old, new, val;
+	unsigned int old, new;
 	do {
 		old = *lock;
 		new = (((old & ~0x3) + 2) + ((old >> 1) & 0x1));
-		val = cmpxchg(lock, old, new);
-	} while (unlikely (val != old));
+	} while (unlikely (!cmpxchg_flag(lock, old, new)));
 	return (new < 3) ? -1 : 0;
 }
 
 int __acpi_release_global_lock(unsigned int *lock)
 {
-	unsigned int old, new, val;
+	unsigned int old, new;
 	do {
 		old = *lock;
 		new = old & ~0x3;
-		val = cmpxchg(lock, old, new);
-	} while (unlikely (val != old));
+	} while (unlikely (!cmpxchg_flag(lock, old, new)));
 	return old & 0x1;
 }
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 3385ea2..99ae2d1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -198,7 +198,7 @@ void mce_log(struct mce *mce)
 		}
 		smp_rmb();
 		next = entry + 1;
-		if (cmpxchg(&mcelog.next, entry, next) == entry)
+		if (cmpxchg_flag(&mcelog.next, entry, next))
 			break;
 	}
 	memcpy(mcelog.entry + entry, mce, sizeof(struct mce));
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 141eb0d..5510082 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -448,7 +448,7 @@ static bool alloc_p2m(unsigned long pfn)
 
 		p2m_mid_init(mid);
 
-		if (cmpxchg(top_p, p2m_mid_missing, mid) != p2m_mid_missing)
+		if (!cmpxchg_flag(top_p, p2m_mid_missing, mid))
 			free_p2m_page(mid);
 	}
 
@@ -470,7 +470,7 @@ static bool alloc_p2m(unsigned long pfn)
 
 		missing_mfn = virt_to_mfn(p2m_mid_missing_mfn);
 		mid_mfn_mfn = virt_to_mfn(mid_mfn);
-		if (cmpxchg(top_mfn_p, missing_mfn, mid_mfn_mfn) != missing_mfn)
+		if (!cmpxchg_flag(top_mfn_p, missing_mfn, mid_mfn_mfn))
 			free_p2m_page(mid_mfn);
 		else
 			p2m_top_mfn_p[topidx] = mid_mfn;
@@ -488,7 +488,7 @@ static bool alloc_p2m(unsigned long pfn)
 
 		p2m_init(p2m);
 
-		if (cmpxchg(&mid[mididx], p2m_orig, p2m) != p2m_orig)
+		if (!cmpxchg_flag(&mid[mididx], p2m_orig, p2m))
 			free_p2m_page(p2m);
 		else
 			mid_mfn[mididx] = virt_to_mfn(p2m);
@@ -600,8 +600,8 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 
 		/* Swap over from MISSING to IDENTITY if needed. */
 		if (p2m_top[topidx][mididx] == p2m_missing) {
-			WARN_ON(cmpxchg(&p2m_top[topidx][mididx], p2m_missing,
-				p2m_identity) != p2m_missing);
+			WARN_ON(!cmpxchg_flag(&p2m_top[topidx][mididx], p2m_missing,
+					      p2m_identity));
 			return true;
 		}
 	}
-- 
1.7.6

