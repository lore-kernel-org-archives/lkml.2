Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966852Ab2EOVFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:05:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52328 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966817Ab2EOVF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:05:28 -0400
Date: Tue, 15 May 2012 14:05:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        mingo@kernel.org, pjt@google.com, paul@paulmenage.org,
        akpm@linux-foundation.org, rjw@sisk.pl, nacc@us.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 5/5] cpusets, suspend: Save and restore cpusets during
 suspend/resume
In-Reply-To: <1337112653.27694.110.camel@twins>
Message-ID: <alpine.DEB.2.00.1205151346570.1656@chino.kir.corp.google.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231710.3566.45349.stgit@srivatsabhat> <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com> <20120515014042.GA9774@linux.vnet.ibm.com> <alpine.DEB.2.00.1205142055160.10906@chino.kir.corp.google.com>
 <20120515044539.GA25256@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151106490.24304@chino.kir.corp.google.com> <1337112653.27694.110.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012, Peter Zijlstra wrote:

> > However, if a thread did set_mempolicy(MPOL_BIND, 2-3) where cpuset.mems 
> > == node_online_map, cpuset.mems changes to 0-1, then cpuset.mems changes 
> > back to node_online_map, then I believe (and implemented in the mempolicy 
> > code and added the specification in the man page) that the thread should 
> > be bound to nodes 2-3.
> 
> I disagree, but alas that is done :-(
> 

Not sure what you're disagreeing with, it only happens with 
MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES and I've clearly defined the 
behavior in the man page.  I personally never had a use-case for 
MPOL_F_RELATIVE_NODES but Paul Jackson asked that it be added for SGI when 
we added mempolicy mode flags.

> But what happens if you unplug nodes 2-3?
> 

Mempolicies lack hotplug notifiers entirely so it falls back to no policy 
at allocation time, the rebinding of nodes in the context of cpusets only 
occurs when cpuset.mems changes, not with hotplug.

> The problem is that if you have some cpusets configuration and then do a
> s/r cycle the entire configuration is wrecked because suspend
> hot-unplugs all but cpu0 and resume re-plugs the cpus.
> 
> This destroys all masks and migrates all tasks in sets not including
> cpu0 to the root set.
> 

Yup.

> Srivatsa proposed to 'fix' this by remembering state of regular hotplug,
> to which I strongly oppose, hotplug is destructive and should be,
> there's no point in remembering state that might never be used again.
> Worse you temporarily 'break' your cpuset 'promise' to then silently
> restore it.
> 
> The s/r resume case is special in that userspace isn't actually around
> to observe the cpus going away and coming back, also it has the
> guarantee the cpus will be coming back.
> 
> So s/r is special and should not destroy state, hotplug should.
> 

Why can't we leave cpuset.cpus unaltered for all cpusets during suspend?  
Having a cpu set in cpuset.cpus does not mean the attached threads are 
allowed to run on all of them.
