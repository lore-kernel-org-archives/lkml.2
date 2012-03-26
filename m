Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676Ab2CZWg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 18:36:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48309 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab2CZWgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 18:36:10 -0400
Message-ID: <1332786755.16159.174.camel@twins>
Subject: Re: [PATCH 07/39] autonuma: introduce kthread_bind_node()
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
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Date: Mon, 26 Mar 2012 20:32:35 +0200
In-Reply-To: <1332783986-24195-8-git-send-email-aarcange@redhat.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
	 <1332783986-24195-8-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 19:45 +0200, Andrea Arcangeli wrote:
> +void kthread_bind_node(struct task_struct *p, int nid)
> +{
> +       /* Must have done schedule() in kthread() before we set_task_cpu */
> +       if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
> +               WARN_ON(1);
> +               return;
> +       }
> +
> +       /* It's safe because the task is inactive. */
> +       do_set_cpus_allowed(p, cpumask_of_node(nid));
> +       p->flags |= PF_THREAD_BOUND;
> +}
> +EXPORT_SYMBOL(kthread_bind_node);

That's a wrong use of PF_THREAD_BOUND, we should only use that for
cpumask_weight(tsk_cpus_allowed()) == 1.
