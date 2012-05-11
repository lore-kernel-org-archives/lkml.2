Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139Ab2EKCTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 22:19:43 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:34755 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759073Ab2EKCTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 22:19:40 -0400
Message-ID: <4FAC7733.1050100@linux.vnet.ibm.com>
Date: Fri, 11 May 2012 10:19:31 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Diwakar Tundlam <dtundlam@nvidia.com>, "'Ingo Molnar'" <mingo@kernel.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH] sched: Make nr_uninterruptible count a signed value
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10C@HQMAIL04.nvidia.com> <1336514192.8226.52.camel@twins> <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10D@HQMAIL04.nvidia.com> <1336516020.8226.57.camel@twins> <1336516174.8226.59.camel@twins> <1DD7BFEDD3147247B1355BEFEFE46652379C3DF10E@HQMAIL04.nvidia.com> <1336551100.27020.84.camel@laptop> <4FAB38ED.5050200@linux.vnet.ibm.com> <1336643166.2527.86.camel@twins>
In-Reply-To: <1336643166.2527.86.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051102-5564-0000-0000-000002A2971B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 05:46 PM, Peter Zijlstra wrote:

> Or something like the below.. I recently changed nr_running to int (see
> c82513e51) so P(nr_running) would also benefit.
> 
> ---
>  kernel/sched/debug.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index 31e4f61..954fabf 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -260,8 +260,14 @@ static void print_cpu(struct seq_file *m, int cpu)
>  	SEQ_printf(m, "\ncpu#%d\n", cpu);
>  #endif
> 
> -#define P(x) \
> -	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rq->x))
> +#define P(x)								\
> +do {									\
> +	if (sizeof(rq->x) == 4)						\
> +		SEQ_printf(m, "  .%-30s: %ld\n", #x, (long)(rq->x));	\


Oh, yes, I haven't noticed that sizeof could also be a check point.
So now we can use P(x) freely and don't need to worry about anything.

Regards,
Michael Wang

> +	else								\
> +		SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(rq->x));\
> +} while (0)
> +		
>  #define PN(x) \
>  	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", #x, SPLIT_NS(rq->x))
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


