Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2E2SLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 14:11:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab2E2SLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 14:11:04 -0400
Date: Tue, 29 May 2012 20:09:28 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hillf Danton <dhillf@gmail.com>,
        Dan Smith <danms@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 13/35] autonuma: add page structure fields
Message-ID: <20120529180928.GL21339@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
 <1337965359-29725-14-git-send-email-aarcange@redhat.com>
 <1338297385.26856.74.camel@twins>
 <20120529163849.GF21339@redhat.com>
 <CA+55aFwmhM2a2HjB_MEjVDDL-AP4j-t202ozmHgT0azSptjnoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwmhM2a2HjB_MEjVDDL-AP4j-t202ozmHgT0azSptjnoA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 10:38:34AM -0700, Linus Torvalds wrote:
> A big fraction of one percent is absolutely unacceptable.
> 
> Our "struct page" is one of our biggest memory users, there's no way
> we should cavalierly make it even bigger.
> 
> It's also a huge performance sink, the cache miss on struct page tends
> to be one of the biggest problems in managing memory. We may not ever
> fix that, but making struct page bigger certainly isn't going to help
> the bad cache behavior.

The cache effects on the VM fast paths shouldn't be altered, and no
additional memory per-page is allocated when booting the same bzImage
on not NUMA hardware.

But now when booted on NUMA hardware it takes 8 bytes more than
before. There are 32 bytes allocated for every page (with autonuma13
it was only 24 bytes). The struct page itself isn't modified.

I want to remove the page pointer from the page_autonuma structure, to
keep the overhead at 0.58% instead of the current 0.78% (like it was
on autonuma alpha13 before the page_autonuma introduction). That
shouldn't be difficult and it's the next step.

Those changes aren't visible to anything but *autonuma.* files and the
cache misses in accessing the page_autonuma structure shouldn't be
measurable (the only fast path access is from
autonuma_free_page). Even if we find a way to shrink it below 0.58%,
it won't be intrusive over the rest of the kernel.

memcg takes 0.39% on every system built with
CONFIG_CGROUP_MEM_RES_CTLR=y unless the kernel is booted with
cgroup_disable=memory (and nobody does).

I'll do my best to shrink it further, like mentioned I'm very willing
to experiment with a fixed size array in function of the RAM per node,
to reduce the overhead (Michel and Rik suggested that at MM summit
too). Maybe it'll just work fine even if the max size of the lru is
reduced by a factor of 10. In the worst case I personally believe lots
of people would be ok to pay 0.58% considering they're paying 0.39%
even on much smaller not-NUMA systems to boot with memcg. And I'm sure
I can reduce it at least to 0.58% without any downside.

It's lots of work to reduce it below 0.58%, so before doing that I
believe it's fair enough to do enough performance measurement and
reviews to be sure the design flies.
