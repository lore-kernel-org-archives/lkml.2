Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161481Ab2GLSGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 14:06:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932762Ab2GLSG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 14:06:29 -0400
Date: Thu, 12 Jul 2012 19:59:55 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 19/40] autonuma: alloc/free/init sched_autonuma
Message-ID: <20120712175955.GK20382@redhat.com>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
 <1340888180-15355-20-git-send-email-aarcange@redhat.com>
 <20120630051000.GF3975@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120630051000.GF3975@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

On Sat, Jun 30, 2012 at 01:10:01AM -0400, Konrad Rzeszutek Wilk wrote:
> On Thu, Jun 28, 2012 at 02:55:59PM +0200, Andrea Arcangeli wrote:
> > This is where the dynamically allocated sched_autonuma structure is
> > being handled.
> > 
> > The reason for keeping this outside of the task_struct besides not
> > using too much kernel stack, is to only allocate it on NUMA
> > hardware. So the not NUMA hardware only pays the memory of a pointer
> > in the kernel stack (which remains NULL at all times in that case). 
> 
> .. snip..
> > +	if (unlikely(alloc_task_autonuma(tsk, orig, node)))
> > +		/* free_thread_info() undoes arch_dup_task_struct() too */
> > +		goto out_thread_info;
> >  
> 
> That looks (without seeing the implementation) and from reading the git
> commit, like that on non-NUMA machines it would fail - and end up
> stop the creation of a task.

On not NUMA systems or if you boot with noautonuma, this does nothing
but returns 0 (if CONFIG_AUTONUMA=n it returns 0 at build time so the
above block is discarded by gcc). It can only fail when AutoNUMA is
enabled on real NUMA hardware, when it does something but you run OOM
(likely also triggering oom killer and stuff but it must handle the
OOM as every other kernel allocation or the whole kernel becomes OOM
deadlock prone).

> 
> Perhaps a better name for the function: alloc_always_task_autonuma
> since the function (at least from the description of this patch) will
> always succeed. Perhaps even remove the:
> "if unlikely(..)" bit?

It will not always succeed and it will not always allocate.
