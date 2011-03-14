Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab1CNBBM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 21:01:12 -0400
Received: from mout.perfora.net ([74.208.4.195]:53463 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873Ab1CNBBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 21:01:07 -0400
Date: Sun, 13 Mar 2011 20:59:48 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Kees Cook <kees.cook@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] proc: make check_mem_permission() return an
	mm_struct on success
Message-ID: <20110314005948.GA28037@fibrous.localdomain>
References: <1300045764-24168-1-git-send-email-wilsons@start.ca> <1300045764-24168-12-git-send-email-wilsons@start.ca> <20110314000859.GF21770@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314000859.GF21770@outflux.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:7FEly5jmjXLwAC5LrRdNH7aC8whT+PvPEicFpOrsRY0
 kqB9N+fta1kVkf8pSNLgU0HT0hONjsxHnF5ej8ZDZ2Z1f3IAaR
 qfGqyQg1AHqK2VZgIQUCILHfklvNiYQSkexKR4pG2peB9U43Uy
 J7FpljDJe3Yk8oaVBMWo5zna8UkN4D7hQ6NB2M3nujQCwcQoBC
 GpDSaAJ/mgmjLlPsbr0XZoCAPdarQsnnyIhC7wkEY4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, Mar 13, 2011 at 05:08:59PM -0700, Kees Cook wrote:
> On Sun, Mar 13, 2011 at 03:49:23PM -0400, Stephen Wilson wrote:
> >  	copied = -EIO;
> >  	if (file->private_data != (void *)((long)current->self_exec_id))
> > -		goto out;
> > +		goto out_mm;
> 
> The file->private_data test seems wrong to me. Is there a case were the mm
> returned from check_mem_permission(task) can refer to something that is no
> longer attached to task?
> 
> For example:
> - pid 100 ptraces pid 200
> - pid 100 opens /proc/200/mem
> - pid 200 execs into something else

If the _target_ task (pid 200) execs then we are OK -- we hold a
reference to the *old* mm and it is that to which we read and write via
access_remote_vm().

In the case of the file->private_data test we are looking at the
*ptracer* (pid 100).  Here we are guarding against the case where the
tracer exec's and accidentally leaks the fd (hence the test wrt
current).  IOW, /proc/pid/mem is implicitly close on exec.  This is just
a minor feature to protect against buggy user space reading/writing
mistakenly into the targets address space.

> only after passing check_mem_permission(task) again. This is stopped
> by the private_data test. But should it, since check_mem_permission()
> passed?

No.  I hope the above clears that up.

> Even if it does mean to block it, it's insufficient since pid 200
> could just exec u32 many times and align with the original private_data
> value. 

Just for clarity, in your example it would be pid 100 that would need to
exec many times.  And yes, I think it would be possible for pid 100 to
exec() N times before the next call to mem_read/mem_write and thus
subvert this check.

Perhaps we can improve things (I would need to look into how O_CLOEXEC
is implemented), however please note that the primary rationale here is
to protect against bugs:  the tracer already has the needed privilege,
and it would be silly for it to exec N times just to pass the fd out
across an exec().


> What is that test trying to do? And I'm curious for both mem_write
> as well as the existing mem_read use of the test, since I'd like to see
> a general solution to the "invalidate /proc fds across exec" so we can
> close CVE-2011-1020 for everything[1].

These patches certainly do not add to the problem -- but they do not try
to address the general issue either.

> Associated with this, the drop of check_mem_permission(task) during the
> mem_read loop implies that the mm is locked during that loop and seems to
> reflect what you're saying ("Holding a reference to the target mm_struct
> eliminates this vulnerability."), meaning there's no reason to recheck
> permissions. Is that accurate?

Yes, precisely.  Once we have a reference to the mm we do not need to
worry about things changing underneath our feet, so the second check in
mem_read() is redundant and can be dropped.


Take care,

> 
> Thanks,
> 
> -Kees
> 
> [1] https://lkml.org/lkml/2011/2/7/368
> 
> -- 
> Kees Cook
> Ubuntu Security Team


-- 
steve

