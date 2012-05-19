Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117Ab2ESLTQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 07:19:16 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46809 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab2ESLTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 07:19:14 -0400
Date: Sat, 19 May 2012 13:19:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        pjt@google.com, cl@linux.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
Message-ID: <20120519111908.GC2012@gmail.com>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
 <4FB66756.2060302@redhat.com>
 <1337355341.573.68.camel@twins>
 <4FB66F5D.4020803@redhat.com>
 <1337357128.573.88.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337357128.573.88.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > > I very much believe in doing the simple thing first, and 
> > > this is that,
> > 
> > Leave out your syscalls (which might not be useful for 
> > managed runtimes), and you actually have the simple thing :)
> 
> Right, but the virt people could actually trivially use those, 
> and vnuma doesn't have the scambling issue outlined earlier 
> since the guest kernel would also try to keep home-node 
> affinity.
> 
> Avi already said patching kvm would be like 5 minutes work.

These APIs also match what user-space numa daemons started doing 
already.

> It also absolutely avoids the false sharing issue otherwise 
> present with per-cpu memory, since you explicitly tell it 
> where it belongs.

The grouping is also a natural extension to task and memory 
affinities and groups in general.

It also allows us to turn auto-migration off by default, which 
is a plus in my book. Without enough numbers I'm not convinced 
that we really *want* auto-discovery turned on all the time, for 
all workloads. The thing is, in practice most workloads that 
matter are short-run and even trivial forms of CPU migration 
doesnt ever happen for bursts of activity. We place them and 
that's it.

Managed runtimes on the other hand can be expected to know about 
and manage their locality - they do it anyway, by running guest 
scheduler(s). So this patch-set gives them the ability to 
express locality in a simple way, without the host kernel 
scanning actively.

We can auto-scan on top of this, if the numbers support it, but 
in the simple case where both the guest and the host is smart 
then simply expressing locality and telling each other is vastly 
superior to any scanning method.

Thanks,

	Ingo
