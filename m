Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab0KTR6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 12:58:24 -0500
Received: from serrano.cc.columbia.edu ([128.59.29.6]:65080 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab0KTR6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 12:58:22 -0500
Date: Sat, 20 Nov 2010 12:58:07 -0500 (EST)
From: Oren Laadan <orenl@cs.columbia.edu>
X-X-Sender: orenl@takamine.ncl.cs.columbia.edu
To: Tejun Heo <tj@kernel.org>
cc: Kirill Korotaev <dev@parallels.com>, Kapil Arya <kapil@ccs.neu.edu>,
        Pavel Emelianov <xemul@parallels.com>,
        Gene Cooperman <gene@ccs.neu.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.osdl.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
In-Reply-To: <4CE698C5.5060806@kernel.org>
Message-ID: <Pine.LNX.4.64.1011201247090.15662@takamine.ncl.cs.columbia.edu>
References: <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org>
 <20101106053204.GB12449@count0.beaverton.ibm.com> <20101106204008.GA31077@sundance.ccs.neu.edu>
 <4CD5D99A.8000402@cs.columbia.edu> <20101107184927.GF31077@sundance.ccs.neu.edu>
 <4CD72150.9070705@cs.columbia.edu> <4CE3C334.9080401@kernel.org>
 <20101117153902.GA1155@hallyn.com> <4CE3F8D1.10003@kernel.org>
 <20101119041045.GC24031@hallyn.com> <4CE683E1.6010500@kernel.org>
 <04F4899E-B5C7-4BAF-8F2F-05D507A91408@parallels.com> <4CE698C5.5060806@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010, Tejun Heo wrote:

> Hello,
> 
> On 11/19/2010 03:36 PM, Kirill Korotaev wrote:
> > Can you imagine how many userland APIs are needed to make userspace C/R?
> > 
> > Do you really want APIs in user-space which allow to:
> > - send signals with siginfo attached (kill() doesn't work...)
> 
> Doesn't rt_sigqueueinfo() already do this?
> 

You assume that c/r is done by the checkpointed processes _themselves_,
that is that to checkpoint a process that process need to be made runnable 
and it will save its own state (which is the model of dmtcp, but not of
using ptrace). 

This model is restrictive: it requires that you hijack the execution of
that process somehow and make it run. What if the process isn't runnable
(e.g. in vfork waiting for completion, or ptraced deep in the kernel) ?
letting it run even just a bit may modify its state. It also means that
if you have many processes in the checkpointed session, e.g. 1000, then
_all_ of them will have to be scheduled to run !

With kernel c/r this is unnecessary:  you can use an auxiliary process
to checkpoint other processes without scheduling the other processes.
I.e. it's _transparent_ and _preemptive_.

Another advantage is that if anything fails during checkpoint (for 
whatever reason), there are no side-effects (which is not the case with
the other method).

> > For every small piece of functionality you will need to export ABI
> > and maintain it forever.  It's thousands of APIs! And why the hell
> > they are needed in user space at all?
> 
> I think it's actually quite the contrary.  Most things are already
> visible to userland.  They _have_ to be and that's the reason why
> userland implementation can already get most things working without
> any change to the kernel with some amount of hackery.  To me in-kernel
> CR seems to approach the problem from the exactly wrong direction -
> rather than dealing with specific exceptions, it create a completely
> new framework which is very foreign and not useful outside of CR.
> 
> Also, think about it.  Which one is better?  A kernel which can fully
> show its ABI visible states to userland or one which dumps its
> internal data structurs in binary blobs.  To me, the latter seems
> multiple orders of magnitude uglier.

Are we jusding aesteics ?  To me the former looks uglier...

The amount of fragile hacks you need to go through to make it work
in userspace for the generic cases (including userspace trickery
and new crazy APIs from the kernel for state that was never even an 
ABI, like skb's), and the restrictions it posses simply suggest that 
userspace is not the right place to do it. 

Thanks,

Oren.
