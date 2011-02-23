Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1BWDJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 22:09:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60521 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab1BWDJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 22:09:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j128buAcPX56EA+PXZKJDQohbGbcFRjoJpGvqKZejK7uI8wZcm4Nj5F8NvuTQxVqSF
         GCzIRlk22iYPYgbGm3LTkeB/R2ofzzyToXbqVZfeydMuS9W4e/7FcAftsGBkxbHqnEBt
         8X+R65FMlAIf+POiPniDunDQBCKY5MQaIHJUI=
Date: Wed, 23 Feb 2011 04:09:43 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
Message-ID: <20110223030940.GB5809@nowhere>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 05:39:40PM -0800, Paul E. McKenney wrote:
> +/*
> + * Set the per-rcu_node kthread's affinity to cover all CPUs that are
> + * served by the rcu_node in question.
> + */
> +static void rcu_node_kthread_setaffinity(struct rcu_node *rnp)
> +{
> +	cpumask_var_t cm;
> +	int cpu;
> +	unsigned long mask = rnp->qsmaskinit;
> +
> +	if (rnp->node_kthread_task == NULL ||
> +	    rnp->qsmaskinit == 0)
> +		return;
> +	if (!alloc_cpumask_var(&cm, GFP_KERNEL))
> +		return;
> +	cpumask_clear(cm);
> +	for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask <<= 1)

There seem to be the same shift problem here.

> +		if (mask & 01)
> +			cpumask_set_cpu(cpu, cm);
> +	set_cpus_allowed_ptr(rnp->node_kthread_task, cm);
> +	free_cpumask_var(cm);
> +}
