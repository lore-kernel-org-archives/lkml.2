Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab2IYLoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:44:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16906 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755770Ab2IYLoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:44:12 -0400
X-IronPort-AV: E=Sophos;i="4.80,482,1344182400"; 
   d="scan'208";a="5914056"
Message-ID: <5061996E.8070301@cn.fujitsu.com>
Date: Tue, 25 Sep 2012 19:45:50 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-numa@vger.kernel.org, wency@cn.fujitsu.com, mingo@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Update sched_domains_numa_masks when new cpus are onlined.
References: <1347963128-25942-1-git-send-email-tangchen@cn.fujitsu.com>  <1348479536.11847.25.camel@twins> <50611946.9080601@cn.fujitsu.com> <1348569232.3881.1.camel@twins>
In-Reply-To: <1348569232.3881.1.camel@twins>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/25 19:44:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/25 19:44:24,
	Serialize complete at 2012/09/25 19:44:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter~

Sorry about the confusing log, and thanks for the patient. :)

Here, I want to say something more about the sched_domains_numa_levels
to make myself more clear. :)


Let's have an example here.

sched_init_numa()
{
	...
	// A loop set sched_domains_numa_levels to level.-------------1

	// I set sched_domains_numa_levels to 0.
	sched_domains_numa_levels = 0;--------------------------------2

	// A loop allocating memory for sched_domains_numa_masks[][]
	for (i = 0; i < level; i++) {
		......
		// Allocate memory for sched_domains_numa_masks[i]----3
		......
	}
	......

	// I reset sched_domains_numa_levels to level.
	sched_domains_numa_levels = level;----------------------------4
}

// A new function I added.
static void sched_domains_numa_masks_clear(int cpu)
{
         int i, j;
         for (i = 0; i < sched_domains_numa_levels; i++)---------------5
                 for (j = 0; j < nr_node_ids; j++)
                         cpumask_clear_cpu(cpu, 
sched_domains_numa_masks[i][j]);
}


Suppose level is 10, and at step 1, sched_domains_numa_levels is 10.

If I didn't set sched_domains_numa_levels to 0 at step 2, it will be 10
all the time.

If memory allocation at step 3 fails when i = 5, the array
sched_domains_numa_masks[][] will only have 5 members, and
sched_domains_numa_levels is 10.

As you see, I added 2 functions using sched_domains_numa_levels to
iterate sched_domains_numa_masks[][], such as at step 5.
In this case, the iteration will break out when i = 5.

This could be dangerous.

So, I set sched_domains_numa_levels to 0 at step 2. This way, even if
any memory allocation at step 3 fails, and sched_init_numa() returns,
anyone uses sched_domains_numa_levels (which is 0) won't be wrong.

I'm not sure if this is the best way to settle this problem.
If you have a better idea, please tell me. Thanks. :)


On 09/25/2012 06:33 PM, Peter Zijlstra wrote:
> On Tue, 2012-09-25 at 10:39 +0800, Tang Chen wrote:
>>>> @@ -6765,11 +6773,64 @@ static void sched_init_numa(void)
>>>>       }
>>>>
>>>>       sched_domain_topology = tl;
>>>> +
>>>> +    sched_domains_numa_levels = level;
>>
>> And I set it to level here again.
>>
> But its already set there.. its set every time we find a new level.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

