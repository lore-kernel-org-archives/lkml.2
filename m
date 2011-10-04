Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab1JDO27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 10:28:59 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:27421 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757065Ab1JDO26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:28:58 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: xrS2RPEVM1lPqdXGeMtweBFXV5PfsRxHYcQmywebP9hQofz
 aQEn_tBf34nTc0NEVFJc1nww_Qa0o2G6lU2X8FwkVEYVqX0kENHCxxc0AaSc
 MWXl6oU4gpw1NeEU8X7mR3lEi5C5K.3.ikT_s.P.lD4TFXu53YZqoPkCyQt.
 hW3Sojb8XF.qQZdEokBHdAi8Cyn._CKBxvbewCAIVD3Q1mVpRYb53qTx7RDx
 MQX1CKwIl.pI0puSOJuI9xhhA8cCOgqCqpVmiQ1CMK4iLmWiuzyJNDrfS2Tj
 L5Gfkja54m4X5mFm8YWHCaxdkT_L.M_Qhx0LDwPJu3zflSa4RPyhSqaIHXdV
 COF4I16hX7MKtPt1.dgyA6nbTGX1fMBiXl_B3nMTY4J9yFJ0-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 4 Oct 2011 09:28:54 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        penberg@kernel.org, mpm@selenic.com, linux-mm@kvack.org
Subject: Re: lockdep recursive locking detected (rcu_kthread /
 __cache_free)
In-Reply-To: <20111003214739.GK2403@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1110040916330.8522@router.home>
References: <20111003175322.GA26122@sucs.org> <20111003203139.GH2403@linux.vnet.ibm.com> <alpine.DEB.2.00.1110031540560.11713@router.home> <20111003214739.GK2403@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Oct 2011, Paul E. McKenney wrote:

> On Mon, Oct 03, 2011 at 03:46:11PM -0500, Christoph Lameter wrote:
> > On Mon, 3 Oct 2011, Paul E. McKenney wrote:
> >
> > > The first lock was acquired here in an RCU callback.  The later lock that
> > > lockdep complained about appears to have been acquired from a recursive
> > > call to __cache_free(), with no help from RCU.  This looks to me like
> > > one of the issues that arise from the slab allocator using itself to
> > > allocate slab metadata.
> >
> > Right. However, this is a false positive since the slab cache with
> > the metadata is different from the slab caches with the slab data. The slab
> > cache with the metadata does not use itself any metadata slab caches.
>
> Wouldn't it be possible to pass a new flag to the metadata slab caches
> upon creation so that their locks could be placed in a separate lock
> class?  Just allocate a separate lock_class_key structure for each such
> lock in that case, and then use lockdep_set_class_and_name to associate
> that structure with the corresponding lock.  I do this in kernel/rcutree.c
> in order to allow the rcu_node tree's locks to nest properly.

We could give the kmalloc array a different class from created slab
caches. That should have the desired effect.

But that seems to be already the case (looking at init_node_lock_keys).
Non OFF_SLAB caches seem to be getting a different lock class? Why is this
not working?

static void init_node_lock_keys(int q)
{
        struct cache_sizes *s = malloc_sizes;

        if (g_cpucache_up != FULL)
                return;

        for (s = malloc_sizes; s->cs_size != ULONG_MAX; s++) {
                struct kmem_list3 *l3;

                l3 = s->cs_cachep->nodelists[q];
                if (!l3 || OFF_SLAB(s->cs_cachep))
                        continue;

                slab_set_lock_classes(s->cs_cachep, &on_slab_l3_key,
                                &on_slab_alc_key, q);
        }
}




