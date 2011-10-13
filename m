Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab1JMUsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:48:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:27759 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab1JMUsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:48:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=ED+VUH2eezU4rr9LMuRW3L7l/5iqSmMq/7WLs3FERh1dh3L+fQEPgRvZrAzoMbh0g
	662PCB7wS1ZAkTbcjihyQ==
Date: Thu, 13 Oct 2011 13:48:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Satoru Moriya <satoru.moriya@hds.com>
cc: Con Kolivas <kernel@kolivas.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, Hugh Dickins <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: RE: [PATCH -v2 -mm] add extra free kbytes tunable
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9CB516D459@USINDEVS02.corp.hds.com>
Message-ID: <alpine.DEB.2.00.1110131337580.24853@chino.kir.corp.google.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com> <20110901100650.6d884589.rdunlap@xenotime.net> <20110901152650.7a63cb8b@annuminas.surriel.com> <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com> <20111010153723.6397924f.akpm@linux-foundation.org>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com> <alpine.DEB.2.00.1110111612120.5236@chino.kir.corp.google.com> <65795E11DBF1E645A09CEC7EAEE94B9CB516D459@USINDEVS02.corp.hds.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Satoru Moriya wrote:

> My test case is just a simple one (maybe too simple), and I tried
> to demonstrate following issues that current kernel has with it.
> 
> 1. Current kernel uses free memory as pagecache.
> 2. Applications may allocate memory burstly and when it happens
>    they may get a latency issue because there are not enough free
>    memory. Also the amount of required memory is wide-ranging.

This is what the per-zone watermarks are intended to address and I 
understand that it's not doing a good enough job for your particular 
workloads.  I'm trying to find a solution that mitigates that for all 
threads that allocate faster than the kernel can reclaim, realtime or 
otherwise, without requiring the admin to set those watermarks himself, 
which is really what extra_free_kbytes is eventually leading to.

> 3. Some users would like to control the amount of free memory
>    to avoid the situation above.

The only possible way to do that is with min_free_kbytes right now and 
that would increase the amount of memory that realtime threads have 
exclusive access to.  Let's try not to add additional tunables so that 
admins need to find their own optimal watermarks for every kernel release.  
I see no reason why we can't add logic for rt-threads triggering reclaim 
to either reclaim faster (Con's patch) or more memory than normal (an 
ALLOC_HARDER type bonus in the reclaim path to reclaim 1.25 * high_wmark, 
for example).  We've had a rt-thread bonus in the page allocator for a 
long time, I'm not saying we don't need more elsewhere.

> 4. User can't setup the amount of free memory explicitly.
>    From user's point of view, the amount of free memory is the delta
>    between high watermark - min watermark because below min watermark
>    user applications incur a penalty (direct reclaim). The width of
>    delta depends on min_free_kbytes, actually min watermark / 2, and
>    so if we want to make free memory bigger, we must make
>    min_free_kbytes bigger. It's not a intuitive and it introduces
>    another problem that is possibility of direct reclaim is increased.
> 

So you're saying that we need to increase the space between high_wmark and 
min_wmark anytime that min_free_kbytes changes?  That certainly may be 
true and would hopefully mitigate direct reclaim becoming too intrusive 
for your workload.

We _really_ don't want to cause regressions for others, though, which 
extra_free_kbytes can easily do for cpu-intensive workloads if nothing is 
currently requiring that extra burst of memory (and occurs because 
extra_free_kbytes is a global tunable and not tied to any specific 
application [like testing for rt_task()] that we can identify when 
reclaiming).

> But my concern described above is still alive because whether
> latency issue happen or not depends on how heavily workloads
> allocate memory at a short time. Of cource we can say same
> things for extra_free_kbytes, but we can change it and test
> an effect easily.
> 

We'll never know the future and how much memory a latency-sensitive 
application will require 100ms from now.  The only thing that we can do is 
(i) identify the latency-sensitive app, (ii) reclaim more aggressively for 
them, and (iii) reclaim additional memory in preparation for another 
burst.  At some point, though, userspace needs to be responsible to not 
allocate enormous amounts of memory all at once and there's room for 
mitigation there too to preallocate ahead of what you actually need.
