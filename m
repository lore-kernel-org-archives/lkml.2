Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1GHHqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 03:46:11 -0400
Received: from smtp-out.google.com ([74.125.121.67]:3539 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab1GHHqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 03:46:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=o47ILzMRrXdNwuu/rwLDw5Z7aS4QN8MkyTP7wC9YBSwUgSFF4VHyqHFVaCS78lZ/B
	JLbihlRyODuOuzIIDTxAQ==
MIME-Version: 1.0
In-Reply-To: <1310061588.3282.624.camel@twins>
References: <20110707053036.173186930@google.com> <20110707112302.GB8227@elte.hu>
 <1310049528.3282.583.camel@twins> <1310061588.3282.624.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Fri, 8 Jul 2011 00:45:32 -0700
Message-ID: <CAPM31RLcUxyTh=iJxfxfQZ2CY-8ksDYkPPY9==JbDx8L0N=DJA@mail.gmail.com>
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 10:59 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2011-07-07 at 16:38 +0200, Peter Zijlstra wrote:
>> On Thu, 2011-07-07 at 13:23 +0200, Ingo Molnar wrote:
>> >
>> > The +1.5% increase in vanilla kernel context switching performance is
>> > unfortunate - where does that overhead come from?
>>
>> Looking at the asm output, I think its partly because things like:
>>
>> @@ -602,6 +618,8 @@ static void update_curr(struct cfs_rq *c
>>                 cpuacct_charge(curtask, delta_exec);
>>                 account_group_exec_runtime(curtask, delta_exec);
>>         }
>> +
>> +       account_cfs_rq_runtime(cfs_rq, delta_exec);
>>  }
>>
>>
>> +static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
>> +               unsigned long delta_exec)
>> +{
>> +       if (!cfs_rq->runtime_enabled)
>> +               return;
>> +
>> +       cfs_rq->runtime_remaining -= delta_exec;
>> +       if (cfs_rq->runtime_remaining > 0)
>> +               return;
>> +
>> +       assign_cfs_rq_runtime(cfs_rq);
>> +}
>>
>> generate a call, only to then take the first branch out, marking that
>> function __always_inline would cure the call problem. Going beyond that
>> would be using static_branch() to track if there is any bandwidth
>> tracking required at all.
>
> Right, so that cfs_rq->runtime_enabled is almost a guaranteed cacheline
> miss as well, its at the tail end of cfs_rq, then again, the smp-load
> update will want to touch that same cacheline so its not a complete
> waste of time.

Right -- this is already being pulled in by the touch to
load_unacc_exec_time in __update_curr().

I looked at moving to share a line with exec_clock/vruntime, however
this was not beneficial in the supported but not enabled case due to
the above.  Moreover, it was detrimental to the enabled performance as
the dependent runtime state was no longer shared on the line when
cfs_rq->runtime_enabled == 1.

>
> The other big addition to all the fast paths are the various throttled
> checks, those do miss a complete new cacheline.. adding a
> static_branch() to that might make sense.
>
> compile tested only..
>
> ---
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -71,6 +71,7 @@
>  #include <linux/ctype.h>
>  #include <linux/ftrace.h>
>  #include <linux/slab.h>
> +#include <linux/jump_label.h>
>
>  #include <asm/tlb.h>
>  #include <asm/irq_regs.h>
> @@ -297,6 +298,7 @@ struct task_group {
>        struct autogroup *autogroup;
>  #endif
>
> +       int runtime_enabled;
>        struct cfs_bandwidth cfs_bandwidth;
>  };
>
> @@ -410,6 +412,8 @@ struct cfs_rq {
>  };
>
>  #ifdef CONFIG_CFS_BANDWIDTH
> +static struct jump_label_key cfs_bandwidth_enabled;
> +
>  static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
>  {
>        return &tg->cfs_bandwidth;
> @@ -9075,6 +9079,15 @@ static int tg_set_cfs_bandwidth(struct t
>                        unthrottle_cfs_rq(cfs_rq);
>                raw_spin_unlock_irq(&rq->lock);
>        }
> +
> +       if (runtime_enabled && !tg->runtime_enabled)
> +               jump_label_inc(&cfs_bandwidth_enabled);
> +
> +       if (!runtime_enabled && tg->runtime_enabled)
> +               jump_label_dec(&cfs_bandwidth_enabled);
> +
> +       tg->runtime_enabled = runtime_enabled;
> +
>  out_unlock:
>        mutex_unlock(&cfs_constraints_mutex);
>
> Index: linux-2.6/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_fair.c
> +++ linux-2.6/kernel/sched_fair.c
> @@ -1410,10 +1410,10 @@ static void expire_cfs_rq_runtime(struct
>        }
>  }
>
> -static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
> +static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
>                unsigned long delta_exec)
>  {
> -       if (!cfs_rq->runtime_enabled)
> +       if (!static_branch(&cfs_bandwidth_enabled) || !cfs_rq->runtime_enabled)
>                return;
>
>        /* dock delta_exec before expiring quota (as it could span periods) */
> @@ -1433,13 +1433,13 @@ static void account_cfs_rq_runtime(struc
>
>  static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
>  {
> -       return cfs_rq->throttled;
> +       return static_branch(&cfs_bandwidth_enabled) && cfs_rq->throttled;
>  }
>
>  /* check whether cfs_rq, or any parent, is throttled */
>  static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
>  {
> -       return cfs_rq->throttle_count;
> +       return static_branch(&cfs_bandwidth_enabled) && cfs_rq->throttle_count;
>  }
>
>  /*
>
>
