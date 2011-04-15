Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab1DOEPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 00:15:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54966 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1DOEPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 00:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fd2dRKd8wzX4uM5qMtbKTEa1Uq3oOg1YOVAuxdeh5fnnMdN5kcVoFtDg0eXN2IGcOB
         xVW3/z10rDlYocYBYW32H9dSY0G96Q1cAV+dkgVmyKqTt1DuNNuPD636tDOjNepfXm55
         ZvUIfBSKKrcPnn8KT9QxVEsdhTzBFYLgfPHFQ=
Date: Fri, 15 Apr 2011 13:15:06 +0900
From: Tejun Heo <tj@kernel.org>
To: shaohua.li@intel.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, cl@linux.com,
        eric.dumazet@gmail.com
Subject: Re: [patch v3 3/3] percpu_counter: use atomic64 for counter in SMP
Message-ID: <20110415041506.GC29512@mtj.dyndns.org>
References: <20110414020447.979946152@sli10-conroe.sh.intel.com>
 <20110414020747.411215973@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414020747.411215973@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 14, 2011 at 10:04:50AM +0800, shaohua.li@intel.com wrote:
> Index: linux/lib/percpu_counter.c
> ===================================================================
> --- linux.orig/lib/percpu_counter.c	2011-04-14 09:53:04.000000000 +0800
> +++ linux/lib/percpu_counter.c	2011-04-14 10:01:29.000000000 +0800
> @@ -59,13 +59,17 @@ void percpu_counter_set(struct percpu_co
>  {
>  	int cpu;
>  
> -	spin_lock(&fbc->lock);
> +	/*
> +	 * Don't really need to disable preempt here, just make sure there is
> +	 * no big latency because of preemption
> +	 */
> +	preempt_disable();
>  	for_each_possible_cpu(cpu) {
>  		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
>  		*pcount = 0;
>  	}
> -	fbc->count = amount;
> -	spin_unlock(&fbc->lock);
> +	atomic64_set(&fbc->count, amount);
> +	preempt_enable();

Disabling preemption here doesn't make any sense.
percpu_counter_set() inherently requires its users to guarantee that
no other user is modifying the percpu counter.

Thanks.

-- 
tejun
