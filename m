Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab0FKXck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 19:32:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:48576 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab0FKXci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 19:32:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,405,1272870000"; 
   d="scan'208";a="287988927"
Subject: Re: [PATCH v2 1/2] tmpfs: Quick token library to allow scalable
 retrieval of tokens from token jar
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>
In-Reply-To: <20100611152620.97bc3e59.akpm@linux-foundation.org>
References: <1274902371.31973.9392.camel@mudge.jf.intel.com>
	 <20100601145126.f46572d1.akpm@linux-foundation.org>
	 <87ocftyfnh.fsf@basil.nowhere.org>
	 <20100609153654.0061e9c8.akpm@linux-foundation.org>
	 <1276189574.2385.32.camel@mudge.jf.intel.com>
	 <20100611145219.017a87c0.akpm@linux-foundation.org>
	 <1276294003.2385.48.camel@mudge.jf.intel.com>
	 <20100611152620.97bc3e59.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jun 2010 16:29:59 -0700
Message-ID: <1276298999.2385.71.camel@mudge.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 15:26 -0700, Andrew Morton wrote:

>  	}
> @@ -422,11 +423,11 @@ static swp_entry_t *shmem_swp_alloc(stru
>  		 */
>  		if (sbinfo->max_blocks) {
>  			spin_lock(&sbinfo->stat_lock);
> -			if (sbinfo->free_blocks <= 1) {
> +			if (percpu_counter_read(&sbinfo->free_blocks) <= 1) {
>  				spin_unlock(&sbinfo->stat_lock);

Thanks for pointing me to look at this alternative implementation.

However, looking at the percpu counter code, it appears that the
percpu_counter_read is imprecise.  The counters in the per cpu counters
are not accounted and the value read may be much less than the true
amount of free blocks left when used in the patch above.  We could fail
the above test and not allocate pages when we actually have additional
pages available. Using percpu_counter_sum will give the precise count
but will cause the acquisition of the spin lock in the percpu_counter
and slowed things down in this performance critical path.  If we feel
that we could tolerate fuzziness on the size we configured for tmpfs,
then this could be the way to go.

However, qtoken library implementation will impose a precise limit and
has the per cpu counter's speed advantage.

Tim

