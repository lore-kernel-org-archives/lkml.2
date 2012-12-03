Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab2LCT6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:58:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab2LCT6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:58:11 -0500
Message-ID: <50BD03B7.2070401@redhat.com>
Date: Mon, 03 Dec 2012 14:55:35 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 29/52] sched: Implement NUMA scanning backoff
References: <1354473824-19229-1-git-send-email-mingo@kernel.org> <1354473824-19229-30-git-send-email-mingo@kernel.org>
In-Reply-To: <1354473824-19229-30-git-send-email-mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2012 01:43 PM, Ingo Molnar wrote:
> Back off slowly from scanning, up to sysctl_sched_numa_scan_period_max
> (1.6 seconds). Scan faster again if we were forced to switch to
> another node.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 8f0e6ba..59fea2e 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -865,8 +865,10 @@ static void task_numa_placement(struct task_struct *p)
>   		}
>   	}
>
> -	if (max_node != p->numa_max_node)
> +	if (max_node != p->numa_max_node) {
>   		sched_setnuma(p, max_node, task_numa_shared(p));
> +		goto out_backoff;
> +	}
>
>   	p->numa_migrate_seq++;
>   	if (sched_feat(NUMA_SETTLE) &&

Is that correct?

It looks like the code only jumps to the out_backoff label
after resetting p->numa_scan_period to sysctl_sched_numa_scan_period_min
in sched_setnuma?

Should it not be the other way around, slowly increasing the process's
numa_scan_period when we do NOT do a sched_setnuma call for the process
at all?

> @@ -882,7 +884,11 @@ static void task_numa_placement(struct task_struct *p)
>   	if (shared != task_numa_shared(p)) {
>   		sched_setnuma(p, p->numa_max_node, shared);
>   		p->numa_migrate_seq = 0;
> +		goto out_backoff;
>   	}
> +	return;

We can never reach the backoff code, except by an explicit goto,
which is only there after a call to sched_setnuma.

That is the opposite from what the changelog suggests...

> +out_backoff:
> +	p->numa_scan_period = min(p->numa_scan_period * 2, sysctl_sched_numa_scan_period_max);
>   }
>
>   /*
>

