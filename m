Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab2FRIrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:47:21 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64191 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906Ab2FRIrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:47:18 -0400
Date: Mon, 18 Jun 2012 12:47:13 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
Message-ID: <20120618084713.GC1946@moon>
References: <20120613102823.373180763@linutronix.de>
 <20120613105815.206105518@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613105815.206105518@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 11:00:54AM -0000, Thomas Gleixner wrote:
> +
> +static int
> +__smpboot_create_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
> +{
> +	struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
> +	struct smpboot_thread_data *td;
> +
> +	if (tsk)
> +		return 0;
> +
> +	td = kzalloc_node(sizeof(*td), GFP_KERNEL, cpu_to_node(cpu));
> +	if (!td)
> +		return -ENOMEM;
> +	td->cpu = cpu;
> +	td->ht = ht;
> +
> +	tsk = kthread_create_on_cpu(ht->thread_fn, td, cpu, ht->thread_comm);
> +	if (IS_ERR(tsk))
> +		return PTR_ERR(tsk);
> +

Hi Thomas, I might be missing something obvious but will not we leak td
allocated here if kthread_create_on_cpu failed?

	Cyrill
