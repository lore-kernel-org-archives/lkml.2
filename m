Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0EYLjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 07:39:53 -0400
Received: from mail4.comsite.net ([205.238.176.238]:20771 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab0EYLjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 07:39:52 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.98.68;
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
From: Millton Miller <miltonm@bga.com>
Subject: [Patch 1/4] Allow arch-specific cleanup before breakpoint
	unregistration
In-Reply-To: <20100525091356.GB29003@in.ibm.com>
References: <20100525083055.342788418@linux.vnet.ibm.com> <20100525091356.GB29003@in.ibm.com>
User-Agent: vi
Cc: Michael Neuling <mikey@neuling.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, shaggy@linux.vnet.ibm.com,
       Frederic Weisbecker <fweisbec@gmail.com>,
       David Gibson <dwg@au1.ibm.com>, Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 25 May 2010 06:39:19 -0500
X-Originating-IP: 71.22.98.68
Message-ID: <1274787559_8162@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 at 14:43:56 +0530, K.Prasad wrote:
> Certain architectures (such as PowerPC Book III S) have a need to cleanup
> data-structures before the breakpoint is unregistered. This patch introduces
> an arch-specific hook in release_bp_slot() along with a weak definition in
> the form of a stub funciton.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  kernel/hw_breakpoint.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)


My understanding is weak function definitions must appear in a different C
file than their call sites to work on some toolchains.

Andrew, can you confirm the above statement?

> Index: linux-2.6.ppc64_test/kernel/hw_breakpoint.c
> ===================================================================
> --- linux-2.6.ppc64_test.orig/kernel/hw_breakpoint.c
> +++ linux-2.6.ppc64_test/kernel/hw_breakpoint.c
> @@ -242,6 +242,17 @@  toggle_bp_slot(struct perf_event *bp, bo
>  }
>  
>  /*
> + * Function to perform processor-specific cleanup during unregistration
> + */
> +__weak void arch_unregister_hw_breakpoint(struct perf_event *bp)
> +{
> +	/*
> +	 * A weak stub function here for those archs that don't define
> +	 * it inside arch/.../kernel/hw_breakpoint.c
> +	 */
> +}
> +
> +/*
>   * Contraints to check before allowing this new breakpoint counter:
>   *
>   *  == Non-pinned counter == (Considered as pinned for now)
> @@ -339,6 +350,7 @@  void release_bp_slot(struct perf_event *
>  {
>  	mutex_lock(&nr_bp_mutex);
>  
> +	arch_unregister_hw_breakpoint(bp);
>  	__release_bp_slot(bp);
>  
>  	mutex_unlock(&nr_bp_mutex);
> 


Since the weak version is empty, should it just be delcared (in
a header, put the comment there) and not defined?

milton
