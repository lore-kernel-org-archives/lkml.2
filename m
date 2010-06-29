Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab0F2OtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 10:49:17 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:43385 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247Ab0F2OtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 10:49:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XUsyBn1E60Q1r9q3fYN/o3eV7+teIdV/+lztaznPWvFn/PfoOTys0b49pSoklwi67C
         bWjAqIK5u02/Wc4QuVaK8+fHyU+37ABl6C3AxZMy8REwm7yoW//OjfzPxJX8MK9yKMof
         sv1hyf++SjvvqwV5UdbOi8y7wTROGi/ypFfEw=
Date: Tue, 29 Jun 2010 16:49:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 09/11] perf: Default PMU ops
Message-ID: <20100629144920.GD5318@nowhere>
References: <20100624142804.431553874@chello.nl> <20100624143406.993794468@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624143406.993794468@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 04:28:13PM +0200, Peter Zijlstra wrote:
> Provide default implementations for the pmu txn methods, this allows
> us to remove some conditional code.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/perf_event.c |   48 ++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 36 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_event.c
> +++ linux-2.6/kernel/perf_event.c
> @@ -656,21 +656,14 @@ group_sched_in(struct perf_event *group_
>  {
>  	struct perf_event *event, *partial_group = NULL;
>  	struct pmu *pmu = group_event->pmu;
> -	bool txn = false;
>  
>  	if (group_event->state == PERF_EVENT_STATE_OFF)
>  		return 0;
>  
> -	/* Check if group transaction availabe */
> -	if (pmu->start_txn)
> -		txn = true;
> -
> -	if (txn)
> -		pmu->start_txn(pmu);
> +	pmu->start_txn(pmu);
>  
>  	if (event_sched_in(group_event, cpuctx, ctx)) {
> -		if (txn)
> -			pmu->cancel_txn(pmu);
> +		pmu->cancel_txn(pmu);
>  		return -EAGAIN;
>  	}
>  
> @@ -684,7 +677,7 @@ group_sched_in(struct perf_event *group_
>  		}
>  	}
>  
> -	if (!txn || !pmu->commit_txn(pmu))
> +	if (!pmu->commit_txn(pmu))
>  		return 0;
>  
>  group_error:
> @@ -699,8 +692,7 @@ group_error:
>  	}
>  	event_sched_out(group_event, cpuctx, ctx);
>  
> -	if (txn)
> -		pmu->cancel_txn(pmu);
> +	pmu->cancel_txn(pmu);
>  
>  	return -EAGAIN;
>  }
> @@ -4755,6 +4747,26 @@ static struct list_head pmus;
>  static DEFINE_MUTEX(pmus_lock);
>  static struct srcu_struct pmus_srcu;
>  
> +static void perf_pmu_nop(struct pmu *pmu)
> +{
> +}
> +
> +static void perf_pmu_start_txn(struct pmu *pmu)
> +{
> +	perf_pmu_disable(pmu);
> +}
> +
> +static int perf_pmu_commit_txn(struct pmu *pmu)
> +{
> +	perf_pmu_enable(pmu);
> +	return 0;
> +}
> +
> +static void perf_pmu_cancel_txn(struct pmu *pmu)
> +{
> +	perf_pmu_enable(pmu);


Did you mean disable here?

