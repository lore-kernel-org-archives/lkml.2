Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab1JHDI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 23:08:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61045 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab1JHDIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 23:08:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=ydSqmwydzcgA7h9eoGiJ4vSFl+jE2qTerA+MmMx2BQW7r6g+7zbIM/xfEg5jCgSiY
	L849iED2iUtTNS7tcZRMQ==
Date: Fri, 7 Oct 2011 20:08:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rik van Riel <riel@redhat.com>
cc: Randy Dunlap <rdunlap@xenotime.net>, Satoru Moriya <smoriya@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, lwoodman@redhat.com,
        Seiji Aguchi <saguchi@redhat.com>, akpm@linux-foundation.org,
        hughd@google.com, hannes@cmpxchg.org
Subject: Re: [PATCH -v2 -mm] add extra free kbytes tunable
In-Reply-To: <20110901152650.7a63cb8b@annuminas.surriel.com>
Message-ID: <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com> <20110901100650.6d884589.rdunlap@xenotime.net> <20110901152650.7a63cb8b@annuminas.surriel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011, Rik van Riel wrote:

> Add a userspace visible knob to tell the VM to keep an extra amount
> of memory free, by increasing the gap between each zone's min and
> low watermarks.
> 
> This is useful for realtime applications that call system
> calls and have a bound on the number of allocations that happen
> in any short time period.  In this application, extra_free_kbytes
> would be left at an amount equal to or larger than than the
> maximum number of allocations that happen in any burst.
> 
> It may also be useful to reduce the memory use of virtual
> machines (temporarily?), in a way that does not cause memory
> fragmentation like ballooning does.
> 

I know this was merged into -mm, but I still have to disagree with it 
because I think it adds yet another userspace knob that will never be 
obsoleted, will be misinterepted, and is tied very closely to the 
implementation of page reclaim, both synchronous and asynchronous.  I also 
think that it will cause regressions on other cpu intensive workloads 
that don't require this extra freed memory because it works as a global 
heuristic and is not tied to any specific application.

I think it would be far better to reclaim beyond above the high watermark 
if the types of workloads that need this tunable can be somehow detected 
(the worst case scenario is being a prctl() that does synchronous reclaim 
above the watermark so admins can identify these workloads), or be able to 
mark allocations within the kernel as potentially coming in large bursts 
where allocation is problematic.
