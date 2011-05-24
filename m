Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab1EXCIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 22:08:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60377 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094Ab1EXCIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 22:08:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDB12FD.2000208@jp.fujitsu.com>
Date: Tue, 24 May 2011 11:07:57 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: rientjes@google.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH 3/5] oom: oom-killer don't use proportion of system-ram
 internally
References: <4DD61F80.1020505@jp.fujitsu.com> <4DD6204D.5020109@jp.fujitsu.com> <alpine.DEB.2.00.1105231522410.17840@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1105231522410.17840@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/24 7:28), David Rientjes wrote:
> On Fri, 20 May 2011, KOSAKI Motohiro wrote:
>
>> CAI Qian reported his kernel did hang-up if he ran fork intensive
>> workload and then invoke oom-killer.
>>
>> The problem is, current oom calculation uses 0-1000 normalized value
>> (The unit is a permillage of system-ram). Its low precision make
>> a lot of same oom score. IOW, in his case, all processes have smaller
>> oom score than 1 and internal calculation round it to 1.
>>
>> Thus oom-killer kill ineligible process. This regression is caused by
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
> Same response as when you initially proposed this patch:
> http://marc.info/?l=linux-kernel&m=130507086613317 -- you never replied to
> that.

I did replay. Why don't you read?
http://www.gossamer-threads.com/lists/linux/kernel/1378837#1378837

If you haven't understand the issue, you can apply following patch and
run it.


diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index b01fa64..f35909b 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -718,6 +718,9 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
  	 */
  	constraint = constrained_alloc(zonelist, gfp_mask, nodemask,
  						&totalpages);
+
+	totalpages *= 10;
+
  	mpol_mask = (constraint == CONSTRAINT_MEMORY_POLICY) ? nodemask : NULL;
  	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask);



> The changelog doesn't accurately represent CAI Qian's problem; the issue
> is that root processes are given too large of a bonus in comparison to
> other threads that are using at most 1.9% of available memory.  That can
> be fixed, as I suggested by giving 1% bonus per 10% of memory used so that
> the process would have to be using 10% before it even receives a bonus.
>
> I already suggested an alternative patch to CAI Qian to greatly increase
> the granularity of the oom score from a range of 0-1000 to 0-10000 to
> differentiate between tasks within 0.01% of available memory (16MB on CAI
> Qian's 16GB system).  I'll propose this officially in a separate email.
>
> This patch also includes undocumented changes such as changing the bonus
> given to root processes.




