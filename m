Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1DVCvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 22:51:13 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53509 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab1DVCvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 22:51:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DB0ECEC.7090608@jp.fujitsu.com>
Date: Fri, 22 Apr 2011 11:50:20 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 12/15] sched: maintain throttled rqs as a list
References: <20110323030326.789836913@google.com> <20110323030449.828962245@google.com>
In-Reply-To: <20110323030449.828962245@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

(2011/03/23 12:03), Paul Turner wrote:
> @@ -1434,7 +1435,11 @@ static void throttle_cfs_rq(struct cfs_r
>  	if (!se)
>  		rq->nr_running += task_delta;
>  
> +	raw_spin_lock(&cfs_b->lock);
>  	cfs_rq->throttled = 1;
> +	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
> +	raw_spin_unlock(&cfs_b->lock);
> +
>  	cfs_rq->throttled_timestamp = rq_of(cfs_rq)->clock;
>  }
>  

Though I'm looking forward to see your updates soon, just FYI,
I found that somehow throttle_cfs_rq() was called with already
throttled cfs_rq.

So it breaks list throttled_cfs_rq by repeating list_add_tail_rcu()
and results in lockups like that Bharata and Xiao already reported.

There should be better fix, but following first aid to put_prev_entity()
worked for me:

-       if (!within_bandwidth(cfs_rq))
+       if (!within_bandwidth(cfs_rq) && !cfs_rq->throttled)
                throttle_cfs_rq(cfs_rq);
        else
                return_cfs_rq_quota(cfs_rq);

I believe you can do better next time.


Thanks,
H.Seto

