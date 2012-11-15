Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992583Ab2KOD76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 22:59:58 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65348 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992498Ab2KOD7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 22:59:55 -0500
Date: Wed, 14 Nov 2012 19:59:52 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Anton Vorontsov <cbouatmailru@gmail.com>
cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: Re: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
In-Reply-To: <20121115033932.GA15546@lizard.sbx05977.paloaca.wayport.net>
Message-ID: <alpine.DEB.2.00.1211141946370.14414@chino.kir.corp.google.com>
References: <20121107105348.GA25549@lizard> <20121107112136.GA31715@shutemov.name> <CAOJsxLHY+3ZzGuGX=4o1pLfhRqjkKaEMyhX0ejB5nVrDvOWXNA@mail.gmail.com> <20121107114321.GA32265@shutemov.name> <alpine.DEB.2.00.1211141910050.14414@chino.kir.corp.google.com>
 <20121115033932.GA15546@lizard.sbx05977.paloaca.wayport.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Anton Vorontsov wrote:

> > I agree that eventfd is the way to go, but I'll also add that this feature 
> > seems to be implemented at a far too coarse of level.  Memory, and hence 
> > memory pressure, is constrained by several factors other than just the 
> > amount of physical RAM which vmpressure_fd is addressing.  What about 
> > memory pressure caused by cpusets or mempolicies?  (Memcg has its own 
> > reclaim logic
> 
> Yes, sure, and my plan for per-cgroups vmpressure was to just add the same
> hooks into cgroups reclaim logic (as far as I understand, we can use the
> same scanned/reclaimed ratio + reclaimer priority to determine the
> pressure).
> 

I don't understand, how would this work with cpusets, for example, with 
vmpressure_fd as defined?  The cpuset policy is embedded in the page 
allocator and skips over zones that are not allowed when trying to find a 
page of the specified order.  Imagine a cpuset bound to a single node that 
is under severe memory pressure.  The reclaim logic will get triggered and 
cause a notification on your fd when the rest of the system's nodes may 
have tons of memory available.  So now an application that actually is 
using this interface and is trying to be a good kernel citizen decides to 
free caches back to the kernel, start ratelimiting, etc, when it actually 
doesn't have any memory allocated on the nearly-oom cpuset so its memory 
freeing doesn't actually achieve anything.

Rather, I think it's much better to be notified when an individual process 
invokes various levels of reclaim up to and including the oom killer so 
that we know the context that memory freeing needs to happen (or, 
optionally, the set of processes that could be sacrificed so that this 
higher priority process may allocate memory).

> > and its own memory thresholds implemented on top of eventfd 
> > that people already use.)  These both cause high levels of reclaim within 
> > the page allocator whereas there may be an abundance of free memory 
> > available on the system.
> 
> Yes, surely global-level vmpressure should be separate for the per-cgroup
> memory pressure.
> 

I disagree, I think if you have a per-thread memory pressure notification 
if and when it starts down the page allocator slowpath, through the 
various states of reclaim (perhaps on a scale of 0-100 as described), and 
including the oom killer that you can target eventual memory freeing that 
actually is useful.

> But we still want the "global vmpressure" thing, so that we could use it
> without cgroups too. How to do it -- syscall or sysfs+eventfd doesn't
> matter much (in the sense that I can do eventfd thing if you folks like it
> :).
> 

Most processes aren't going to care if they are running into memory 
pressure and have no implementation to free memory back to the kernel or 
start ratelimiting themselves.  They will just continue happily along 
until they get the memory they want or they get oom killed.  The ones that 
do, however, or a job scheduler or monitor that is watching over the 
memory usage of a set of tasks, will be able to do something when 
notified.

In the hopes of a single API that can do all this and not a 
reimplementation for various types of memory limitations (it seems like 
what you're suggesting is at least three different APIs: system-wide via 
vmpressure_fd, memcg via memcg thresholds, and cpusets through an eventual 
cpuset threshold), I'm hoping that we can have a single interface that can 
be polled on to determine when individual processes are encountering 
memory pressure.  And if I'm not running in your oom cpuset, I don't care 
about your memory pressure.
