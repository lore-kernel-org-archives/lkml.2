Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2E2Qjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:39:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab2E2Qje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:39:34 -0400
Date: Tue, 29 May 2012 18:38:49 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20120529163849.GF21339@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
 <1337965359-29725-14-git-send-email-aarcange@redhat.com>
 <1338297385.26856.74.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338297385.26856.74.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 03:16:25PM +0200, Peter Zijlstra wrote:
> 24 bytes per page.. or ~0.6% of memory gone. This is far too great a
> price to pay.

I don't think it's too great, memcg uses for half of that and yet
nobody is booting with cgroup_disable=memory even on not-NUMA servers
with less RAM.

> At LSF/MM Rik already suggested you limit the number of pages that can
> be migrated concurrently and use this to move the extra list_head out of
> struct page and into a smaller amount of extra structures, reducing the
> total overhead.

It would reduce the memory overhead but it'll make the code more
complex and it'll require more locking, plus allowing for very long
migration lrus, provides an additional means of false-sharing
avoidance. Those are lrus, if the last_nid false sharing logic will
pass, the page still has to reach the tail of the list before being
migrated, if false sharing happens in the meanwhile we'll remove it
from the lru.

But I'm all for experimenting. It's just not something I had the time
to try yet. I will certainly love to see how it performs by reducing
the max size of the list. I totally agree it's a good idea to try it
out, and I don't exclude it will work fine, but it's not obvious it's
worth the memory saving.
