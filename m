Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab0KCG7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 02:59:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56470 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab0KCG7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 02:59:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LqEnv0sY8+d+9kwuvXEAikD9o5ABsGUOQ2pNy31IT1u1P0EkU/GIEb9m7vhqyZU0mA
         KepRXhtGXctirlDoywWocA3SXwnMWA/izl+0ts0nmo5IeJVITNJy9xXRdH8P69go2CcA
         1tEP0ZePOwk+C4iwdXVhIjETJrKYq0Oy1gnWg=
Subject: Re: [RFC 4/4]x86: avoid tlbstate lock if no enough cpus
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <1288766668.23014.117.camel@sli10-conroe>
References: <1288766668.23014.117.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 07:59:40 +0100
Message-ID: <1288767580.2467.636.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 03 novembre 2010 à 14:44 +0800, Shaohua Li a écrit :
> This one isn't related to previous patch. If online cpus are below
> NUM_INVALIDATE_TLB_VECTORS, we don't need the lock. The comments
> in the code declares we don't need the check, but a hot lock still
> needs an atomic operation and expensive, so add the check here.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  arch/x86/mm/tlb.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> Index: linux/arch/x86/mm/tlb.c
> ===================================================================
> --- linux.orig/arch/x86/mm/tlb.c	2010-11-02 10:31:51.000000000 +0800
> +++ linux/arch/x86/mm/tlb.c	2010-11-02 14:53:27.000000000 +0800
> @@ -174,17 +174,16 @@ static void flush_tlb_others_ipi(const s
>  {
>  	unsigned int sender;
>  	union smp_flush_state *f;
> +	bool do_lock = false;
>  
>  	/* Caller has disabled preemption */
>  	sender = this_cpu_read(tlb_vector_offset);
>  	f = &flush_state[sender];
>  
> -	/*
> -	 * Could avoid this lock when
> -	 * num_online_cpus() <= NUM_INVALIDATE_TLB_VECTORS, but it is
> -	 * probably not worth checking this for a cache-hot lock.
> -	 */
> -	raw_spin_lock(&f->tlbstate_lock);
> +	if (num_online_cpus() > NUM_INVALIDATE_TLB_VECTORS) {

Ouch, you remove a comment that pretty well explained the problem.

Last time I checked, num_online_cpus() was pretty expensive on a 4096
cpus machine, since 4096 bits array is 512 bytes long.

Are you sure you didnt want to use nr_cpu_ids here ?

> +		do_lock = true;
> +		raw_spin_lock(&f->tlbstate_lock);
> +	}
>  
>  	f->flush_mm = mm;
>  	f->flush_va = va;
> @@ -202,7 +201,8 @@ static void flush_tlb_others_ipi(const s
>  
>  	f->flush_mm = NULL;
>  	f->flush_va = 0;
> -	raw_spin_unlock(&f->tlbstate_lock);
> +	if (do_lock)
> +		raw_spin_unlock(&f->tlbstate_lock);
>  }
>  
>  void native_flush_tlb_others(const struct cpumask *cpumask,
> 


