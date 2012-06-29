Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab2F2S7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:59:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932708Ab2F2S7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:59:05 -0400
Message-ID: <4FEDFAB1.8050305@redhat.com>
Date: Fri, 29 Jun 2012 14:57:53 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
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
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 21/40] autonuma: avoid CFS select_task_rq_fair to return
 -1
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-22-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-22-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:56 AM, Andrea Arcangeli wrote:
> Fix to avoid -1 retval.
>
> Includes fixes from Hillf Danton<dhillf@gmail.com>.
>
> Signed-off-by: Andrea Arcangeli<aarcange@redhat.com>
> ---
>   kernel/sched/fair.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index c099cc6..fa96810 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2789,6 +2789,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>   		if (new_cpu == -1 || new_cpu == cpu) {
>   			/* Now try balancing at a lower domain level of cpu */
>   			sd = sd->child;
> +			if (new_cpu<  0)
> +				/* Return prev_cpu is find_idlest_cpu failed */
> +				new_cpu = prev_cpu;
>   			continue;
>   		}
>
> @@ -2807,6 +2810,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>   unlock:
>   	rcu_read_unlock();
>
> +	BUG_ON(new_cpu<  0);
>   	return new_cpu;
>   }
>   #endif /* CONFIG_SMP */

Wait, what?

Either this is a scheduler bugfix, in which case you
are better off submitting it separately and reducing
the size of your autonuma patch queue, or this is a
behaviour change in the scheduler that needs better
arguments than a 1-line changelog.

-- 
All rights reversed
