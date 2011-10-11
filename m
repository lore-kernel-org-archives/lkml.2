Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab1JKVFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 17:05:00 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44037 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1JKVE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 17:04:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=RUDnhY1ec1VJzDX+6VK3mri7gTl4C3h8QlZHKgLYiDOUMFI1R9FhD+QJoQRnSdcXy
	bNJDwrfSxMQwZmC6cgLag==
Date: Tue, 11 Oct 2011 14:04:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Satoru Moriya <satoru.moriya@hds.com>
cc: Rik van Riel <riel@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: RE: [PATCH -v2 -mm] add extra free kbytes tunable
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9CB516CBBC@USINDEVS02.corp.hds.com>
Message-ID: <alpine.DEB.2.00.1110111343070.29761@chino.kir.corp.google.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com> <20110901100650.6d884589.rdunlap@xenotime.net> <20110901152650.7a63cb8b@annuminas.surriel.com> <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516CBBC@USINDEVS02.corp.hds.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Oct 2011, Satoru Moriya wrote:

> > I also
> > think that it will cause regressions on other cpu intensive workloads 
> > that don't require this extra freed memory because it works as a 
> > global heuristic and is not tied to any specific application.
> 
> It's yes and no. It may cause regressions on the workloads due to
> less amount of available memory. But it may improve the workloads'
> performance because they can avoid direct reclaim due to extra
> free memory.
> 

There's only a memory-availability regression if background reclaim is 
actually triggered in the first place, i.e. extra_free_kbytes doesn't 
affect the watermarks themselves when reclaim is started but rather causes 
it to, when set, reclaim more memory than otherwise.

That's not really what I was referring to; I was referring to cpu 
intensive workloads that now incur a regression because kswapd is now 
doing more work (potentially a significant amount of work since 
extra_free_kbytes is unbounded) on shared machines.  These applications 
may not be allocating memory at all and now they incur a performance 
penalty because kswapd is taking away one of their cores.

In other words, I think it's a fine solution if you're running a single 
application with very bursty memory allocations so you need to reclaim 
more memory when low, but that solution is troublesome if it comes at 
the penalty of other applications and that's a direct consequence of it 
being a global tunable.  I'd much rather identify memory allocations in 
the kernel that causing the pain here and mitigate it by (i) attempting to 
sanely rate limit those allocations, (ii) preallocate at least a partial 
amount of those allocations ahead of time so avoid significant reclaim 
all at one, or (iii) annotate memory allocations with such potential so 
that the page allocator can add this reclaim bonus itself only in these 
conditions.

> Of course if one doesn't need extra free memory, one can turn it
> off. I think we can add this feature to cgroup if we want to set
> it for any specific process or process group. (Before that we
> need to implement min_free_kbytes for cgroup and the implementation
> of extra free kbytes strongly depends on it.)
> 

That would allow you to only reclaim additional memory when certain 
applications tirgger it, but it's not actually a solution since another 
task can hit a zone's low watermark and kick kswapd and then the bursty 
memory allocations happen immediately following that and doesn't actually 
do anything because kswapd was already running.  So I disagree, as I did 
when per-cgroup watermark tunables were proposed, that watermarks should 
be changed for a subset of applications unless you guarantee memory 
isolation such that that subset of applications has exclusive access to 
the memory zones being tuned.
