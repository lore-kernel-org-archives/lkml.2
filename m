Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966367Ab2EOWcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 18:32:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36934 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965977Ab2EOWcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 18:32:06 -0400
Date: Tue, 15 May 2012 15:32:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, tj@kernel.org,
        mschmidt@redhat.com, berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 5/5] cpusets, suspend: Save and restore cpusets during
 suspend/resume
In-Reply-To: <4FB2D5CB.6090209@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1205151527220.25449@chino.kir.corp.google.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231710.3566.45349.stgit@srivatsabhat> <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com> <20120515014042.GA9774@linux.vnet.ibm.com> <alpine.DEB.2.00.1205142055160.10906@chino.kir.corp.google.com>
 <20120515044539.GA25256@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151106490.24304@chino.kir.corp.google.com> <1337112653.27694.110.camel@twins> <alpine.DEB.2.00.1205151346570.1656@chino.kir.corp.google.com> <1337116107.27694.114.camel@twins>
 <alpine.DEB.2.00.1205151414210.1656@chino.kir.corp.google.com> <4FB2CDAD.4020306@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151444260.1656@chino.kir.corp.google.com> <4FB2D5CB.6090209@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012, Srivatsa S. Bhat wrote:

> >  I know root is special 
> > cased all over the cpuset code, but I think the real fix here is to figure 
> > out why it can't be left as a superset and then we end up doing nothing 
> > for s/r.
> > 
> > I don't have a preference for cpu hotplug and whether cpuset.cpus = 1-3 
> > remains 1-3 when cpu 2 is offlined or not, I think it could be argued both 
> > ways, but I disagree with saving the cpumask, removing all suspended cpus, 
> > and then reinstating it for no reason.
> > 
> 
> I think there is a valid reason behind doing that.
> 
> Cpusets translates to sched domains in scheduler terms. So whenever you update
> cpusets, the sched domains are updated. IOW, if you don't touch cpusets during
> hotplug (suspend/resume case), you allow them to have offline cpus, meaning,
> you allow sched domains to have offline cpus. Hence sched domains are rendered
> stale.
> 

It's not possible to update the sched domains for s/r to be a subset of 
cpuset.cpus?  It would be the same situation for a thread using 
sched_setaffinity() while bound to a cpuset with a superset of allowed 
nodes.  If you do that, there's no reason to alter cpuset.cpus at all and 
you don't need to carry another cpumask around for each cpuset.
