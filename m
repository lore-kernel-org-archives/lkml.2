Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab1CBHXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 02:23:44 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:59830 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab1CBHXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 02:23:43 -0500
Date: Wed, 2 Mar 2011 12:53:59 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
Subject: Re: [CFS Bandwidth Control v4 3/7] sched: throttle cfs_rq entities
 which exceed their local quota
Message-ID: <20110302072359.GB3142@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110216031831.571628191@google.com>
 <20110216031841.068673650@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216031841.068673650@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Tue, Feb 15, 2011 at 07:18:34PM -0800, Paul Turner wrote:
> @@ -1015,6 +1046,14 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
>  	 * Update run-time statistics of the 'current'.
>  	 */
>  	update_curr(cfs_rq);
> +
> +
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	if (!entity_is_task(se) && (cfs_rq_throttled(group_cfs_rq(se)) ||
> +	     !group_cfs_rq(se)->nr_running))
> +		return;
> +#endif
> +
>  	update_cfs_load(cfs_rq, 0);
>  	account_entity_enqueue(cfs_rq, se);
>  	update_cfs_shares(cfs_rq);

> @@ -1363,6 +1407,9 @@ enqueue_task_fair(struct rq *rq, struct 
>  			break;
>  		cfs_rq = cfs_rq_of(se);
>  		enqueue_entity(cfs_rq, se, flags);
> +		/* don't continue to enqueue if our parent is throttled */
> +		if (cfs_rq_throttled(cfs_rq))
> +			break;

1. This check (in enqueue_task_fair) ensures that if the cfs_rq we just enqueued
se to is throttled, we bail our from futher enqueueing of the hierarchy.

2. In enqueue_entity() we check if the entity we are enqueing owns a throttled
hieararchy and refuse to enqueue if true. And we silently refuse but continue
with futher enqueue attempts.

I see that 1 can happen when there a task belonging to a throttled group
wakes up.

Can you pls explain the scenario when 2 is needed ?

Regards,
Bharata.
