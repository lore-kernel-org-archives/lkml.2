Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab0KCHGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 03:06:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:60797 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab0KCHGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 03:06:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,287,1286175600"; 
   d="scan'208";a="343960949"
Subject: Re: [RFC 4/4]x86: avoid tlbstate lock if no enough cpus
From: Shaohua Li <shaohua.li@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <1288767580.2467.636.camel@edumazet-laptop>
References: <1288766668.23014.117.camel@sli10-conroe>
	 <1288767580.2467.636.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 15:06:35 +0800
Message-ID: <1288767995.23014.120.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-03 at 14:59 +0800, Eric Dumazet wrote:
> Le mercredi 03 novembre 2010 à 14:44 +0800, Shaohua Li a écrit :
> > This one isn't related to previous patch. If online cpus are below
> > NUM_INVALIDATE_TLB_VECTORS, we don't need the lock. The comments
> > in the code declares we don't need the check, but a hot lock still
> > needs an atomic operation and expensive, so add the check here.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > ---
> >  arch/x86/mm/tlb.c |   14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> > 
> > Index: linux/arch/x86/mm/tlb.c
> > ===================================================================
> > --- linux.orig/arch/x86/mm/tlb.c	2010-11-02 10:31:51.000000000 +0800
> > +++ linux/arch/x86/mm/tlb.c	2010-11-02 14:53:27.000000000 +0800
> > @@ -174,17 +174,16 @@ static void flush_tlb_others_ipi(const s
> >  {
> >  	unsigned int sender;
> >  	union smp_flush_state *f;
> > +	bool do_lock = false;
> >  
> >  	/* Caller has disabled preemption */
> >  	sender = this_cpu_read(tlb_vector_offset);
> >  	f = &flush_state[sender];
> >  
> > -	/*
> > -	 * Could avoid this lock when
> > -	 * num_online_cpus() <= NUM_INVALIDATE_TLB_VECTORS, but it is
> > -	 * probably not worth checking this for a cache-hot lock.
> > -	 */
> > -	raw_spin_lock(&f->tlbstate_lock);
> > +	if (num_online_cpus() > NUM_INVALIDATE_TLB_VECTORS) {
> 
> Ouch, you remove a comment that pretty well explained the problem.
> 
> Last time I checked, num_online_cpus() was pretty expensive on a 4096
> cpus machine, since 4096 bits array is 512 bytes long.
ok
> Are you sure you didnt want to use nr_cpu_ids here ?
just don't want to include the non-present cpus here. I wonder why we
haven't a variable to record online cpu number.

Thanks,
Shaohua

