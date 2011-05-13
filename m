Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab1EMK25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:28:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46303 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1EMK2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:28:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DCD0845.10409@jp.fujitsu.com>
Date: Fri, 13 May 2011 19:30:29 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: CAI Qian <caiqian@redhat.com>, avagin@gmail.com,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 3/4] oom: oom-killer don't use permillage of system-ram
 internally
References: <20110509182110.167F.A69D9226@jp.fujitsu.com> <20110510171335.16A7.A69D9226@jp.fujitsu.com> <20110510171724.16B3.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1105101632290.12477@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1105101632290.12477@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/11 8:40), David Rientjes wrote:
> On Tue, 10 May 2011, KOSAKI Motohiro wrote:
>
>> CAI Qian reported his kernel did hang-up if he ran fork intensive
>> workload and then invoke oom-killer.
>>
>> The problem is, Current oom calculation uses 0-1000 normalized value
>> (The unit is a permillage of system-ram). Its low precision make
>> a lot of same oom score. IOW, in his case, all processes have<1
>> oom score and internal integral calculation round it to 1. Thus
>> oom-killer kill ineligible process. This regression is caused by
>> commit a63d83f427 (oom: badness heuristic rewrite).
>>
>> The solution is, the internal calculation just use number of pages
>> instead of permillage of system-ram. And convert it to permillage
>> value at displaying time.
>>
>> This patch doesn't change any ABI (included  /proc/<pid>/oom_score_adj)
>> even though current logic has a lot of my dislike thing.
>>
>
> s/permillage/proportion/
>
> This is unacceptable, it does not allow users to tune oom_score_adj
> appropriately based on the scores exported by /proc/pid/oom_score to
> discount an amount of RAM from a thread's memory usage in systemwide,
> memory controller, cpuset, or mempolicy contexts.  This is only possible
> because the oom score is normalized.

You misunderstand the code. The patch doesn't change oom_score.
The patch change fs/proc too.

>
> What would be acceptable would be to increase the granularity of the score
> to 10000 or 100000 to differentiate between threads using 0.01% or 0.001%
> of RAM from each other, respectively.  The range of oom_score_adj would
> remain the same, however, and be multiplied by 10 or 100, respectively,
> when factored into the badness score baseline.  I don't believe userspace
> cares to differentiate between more than 0.1% of available memory.

Currently, SGI buy 16TB memory. 16TB x 0.1% = 1.6GB. I don't think your
fork bomb process use bigger than 1.6GB. Thus your patch is unacceptable.

So, please read the code again. or run it.

> The other issue that this patch addresses is the bonus given to root
> processes.  I agree that if a root process is using 4% of RAM that it
> should not be equal to all other threads using 1%.  I do believe that a
> root process using 60% of RAM should be equal priority to a thread using
> 57%, however.  Perhaps a compromise would be to give root processes a
> bonus of 1% for every 30% of RAM they consume?

I think you are talking about patch [4/4], right? patch [3/4] and [4/4]
are attacking another issue. big machine issue and root user issue.


