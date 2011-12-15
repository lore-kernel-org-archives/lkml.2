Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab1LOKJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 05:09:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40218 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab1LOKJ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 05:09:28 -0500
Message-ID: <1323943710.18942.24.camel@twins>
Subject: Re: [RFC] sched: Ensure cpu_power periodic update
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Thu, 15 Dec 2011 11:08:30 +0100
In-Reply-To: <1323717668-2143-1-git-send-email-vincent.guittot@linaro.org>
References: <1323717668-2143-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 20:21 +0100, Vincent Guittot wrote:
> With a lot of small tasks, the softirq sched is nearly never called
> when no_hz is enable. In this case the load_balance is mainly called with
> the newly_idle mode which doesn't update the cpu_power.
> Add a next_update field which ensure a maximum update period when
> there is short activity

> +	if (local_group) {
> +		if (idle != CPU_NEWLY_IDLE) {
> +			if (balance_cpu != this_cpu) {
> +				*balance = 0;
> +				return;
> +			}
> +			update_group_power(sd, this_cpu);
> +		} else if (time_after_eq(jiffies, group->sgp->next_update))
> +			update_group_power(sd, this_cpu);
>  	}

Hmm, I would have expected it to be called from the NOHZ balancing path
instead of the new_idle path. Your changelog fails to mentions any
considerations on this..

Then again, its probably easier to keep update_group_power on this_cpu
than to allow a remote update of your cpu_power.

So I'm not opposed to this patch, I'd just like a little extra
clarification.
