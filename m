Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab1AKMoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:44:19 -0500
Received: from service87.mimecast.com ([94.185.240.25]:52607 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755960Ab1AKMoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:44:16 -0500
Subject: Re: [PATCH] kmemleak: Reduce verbosity when memory allocation fails
From: Catalin Marinas <catalin.marinas@arm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org,
        Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>, "Ted Ts'o" <tytso@mit.edu>
In-Reply-To: <alpine.DEB.2.00.1101101527580.15655@chino.kir.corp.google.com>
References: <20110110181133.14995.12364.stgit@e102109-lin.cambridge.arm.com>
	 <alpine.DEB.2.00.1101101232580.11969@chino.kir.corp.google.com>
	 <AANLkTik-NwSioPg96EFUDzuK=zK0kNbvUeQbt0rwQAtX@mail.gmail.com>
	 <alpine.DEB.2.00.1101101527580.15655@chino.kir.corp.google.com>
Organization: ARM Limited
Date: Tue, 11 Jan 2011 12:44:01 +0000
Message-ID: <1294749841.4666.49.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 11 Jan 2011 12:44:10.0619 (UTC) FILETIME=[3E6F7CB0:01CBB18D]
X-MC-Unique: 111011112441306901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-10 at 23:31 +0000, David Rientjes wrote:
> On Mon, 10 Jan 2011, Catalin Marinas wrote:
> > > It would be a shame if the allocation were __GFP_NORETRY and kmemleak
> > > ended up looping forever because it suppresses the bit for a single page,
> > > it uses __GFP_NOMEMALLOC and kmemleak ends up allocating from memory
> > > reserves, or it uses __GFP_HARDWALL and kmemleak is allocating metadata in
> > > a different cpuset.
> > >
> > > I'm not sure why you're not just masking __GFP_NOFAIL and __GFP_REPEAT and
> > > then failing gracefully?  (And __GFP_ZERO and __GFP_COMP, too, of course.)
[...]
> > If the user calling the kernel alloc function cannot get memory,
> > kmemleak won't be called anyway.
> 
> I'm talking about when the allocation is successful and the metadata
> allocation is not, such as what Toralf reported.  If you pass
> __GFP_NOFAIL, it's going to loop forever which is certainly not what we'd
> want: we'd rather just disable kmemleak and continue doing work.  

I agree with this but kmemleak doesn't pass any __GFP_NOFAIL flag (it's
masked out). The reason it only keeps (GFP_KERNEL | GFP_ATOMIC) from the
caller flags is to know whether the kmemleak metadata allocation must be
atomic or not. All the other flags a user may pass like __GFP_NOFAIL are
masked out.

Of course, kmemleak can pass additional flags for allocating its
metadata, but I see this as unrelated to what the user passed (as long
as the atomicity is preserved).

Now, if the user passes __GFP_NOFAIL, do we want such flag for the
kmemleak allocation? IMHO we don't need this (hence it is masked out).
We just allow the kmemleak allocation to fail.

> If you
> pass __GFP_NOMEMALLOC, then kmemleak can allocate from memory reserves in
> the reclaim path which is not allowed.  And if you don't pass
> __GFP_HARDWALL, then these allocations can break memory isolation by
> allowing the metadata to be allocated from different cpusets.

As I said above, we can pass additional flags like __GFP_NOMEMALLOC. But
I think these should be hard-coded for kmemleak allocations irrespective
of the k*alloc user gfp flags.

As for the __GFP_HARDWALL, I don't think it matters much. Kmemleak
doesn't have per-CPU data anyway and the tree for storing the metada is
a global one. When scanning the memory, it does it on a single CPU no
matter where the object was allocated from.
> 
> In other words, I'm pretty sure you don't want to be masking these options
> off of the caller allocation when passed.  It makes no sense for the user
> to do a GFP_KERNEL | __GFP_NORETRY allocation and then have kmemleak loop
> forever.

__GFP_NORETRY is another flag we could force on kmemleak metadata
allocations. See below:


kmemleak: Allow kmemleak metadata allocations to fail

From: Catalin Marinas <catalin.marinas@arm.com>

This patch adds __GFP_NORETRY and __GFP_NOMEMALLOC flags to the kmemleak
metadata allocations so that it has a smaller effect on the users of the
kernel slab allocator. Since kmemleak allocations can now fail more
often, this patch also reduces the verbosity by passing __GFP_NOWARN and
not dumping the stack trace when a kmemleak allocation fails.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Ted Ts'o <tytso@mit.edu>
---
 mm/kmemleak.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index bd9bc21..84225f3 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -113,7 +113,9 @@
 #define BYTES_PER_POINTER	sizeof(void *)
 
 /* GFP bitmask for kmemleak internal allocations */
-#define GFP_KMEMLEAK_MASK	(GFP_KERNEL | GFP_ATOMIC)
+#define gfp_kmemleak_mask(gfp)	(((gfp) & (GFP_KERNEL | GFP_ATOMIC)) | \
+				 __GFP_NORETRY | __GFP_NOMEMALLOC | \
+				 __GFP_NOWARN)
 
 /* scanning area inside a memory block */
 struct kmemleak_scan_area {
@@ -511,9 +513,10 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 	struct kmemleak_object *object;
 	struct prio_tree_node *node;
 
-	object = kmem_cache_alloc(object_cache, gfp & GFP_KMEMLEAK_MASK);
+	object = kmem_cache_alloc(object_cache, gfp_kmemleak_mask(gfp));
 	if (!object) {
-		kmemleak_stop("Cannot allocate a kmemleak_object structure\n");
+		pr_warning("Cannot allocate a kmemleak_object structure\n");
+		kmemleak_disable();
 		return NULL;
 	}
 
@@ -734,9 +737,9 @@ static void add_scan_area(unsigned long ptr, size_t size, gfp_t gfp)
 		return;
 	}
 
-	area = kmem_cache_alloc(scan_area_cache, gfp & GFP_KMEMLEAK_MASK);
+	area = kmem_cache_alloc(scan_area_cache, gfp_kmemleak_mask(gfp));
 	if (!area) {
-		kmemleak_warn("Cannot allocate a scan area\n");
+		pr_warning("Cannot allocate a scan area\n");
 		goto out;
 	}
 


-- 
Catalin


