Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0FAHTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 03:19:40 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:34493 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0FAHTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 03:19:38 -0400
Date: Tue, 1 Jun 2010 09:19:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, gregkh@suse.de
Subject: Re: [PATCH V3] x86, UV: BAU performance and error recovery
Message-ID: <20100601071931.GB13641@elte.hu>
References: <E1OJCtx-00024G-RE@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OJCtx-00024G-RE@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> 
> Ingo,
> This patch updates the patch of the same name, which is in your lastest -tip
>   b8f7fb1: x86, UV: Improve BAU performance and error recovery
> It does not depend on any other patch.
> 
> It includes the BAU tunables interfaced through debugfs (instead of /proc)
> per Greg Kroah-Hartman's recommendation.
> 
> This patch
> - corrects several bugs:
>   o the lack of BAU messaging to blade 0 (an uninitialized field)
>   o correct message type for a normal shootdown message
>   o fix to recovery from timed-out s/w acknowledge resources
>   o calculation of the actual destination timeout so that a 'short' timeout can
>     be identified
>   o fix mishandling of non-consecutive hub and socket numbers
>   o identification of a cpu's socket number
>   o removal of the check for the h/w stay-busy bug, as under extreme pressure it
>     cannot be accurately detected
>   o fall back to IPI-method when extreme pressure makes numalink very slow,
>     and then resume BAU-method after an interval
> - adds BAU broadcasting to the cpu's on the local node
> - simplifies the returning of the original cpu bitmap when the BAU attempt
>   is given up entirely
> - adds modification of tuning variables through debugfs
>   (/sys/kernel/debug/sgi_uv/bau_tunables)
> 
> Peter, I weighed the review-ability of a patch for each bug fix and each
> addition, versus the ease of tracking a single patch. And decided on the
> latter since these bugs and features are only of interest to SGI UV. Hope
> that is reasonable.
> 
> Diffed against 2.6.34 -tip  (Sheep on Meth)
> 
> Signed-off-by: Cliff Wickman <cpw@sgi.com>
> 
> ---
>  arch/x86/include/asm/uv/uv_bau.h |  151 ++++++---
>  arch/x86/kernel/tlb_uv.c         |  640 +++++++++++++++++++++++++++------------
>  2 files changed, 554 insertions(+), 237 deletions(-)

Such a large patch cannot go into 2.6.35 - we are after -rc1 already.

So if you want the fixes to be in 2.6.35 then please separate them out into 
small, digestable patches.

As far as the feature work goes, it looks rather ugly:

> +int uv_flush_send_and_wait(struct bau_desc *bau_desc,
> +			   struct cpumask *flush_mask, struct bau_control *bcp)
>  {
>  	int right_shift;
> -	int uvhub;
> -	int bit;
>  	int completion_status = 0;
>  	int seq_number = 0;
>  	long try = 0;
>  	int cpu = bcp->uvhub_cpu;
> +	int tcpu;
>  	int this_cpu = bcp->cpu;
> -	int this_uvhub = bcp->uvhub;
>  	unsigned long mmr_offset;
>  	unsigned long index;
>  	cycles_t time1;
>  	cycles_t time2;
> -	struct ptc_stats *stat = &per_cpu(ptcstats, bcp->cpu);
> +	cycles_t elapsed;
> +	cycles_t local_congested_cycles = congested_cycles;
> +	struct ptc_stats *stat = bcp->statp;
>  	struct bau_control *smaster = bcp->socket_master;
>  	struct bau_control *hmaster = bcp->uvhub_master;
> +	struct bau_control *tbcp;


There is absolutely no reason for uv_flush_send_and_wait() to be a 150+ lines 
long monster-function ... Please reduce the size of functions in tlb_uv.c by 
introducing proper helper functions.

Also, instead of dropping a mega-patch per cycle you should split out the 
changes some more, so that they are more reviewable. This current patch should 
have come as about 10 patches. Each patch should do one well-defined thing, 
not a laundry list of changes integrated up over a few weeks/months.

Thanks,

	Ingo
