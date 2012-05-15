Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab2EOVtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:49:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57894 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696Ab2EOVtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:49:50 -0400
Date: Tue, 15 May 2012 14:49:47 -0700 (PDT)
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
In-Reply-To: <4FB2CDAD.4020306@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1205151444260.1656@chino.kir.corp.google.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231710.3566.45349.stgit@srivatsabhat> <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com> <20120515014042.GA9774@linux.vnet.ibm.com> <alpine.DEB.2.00.1205142055160.10906@chino.kir.corp.google.com>
 <20120515044539.GA25256@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151106490.24304@chino.kir.corp.google.com> <1337112653.27694.110.camel@twins> <alpine.DEB.2.00.1205151346570.1656@chino.kir.corp.google.com> <1337116107.27694.114.camel@twins>
 <alpine.DEB.2.00.1205151414210.1656@chino.kir.corp.google.com> <4FB2CDAD.4020306@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012, Srivatsa S. Bhat wrote:

> What you are suggesting was precisely the v1 of this patchset, which went
> upstream as commit 8f2f748b06562 (CPU hotplug, cpusets, suspend: Don't touch
> cpusets during suspend/resume).
> 
> It got reverted due to a nasty suspend hang in some corner case, where the
> sched domains not being up-to-date got the scheduler confused.
> Here is the thread with that discussion:
> http://thread.gmane.org/gmane.linux.kernel/1262802/focus=1286289
> 
> As Peter suggested, I'll try to fix the issues at the 2 places that I found
> where the scheduler gets confused despite the cpu_active mask being up-to-date.
> 
> But, I really want to avoid that scheduler fix and this cpuset fix from
> being tied together, for the fear that until we root-cause and fix all
> scheduler bugs related to cpu_active mask, we can never get cpusets fixed
> once and for all for suspend/resume. So, this patchset does an explicit
> save and restore to be sure, and so that we don't depend on some other/unknown
> factors to make this work reliably.
> 

Ok, so it seems like this is papering over an existing cpusets issue or an 
interaction with the scheduler that is buggy.  There's no reason why a 
cpuset.cpus that is a superset of cpu_active_mask should cause an issue 
since that's exactly what the root cpuset has.  I know root is special 
cased all over the cpuset code, but I think the real fix here is to figure 
out why it can't be left as a superset and then we end up doing nothing 
for s/r.

I don't have a preference for cpu hotplug and whether cpuset.cpus = 1-3 
remains 1-3 when cpu 2 is offlined or not, I think it could be argued both 
ways, but I disagree with saving the cpumask, removing all suspended cpus, 
and then reinstating it for no reason.
