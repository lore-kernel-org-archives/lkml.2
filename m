Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0KDFVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 01:21:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:47329 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab0KDFVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 01:21:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,293,1286175600"; 
   d="scan'208";a="854020328"
Subject: Re: [RFC 4/4]x86: avoid tlbstate lock if no enough cpus
From: Shaohua Li <shaohua.li@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <1288775282.2511.9.camel@edumazet-laptop>
References: <1288766668.23014.117.camel@sli10-conroe>
	 <1288767580.2467.636.camel@edumazet-laptop>
	 <1288767995.23014.120.camel@sli10-conroe>
	 <1288768330.2467.660.camel@edumazet-laptop>
	 <1288768795.23014.123.camel@sli10-conroe>
	 <1288769123.2467.681.camel@edumazet-laptop>
	 <1288769486.2467.690.camel@edumazet-laptop>
	 <1288773716.23014.124.camel@sli10-conroe>
	 <1288775282.2511.9.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 13:21:19 +0800
Message-ID: <1288848079.23014.131.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-03 at 17:08 +0800, Eric Dumazet wrote:
> Le mercredi 03 novembre 2010 à 16:41 +0800, Shaohua Li a écrit :
> 
> > yes, this is ok. we might need avoid some cpu hotplug race too. I'll
> > post a new patch later.
> > 
> > 
> 
> Hmm, maybe only set the variable "must take the lock", never unset it.
I followed your suggestions to use nr_cpu_ids, it should be good enough.

Thanks,
Shaohua


This one isn't related to previous patch. If online cpus are below
NUM_INVALIDATE_TLB_VECTORS, we don't need the lock. The comments
in the code declares we don't need the check, but a hot lock still
needs an atomic operation and expensive, so add the check here.

Uses nr_cpu_ids here as suggested by Eric Dumazet.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 arch/x86/mm/tlb.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: linux/arch/x86/mm/tlb.c
===================================================================
--- linux.orig/arch/x86/mm/tlb.c	2010-11-04 10:59:09.000000000 +0800
+++ linux/arch/x86/mm/tlb.c	2010-11-04 13:17:51.000000000 +0800
@@ -179,12 +179,8 @@ static void flush_tlb_others_ipi(const s
 	sender = this_cpu_read(tlb_vector_offset);
 	f = &flush_state[sender];
 
-	/*
-	 * Could avoid this lock when
-	 * num_online_cpus() <= NUM_INVALIDATE_TLB_VECTORS, but it is
-	 * probably not worth checking this for a cache-hot lock.
-	 */
-	raw_spin_lock(&f->tlbstate_lock);
+	if (nr_cpu_ids > NUM_INVALIDATE_TLB_VECTORS)
+		raw_spin_lock(&f->tlbstate_lock);
 
 	f->flush_mm = mm;
 	f->flush_va = va;
@@ -202,7 +198,8 @@ static void flush_tlb_others_ipi(const s
 
 	f->flush_mm = NULL;
 	f->flush_va = 0;
-	raw_spin_unlock(&f->tlbstate_lock);
+	if (nr_cpu_ids > NUM_INVALIDATE_TLB_VECTORS)
+		raw_spin_unlock(&f->tlbstate_lock);
 }
 
 void native_flush_tlb_others(const struct cpumask *cpumask,


