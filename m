Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab0FPREE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 13:04:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39736 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759055Ab0FPREB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 13:04:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rpt7DVaHt/tSg3AYvjig+L8pU6cn5ZeeLjvXZgbV35PM1ZctG0NM8Yzz6pKWPTQLNN
         iCaQZQHG4OXFlQogvosnDE3PBOyiC2bo4+D6d7cnc0Dz867a1f0wsQKMdmf+bcf29mCu
         SxgMogZEtSfuqTYR1g0DP8h8m3blm4W/4LyZg=
Date: Wed, 16 Jun 2010 19:03:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 3/8] perf: register pmu implementations
Message-ID: <20100616170354.GA5530@nowhere>
References: <20100616160027.590430763@chello.nl> <20100616160238.241599593@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616160238.241599593@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 06:00:30PM +0200, Peter Zijlstra wrote:
> +static void bp_perf_event_destroy(struct perf_event *event)
> +{
> +	release_bp_slot(event);
> +}
> +
> +static struct pmu *bp_perf_event_init(struct perf_event *bp)
> +{
> +	int err;
> +
> +	if (event->attr.type != PERF_TYPE_BREAKPOINT)
> +		return -ENOENT;
> +
> +	err = register_perf_hw_breakpoint(bp);
> +	if (err)
> +		return err;
> +
> +	bp->destroy = bp_perf_event_destroy;
> +
> +	return 0;
> +}
> +
> +static struct pmu perf_breakpoint = {
> +	.event_init	= hw_breakpoint_event_init,



Should be bp_perf_event_init?



> +	.enable		= arch_install_hw_breakpoint,
> +	.disable	= arch_uninstall_hw_breakpoint,
> +	.read		= hw_breakpoint_pmu_read,
> +};
<snip>
> +static int perf_swevent_int(struct perf_event *event)
> +{
> +	if (event->attr.type != PERF_TYPE_SOFTWARE)
> +		return -ENOENT


perf_swevent_init() ?



> +int perf_pmu_register(struct pmu *pmu)
> +{
> +	spin_lock(&pmus_lock);
> +	list_add_rcu(&pmu->entry, &pmus);
> +	spin_unlock(&pmus_lock);
> +
> +	return 0;
> +}
> +
> +void perf_pmu_unregister(struct pmu *pmu)
> +{
> +	spin_lock(&pmus_lock);
> +	list_del_rcu(&pmu->entry);
> +	spin_unlock(&pmus_lock);
> +
> +	synchronize_srcu(&pmus_srcu);
> +}



Who needs this?



> +
> +struct pmu *perf_init_event(struct perf_event *event)
> +{
> +	struct pmu *pmu;
> +	int idx;
> +
> +	idx = srcu_read_lock(&pmus_srcu);
> +	list_for_each_entry_rcu(pmu, &pmus, entry) {
> +		int ret = pmu->event_init(event);
> +		if (!ret)
> +			break;
> +		if (ret != -ENOENT) {
> +			pmu = ERR_PTR(ret);
> +			break;
>  		}
> -		pmu = &perf_ops_generic;
> -		break;
>  	}
> +	srcu_read_unlock(&pmus_srcu, idx);



This could use a simple mutex instead of a spinlock + srcu_sync on
writer and srcu on reader.

That doesn't matter much that said. What I don't understand is
why we need to synchronize the writers. Walking the list with
list_*_rcu() looks justified once we support boot events, but
until then...


For the rest of the patch, the whole idea is nice.

