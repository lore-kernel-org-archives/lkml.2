Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab1JLU02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 16:26:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49267 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab1JLU01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 16:26:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=K40G/1bWxhEa4qmR45A001h9+8+LTTu4iEiV9ON1JkNyWmcCKRYfuXSZwlt3O/O/D
	nf6QEics8Z3Fe580aYNzg==
Date: Wed, 12 Oct 2011 13:26:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rik van Riel <riel@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Satoru Moriya <satoru.moriya@hds.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        "hughd@google.com" <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [PATCH -v2 -mm] add extra free kbytes tunable
In-Reply-To: <4E95F167.5050709@redhat.com>
Message-ID: <alpine.DEB.2.00.1110121322200.7646@chino.kir.corp.google.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com> <20110901100650.6d884589.rdunlap@xenotime.net> <20110901152650.7a63cb8b@annuminas.surriel.com> <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com> <20111010153723.6397924f.akpm@linux-foundation.org>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com> <20111011125419.2702b5dc.akpm@linux-foundation.org> <65795E11DBF1E645A09CEC7EAEE94B9CB516CBFE@USINDEVS02.corp.hds.com> <20111011135445.f580749b.akpm@linux-foundation.org> <4E95917D.3080507@redhat.com>
 <20111012122018.690bdf28.akpm@linux-foundation.org> <4E95F167.5050709@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011, Rik van Riel wrote:

> > > The problem is that we may be dealing with bursts, not steady
> > > states of allocations.  Without knowing the size of a burst,
> > > we have no idea when we should wake up kswapd to get enough
> > > memory freed ahead of the application's allocations.
> > 

Raising the priority of kswapd to be the highest possible when triggered 
by rt-tasks should help to reclaim memory faster.  If that doesn't work 
fully with Con's patch on Satoru's testcase then we'll want to extend it 
to raise the priority for a running kswapd when a higher priority thread 
calls into the page allocator slowpath.  If that also doesn't mitigate the 
problem entirely, then we'll need to suggest raising min_free_kbytes so 
these threads have a larger pool of exclusive access to memory when the 
burst first happens.

> > That problem remains with this patch - it just takes a larger burst.
> > 
> > Unless the admin somehow manages to configure the tunable large enough
> > to cover the largest burst, and there aren't other applications
> > allocating memory during that burst, and the time between bursts is
> > sufficient for kswapd to be able to sufficiently replenish free-page
> > reserves.  All of which sounds rather unlikely.
> 
> It depends on the system. For a setup which is packed to
> the brim with workloads, this patch is not likely to help.
> On the other hand, on a system that is packed to the brim
> with workloads, you are unlikely to get low latencies anyway.
> 
> For situations where people really care about low latencies,
> I imagine having dedicated hardware for a workload is not at
> all unusual, and the patch works for that.
> 

If it's dedicated hardware, then you should be able to just raise 
min_free_kbytes so that rt-tasks get exclusive access to a larger amount 
of memory.
