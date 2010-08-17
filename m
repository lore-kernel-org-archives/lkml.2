Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab0HQN4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:56:33 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:47510 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751052Ab0HQN4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:56:32 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: iv1hVVoVM1mK4pswX6_PnQ_kgFBe4sAJUNuQky9toJ51JJ6
 K67Cy5GtLSehb22YQ.p5uz43lJTkRaBYWH5YFGht9vBe4qSihPBaGFJewev1
 q8MNDEigrnBoTNe0XZwOrg2LOafY9FeTMFZO_pJz0WtlxKDt_omJVgdirwH.
 PxjNbdElV21v.z6A75ytZa3KB3al4vq2pu8rVzU91IzOFkweSHuzqes7Dp4p
 F
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 17 Aug 2010 08:56:28 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q3 00/23] SLUB: The Unified slab allocator (V3)
In-Reply-To: <4C6A408C.6040203@kernel.org>
Message-ID: <alpine.DEB.2.00.1008170854060.7853@router.home>
References: <20100804024514.139976032@linux.com> <alpine.DEB.2.00.1008032138160.20049@chino.kir.corp.google.com> <alpine.DEB.2.00.1008041115500.11084@router.home> <alpine.DEB.2.00.1008050136340.30889@chino.kir.corp.google.com> <alpine.DEB.2.00.1008051231400.6787@router.home>
 <alpine.DEB.2.00.1008151627450.27137@chino.kir.corp.google.com> <4C6A408C.6040203@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010, Tejun Heo wrote:

> Hello,
>
> On 08/17/2010 06:56 AM, David Rientjes wrote:
> > I'm adding Tejun Heo to the cc because of another thing that may be
> > problematic: alloc_percpu() allocates GFP_KERNEL memory, so when we try to
> > allocate kmem_cache_cpu for a DMA cache we may be returning memory from a
> > node that doesn't include lowmem so there will be no affinity between the
> > struct and the slab.  I'm wondering if it would be better for the percpu
> > allocator to be extended for kzalloc_node(), or vmalloc_node(), when
> > allocating memory after the slab layer is up.
>
> Hmmm... do you mean adding @gfp_mask to percpu allocation function?

DMA caches may only exist on certain nodes because others do not have a
DMA zone. Their role is quite limited these days. DMA caches allocated on
nodes without DMA zones would have their percpu area allocated on the node
but the DMA allocations would be redirected to the closest node with DMA
memory.

> I've been thinking about adding it for atomic allocations (Christoph,
> do you still want it?).  I've been sort of against it because I
> primarily don't really like atomic allocations (it often just pushes
> error handling complexities elsewhere where it becomes more complex)
> and it would also require making vmalloc code do atomic allocations.

At this point I would think that we do not need that support.

