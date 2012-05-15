Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab2EOVhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:37:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab2EOVhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:37:19 -0400
Date: Tue, 15 May 2012 14:37:16 -0700 (PDT)
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
In-Reply-To: <1337116407.27694.118.camel@twins>
Message-ID: <alpine.DEB.2.00.1205151425260.1656@chino.kir.corp.google.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231710.3566.45349.stgit@srivatsabhat> <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com> <20120515014042.GA9774@linux.vnet.ibm.com> <alpine.DEB.2.00.1205142055160.10906@chino.kir.corp.google.com>
 <20120515044539.GA25256@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151106490.24304@chino.kir.corp.google.com> <1337112653.27694.110.camel@twins> <alpine.DEB.2.00.1205151346570.1656@chino.kir.corp.google.com> <1337116407.27694.118.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012, Peter Zijlstra wrote:

> > Not sure what you're disagreeing with, it only happens with 
> > MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES and I've clearly defined the 
> > behavior in the man page.  I personally never had a use-case for 
> > MPOL_F_RELATIVE_NODES but Paul Jackson asked that it be added for SGI when 
> > we added mempolicy mode flags. 
> 
> So what you're saying is that:
> 
> task t: set_mempolicy(,mask=2-3);
> 
> add t to cpuset A
> 
> A.mems = 0-1
> A.mems = 0-n
> 
> At which point t will again have 2-3, right?
> 

Depends on the mode which was omitted from your set_mempolicy().

When A.mems becomes 0-1, the task obviously also has a mempolicy of 0-1; 
for MPOL_F_STATIC_NODES, the resulting nodemask of (0-1) & (2-3) is empty 
so it falls back to the cpuset placement as required by the documentation, 
and without MPOL_F_STATIC_NODES the nodemask is remapped onto the new set 
which is also 0-1.

When A-mems is changed to 0-n, the task's mempolicy is either

 - 2-3 again (in n >= 3) with MPOL_F_STATIC_NODES, the flag that means we 
   really want these specific nodes when allowed, or

 - 0-1 still without MPOL_F_STATIC_NODES.

> Also, what does it mean to silently return to 2-3 after you've broken
> that promise by forcing it to 0-1 using cpusets?
> 

This obviously isn't the typical usecase and I doubt moving tasks to a 
cpuset with a disjoint set of allowed nodes ever happens in practice since 
cpusets is for NUMA optimizations and its being inappropriately moved 
around.  MPOL_F_STATIC_NODES is typically used when mems are removed from 
a cpuset and then subsequently added later.  Doing 
set_mempolicy(MPOL_INTERLEAVE, 0-3), attaching to cpuset.mems = 0-1, then 
cpuset.mems = 0-3, would result in an interleave over 0-1 before 
MPOL_F_STATIC_NODES was introduced.  With the flag, however, the mems 
becomes 0-3 once again.
