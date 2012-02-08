Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab2BHTtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 14:49:12 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:20814 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932119Ab2BHTtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 14:49:09 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: FkE.aIkVM1lMQwVGmGt7lUdw0h_tQ6k7xqmYvOL2kbV7n_g
 u.B_CpIdBQPksRmXgRRbB9BN.NhZDe.k9_MlI14qgFMyvA_dg4sK17.C9SpM
 pREOMxVUmFoAC7.3SSjy5FSQbp6bq2t1R9oD78L7ws2sFNHF4todsZgkn2pp
 vf8C2tGwcmZX1.56BVXPMg.wZuRyB0KOeY_LYSbs4vIAsEQ7QcjhzsRK_M2Q
 wx8frzqaSRi00VOaYo7FP5uGOBaJ0cuRJmUklpv9.KOl7ndmYBrF1VUxyOjL
 L8VhGfsmYQOTsCbi_tMrWSvIiOzUtUbqyGfRUakgrqwLYsjLDtX4PqNyZctx
 pTOB60piqtRmQwc.jhZhW0cPatFYso22DhaPNJwLtIXwn7UO.gd7onXKtM7I
 uXlmRLTFGvVjI33EqxGOd0f5kRUui0PPcOfx4
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 8 Feb 2012 13:49:05 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 02/15] mm: sl[au]b: Add knowledge of PFMEMALLOC reserve
 pages
In-Reply-To: <20120208163421.GL5938@suse.de>
Message-ID: <alpine.DEB.2.00.1202081338210.32060@router.home>
References: <1328568978-17553-1-git-send-email-mgorman@suse.de> <1328568978-17553-3-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1202071025050.30652@router.home> <20120208144506.GI5938@suse.de> <alpine.DEB.2.00.1202080907320.30248@router.home>
 <20120208163421.GL5938@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Feb 2012, Mel Gorman wrote:

> Ok, I looked into what is necessary to replace these with checking a page
> flag and the cost shifts quite a bit and ends up being more expensive.

That is only true if you go the slab route. Slab suffers from not having
the page struct pointer readily available. The changes are likely already
impacting slab performance without the virt_to_page patch.

> In slub, it's sufficient to check kmem_cache_cpu to know whether the
> objects in the list are pfmemalloc or not.

We try to minimize the size of kmem_cache_cpu. The page pointer is readily
available. We just removed the node field from kmem_cache_cpu because it
was less expensive to get the node number from the struct page field.

The same is certainly true for a PFMEMALLOC flag.

> Yeah, you're right on the button there. I did my checking assuming that
> PG_active+PG_slab were safe to use. The following is an untested patch that
> I probably got details wrong in but it illustrates where virt_to_page()
> starts cropping up.

Yes you need to come up with a way to not use virt_to_page otherwise slab
performance is significantly impacted. On NUMA we are already doing a page
struct lookup on free in slab. If you would save the page struct pointer
there and reuse it then you would not have an issue at least on free.

You still would need to determine which "struct slab" pointer is in use
which will also require similar lookups in varous places.

Transfer of the pfmemalloc flags (guess you must have a pfmemalloc
field in struct slab then) in slab is best be done when allocating and
freeing a slab page from the page allocator.

I think its rather trivial to add the support you want in a non intrusive
way to slub. Slab would require some more thought and discussion.

