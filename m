Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab2KMKph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 05:45:37 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61547 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab2KMKpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 05:45:36 -0500
Date: Tue, 13 Nov 2012 11:45:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/19] mm: numa: Add fault driven placement and migration
Message-ID: <20121113104530.GF21522@gmail.com>
References: <1352193295-26815-1-git-send-email-mgorman@suse.de>
 <1352193295-26815-16-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352193295-26815-16-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mgorman@suse.de> wrote:

> NOTE: This patch is based on "sched, numa, mm: Add fault driven
>	placement and migration policy" but as it throws away 
>	all the policy to just leave a basic foundation I had to 
>	drop the signed-offs-by.

So, much of that has been updated meanwhile - but the split 
makes fundamental sense - we considered it before.

One detail you did in this patch was the following rename:

     s/EMBEDDED_NUMA/NUMA_VARIABLE_LOCALITY

> --- a/arch/sh/mm/Kconfig
> +++ b/arch/sh/mm/Kconfig
> @@ -111,6 +111,7 @@ config VSYSCALL
>  config NUMA
>  	bool "Non Uniform Memory Access (NUMA) Support"
>  	depends on MMU && SYS_SUPPORTS_NUMA && EXPERIMENTAL
> +	select NUMA_VARIABLE_LOCALITY
>  	default n
>  	help
>  	  Some SH systems have many various memories scattered around
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
>
..aaba45d 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -696,6 +696,20 @@ config LOG_BUF_SHIFT
>  config HAVE_UNSTABLE_SCHED_CLOCK
>  	bool
>  
> +#
> +# For architectures that (ab)use NUMA to represent different memory regions
> +# all cpu-local but of different latencies, such as SuperH.
> +#
> +config NUMA_VARIABLE_LOCALITY
> +	bool

The NUMA_VARIABLE_LOCALITY name slightly misses the real point 
though that NUMA_EMBEDDED tried to stress: it's important to 
realize that these are systems that (ab-)use our NUMA memory 
zoning code to implement support for variable speed RAM modules 
- so they can use the existing node binding ABIs.

The cost of that is the losing of the regular NUMA node 
structure. So by all means it's a convenient hack - but the name 
must signal that. I'm not attached to the NUMA_EMBEDDED naming 
overly strongly, but NUMA_VARIABLE_LOCALITY sounds more harmless 
than it should.

Perhaps ARCH_WANT_NUMA_VARIABLE_LOCALITY_OVERRIDE? A tad long 
but we don't want it to be overused in any case.

Thanks,

	Ingo
