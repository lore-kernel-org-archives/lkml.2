Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157Ab2EOEE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 00:04:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58244 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab2EOEEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 00:04:20 -0400
Date: Mon, 14 May 2012 21:04:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org, rjw@sisk.pl,
        nacc@us.ibm.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 5/5] cpusets, suspend: Save and restore cpusets during
 suspend/resume
In-Reply-To: <20120515014042.GA9774@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1205142055160.10906@chino.kir.corp.google.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231710.3566.45349.stgit@srivatsabhat> <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com> <20120515014042.GA9774@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Nishanth Aravamudan wrote:

> > I see what you're doing with this and think it will fix the problem that 
> > you're trying to address, but I think it could become much more general 
> > to just the suspend case: if an admin sets a cpuset to have cpus 4-6, for 
> > example, and cpu 5 goes offline, then I believe the cpuset should once 
> > again become 4-6 if cpu 5 comes back online.  So I think this should be 
> > implemented like mempolicies are which save the user intended nodemask 
> > that may become restricted by cpuset placement but will be rebound if the 
> > cpuset includes the intended nodes.
> 
> Heh, please read the thread at
> http://marc.info/?l=linux-kernel&m=133615922717112&w=2 ... subject is
> "[PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets handling
> upon CPU hotplug". That was effectively the same solution Srivatsa
> originally posted. But after lengthy discussions with PeterZ and others,
> it was decided that suspend/resume is a special case where it makes
> sense to save "policy" but that generally cpu/memory hotplug is a
> destructive operation and nothing is required to be retained (that
> certain policies are retained is unfortunately now expected, but isn't
> guaranteed for cpusets, at least).
> 

If you do set_mempolicy(MPOL_BIND, 2-3) to bind a thread to nodes 2-3 that 
is attached to a cpuset whereas cpuset.mems == 2-3, and then cpuset.mems 
changes to 0-1, what is the expected behavior?  Do we immediately oom on 
the next allocation?  If cpuset.mems is set again to 2-3, what's the 
desired behavior?

I fixed this problem by introducing MPOL_F_* flags in set_mempolicy(2) by 
saving the user intended nodemask passed by set_mempolicy() and respecting 
it whenever allowed by cpusets.

Right now, the behavior of what happens for a cpuset where cpuset.cpus == 
2-3 and then cpus 2-3 go offline and then are brought back online is 
undefined.  The same is true of cpuset.cpus during resume.  So if you're 
going to add a cpumask to struct cpuset, then why not respect it for all 
offline events and get rid of all this specialized suspend-only stuff?  
It's very simple to make this consistent across all cpu hotplug events and 
build suspend on top of it from a cpuset perspective.
