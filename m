Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab1GNR00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 13:26:26 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:42871 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932139Ab1GNR0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 13:26:25 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: qy3POxoVM1mDHgCTZ6D_7rdmFvVFGRq94GWtVAqt7s0M9JF
 Y6ALVR9E4GRGaiWKK5IbNREZH4jbCQQzM23W42HJcAz3zoBeJVKANJ7xKdqh
 Xrj95ucGxkrxFhu.YBDoA7zcr3oZHdRBbseXBfDUFDbkOI5a5I6Z4CXFiBo0
 bBLG0rpVCM_kPZwzWczt4Ad_3IdWXUzUuizhB8AjPvVmV9MZIg0PD.7HLJt2
 ie9gZZ.pr.FAuZmhY.r_yQmmLXuuhNY0KpdHkHy2w1ugHL_6KD.8wrmAOnM_
 tbwrBAQaEh1Qe86EMvy_iUotJyif15iob8DVnc6c.wqO.UOQEzQ--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 14 Jul 2011 12:26:21 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Hugh Dickins <hughd@google.com>
cc: Pekka Enberg <penberg@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next/mmotm] slub: partly fix freeze in __slab_free
In-Reply-To: <alpine.LSU.2.00.1107140905030.4077@sister.anvils>
Message-ID: <alpine.DEB.2.00.1107141141090.30512@router.home>
References: <alpine.LSU.2.00.1107111156310.13035@sister.anvils> <1310413167.2860.3.camel@edumazet-laptop> <4E1BE5F9.10401@kernel.org> <alpine.DEB.2.00.1107121010060.1672@router.home> <alpine.DEB.2.00.1107121046000.2530@router.home>
 <alpine.LSU.2.00.1107130357560.4184@sister.anvils> <alpine.DEB.2.00.1107131041170.29034@router.home> <alpine.DEB.2.00.1107131054270.29034@router.home> <alpine.LSU.2.00.1107140905030.4077@sister.anvils>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011, Hugh Dickins wrote:

> Success, thank you: I ran my load for 22 hours on the ppc64,
> no problem this time, where before it froze in 2.5 hours.
>
> I was running rc6-mm1 plus this patch, plus (my transcription of) your
> mm_types.h struct page patch, plus Fengguang's redirty_tail patch;
> leaving out my "*new = page" patch which kicked this thread off.
>
> Feel free to add
> Tested-by: Hugh Dickins <hughd@google.com>

Ok now we know the cause. The cure needs to be a bit different I think
since this is performance critical code and the interrupt operations are
high latency.

Subject: slub: disable interrupts in cmpxchg_double_slab when falling back to pagelock (V2)

Split cmpxchg_double_slab into two functions. One for the case where we know that
interrupts are disabled (and therefore the fallback does not need to disable
interrupts) and one for the other cases where fallback will also disable interrupts.

This fixes the issue that __slab_free called cmpxchg_double_slab in some scenarios
without disabling interrupts.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   49 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 4 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-07-14 12:23:01.617611569 -0500
+++ linux-2.6/mm/slub.c	2011-07-14 12:23:04.117611553 -0500
@@ -354,6 +354,42 @@ static __always_inline void slab_unlock(
 	__bit_spin_unlock(PG_locked, &page->flags);
 }

+/* Interrupts must be disabled (for the fallback code to work right) */
+static inline bool __cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
+		void *freelist_old, unsigned long counters_old,
+		void *freelist_new, unsigned long counters_new,
+		const char *n)
+{
+	VM_BUG_ON(!irqs_disabled());
+#ifdef CONFIG_CMPXCHG_DOUBLE
+	if (s->flags & __CMPXCHG_DOUBLE) {
+		if (cmpxchg_double(&page->freelist,
+			freelist_old, counters_old,
+			freelist_new, counters_new))
+		return 1;
+	} else
+#endif
+	{
+		slab_lock(page);
+		if (page->freelist == freelist_old && page->counters == counters_old) {
+			page->freelist = freelist_new;
+			page->counters = counters_new;
+			slab_unlock(page);
+			return 1;
+		}
+		slab_unlock(page);
+	}
+
+	cpu_relax();
+	stat(s, CMPXCHG_DOUBLE_FAIL);
+
+#ifdef SLUB_DEBUG_CMPXCHG
+	printk(KERN_INFO "%s %s: cmpxchg double redo ", n, s->name);
+#endif
+
+	return 0;
+}
+
 static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
 		void *freelist_old, unsigned long counters_old,
 		void *freelist_new, unsigned long counters_new,
@@ -368,14 +404,19 @@ static inline bool cmpxchg_double_slab(s
 	} else
 #endif
 	{
+		unsigned long flags;
+
+		local_irq_save(flags);
 		slab_lock(page);
 		if (page->freelist == freelist_old && page->counters == counters_old) {
 			page->freelist = freelist_new;
 			page->counters = counters_new;
 			slab_unlock(page);
+			local_irq_restore(flags);
 			return 1;
 		}
 		slab_unlock(page);
+		local_irq_restore(flags);
 	}

 	cpu_relax();
@@ -1471,7 +1512,7 @@ static inline int acquire_slab(struct km
 		VM_BUG_ON(new.frozen);
 		new.frozen = 1;

-	} while (!cmpxchg_double_slab(s, page,
+	} while (!__cmpxchg_double_slab(s, page,
 			freelist, counters,
 			NULL, new.counters,
 			"lock and freeze"));
@@ -1709,7 +1750,7 @@ static void deactivate_slab(struct kmem_
 			new.inuse--;
 			VM_BUG_ON(!new.frozen);

-		} while (!cmpxchg_double_slab(s, page,
+		} while (!__cmpxchg_double_slab(s, page,
 			prior, counters,
 			freelist, new.counters,
 			"drain percpu freelist"));
@@ -1798,7 +1839,7 @@ redo:
 	}

 	l = m;
-	if (!cmpxchg_double_slab(s, page,
+	if (!__cmpxchg_double_slab(s, page,
 				old.freelist, old.counters,
 				new.freelist, new.counters,
 				"unfreezing slab"))
@@ -1992,7 +2033,7 @@ static void *__slab_alloc(struct kmem_ca
 		new.inuse = page->objects;
 		new.frozen = object != NULL;

-	} while (!cmpxchg_double_slab(s, page,
+	} while (!__cmpxchg_double_slab(s, page,
 			object, counters,
 			NULL, new.counters,
 			"__slab_alloc"));
