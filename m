Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827Ab2EOBk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:40:56 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34460 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964807Ab2EOBky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:40:54 -0400
Date: Mon, 14 May 2012 18:40:42 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org, rjw@sisk.pl,
        nacc@us.ibm.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 5/5] cpusets, suspend: Save and restore cpusets during
 suspend/resume
Message-ID: <20120515014042.GA9774@linux.vnet.ibm.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat>
 <20120513231710.3566.45349.stgit@srivatsabhat>
 <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com>
X-Operating-System: Linux 3.2.0-24-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051501-3270-0000-0000-0000065747C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.05.2012 [17:37:50 -0700], David Rientjes wrote:
> On Mon, 14 May 2012, Srivatsa S. Bhat wrote:
> 
> > diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> > index 0723183..671bf26 100644
> > --- a/kernel/cpuset.c
> > +++ b/kernel/cpuset.c
> > @@ -93,6 +93,13 @@ struct cpuset {
> >  
> >  	unsigned long flags;		/* "unsigned long" so bitops work */
> >  	cpumask_var_t cpus_allowed;	/* CPUs allowed to tasks in cpuset */
> > +
> > +	/*
> > +	 * used to save cpuset's cpus_allowed mask during suspend and restore
> > +	 * it during resume.
> > +	 */
> > +	cpumask_var_t suspend_cpus_allowed;
> > +
> >  	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
> >  
> >  	struct cpuset *parent;		/* my parent */
> 
> I see what you're doing with this and think it will fix the problem that 
> you're trying to address, but I think it could become much more general 
> to just the suspend case: if an admin sets a cpuset to have cpus 4-6, for 
> example, and cpu 5 goes offline, then I believe the cpuset should once 
> again become 4-6 if cpu 5 comes back online.  So I think this should be 
> implemented like mempolicies are which save the user intended nodemask 
> that may become restricted by cpuset placement but will be rebound if the 
> cpuset includes the intended nodes.

Heh, please read the thread at
http://marc.info/?l=linux-kernel&m=133615922717112&w=2 ... subject is
"[PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets handling
upon CPU hotplug". That was effectively the same solution Srivatsa
originally posted. But after lengthy discussions with PeterZ and others,
it was decided that suspend/resume is a special case where it makes
sense to save "policy" but that generally cpu/memory hotplug is a
destructive operation and nothing is required to be retained (that
certain policies are retained is unfortunately now expected, but isn't
guaranteed for cpusets, at least).

> If that's done, then it takes care of the suspend case as well and adds 
> generic cpu hotplug support, not just for suspend/resume.

Yeah ... but that's not the intent here (to add generic cpu hotplug
support).

Srivatsa, perhaps a reference to some summary of why it's not good to
support the general hotplug case would have been good in 0/5?

Thanks,
Nish


-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center

