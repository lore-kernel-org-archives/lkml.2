Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819Ab2KVXHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 18:07:23 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34086 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2KVXHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 18:07:17 -0500
MIME-Version: 1.0
In-Reply-To: <20121121171047.GA28875@gmail.com>
References: <1353291284-2998-1-git-send-email-mingo@kernel.org>
 <20121119162909.GL8218@suse.de> <alpine.DEB.2.00.1211191644340.24618@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1211191703270.24618@chino.kir.corp.google.com>
 <20121120060014.GA14065@gmail.com> <alpine.DEB.2.00.1211192213420.5498@chino.kir.corp.google.com>
 <20121120074445.GA14539@gmail.com> <alpine.DEB.2.00.1211200001420.16449@chino.kir.corp.google.com>
 <20121120090637.GA14873@gmail.com> <CA+55aFyR9FsGYWSKkgsnZB7JhheDMjEQgbzb0gsqawSTpetPvA@mail.gmail.com>
 <20121121171047.GA28875@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 21 Nov 2012 12:04:25 -1000
X-Google-Sender-Auth: S-7DcasslVb3_-EnA1gGUl5jKAE
Message-ID: <CA+55aFwCiA=4+piuvf6uTT6dqeJm_Nmib_zZ=4Xj0_JmN1GrnA@mail.gmail.com>
Subject: Re: [PATCH 00/27] Latest numa/core release, v16
To: Ingo Molnar <mingo@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 7:10 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Because scalability slowdowns are often non-linear.

Only if you hold locks or have other non-cpu-private activity.

Which the vsyscall code really shouldn't have.

That said, it might be worth removing the "prefetchw(&mm->mmap_sem)"
from the VM fault path. Partly because software prefetches have never
ever worked on any reasonable hardware, and partly because it could
seriously screw up things like the vsyscall stuff.

I think we only turn prefetchw into an actual prefetch instruction on
3DNOW hardware. Which is the *old* AMD chips. I don't think even the
Athlon does that.

Anyway, it might be interesting to see a instruction-level annotated
profile of do_page_fault() or whatever

> So with CONFIG_NUMA_BALANCING=y we are taking a higher page
> fault rate, in exchange for a speedup.

The thing is, so is autonuma.

And autonuma doesn't show any of these problems. Autonuma didn't need
vsyscall hacks, autonuma didn't need TLB flushing optimizations,
autonuma just *worked*, and in fact got big speedups when Mel did the
exact same loads on that same machine, presumably with all the same
issues..

Why are you ignoring that fact?

                  Linus
