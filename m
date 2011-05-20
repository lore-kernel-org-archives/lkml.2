Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933837Ab1ETNbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:31:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53275 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756426Ab1ETNbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:31:33 -0400
Date: Fri, 20 May 2011 15:31:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2] x86: UV uv_tlb.c cleanup
Message-ID: <20110520133128.GC17699@elte.hu>
References: <E1QNPH2-0006eo-8E@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QNPH2-0006eo-8E@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> +static ssize_t tunables_write(struct file *file, const char __user *user,
> +				size_t count, loff_t *data)
> +{
> +	int cpu;
> +	int ret;
> +	char instr[100];
> +	struct bau_control *bcp;
> +
> +	if (count == 0 || count > sizeof(instr)-1)
> +		return -EINVAL;
> +	if (copy_from_user(instr, user, count))
> +		return -EFAULT;
> +	instr[count] = '\0';
> +	bcp = &per_cpu(bau_control, smp_processor_id());
> +	ret = parse_tunables_write(bcp, instr, count);
> +	if (ret)
> +		return ret;
>  	for_each_present_cpu(cpu) {
>  		bcp = &per_cpu(bau_control, cpu);
> -		bcp->max_bau_concurrent = max_bau_concurrent;
> -		bcp->max_bau_concurrent_constant = max_bau_concurrent;
> +		bcp->max_concurr = max_concurr;
> +		bcp->max_concurr_const = max_concurr;
>  		bcp->plugged_delay = plugged_delay;
>  		bcp->plugsb4reset = plugsb4reset;
>  		bcp->timeoutsb4reset = timeoutsb4reset;
>  		bcp->ipi_reset_limit = ipi_reset_limit;
>  		bcp->complete_threshold = complete_threshold;
> -		bcp->congested_response_us = congested_response_us;
> -		bcp->congested_reps = congested_reps;
> -		bcp->congested_period = congested_period;
> +		bcp->cong_response_us = congested_response_us;
> +		bcp->cong_reps = congested_reps;
> +		bcp->cong_period = congested_period;
>  	}
>  	return count;
>  }
>  
>  static const struct seq_operations uv_ptc_seq_ops = {
> -	.start		= uv_ptc_seq_start,
> -	.next		= uv_ptc_seq_next,
> -	.stop		= uv_ptc_seq_stop,
> -	.show		= uv_ptc_seq_show
> +	.start		= ptc_seq_start,
> +	.next		= ptc_seq_next,
> +	.stop		= ptc_seq_stop,
> +	.show		= ptc_seq_show

Please apply vertical alignment for mass-initializations as well, like the ones further above.

This:

 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);

		bcp->max_concurr		= max_concurr;
		bcp->max_concurr_const		= max_concurr;
 		bcp->plugged_delay		= plugged_delay;
 		bcp->plugsb4reset		= plugsb4reset;
 		bcp->timeoutsb4reset		= timeoutsb4reset;
 		bcp->ipi_reset_limit		= ipi_reset_limit;
 		bcp->complete_threshold		= complete_threshold;
		bcp->cong_response_us		= congested_response_us;
		bcp->cong_reps			= congested_reps;
		bcp->cong_period		= congested_period;
	}

Looks a *lot* tidier visually.

Another detail is the lack of separation between blocks of code:

> +	if (count == 0 || count > sizeof(instr)-1)
> +		return -EINVAL;
> +	if (copy_from_user(instr, user, count))
> +		return -EFAULT;
> +	instr[count] = '\0';
> +	bcp = &per_cpu(bau_control, smp_processor_id());
> +	ret = parse_tunables_write(bcp, instr, count);
> +	if (ret)
> +		return ret;
>  	for_each_present_cpu(cpu) {
>  		bcp = &per_cpu(bau_control, cpu);

It looks more structured if it's written like this:

static ssize_t tunables_write(struct file *file, const char __user *user,
				size_t count, loff_t *data)
{
	int cpu;
	int ret;
	char instr[100];
	struct bau_control *bcp;

	if (count == 0 || count > sizeof(instr)-1)
		return -EINVAL;
	if (copy_from_user(instr, user, count))
		return -EFAULT;

	instr[count] = '\0';

	bcp = &per_cpu(bau_control, smp_processor_id());

	ret = parse_tunables_write(bcp, instr, count);
	if (ret)
		return ret;

 	for_each_present_cpu(cpu) {
 		bcp = &per_cpu(bau_control, cpu);

Let the code breath and keep bits together that belong together.

That way the reviewer can see the various key steps at a glance, the code 
becomes more structured.

The patterns above repeat in many places in uv_tlb.c.

And clean code works: for example, when i look at this restructured code a real 
bug in the code sticks out at me like a sore thumb: the smp_processor_id() is 
called with preemption enabled, this will generate an ugly kernel warning when 
this tunable is tweaked, with the right debug options turned on ...

Btw., please fix the bug in a separate patch, the cleanup patch itself should 
have no functional changes at all.

Thanks,

	Ingo
