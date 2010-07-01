Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab0GAPmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:42:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56090 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab0GAPmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:42:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GlYj4NJ8bkn9LIQYEtG/1WUcZv1I7w0eX/9t4Ia9L48v+RYJglCy2rxkFt2SSR+qGU
         vo8AlPaDP+vIppaZQsqoXGKESSs+2xEhzTrx8N920SvjRjb4bn/Ffo3L8BA+nWnMBeCW
         DH4Z1hj7s76xSh94tKvcIzE/h9dMS8p5awlEw=
Date: Thu, 1 Jul 2010 17:42:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       David Miller <davem@davemloft.net>, Borislav Petkov <bp@amd64.org>
Subject: Re: [RFC PATCH 5/6] perf: Fix race in callchains
Message-ID: <20100701154232.GA10616@nowhere>
References: <1277998562-21366-1-git-send-regression-fweisbec@gmail.com> <1277998562-21366-6-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277998562-21366-6-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 05:36:01PM +0200, Frederic Weisbecker wrote:
> +static struct perf_callchain_entry *get_callchain_entry(int *rctx)
> +{
> +	struct perf_callchain_entry_cpus *cpu_entries;
> +
> +	*rctx = get_recursion_context(&__get_cpu_var(callchain_recursion));
> +	if (*rctx == -1)
> +		return NULL;
> +
> +	cpu_entries = rcu_dereference(callchain_entries[*rctx]);
> +	if (!cpu_entries)
> +		return NULL;
> +
> +	return this_cpu_ptr(cpu_entries->entries);
> +}
> +
> +static void
> +put_callchain_entry(int rctx)
> +{
> +	put_recursion_context(&__get_cpu_var(callchain_recursion), rctx);
> +}
> +
> +static struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
> +{
> +	int rctx;
> +	struct perf_callchain_entry *entry;
> +
> +
> +	entry = get_callchain_entry(&rctx);
> +	if (!entry)
> +		goto exit_put;


I realize this should only call put_callchain_entry() if rctx == -1, but you
got the idea...



> +
> +	entry->nr = 0;
> +
> +	if (!user_mode(regs)) {
> +		perf_callchain_store(entry, PERF_CONTEXT_KERNEL);
> +		perf_callchain_kernel(entry, regs);
> +		if (current->mm)
> +			regs = task_pt_regs(current);
> +		else
> +			regs = NULL;
> +	}
> +
> +	if (regs) {
> +		perf_callchain_store(entry, PERF_CONTEXT_USER);
> +		perf_callchain_user(entry, regs);
> +	}
> +
> +exit_put:
> +	put_callchain_entry(rctx);
> +
> +	return entry;
> +}

