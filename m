Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab2EOAhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 20:37:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56049 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab2EOAhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 20:37:52 -0400
Date: Mon, 14 May 2012 17:37:50 -0700 (PDT)
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
Subject: Re: [PATCH v3 5/5] cpusets, suspend: Save and restore cpusets during
 suspend/resume
In-Reply-To: <20120513231710.3566.45349.stgit@srivatsabhat>
Message-ID: <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231710.3566.45349.stgit@srivatsabhat>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Srivatsa S. Bhat wrote:

> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 0723183..671bf26 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -93,6 +93,13 @@ struct cpuset {
>  
>  	unsigned long flags;		/* "unsigned long" so bitops work */
>  	cpumask_var_t cpus_allowed;	/* CPUs allowed to tasks in cpuset */
> +
> +	/*
> +	 * used to save cpuset's cpus_allowed mask during suspend and restore
> +	 * it during resume.
> +	 */
> +	cpumask_var_t suspend_cpus_allowed;
> +
>  	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
>  
>  	struct cpuset *parent;		/* my parent */

I see what you're doing with this and think it will fix the problem that 
you're trying to address, but I think it could become much more general 
to just the suspend case: if an admin sets a cpuset to have cpus 4-6, for 
example, and cpu 5 goes offline, then I believe the cpuset should once 
again become 4-6 if cpu 5 comes back online.  So I think this should be 
implemented like mempolicies are which save the user intended nodemask 
that may become restricted by cpuset placement but will be rebound if the 
cpuset includes the intended nodes.

If that's done, then it takes care of the suspend case as well and adds 
generic cpu hotplug support, not just for suspend/resume.
