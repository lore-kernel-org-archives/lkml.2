Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab1KWGXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:23:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50402 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab1KWGXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:23:48 -0500
Date: Wed, 23 Nov 2011 08:23:31 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Matt Mackall <mpm@selenic.com>, Sasha Levin <levinsasha928@gmail.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        apkm@linux-foundation.org
Subject: Re: [PATCH v4 4/5] slub: Only IPI CPUs that have per cpu obj to
 flush
In-Reply-To: <1321960128-15191-5-git-send-email-gilad@benyossef.com>
Message-ID: <alpine.LFD.2.02.1111230822270.1773@tux.localdomain>
References: <1321960128-15191-1-git-send-email-gilad@benyossef.com> <1321960128-15191-5-git-send-email-gilad@benyossef.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Gilad Ben-Yossef wrote:
> static void flush_all(struct kmem_cache *s)
> {
> -	on_each_cpu(flush_cpu_slab, s, 1);
> +	cpumask_var_t cpus;
> +	struct kmem_cache_cpu *c;
> +	int cpu;
> +
> +	if (likely(zalloc_cpumask_var(&cpus, GFP_ATOMIC))) {

__GFP_NOWARN too maybe?

> +		for_each_online_cpu(cpu) {
> +			c = per_cpu_ptr(s->cpu_slab, cpu);
> +			if (c->page)
> +				cpumask_set_cpu(cpu, cpus);
> +		}
> +		on_each_cpu_mask(cpus, flush_cpu_slab, s, 1);
> +		free_cpumask_var(cpus);
> +	} else
> +		on_each_cpu(flush_cpu_slab, s, 1);
> }

Acked-by: Pekka Enberg <penberg@kernel.org>

I can't take the patch because it depends on a new API introduced in the 
first patch.

I'm CC'ing Andrew.

 			Pekka
