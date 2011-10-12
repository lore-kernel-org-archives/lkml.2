Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab1JLBVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 21:21:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30091 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab1JLBVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 21:21:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=cQ/cHGU3OvYGMeuoPR25GDud5WKwrzhegTw3/r9lP3capezRO9E4W3dcQUcLNtZCG
	TcUB8SvwjY2l3iQ8laUhQ==
Date: Tue, 11 Oct 2011 18:20:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Tejun Heo <htejun@gmail.com>, Mike Galbraith <efault@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch] cpusets, cgroups: disallow attaching kthreadd
In-Reply-To: <1318342087.14615.5.camel@twins>
Message-ID: <alpine.DEB.2.00.1110111810500.10060@chino.kir.corp.google.com>
References: <1316758874.7393.2.camel@marge.simson.net> <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net> <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com> <1316770936.6641.11.camel@marge.simson.net>
 <1316775204.7562.9.camel@marge.simson.net> <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com> <1316788392.6544.33.camel@marge.simson.net> <1318224892.6161.45.camel@marge.simson.net> <1318233815.6527.5.camel@marge.simson.net> <20111010164339.GA8100@google.com>
 <1318342087.14615.5.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Oct 2011, Peter Zijlstra wrote:

> >  Maybe we need a flag to properly indicate "don't diddle with
> > this thread from userland"?  But, then, mainline kernel wouldn't need
> > the current PF_THREAD_BOUND at all.  Peter, Steven, what do you think?
> 
> Strict per-cpu affinity that is needed for correctness and disallows
> sched_setaffinity() is something entirely different from not being
> allowed to put something in a cgroup.
> 

Right, I introduced PF_THREAD_BOUND specifically so userspace could not 
change the set of allowed cpus of a kthread that has used kthread_bind() 
for specific affinity.  Any other kthread could set that flag directly to 
avoid the same tampering.

The flag was extended for cpusets to avoid having the same kthreads being 
moved out of the root cpuset since cpuset.cpus can be changed for all non-
root cpusets to be disjoint.  We wanted to avoid an inconsistency where 
threads attached to a cpuset had disjoint cpumasks; all threads attached 
to a cpuset should have cpumasks that are a subset of cpuset.cpus.

> As to not allowing to put in a cgroup thing, is there anything other
> than kthreadd for which we need to enforce that? So far I've mostly
> treated it like: root can do stupid things, this is one of them, don't
> do that then.
> 

Certainly the stop machine migration kthreads and per-cpu watchdog 
threads shouldn't be moved out of the root cpuset.  Both get 
PF_THREAD_BOUND from calling kthread_bind().
