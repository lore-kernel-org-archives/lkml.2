Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab2E2SZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 14:25:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985Ab2E2SZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 14:25:24 -0400
Date: Tue, 29 May 2012 20:24:40 +0200
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
Subject: Re: [PATCH 22/35] autonuma: sched_set_autonuma_need_balance
Message-ID: <20120529182440.GN21339@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
 <1337965359-29725-23-git-send-email-aarcange@redhat.com>
 <1338307942.26856.111.camel@twins>
 <20120529173347.GJ21339@redhat.com>
 <1338313407.26856.163.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338313407.26856.163.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 07:43:27PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-05-29 at 19:33 +0200, Andrea Arcangeli wrote:
> > So the cost on a 24-way SMP 
> 
> is irrelevant.. also, not every cpu gets to the 24 cpu domain, just 2
> do.
> 
> When you do for_each_cpu() think at least 4096, if you do
> for_each_node() think at least 256.
> 
> Add to that the knowledge that doing 4096 remote memory accesses will
> cost multiple jiffies, then realize you're wanting to do that with
> preemption disabled.
> 
> That's just a very big no go.

I'm thinking 4096/256, this is why I mentioned it's a 24-way system. I
think the hackbench should be repeated on a much bigger system to see
what happens, I'm not saying it'll work fine already.

But from autonuma13 to 14 it's a world of difference in hackbench
terms, to the point the cost is zero on a 24-way.

My idea down the road, with multi hop systems, is to balance across
the 1 hop at the regular load_balance interval, and move to the 2 hops
at half frequency, and 3 hops at 1/4th frequency etc... That change
alone should help tremendously with 256 nodes and 5/6 hops. And it
should be quite easy to implement too.

knuma_migrated also need to learn more about the hops and probably
scan at higher frequency the lru heads coming from the closer hops.

The code is not "hops" aware yet and certainly there are still lots of
optimization to do for the very big systems. I think it's already
quite ideal right now for most servers and I don't see blockers in
optimizing it for the extreme big cases (and I expect it'd already
work better than nothing in the extreme setups). I removed [RFC]
because I'm quite happy with it now (there were things I wasn't happy
with before), but I didn't mean it's finished.
