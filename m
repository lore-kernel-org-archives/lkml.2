Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab2GIMZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:25:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:48191 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2GIMZ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:25:26 -0400
Message-ID: <1341836705.3462.62.camel@twins>
Subject: Re: [RFC][PATCH 14/26] sched, numa: Numa balancer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Mon, 09 Jul 2012 14:25:05 +0200
In-Reply-To: <4FF9D2EF.7010901@redhat.com>
References: <20120316144028.036474157@chello.nl>
	 <20120316144241.012558280@chello.nl> <4FF9D2EF.7010901@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-08 at 14:35 -0400, Rik van Riel wrote:
> 
> This looks like something that should be fixed before the
> code is submitted for merging upstream. 

static bool __task_can_migrate(struct task_struct *t, u64 *runtime, int node)
{
#ifdef CONFIG_CPUSETS
        if (!node_isset(node, t->mems_allowed))
                return false;
#endif

        if (!cpumask_intersects(cpumask_of_node(node), tsk_cpus_allowed(t)))
                return false;

        *runtime += t->se.sum_exec_runtime; // @#$#@ 32bit

        return true;
}

static bool process_can_migrate(struct numa_entity *ne, int node)
{
        struct task_struct *p, *t;
        bool allowed = false;
        u64 runtime = 0;

        rcu_read_lock();
        t = p = ne_owner(ne);
        if (p) do {
                allowed = __task_can_migrate(t, &runtime, node);
                if (!allowed)
                        break;
        } while ((t = next_thread(t)) != p);
        rcu_read_unlock();

        /*
         * Don't bother migrating memory if there's less than 1 second
         * of runtime on the tasks.
         */
        return allowed && runtime > NSEC_PER_SEC;
}

is what it looks like..
