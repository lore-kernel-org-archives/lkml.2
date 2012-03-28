Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab2C1Ske (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:40:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758389Ab2C1Skd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:40:33 -0400
Date: Wed, 28 Mar 2012 20:39:35 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dan Smith <danms@us.ibm.com>, Paul Turner <pjt@google.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>, Bharata B Rao <bharata.rao@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/39] autonuma: CPU follow memory algorithm
Message-ID: <20120328183935.GM5906@redhat.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
 <1332783986-24195-12-git-send-email-aarcange@redhat.com>
 <1332786353.16159.173.camel@twins>
 <4F70C365.8020009@redhat.com>
 <20120326194435.GW5906@redhat.com>
 <CA+55aFwk0Etg_UhoZcKsfFJ7PQNLdQ58xxXiwcA-jemuXdZCZQ@mail.gmail.com>
 <20120326203951.GZ5906@redhat.com>
 <1332837595.16159.208.camel@twins>
 <20120327161540.GS5906@redhat.com>
 <1332933968.2528.26.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332933968.2528.26.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 28, 2012 at 01:26:08PM +0200, Peter Zijlstra wrote:
> Right, so can we agree that the only case where they diverge is single
> processes that have multiple threads and are bigger than a single node (either
> in memory, cputime or both)?

I think it vastly diverges for processes that are smaller than one
node too. 1) your numa/sched goes blind with an almost arbitrary home
node, 2) your migrate-on-fault will be unable to provide an efficient
and steady async background migration.

> I've asked you several times why you care about that one case so much, but
> without answer.

If this case wasn't important to you, you wouldn't need to introduce
your syscalls.

> I'll grant you that unmodified such processes might do better with your
> stuff, however:
> 
>  - your stuff assumes there is a fair amount of locality to exploit.
> 
>    I'm not seeing how this is true in general, since data partitioning is hard
>    and for those problems where its possible people tend to already do so,
>    yielding natural points to add the syscalls.

Later, I plan to detect this and layout interleaved pages
automatically so you don't even need to manually set MPOL_INTERLEAVE.

>  - your stuff doesn't actually nest, since a guest kernel has no clue as to
>    what constitutes a node (or if there even is such a thing) it will randomly
>    move tasks around on the vcpus, with complete disrespect for whatever host
>    vcpu<->page mappings you set up.
> 
>    guest kernels actively scramble whatever relations you're building by
>    scanning, destroying whatever (temporal) locality you think you might
>    have found.

This shall work fine, running AutoNUMA in guest and host. qemu just
need to create a vtopology for the guest that matches the hardware
topology. Hard binds in the guest will also work great (they create
node locality too).

A paravirt layer could also hint the host on the vcpu switches to
shift the host numa stats across but I didn't thought too much on this
possible paravirt numa-sched optimization, it's not mandatory, just an idea.

> Related to this is that all applications that currently use mbind() and
> sched_setaffinity() are trivial to convert.

Too bad firefox isn't using mbind yet. My primary target are the 99%
of apps out there running on a 24way 2 node system or equivalent and
KVM.

I agree converting qemu to the syscalls would be trivial though.
