Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab2CSMQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 08:16:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab2CSMQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 08:16:52 -0400
Message-ID: <4F672384.1030601@redhat.com>
Date: Mon, 19 Mar 2012 14:16:04 +0200
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
References: <20120316144028.036474157@chello.nl>   <4F670325.7080700@redhat.com> <1332155527.18960.292.camel@twins>  <4F671B90.3010209@redhat.com> <1332158992.18960.316.camel@twins>
In-Reply-To: <1332158992.18960.316.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 02:09 PM, Peter Zijlstra wrote:
> On Mon, 2012-03-19 at 13:42 +0200, Avi Kivity wrote:
> > > That's intentional, it keeps the work accounted to the tasks that need
> > > it.
> > 
> > The accounting part is good, the extra latency is not.  If you have
> > spare resources (processors or dma engines) you can employ for eager
> > migration why not make use of them.
>
> Afaik we do not use dma engines for memory migration. 

We don't, but I think we should.

> In any case, if you do cross-node migration frequently enough that the
> overhead of copying pages is a significant part of your time then I'm
> guessing there's something wrong.
>
> If not, the latency should be armortised enough to not matter.

Amortization is okay for HPC style applications but not for interactive
applications (including servers).  It all depends on the numbers of
course, maybe migrate on fault is okay, we'll need to measure it somehow.

> > > > - doesn't work with dma engines
> > >
> > > How does that work anyway? You'd have to reprogram your dma engine, so
> > > either the ->migratepage() callback does that and we're good either way,
> > > or it simply doesn't work at all.
> > 
> > If it's called from the faulting task's context you have to sleep, and
> > the latency gets increased even more, plus you're dependant on the dma
> > engine's backlog.  If you do all that from a background thread you don't
> > have to block (you might have to cancel or discard a migration if the
> > page was changed while being copied). 
>
> The current MoF implementation simply bails and uses the old page. It
> will never block.

Then it can not use a dma engine.

> Its all a best effort approach, a 'few' stray pages is OK as long as the
> bulk of the pages are local.
>
> If you're concerned, we can add per mm/vma counters to track this.

These are second and third order effects.  Overall I'm happy, kvm is one
of the workloads most severely impacted by the current numa support and
this looks like it addresses most of the issues.

-- 
error compiling committee.c: too many arguments to function

