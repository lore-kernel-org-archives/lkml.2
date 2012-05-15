Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab2EOADw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 20:03:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56170 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758277Ab2EOADu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 20:03:50 -0400
Date: Mon, 14 May 2012 17:03:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org, rjw@sisk.pl,
        nacc@us.ibm.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 1/5] cpusets, hotplug: Implement cpuset tree traversal
 in a helper function
In-Reply-To: <20120513231449.3566.70799.stgit@srivatsabhat>
Message-ID: <alpine.DEB.2.00.1205141700480.25235@chino.kir.corp.google.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231449.3566.70799.stgit@srivatsabhat>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Srivatsa S. Bhat wrote:

> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 14f7070..23e5da6 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -2000,6 +2000,23 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
>  	move_member_tasks_to_cpuset(cs, parent);
>  }
>  
> +static struct cpuset *traverse_cpusets(struct list_head *queue)

I suggest a different name for this, traverse_cpusets() doesn't imply that 
it will be returning struct cpuset *.

> +{
> +	struct cpuset *cp;
> +	struct cpuset *child;	/* scans child cpusets of cp */
> +	struct cgroup *cont;
> +
> +	cp = list_first_entry(queue, struct cpuset, stack_list);
> +	list_del(queue->next);
> +	list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
> +		child = cgroup_cs(cont);
> +		list_add_tail(&child->stack_list, queue);
> +	}
> +
> +	return cp;

Eek, what happens if queue is empty?  It can't happen with only this 
patch applied, but since you're doing this to be used in other places then 
you'd need to check for list_empty().

> +}
> +
> +
>  /*
>   * Walk the specified cpuset subtree and look for empty cpusets.
>   * The tasks of such cpuset must be moved to a parent cpuset.
> @@ -2019,19 +2036,12 @@ static void scan_for_empty_cpusets(struct cpuset *root)
>  {
>  	LIST_HEAD(queue);
>  	struct cpuset *cp;	/* scans cpusets being updated */
> -	struct cpuset *child;	/* scans child cpusets of cp */
> -	struct cgroup *cont;
>  	static nodemask_t oldmems;	/* protected by cgroup_mutex */
>  
>  	list_add_tail((struct list_head *)&root->stack_list, &queue);
>  
>  	while (!list_empty(&queue)) {
> -		cp = list_first_entry(&queue, struct cpuset, stack_list);
> -		list_del(queue.next);
> -		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
> -			child = cgroup_cs(cont);
> -			list_add_tail(&child->stack_list, &queue);
> -		}
> +		cp = traverse_cpusets(&queue);
>  
>  		/* Continue past cpusets with all cpus, mems online */
>  		if (cpumask_subset(cp->cpus_allowed, cpu_active_mask) &&

Otherwise, looks good.
