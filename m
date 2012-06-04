Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab2FDRIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:08:41 -0400
Received: from relay.parallels.com ([195.214.232.42]:49883 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab2FDRIk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:08:40 -0400
From: Vladimir Davydov <VDavydov@parallels.com>
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 4 Jun 2012 21:08:37 +0400
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
Thread-Topic: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
Thread-Index: Ac1CdKs/UPRGNHDZQlK6uIL0Dxv73Q==
Message-ID: <33E662E8-48BF-49A7-A4A0-CB1A751AAEBC@parallels.com>
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
 <1338805967.28282.12.camel@twins> <4FCCB486.4040905@linux.intel.com>
 <1338817519.28282.54.camel@twins> <4FCCBC97.8060101@linux.intel.com>
 <1338822509.28282.65.camel@twins> <4FCCD0CD.8080700@linux.intel.com>
 <1338823568.28282.79.camel@twins> <4FCCD6B7.4030703@linux.intel.com>
 <1338827607.28282.99.camel@twins> <4FCCE823.8090700@linux.intel.com>
In-Reply-To: <4FCCE823.8090700@linux.intel.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, ru-RU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 4, 2012, at 8:53 PM, Arjan van de Ven wrote:

> 
>> 
>> False, you can have 0 idle time and still have low load.
> 
> 1 is not low in this context fwiw.
> 
>> 
>>> but because idle
>>> time tends to be bursty, we can still be idle for, say, a millisecond
>>> every 10 milliseconds. In this scenario, the load average is used to
>>> ensure that the 200 usecond cost of exiting idle is acceptable.
>> 
>> So what you're saying is that if you have 1ms idle in 10ms, it might not
>> be a continuous 1ms. And you're using load as a measure of how many
>> fragments it comes apart in?
> 
> no
> 
> what I'm saying is that if you have a workload where you have 10 msec of
> work, then 1 msec of idle, then 10 msec of work, 1 msec of idle etc etc,
> it is very different from 100 msec of work, 10 msec of idle, 100 msec of
> work, even though utilization is the same.
> 
> what the logic is trying to do, on a 10 km level, is to limit the damage
> of accumulated C state exit time.
> (I'll avoid the word "latency" here, since the real time people will
> then immediately think this is about controlling latency response, which
> it isn't)
> 
> Now, if you're very idle for a sustained duration (e.g. low load),
> you're assumed not sensitive to a bit of performance cost.
> but if you're actually busy (over a longer period, not just "right
> now"), you're assumed to be sensitive to the performance cost,
> and what the algorithm does is make it less easy to go into the
> expensive states.
> 
> the closest metric we have right now to "sensitive to performance cost"
> that I know of is "load average". If the scheduler has a better metric,
> I'd be more than happy to switch the idle selection code over to it...
> 

But this_cpu_load(), which is currently used by cpuidle, does not return the "load average". It returns the value of cpuload at some moment in the past (actually, the value is updated in update_cpu_load()). This value is usually used for load balancing.

Moreover, this value does not reflect the real cpu load from the cpuidle pow, because it depends on tasks priority (nice) and, what is worse, with the introduction of cgroups it can be pretty arbitrary. For instance, each group of tasks is accounted just as a single task with standard priority "spreaded" among all cpus, no matter how many tasks are actually running in it.

> 
> note that the idle selection code has 3 metrics, this is only one of them:
> 1. PM_QOS latency tolerance
> 2. Energy break even
> 3. Performance tolerance
> 
> 

