Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab1GTPJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 11:09:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45454 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1GTPJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 11:09:30 -0400
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
In-Reply-To: <alpine.DEB.2.00.1107200950270.1472@router.home>
References: <20110720121612.28888.38970.stgit@localhost6>
	 <alpine.DEB.2.00.1107201611010.3528@tiger> <20110720134342.GK5349@suse.de>
	 <alpine.DEB.2.00.1107200854390.32737@router.home>
	 <1311170893.2338.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <alpine.DEB.2.00.1107200950270.1472@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jul 2011 17:09:22 +0200
Message-ID: <1311174562.2338.42.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 20 juillet 2011 à 09:52 -0500, Christoph Lameter a écrit :
> On Wed, 20 Jul 2011, Eric Dumazet wrote:
> 
> > > Slab's kmem_cache is configured with an array of NR_CPUS which is the
> > > maximum nr of cpus supported. Some distros support 4096 cpus in order to
> > > accomodate SGI machines. That array then will have the size of 4096 * 8 =
> > > 32k
> >
> > We currently support a dynamic schem for the possible nodes :
> >
> > cache_cache.buffer_size = offsetof(struct kmem_cache, nodelists) +
> > 	nr_node_ids * sizeof(struct kmem_list3 *);
> >
> > We could have a similar trick to make the real size both depends on
> > nr_node_ids and nr_cpu_ids.
> >
> > (struct kmem_cache)->array would become a pointer.
> 
> We should be making it a per cpu pointer like slub then. I looked at what
> it would take to do so a couple of month ago but it was quite invasive.
> 

Lets try this first patch, simple enough : No need to setup percpu data
for a one time use structure...

[PATCH] slab: remove one NR_CPUS dependency

Reduce high order allocations in do_tune_cpucache() for some setups.
(NR_CPUS=4096 -> we need 64KB)

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Pekka Enberg <penberg@kernel.org>
CC: Christoph Lameter <cl@linux.com>
---
 mm/slab.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index d96e223..862bd12 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3933,7 +3933,7 @@ fail:
 
 struct ccupdate_struct {
 	struct kmem_cache *cachep;
-	struct array_cache *new[NR_CPUS];
+	struct array_cache *new[0];
 };
 
 static void do_ccupdate_local(void *info)
@@ -3955,7 +3955,8 @@ static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
 	struct ccupdate_struct *new;
 	int i;
 
-	new = kzalloc(sizeof(*new), gfp);
+	new = kzalloc(sizeof(*new) + nr_cpu_ids * sizeof(struct array_cache *),
+		      gfp);
 	if (!new)
 		return -ENOMEM;
 


