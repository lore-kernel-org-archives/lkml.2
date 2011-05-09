Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab1EIA3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:29:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45584 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab1EIA3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:29:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cpumask: alloc_cpumask_var() use NUMA_NO_NODE
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
In-Reply-To: <20110505124556.3c8a7e5b.akpm@linux-foundation.org>
References: <20110428231856.3D54.A69D9226@jp.fujitsu.com> <20110505124556.3c8a7e5b.akpm@linux-foundation.org>
Message-Id: <20110509093043.3ABB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon,  9 May 2011 09:29:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Thu, 28 Apr 2011 23:17:15 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > NUMA_NO_NODE and numa_node_id() are different meanings. NUMA_NO_NODE 
> > is obviously recomended fallback.
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  lib/cpumask.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/lib/cpumask.c b/lib/cpumask.c
> > index 4f6425d..af3e581 100644
> > --- a/lib/cpumask.c
> > +++ b/lib/cpumask.c
> > @@ -131,7 +131,7 @@ EXPORT_SYMBOL(zalloc_cpumask_var_node);
> >   */
> >  bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
> >  {
> > -	return alloc_cpumask_var_node(mask, flags, numa_node_id());
> > +	return alloc_cpumask_var_node(mask, flags, NUMA_NO_NODE);
> >  }
> >  EXPORT_SYMBOL(alloc_cpumask_var);
> >  
> 
> So effectively this will replace numa_node_id() with numa_mem_id(),
> yes?  What runtime effects might this have?  

If I understand correctly,

 alloc_pages_node():  same effect both NUMA_NO_NODE and numa_node_id()
 kmalloc_node(): not same effect NUMA_NO_NODE and numa_node_id()

because 

slub.c
---------------------------------------------------
	slab_alloc() {
	 (snip)
	        if (unlikely(!object || !node_match(c, node)))
			// slow path
	        else {
			// fast path

and

	static inline int node_match(struct kmem_cache_cpu *c, int node)
	{
	#ifdef CONFIG_NUMA
	        if (node != NUMA_NO_NODE && c->node != node)
	                return 0;
	#endif
	        return 1;
	}
---------------------------------------------------
In a nutshell, numa_node_id() reduce slab cache reusing chance.


Oh, I missed slab.c code. It's using numa_mem_id(). thank you correct me!

numa_mem_id() don't have much meanings. It's ia64 HP big machine quirk.
it only affect to improve slab performance a little if users try to allocate
a memory from a cpu within memoryless node . and, 99% users never use such machine.

In a nutshell, NUMA_NO_NODE and numa_node_id() don't have a lot of difference
if users are using SLAB.


