Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab2E2Mtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 08:49:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:55092 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab2E2Mto convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 08:49:44 -0400
Message-ID: <1338295753.26856.60.camel@twins>
Subject: Re: [PATCH 08/35] autonuma: introduce kthread_bind_node()
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
Date: Tue, 29 May 2012 14:49:13 +0200
In-Reply-To: <1337965359-29725-9-git-send-email-aarcange@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
	 <1337965359-29725-9-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 19:02 +0200, Andrea Arcangeli wrote:
>  /**
> + * kthread_bind_node - bind a just-created kthread to the CPUs of a node.
> + * @p: thread created by kthread_create().
> + * @nid: node (might not be online, must be possible) for @k to run on.
> + *
> + * Description: This function is equivalent to set_cpus_allowed(),
> + * except that @nid doesn't need to be online, and the thread must be
> + * stopped (i.e., just returned from kthread_create()).
> + */
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

No, I've said before, this is wrong. You should only ever use
PF_THREAD_BOUND when its strictly per-cpu. Moving the your numa threads
to a different node is silly but not fatal in any way.

> +}
> +EXPORT_SYMBOL(kthread_bind_node); 


