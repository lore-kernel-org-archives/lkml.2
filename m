Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab2C1L0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:26:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:37972 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab2C1L0i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:26:38 -0400
Message-ID: <1332933968.2528.26.camel@twins>
Subject: Re: [PATCH 11/39] autonuma: CPU follow memory algorithm
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
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
Date: Wed, 28 Mar 2012 13:26:08 +0200
In-Reply-To: <20120327161540.GS5906@redhat.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
	 <1332783986-24195-12-git-send-email-aarcange@redhat.com>
	 <1332786353.16159.173.camel@twins> <4F70C365.8020009@redhat.com>
	 <20120326194435.GW5906@redhat.com>
	 <CA+55aFwk0Etg_UhoZcKsfFJ7PQNLdQ58xxXiwcA-jemuXdZCZQ@mail.gmail.com>
	 <20120326203951.GZ5906@redhat.com> <1332837595.16159.208.camel@twins>
	 <20120327161540.GS5906@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 18:15 +0200, Andrea Arcangeli wrote:
> This is _purely_ a performance optimization so if my design is so bad,
> and you're also requiring all apps that spans over more than one NUMA
> node to be modified to use your new syscalls, you won't have problems
> to win against AutoNUMA in the benchmarks. 

Right, so can we agree that the only case where they diverge is single
processes that have multiple threads and are bigger than a single node (either
in memory, cputime or both)?

I've asked you several times why you care about that one case so much, but
without answer.

I'll grant you that unmodified such processes might do better with your
stuff, however:

 - your stuff assumes there is a fair amount of locality to exploit.

   I'm not seeing how this is true in general, since data partitioning is hard
   and for those problems where its possible people tend to already do so,
   yielding natural points to add the syscalls.

 - your stuff doesn't actually nest, since a guest kernel has no clue as to
   what constitutes a node (or if there even is such a thing) it will randomly
   move tasks around on the vcpus, with complete disrespect for whatever host
   vcpu<->page mappings you set up.

   guest kernels actively scramble whatever relations you're building by
   scanning, destroying whatever (temporal) locality you think you might
   have found.

 - also, by not exposing NUMA to the guest kernel, the guest kernel/userspace
   has no clue it needs to behave as if there's multiple nodes etc..

Furthermore, most applications that are really big tend to have already thought
about parallelism and have employed things like data-parallelism if at all
possible. If this is not possible (many problems fall in this category) there
really isn't much you can do.

Related to this is that all applications that currently use mbind() and
sched_setaffinity() are trivial to convert.

Also, really big threaded programs have a natural enemy, the shared state that
makes it a process, most dominantly the shared address space (mmap_sem etc..).

There's also the reason Avi mentioned, core count tends to go up, which means
nodes are getting bigger and bigger.

But most importantly, your solution is big, complex and costly specifically to
handle this case which, as per the above reasons, I think is not very
interesting.

So why not do the simple thing first before going overboard for a case that
might be irrelevant?

