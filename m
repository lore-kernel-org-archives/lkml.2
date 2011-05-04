Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab1EDOgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:36:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44637 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab1EDOge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:36:34 -0400
Date: Wed, 4 May 2011 16:36:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH] slub: Fix the lockless code on 32-bit platforms with no
 64-bit cmpxchg
Message-ID: <20110504143616.GA19986@elte.hu>
References: <20110504083559.GB25724@elte.hu>
 <alpine.LFD.2.02.1105041124080.3005@ionos>
 <20110504101932.GA3392@elte.hu>
 <alpine.LFD.2.02.1105041233280.3005@ionos>
 <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
 <20110504112746.GE8007@htj.dyndns.org>
 <alpine.LFD.2.02.1105041417330.3005@ionos>
 <20110504132022.GA17294@htj.dyndns.org>
 <alpine.LFD.2.02.1105041539050.3005@ionos>
 <20110504141413.GA14127@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504141413.GA14127@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Patch below. Ingo, can you test that please ?
> 
> Sure - test underway.

Ok, the patch below is looking really good - the test would have crashed on the 
bad kernel. I think we can consider the regression fixed:

  Acked-and-tested-by: Ingo Molnar <mingo@elte.hu>

I'll keep it running some more to make really sure it's fixed, plus it would be 
nice if Walter tested your fix as well.

Thanks,

	Ingo

----------------->
>From c22bd309573330e33a77c329405d9473fc14f1cb Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 4 May 2011 15:38:19 +0200
Subject: [PATCH] slub: Fix the lockless code on 32-bit platforms with no 64-bit cmpxchg

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: werner <w.landgraf@ru.ru>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1105041539050.3005@ionos
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/percpu.h |    2 +-
 mm/slub.c              |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 3a5c444..8b97308 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -948,7 +948,7 @@ do {									\
 	irqsafe_generic_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
 # endif
 # define irqsafe_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__pcpu_double_call_return_int(irqsafe_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+	__pcpu_double_call_return_bool(irqsafe_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
 #endif
 
 #endif /* __LINUX_PERCPU_H */
diff --git a/mm/slub.c b/mm/slub.c
index 94d2a33..9d2e5e4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1940,7 +1940,7 @@ redo:
 		 * Since this is without lock semantics the protection is only against
 		 * code executing on this cpu *not* from access by other cpus.
 		 */
-		if (unlikely(!this_cpu_cmpxchg_double(
+		if (unlikely(!irqsafe_cpu_cmpxchg_double(
 				s->cpu_slab->freelist, s->cpu_slab->tid,
 				object, tid,
 				get_freepointer(s, object), next_tid(tid)))) {
@@ -2145,7 +2145,7 @@ redo:
 		set_freepointer(s, object, c->freelist);
 
 #ifdef CONFIG_CMPXCHG_LOCAL
-		if (unlikely(!this_cpu_cmpxchg_double(
+		if (unlikely(!irqsafe_cpu_cmpxchg_double(
 				s->cpu_slab->freelist, s->cpu_slab->tid,
 				c->freelist, tid,
 				object, next_tid(tid)))) {
