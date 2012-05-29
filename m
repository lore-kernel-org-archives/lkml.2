Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab2E2NBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 09:01:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:55281 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2E2NBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 09:01:35 -0400
Message-ID: <1338296453.26856.68.camel@twins>
Subject: Re: [PATCH 12/35] autonuma: CPU follow memory algorithm
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
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
Date: Tue, 29 May 2012 15:00:53 +0200
In-Reply-To: <1337965359-29725-13-git-send-email-aarcange@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
	 <1337965359-29725-13-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 19:02 +0200, Andrea Arcangeli wrote:
> @@ -3274,6 +3268,8 @@ need_resched:
>  
>         post_schedule(rq);
>  
> +       sched_autonuma_balance();
> +
>         sched_preempt_enable_no_resched();
>         if (need_resched())
>                 goto need_resched;



> +void sched_autonuma_balance(void)
> +{

> +       for_each_online_node(nid) {
> +       }

> +       for_each_online_node(nid) {
> +               for_each_cpu_and(cpu, cpumask_of_node(nid), allowed) {


> +               }
> +       }

> +       stop_one_cpu(this_cpu, migration_cpu_stop, &arg);
> +} 

NAK

You do _NOT_ put a O(nr_cpus) or even O(nr_nodes) loop in the middle of
schedule().

I see you've made it conditional, but schedule() taking that long --
even occasionally -- is just not cool.

schedule() calling schedule() is also an absolute abomination.

You were told to fix this several times..
