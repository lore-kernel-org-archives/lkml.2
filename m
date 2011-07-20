Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab1GTOIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 10:08:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55348 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab1GTOIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 10:08:22 -0400
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
In-Reply-To: <alpine.DEB.2.00.1107200854390.32737@router.home>
References: <20110720121612.28888.38970.stgit@localhost6>
	 <alpine.DEB.2.00.1107201611010.3528@tiger> <20110720134342.GK5349@suse.de>
	 <alpine.DEB.2.00.1107200854390.32737@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jul 2011 16:08:13 +0200
Message-ID: <1311170893.2338.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 20 juillet 2011 à 08:56 -0500, Christoph Lameter a écrit :
> On Wed, 20 Jul 2011, Mel Gorman wrote:
> 
> > > The changelog isn't that convincing, really. This is
> > > kmem_cache_create() so I'm surprised we'd ever get NULL here in
> > > practice. Does this fix some problem you're seeing? If this is
> > > really an issue, I'd blame the page allocator as GFP_KERNEL should
> > > just work.
> > >
> >
> > Besides, is allocating from cache_cache really a
> > PAGE_ALLOC_COSTLY_ORDER allocation? On my laptop at least, it's an
> > order-2 allocation which is supporting up to 512 CPUs and 512 nodes.
> 
> Slab's kmem_cache is configured with an array of NR_CPUS which is the
> maximum nr of cpus supported. Some distros support 4096 cpus in order to
> accomodate SGI machines. That array then will have the size of 4096 * 8 =
> 32k

We currently support a dynamic schem for the possible nodes :

cache_cache.buffer_size = offsetof(struct kmem_cache, nodelists) + 
	nr_node_ids * sizeof(struct kmem_list3 *);

We could have a similar trick to make the real size both depends on
nr_node_ids and nr_cpu_ids.

(struct kmem_cache)->array would become a pointer.



