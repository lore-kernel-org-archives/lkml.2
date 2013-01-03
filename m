Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab3ACVrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 16:47:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab3ACVru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 16:47:50 -0500
Date: Thu, 3 Jan 2013 13:47:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Decotigny <decot@googlers.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH v4] lib: cpu_rmap: avoid flushing all workqueues
Message-Id: <20130103134749.1d01bc2e.akpm@linux-foundation.org>
In-Reply-To: <CAG88wWYuxY7Gi6tuBsv_tY2QqGmQgB-zER9pzpZga7uV21HorA@mail.gmail.com>
References: <cover.1357163124.git.decot@googlers.com>
	<bb2493cb7d0b36f35282d77c1f07727601f9c751.1357163124.git.decot@googlers.com>
	<20130102151242.fc6f1bee.akpm@linux-foundation.org>
	<CAG88wWYuxY7Gi6tuBsv_tY2QqGmQgB-zER9pzpZga7uV21HorA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2013 18:35:00 -0800
David Decotigny <decot@googlers.com> wrote:
>

(please don't top-post)

> Thanks. It is not too late to review this code. But I'd prefer not to
> address refactoring issues with this patch, which is supposed to fix a
> deadlock with some drivers. So I'd rather not to add function
> renaming, suppressions, etc. that have an effect outside cpu_rmap's
> code. Instead, I'd like to propose another patch later, which will be
> a little more intrusive in that respect, if that's ok with you.
> 
> I believe Ben answered your other concerns, I consider him as the
> expert as to whether there should be finer-grained locking implemented
> in this subsystem. Let me just add that I second him in saying that
> the deadlock risk was clearly identified and mentioned in the doc.
> Unfortunately, initial implementation makes this risk hard to
> work-around for some drivers, which is what this patch proposes to
> address.

^^ all this pertains to the existing code.

> So, for now, I'd like to keep v4 as the current version. And some
> refactoring will be done in a later patch.

^^ this pertains to the current patch.  And no reason for ignoring my
review comments was provided.

So I did it myself.  It's very simple, as free_cpu_rmap() has no callers.

Also, free_irq_cpu_rmap() is now distinctly fishy - it runs all the
notifiers every time it is called.  Surely it should only do that when
the refcount falls to zero?



From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-cpu_rmap-avoid-flushing-all-workqueues-fix

eliminate free_cpu_rmap, rename cpu_rmap_reclaim() to cpu_rmap_release(),
propagate kref_put() retval from cpu_rmap_put()

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Amir Vadai <amirv@mellanox.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: David Decotigny <decot@googlers.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu_rmap.h |    2 +-
 lib/cpu_rmap.c           |   21 ++++++---------------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff -puN include/linux/cpu_rmap.h~lib-cpu_rmap-avoid-flushing-all-workqueues-fix include/linux/cpu_rmap.h
--- a/include/linux/cpu_rmap.h~lib-cpu_rmap-avoid-flushing-all-workqueues-fix
+++ a/include/linux/cpu_rmap.h
@@ -36,7 +36,7 @@ struct cpu_rmap {
 #define CPU_RMAP_DIST_INF 0xffff
 
 extern struct cpu_rmap *alloc_cpu_rmap(unsigned int size, gfp_t flags);
-extern void free_cpu_rmap(struct cpu_rmap *rmap);
+extern int cpu_rmap_put(struct cpu_rmap *rmap);
 
 extern int cpu_rmap_add(struct cpu_rmap *rmap, void *obj);
 extern int cpu_rmap_update(struct cpu_rmap *rmap, u16 index,
diff -puN include/linux/interrupt.h~lib-cpu_rmap-avoid-flushing-all-workqueues-fix include/linux/interrupt.h
diff -puN lib/cpu_rmap.c~lib-cpu_rmap-avoid-flushing-all-workqueues-fix lib/cpu_rmap.c
--- a/lib/cpu_rmap.c~lib-cpu_rmap-avoid-flushing-all-workqueues-fix
+++ a/lib/cpu_rmap.c
@@ -65,10 +65,10 @@ struct cpu_rmap *alloc_cpu_rmap(unsigned
 EXPORT_SYMBOL(alloc_cpu_rmap);
 
 /**
- * cpu_rmap_reclaim - internal reclaiming helper called from kref_put
+ * cpu_rmap_release - internal reclaiming helper called from kref_put
  * @ref: kref to struct cpu_rmap
  */
-static void cpu_rmap_reclaim(struct kref *ref)
+static void cpu_rmap_release(struct kref *ref)
 {
 	struct cpu_rmap *rmap = container_of(ref, struct cpu_rmap, refcount);
 	kfree(rmap);
@@ -84,23 +84,14 @@ static inline void cpu_rmap_get(struct c
 }
 
 /**
- * cpu_rmap_put - internal helper to release ref on a cpu_rmap
+ * cpu_rmap_put - release ref on a cpu_rmap
  * @rmap: reverse-map allocated with alloc_cpu_rmap()
  */
-static inline void cpu_rmap_put(struct cpu_rmap *rmap)
+int cpu_rmap_put(struct cpu_rmap *rmap)
 {
-	kref_put(&rmap->refcount, cpu_rmap_reclaim);
+	return kref_put(&rmap->refcount, cpu_rmap_release);
 }
-
-/**
- * free_cpu_rmap - free CPU affinity reverse-map
- * @rmap: Reverse-map allocated with alloc_cpu_rmap()
- */
-void free_cpu_rmap(struct cpu_rmap *rmap)
-{
-	cpu_rmap_put(rmap);
-}
-EXPORT_SYMBOL(free_cpu_rmap);
+EXPORT_SYMBOL(cpu_rmap_put);
 
 /* Reevaluate nearest object for given CPU, comparing with the given
  * neighbours at the given distance.
_

