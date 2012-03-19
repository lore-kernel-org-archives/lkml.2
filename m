Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903Ab2CSM4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 08:56:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758513Ab2CSM4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 08:56:47 -0400
Message-ID: <4F67217B.40205@redhat.com>
Date: Mon, 19 Mar 2012 14:07:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 00/26] sched/numa
References: <20120316144028.036474157@chello.nl>   <4F670325.7080700@redhat.com> <1332155527.18960.292.camel@twins>  <4F671B90.3010209@redhat.com> <1332158367.18960.308.camel@twins>
In-Reply-To: <1332158367.18960.308.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 01:59 PM, Peter Zijlstra wrote:
> On Mon, 2012-03-19 at 13:42 +0200, Avi Kivity wrote:
> > > Now if you want to be able to scan per-thread, you need per-thread
> > > page-tables and I really don't want to ever see that. That will blow
> > > memory overhead and context switch times.
> > 
> > I thought of only duplicating down to the PDE level, that gets rid of
> > almost all of the overhead. 
>
> You still get the significant CR3 cost for thread switches. 

True.  Not so much for virt, which has one thread per cpu generally.

> [ /me grabs the SDM to find that PDE is what we in Linux call the pmd ]

Yes, sorry.

> That'll cut the memory overhead down but also the severely impact the
> accuracy.
>
> Also, I still don't see how such a scheme would correctly identify
> per-cpu memory in guest kernels. While less frequent its still very
> common to do remote access to per-cpu data. So even if you did page
> granularity you'd get a fair amount of pages that are accesses by all
> threads (vcpus) in the scan interval, even thought they're primarily
> accesses by just one.
>
> If you go to pmd level you get even less information.

That is true.  Which is why I like the explicit vnode thing.  The guest
kernel already knows how to affine vcpus to memory, we don't need to
scan to see if it's actually doing what we told it to do.  Scanning is
good for unmodified non-virt applications, or to prioritize the migration.

-- 
error compiling committee.c: too many arguments to function

