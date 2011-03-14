Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab1CNPOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:14:32 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51775 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab1CNPOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:14:31 -0400
Date: Mon, 14 Mar 2011 08:13:20 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Stephen Wilson <wilsons@start.ca>
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
Message-ID: <20110314151320.GG21770@outflux.net>
References: <1300045764-24168-1-git-send-email-wilsons@start.ca>
 <1300045764-24168-12-git-send-email-wilsons@start.ca>
 <20110314000859.GF21770@outflux.net>
 <20110314005948.GA28037@fibrous.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314005948.GA28037@fibrous.localdomain>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 08:59:48PM -0400, Stephen Wilson wrote:
> On Sun, Mar 13, 2011 at 05:08:59PM -0700, Kees Cook wrote:
> > On Sun, Mar 13, 2011 at 03:49:23PM -0400, Stephen Wilson wrote:
> > >  	copied = -EIO;
> > >  	if (file->private_data != (void *)((long)current->self_exec_id))
> > > -		goto out;
> > > +		goto out_mm;
> > 
> > The file->private_data test seems wrong to me. Is there a case were the mm
> > returned from check_mem_permission(task) can refer to something that is no
> > longer attached to task?
> > 
> > For example:
> > - pid 100 ptraces pid 200
> > - pid 100 opens /proc/200/mem
> > - pid 200 execs into something else
> 
> If the _target_ task (pid 200) execs then we are OK -- we hold a
> reference to the *old* mm and it is that to which we read and write via
> access_remote_vm().

Right, the old mm is held during read_mem(). But isn't the mm fetched
from check_mem_permission(task) each time pid 100 reads from the
/proc/200/mem fd? (And if so, that's still okay, it still passes through
check_mem_permission() so the access will be validated.)

> In the case of the file->private_data test we are looking at the
> *ptracer* (pid 100).  Here we are guarding against the case where the
> tracer exec's and accidentally leaks the fd (hence the test wrt
> current).  IOW, /proc/pid/mem is implicitly close on exec.  This is just
> a minor feature to protect against buggy user space reading/writing
> mistakenly into the targets address space.

Ah! Right, thanks, that clears that up.

> > What is that test trying to do? And I'm curious for both mem_write
> > as well as the existing mem_read use of the test, since I'd like to see
> > a general solution to the "invalidate /proc fds across exec" so we can
> > close CVE-2011-1020 for everything[1].
> 
> These patches certainly do not add to the problem -- but they do not try
> to address the general issue either.

The use of check_mem_permission() already protects /proc/pid/mem, but
that test is much stricter than the may_ptrace() checks of things like
/proc/pid/maps. Regardless, yeah, there's no problem here that I can see.

> > Associated with this, the drop of check_mem_permission(task) during the
> > mem_read loop implies that the mm is locked during that loop and seems to
> > reflect what you're saying ("Holding a reference to the target mm_struct
> > eliminates this vulnerability."), meaning there's no reason to recheck
> > permissions. Is that accurate?
> 
> Yes, precisely.  Once we have a reference to the mm we do not need to
> worry about things changing underneath our feet, so the second check in
> mem_read() is redundant and can be dropped.

Excellent. :)

-Kees

-- 
Kees Cook
Ubuntu Security Team
